remove_incendium_items:
    type: world
    debug: false
    events:
        on player opens inventory:
        - if <player.inventory.list_contents.filter[all_raw_nbt.keys.contains[incendium]].size.equals[0].not||false>:
            - inventory exclude d:<player.inventory> origin:<player.inventory.list_contents.filter[all_raw_nbt.keys.contains[incendium]]>
        - if <context.inventory.list_contents.filter[all_raw_nbt.keys.contains[incendium]].size.equals[0].not||false>:
            - inventory exclude d:<context.inventory> origin:<context.inventory.list_contents.filter[all_raw_nbt.keys.contains[incendium]]>

fixes_events:
    type: world
    debug: false
    config:
        defaults:
            enderpearl:
                cooldown: 20s
                damage_when_teleported: 2
            lagcontrol:
                redstone:
                    min_time_between_pulse: 1s
                    number_before_removal: 10
                entities:
                    maximum_per_chunk: 50
            offhand:
                disallow:
                - AK47
                - SPAS12
                - M1014
                - OLYMPIA
                - FAL
                - AK74u
                - BARRET
                - FAMAS
                - AWP
                - HUNTING_RIFLE
                - L85A2
                - M16
                - M249
                - M4A1
                - P90
                - UMP
                - UZI
                - SCAR
                - PKP
                - RPG
    events:
        on player opens inventory:
        - inventory exclude d:<context.inventory> origin:totem_of_undying
        - inventory exclude d:<player.inventory> origin:totem_of_undying
        on delta time secondly:
        - foreach <server.online_players.filter[location.material.name.equals[nether_portal]]>:
            - define portal <[value].location.flood_fill[6].types[nether_portal]]>
            - foreach <[portal]> as:b:
                - if <[b].material.direction.equals[Z]||false>:
                    - modifyblock <[b].relative[1,0,0]> air
                    - modifyblock <[b].relative[-1,0,0]> air
                - if <[b].material.direction.equals[X]||false>:
                    - modifyblock <[b].relative[0,0,1]> air
                    - modifyblock <[b].relative[0,0,-1]> air
        on player uses portal:
        - if <player.location||null> == null:
            - stop
        - waituntil <context.to.chunk.is_loaded>
        - define portal <player.location.flood_fill[6].types[*].filter[material.name.equals[nether_portal]]>
        - wait 5t
        - foreach <[portal]> as:b:
            - if <[b].material.direction.equals[Z]||false>:
                - modifyblock <[b].relative[1,0,0]> air
                - modifyblock <[b].relative[-1,0,0]> air
            - if <[b].material.direction.equals[X]||false>:
                - modifyblock <[b].relative[0,0,1]> air
                - modifyblock <[b].relative[0,0,-1]> air
        on player swaps items:
        - if <yaml[config].read[offhand.disallow].parse[to_uppercase].contains[<context.offhand.crackshot_weapon.to_uppercase||<context.offhand.script.name||<context.offhand.material.name>>>]>:
            - determine cancelled
        on block ignites ignorecancelled:true:
        - if <context.location.town||> == <context.entity.town||>:
            - determine cancelled:false
        - if <context.location.has_town.not>:
            - determine cancelled:false
        on block forms ignorecancelled:true:
        - determine cancelled:false
        on liquid spreads ignorecancelled:true:
        - if <context.location.chunk> == <context.destination.chunk>:
            - determine cancelled:false
        - if <context.location.town||null> == <context.destination.town||null>:
            - determine cancelled:false
        on entity damaged ignorecancelled:true:
        - if <player.name||null> == SuperTNT20 && <player.world.name.starts_with[arena]||false>:
            - determine cancelled:false
        on player joins:
        - determine NONE
        on player quits:
        - determine NONE
        on player receives message:
        - if <context.message.strip_color.starts_with[<&sp><&sp>Eg:<&sp>/tr<&sp>]>:
            - determine MESSAGE:<context.message.replace[/tr].with[/trs]>
        on redstone recalculated:
        - define loc <context.location.center>
        - ratelimit <[loc]> 2t
        - flag <[loc]> redstone:<[loc].flag[redstone].add[1]||1> duration:<yaml[config].read[lagcontrol.redstone.min_time_between_pulse].as_duration||<duration[1s]>>
        - define num <[loc].flag[redstone]>
        - if <[num].is_more_than[<yaml[config].read[lagcontrol.redstone.number_before_removal]||10>]>:
            - wait 1t
            - modifyblock <[loc]> air naturally:diamond_pickaxe
            - flag <[loc]> redstone:!
        on block ignites ignorecancelled:true bukkit_priority:monitor:
        - if <entity||null> == null:
            - stop
        - define entity <context.entity>
        - define location <context.location>
        - if <[entity].exists> && <context.entity.is_player>:
            - if <[location].has_town.not>:
                - determine cancelled:false
            - if <[entity].town> == <[location].town>:
                - determine cancelled:false
        on crackshot weapon damages entity:
        - if <player.is_inside_vehicle||false> && !<context.victim.is_inside_vehicle||false>:
            - determine passively cancelled
        on ender_pearl spawns:
        - stop
        - define pl <context.location.find_players_within[0.1].get[1]||null>
        - if <[pl]> != null:
            - adjust <queue> linked_player:<[pl]>
            - itemcooldown ender_pearl duration:<yaml[config].read[enderpearl.cooldown]>
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
        on crackshot player fires projectile:
        - if <player.is_sprinting>:
            - determine BULLET_SPREAD:<context.bullet_spread.mul[2]>
        on entity damages entity:
        - if <context.damager.fallingblock_material.name.contains_text[dripstone]||false>:
            - determine cancelled
        - if <context.projectile.entity_type||null> == ender_pearl:
            - determine <yaml[config].read[enderpearl.damage_when_teleported]>
        on entity teleports:
        - if <player||null> != null:
            - if <player.has_flag[going_home]>:
                - if <context.destination.town||null> != <player.town||null>:
                    - determine passively cancelled
        on player consumes item:
        - if <context.item.potion_base.starts_with[STRENGTH]||false> || <context.item.potion_base.starts_with[INVISIBILITY]||false>:
            - determine cancelled
        on potion splash:
        - if <context.potion.potion_base.starts_with[INSTANT_DAMAGE]||false> || <context.potion.potion_base.starts_with[STRENGTH]||false> || <context.potion.potion_base.starts_with[INVISIBILITY]||false>:
            - determine cancelled
        on lingering potion splash:
        - determine cancelled
        on entity death bukkit_priority:monitor:
        - if <context.entity.is_player>:
            - determine NO_MESSAGE
        - determine <context.drops.filter[material.name.is[!=].to[TRIDENT]]>