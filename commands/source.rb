def Commands.source(socket, nick, channel, args)
  if args.empty?
    tsputs "SEND: PRIVMSG #{channel} :https://github.com/heydabop/silverfish"
    socket.puts "PRIVMSG #{channel} :https://github.com/heydabop/silverfish"
  else
    file = args[0]
    tsputs "SEND: PRIVMSG #{channel} :https://github.com/heydabop/silverfish/blob/master/commands/#{file}.rb"
    socket.puts "PRIVMSG #{channel} :https://github.com/heydabop/silverfish/blob/master/commands/#{file}.rb"
  end
end
