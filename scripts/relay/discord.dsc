discord_events:
    type: world
    debug: false
    events:
        on server start:
        - discordconnect id:orbis tokenfile:discord.txt
        on discord message received:
        - if <context.new_message.text.starts_with[!]> && <context.new_message.author.roles[<context.group>].parse[id].contains[934514375849570324]> && !<context.new_message.author.is_bot>:
            - define message <context.new_message.text.substring[2]>
            - define cmd <[message].split[<&sp>].get[1].to_lowercase>
            - define args <[message].split[<&sp>].exclude[<[cmd]>]>
            - if <[cmd]> == ex:
                - define server <[args].get[1].if_null[<bungee.server>]>
                - define command <[args].remove[1].space_separated>
                - if <bungee.list_servers.contains[<[server]>].not||true>:
                    - ~discordmessage id:orbis channel:<context.channel> "<discord_embed[title=<[server]>;description=You must specify a server.]>"
                    - stop
                - bungee <[server]>:
                    - execute as_server "ex <[command]>"
                - ~discordmessage id:orbis channel:<context.channel> "<discord_embed[title=<[server]>;description=Command executed successfully.]>"
                - stop
            - if <[cmd]> == parse:
                - define server <[args].get[1].if_null[<bungee.server>]>
                - define tag <[args].remove[1].space_separated>
                - if <bungee.list_servers.contains[<[server]>].not||true>:
                    - define server <bungee.server>
                    - define tag <[args].space_separated>
                - if <[server]> != <bungee.server>:
                    - define time_now <server.current_time_millis>
                    - ~bungeetag server:<[server]> <[tag].parsed||null> save:entry
                    - define time_taken <server.current_time_millis.sub[<[time_now]>]>
                    - define result <entry[entry].result>
                - else:
                    - define time_now <server.current_time_millis>
                    - define result <[tag].parsed||null>
                    - define time_taken <server.current_time_millis.sub[<[time_now]>]>
                - if <[result]> == null:
                    - ~discordmessage id:orbis channel:<context.channel> "<discord_embed[title=<[server]>;description=This tag is invalid.]>"
                - else:
                    - narrate "title=<[server]>;footer=Time<&co> <[time_taken]> ms;description=<[result]>"
                    - ~discordmessage id:orbis channel:<context.channel> "<discord_embed[title=<[server]>;footer=Time<&co> <[time_taken]> ms;description=<[result]>]>"
