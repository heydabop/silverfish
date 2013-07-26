def Commands.info(socket, nick, channel, args)
  host = "mc.0xKohen.com"
  version = "FTB 1.0.1"
  list_out = %x[/home/ross/bin/mcrcon -H #{MC_HOST} -p #{MC_PASS} -P #{MC_PORT} list]
  midIndex = list_out.index("/")
  index = list_out.rindex(" ", midIndex)
  endIndex = list_out.index(" ", midIndex)
  numPlayers = list_out[index..endIndex].strip
  
  playerList = list_out[list_out.index(":")+1..list_out.length].strip
  
  motd = ""
  properties = File.new("/home/ross/ftb/server.properties")
  properties.each_line{|line|
    if line.include?("motd=")
      motd = line[line.index("=")+1..line.length].strip
      break
    end
  }
  
  message = ""
  if numPlayers[0] != "0"
    message = "#{host} (#{numPlayers}) - #{version} - MOTD: #{motd} - Players: #{playerList}"
  else
    message = "#{host} (#{numPlayers}) - #{version} - MOTD: #{motd}"
  end
    tsputs "SEND: PRIVMSG #{channel} :#{message}"
    socket.puts "PRIVMSG #{channel} :#{message}"
end
