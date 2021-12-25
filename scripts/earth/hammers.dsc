
hammers_events:
    type: world
    debug: true
    events:
        on player breaks block bukkit_priority:highest:
        - if <player.item_in_hand.enchantment_types.parse[name].contains[area_dig]>:
            - ratelimit <player> 1t
            - if <player.location.precise_impact_normal[10].y.equals[0]>:
                - define location <context.location.face[<context.location.add[<player.location.precise_impact_normal[10]>]>]>
                - define blocks <[location].below.left.to_cuboid[<[location].above.right>].blocks>
            - else:
                - define blocks <context.location.with_yaw[0].with_pitch[0].forward.left.to_cuboid[<context.location.with_yaw[0].with_pitch[0].backward.right>]>
            - modifyblock <[blocks]> air naturally:<player.item_in_hand> source:<player>
            - inventory set d:<player.inventory> slot:<player.held_item_slot> o:<player.item_in_hand.with[durability=<player.item_in_hand.durability.add[1]>]>

hammer_diamond:
    type: item
    material: diamond_pickaxe
    mechanisms:
        enchantments:
            area_dig: 1
    display name: <&e>Diamond Hammer
    recipes:
        1:
            type: shaped
            recipe_id: diamond_hammer_1
            output_quantity: 1
            input:
            - material:diamond_block|material:diamond_block|material:diamond_block
            - air|material:stick|air
            - air|material:stick|air

hammer_netherite:
    type: item
    material: netherite_pickaxe
    mechanisms:
        enchantments:
            area_dig: 1
    display name: <&e>Netherite Hammer
    recipes:
        1:
            type: shaped
            recipe_id: netherite_hammer_1
            output_quantity: 1
            input:
            - material:netherite_block|material:netherite_block|material:netherite_block
            - air|material:stick|air
            - air|material:stick|air

hammer_iron:
    type: item
    material: iron_pickaxe
    mechanisms:
        enchantments:
            area_dig: 1
    display name: <&e>Iron Hammer
    recipes:
        1:
            type: shaped
            recipe_id: iron_hammer_1
            output_quantity: 1
            input:
            - material:iron_block|material:iron_block|material:iron_block
            - air|material:stick|air
            - air|material:stick|air

enchantment_area_dig:
    type: enchantment
    id: area_dig
    slots:
    - mainhand
    rarity: VERY_RARE
    category: BREAKABLE
    full_name: Area Dig
    min_level: 1
    max_level: 1
    min_cost: <context.level.mul[1]>
    max_cost: <context.level.mul[1]>
    treasure_only: true
    is_curse: false
    is_tradable: false
    is_discoverable: false
    is_compatible: <context.enchantment_key.advanced_matches_text[minecraft:mending|minecraft:unbreaking].not>
    can_enchant: <context.item.material.name.contains[pickaxe]>
    damage_bonus: 0.0
    damage_protection: 0
    # after attack:
    # - narrate "You attacked <context.victim.name> with a <context.level> enchantment!"
    # after hurt:
    # - adjust <player> gliding:false