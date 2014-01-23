def Commands.platform(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #{channel} :http://www.technicpack.net/api/modpack/tehhardcraft-dev"
  socket.puts "PRIVMSG #{channel} :http://www.technicpack.net/api/modpack/tehhardcraft-dev"
end
