resourcepack_events:
    type: world
    debug: false
    events:
        on bungee player joins network:
        # - waituntil <server.match_offline_player[<context.name>].is_online>
        - while <server.match_offline_player[<context.name>].is_online.not>:
            - wait 1t
        - adjust <queue> linked_player:<server.match_offline_player[<context.name>]>
        # - resourcepack hash:<server.flag[resourcepack.hash]> url:<server.flag[resourcepack.url]> prompt:<server.flag[resourcepack.prompt].parsed> targets:<player>
        - adjust <player> resource_pack:<server.flag[resourcepack.url]>