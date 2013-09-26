def Commands.kick(socket, nick, channel, args)
  if AUTH_USERS.include?(nick)
    if channel == nick #IS PM, take channel as arg
      channel = args.delete_at(0)
    end
    for user in args
      tsputs "SEND: KICK #{channel} #{user} :Beep boop robot kick go"
      socket.puts "KICK #{channel} #{user} :Beep boop robot kick go"
    end
  else
    tsputs "SEND: NOTICE #{nick} :I don't have to listen to you! You're not my real father!"
    socket.puts "NOTICE #{nick} :I don't have to listen to you! You're not my real father!"
  end
end
