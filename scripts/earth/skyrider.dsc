enchantment_skyrider_events:
    type: world
    debug: false
    glide:
    - if <player.equipment_map.get[chestplate].material.name.equals[elytra].not>:
        - stop
    - if <player.equipment_map.get[chestplate].enchantments.contains[skyrider].not||true>:
        - stop
    - if <[gliding]||<player.gliding>>:
        - playeffect at:<player.location> quantity:50 offset:2 explosion_huge
        - adjust <player> velocity:<player.velocity.add[<player.location.forward[2].sub[<player.location>]>]>
        - flag <player> skyrider_queue:<queue.id>
        - wait 1t
        - adjust <player> gliding:true
        - define gauss_val 1
        - define gauss_div 2
        - while <player.gliding> && <player.flag[skyrider_queue].equals[<queue.id>]>:
            - define vel <player.velocity.distance[<location[0,0,0,<player.world.name>]>]>
            - if <player.is_sneaking> && <[vel].is_less_than[5]>:
                - adjust <player> velocity:<player.velocity.add[<player.location.forward[0.05].sub[<player.location>]>]>
            - repeat <[vel].mul[20].round>:
                - playeffect at:<player.location.add[<location[0,0.5,0]>].sub[<player.velocity.mul[2]>]> quantity:1 offset:2 <player.flag[playersettings.elytra.effect]||cloud> velocity:<player.velocity.face[<location[0,0,0,<player.world.name>]>].mul[-3].relative[<location[<util.random.gauss[<[gauss_val]>].div[<[gauss_div]>]>,<util.random.gauss[<[gauss_val]>].div[<[gauss_div]>]>,0]>]> visibility:500
            - wait 1t
    events:
        on player starts sneaking:
        - inject enchantment_skyrider_events path:glide
        on entity starts gliding:
        - if <player||null> != null:
            - define gliding true
            - inject enchantment_skyrider_events path:glide

enchantment_skyrider:
    type: enchantment
    id: skyrider
    slots:
    - chest
    rarity: VERY_RARE
    category: WEARABLE
    full_name: Skyrider
    min_level: 1
    max_level: 1
    min_cost: <context.level.mul[1]>
    max_cost: <context.level.mul[1]>
    treasure_only: true
    is_curse: false
    is_tradable: false
    is_discoverable: false
    is_compatible: <context.enchantment_key.advanced_matches_text[minecraft:mending].not>
    can_enchant: <context.item.material.name.equals[elytra]>
    damage_bonus: 0.0
    damage_protection: 0
    # after attack:
    # - narrate "You attacked <context.victim.name> with a <context.level> enchantment!"
    after hurt:
    - adjust <player> gliding:false