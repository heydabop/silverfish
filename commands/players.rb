def Irc.players socket
  players = %x[/home/ross/bin/mcrcon -H 127.0.0.1 -p rossroll1234 -P 20155 list]
  players.sub!(":", ": ")
  players.rstrip!
  tsputs "SEND: PRIVMSG #minecraft :#{players}"
  socket.puts "PRIVMSG #minecraft :#{players}"
end