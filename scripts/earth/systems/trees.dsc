trees_events:
    type: world
    debug: false
    trees:
    - oak
    - birch
    - acacia
    - dark_oak
    - jungle
    - spruce
    events:
        on structure grows:
        - if <context.location.material.name.replace[_sapling].with[].advanced_matches_text[<script.data_key[trees]>]>:
            - determine passively cancelled
            - define saplings <context.location.flood_fill[6].types[<context.location.material.name>]>
            - announce <[saplings].size>
            - define tree <context.location.material.name.replace[_sapling].with[]>
            - if <[saplings].size.is_more_than_or_equal_to[9]>:
                - define size large
            - else if <[saplings].size.is_more_than_or_equal_to[4]>:
                - define size medium
            - else:
                - define size small
            - define schematic <proc[list_files_recursively].context[schematics].filter[contains_text[<[tree]>/<[size]>]].random.replace[.schem].with[]||null>
            - ~schematic load filename:<[schematic]> name:<[schematic]>
            - define cuboid <schematic[<[schematic]>].cuboid[<context.location>]>
            - define inventories <[cuboid].blocks.filter[inventory.exists]>
            - define map <map[]>
            - foreach <[inventories].parse[as_location]> as:b:
                - define map <[map].with[<[b].simple>].as[<[b].inventory.list_contents>]>
            - modifyblock <[saplings]> air
            - ~schematic paste name:<[schematic]> <context.location> noair
            - adjustblock <[cuboid].blocks[*leaves]> persistent:false
            - wait 1t
            - foreach <[inventories].filter[as_location.inventory.exists.not]> as:b:
                - modifyblock <[b].as_location> air
                - drop <[map].get[<[b].simple>]> <[b].as_location.center>
            - wait 1s
            - ~schematic unload name:<[schematic]>

list_files_recursively:
    type: procedure
    debug: false
    definitions: path
    script:
    - define todo:<server.list_files[<[path]||>]>
    - define files <list[]>
    - while <[todo].size.equals[0].not>:
        - foreach <[todo]> as:folder:
            - define todo <[todo].exclude[<[folder]>]>
            - foreach <server.list_files[<[path]>/<[folder]>]> as:file:
                - if <server.list_files[<[path]>/<[folder]>/<[file]>].exists>:
                    - define todo:|:<[folder]>/<[file]>
                - else:
                    - define files:|:<[folder]>/<[file]>
    - determine <[files]>
