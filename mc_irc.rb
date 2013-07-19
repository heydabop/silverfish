def mc_irc irc
  tail_process = IO.popen "tail -n 0 -f #{SERVER_LOG}"
  $tail_pid = tail_process.pid #init in main.rb, used in spawner.rb
  while log_line = tail_process.readline.rstrip
    if %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] <\w+>}.match(log_line) != nil #chat message
      index = log_line.index('<') + 1
      endIndex = log_line.index('>')
      nick = log_line[index...endIndex]
      message = log_line[(endIndex+2)..log_line.length].rstrip
      tsputs "SEND: PRIVMSG #test :<#{nick}> #{message}"
      begin
        irc.puts "PRIVMSG #test :<#{nick}> #{message}"
      rescue IOError => e
        puts e.message
      end
    end
    if %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] User \w{,16} connecting}.match(log_line) != nil #join
      index = log_line.index(" [INFO] User ") + 13
      endIndex = log_line.index(" connecting ")
      nick = log_line[index...endIndex]
      tsputs "SEND: NOTICE #test :#{nick} has joined"
      begin
        irc.puts "NOTICE #test :#{nick} has joined"
      rescue IOError => e
        puts e.message
      end
    end
    if %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] \w{,16} lost connection}.match(log_line) != nil #quit
      index = log_line.index(" [INFO] ") + 8
      endIndex = log_line.index(" lost connection:")
      nick = log_line[index...endIndex]
      tsputs "SEND: NOTICE #test :#{nick} has disconnected"
      begin
        irc.puts "NOTICE #test :#{nick} has disconnected"
      rescue IOError => e
        puts e.message
      end
    end
  end
end

