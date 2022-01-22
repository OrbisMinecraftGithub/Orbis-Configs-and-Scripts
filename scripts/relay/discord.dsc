discord_events:
    type: world
    debug: false
    events:
        on server start:
        - discordconnect id:orbis tokenfile:discord.txt
        on discord message received:
        - if <context.new_message.text.starts_with[!]> && <context.new_message.author.roles[<context.group>].parse[id].contains[934514375849570324]> && !<context.new_message.author.is_bot>:
            - if <context.new_message.text.substring[2].split[<&sp>].get[1].to_lowercase> == parse:
                - define server <context.new_message.text.substring[2].split[<&sp>].exclude[<context.new_message.text.substring[2].split[<&sp>].get[1].to_lowercase>].get[1].if_null[null]>
                - if <[server]> == help:
                    - ~discordmessage id:orbis channel:<context.channel> "TODO"
                    - stop
                - if <bungee.list_servers.contains[<[server]>].not||true>:
                    - define server relay
                - define tag <context.new_message.text.substring[2].split[<&sp>].exclude[<context.new_message.text.substring[2].split[<&sp>].get[1].to_lowercase>].remove[1].space_separated.parsed>
                - ~bungeetag server:<[server]> <[tag].parsed> save:entry
                - ~discordmessage id:orbis channel:<context.channel> "<entry[entry].result>"