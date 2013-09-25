@@socket_mutex = Mutex.new
@@server = ""

#pong server
def pong (socket, server)
  tsputs "SEND: PONG #{server}"
  socket.puts "PONG #{server}"
end

def identified?(socket, nick)
  tsputs "SEND: PRIVMSG NickServ :info #{nick}"
  socket.puts "PRIVMSG NickServ :info #{nick}"
  nick_line = socket.gets.strip
  tsputs(nick_line)
  if %r{Nickname: #{nick} << ONLINE >>}.match(nick_line) != nil
    return true
  else
    tsputs "SEND: NOTICE #{nick} :Who are you? Go IDENTIFY with NickServ."
    socket.puts "NOTICE #{nick} :Who are you? Go IDENTIFY with NickServ."
    return false
  end
end


def irc(irc_socket)
  if defined?(SERVER_PASS)
    tsputs "SEND: PASS #{SERVER_PASS}"
    irc_socket.puts "PASS #{SERVER_PASS}"
  end
  tsputs "SEND: NICK #{NICKNAME}"
  irc_socket.puts "NICK #{NICKNAME}"
  tsputs "SEND: USER #{USERNAME} #{HOSTNAME} #{SERVERNAME} :#{REALNAME}"
  irc_socket.puts "USER #{USERNAME} #{HOSTNAME} #{SERVERNAME} :#{REALNAME}"

  #wait for auth to finish, join channels and identify upon server sending 001
  while line = irc_socket.gets
    tsputs line
    if line.include? "001"
      server_id = %r{:(.*) 001}.match(line)
      puts server_id
      @@server = server_id[1]
      identify irc_socket, NICKSERV_PASS
      INIT_CHANNELS.each {|chan| irc_socket.puts "JOIN #{chan}"}
      break
    end
  end

  rgen = Random.new(Time.now.nsec)

  #puts output and parses messages
  while line = @@socket_mutex.synchronize{irc_socket.gets.strip}
    tsputs line
    #if connection fails
    if %r{^ERROR :Closing Link:}.match(line) != nil
      irc_socket.puts "QUIT" #If you haveb't actually disconnected, you have now
      raise IOError, "Connection Error."
    end
    @last_ping = Time.now #used in spawner
    #listen for a respond to pings
    if %r{^PING}.match(line) != nil
      server = line.split(':')[1]
      pong irc_socket, server
      next
    end
    if %r{^:#{@@server}}.match(line) != nil #server message
      next
    elsif %r{^:\w+!~?\w+@[\w\.\-]+ PRIVMSG}.match(line) != nil #chat message
      #extract nick
      index = line.index(':') + 1
      end_index = line.index('!') - 1
      nick = line[index..end_index]
      #end
      #extract chan
      index = line.index("PRIVMSG") + 8
      chan = line[index..line.length]
      end_index = chan.index(' ') - 1
      chan = chan[0..end_index]
      #end
      # if chan == "#minecraft" #pipe to minecraft server
      #   index = line.index(':', 2) + 1
      #   message = line[index..line.length]
      #   message.tr!(%q("), %q('))
      #   if message.length > 100
      #     messages = Array.new
      #     while message.length > 100
      #       endIndex = message[0..99].rindex(' ')
      #       if endIndex == nil
      #         endIndex = 99
      #       end
      #       messages.push(message.slice!(0..endIndex))
      #     end
      #     messages.each {|msg| system(%Q(/home/ross/bin/mcrcon -H #{MC_HOST} -p #{MC_PASS} -P #{MC_PORT} "say <#{nick}> #{msg}"))}
      #     system(%Q(/home/ross/bin/mcrcon -H #{MC_HOST} -p #{MC_PASS} -P #{MC_PORT} "say <#{nick}> #{message}"))
      #   else
      #     system(%Q(/home/ross/bin/mcrcon -H #{MC_HOST} -p #{MC_PASS} -P #{MC_PORT} "say <#{nick}> #{message}"))
      #   end
      # end
      #listen for commands via command prefix char, PM, or mention
      if (linereg = %r{^:\w+!~?\w+@[\w\.\-]+ PRIVMSG #{chan} :#{RCOMMAND_PREFIX}(.*)}.match(line)) != nil \
        || (linereg = %r{^:\w+!~?\w+@[\w\.\-]+ PRIVMSG #{NICKNAME}\s*(.*):}.match(line)) != nil \
        || (linereg = %r{^:\w+!~?\w+@[\w\.\-]+ PRIVMSG #{chan} :#{NICKNAME}\W?\s*(.*)}.match(line)) != nil
        #extract command and args
        if chan == NICKNAME #is a PM
          chan = nick #respond with PM
          index = line.index(':', 2) + 1
          command = linereg[1]
          if command[0] == "\u0001" #CTCP
            command.delete!("\u0001")
            command_args = [command] #CTCP command
            command = "ctcp"
          end
          command_args = line[index..line.length].split(' ')
          if command != "ctcp"
            command_args.delete_at(0)
          end
        elsif line[line.index(':', 2) + 1] == COMMAND_PREFIX
          #extract command and args
          index = line.index(COMMAND_PREFIX) + 1
          command = linereg[1]
          command_args = line[index..line.length].split(' ')
          command_args.delete_at(0)
          #end
        else #mention
          if %r{\?$}.match(line) != nil #directed question
            if rgen.rand(2) == 1
              tsputs "SEND: PRIVMSG #{chan} :Yes."
              irc_socket.puts "PRIVMSG #{chan} :Yes."
            else
              tsputs "SEND: PRIVMSG #{chan} :No."
              irc_socket.puts "PRIVMSG #{chan} :No."
            end
            next
          end
          command = linereg[1]
          command.strip!
          command_args = command.split(' ')
          command_args.delete_at(0)
          command = command.split(' ')[0]
        end
        command.downcase! #case insensitivity
        if Commands.respond_to? command
          exec = true #because mutex are hard
          if AUTH_COMMANDS.include? command
            if !@@socket_mutex.synchronize{identified? irc_socket, nick} #have to do this here or else while loop will lock before the thread can
              exec = false
            end
          end
          if exec
            Thread.new{ #MAOR THREDZ MAOR BETTUR
              begin
                Commands.send(command, irc_socket, nick, chan, command_args)
              rescue => e
                puts e.message
                puts e.backtrace.inspect
              end
            }
          end
        else
          tsputs "SEND: NOTICE #{nick} :#{command} is not a valid command."
          irc_socket.puts "NOTICE #{nick} :#{command} is not a valid command."
        end
      end
    end
  end
end
