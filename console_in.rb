def console_in(irc_socket)
  while input = gets
    tsputs "SEND: #{input}"
    begin
      irc_socket.puts input
    rescue IOError => e
      puts e.message
      puts e.backtrace.inspect
    end
  end
end
