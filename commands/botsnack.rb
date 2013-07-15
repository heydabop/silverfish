def Commands.botsnack(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #{channel} :Fuck off. I don't even do anything yet. I don't need your sympathy."
  socket.puts "PRIVMSG #{channel} :Fuck off. I don't even do anything yet. I don't need your sympathy."
end
