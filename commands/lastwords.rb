def Commands.lastwords(socket, nick, channel, args)
  deathInfo = Struct.new(:last_word, :death_message)
  deaths = Array.new

  user = args[0].downcase
  death_types = Set.new ["#{user} was", "#{user} walked into a cactus whilst trying to escape", "#{user} drowned", "#{user} blew up", "#{user} hit the ground too hard", "#{user} fell", "#{user} went up in flames", "#{user} burned to death","#{user} walked into a fire whilst fighting", "#{user} got finished off by", "#{user} tried to swim in lava", "#{user} died", "#{user} starved to death", "#{user} suffocated in a wall", "#{user} withered away"]
  lines = Array.new
  log = File.new(SERVER_LOG)
  log.each_line {|line| lines.push(line)}
  lines.reverse!
  lines.each_index {|x|
    line = lines[x]
    if %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] \w+}.match(line) != nil #not a chat message
      death_types.each {|death|
        if line.downcase.include? death #death message
          index = line.downcase.index(user)
          death_message = line[index..line.length].strip
          chat_lines = lines[x..lines.length]
          chat_lines.each {|chat|
            if %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] <(?i:#{user})>}.match(chat) != nil
              index = chat.index('<')
              last_word = chat[index..chat.length].strip

              deaths.push(deathInfo.new(last_word, death_message))
              break
            end
          }
        end
      }
    end
  }

  death = deaths.sample
  tsputs "SEND: PRIVMSG #{channel} :#{death.last_word} | #{death.death_message}"
  socket.puts "PRIVMSG #{channel} :#{death.last_word} | #{death.death_message}"
end
              




