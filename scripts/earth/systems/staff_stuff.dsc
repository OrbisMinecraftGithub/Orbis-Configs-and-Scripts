command_gamemode_spectator:
    type: command
    name: spectator
    aliases:
    - gmsp
    debug: false
    script:
    - if <player.has_permission[spectator]> || <player.has_permission[minecraft.command.gamemode]>:
        - if <player.has_flag[staff.spectator]>:
            - adjust <player> gamemode:survival
            - narrate "<&e>You are now in survival."
            - teleport <player> <player.flag[staff.spectator].as_location>
            - flag <player> staff.spectator:!
        - else:
            - adjust <player> gamemode:spectator
            - narrate "<&e>You are now in spectator."
            - flag <player> staff.spectator:<player.location>
    - else:
        - narrate "<&c>You do not have permission for that command."

command_gamemode_creative:
    type: command
    name: creative
    aliases:
    - gmc
    debug: false
    script:
    - if <player.has_permission[creative]> || <player.has_permission[minecraft.command.gamemode]>:
        - adjust <player> gamemode:creative
        - narrate "<&e>You are now in creative."
    - else:
        - narrate "<&c>You do not have permission for that command."

command_gamemode_survival:
    type: command
    name: survival
    aliases:
    - gms
    debug: false
    script:
    - if <player.has_permission[survival]> || <player.has_permission[minecraft.command.gamemode]>:
        - adjust <player> gamemode:survival
        - narrate "<&e>You are now in survival."
    - else:
        - narrate "<&c>You do not have permission for that command."