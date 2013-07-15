def Irc.testing(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #minecraft :I don't always test my code. But when I do it's in production."
  socket.puts "PRIVMSG #minecraft :I don't always test my code. But when I do it's in production."
end
