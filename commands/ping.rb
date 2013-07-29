def Commands.ping(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #{channel} :PONG"
  socket.puts "PRIVMSG #{channel} :PONG"
end
