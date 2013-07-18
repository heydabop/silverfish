def Commands.whereami(socket, nick, channel, args)
  cmdout = `ps aux | grep irc.rb`
  cmdout = cmdout.split("\n")
  pid = ""
  addr = ""
  cmdout.each_index {|i|
    if %r{ruby \./irc.rb}.match(cmdout[i]) != nil
      pid = cmdout[i]
      break
    end
  }
  pid.slice!(0...pid.index(' '))
  pid.lstrip!
  pid.slice!(pid.index(' ')..pid.length)
  pmapout = `pmap #{pid}`
  pmaparr = pmapout.split("\n")
  pmaparr.each_index {|i|
    if %r{\[ stack \]}.match(pmaparr[i]) != nil
      addr = pmaparr[i]
      break
    end
  }
  addr.slice!(addr.index(' ')..addr.length)
  tsputs "SEND: PRIVMSG #{channel} :0x#{addr}"
  socket.puts "PRIVMSG #{channel} :0x#{addr}"
end
