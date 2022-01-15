fake_armor_toggle:
    type: command
    name: fake_armor_toggle
    debug: false
    usage: /fake_armor_toggle
    description: toggles relative colored armor for war
    script:
    - narrate "<&c>Sorry, this is currently disabled."
    - stop
    - if <player.has_flag[playersettings.relative_armor_color.enabled]>:
        - flag player playersettings.relative_armor_color.enabled:!
        - run fake_armor_task_off
        - narrate "<&e>You are no longer seeing armor colors relative to your relationship."
    - else:
        - flag player playersettings.relative_armor_color.enabled
        - run fake_armor_task_on
        - narrate "<&e>You are now seeing armor colors relative to your relationship."

fake_armor_update_self:
  type: task
  debug: false
  script:
  - if <player.nation.exists>:
    - define enemies <player.nation.enemies.parse[residents].combine.filter[is_online].filter[has_flag[playersettings.relative_armor_color.enabled]]>
    - define allies <player.nation.allies.parse[residents].combine.filter[is_online].filter[has_flag[playersettings.relative_armor_color.enabled]]>
    - foreach <player.equipment_map> key:slot as:value:
      - if <[value].material.name> != air:
        - if !<[enemies].is_empty>:
          - fakeequip <player> for:<[enemies]> <[slot]>:leather_<[slot]>[color=<color[red]>]
        - if !<[allies].is_empty>:
          - fakeequip <player> for:<[allies]> <[slot]>:leather_<[slot]>[color=<color[#00c8ff]>]

fake_armor_task_off:
    type: task
    debug: false
    script:
    - if <player.nation.exists>:
        - define enemies <player.nation.enemies.parse[residents].combine.filter[is_online].combine>
        - define allies <player.nation.allies.parse[residents].combine.filter[is_online].combine>
        - if !<[allies].include[<[enemies]>].is_empty>:
            - fakeequip <[allies].include[<[enemies]>]> for:<player> reset

fake_armor_task_on:
    type: task
    debug: false
    script:
    - if <player.nation.exists>:
        - define enemies <player.nation.enemies.parse[residents].combine.filter[is_online]>
        - define allies <player.nation.allies.parse[residents].combine.filter[is_online]>
        - if !<[enemies].is_empty>:
            - foreach <[enemies]> as:target:
                - foreach <[target].equipment_map> key:slot as:value:
                    - if <[value].material.name> != air:
                        - fakeequip <[target]> for:<player> <[slot]>:leather_<[slot]>[color=<color[red]>]
        - wait 1t
        - if !<[allies].is_empty>:
            - foreach <[allies]> as:target:
                - foreach <[target].equipment_map> key:slot as:value:
                    - if <[value].material.name> != air:
                        - fakeequip <[target]> for:<player> <[slot]>:leather_<[slot]>[color=<color[#00c8ff]>]
        - wait 1t
        - wait 1t
        - run fake_armor_update_self

fake_armor_events:
    type: world
    debug: false
    config:
        playersettings:
            relative_armor_color:
                enemy: red
                ally: <&ns>00c8ff
                enabled: true
    events:
        after player logs in flagged:playersettings.relative_armor_color.enabled server_flagged:bork:
        - run fake_armor_task_on
        on player equips|unequips armor server_flagged:bork:
        - run fake_armor_update_self


command_pvp_off:
    type: command
    name: pvpoff
    debug: false
    script:
    - flag <player> no_pvp_damage:!
    - flag <player> no_damage:!
    - narrate "You do not have PvP protection."

run_combat_check_low:
    type: task
    debug: false
    script:
    - if <[attacker]> == <[victim]>:
        - stop
    - if !<[attacker].is_player> || !<[victim].is_player>:
        - stop
    - if <[attacker].vehicle.entity_type.equals[ARMOR_STAND]||false>:
        - determine cancelled
    - if <[attacker].has_flag[no_damage]> || <[attacker].has_flag[no_pvp_damage]>:
        - determine cancelled
    - if <[attacker].mcmmo.party.equals[<[victim].mcmmo.party||>]||false>:
        - determine cancelled
    # - if <[attacker].inventory.list_contents.filter[material.name.equals[air].not].size.equals[0]> || <[victim].inventory.list_contents.filter[material.name.equals[air].not].size.equals[0]>:
    #     - determine cancelled
    - if <[victim].has_flag[pvp.protection.chunk.<[victim].location.chunk>]>:
        - determine cancelled
    - if <[victim].has_flag[pvp.protection.town.<[victim].location.town||>]>:
        - determine cancelled
    - if <[attacker].town.name||null1> == <[victim].town.name||null2>:
        - determine cancelled
    - if <[attacker].nation.name||null1> == <[victim].nation.name||null2>:
        - determine cancelled

run_combat_check_high:
    type: task
    debug: false
    script:
    - if <[attacker]> == <[victim]>:
        - stop
    - if !<[attacker].is_player> || !<[victim].is_player>:
        - stop
    - if <[attacker].location.is_siege_zone.exists> && <[victim].location.is_siege_zone.exists>:
        - if <[attacker].location.is_siege_zone||false> && <[victim].location.is_siege_zone||false>:
            - determine passively cancelled:false
    - if <[attacker].location.town.pvp||false> && <[victim].location.town.pvp||false>:
        - determine passively cancelled:false
    - if <[attacker].location.chunk.pvp||false> && <[victim].location.chunk.pvp||false>:
        - determine passively cancelled:false
    - if <[victim].has_flag[combat]||false>:
        - determine passively cancelled:false
    - if <[victim].has_flag[combat]||false> && !<[attacker].has_flag[combat]>:
        - if !<[victim].location.town.pvp||false> && !<[attacker].location.town.pvp||false>:
            - determine passively cancelled

run_combat_check_monitor:
    type: task
    debug: false
    script:
    - if <[attacker]> == <[victim]>:
        - stop
    - if !<[attacker].is_player> || !<[victim].is_player>:
        - stop
    - if <context.cancelled.not>:
        - if !<[attacker].has_flag[combat]>:
            - narrate "<&b>You are now in combat!" targets:<list[<[attacker]>]>
            - runlater player_leaves_combat def:<[attacker]> delay:46s
        - if !<[victim].has_flag[combat]>:
            - narrate "<&b>You are now in combat!" targets:<list[<[victim]>]>
            - runlater player_leaves_combat def:<[victim]> delay:46s
        - flag <[attacker]> combat:true expire:45s
        - flag <[victim]> combat:true expire:45s
        - if <[attacker].has_flag[combat]>:
            - if !<server.current_bossbars.contains[combat_time<[attacker].uuid>]>:
                - bossbar combat_time<[attacker].uuid> players:<[attacker]> "title:<&c>You are now in combat." color:RED
        - if <[victim].has_flag[combat]>:
            - if !<server.current_bossbars.contains[combat_time<[victim].uuid>]>:
                - bossbar combat_time<[victim].uuid> players:<[victim]> "title:<&c>You are now in combat." color:RED
#        - if <[yes]||false> && <context.weapon||null> != null:
#            - determine passively cancelled
#            - define damage <proc[calculate_damage].context[<[attacker]>|<[victim]>|<yaml[guns].read[<context.weapon>.Shooting.Projectile_Damage]>]>
#            - hurt <[victim]> <[damage]>

ttestt_events:
    type: world
    debug: false
    events:
        on server start:
        - yaml id:guns load:../CrackShot/weapons/Default_CS_Weapons.yml
        on reload scripts:
        - yaml id:guns load:../CrackShot/weapons/Default_CS_Weapons.yml

calculate_damage:
    type: procedure
    debug: false
    definitions: damager|damaged|damage|type
    script:
    - define defence_points <[damaged].armor_bonus>
    - define weapon_damage <[damage]>
    - define armor_toughness 1
    - foreach <[damaged].equipment.filter[material.name.equals[air].not]>:
        - if <[value].material.name.starts_with[diamond]>:
            - define armor_toughness:+:2
        - if <[value].material.name.starts_with[netherite]>:
            - define armor_toughness:+:3
    - define damage1 <[defence_points].div[5]>
    - define damage2 <[weapon_damage].mul[4].div[<[armor_toughness].add[8]>].sub[<[defence_points]>]>
    - define final <[weapon_damage].mul[<element[1].sub[<element[20].min[<[damage1].max[<[damage2]>]>].div[25]>]>]>
    - define final <[final].mul[0.5]>
    - determine <[final]>

# calculate_damage:
#     type: procedure
#     debug: false
#     definitions: damager|damaged|damage|type
#     script:
#     - define armor:<[damaged].armor_bonus>
#     - define damage_modifier:1
#     - define defence_modifier:1
#     - if <[damager].object_type> == player:
#         - define damage_modifier:<yaml[player.<[damager].uuid>].read[stats.damage_modifier.<[type]>]||1>
#     - else if <[damager].object_type> == entity:
#         - if <[damager].script||null> != null:
#             - define damage_modifier:<[damager].script.data_key[custom.damage_modifier.<[type]>]||1>
#     - if <[damaged].object_type> == player:
#         - define defence_modifier:<yaml[player.<[damaged].uuid>].read[stats.defence_modifier.<[type]>]||1>
#     - else if <[damaged].object_type> == entity:
#         - if <[damaged].script||null> != null:
#             - define defence_modifier:<[damaged].script.data_key[custom.defence_modifier.<[type]>]||1>
#     - define damage:<[damage].mul[<[damage_modifier]>].div[<[defence_modifier]>]>
#     - define final_damage:<[damage].mul[<element[1].sub[<element[20].mul[<[armor].div[5]>].div[25]>]>]>
#     - if <[final_damage]> < 0.5:
#         - define final_damage:0.5
#     - determine <[final_damage]>

combat_log_events:
    type: world
    debug: false
    config:
        defaults:
            combat_tag:
                blocked_commands:
                - t spawn
                - n spawn
                - res spawn
    events:
        on player teleports to nation spawn:
        - if <player.has_flag[combat]>:
            - narrate "<&c>You cannot teleport while in combat."
            - determine cancelled
        on player teleports to town spawn:
        - if <player.has_flag[combat]>:
            - narrate "<&c>You cannot teleport while in combat."
            - determine cancelled
        on entity teleports:
        - if <context.entity.has_flag[combat]> && <context.destination.distance[<context.origin>].is_more_than[100]>:
            - determine cancelled
        on entity spawns:
        - if <context.entity.entity_type.equals[ENDER_PEARL].not>:
            - stop
        - wait 10s
        - if <context.entity.is_spawned>:
            - remove <context.entity>
        on player death:
        - flag <player> combat:!
        - determine passively no_message
        - run player_leaves_combat defmap:<map[player=<player>]>
        on crackshot weapon damages entity ignorecancelled:true bukkit_priority:lowest:
        - if <context.damage.is_less_than[0.5]>:
            - determine 0.5
        on crackshot weapon damages entity ignorecancelled:false bukkit_priority:low:
        - define victim <context.victim>
        - define attacker <player>
        - define weapon <context.weapon>
        - inject run_combat_check_low
        on entity damages entity ignorecancelled:false bukkit_priority:low:
        - define victim <context.entity>
        - define attacker <context.damager>
        - inject run_combat_check_low
        on crackshot weapon damages entity ignorecancelled:true bukkit_priority:high:
        - define victim <context.victim>
        - define attacker <player>
        - define weapon <context.weapon>
        - inject run_combat_check_high
        on entity damages entity ignorecancelled:true bukkit_priority:high:
        - define victim <context.entity>
        - define attacker <context.damager>
        - inject run_combat_check_high
        # on crackshot weapon damages entity bukkit_priority:monitor:
        # - define victim <context.victim>
        # - define attacker <player>
        # - define weapon <context.weapon>
        # - inject run_combat_check_monitor
        on entity damages entity bukkit_priority:monitor:
        - define victim <context.entity>
        - define attacker <context.damager>
        - inject run_combat_check_monitor
        on player quits:
        - if <player.has_flag[combat]>:
            - flag <player> kill_on_login
            - drop <player.inventory.list_contents> <player.location>
            - inventory clear d:<player.inventory>
            - determine passively "<&c><player.name> logged out in combat."
        on player join:
        - if <player.has_flag[kill_on_login]> && <server.has_flag[safety].not>:
            - adjust <player> health:0
            - flag <player> kill_on_login:!
            - determine passively "<&c><player.name> died from combat logging."
        on player respawns:
        - flag <player> combat:!
        on delta time secondly every:3:
        - foreach <server.online_players.filter[has_flag[combat].is[==].to[false]]||<list[]>> as:p:
            - if <server.current_bossbars.contains[combat_time<[p].uuid>]>:
                - bossbar remove combat_time<[p].uuid> players:<[p]>
        - foreach <server.online_players.filter[has_flag[combat]]||<list[]>> as:p:
            - if <server.current_bossbars.contains[combat_time<[p].uuid>]>:
                - bossbar update combat_time<[p].uuid> players:<[p]> "title:<&f>Combat Time Remaining<&co> <&c><[p].flag_expiration[combat].from_now.formatted_words>" progress:<[p].flag_expiration[combat].from_now.in_ticks.div[<duration[45s].in_ticks>]> color:RED
            - else:
                - bossbar creates combat_time<[p].uuid> players:<[p]> "title:<&f>Combat Time Remaining<&co> <&c><[p].flag_expiration[combat].from_now.formatted_words>" progress:<[p].flag_expiration[combat].from_now.in_ticks.div[<duration[45s].in_ticks>]> color:RED
        - foreach <server.online_players.filter[has_flag[combat]].filter[flag_expiration[combat].from_now.is_less_than[1]]||<list[]>> as:p:
            - run player_leaves_combat defmap:<map[player=<[p]>]>
        on command:
        - if <context.source_type> == PLAYER:
            - if <player.has_flag[combat]||false>:
                - define cmd:<context.command.to_lowercase><&sp><context.args.space_separated.to_lowercase>
                - if <yaml[config].parsed_key[combat_tag.blocked_commands].parse[to_lowercase].filter_tag[<[cmd].starts_with[<[filter_value]>]>].size> != 0:
                    - determine passively cancelled
                    - narrate "<&c>You cannot run this command while in combat."
            - if <server.online_players.filter[has_flag[combat]].filter_tag[<context.raw_args.to_lowercase.contains[<[filter_value].name.to_lowercase>]>].size.equals[0].not> && <player.has_permission[combat.bypass].not>:
                - narrate "<&c>This player is in combat."
                - determine cancelled


player_leaves_combat:
    type: procedure
    definitions: player
    debug: false
    script:
    - if !<[player].has_flag[combat]>:
        - if <server.current_bossbars.contains[combat_time<[player].uuid>]>:
            - bossbar remove combat_time<[player].uuid> players:<[player]>
        - narrate "<&b>You are no longer in combat." targets:<list[<[player]>]>

combat_time_command:
    type: command
    debug: false
    name: combattime
    description: Display how long you have left in combat.
    usage: /combattime
    aliases:
    - ct
    script:
    - if <player.has_flag[combat]>:
        - narrate "<&b>You have <&c><player.flag_expiration[combat].from_now.formatted_words> <&b>left in combat."
    - else:
        - narrate "<&b>You are not in combat."

logout_quit_command:
    type: command
    debug: false
    name: logout
    description: Safely logout of the server.
    usage: /logout
    aliases:
    - quit
    script:
    - if <player.has_flag[combat]>:
        - narrate "<&c>You must wait another <&4><player.flag_expiration[combat].from_now.formatted_words> <&c> before logging out safely."
    - else:
        - define move_check:<player.location.simple>
        - flag <player> logging_out duration:10s
        - repeat 10:
            - if <player.location.simple> == <[move_check]>:
                - playeffect dragon_breath <player.location> quantity:50
                - narrate "<&a>Safely logging out in <&2><player.flag_expiration[combat].from_now.formatted_words>"
                - wait 1s
            - else:
                - narrate "<&c>Logout cancelled. Please stand still."
                - stop
        - flag player combat:!
        - kick <player> "reason:<&a>----------------------------------------------------<&nl><&nl><&a>You have been safely removed from the server.<&nl><&nl><&a>----------------------------------------------------"
