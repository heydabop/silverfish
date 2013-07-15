def Irc.source(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #minecraft :https://github.com/heydabop/silverfish"
  socket.puts "PRIVMSG #minecraft :https://github.com/heydabop/silverfish"
end
