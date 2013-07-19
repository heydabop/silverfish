def console_in(irc)
  while input = gets
    tsputs "SEND: #{input}"
    begin
      irc.puts input
    rescue IOError => e
      puts e.message
    end
  end
end
