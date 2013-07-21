#pong server
def pong (socket, server)
  tsputs "SEND: PONG #{server}"
  socket.puts "PONG #{server}"
end

def irc(irc_socket)

  tsputs "SEND: NICK silvrfish"
  irc_socket.puts "NICK silvrfish"
  tsputs "SEND: USER silvrfish silverfish.0xkohen.com * :silvrfish"
  irc_socket.puts "USER silvrfish silverfish.0xkohen.com * :silvrfish"

  #wait for auth to finish, join channels and identify upon server sending 001
  while line = irc_socket.gets
    tsputs line
    if line.include? "001"
      identify irc_socket, NICKSERV_PASS
      Commands.join irc_socket, AUTH_USERS[0], "null_channel", INIT_CHANNELS
      break
    end
  end

  #puts output and parses messages
  while line = irc_socket.gets.rstrip
    tsputs line
    #if connection fails
    if %r{^ERROR :Closing Link:}.match(line) != nil
      irc_socket.puts "QUIT" #If you haveb't actually disconnected, you have now
      raise IOError, "Connection Error."
    end
    #listen for a respond to pings
    if %r{^PING}.match(line) != nil
      server = line.split(':')[1]
      pong irc_socket, server
      next
    end
    if line.include?("PRIVMSG") #chat message
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
      if chan == "#minecraft" #pipe to minecraft server
        index = line.index(':', 2) + 1
        message = line[index..line.length]
        message.tr!(%q("), %q('))
        if message.length > 100
          messages = Array.new
          while message.length > 100
            endIndex = message[0..99].rindex(' ')
            if endIndex == nil
              endIndex = 99
            end
            messages.push(message.slice!(0..endIndex))
          end
          messages.each {|msg| system(%Q(/home/ross/bin/mcrcon -H #{MC_HOST} -p #{MC_PASS} -P #{MC_PORT} "say <#{nick}> #{msg}"))}
          system(%Q(/home/ross/bin/mcrcon -H #{MC_HOST} -p #{MC_PASS} -P #{MC_PORT} "say <#{nick}> #{message}"))
        else
          system(%Q(/home/ross/bin/mcrcon -H #{MC_HOST} -p #{MC_PASS} -P #{MC_PORT} "say <#{nick}> #{message}"))
        end
      end
      #listen for commands, regex to watch for line beginning with & or for PMs
      if %r{PRIVMSG #[[:alnum:]]+ :&}.match(line) != nil || %r{PRIVMSG [[:alnum:]]+ :}.match(line) != nil
        #extract command and args
        if chan == "silvrfish" #is a PM
          chan = nick #respond with PM
          index = line.index(':', 2) + 1
          command = line[index..line.length].split(' ')[0]
          if command[0] == '&' #delete escape char if used
            command.slice!(0)
          end
          command_args = line[index..line.length].split(' ')
          command_args.delete_at(0)
        else #find command escape char
          #extract command and args
          index = line.index('&') + 1
          command = line[index..line.length].split(' ')[0]
          command_args = line[index..line.length].split(' ')
          command_args.delete_at(0)
          #end
        end
        command.downcase! #case insensitivity
        if Commands.respond_to? command
          Thread.new{ #MAOR THREDZ MAOR BETTUR
            begin
              Commands.send(command, irc_socket, nick, chan, command_args)
            rescue => e
              puts e.message
            end
          }
        else
          tsputs "SEND: NOTICE #{nick} :#{command} is not a valid command."
          irc_socket.puts "NOTICE #{nick} :#{command} is not a valid command."
        end
      end
    end
  end
end
