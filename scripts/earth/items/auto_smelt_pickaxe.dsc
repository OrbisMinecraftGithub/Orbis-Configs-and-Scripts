
auto_smelt_events:
    type: world
    debug: false
    events:
        on player breaks block:
        - stop
        # TODO

auto_smelt_iron:
    type: item
    material: iron_axe
    mechanisms:
        enchantments:
            auto_smelt: 1
    display name: <&e>Auto Smelt Pickaxe
    recipes:
        1:
            type: shaped
            recipe_id: auto_smelt_pickaxe_1
            output_quantity: 1
            input:
            - material:magma_block|material:magma_block|material:magma_block
            - material:fire_charge|material:blaze_rod|material:fire_charge
            - material:fire_charge|material:blaze_rod|material:fire_charge

enchantment_auto_smelt:
    type: enchantment
    id: auto_smelt
    slots:
    - mainhand
    rarity: VERY_RARE
    category: BREAKABLE
    full_name: Auto Smelt
    min_level: 1
    max_level: 1
    min_cost: <context.level.mul[1]>
    max_cost: <context.level.mul[1]>
    treasure_only: true
    is_curse: false
    is_tradable: false
    is_discoverable: false
    is_compatible: <context.enchantment_key.advanced_matches_text[minecraft:mending|minecraft:fortune].not>
    can_enchant: <context.item.material.name.contains[pickaxe]>
    damage_bonus: 0.0
    damage_protection: 0
