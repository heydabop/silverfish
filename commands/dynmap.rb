def Commands.dynmap(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #{channel} :http://0xsilverfish.com/dynmap_unleashed/"
  socket.puts "PRIVMSG #{channel} :http://0xsilverfish.com/dynmap_unleashed/"
end
