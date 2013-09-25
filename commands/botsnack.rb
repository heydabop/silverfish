def Commands.botsnack(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #{channel} :Stop that. I'm not even hungry."
  socket.puts "PRIVMSG #{channel} :Stop that. I'm not even hungry."
end
