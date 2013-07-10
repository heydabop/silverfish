def Irc.source socket
  tsputs "SEND: PRIVMSG #minecraft :https://github.com/heydabop/silverfish"
  socket.puts "PRIVMSG #minecraft :https://github.com/heydabop/silverfish"
end
