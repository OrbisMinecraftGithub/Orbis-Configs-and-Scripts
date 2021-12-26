trees_events:
    type: world
    debug: true
    trees:
        oak:
            large: 5
            medium: 11
            small: 6
        birch:
            medium: 8
            small: 5
        acacia:
            large: 1
            medium: 6
            small: 6
        dark_oak:
            large: 10
            medium: 16
        jungle:
            large: 6
            medium: 5
        spruce:
            large: 10
            medium: 7
            small: 5
    events:
        on structure grows:
        - determine passively cancelled
        - define saplings <context.location.flood_fill[6].types[<context.location.material.name>]>
        - define tree <context.location.material.name.replace[_sapling].with[]>
        - if <[saplings].size.is_more_than[9]> && <script.data_key[trees.<[tree]>].contains[large]>:
            - define schematic <[tree]>/large/<util.random.int[1].to[<script.data_key[trees.<[tree]>.large]>]>
        - else if <[saplings].size.is_more_than[4]> && <script.data_key[trees.<[tree]>].contains[medium]>:
            - define schematic <[tree]>/medium/<util.random.int[1].to[<script.data_key[trees.<[tree]>.medium]>]>
        - else:
            - define schematic <[tree]>/small/<util.random.int[1].to[<script.data_key[trees.<[tree]>.small]>]>
        - ~schematic load filename:worldgen/trees/<[schematic]> name:worldgen/trees/<[schematic]>
        - modifyblock <[saplings]> air
        - ~schematic paste name:worldgen/trees/<[schematic]> <context.location> noair
        - define cuboid <schematic[worldgen/trees/<[schematic]>].cuboid[<context.location>]>
        - adjustblock <[cuboid].blocks[*leaves]> persistent:false
        - wait 1s
        - ~schematic unload name:worldgen/trees/<[schematic]>
