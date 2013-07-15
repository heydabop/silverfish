def Irc.part(socket, nick, channel, args)
  if AUTH_USERS.include?(nick)
    for chan in args
      tsputs "SEND: PART #{chan}"
      socket.puts "PART #{chan}"
    end
  else
    tsputs "ERROR: User #{nick} not authorized to call #{__method__}."
  end
end
