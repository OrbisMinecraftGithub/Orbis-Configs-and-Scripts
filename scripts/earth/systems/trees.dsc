trees_events:
    type: world
    debug: false
    trees:
        oak:
            large: 7
            medium: 23
            small: 11
        birch:
            large: 4
            medium: 8
            small: 5
        acacia:
            large: 1
            medium: 6
            small: 6
        dark_oak:
            large: 11
            medium: 27
        jungle:
            large: 6
            medium: 15
            small: 10
        spruce:
            large: 10
            medium: 7
            small: 5
    events:
        on structure grows:
        - if <context.location.material.name.replace[_sapling].with[].advanced_matches_text[<script.list_keys[trees]>]>:
            - determine passively cancelled
            - define saplings <context.location.flood_fill[6].types[<context.location.material.name>]>
            - define tree <context.location.material.name.replace[_sapling].with[]>
            - if <[saplings].size.is_more_than[9]>:
                - define size large
            - else if <[saplings].size.is_more_than[4]>:
                - define size medium
            - else:
                - define size small
            - define num <util.random.int[1].to[<script.data_key[trees.<[tree]>.<[size]>]>]||null>
            - if <[num].equals[null]>:
                - define size medium
            - define schematic <[tree]>/<[size]>/<util.random.int[1].to[<script.data_key[trees.<[tree]>.<[size]>]>]>
            - ~schematic load filename:worldgen/trees/<[schematic]> name:worldgen/trees/<[schematic]>
            - define inventories <schematic[worldgen/trees/<[schematic]>].cuboid[<context.location>].blocks.filter[inventory.exists]>
            - define map <map[]>
            - foreach <[inventories]> as:b:
                - define map <[map].with[<[b].simple>].as[<[b].inventory.list_contents>]>
            - modifyblock <[saplings]> air
            - ~schematic paste name:worldgen/trees/<[schematic]> <context.location> noair
            - define cuboid <schematic[worldgen/trees/<[schematic]>].cuboid[<context.location>]>
            - adjustblock <[cuboid].blocks[*leaves]> persistent:false
            - wait 1t
            - foreach <[inventories].keys.filter[as_location.inventory.exists.not]> as:b:
                - drop <[map].get[<[b].simple>]> <[b].as_location.center>
            - wait 1s
            - ~schematic unload name:worldgen/trees/<[schematic]>
