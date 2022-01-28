travel_command:
    type: command
    debug: false
    name: travel
    tab complete:
        - if !<player.has_permission[travel.command]>:
            - stop
        - define index <context.raw_args.to_list.count[<&sp>]>
        - if <[index]> == 0:
            - determine <server.list_files[../../].filter[starts_with[template_]].replace_text[template_].with[].as_list.filter[starts_with[<context.args.get[1]||>]]>
    script:
    - define world <context.args.get[0]||null>
    - if <[world]> != null && <world[<[world]>]||null> != null:
        - define world <world[<[world]>]>
        - teleport <player> <[world].spawn_location>
