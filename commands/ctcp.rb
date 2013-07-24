def Commands.ctcp(socket, nick, channel, args) #args[0] is CTCP command
  command = args[0]
  case command
  when "CLIENTINFO"
    tsputs "SEND: NOTICE #{nick} :\u0001CLIENTINFO VERSION SOURCE USERINFO CLIENTINFO TIME FINGER\u0001"
    socket.puts "NOTICE #{nick} :\u0001CLIENTINFO VERSION SOURCE USERINFO CLIENTINFO TIME FINGER\u0001"
  when "VERSION"
    tsputs "SEND: NOTICE #{nick} :\u0001VERSION Heydabot Co. Silverfish Edition vALPHA -- #{`ruby --version`}\u0001"
    socket.puts "NOTICE #{nick} :\u0001VERSION Heydabot Co. Silverfish Edition vALPHA -- #{`ruby --version`}\u0001"
  when "SOURCE"
    tsputs "SEND: NOTICE #{nick} :\u0001SOURCE https://github.com/heydabop/silverfish\u0001"
    socket.puts "NOTICE #{nick} :\u0001SOURCE https://github.com/heydabop/silverfish\u0001"
  when "USERINFO"
    tsputs "SEND: NOTICE #{nick} :\u0001USERINFO #{USERNAME}\u0001"
    socket.puts "NOTICE #{nick} :\u0001USERINFO #{USERNAME}\u0001"
  when "TIME"
    tsputs "SEND: NOTICE #{nick} :\u0001TIME #{`date`}"
    socket.puts "NOTICE #{nick} :\u0001TIME #{`date`}"
  when "FINGER"
    tsputs "SEND: NOTICE #{nick} :\u0001FINGER #{REALNAME} (#{NICKNAME})  Idle NEVER"
    socket.puts "NOTICE #{nick} :\u0001FINGER #{REALNAME} (#{NICKNAME})  Idle NEVER"
  end
end
    
