def mc_irc irc_socket
  death_types = Set.new ['\w{,16} was', '\w{,16} walked into a cactus whilst trying to escape', '\w{,16} drowned', '\w{,16} blew up', '\w{,16} hit the ground too hard', '\w{,16} fell', '\w{,16} went up in flames', '\w{,16} burned to death','\w{,16} walked into a fire whilst fighting', '\w{,16} got finished off by', '\w{,16} tried to swim in lava', '\w{,16} died', '\w{,16} starved to death', '\w{,16} suffocated in a wall', '\w{,16} withered away']  

  tail_process = IO.popen "tail -n 0 -f #{SERVER_LOG}"
  $tail_pid = tail_process.pid #init in main.rb, used in spawner.rb
  while log_line = tail_process.readline.strip
    if %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] \[Rcon\]}.match(log_line) != nil || %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] Rcon}.match(log_line) != nil #do nothing
    elsif (message = %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] (<\w{,16}>) (.*)}.match(log_line)) != nil #chat message
      nick = message[1]
      message = message[2].strip
      tsputs "SEND: PRIVMSG #minecraft :#{nick} #{message}"
      begin
        irc_socket.puts "PRIVMSG #minecraft :#{nick} #{message}"
      rescue IOError => e
        puts e.message
        puts e.backtrace.inspect
      end
    elsif (nick = %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] (\w{,16})\[/[.:0-9]*\] logged in with entity id}.match(log_line)) != nil #join
      nick = nick[1]
      tsputs "SEND: NOTICE #minecraft :#{nick} has joined"
      begin
        irc_socket.puts "NOTICE #minecraft :#{nick} has joined"
      rescue IOError => e
        puts e.message
        puts e.backtrace.inspect
      end
    elsif (nick = %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] (\w{,16}) lost connection}.match(log_line)) != nil #quit
      nick = nick[1]
      tsputs "SEND: NOTICE #minecraft :#{nick} has disconnected"
      begin
        irc_socket.puts "NOTICE #minecraft :#{nick} has disconnected"
      rescue IOError => e
        puts e.message
        puts e.backtrace.inspect
      end
    else
      puts death_types.size
      death_types.each {|death|
        if (message = %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] (#{death}.*)}.match(log_line)) != nil
         message = message[1].strip
         tsputs "SEND: NOTICE #minecraft :#{message}"
         begin
           irc_socket.puts "NOTICE #minecraft :#{message}"
         rescue IOError => e
           puts e.message
           puts e.backtrace.inspect
         end
         break
        end
      }
    end
  end
end

