def mc_irc irc_socket
  tail_process = IO.popen "tail -n 0 -f #{SERVER_LOG}"
  $tail_pid = tail_process.pid #init in main.rb, used in spawner.rb
  while log_line = tail_process.readline.rstrip
    if %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] <\w+>}.match(log_line) != nil #chat message
      index = log_line.index('<') + 1
      endIndex = log_line.index('>')
      nick = log_line[index...endIndex]
      message = log_line[(endIndex+2)..log_line.length].rstrip
      tsputs "SEND: PRIVMSG #minecraft :<#{nick}> #{message}"
      begin
        irc_socket.puts "PRIVMSG #minecraft :<#{nick}> #{message}"
      rescue IOError => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
    if %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] \w{,16}\[/[.:0-9]*\] logged in with entity id}.match(log_line) != nil #join
      index = log_line.index(" [INFO] ") + 8
      endIndex = log_line.index("[/")
      nick = log_line[index...endIndex]
      tsputs "SEND: NOTICE #minecraft :#{nick} has joined"
      begin
        irc_socket.puts "NOTICE #minecraft :#{nick} has joined"
      rescue IOError => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
    if %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] \w{,16} lost connection}.match(log_line) != nil #quit
      index = log_line.index(" [INFO] ") + 8
      endIndex = log_line.index(" lost connection:")
      nick = log_line[index...endIndex]
      tsputs "SEND: NOTICE #minecraft :#{nick} has disconnected"
      begin
        irc_socket.puts "NOTICE #minecraft :#{nick} has disconnected"
      rescue IOError => e
        puts e.message
        puts e.backtrace.inspect
      end
    end
  end
end

