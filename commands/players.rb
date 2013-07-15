def Irc.players(socket, nick, channel, args)
  players = %x[/home/ross/bin/mcrcon -H 127.0.0.1 -p rossroll1234 -P 20155 list]
  players.sub!(":", ": ")
  players.rstrip!
  tsputs "SEND: PRIVMSG #{channel} :#{players}"
  socket.puts "PRIVMSG #{channel} :#{players}"
end
