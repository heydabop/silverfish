def Commands.chanstats(socket, nick, channel, args)
  if channel[0] != '#' #PM
    tsputs "SEND: PRIVMSG #{channel} :This isn't a channel."
    socket.puts "PRIVMSG #{channel} :This isn't a channel."
    return
  end
  chanurl = channel[1..channel.length]
  tsputs "SEND: PRIVMSG #{channel} :http://0xsilverfish.com/irc/#{chanurl}/"  
  socket.puts "PRIVMSG #{channel} :http://0xsilverfish.com/irc/#{chanurl}/"
end
