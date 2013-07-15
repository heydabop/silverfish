def Commands.dynmap(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #{channel} :https://mc.0xkohen.com/dynmap/"
  socket.puts "PRIVMSG #{channel} :https://mc.0xkohen.com/dynmap/"
end
