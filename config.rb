AUTH_USERS = ["heydabop"] #used to verify authority to run things like join, part, stop, start, etc.

INIT_CHANNELS = ["#minecraft"] #channels to join upon start

#NICKSERV_PASS = "" #password to pass to NickServ, defined in pass.rb
#SERVER_PASS = "" #password for server

#MC_PASS = "uka8Ohk6el" #rcon pass, used when calling mcrcon, defined in mcrcon.rb
#MC_HOST = "127.0.0.1" #rcon host
#MC_PORT = "20155" #rcon port

#BUG: If command_prefix is a special character in regexps, you're gonna have a bad time
#TEMPFIX: In the line below the comment "#listen for commands via command prefix char, PM, or mention"
#replace #{COMMAND_PREFIX} with \[prefix]. Example, if COMMAND_PREFIX = +, then #{COMMAND_PREFIX should be \+
COMMAND_PREFIX = '&' #prefix for commands used in channel

NICKNAME = "silvrfish" #IRC nick

#per RFC 1459 4.1.3
USERNAME = "silvrfish"
HOSTNAME = "home.0xsilverfish.com"
SERVERNAME = "*"
REALNAME = "silvrfish"

IRC_SERVER = "0xkohen.com"
IRC_PORT = 20158 #commonly 6667

SERVER_LOG = "/home/ross/ftb/server.log" #path to minecraft server log
