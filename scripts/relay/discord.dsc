discord_events:
    type: world
    debug: false
    events:
        on server start:
        - discordconnect id:orbis tokenfile:discord.txt
        on discord message received:
        - if <context.message.starts_with[!]> && <context.author.roles[<context.group>].parse[id].contains[923373203924058164]> && !<context.author.is_bot>:
            - define message <context.message.substring[2]>
            - define cmd <[message].split[<&sp>].get[1].to_lowercase>
            - define args <[message].split[<&sp>].exclude[<[cmd]>]>
            - if <[cmd]> == parse:
                - define server <[args].get[1].if_null[null]>
                - if <bungee.list_servers.contains[<[server]>].not||true>:
                    - ~discordmessage id:orbis channel:<context.channel> "That server does not exist."
                    - stop
                - ~bungeetag server:<[server]> <[args].remove[1].space_separated> save:entry
                - ~discordmessage id:orbis channel:<context.channel> "<entry[entry].result>"