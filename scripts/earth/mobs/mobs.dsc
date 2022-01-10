mobs_events:
    type: world
    debug: false
    events:
        on wandering_trader spawns because natural:
        - determine cancelled
        on zombie_villager spawns:
        - if <context.reason> != SPAWNER_EGG:
            - determine cancelled
        on phantom spawns because natural:
        - determine cancelled
        on ender_crystal spawns:
        - determine cancelled
        on entity dies:
        - determine <context.drops.filter[material.name.equals[totem_of_undying].not]>
        on armor_stand dies:
        - determine <context.drops.filter[unbreakable.not]>
        on iron_golem spawns:
        - if <context.reason> != BUILD_IRONGOLEM:
            - determine cancelled