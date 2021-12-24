patch_lore:
    type: procedure
    definitions: item|map
    script:
    - define map <[map]||<[item].enchantment_map>>
    - define lore <[map].parse_value_tag[<gray><enchantment[<[parse_key]>].full_name[<[parse_value]>]>].values>
    - if !<[item].has_flag[patch_lore]>:
        - define item <[item].with_flag[patch_lore:<[item].lore.if_null[<empty>]>]>
    - define lore <[lore].include[<[item].flag[patch_lore]>]>
    - define item <[item].with[hides=ENCHANTS;lore=<[lore]>]>
    - determine <[item]>

patch_lore_hook:
    type: world
    events:
        #| No way to override what appears when you hover over the enchantment button, so narrate them for the player
        # on player prepares item enchant:
        # - ratelimit <player> 1t
        # - define lines "<context.offers.parse_tag[<gray><[parse_value].get[enchantment_type].full_name[<[parse_value].get[level]>]> <white>. . . ?]>"
        # - narrate <[lines].separated_by[<n>]>
        on item enchanted:
        - determine RESULT:<context.item.proc[patch_lore].context[<context.enchants>]>
        on player prepares anvil craft item:
        - determine <context.item.proc[patch_lore].context[<context.item.enchantment_map>]>