def Commands.klf(socket, nick, channel, args)
  html = Net::HTTP.get('127.0.0.1', '/', 8016)
  lines = html.split "\n"
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
  tsputs "SEND: PRIVMSG #{channel} :Kerbal LiveFeed: #{host}:#{port} - v#{version} - #{numPlayers} - #{players}"
  socket.puts "PRIVMSG #{channel} :Kerbal LiveFeed: #{host}:#{port} - v#{version} - #{numPlayers} - #{players}"
end
  

