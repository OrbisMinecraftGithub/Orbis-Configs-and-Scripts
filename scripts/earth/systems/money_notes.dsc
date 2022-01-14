money_note_startup:
    type: world
    debug: false
    save:
    - yaml id:moneynotes savefile:data/moneynotes.yml
    load:
    - if !<server.list_files[data].contains[moneynotes.yml]>:
        - yaml create id:moneynotes
    - else:
        - yaml id:moneynotes load:data/moneynotes.yml
    events:
        on server start:
        - inject money_note_startup path:load
        on shutdown:
        - inject money_note_startup path:save

command_money_note:
    type: command
    name: iou
    debug: false
    aliases:
    - moneynote
    script:
    - if <context.args.get[1]||null> == null:
        - narrate "<&c>Not enough arguments."
        - stop
    - define number <context.args.get[1]>
    - if !<[number].mul[1].equals[<[number]>]||false>:
        - narrate "<&c>That number is not valid."
        - stop
    - if <[number]> < 0:
        - narrate "<&c>You cannot create a note with a negative value."
        - stop
    - if <player.money> < <[number]>:
        - narrate "<&c>You do not have enough money."
        - stop
    - if <[number]> > 10000:
        - narrate "<&c>You have exceeded the amount that you can put into a money note."
        - stop
    - define item <item[money_note_item]>
    - define item "<[item].with[lore=<list[<&b>Current value: <&c><&l>$<[number].format_number>]>]>"
    - flag <[item]> value:<[number]>
    - define uuid <util.random.uuid>
    - flag <[item]> uuid:<[uuid]>
    - flag <[item]> creator:<player>
    - yaml id:moneynotes set notes:->:<[uuid]>
    - inject money_note_startup path:save
    - if !<player.inventory.can_fit[<[item]>]>:
        - narrate "<&c>Your inventory is full."
        - stop
    - give <[item].with[custom_model_data=1]> to:<player.inventory>
    - money take players:<player> quantity:<[number]>

money_note_events:
    type: world
    debug: false
    events:
        on player right clicks block:
        - if <context.item.script.name||> == money_note_item:
            - define number <context.item.flag[value]>
            - if <yaml[moneynotes].read[notes].contains[<context.item.flag[uuid]>]||true>:
                - yaml id:moneynotes set notes:<-:<context.item.flag[uuid]>
                - money give players:<player> quantity:<[number]>
            - else:
                - narrate "<&c>This money note has already been claimed by someone else, this can only be caused by the money note being duplicated illegally."
                - narrate "<&c>The server administrators has been notified of this."
                - announce to_flagged:staffmode "<&c><player.name> attempted to redeem a duplicated money note worth $<[number]>, that was originally created by <context.item.flag[creator].as_player.name>."
            - take <context.item> quantity:1 from:<player.inventory>

money_note_item:
    type: item
    material: paper
    display name: <&e>Money Note
    custom_model_data: 1
