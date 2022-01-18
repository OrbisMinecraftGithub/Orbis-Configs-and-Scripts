command_towny_flight:
    type: command
    debug: false
    name: townyflight
    aliases:
    - tflight
    - townyfly
    - tfly
    script:
    - if <player.has_permission[towny_flight.command]>:
        - if <player.has_flag[towny_flight]>:
            - run towny_flight_player_disable def:<player>
        - else:
            - if <player.location.town||null1> == <player.town||null2>:
                - run towny_flight_player_enable def:<player>
            - else:
                - narrate "<&c>You can only activate towny flight in your towns claim."
    - else:
        - narrate "<&c>You do not have permission for that command."

towny_flight_events:
    type: world
    debug: false
    events:
        on towny player exits town:
        - if <player.has_flag[towny_flight]>:
            - run towny_flight_player_warning def:<player>
        after player respawns:
        - if <player.has_flag[towny_flight]> && <context.location.town||null1> != <player.town||null2>:
            - run towny_flight_player_warning def:<player>

towny_flight_player_warning:
    type: task
    definitions: player
    debug: false
    script:
    - ratelimit 59t <[player]>
    - adjust <queue> linked_player:<[player]>
    - narrate "<&c>You have left your towns claim; turn back, or you will stop flying."
    - wait 3s
    - if <player.location.town||null1> != <player.town||null2>:
        - run towny_flight_player_disable def:<player>
        - flag <player> no_fall
        - waituntil <player.location.below[0.5].material.is_solid||true>
        - wait 1s
        - flag <player> no_fall:!

towny_flight_player_enable:
    type: task
    definitions: player
    debug: false
    script:
    - if !<[player].is_truthy> || !<[player].object_type> != Player:
        - stop
    - adjust <queue> linked_player:<[player]>
    - flag <player> towny_flight
    - adjust <player> can_fly:true
    - narrate "<&e>You have <&a>activated <&e>towny flight."

towny_flight_player_disable:
    type: task
    definitions: player
    debug: false
    script:
    - if !<[player].is_truthy> || !<[player].object_type> != Player:
        - stop
    - adjust <queue> linked_player:<[player]>
    - flag <player> towny_flight:!
    - adjust <player> can_fly:false
    - narrate "<&e>You have <&c>deactivated <&e>towny flight."