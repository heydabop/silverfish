def Commands.restart(socket, nick, channel, args)
  if AUTH_USERS.include?(nick) || nick == "pdbogen"
    Commands.stop(socket, nick, channel, args)
    Commands.start(socket, nick, channel, args)
  end
end
