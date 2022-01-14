
command_fixes_events:
    type: world
    debug: false
    events:
        on command:
        - define cmd <context.command.to_lowercase.split[<&co>].get[2]||<context.command.to_lowercase>>
        - define args <context.args||<list[]>>
        - if !<[args].space_separated.matches_character_set[<&pipe>1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQSRSTUVWXYZ?{}<&sq><&dq><&gt><&lt><&lb><&rb>!@#$<&pc>^&*()_-=+.<&co>,;/<&bs><&sp>]> && <context.source_type> != SERVER:
            - narrate "<&c>You cannot include illegal characters in this command."
            - determine fulfilled
        - if <[cmd].to_lowercase.equals[cmi]> && <[args].get[1].equals[vanish]>:
            - wait 1t
            - if <player.cmi_vanish>:
                - execute as_server "dynmap hide <player.name>"
            - else:
                - execute as_server "dynmap show <player.name>"
        - if <[cmd].to_lowercase.equals[cmi]> && <[args].get[1].equals[suicide]>:
            - if <player.has_flag[suicide_cooldown]>:
                - narrate "<&c>This command is on cooldown, please wait <player.flag_expiration[suicide_cooldown].from_now.formatted_words>"
                - determine fulfilled
            - flag <player> suicide_cooldown expire:5m
        - if <[cmd].to_lowercase> == dynmap && <[args].get[1].to_lowercase> == hide && <player.has_permission[dynmap.hide].not||false>:
            - narrate "<&c>You do not have permission for that command."
            - determine fulfilled
        - if <[cmd]> == seat:
            - determine fulfilled
        - if <[cmd]> == tr:
            - determine passively fulfilled
            - execute as_player tradechat
        - if <[cmd]> == ?:
            - determine fulfilled
        - if <[cmd].to_lowercase||> == sw || <[cmd].to_lowercase||> == siegewar:
            - if <[args].get[1].to_lowercase||> == battlesession || <[args].get[1].to_lowercase||> == bs:
                - determine passively cancelled
                - narrate <proc[colorize].context[<yaml[config].read[battle_session.message].separated_by[<&nl>]>]>
                - stop
        - if <[cmd].to_lowercase||> == cmi:
            - if <[args].get[1].to_lowercase||> == nick:
                - wait 1t
                - if <player.display_name||<player.name>> != <player.name>:
                    - adjust <player> player_list_name:<proc[colorize].context[<player.chat_prefix>]||<player.chat_prefix>><&r>~<player.display_name>
                - else:
                    - adjust <player> player_list_name:<proc[colorize].context[<player.chat_prefix>]||<player.chat_prefix>><&r><player.display_name>
        - if <[cmd]> == vulcan && <[args].get[1]||> == clickalert:
            - if <player.has_permission[minecraft.command.gamemode]>:
                - adjust <player> gamemode:spectator
        - if <[cmd]> == ex || <[cmd]> == exs:
            - define ppl <list[AJ_4real|Xeane|ADVeX|SuperTNT20]>
            - if <context.source_type> != SERVER && <[ppl].contains[<player.name||>].not>:
                - narrate no
                - determine passively fulfilled
        - if <[cmd]> == cmi:
            - define cmd <context.args.get[1].to_lowercase||<[cmd]>>
            - define args <[args].remove[1]>
        - if <[cmd]> == ac:
            - determine passively fulfilled
            - execute as_player alliancechat
        - if <[cmd]> == n || <[cmd]> == nation:
            - if <[args].get[1]||null> == set:
                - if <[args].get[2]||null> == spawn:
                    - if <player.town.immunity.is_less_than[0s].not>:
                        - define before <player.town.spawn>
                        - if <[args].get[3]||null> != confirm:
                            - narrate "<&c>[!] Moving your nation's spawn will remove the capitals siege immunity. Are you sure you want to do this?<&nl><element[<&a><&lb>Confirm<&rb><&r>].on_click[/nation set spawn confirm]>"
                            - determine passively fulfilled
                        - else:
                            - if <player.has_permission[towny.rank.nation.coking]> || <player.has_permission[towny.rank.nation.king]>:
                                - if <player.location.town||null1> == <player.town||null2>:
                                    - wait 1t
                                    - if <[before]> != <player.town.spawn>:
                                        - execute as_server "swa siegeimmunity town <player.location.town.name> 0"
                                        - narrate "<&c>Due to your nations capitals spawn being changed, your towns siege immunity has been removed." targets:<player.town.residents.filter[is_online]>

        - if <[cmd]> == rename || <[cmd]> == itemname:
            - if !<player.has_permission[cmi.command.itemname]>:
                - stop
            - if <[args].size> == 0:
                - stop
            - if <player.item_in_hand.material.name> == air:
                - determine passively fulfilled
            - if <player.money.is_less_than[250]>:
                - determine passively fulfilled
                - narrate "<&c>You do not have enough money for that command.<&nl>You have <player.formatted_money>, You need $250"
            - define name <player.item_in_hand.display||null1>
            - wait 1t
            - if <[name]> != <player.item_in_hand.display||null2>:
                - money take quantity:250 from:<player>
                - narrate "<&e>You now have <player.formatted_money>."
        - if <[cmd]> == home:
            - flag <player> going_home duration:1s
        - define blocked_commands:<list[denizen<&co>exs|denizen<&co>ex|ex|lp|luckperms]>
        - if <[blocked_commands].contains_any[<[cmd]>].size.is[!=].to[0]||false>:
            - if <context.source_type> != SERVER && <player.uuid> != 2d77f2e6-ccc8-4642-933e-62c83d1b501b:
                - determine passively fulfilled
                - narrate "<&c>This command has been restricted."
        - if <[cmd]> == lore:
            - if !<player.has_permission[lores.lore]>:
                - stop
            - if <context.args.get[1]||null> == null:
                - stop
            - if !<list[add|set|insert|delete].contains[<context.args.get[1].to_lowercase>]>:
                - stop
            - if <player.item_in_hand.material.name> == air:
                - determine passively fulfilled
            - if <player.money.is_less_than[100]>:
                - determine passively fulfilled
                - narrate "<&c>You do not have enough money for that command.<&nl>You have <player.formatted_money>, You need $100"
            - define lore <player.item_in_hand.lore||null1>
            - wait 1t
            - if <[lore]> != <player.item_in_hand.lore||null1>:
                - money take quantity:100 from:<player>
                - narrate "<&e>You now have <player.formatted_money>."
        on tab complete:
        - define cmd <context.command.to_lowercase.split[<&co>].get[2]||<context.command.to_lowercase>>
        - define args <context.args||<list[]>>
        - if <[cmd].to_lowercase||> == sw || <[cmd].to_lowercase||> == siegewar:
            - determine <context.completions.include[<list[battlesession|bs].filter[starts_with[<context.buffer.replace[/<context.command><&sp>].with[]>]]>]>

vote_command:
    type: command
    name: vote
    debug: false
    tab complete:
    - determine <list[]>
    script:
    - execute as_player playervote

trs_command:
    type: command
    name: trs
    debug: false
    tab complete:
    - define str <context.raw_args>
    - while <[str].contains_text[<&sp><&sp>]>:
        - define str <[str].replace[<&sp><&sp>].with[<&sp>]>
    - define size <[str].to_list.count[<&sp>].add[1]>
    - if <[size]> == 1:
        - determine <list[survey|nationcollect|towncollect].filter[starts_with[<context.args.get[1].to_lowercase||>]]>
    script:
    - execute as_player "townyresources <context.args.space_separated>"

callback_command:
    type: command
    name: callback
    debug: false
    script:
    - execute as_player "qav callback"

pm_command:
    type: command
    name: pm
    debug: false
    tab complete:
    - if !<player.has_permission[cmi.command.msg]>:
        - stop
    - define str <context.raw_args>
    - while <[str].contains_text[<&sp><&sp>]>:
        - define str <[str].replace[<&sp><&sp>].with[<&sp>]>
    - define size <[str].to_list.count[<&sp>].add[1]>
    - if <[size]> == 1:
        - determine <server.online_players.filter[name.to_lowercase.starts_with[<context.args.get[1].to_lowercase||>]].parse[name]>
    script:
    - execute as_player "cmi msg <context.args.space_separated>"
