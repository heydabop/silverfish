def Commands.dynmap(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #{channel} :https://0xsilverfish.com/dynmap/"
  socket.puts "PRIVMSG #{channel} :https://0xsilverfish.com/dynmap/"
end
