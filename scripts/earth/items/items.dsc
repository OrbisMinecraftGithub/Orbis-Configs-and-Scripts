patch_lore:
    type: procedure
    definitions: item|map
    debug: false
    script:
    - if <[item].exists.not> && <[item].material.name.equals[air]>:
        - determine <item[air]>
    - if <[item].has_lore.not> && <[item].enchantments.size.equals[0]||true>:
        - determine <[item]>
    - define map <[map]||<[item].enchantment_map>>
    - define lore <[map].parse_value_tag[<gray><enchantment[<[parse_key]>].full_name[<[parse_value]>]>].values>
    - if !<[item].has_flag[patch_lore]>:
        - define item <[item].with_flag[patch_lore:<[item].lore.if_null[<empty>]>]>
    - define lore <[lore].include[<[item].flag[patch_lore]>]>
    - define item <[item].with[lore=<[lore]>;hides=<[item].hides.include[ENCHANTS].deduplicate>]>
    - determine <[item]>

patch_lore_hook:
    type: world
    debug: false
    events:
        #| No way to override what appears when you hover over the enchantment button, so narrate them for the player
        # on player prepares item enchant:
        # - ratelimit <player> 1t
        # - define lines "<context.offers.parse_tag[<gray><[parse_value].get[enchantment_type].full_name[<[parse_value].get[level]>]> <white>. . . ?]>"
        # - narrate <[lines].separated_by[<n>]>
        on item enchanted:
        - determine RESULT:<context.item.proc[patch_lore].context[<context.enchants>]>
        on player prepares anvil craft item:
        - if <context.item.material.name.equals[air].not>:
            - determine <context.item.proc[patch_lore].context[<context.item.enchantment_map>]>
        on player clicks item in grindstone:
        - wait 1t
        - inventory set d:<context.inventory> slot:3 o:<context.inventory.slot[3].proc[patch_lore]>
        on item recipe formed:
        - define item <context.item>
        - if <context.recipe_id.equals[minecraft:repair_item]>:
            - define items <context.recipe.filter[script.name.exists].parse[script.name]>
            - if <[items].get[1].equals[<[items].get[2]>]>:
                - define item <item[<[items].get[1]>].with[durability=<context.item.durability>]>
        - determine <[item].proc[patch_lore]>

calculate_durability_damage:
    type: procedure
    definitions: unbreaking_level
    debug: false
    script:
    - determine <element[1].div[<[unbreaking_level].add[1]>]>

calculate_fortune_drops:
    type: procedure
    definitions: fortune_level|quantity
    debug: false
    script:
    - define quantity <[quantity]||1>
    - define list:|:1
    - repeat <[fortune_level].add[1]>:
        - define list:|:<[value]>
    - determine <[quantity].mul[<util.random.decimal[1].to[<[list].random>]>]||1>