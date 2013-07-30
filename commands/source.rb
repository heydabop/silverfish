def Commands.source(socket, nick, channel, args)
  if args.empty?
    tsputs "SEND: PRIVMSG #{channel} :https://github.com/heydabop/silverfish"
    socket.puts "PRIVMSG #{channel} :https://github.com/heydabop/silverfish"
  else
    file = args[0]
    if Commands.respond_to? file
      tsputs "SEND: PRIVMSG #{channel} :https://github.com/heydabop/silverfish/blob/master/commands/#{file}.rb"
      socket.puts "PRIVMSG #{channel} :https://github.com/heydabop/silverfish/blob/master/commands/#{file}.rb"
    else
      tsputs "SEND: PRIVMSG #{channel} :No source for #{file}, probably not a command."
      socket.puts "PRIVMSG #{channel} :No source for #{file}, probably not a command."
    end
  end
end
