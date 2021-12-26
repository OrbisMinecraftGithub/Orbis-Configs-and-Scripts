limit_redstone_device:
    type: world
    debug: false
    config:
        defaults:
            lagcontrol:
                limits:
                    redstone_lamp: 16
                    dispenser: 16
                    dropper: 16
                    piston: 16
                    hopper: 16
                    sticky_piston: 16
                    slime_block: 16
    task:
    - define material <[material]||<context.material.name>>
    - if <yaml[config].list_keys[lagcontrol.limits].contains[<[material]>]>:
        - if <context.location.chunk.cuboid.blocks[<[material]>].size> > <yaml[config].read[lagcontrol.limits.<[material]>]>:
            - narrate "<&c>You cannot place anymore <[material]>s in this chunk."
            - determine cancelled
    events:
        on player places block:
        - if <yaml[config].list_keys[lagcontrol.limits].contains[<context.material.name>]>:
            - inject limit_redstone_device path:task
