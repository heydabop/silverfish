def Commands.players(socket, nick, channel, args)
  players = %x[/home/ross/bin/mcrcon -H #{MC_HOST} -p #{MC_PASS} -P #{MC_PORT} list]
  players.sub!(":", ": ")
  players.rstrip!
  tsputs "SEND: PRIVMSG #{channel} :#{players}"
  socket.puts "PRIVMSG #{channel} :#{players}"
end
