def Commands.join(socket, nick, channel, args)
  if AUTH_USERS.include?(nick)
    for chan in args
      tsputs "SEND: JOIN #{chan}"
      socket.puts "JOIN #{chan}"
    end
  else
    tsputs "SEND: NOTICE #{nick} :I don't have to listen to you! You're not my real father!"
    socket.puts "NOTICE #{nick} :I don't have to listen to you! You're not my real father!"
  end
end
