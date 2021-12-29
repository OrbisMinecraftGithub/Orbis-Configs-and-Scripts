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
        on player clicks block:
        - if <player.item_in_hand.enchantment_map.contains[sharpness]> && <player.item_in_hand.enchantment_map.get[sharpness].is_more_than[1]>:
            - inventory adjust slot:<player.held_item_slot> enchantments:<player.item_in_hand.enchantment_map.with[sharpness].as[1]>
        - if <player.item_in_offhand.enchantment_map.contains[sharpness]> && <player.item_in_offhand.enchantment_map.get[sharpness].is_more_than[1]>:
            - inventory adjust slot:41 enchantments:<player.item_in_offhand.enchantment_map.with[sharpness].as[1]>
