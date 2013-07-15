def Irc.dynmap(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #minecraft :https://mc.0xkohen.com/dynmap/"
  socket.puts "PRIVMSG #minecraft :https://mc.0xkohen.com/dynmap/"
end
