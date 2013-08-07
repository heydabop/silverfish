def Commands.quit(socket, nick, channel, args)
  if AUTH_USERS.include? nick
    raise SystemExit
  else
    tsputs "SEND: NOTICE #{nick} :Nice try..."
    socket.puts "NOTICE #{nick} :Nice try..."
  end
end
  
