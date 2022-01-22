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
                - define server <[args].get[1].if_null[null]>
                - define tag <[args].remove[1].space_separated>
                - if <bungee.list_servers.contains[<[server]>].not||true>:
                    - define server relay
                    - define tag <[args].space_separated>
                - announce <[tag]>
                - define tag <[tag].parsed.if_null[<[tag]>]>
                - announce <[tag]>
                - ~bungeetag server:<[server]> <[tag].parsed.if_null[null]> save:entry
                - announce <entry[entry].result>
                - ~discordmessage id:orbis channel:<context.channel> "<entry[entry].result>"