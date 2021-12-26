
excavator_events:
    type: world
    debug: false
    data:
        allowed_blocks:
        - dirt
        - sand
        - gravel
        - coarse_dirt
        - grass_block
        - *concrete_powder
    events:
        on player breaks block bukkit_priority:highest:
        - if <player.item_in_hand.enchantment_types.parse[name].contains[excavation]>:
            - ratelimit <player> 1t
            - if <player.location.precise_impact_normal[10].y.equals[0]>:
                - define location <context.location.face[<context.location.add[<player.location.precise_impact_normal[10]>]>]>
                - define cuboid <[location].below.left.to_cuboid[<[location].above.right>]>
            - else:
                - define cuboid <context.location.with_yaw[0].with_pitch[0].forward.left.to_cuboid[<context.location.with_yaw[0].with_pitch[0].backward.right>]>
            - define blocks <[cuboid].blocks[<script.data_key[data.allowed_blocks].separated_by[|]>]>
            - ~modifyblock <[blocks]> air naturally:<player.item_in_hand> source:<player>
            - inventory set d:<player.inventory> slot:<player.held_item_slot> o:<player.item_in_hand.with[durability=<player.item_in_hand.durability.add[1]>]>

excavator_iron:
    type: item
    material: iron_axe
    mechanisms:
        enchantments:
            excavation: 1
            unbreaking: 5
    display name: <&e>Iron Excavator
    recipes:
        1:
            type: shaped
            recipe_id: iron_excavator_1
            output_quantity: 1
            input:
            - material:iron_block
            - material:stick
            - material:stick

excavator_diamond:
    type: item
    material: diamond_shovel
    mechanisms:
        enchantments:
            excavation: 1
            unbreaking: 5
    display name: <&e>Diamond Excavator
    recipes:
        1:
            type: shaped
            recipe_id: diamond_excavator_1
            output_quantity: 1
            input:
            - material:diamond_block
            - material:stick
            - material:stick

excavator_netherite:
    type: item
    material: netherite_shovel
    mechanisms:
        enchantments:
            excavation: 1
            unbreaking: 5
    display name: <&e>Netherite Excavator
    recipes:
        1:
            type: shaped
            recipe_id: netherite_excavator_1
            output_quantity: 1
            input:
            - material:netherite_block
            - material:stick
            - material:stick


enchantment_excavation:
    type: enchantment
    id: excavation
    slots:
    - mainhand
    rarity: VERY_RARE
    category: BREAKABLE
    full_name: Excavation
    min_level: 1
    max_level: 1
    min_cost: <context.level.mul[1]>
    max_cost: <context.level.mul[1]>
    treasure_only: true
    is_curse: false
    is_tradable: false
    is_discoverable: false
    is_compatible: <context.enchantment_key.advanced_matches_text[minecraft:mending].not>
    can_enchant: <context.item.material.name.contains[shovel]>
    damage_bonus: 0.0
    damage_protection: 0
