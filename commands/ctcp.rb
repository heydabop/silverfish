def Commands.ctcp(socket, nick, channel, args) #args[0] is CTCP command
  args[0].delete!("\u0001")
  args[args.length-1].delete!("\u0001")

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
    tsputs "SEND: NOTICE #{nick} :\u0001TIME #{`date`}\u0001"
    socket.puts "NOTICE #{nick} :\u0001TIME #{`date`}\u0001"
  when "FINGER"
    tsputs "SEND: NOTICE #{nick} :\u0001FINGER #{REALNAME} (#{NICKNAME})  Idle NEVER\u0001"
    socket.puts "NOTICE #{nick} :\u0001FINGER #{REALNAME} (#{NICKNAME})  Idle NEVER\u0001"
  when "BOTINFO"
    tsputs "SEND: NOTICE #{nick} :\u0001BOTINFO Definitely a fleshy human over here. No metal. Can I have a hamburger?\u0001"
    socket.puts "NOTICE #{nick} :\u0001BOTINFO Definitely a fleshy human over here. No metal. Can I have a hamburger?\u0001"
  when "PING"
    message = ""
    args.each {|arg|
      message = "#{message}#{arg} "
    }
    tsputs "SEND: NOTICE #{nick} :\u0001#{message.strip}\u0001"
    socket.puts "NOTICE #{nick} :\u0001#{message.strip}\u0001"
  end
end
    
