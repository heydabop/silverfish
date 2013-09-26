def Commands.verbatim(socket, nick, channel, args)
  if AUTH_USERS.include?(nick)
    tsputs "SEND: #{args.join(' ')}"
    socket.puts args.join(' ')
  else
    tsputs "SEND: NOTICE #{nick} :I don't have to listen to you! You're not my real father!"
    socket.puts "NOTICE #{nick} :I don't have to listen to you! You're not my real father!"
  end
end
