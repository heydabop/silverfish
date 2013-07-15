def Irc.testing(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #{channel} :I don't always test my code. But when I do it's in production."
  socket.puts "PRIVMSG #{channel} :I don't always test my code. But when I do it's in production."
end
