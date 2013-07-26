def Commands.klf(socket, nick, channel, args)
  site = TCPSocket.new "127.0.0.1", 8016
  site.print "GET / HTTP/1.0\n\n"
  lines = Array.new
  while line = site.gets
    lines.push line
  end
  site.close
  host = "mc.0xsilverfish.com"
  version = ""
  port = ""
  numPlayers = ""
  players = ""
  lines.each {|line|
    if line.include?("Version:")
      version = line[(line.index(':') + 2)..line.length].strip
    elsif line.include?("Port:")
      port = line[(line.index(':') + 2)..line.length].strip
    elsif line.include?("Num Players:")
      numPlayers = line[(line.index(':') + 2)..line.length].strip
    elsif %r{^Players:}.match(line) != nil
      players = line.strip
    end
  }
  tsputs "SEND: PRIVMSG #{channel} :Kerbel LiveFeed: #{host}:#{port} - v#{version} - #{numPlayers} - #{players}"
  socket.puts "PRIVMSG #{channel} :Kerbel LiveFeed: #{host}:#{port} - v#{version} - #{numPlayers} - #{players}"
end
  

