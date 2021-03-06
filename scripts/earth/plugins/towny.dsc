towny_events:
    type: world
    debug: false
    events:
        on player kills player bukkit_priority:monitor:
        - define killed <context.entity>
        - define killer <context.damager>
        - flag <[killed]> stats.pvp.deaths:+:1
        - flag <[killer]> stats.pvp.kills:+:1
        - townymeta <[killed]> key:stats.pvp.deaths "label:PVP Deaths" value:<[killed].flag[stats.pvp.deaths]>
        - townymeta <[killer]> key:stats.pvp.kills "label:PVP Kills" value:<[killer].flag[stats.pvp.kills]>
        on resident teleports to town:
        - if <context.destination.has_town>:
            - if <context.destination.town.is_sieged||false> && <player.town.equals[<context.destination.town>].not||true>:
                - narrate "<&c>You cannot teleport to a besieged town."
                - determine cancelled
        on resident teleports to nation:
        - if <context.destination.has_town> && <context.destination.town.is_sieged||false> && <player.town.equals[<context.destination.town>].not||true>:
            - narrate "<&c>You cannot teleport to a besieged town."
            - determine cancelled
        on town toggles pvp:
        - ratelimit <context.town> 1t
        - if <context.pvp.not>:
            - stop
        - title targets:<context.town.plots.filter[players.exists].parse[players].combine.filter[has_flag[combat].not]> "title:<&c>PVP has been toggled!" "subtitle:You will lose protection in 10 seconds."
        - foreach <context.town.plots.filter[players.exists].parse[players].combine.filter[has_flag[combat].not]> as:p:
            - flag <[p]> pvp.protection.town.<context.town> expire:10s
        on plot toggles pvp:
        - ratelimit <context.chunk> 1t
        - if <context.pvp.not>:
            - stop
        - title targets:<context.chunk.players.filter[has_flag[combat].not]> "title:<&c>PVP has been toggled!" "subtitle:You will lose protection in 10 seconds."
        - foreach <context.chunk.players.filter[has_flag[combat].not]> as:p:
            - flag <[p]> pvp.protection.chunk.<context.chunk> expire:10s
