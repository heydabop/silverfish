def Irc.sla(socket, nick, channel, args)
  tsputs "SEND: PRIVMSG #minecraft :We here at heydatech pride ourselves on running via high quality third-party connections. If you have an issue with connectivity, you may open a support ticket by removing yourself from the whitelist."
  socket.puts "PRIVMSG #minecraft :We here at heydatech pride ourselves on running via high quality third-party connections. If you have an issue with connectivity, you may open a support ticket by removing yourself from the whitelist."
end
