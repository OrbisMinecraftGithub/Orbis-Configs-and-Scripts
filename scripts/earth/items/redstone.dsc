limit_redstone_device:
    type: world
    debug: false
    config:
        defaults:
            lagcontrol:
                redstone:
                    min_time_between_pulse: 1s
                    number_before_removal: 10
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
        on redstone recalculated:
        - define loc <context.location.center>
        - ratelimit <[loc]> 2t
        - flag <[loc]> redstone:<[loc].flag[redstone].add[1]||1> duration:<yaml[config].read[lagcontrol.redstone.min_time_between_pulse].as_duration||<duration[1s]>>
        - define num <[loc].flag[redstone]>
        - if <[num].is_more_than[<yaml[config].read[lagcontrol.redstone.number_before_removal]||10>]>:
            - wait 1t
            - modifyblock <[loc]> air naturally:diamond_pickaxe
            - flag <[loc]> redstone:!