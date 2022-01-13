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
            - define time <[government].flag_expiration[towny_missions.mission.type].from_now.in_seconds>
            - define time <[time].sub[<[time].mod[60]>].as_duration>
            - define "lines:|:<&2> <&gt> Time Left: <&a><[time].formatted_words>"
        - else:
            - define "lines:|:<&a>Completed"
    - townymeta <[government]> key:denizen label:Mission "value:<[lines].separated_by[<&nl>]>"

item_helper:
    type: world
    debug: false
    events:
        on player clicks item in inventory:
        - if <context.item.script.exists> && <context.item.script.data_key[data.task].exists>:
            - define script <context.item.script>
            - if <[script].data_key[data.task.click].exists>:
                - if !<context.click.advanced_matches_text[<[script].data_key[data.task.click]>]>:
                    - stop
            - define task <[script].data_key[data.task.script]>
            - define definitions <[script].data_key[data.task.definitions].parsed>
            - run <[task]> defmap:<[definitions]>

towny_missions_events:
    type: world
    debug: false
    events:
        on server start:
        - yaml id:towny_missions load:data/missions_pool.yml
        on delta time minutely:
        - foreach <towny.list_towns.filter[has_flag[towny_missions.mission.type]].filter[flag_expiration[towny_missions.mission.type].from_now.is_less_than[60m]]> as:t:
            - run towny_rebuild_status_screen def:<[t]>
        on delta time minutely every:10:
        - foreach <towny.list_towns.filter[has_flag[towny_missions.mission.type]].filter[flag_expiration[towny_missions.mission.type].from_now.is_more_than[60m]]> as:t:
            - run towny_rebuild_status_screen def:<[t]>
        on delta time hourly:
        - foreach <towny.list_towns.filter[has_flag[towny_missions.mission.cooldown].not]> as:t:
            - run towny_missions_give_mission def:<[t]>
        on player picks up item:
        - if <player.has_town> && <player.has_flag[towny_missions.auto_contribute.town]> && <player.town.has_flag[towny_missions.mission.type]>:
            - if <context.item.advanced_matches[<player.town.flag[towny_missions.mission.easy.matcher]>]>:
                - wait 1t
                - run towny_missions_player_contributes def:<player.town>|<player>|true
        - if <player.has_nation> && <player.has_flag[towny_missions.auto_contribute.nation]> && <player.nation.has_flag[towny_missions.mission.type]>:
            - if <context.item.advanced_matches[<player.nation.flag[towny_missions.mission.easy.matcher]>]>:
                - wait 1t
                - run towny_missions_player_contributes def:<player.nation>|<player>|true


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
        - flag <[government]> towny_missions.mission.goal.<[n]>.quantity.completed.server:0
        - flag <[government]> towny_missions.mission.easy.matcher:|:<[material]>
        - narrate targets:<[online]> "<&2> <&gt> Gather <&a><[quantity]> <&2><[material].to_titlecase>"
    - narrate targets:<[online]> "<&2>You have <&a><[duration].formatted_words> <&2>to complete this mission."
    - flag <[government]> towny_missions.mission.cooldown expire:<[duration]>
    - run towny_rebuild_status_screen def:<[government]>

towny_missions_player_contributes:
    type: task
    debug: false
    definitions: government|player|auto
    script:
    - define auto <[auto]||false>
    - if !<[government].is_truthy> || !<[government].flag[towny_missions.mission.type].exists>:
        - stop
    - if !<[government].object_type> != Town && !<[government].object_type> != Nation:
        - stop
    - if !<[player].is_truthy> || <[player].object_type> != Player:
        - stop
    - ratelimit 1s <[player]>
    - adjust <queue> linked_player:<[player]>
    - if <[government].has_flag[towny_missions.mission.goal]>:
        - if <[player].inventory.contains_item[<[government].flag[towny_missions.mission.goal].values.parse[get[material]]>]>:
            - foreach <[government].flag[towny_missions.mission.goal].keys> as:n:
                - if <[government].flag[towny_missions.mission.goal.<[n]>.completed]||false>:
                    - foreach next
                - define item <[government].flag[towny_missions.mission.goal.<[n]>.material]>
                - if !<[player].inventory.contains_item[<[item]>]>:
                    - foreach next
                - define has <[player].inventory.list_contents.filter[advanced_matches[<[item]>]].parse[quantity].sum>
                - define requirement <[government].flag[towny_missions.mission.goal.<[n]>.quantity.requirement]>
                - define remaining <[requirement].sub[<[government].flag[towny_missions.mission.goal.<[n]>.quantity.completed].values.sum||0>]>
                - if <[remaining]> >= <[has]>:
                    - define take <[has]>
                - else:
                    - define take <[remaining]>
                - take item:<[item]> from:<[player].inventory> quantity:<[take]>
                - flag <[government]> towny_missions.mission.goal.<[n]>.quantity.completed.<[player].uuid>:+:<[take]>
                - if <[remaining]> <= <[has]>:
                    - run towny_missions_complete_mission_objective def:<[government]>|<[n]>
                - else:
                    - if !<[auto]>:
                        - narrate "<&2>Turned in <&a><[take]> <&2><[item]>, <&a><[remaining].sub[<[take]>]> <&2>items are remaining."
                    - run towny_rebuild_status_screen def:<[government]>
                    - run towny_missions_mission_inventory_gui_update def:<[government]>

towny_missions_complete_mission_objective:
    type: task
    debug: false
    definitions: government|n
    script:
    - if !<[government].is_truthy> || !<[n].is_truthy> || !<[government].flag[towny_missions.mission.type].exists>:
        - stop
    - if !<[government].object_type> != Town && !<[government].object_type> != Nation:
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
            - execute as_server "ta <[government].object_type> <[government].name> deposit <[total]>"
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
        - run towny_missions_mission_inventory_gui_update def:<[government]>
    - else:
        - run towny_missions_completes_mission def:<[government]>

towny_missions_completes_mission:
    type: task
    debug: false
    definitions: government
    script:
    - if !<[government].is_truthy> || !<[government].flag[towny_missions.mission.type].exists>:
        - stop
    - if !<[government].object_type> != Town && !<[government].object_type> != Nation:
        - stop
    - define mission <[government].flag[towny_missions.mission.type]>
    - define money 0
    - foreach <yaml[towny_missions].read[pool.<[mission]>.rewards].filter_tag[<[filter_value].get[type].equals[GOVERNMENT_BANK]>]> as:n key:m:
        - execute as_server "ta <[government].object_type> <[government].name> deposit <[n].get[total]>"
        - define money:+:<[n].get[total]>
    - define online <[government].residents.filter[is_online]>
    - narrate targets:<[online]> "<&2>Your <[government].object_type> completed its mission objectives and has been rewarded $<[money]>."
    - narrate targets:<server.online_players.exclude[<[online]>]> "The <[government].object_type> <[government].name> has completed its mission and has been rewarded $<[money]>."
    - flag <[government]> towny_missions.mission:!
    - flag <[government]> towny_missions.mission.completed
    - run towny_rebuild_status_screen def:<[government]>
    - run towny_missions_mission_inventory_gui_update def:<[government]>

towny_missions_mission_inventory_gui_update:
    type: task
    debug: false
    definitions: government
    script:
    - define players <[government].residents.filter[open_inventory.script.name.equals[towny_missions_mission_inventory_gui]]>
    - if !<[players].is_empty>:
        - adjust <queue> linked_player:<[players].first>
        - define inventory <inventory[towny_missions_mission_inventory_gui]>
        - foreach <[players]> as:p:
            - inventory swap d:<player[AJ_4real].open_inventory> o:<inventory[towny_missions_mission_inventory_gui]>

towny_missions_mission_inventory_gui:
    type: inventory
    inventory: chest
    size: 45
    gui: true
    debug: false
    title: <element[Towny Missions - Overview].color_gradient[from=#2121dc;to=#1898dc]>
    procedural items:
    - if !<player.has_town>:
        - define items:|:<item[towny_missions_gui_item_no_town]>
    - else if !<player.town.has_flag[towny_missions.mission.type]>:
        - define items:|:<item[towny_missions_gui_item_no_town_mission]>
    - else:
        - define town <player.town>
        - define lore:<list[]>
        - foreach <[town].flag[towny_missions.mission.goal].keys> as:n:
            - if <[town].flag[towny_missions.mission.goal.<[n]>.quantity.completed].values.sum.exists> && <[town].flag[towny_missions.mission.goal.<[n]>.quantity.requirement]> == <[town].flag[towny_missions.mission.goal.<[n]>.quantity.completed].values.sum>:
                - define "lore:|:<&2> <&gt> <&m>Gather <&a><&m><[town].flag[towny_missions.mission.goal.<[n]>.quantity.requirement]> <&2><&m><[town].flag[towny_missions.mission.goal.<[n]>.material].to_titlecase><&co> <&a><&m><[town].flag[towny_missions.mission.goal.<[n]>.quantity.completed].values.sum>"
            - else:
                - define "lore:|:<&2> <&gt> Gather <&a><[town].flag[towny_missions.mission.goal.<[n]>.quantity.requirement]> <&2><[town].flag[towny_missions.mission.goal.<[n]>.material].to_titlecase><&co> <&a><[town].flag[towny_missions.mission.goal.<[n]>.quantity.completed].values.sum||0>"
        - define ttime <[town].flag_expiration[towny_missions.mission.type].from_now.in_seconds>
        - define "lore:|:<&2>Time Left: <&a><[ttime].sub[<[ttime].mod[60]>].as_duration.formatted_words>"
        - define lore:|:<&sp>
        - define "lore:|:<&2><&l>Left Click to Contribute."
        - define items:|:<item[towny_missions_gui_item_town_mission].with[lore=<[lore]>]>
    - if !<player.has_nation>:
        - define items:|:<item[towny_missions_gui_item_no_nation]>
    - else if !<player.nation.has_flag[towny_missions.mission.type]>:
        - define items:|:<item[towny_missions_gui_item_no_nation_mission]>
    - else:
        - define nation <player.nation>
        - foreach <[nation].flag[towny_missions.mission.goal].keys> as:n2:
            - if <[nation].flag[towny_missions.mission.goal.<[n2]>.quantity.completed].values.sum.exists> && <[nation].flag[towny_missions.mission.goal.<[n2]>.quantity.requirement]> == <[nation].flag[towny_missions.mission.goal.<[n2]>.quantity.completed].values.sum>:
                - define "lore2:|:<&2> <&gt> <&m>Gather <&a><&m><[nation].flag[towny_missions.mission.goal.<[n2]>.quantity.requirement]> <&2><&m><[nation].flag[towny_missions.mission.goal.<[n2]>.material].to_titlecase><&co> <&a><&m><[nation].flag[towny_missions.mission.goal.<[n2]>.quantity.completed].values.sum>"
            - else:
                - define "lore2:|:<&2> <&gt> Gather <&a><[nation].flag[towny_missions.mission.goal.<[n2]>.quantity.requirement]> <&2><[nation].flag[towny_missions.mission.goal.<[n2]>.material].to_titlecase><&co> <&a><[nation].flag[towny_missions.mission.goal.<[n2]>.quantity.completed].values.sum||0>"
        - define ntime <[nation].flag_expiration[towny_missions.mission.type].from_now.in_seconds>
        - define "lore2:|:<&2>Time Left: <&a><[ntime].sub[<[ntime].mod[60]>].as_duration.formatted_words>"
        - define lore2:|:<&sp>
        - define "lore2:|:<&2><&l>Left Click to Contribute."
        - define items:|:<item[towny_missions_gui_item_nation_mission].with[lore=<[lore2]>]>
    - determine <[items]>
    definitions:
        ui: <item[gray_stained_glass_pane].with[display=<&sp>]>
    slots:
        - [ui] [ui] [ui] [ui] [ui] [ui] [ui] [ui] [ui]
        - [ui] [ui] [ui] [ui] [ui] [ui] [ui] [ui] [ui]
        - [ui] [] [ui] [] [ui] [towny_missions_gui_item_no_coalition] [ui] [] [ui]
        - [ui] [ui] [ui] [ui] [ui] [ui] [ui] [ui] [ui]
        - [ui] [ui] [ui] [ui] [ui] [ui] [ui] [ui] [ui]

towny_missions_command:
    type: command
    debug: false
    name: missions
    tab complete:
    - define cmd <context.alias.to_lowercase.split[<&co>].get[2]||<context.alias.to_lowercase>>
    - define args <context.args||<list[]>>
    - define length <context.raw_args.split[].count[<&sp>].add[1]>
    - if <[length]> == 1:
        - determine <list[contribute|contrib|autocontrib|autocontribute|auto].filter[to_lowercase.starts_with[<[args].get[1].to_lowercase||>]]>
    - else:
        - if <[args].get[1].to_lowercase.advanced_matches_text[contribute|contrib|autocontrib|autocontribute|auto]> && <[length]> == 2:
            - determine <list[town|nation].filter[to_lowercase.starts_with[<[args].get[2].to_lowercase||>]]>
    script:
    - define cmd <context.alias.to_lowercase.split[<&co>].get[2]||<context.alias.to_lowercase>>
    - define args <context.args||<list[]>>
    - if <context.source_type> != PLAYER:
        - narrate "<&c>This command can only be executed as a player."
        - stop
    - choose <[args].get[1].to_lowercase||>:
        - case "":
            - inventory open d:towny_missions_mission_inventory_gui
            - stop
        - case "contrib" "contribute":
            - choose <[args].get[2].to_lowercase||>:
                - case "":
                    - narrate "<&c>Not enough arguments."
                - case "nation":
                    - if !<player.has_nation>:
                        - narrate "<&c>You are not in a nation."
                        - stop
                    - if !<player.nation.has_flag[towny_missions.mission.type]>:
                        - narrate "<&c>Your nation does not have a mission."
                        - stop
                    - run towny_missions_player_contributes def:<player.nation>|<player>
                - case "town":
                    - if !<player.has_town>:
                        - narrate "<&c>You are not in a town."
                        - stop
                    - if !<player.town.has_flag[towny_missions.mission.type]>:
                        - narrate "<&c>Your town does not have a mission."
                        - stop
                    - run towny_missions_player_contributes def:<player.town>|<player>
                - default:
                    - narrate "<&c>That is not a valid argument."
        - case "autocontrib" "autocontribute" "auto":
            - choose <[args].get[2].to_lowercase||>:
                - case "":
                    - narrate "<&c>Not enough arguments."
                - case "nation":
                    - flag <player> towny_missions.auto_contribute.nation:<player.flag[towny_missions.auto_contribute.nation].not||true>
                    - narrate "<&e>You have toggled auto contribute for nation missions: <tern[<player.flag[towny_missions.auto_contribute.nation]>].pass[<&2>].fail[<&4>]><player.flag[towny_missions.auto_contribute.nation]>"
                - case "town":
                    - flag <player> towny_missions.auto_contribute.town:<player.flag[towny_missions.auto_contribute.town].not||true>
                    - narrate "<&e>You have toggled auto contribute for town missions: <tern[<player.flag[towny_missions.auto_contribute.town]>].pass[<&2>].fail[<&4>]><player.flag[towny_missions.auto_contribute.town]>"
                - default:
                    - narrate "<&c>That is not a valid argument."
        - default:
            - narrate "<&c>That is not a valid argument."

towny_missions_gui_item_no_town_mission:
    type: item
    material: paper
    display name: <&l><&2>Town Mission<&co> <&a><&l>Not Available

towny_missions_gui_item_no_town:
    type: item
    material: paper
    display name: <&l><&2>Town Mission<&co> <&a><&l>No Town

towny_missions_gui_item_town_mission:
    type: item
    material: paper
    display name: <&l><&2>Town Mission<&co> <&a><&l>In Progress
    data:
        task:
            script: towny_missions_player_contributes
            definitions:
                government: <player.town>
                player: <player>
            click: RIGHT|SHIFT_RIGHT

towny_missions_gui_item_no_nation_mission:
    type: item
    material: book
    display name: <&l><&2>Town Mission<&co> <&a><&l>Not Available

towny_missions_gui_item_no_nation:
    type: item
    material: book
    display name: <&l><&2>Town Mission<&co> <&a><&l>No Nation

towny_missions_gui_item_nation_mission:
    type: item
    material: book
    display name: <&l><&2>Nation Mission<&co> <&a><&l>In Progress
    data:
        task:
            script: towny_missions_player_contributes
            definitions:
                government: <player.nation>
                player: <player>
            click: RIGHT|SHIFT_RIGHT

towny_missions_gui_item_no_coalition:
    type: item
    material: book
    display name: <&l><&2>Coalition Mission<&co>
    lore:
    - <&c><&l>COMING SOON!