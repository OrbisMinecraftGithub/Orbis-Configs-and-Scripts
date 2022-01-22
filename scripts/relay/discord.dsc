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
            - if <[cmd]> == parse:
                - define server <[args].get[1].if_null[relay]>
                - define tag <[args].remove[1].space_separated>
                - if <bungee.list_servers.contains[<[server]>].not||true>:
                    - define server relay
                    - define tag <[args].space_separated>
                - if <[server]> != <bungee.server>:
                    - define time_now <server.current_time_millis>
                    - ~bungeetag server:<[server]> <tern[<server.object_is_valid[<[tag].parsed>]>].pass[<[tag].parsed>].fail[null]> save:entry
                    - define time_taken <server.current_time_millis.sub[<[time_now]>]>
                    - define result <entry[entry].result>
                - else:
                    - if <server.object_is_valid[<[tag].parsed>]>:
                        - define time_now <server.current_time_millis>
                        - define result <[tag].parsed>
                        - define time_taken <server.current_time_millis.sub[<[time_now]>]>
                    - else:
                        - define result null
                - if <[result]> == null:
                    - ~discordmessage id:orbis channel:<context.channel> "<discord_embed[title=<[server]>;description=This tag is invalid]>"
                - else:
                    - ~discordmessage id:orbis channel:<context.channel> "<discord_embed[title=<[server]>;footer=Time<&co> <[time_taken]> ms;description=<[result]>]>"