towny_rebuild_status_screen:
    type: task
    debug: false
    definitions: government
    script:
    - if !<[government].is_truthy>:
        - stop
    - if !<[government].object_type> != Town && !<[government].object_type> != Nation:
        - stop
    - define lines <list[]>
    - if <[government].has_flag[towny_missions.mission]>:
        - if !<[government].has_flag[towny_missions.mission.completed]>:
            - define "lines:|:<&a>In Progress"
            - foreach <[government].flag[towny_missions.mission.goal].keys> as:n:
                - define requirement <[government].flag[towny_missions.mission.goal.<[n]>.quantity.requirement]>
                - define completed <[government].flag[towny_missions.mission.goal.<[n]>.quantity.completed].values.sum||0>
                - define material <[government].flag[towny_missions.mission.goal.<[n]>.material].to_titlecase>
                - if <[requirement]> == <[completed]>:
                    - define "lines:|:<&2> <&gt> <&m>Gather <&a><&m><[requirement]> <&2><&m><[material]><&co> <&a><&m><[completed]>"
                - else:
                    - define "lines:|:<&2> <&gt> Gather <&a><[requirement]> <&2><[material]><&co> <&a><[completed]>"
            - define time <player.town.flag_expiration[towny_missions.mission.type].from_now.in_seconds>
            - define time <[time].sub[<[time].mod[60]>].as_duration>
            - define "lines:|:<&2> <&gt> Time Left: <&a><[time].formatted_words>"
        - else:
            - define "lines:|:<&a>Completed"
    - townymeta <[government]> key:denizen label:Mission "value:<[lines].separated_by[<&nl>]>"

towny_missions_events:
    type: world
    debug: false
    events:
        on server start:
        - yaml id:towny_missions load:data/missions_pool.yml

towny_missions_give_mission:
    type: task
    debug: false
    definitions: government|mission
    script:
    - if !<[government].is_truthy>:
        - stop
    - if !<[government].object_type> != Town && !<[government].object_type> != Nation:
        - stop
    - flag <[government]> towny_missions.mission:!
    - if <[government].object_type> == Town:
        - define mission <[mission].if_null[<yaml[towny_missions].list_keys[pool].filter_tag[<yaml[towny_missions].read[pool.<[filter_value]>.type].equals[TOWN]>].random>]>
    - else if <[government].object_type> == Nation:
        - define mission <[mission].if_null[<yaml[towny_missions].list_keys[pool].filter_tag[<yaml[towny_missions].read[pool.<[filter_value]>.type].equals[NATION]>].random>]>
    - define duration <yaml[towny_missions].read[pool.<[mission]>.duration].as_duration>
    - define online <[government].residents.filter[is_online]>
    - flag <[government]> towny_missions.mission.type:<[mission]> expire:<[duration]>
    - narrate targets:<[online]> "<&2>Towny Missions: <&a>Your <[government].object_type> received a new mission..."
    - foreach <yaml[towny_missions].list_keys[pool.<[mission]>.goals]> as:n:
        - define material <yaml[towny_missions].read[pool.<[mission]>.goals.<[n]>.material]>
        - define quantity <yaml[towny_missions].read[pool.<[mission]>.goals.<[n]>.goal]>
        - flag <[government]> towny_missions.mission.goal.<[n]>.material:<[material]>
        - flag <[government]> towny_missions.mission.goal.<[n]>.quantity.requirement:<[quantity]>
        - flag <[government]> towny_missions.mission.goal.<[n]>.quantity.completed:<list[]>
        - narrate targets:<[online]> "<&2> <&gt> Gather <&a><[quantity]> <&2><[material].to_titlecase>"
    - narrate targets:<[online]> "<&2>You have <&a><[duration].formatted_words> <&2>to complete this mission."
    - run towny_rebuild_status_screen def:<[government]>

towny_missions_player_contributes:
    type: task
    debug: false
    definitions: government|player
    script:
    - if !<[government].is_truthy>:
        - stop
    - if !<[government].object_type> != Town && !<[government].object_type> != Nation:
        - stop
    - if !<[player].is_truthy> || <[player].object_type> != Player:
        - stop
    - if !<[government].flag[towny_missions.mission.type].exists>:
        - stop
    - adjust <queue> linked_player:<[player]>
    - if <[government].has_flag[towny_missions.mission.goal]>:
        - if <[player].inventory.contains_item[<[government].flag[towny_missions.mission.goal].values.parse[get[material]]>]>:
            - foreach <[government].flag[towny_missions.mission.goal].keys> as:n:
                - if <[government].flag[towny_missions.mission.goal.<[n]>.completed]>:
                    - foreach next
                - define item <[government].flag[towny_missions.mission.goal.<[n]>.material]>
                - if !<[player].inventory.contains_item[<[item]>]>:
                    - foreach next
                - define has <[player].inventory.list_contents.filter[advanced_matches[<[item]>]].parse[quantity].sum>
                - define requirement <[government].flag[towny_missions.mission.goal.<[n]>.quantity.requirement]>
                - define remaining <[requirement].sub[<[government].flag[towny_missions.mission.goal.<[n]>.quantity.completed].values.sum>]>
                - if <[remaining]> >= <[has]>:
                    - define take <[has]>
                - else:
                    - define take <[remaining]>
                - take item:<[item]> from:<[player].inventory> quantity:<[take]>
                - flag <[government]> towny_missions.mission.goal.<[n]>.quantity.completed.<[player].uuid>:+:<[take]>
                - if <[remaining]> <= <[has]>:
                    - run towny_missions_complete_mission_objective def:<[government]>|<[n]>
                - else:
                    - narrate "<&2>Turned in <[take]> <[item]>, <[remaining].sub[<[take]>]> items are remaining."
                    - run towny_rebuild_status_screen def:<[government]>

towny_missions_complete_mission_objective:
    type: task
    debug: false
    definitions: government|n
    script:
    - if !<[government].is_truthy>:
        - stop
    - if !<[government].object_type> != Town && !<[government].object_type> != Nation:
        - stop
    - if !<[n].is_truthy>:
        - stop
    - if !<[government].flag[towny_missions.mission.type].exists>:
        - stop
    - define online <[government].residents.filter[is_online]>
    - flag <[government]> towny_missions.mission.goal.<[n]>.completed
    - flag <[government]> towny_missions.mission.goal.<[n]>.quantity.completed.server:<[government].flag[towny_missions.mission.goal.<[n]>.quantity.requirement].sub[<[government].flag[towny_missions.mission.goal.<[n]>.quantity.completed].exclude[server].values.sum||0>]>
    - define contributers <[government].flag[towny_missions.mission.goal.<[n]>.quantity.completed].keys||<list[]>>
    - define requirement <[government].flag[towny_missions.mission.goal.<[n]>.quantity.requirement]>
    - foreach <yaml[towny_missions].list_keys[pool.<[government].flag[towny_missions.mission.type]>.goals.<[n]>.rewards]> as:r:
        - define type <yaml[towny_missions].read[pool.<[government].flag[towny_missions.mission.type]>.goals.<[n]>.rewards.<[r]>.type].to_lowercase>
        - define total <yaml[towny_missions].read[pool.<[government].flag[towny_missions.mission.type]>.goals.<[n]>.rewards.<[r]>.total]>
        - foreach <[contributers].exclude[server]> as:c:
            - define player <[c].as_player>
            - define amount <[government].flag[towny_missions.mission.goal.<[n]>.quantity.completed.<[c]>]>
            - define percent <[amount].div[<[requirement]>]>
            - if <[type]> == money:
                - money give players:<[player]> quantity:<[total].mul[<[percent]>]>
            - else if <[type]> == exp:
                - give xp to:<[player]> quantity:<[total].mul[<[percent]>]>
        - if <[type]> == government_bank:
            - execute as_server "ta town <[government].name> deposit <[total].mul[<[percent]>]>"
    - define complete:<list[<[n]>]>
    - define incomplete:<list[]>
    - foreach <[government].flag[towny_missions.mission.goal].keys> as:n2:
        - if <[government].flag[towny_missions.mission.goal.<[n2]>.quantity.completed].values.sum.exists> && <[government].flag[towny_missions.mission.goal.<[n2]>.quantity.requirement]> == <[government].flag[towny_missions.mission.goal.<[n2]>.quantity.completed].values.sum>:
            - define complete:|:<[n2]>
        - else:
            - define incomplete:|:<[n2]>
    - if !<[incomplete].is_empty>:
        - narrate targets:<[online]> "<&2>Your <[government].object_type> has completed a mission objective:"
        - narrate targets:<[online]> "<&2> <&gt> <&m>Gather <&a><&m><[government].flag[towny_missions.mission.goal.<[n]>.quantity.requirement]> <&m><[government].flag[towny_missions.mission.goal.<[n]>.material].to_titlecase><&nl>"
        - narrate targets:<[online]> "<&2>You still have <&a><[incomplete].size> <&2>more mission<tern[<[incomplete].size.equals[1]>].pass[].fail[s]> to complete."
        - run towny_rebuild_status_screen def:<[government]>
    - else:
        - run towny_missions_completes_mission def:<[government]>

towny_missions_completes_mission:
    type: task
    debug: false
    definitions: government
    script:
    - if !<[government].is_truthy>:
        - stop
    - if !<[government].object_type> != Town && !<[government].object_type> != Nation:
        - stop
    - if !<[government].flag[towny_missions.mission.type].exists>:
        - stop
    - define mission <[government].flag[towny_missions.mission.type]>
    - foreach <yaml[towny_missions].read[pool.<[mission]>.rewards]> as:n key:m:
        - if <[n].get[type]> == GOVERNMENT_BANK:
            - execute as_server "ta <[government].object_type> <[government].name> deposit <[n].get[total]>"
    - define online <[government].residents.filter[is_online]>
    - narrate targets:<[online]> "<&2>Your <[government].object_type> completed its mission objectives and has been rewarded."
    - flag <[government]> towny_missions.mission:!
    - flag <[government]> towny_missions.mission.completed
    - run towny_rebuild_status_screen def:<[government]>
