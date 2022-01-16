
monthly_missions_give_mission:
    type: task
    debug: false
    definitions: mission
    script:
    - if <server.has_flag[monthly_missions.mission]>:
        - run monthly_missions_mission_ends
    - define mission <[mission].if_null[<yaml[towny_missions].list_keys[pool].filter_tag[<yaml[towny_missions].read[pool.<[filter_value]>.type].equals[MONTHLY]>].random>]>
    - define duration <yaml[towny_missions].read[pool.<[mission]>.duration].as_duration>
    - define online <server.online_players>
    - flag server monthly_missions.mission.type:<[mission]> expire:<[duration]>
    - narrate targets:<[online]> "<&2>Monthly Missions: <&a>A new monthly mission has started..."
    - foreach <yaml[towny_missions].list_keys[pool.<[mission]>.goals]> as:n:
        - define material <yaml[towny_missions].read[pool.<[mission]>.goals.<[n]>.material]>
        - define quantity <yaml[towny_missions].read[pool.<[mission]>.goals.<[n]>.goal]>
        - flag server monthly_missions.mission.goal.<[n]>.material:<[material]>
        - flag server monthly_missions.mission.goal.<[n]>.quantity.requirement:<[quantity]>
        - flag server monthly_missions.mission.goal.<[n]>.quantity.completed.server:0
        - flag server monthly_missions.mission.easy.matcher:|:<[material]>
        - narrate targets:<[online]> "<&2> <&gt> Gather <&a><[quantity]> <&2><[material].to_titlecase>"
    - narrate targets:<[online]> "<&2>You have <&a><[duration].formatted_words> <&2>to complete this mission."
    - flag server monthly_missions.cooldown expire:<[duration]>

monthly_missions_player_contributes:
    type: task
    debug: false
    definitions: player|auto
    script:
    - define auto <[auto]||false>
    - if !<server.flag[monthly_missions.mission.type].exists>:
        - stop
    - if !<[player].is_truthy> || <[player].object_type> != Player:
        - stop
    - ratelimit 1s <[player]>
    - adjust <queue> linked_player:<[player]>
    - if <server.has_flag[monthly_missions.mission.goal]>:
        - if <[player].inventory.contains_item[<server.flag[monthly_missions.mission.goal].values.parse[get[material]]>]>:
            - foreach <server.flag[monthly_missions.mission.goal].keys> as:n:
                - if <server.flag[monthly_missions.mission.goal.<[n]>.completed]||false>:
                    - foreach next
                - define item <server.flag[monthly_missions.mission.goal.<[n]>.material]>
                - if !<[player].inventory.contains_item[<[item]>]>:
                    - foreach next
                - define has <[player].inventory.list_contents.filter[advanced_matches[<[item]>]].parse[quantity].sum>
                - define requirement <server.flag[monthly_missions.mission.goal.<[n]>.quantity.requirement]>
                - define remaining <[requirement].sub[<server.flag[monthly_missions.mission.goal.<[n]>.quantity.completed].values.sum||0>]>
                - if <[remaining]> >= <[has]>:
                    - define take <[has]>
                - else:
                    - define take <[remaining]>
                - take item:<[item]> from:<[player].inventory> quantity:<[take]>
                - flag server monthly_missions.mission.goal.<[n]>.quantity.completed.<[player].uuid>:+:<[take]>
                - if <[remaining]> <= <[has]>:
                    - run monthly_missions_complete_mission_objective def:<[n]>
                    - stop
                - else:
                    - if !<[auto]>:
                        - narrate "<&2>Turned in <&a><[take]> <&2><[item]>, <&a><[remaining].sub[<[take]>]> <&2>items are remaining."
                    - else:
                        - playsound sound:ENTITY_EXPERIENCE_ORB_PICKUP <[player]>
                    - run monthly_missions_mission_inventory_gui_update

monthly_missions_complete_mission_objective:
    type: task
    debug: false
    definitions: n
    script:
    - if !<[n].is_truthy> || !<server.flag[monthly_missions.mission.type].exists>:
        - stop
    - define online <server.online_players>
    - flag server monthly_missions.mission.goal.<[n]>.completed
    - flag server monthly_missions.mission.goal.<[n]>.quantity.completed.server:<server.flag[monthly_missions.mission.goal.<[n]>.quantity.requirement].sub[<server.flag[monthly_missions.mission.goal.<[n]>.quantity.completed].exclude[server].values.sum||0>]>
    - define contributers <server.flag[monthly_missions.mission.goal.<[n]>.quantity.completed].keys||<list[]>>
    - define requirement <server.flag[monthly_missions.mission.goal.<[n]>.quantity.requirement]>
    - foreach <yaml[towny_missions].list_keys[pool.<server.flag[monthly_missions.mission.type]>.goals.<[n]>.rewards]> as:r:
        - define type <yaml[towny_missions].read[pool.<server.flag[monthly_missions.mission.type]>.goals.<[n]>.rewards.<[r]>.type].to_lowercase>
        - define total <yaml[towny_missions].read[pool.<server.flag[monthly_missions.mission.type]>.goals.<[n]>.rewards.<[r]>.total]>
        - foreach <[contributers].exclude[server]> as:c:
            - define player <[c].as_player>
            - define amount <server.flag[monthly_missions.mission.goal.<[n]>.quantity.completed.<[c]>]>
            - define percent <[amount].div[<[requirement]>]>
            - if <[type]> == money:
                - money give players:<[player]> quantity:<[total].mul[<[percent]>]>
            - else if <[type]> == exp:
                - give xp to:<[player]> quantity:<[total].mul[<[percent]>]>
    - define complete:<list[]>
    - define incomplete:<list[]>
    - foreach <server.flag[monthly_missions.mission.goal].keys> as:n2:
        - if <server.flag[monthly_missions.mission.goal.<[n2]>.quantity.completed].values.sum.exists> && <server.flag[monthly_missions.mission.goal.<[n2]>.quantity.requirement]> == <server.flag[monthly_missions.mission.goal.<[n2]>.quantity.completed].values.sum>:
            - define complete:|:<[n2]>
        - else:
            - define incomplete:|:<[n2]>
    - if !<[incomplete].is_empty>:
        - narrate targets:<[online]> "<&2>A Monthly Mission Objective was completed:"
        - narrate targets:<[online]> "<&2> <&gt> <&m>Gather <&a><&m><server.flag[monthly_missions.mission.goal.<[n]>.quantity.requirement]> <&m><server.flag[monthly_missions.mission.goal.<[n]>.material].to_titlecase><&nl>"
        - narrate targets:<[online]> "<&2>You still have <&a><[incomplete].size> <&2>more mission<tern[<[incomplete].size.equals[1]>].pass[].fail[s]> to complete."
        - run monthly_missions_mission_inventory_gui_update
    - else:
        - run monthly_missions_completes_mission

monthly_missions_completes_mission:
    type: task
    debug: false
    script:
    - if !<server.flag[monthly_missions.mission.type].exists>:
        - stop
    - define mission <server.flag[monthly_missions.mission.type]>
    - define money 0
    - define online <server.online_players>
    - announce "<&2>The monthly mission has been completed. A new mission will start in <server.flag_expiration[monthly_missions.cooldown].from_now.formatted_words>"
    - flag server monthly_missions.mission:!
    - flag server monthly_missions.mission.completed
    - run monthly_missions_mission_inventory_gui_update

monthly_missions_mission_ends:
    type: task
    debug: false
    script:
    - if !<server.flag[monthly_missions.mission.type].exists>:
        - stop
    - define online <server.online_players>
    - narrate targets:<[online]> "<&2>The monthly mission has ended; Because you did not complete all objectives, you will not receive all rewards."
    - foreach <server.flag[monthly_missions.mission.goal].keys> as:n:
        - define contributers <server.flag[monthly_missions.mission.goal.<[n]>.quantity.completed].keys||<list[]>>
        - define requirement <server.flag[monthly_missions.mission.goal.<[n]>.quantity.requirement]>
        - foreach <yaml[towny_missions].list_keys[pool.<server.flag[monthly_missions.mission.type]>.goals.<[n]>.rewards]||<list[]>> as:r:
            - define type <yaml[towny_missions].read[pool.<server.flag[monthly_missions.mission.type]>.goals.<[n]>.rewards.<[r]>.type].to_lowercase>
            - define total <yaml[towny_missions].read[pool.<server.flag[monthly_missions.mission.type]>.goals.<[n]>.rewards.<[r]>.total]>
            - foreach <[contributers].exclude[server]||<list[]>> as:c:
                - define player <[c].as_player>
                - define amount <server.flag[monthly_missions.mission.goal.<[n]>.quantity.completed.<[c]>]>
                - define percent <[amount].div[<[requirement]>]>
                - if <[type]> == money:
                    - money give players:<[player]> quantity:<[total].mul[<[percent]>].round_to[2]>
                    - narrate targets:<[player]> "<&2>You have been rewarded $<[total].mul[<[percent]>].round_to[2]> for your objectives."
                - else if <[type]> == exp:
                    - give xp to:<[player]> quantity:<[total].mul[<[percent]>]>
    - flag server monthly_missions.mission:!
    - run monthly_missions_mission_inventory_gui_update

monthly_missions_mission_inventory_gui_update:
    type: task
    debug: false
    script:
    - define players <server.online_players.filter[open_inventory.script.name.equals[monthly_missions_mission_inventory_gui_town]]>
    - if !<[players].is_empty>:
        - if !<server.has_flag[monthly_missions.mission.type]>:
            - foreach <[players]> as:p:
                - adjust <queue> linked_player:<[p]>
                - inventory close
            - stop
        - define inventory <inventory[monthly_missions_mission_inventory_gui_town]>
        - foreach <[players]> as:p:
            - adjust <queue> linked_player:<[p]>
            - if <[p].open_inventory.exists>:
                - inventory swap d:<[p].open_inventory> o:<inventory[monthly_missions_mission_inventory_gui_town]>

monthly_missions_mission_inventory_gui_town:
    type: inventory
    inventory: chest
    size: 54
    gui: true
    debug: false
    title: <element[Towny Missions - Monthly].color_gradient[from=#2121dc;to=#1898dc]>
    definitions:
        ui: <item[gray_stained_glass_pane].with[display=<&sp>]>
    procedural items:
    - if !<server.flag[monthly_missions.mission.type].exists>:
        - stop
    - else:
        - define lore:<list[]>
        - repeat 6 as:n:
            - if <server.flag[monthly_missions.mission.goal.<[n]>.quantity.requirement].exists>:
                - define reward <yaml[towny_missions].read[pool.<server.flag[monthly_missions.mission.type]>.goals.<[n]>.rewards]>
                - foreach <[reward]> key:k as:v:
                    - if <[v].get[type]> == MONEY:
                        - define money:<[v].get[TOTAL]>
                - define requirement <server.flag[monthly_missions.mission.goal.<[n]>.quantity.requirement]>
                - define "lore:<&2>Requirement<&co> <&a><[requirement]>"
                - define "lore:|:<&2>Current<&co> <&a><server.flag[monthly_missions.mission.goal.<[n]>.quantity.completed].values.sum||0>"
                - define "lore:|:<&2>Reward<&co> <&a>$<[money]>"
                - define items:|:<server.flag[monthly_missions.mission.goal.<[n]>.material].as_item.with[lore=<[lore]>]>
                - define players:<server.flag[monthly_missions.mission.goal.<[n]>.quantity.completed].exclude[server].keys.get[1].to[8].sort_by_value[map.values].if_null[null]>
                - if <[players]> != null:
                    - repeat 8:
                        - if <[players].get[<[value]>].as_player.skull_item.exists>:
                            - define p <[players].get[<[value]>]>
                            - define player <[p].as_player>
                            - define amount <server.flag[monthly_missions.mission.goal.<[n]>.quantity.completed.<[p]>]>
                            - define item <[player].skull_item.with[display_name=<&2><[player].name>]>
                            - define "lore:<&2>Contribution<&co> <&a><[amount]>"
                            - define "lore:|:<&2>Earnings<&co> <&a>$<[money].mul[<[amount].div[<[requirement]>]>].round_to[2]>"
                            - define item <[item].with[lore=<[lore]>]>
                        - else:
                            - define item <[ui].parsed>
                        - define items:|:<[item]>
                - else:
                    - define items:|:<[ui].parsed.repeat_as_list[8]>
            - else:
                - define items:|:<[ui].parsed.repeat_as_list[9]>
        - determine <[items]>
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
