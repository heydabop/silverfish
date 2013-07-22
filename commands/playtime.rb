def Commands.playtime(socket, nick, channel, args) #args[0] should be username
  require 'time' #expands core-time
  user = args[0]
  if user.length > 16
    raise("ERROR: Invalid username, length exceeds 16 characters.")
  end

  if /\W/.match(user) != nil #sanitize input, check for non-word characters
    raise("ERROR: Invalid username, contains non-word characters.")
  end
  
  seconds = 0
  minutes = 0
  hours = 0
  days = 0
  connected = false
  user = args[0]
  connectTime = Time.new
  disconnectTime = Time.new

  log = File.new(SERVER_LOG)
  log.each_line {|line|
    if !connected && %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] (?i:#{user})\[/[.:0-9]*\] logged in with entity id}.match(line) != nil
      connectTime = Time.parse(line[0...line.index(" [INFO] ")])
      connected = true
    elsif connected && %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] (?i:#{user}) lost connection}.match(line) != nil
      disconnectTime = Time.parse(line[0...line.index(" [INFO] ")])
      connected = false
      seconds += (disconnectTime - connectTime)
    end
  }
  if connected
    seconds += (Time.now - connectTime)
  end

  seconds = seconds.round
  if seconds > 60
    minutes = seconds / 60
    seconds = seconds % 60
  end
  if minutes > 60
    hours = minutes / 60
    minutes = minutes % 60
  end
  if hours > 24
    days = hours / 24
    hours = hours % 24
  end

  s_hours = hours.to_s.rjust(2, '0')
  s_minutes = minutes.to_s.rjust(2, '0')
  s_seconds = seconds.to_s.rjust(2, '0')
  if connected
    tsputs "SEND: PRIVMSG #{channel} :#{user}'s playtime: #{days} days: #{s_hours}:#{s_minutes}:#{s_seconds} and counting..."
    socket.puts "PRIVMSG #{channel} :#{user}'s playtime: #{days} days: #{s_hours}:#{s_minutes}:#{s_seconds} and counting..."
  else
    tsputs "SEND: PRIVMSG #{channel} :#{user}'s playtime: #{days} days: #{s_hours}:#{s_minutes}:#{s_seconds}"
    socket.puts "PRIVMSG #{channel} :#{user}'s playtime: #{days} days: #{s_hours}:#{s_minutes}:#{s_seconds}"
  end
end

  
  
