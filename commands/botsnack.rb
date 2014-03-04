def Commands.botsnack(socket, nick, channel, args)
  if rand(2) == 1
    tsputs "SEND: PRIVMSG #{channel} :8)"
    socket.puts "PRIVMSG #{channel} :8)"
  else
    tsputs "SEND: PRIVMSG #{channel} :(8"
    socket.puts "PRIVMSG #{channel} :(8"
  end
end
