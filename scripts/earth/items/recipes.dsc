
custom_item_recipe_gunpowder:
    type: item
    material: gunpowder
    no_id: true
    recipes:
        1:
            type: shaped
            recipe_id: custom_item_recipe_gunpowder1
            output_quantity: 2
            input:
            - material:gravel|material:raw_copper|material:gravel
            - material:raw_copper|material:gravel|material:raw_copper
            - material:gravel|material:raw_copper|material:gravel
        2:
            type: shaped
            recipe_id: custom_item_recipe_gunpowder2
            output_quantity: 2
            input:
            - material:gravel|material:copper_ingot|material:gravel
            - material:copper_ingot|material:gravel|material:copper_ingot
            - material:gravel|material:copper_ingot|material:gravel

ammunition_rocket:
    type: item
    material: ghast_tear
    display name: §g§6RPG-7 Rocket
    mechanisms:
        custom_model_data: 510
    recipes:
        1:
            type: shaped
            recipes_id: custom_item_recipe_rocket2
            output_quantity: 1
            input:
            - air|material:copper_block|air
            - material:iron_block|material:fire_charge|material:iron_block
            - material:iron_block|material:firework_rocket|material:iron_block

ammunition_magazine:
    type: item
    material: ghast_tear
    display name: §g§6Magazine
    mechanisms:
        custom_model_data: 1
    recipes:
        1:
            type: shapeless
            recipes_id: custom_item_recipe_magazine1
            output_quantity: 1
            input: material:gunpowder|material:copper_ingot|material:copper_ingot

ammunition_shotgun_shell:
    type: item
    material: ghast_tear
    display name: §g§6ShotGun Shell
    mechanisms:
        custom_model_data: 3
    recipes:
        1:
            type: shapeless
            recipes_id: custom_item_recipe_shotgun_shell1
            output_quantity: 6
            input: material:gunpowder|material:copper_ingot|material:gold_ingot

ammunition_clip:
    type: item
    material: ghast_tear
    display name: §g§6Clip
    mechanisms:
        custom_model_data: 2
    recipes:
        1:
            type: shapeless
            recipes_id: custom_item_recipe_clip1
            output_quantity: 1
            input: material:gunpowder|material:copper_ingot

custom_big_dripleaf:
    type: item
    material: big_dripleaf
    no_id: true
    recipes:
        1:
            type: shaped
            recipe_id: big_dripleaf1
            output_quantity: 1
            input:
            - moss_block|moss_block|lily_pad
            - moss_block|moss_block|air
            - air|air|air

custom_azalea:
    type: item
    material: azalea
    no_id: true
    recipes:
        1:
            type: shaped
            recipe_id: azalea1
            output_quantity: 1
            input:
            - moss_block|moss_block|moss_block
            - moss_block|spruce_sapling|moss_block
            - moss_block|moss_block|moss_block

custom_flowering_azalea:
    type: item
    material: flowering_azalea
    no_id: true
    recipes:
        1:
            type: shaped
            recipe_id: flowering_azalea1
            output_quantity: 1
            input:
            - air|pink_tulip|air
            - pink_tulip|azalea|pink_tulip
            - air|pink_tulip|air

custom_sporeblossom:
    type: item
    material: spore_blossom
    no_id: true
    recipes:
        1:
            type: shapeless
            recipe_id: spore_blossom1
            output_quantity: 1
            input: moss_block|pink_tulip|moss_block|moss_block

custom_moss_block:
    type: item
    material: moss_block
    no_id: true
    recipes:
        1:
            type: shaped
            recipe_id: moss_block1
            output_quantity: 1
            input:
            - grass_block|grass_block
            - grass_block|grass_block

custom_small_dripleaf:
    type: item
    material: small_dripleaf
    no_id: true
    recipes:
        1:
            type: shapeless
            recipe_id: small_dripleaf1
            output_quantity: 1
            input: grass_block|lily_pad

custom_bell:
    type: item
    material: bell
    no_id: true
    recipes:
        1:
            type: shaped
            recipe_id: bell1
            output_quantity: 1
            input:
            - material:stone|material:stick|material:stone
            - material:stone|material:golden_block|material:stone
            - material:stone|air|material:stone

custom_ink_sac:
    type: item
    material: ink_sac
    no_id: true
    recipes:
        1:
            type: shapeless
            recipe_id: ink_sac1
            output_quantity: 2
            input: charcoal|charcoal|coal|coal

custom_string:
    type: item
    material: string
    no_id: true
    recipes:
        1:
            type: shapeless
            recipe_id: string1
            output_quantity: 4
            input: *wool