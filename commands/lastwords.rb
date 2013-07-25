def Commands.lastwords(socket, nick, channel, args)
  require 'set'
  require 'time'

=begin
  class DeathInfo
    def initialize(death, word, ti)
      @death_message = death
      @last_word = word
      @time = ti
    end
    def death_message
      return @death_message
    end
    def last_word
      return @last_word
    end
    def time
      return @time
    end
  end
=end

  deathInfo = Struct.new(:last_word, :time, :death_message)
  deaths = Array.new

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
          puts line
          index = line.downcase.index(user)
          death_message = line[index..line.length].strip
          chat_lines = lines[x..lines.length]
          chat_lines.each {|chat|
            if %r{^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \[INFO\] <(?i:#{user})>}.match(chat) != nil
              puts chat
              index = chat.index('<')
              last_word = chat[index..chat.length].strip

              chat_time = Time.parse(chat[0...chat.index(" [INFO] ")])
              death_time = Time.parse(line[0...chat.index(" [INFO] ")])
              seconds = death_time - chat_time
              minutes = 0
              hours = 0
              if seconds > 60
                minutes = seconds / 60
              end
              if minutes > 60
                hours = minutes / 60
              end
              seconds = seconds.round
              minutes = minutes.round
              hours = hours.round
              time = ""
              if minutes == 0 && hours == 0
                if seconds == 1
                  time = "1 second"
                else
                  time = "#{seconds} seconds"
                end
              elsif hours == 0
                if minutes == 1
                  time = "1 minute"
                else
                  time = "#{minutes} minutes"
                end
              else
                if hours == 1
                  time = "1 hour"
                else
                  time = "#{hours} hours"
                end
              end
              
              deaths.push(deathInfo.new(last_word, time, death_message))
              break
            end
          }
        end
      }
    end
  }

  death = deaths.sample
  tsputs "SEND: PRIVMSG #{channel} :#{death.last_word} | About #{death.time} later, #{death.death_message}"
  socket.puts "PRIVMSG #{channel} :#{death.last_word} | About #{death.time} later, #{death.death_message}"
end
              




