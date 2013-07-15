def Irc.botsnack(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #minecraft :Fuck off. I don't even do anything yet. I don't need your sympathy."
  socket.puts "PRIVMSG #minecraft :Fuck off. I don't even do anything yet. I don't need your sympathy."
end
