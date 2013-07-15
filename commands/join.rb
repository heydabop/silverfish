def Irc.join(socket, nick, channel, args)
  if AUTH_USERS.include?(nick)
    for chan in args
      tsputs "SEND: JOIN #{chan}"
      socket.puts "JOIN #{chan}"
    end
  else
    tsputs "ERROR: User #{nick} not authorized to call #{__method__}."
  end
end
