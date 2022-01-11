
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
        - *sand
    events:
        on player breaks block bukkit_priority:highest:
        - if <player.item_in_hand.enchantment_types.parse[name].contains[excavation]>:
            - ratelimit <player> 1t
            - define loc <context.location.face[<context.location.relative[<player.location.forward.sub[<player.location>].round>]>]>
            - define cuboid <[loc].up.right.to_cuboid[<[loc].down.left>]>
            - define blocks <[cuboid].blocks[<script.data_key[data.allowed_blocks].separated_by[|]>]>
            - ~modifyblock <[blocks]> air naturally:<player.item_in_hand> source:<player>
            - if <player.item_in_hand.enchantment_map.contains[unbreaking]>:
                - if <proc[calculate_durability_damage].context[<player.item_in_hand.enchantment_map.get[unbreaking]>].is_more_than[<util.random.decimal[0].to[1]>]>:
                    - inventory set d:<player.inventory> slot:<player.held_item_slot> o:<player.item_in_hand.with[durability=<player.item_in_hand.durability.add[1]>]>
            - else:
                - inventory set d:<player.inventory> slot:<player.held_item_slot> o:<player.item_in_hand.with[durability=<player.item_in_hand.durability.add[1]>]>
            - if <player.item_in_hand.durability> > <player.item_in_hand.max_durability>:
                - inventory set d:<player.inventory> slot:<player.held_item_slot> o:<item[air]>


excavator_iron:
    type: item
    material: iron_shovel
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
