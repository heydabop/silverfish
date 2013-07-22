def Commands.stop(socket, nick, channel, args)
  if AUTH_USERS.include?(nick) || nick == "pdbogen"
    if system(%Q(/home/ross/bin/mcrcon -H #{MC_HOST} -p #{MC_PASS} -P #{MC_PORT} stop)) != 1 #unresponsive, or down
      pinfo = `ps -C java -o pid,cmd | grep ftbserver.jar`
      pid = pinfo.split(' ')[0]
      system(%Q(kill #{pid}))
    end
  end
end
