def Commands.lastwords(socket, nick, channel, args)
  require 'set'
  user = args[0].downcase
  death_types = Set.new ["#{user} was squashed by a falling anvil", "#{user} was pricked to death", "#{user} walked into a cactus whilst trying to escape", "#{user} was shot by arrow", "#{user} drowned", "#{user} blew up", "#{user} was blown up by", "#{user} hit the ground too hard", "#{user} fell off a ladder", "#{user} fell off some vines", "#{user} fell out of the water", "#{user} fell from a high place", "#{user} fell into a patch of fire", "#{user} fell into a patch of cacti", "#{user} was doomed to fall", "#{user} was shot off some vines by", "#{user} was shot off a ladder by", "#{user} was blown from a high place by", "#{user} went up in flames", "#{user} burned to death", "#{user} was burnt to a crisp whilst fighting", "#{user} walked into a fire whilst fighting", "#{user} was slain by", "#{user} was shot by", "#{user} was fireballed by", "#{user} was killed by", "#{user} got finished off by", "#{user} was slain by", "#{user} tried to swim in lava", "#{user} tried to swim in lava while trying to escape", "#{user} died", "#{user} got finished off by", "#{user} was slain by", "#{user} was shot by", "#{user} was killed by", "#{user} was killed by magic", "#{user} starved to death", "#{user} suffocated in a wall", "#{user} was killed while trying to hurt", "#{user} was pummeled by", "#{user} fell out of the world", "#{user} fell from a high place and fell out of the world", "#{user} was knocked into the void by", "#{user} withered away", "#{user} was sucked to the moon"]
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
              tsputs "SEND: PRIVMSG #{channel} :#{last_word} | #{death_message}"
              socket.puts "PRIVMSG #{channel} :#{last_word} | #{death_message}"
              return
            end
          }
          return
        end
      }
    end
  }
end
              




