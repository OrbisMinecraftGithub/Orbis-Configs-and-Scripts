animal_lag_prevention:
    type: world
    debug: false
    data:
        types:
        - sheep
        - rabbit
        - cow
        - pig
    events:
        on delta time minutely every:10:
        - foreach <script.data_key[data.types]> as:animal_type:
            - remove <world[world].entities[<[animal_type]>].filter[location.has_town.not]>
            - wait 1s

chunk_lag_prevention:
    type: world
    debug: false
    events:
        on delta time minutely every:5:
        - if <server.worlds.parse[loaded_chunks].combine.size.is_more_than[50000]>:
            - foreach <server.worlds.parse[loaded_chunks].combine> as:c:
                - adjust <[c]> force_loaded:false
        on server start:
        - wait 1m
        - if <server.worlds.parse[loaded_chunks].combine.size.is_more_than[50000]>:
            - foreach <server.worlds.parse[loaded_chunks].combine> as:c:
                - define i:+:1
                - if <[i].is_more_than_or_equal_to[30]>:
                    - wait 1t
                    - define i 0
                - adjust <[c]> force_loaded:false

command_removelag:
    type: command
    name: removelag
    debug: false
    script:
    - if <player.has_permission[orbis.command.removelag]>:
        - announce "<&c>Preparing to remove lag."
        - define chunks <server.worlds.parse[loaded_chunks].combine.size>
        - define entities <server.worlds.parse[living_entities.filter[location.has_town.not]].combine.size>
        - remove <server.worlds.parse[living_entities.filter[location.has_town.not]].combine>
        - define threshold 50
        - define chunks <server.worlds.parse[loaded_chunks].combine>
        - foreach <[chunks]> as:c:
            - define i:+:1
            - if <[i].is_more_than_or_equal_to[<[threshold]>]>:
                - define i 0
                - wait 1t
            - adjust <[c]> force_loaded:false
        - remove <server.worlds.parse[living_entities.filter[location.has_town.not]].combine>
        - announce "<&c> Unloaded <[chunks].sub[<server.worlds.parse[loaded_chunks].combine.size>]> chunks"
        - announce "<&c> Removed <[entities].sub[<server.worlds.parse[living_entities.filter[location.has_town.not]].combine.size>]> Living Entities"
    - else:
        - narrate "<&c>You do not have permission for that command."

server_dump:
    type: task
    debug: false
    definitions: type
    script:
        - if <server.has_file[server_dump.txt]>:
            - adjust server delete_file:server_dump.txt
        - log "Server Dump Information<n><n>" file:plugins/Denizen/server_dump.txt
        # Server TPS
        - log "Recent TPS: <server.recent_tps.separated_by[,<&sp>]>" type:none file:plugins/Denizen/server_dump.txt
        # Loaded Chunks per World
        - log "<n>Chunks Loaded per World" type:none file:plugins/Denizen/server_dump.txt
        - foreach <server.worlds> as:world:
            - log "<[world].name> - <[world].loaded_chunks.size>" type:none file:plugins/Denizen/server_dump.txt
        # Player Worlds
        - log "<n>Players per World" type:none file:plugins/Denizen/server_dump.txt
        - foreach <server.online_players> as:player:
            - flag server entity_counts.<[player].location.world.name>:+:1
        - foreach <server.flag[entity_counts]> key:key as:value:
            - log "<[key]> - <[value]>" type:none file:plugins/Denizen/server_dump.txt
        - flag server entity_counts:!
        # Entities per World
        - log "<n>Entities per World" type:none file:plugins/Denizen/server_dump.txt
        - foreach <server.worlds> as:world:
            - foreach <[world].entities> as:entity:
                - flag server entity_counts.<[entity].entity_type>:+:1
        - foreach <server.flag[entity_counts]> key:key as:value:
            - log "<[key]> - <[value]>" type:none file:plugins/Denizen/server_dump.txt
        - flag server entity_counts:!
        # Entities per Chunk
        - log "<n>Entities per Chunk (over 10)" type:none file:plugins/Denizen/server_dump.txt
        - foreach <server.worlds> as:world:
            - foreach <[world].entities> as:entity:
                - flag server entity_counts.<[entity].location.chunk>:+:1
        - foreach <server.flag[entity_counts]> key:key as:value:
            - if <[value]> > 10:
                - log "<[key]> - <[value]>" type:none file:plugins/Denizen/server_dump.txt
        - flag server entity_counts:!
        - foreach <server.worlds> as:world:
            - foreach <[world].entities[dropped_item]> as:item_entity:
                - flag server entity_counts.<[item_entity].item.material.name>:+:1
        - foreach <server.flag[entity_counts]> key:key as:value:
            - if <[value]> > 10:
                - log "<[key]> - <[value]>" type:none file:plugins/Denizen/server_dump.txt
        # Event Statistics
        - log "<n>Event Statistics:<n><n>" type:none file:plugins/Denizen/server_dump.txt
        - log <util.event_stats.strip_color> type:none file:plugins/Denizen/server_dump.txt