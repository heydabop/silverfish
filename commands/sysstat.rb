def Commands.sysstat(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #{channel} :http://0xsilverfish.com/graphs.html"
  socket.puts "PRIVMSG #{channel} :http://0xsilverfish.com/graphs.html"
end
