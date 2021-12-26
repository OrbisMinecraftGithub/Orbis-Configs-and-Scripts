item_cooldown_events:
    type: world
    debug: false
    events:
        on player clicks block:
        - if <player.item_in_hand.material.name.to_lowercase> == ender_pearl || <player.item_in_offhand.material.name.to_lowercase> == ender_pearl:
            - ratelimit <player> 1t
            - if <player.item_in_hand.material.name.to_lowercase> == ender_pearl:
                - define num1 <player.item_in_hand.quantity>
            - if <player.item_in_offhand.material.name.to_lowercase> == ender_pearl:
                - define num1 <player.item_in_offhand.quantity>
            - wait 1t
            - if <player.item_in_hand.material.name.to_lowercase> == ender_pearl:
                - define num2 <player.item_in_hand.quantity>
            - if <player.item_in_offhand.material.name.to_lowercase> == ender_pearl:
                - define num2 <player.item_in_offhand.quantity>
            - if <[num1]> != <[num2]||null>:
                - itemcooldown ender_pearl duration:<yaml[config].read[enderpearl.cooldown]>
        on player consumes golden_apple:
        - itemcooldown golden_apple duration:3m
        on player consumes enchanted_golden_apple:
        - itemcooldown enchanted_golden_apple duration:3m