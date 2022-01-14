command_staffmode:
    type: command
    debug: false
    name: staffmode
    script:
    - define list <list[helper|mod|srmod|admin|owner]>
    - foreach <[list]> as:l:
        - if <player.has_permission[staffmode.<[l]>]>:
            - define rank <[l]>
    - if <[rank]||null> == null:
        - narrate "<&c>You do not have permission for this command."
        - stop
    - if <player.has_flag[staffmode]>:
        - if <[rank]> != owner:
            - execute as_server "lp user <player.name> parent remove <[rank]>_staffmode"
        - flag <player> staffmode:!
        - bossbar remove id:staffmode_indicator players:<player>
        - sidebar remove players:<player>
        - narrate "<&4>You have left <&l>StaffMode."
    - else:
        - if <[rank]> != owner:
            - execute as_server "lp user <player.name> parent add <[rank]>_staffmode"
        - flag <player> staffmode
        - execute as_server "dynmap hide <player.name>"
        - narrate "<&4>You have entered <&l>StaffMode."

command_debugmode:
    type: command
    debug: false
    name: debugmode
    script:
    - if !<player.has_permission[debugmode]>:
        - narrate "<&c>You do not have permission for this command."
        - stop
    - if <player.has_flag[debugmode]>:
        - flag <player> debugmode:!
        - bossbar remove id:debugmode_indicator players:<player>
        - narrate "<&9>You have left <&l>DebugMode."
    - else:
        - flag <player> debugmode
        - narrate "<&9>You have entered <&l>DebugMode."

staffmode_events:
    type: world
    debug: false
    create_bossbars:
    - if !<server.current_bossbars.contains[staffmode_indicator]>:
        - bossbar create id:staffmode_indicator color:red title:<&l><&4>StaffMode players:<server.online_players.filter[has_flag[staffmode]]>
    - if !<server.current_bossbars.contains[debugmode_indicator]>:
        - bossbar create id:debugmode_indicator color:blue title:<&l><&9>DebugMode players:<server.online_players.filter[has_flag[debugmode]]>
    events:
        on reload scripts:
        - inject staffmode_events path:create_bossbars
        on server start:
        - inject staffmode_events path:create_bossbars
        on delta time secondly server_flagged:debug_mode:
        - define tps <server.recent_tps.get[1].round_to[3]>
        - if <[tps].is_less_than[8]>:
            - define tps <&c><&l><[tps]>
        - else if <[tps].is_less_than[11]>:
            - define tps <&6><&l><[tps]>
        - else if <[tps].is_less_than[15]>:
            - define tps <&e><&l><[tps]>
        - else:
            - define tps <&2><&l><[tps]>
        - define tps <&c>TPS<&co><[tps]>
        - define uptime "<&c>Uptime: <&2><&l><server.delta_time_since_start.formatted>"
        - define tick_time "<&c>Tick Timing: <tern[<paper.tick_times.get[1].in_milliseconds.is_more_than[50]>].pass[<tern[<paper.tick_times.get[1].in_milliseconds.is_more_than[100]>].pass[<&4>].fail[<&6>]>].fail[<&2>]><&l><paper.tick_times.get[1].in_milliseconds.round_to[3]>ms"
        - define player_count "<&c>Players Online: <&2><&l><server.online_players.size>"
        - define chunk_count "<&c>Chunks Loaded: <&2><&l><server.worlds.parse[loaded_chunks.size].sum>"
        - define entity_count "<&c>Entities: <&2><&l><server.worlds.parse[entities.size].sum>"
        - define living_entity_count "<&c>Living Entities: <&2><&l><server.worlds.parse[living_entities.size].sum>"
        - define queue_count "<&c>Queues: <&2><&l><server.scripts.parse[queues.size].sum>"
        - sidebar set "title:<&4><&l>Server Status" players:<server.online_players.filter[has_flag[staffmode]]> values:<[tps]>|<[tick_time]>|<[uptime]>|<[player_count]>|<[chunk_count]>|<[entity_count]>|<[living_entity_count]>||<[queue_count]>
        - bossbar update id:staffmode_indicator color:red title:<&l><&4>StaffMode players:<server.online_players.filter[has_flag[staffmode]]>
        - bossbar update id:debugmode_indicator color:blue title:<&l><&9>DebugMode players:<server.online_players.filter[has_flag[debugmode]]>

spy_events:
    type: world
    debug: false
    message_commands:
        cmi msg:
            target: 3
            message: 4
        whisper:
            target: 2
            message: 3
        tell:
            target: 2
            message: 3
        pm:
            target: 2
            message: 3
        msg:
            target: 2
            message: 3
    chat_commands:
        g: Global
        globalchat: Global
        lc: Local
        localchat: Local
        tc: Town
        townchat: Town
        tr: Trade
        tradechat: Trade
        nc: Nation
        nationchat: Nation
        ac: Alliance
        alliancechat: Alliance
    events:
        on player chats ignorecancelled:true:
        - if <player.has_permission[spy.bypass]>:
            - stop
        - if <context.cancelled>:
            - announce to_flagged:messagespy "<&c>[Chat]<&r> <player.name> : <context.message>"
        on command:
        - if <player.has_permission[spy.bypass]||false>:
            - stop
        - define command <context.command><&sp><context.args.space_separated>
        - define use <script.list_keys[message_commands].filter_tag[<[command].starts_with[<[filter_value]>]>]>
        - if !<[use].is_empty>:
            - define target <[command].split[<&sp>].get[<script.data_key[message_commands.<[use].first>.target]>]||<player.flag[reply.last]||Unknown>>
            - define message <[command].split[<&sp>].remove[0].to[<script.data_key[message_commands.<[use].first>.message].sub[1]>].space_separated>
            - announce to_flagged:messagespy "<&c>[Message] <&r><player.name> -<&gt> <[target]> : <[message]>"
            - if <server.match_player[<[target]>].exists>:
                - flag <server.match_player[<[target]>]> reply.last:<player>
            - stop
        - if <context.source_type||null> == PLAYER:
            - ratelimit 1t <player>
            - define cmd <context.command.to_lowercase.split[<&co>].get[2]||<context.command.to_lowercase>>
            - define args <context.args||<list[]>>
            - if <[cmd].advanced_matches_text[<script.data_key[chat_commands].keys.separated_by[|]>]> && <[args].space_separated.trim.length> != 0:
                - announce to_flagged:messagespy "<&c>[Chat]<&r> <player.name> <&gt> <script.data_key[chat_commands.<[cmd]>]> : <[args].space_separated>"
            - else:
                - announce to_flagged:commandspy "<&c>[Command] <&r><player.name||<element[Console]>> -<&gt> <[cmd]><&sp><[args].space_separated>"

command_cmdspy:
    type: command
    debug: false
    name: commandspy
    script:
    - if <player.has_flag[staffmode]>:
        - if <player.has_flag[commandspy]>:
            - flag <player> commandspy:!
            - narrate "<&e>You can no longer see hidden commands."
        - else:
            - flag <player> commandspy
            - narrate "<&e>You can now see hidden commands."
    - else:
        - narrate "<&c>You do not have permission for this command."

command_msgspy:
    type: command
    debug: false
    name: messagespy
    script:
    - if <player.has_flag[staffmode]>:
        - if <player.has_flag[messagespy]>:
            - flag <player> messagespy:!
            - narrate "<&e>You can no longer see hidden messages."
        - else:
            - flag <player> messagespy
            - narrate "<&e>You can now see hidden messages."
    - else:
        - narrate "<&c>You do not have permission for this command."

error_handler_events:
    type: world
    debug: false
    events:
        on plugin generates exception:
        - define msg "<context.full_trace.replace[\n].with[<&nl>].strip_color.replace[<&lb>Error Continued<&rb>]>"
        - ratelimit 1t <[msg]>
        - announce to_flagged:debugmode "<&c>An exception has been thrown... <&l><&click[<[msg]>].type[COPY_TO_CLIPBOARD]><&hover[<[msg]>].type[SHOW_TEXT]><&lb>Click to copy!<&rb><&end_hover><&end_click>"
        on script generates error:
        - if <context.script.filename.ends_with[staffmode.dsc]>:
            - stop
        - if !<context.script.exists>:
            - stop
        - if <context.script> == <script>:
            - stop
        - if "<context.message.starts_with[Several text tags like '&dot' or '&cm' are pointless]>":
            - determine cancelled
        - if <context.message.ends_with[is<&sp>invalid!]> && <context.message.starts_with[Tag<&sp><&lt>inventory<&lb>]> && !<player.has_flag[debugmode]>:
            - wait 1t
            - inventory close
        - define "ignore_errors:|:The list_flags tag is meant for testing/debugging only. Do not use it in scripts (ignore this warning if using for testing reasons)."
        - if <context.script||null> != null && <context.line||null> != null && !<[ignore_errors].contains[<context.message>]>:
            - if <player.if_null[null]> != null:
                - define "cause:<player.name.as_element.on_hover[Click to teleport].on_click[/ex -q teleport <player.location||null>]||None>"
            - else:
                - define cause:None
            - flag server debug.errors.<context.queue.id>.stacktrace.<context.line>.message:<context.message>
            - ratelimit <context.queue> 1h
            - waituntil <context.queue.state> == stopping
            - foreach <server.flag[debug.errors.<context.queue.id>.stacktrace].keys> as:t:
                - define message <server.flag[debug.errors.<context.queue.id>.stacktrace.<[t]>.message]>
                - define "stacktrace:|:<&c><context.script.filename.split[plugins/Denizen/scripts/].get[2]><&co><&l><[t]> <&r><[message]>"
            - foreach <context.queue.definitions.deduplicate> as:definition:
                - define data <context.queue.definition[<[definition]>]>
                - if <[data].parsed.exists>:
                    - define definitions:|:<proc[get_debug_info].context[<[data].escaped>|<[definition]>]>
            - announce to_console "<&c>|----------------------| <&4>Error<&c> |-----------------------|"
            - announce to_console " <&c>Filename: <context.script.filename.split[plugins/Denizen/scripts/].get[2]>"
            - announce to_console " <&c>Player: <[cause]>"
            - announce to_console " <[stacktrace].separated_by[<&nl> ]>"
            - announce to_console " <&c>Definitions: <&l><[definitions].separated_by[<&sp><&2>|<&sp><&c><&l>]||None>"

            - announce to_flagged:debugmode "<&c>|----------------------| <&4>Error<&c> |-----------------------|"
            - announce to_flagged:debugmode " <&c>Filename: <context.script.filename.split[plugins/Denizen/scripts/].get[2]>"
            - announce to_flagged:debugmode " <&c>Player: <[cause]>"
            - announce to_flagged:debugmode " <[stacktrace].separated_by[<&nl> ]>"
            - announce to_flagged:debugmode " <&c>Definitions: <&l><[definitions].separated_by[<&sp><&2>|<&sp><&c><&l>]||None>"
            - flag server debug.errors.<context.queue.id>:!

get_debug_info:
    type: procedure
    debug: false
    definitions: data|definition
    script:
    - define data <[data].unescaped>
    - define "info:Type: <[data].object_type||Unknown>"
    - define "info:|:Script: <[data].script.name||None>"
    - choose <[data].object_type>:
        - case item:
            - define "info:|:Click to obtain."
            - define "info:|:Material: <[data].material.name||Unknown>"
            - if <[data].has_display>:
                - define "info:|:Display Name: <[data].display>"
            - if <[data].has_lore>:
                - foreach <[data].lore> as:line:
                    - define "info:|:Lore line <[loop_index]>: <[line]>"
            - determine "<&hover[<[info].separated_by[<&nl><&r>]>].type[SHOW_TEXT]><&click[/ex -q give<&sp><[data]>].type[RUN_COMMAND]><[definition]><&end_click><&end_hover>"
        - case location:
            - define "info:|:Click to teleport."
            - define "info:|:X=<[data].block.x>; Y=<[data].block.y>; Z=<[data].block.z>; World=<[data].world.name>"
            - define "info:|:Note: <[data].note_name||None>"
            - determine "<&hover[<[info].separated_by[<&nl><&r>]>].type[SHOW_TEXT]><&click[/ex -q teleport<&sp><[data]>].type[RUN_COMMAND]><[definition]><&end_click><&end_hover>"
        - case player:
            - define "info:|:Click to teleport."
            - define "info:|:Name: <[data].name>"
            - define "info:|:UUID: <[data].uuid>"
            - define "info:|:Health: <[data].health||Null>; Hunger: <[data].food_level||Null>"
            - if <[data].name.contains[<&ss>]>:
                - define "info:|:<&c>This players name contains hidden characters.<&r>"
            - determine "<&hover[<[info].separated_by[<&nl><&r>]>].type[SHOW_TEXT]><&click[/ex -q teleport<&sp><[data].location>].type[RUN_COMMAND]><[definition]><&end_click><&end_hover>"
        - case entity:
            - define "info:|:Click to teleport."
            - define "info:|:Entity Type: <[data].entity_type>"
            - define "info:|:UUID: <[data].uuid>"
            - define "info:|:Health: <[data].health>"
            - if <[data].name.contains[<&ss>]>:
                - define "info:|:<&c>This entitys name contains hidden characters.<&r>"
            - determine "<&hover[<[info].separated_by[<&nl><&r>]>].type[SHOW_TEXT]><&click[/ex -q teleport<&sp><[data].location>].type[RUN_COMMAND]><[definition]><&end_click><&end_hover>"
        - case list:
            - define "info:|:Click to copy to clipboard."
            - define "info:|:Size: <[data].size>"
            - foreach <[data]> as:v:
                - define i <[i].add[1]||1>
                - if <[i].is_more_than[50]>:
                    - foreach stop
                - choose <[v].object_type>:
                    - case player:
                        - define "t:<[v].name> ( <[v].uuid> )"
                    - case entity:
                        - define "t:<player.target.script.name||<[v].entity_type>> ( <[v].uuid> )"
                    - case item:
                        - define t:<[v].script.name||<[v].material.name>>
                    - case location:
                        - define "t:<tern[<[v].note_name.is_truthy>].pass[Note=<[v].note_name>; ].fail[]>X=<[v].block.x>; Y=<[v].block.y>; Z=<[v].block.z>; World=<[v].world.name>"
                    - default:
                        - define t:<[v]>
                - define "info:|: - <[t]>"
            - determine <&click[<[data]>].type[COPY_TO_CLIPBOARD]><&hover[<[info].separated_by[<&nl><&r>]>].type[SHOW_TEXT]><[definition]><&end_hover><&end_click>
        - case map:
            - define "info:|:Click to copy to clipboard."
            - define "info:|:Size: <[data].size>"
            - foreach <[data].keys> as:k:
                - define i <[i].add[1]||1>
                - if <[i].is_more_than[50]>:
                    - foreach stop
                - define v <[data].get[<[k]>]>
                - choose <[v].object_type>:
                    - case player:
                        - define "t:<[v].name> ( <[v].uuid> )"
                    - case entity:
                        - define "t:<player.target.script.name||<[v].entity_type>> ( <[v].uuid> )"
                    - case item:
                        - define t:<[v].script.name||<[v].material.name>>
                    - case location:
                        - define "t:<tern[<[v].note_name.is_truthy>].pass[Note=<[v].note_name>; ].fail[]>X=<[v].block.x>; Y=<[v].block.y>; Z=<[v].block.z>; World=<[v].world.name>"
                    - default:
                        - define t:<[v]>
                - define "info:|: <[k]> : <[t]>"
            - determine <&click[<[data]>].type[COPY_TO_CLIPBOARD]><&hover[<[info].separated_by[<&nl><&r>]>].type[SHOW_TEXT]><[definition]><&end_hover><&end_click>
        - default:
            - define "info:|:Click to copy to clipboard."
            - define "info:|:Value: <[data]>"
            - determine <&click[<[data]>].type[COPY_TO_CLIPBOARD]><&hover[<[info].separated_by[<&nl><&r>]>].type[SHOW_TEXT]><[definition]><&end_hover><&end_click>

command_gamemode_spectator:
    type: command
    name: spectator
    aliases:
    - gmsp
    debug: false
    script:
    - if <player.has_permission[spectator]> || <player.has_permission[minecraft.command.gamemode]>:
        - if <player.has_flag[staff.spectator]>:
            - adjust <player> gamemode:survival
            - narrate "<&e>You are now in survival."
            - execute as_server "dynmap show <player.name>"
            - teleport <player> <player.flag[staff.spectator].as_location>
            - flag <player> staff.spectator:!
        - else:
            - adjust <player> gamemode:spectator
            - narrate "<&e>You are now in spectator."
            - execute as_server "dynmap hide <player.name>"
            - flag <player> staff.spectator:<player.location>
    - else:
        - narrate "<&c>You do not have permission for that command."

command_gamemode_spectator_events:
    type: world
    debug: false
    events:
        on player teleports:
        - if !<player.has_permission[spectator.teleport]>:
            - if <player.has_flag[staff.spectator]> && <player.gamemode> == SPECTATOR:
                - adjust <player> gamemode:survival
                - determine passively destination:<player.flag[staff.spectator]>
                - flag <player> staff.spectator:!
                - execute as_server "dynmap show <player.name>"
                - narrate "<&e>You are now in survival."

command_gamemode_creative:
    type: command
    name: creative
    aliases:
    - gmc
    debug: false
    script:
    - if <player.has_permission[creative]> || <player.has_permission[minecraft.command.gamemode]>:
        - adjust <player> gamemode:creative
        - narrate "<&e>You are now in creative."
    - else:
        - narrate "<&c>You do not have permission for that command."

command_gamemode_survival:
    type: command
    name: survival
    aliases:
    - gms
    debug: false
    script:
    - if <player.has_permission[survival]> || <player.has_permission[minecraft.command.gamemode]>:
        - adjust <player> gamemode:survival
        - narrate "<&e>You are now in survival."
    - else:
        - narrate "<&c>You do not have permission for that command."