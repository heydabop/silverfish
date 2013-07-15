def Irc.source(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #{channel} :https://github.com/heydabop/silverfish"
  socket.puts "PRIVMSG #{channel} :https://github.com/heydabop/silverfish"
end
