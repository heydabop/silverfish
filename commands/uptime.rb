def Commands.uptime(socket, nick, channel, args)
  result = `uptime`
  tsputs "SEND: PRIVMSG #{channel} :#{result}"
  socket.puts "PRIVMSG #{channel} :#{result}"
end
