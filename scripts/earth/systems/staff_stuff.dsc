command_gamemode_spectator:
    type: command
    name: spectator
    debug: false
    script:
    - if <player.has_permission[spectator].not>:
        - narrate "<&c>You do not have permission for that command."
        - stop
    - if <player.has_flag[staff.spectator]>:
        - adjust <player> gamemode:survival
        - narrate "<&e>You are now in survival."
        - teleport <player> <player.flag[staff.spectator].as_location>
        - flag <player> staff.spectator:!
    - else:
        - adjust <player> gamemode:spectator
        - narrate "<&e>You are now in spectator."
        - flag <player> staff.spectator:<player.location>
