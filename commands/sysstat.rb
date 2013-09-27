def Commands.sysstat(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #{channel} :https://0xsilverfish.com/graphs.html"
  socket.puts "PRIVMSG #{channel} :https://0xsilverfish.com/graphs.html"
end
