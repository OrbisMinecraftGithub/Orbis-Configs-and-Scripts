towny_events:
    type: world
    debug: false
    events:
        on resident teleports to town:
        - if <context.destination.has_town>:
            - if <context.destination.town.is_sieged> && <player.town.equals[<context.destination.town>].not||true>:
                - narrate "<&c>You cannot teleport to a besieged town."
                - determine cancelled
        on resident teleports to nation:
        - if <context.destination.has_town> && <context.destination.town.is_sieged> && <player.town.equals[<context.destination.town>].not||true>:
                - narrate "<&c>You cannot teleport to a besieged town."
                - determine cancelled