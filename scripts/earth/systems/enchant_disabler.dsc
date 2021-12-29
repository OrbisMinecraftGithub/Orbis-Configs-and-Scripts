enchant_disabler_events:
    type: world
    debug: false
    events:
        on player clicks item in inventory:
        - if <context.item.enchantment_map.contains[sharpness]> && <context.item.enchantment_map.get[sharpness].is_more_than[1]>:
            - determine passively cancelled
            - wait 1t
            - adjust <player> item_on_cursor:<item[air]>
            - inventory adjust slot:<context.slot> enchantments:<context.item.enchantment_map.with[sharpness].as[1]>
            - inventory update
