def Commands.sysstat(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #{channel} :https://0xsilverfish.com/sysstat.png"
  socket.puts "PRIVMSG #{channel} :https://0xsilverfish.com/sysstat.png"
end
