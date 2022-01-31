flag_handlers:
    type: world
    debug: false
    events:
        on player dies:
        - flag <player> death_location:<player.location>
        on player damaged by suffocation flagged:no_suffocate:
        - determine cancelled
        on player killed by fall flagged:no_fall:
        - determine cancelled
        on player damaged by fall flagged:no_fall:
        - determine cancelled
        on player killed flagged:no_damage:
        - determine cancelled
        on player damaged flagged:no_damage:
        - determine cancelled
        on player damaged flagged:damage_zero:
        - determine 0.0
        on player damages player bukkit_priority:monitor ignorecancelled:true:
        - if <context.entity.has_flag[no_pvp_damage]> || <context.damager.has_flag[no_pvp_damage]>:
            - determine cancelled
        on entity damages entity bukkit_priority:monitor ignorecancelled:true:
        - if <context.entity.has_flag[no_pvp_damage]> || <context.damager.has_flag[no_pvp_damage]>:
            - if <context.entity.is_player> && <context.damager.is_player>:
                - determine cancelled
        - if <context.entity.has_flag[no_damage]>:
            - determine cancelled
        - if <context.entity.has_flag[damage_zero]>:
            - determine 0.0
        on player jumps flagged:no_jump:
        - determine cancelled
        on player jumps flagged:no_move:
        - determine cancelled
        on entity knocks back entity flagged:no_move:
        - determine cancelled
        on entity knocks back entity flagged:no_knockback:
        - determine cancelled
        on player walks flagged:no_move:
        - determine cancelled
        on player joins flagged:vanish:
        - determine NONE
        on player quit flagged:vanish:
        - determine NONE

no_slash_op:
    type: world
    debug: false
    events:
        on command:
        - if <context.command> == op && <context.source_type> != SERVER:
            - narrate no
            - determine passively cancelled
