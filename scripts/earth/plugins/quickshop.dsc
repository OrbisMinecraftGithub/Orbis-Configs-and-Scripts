quickshop_events:
    type: world
    debug: false
    events:
        on player breaks block ignorecancelled:true:
        - if <context.location.town||null1> != <player.town>:
            - stop
        - if <player.town.assistants.include[<player.town.mayor>].deduplicate.filter[as_player.exists].contains[<player>].not>:
            - stop
        - if <context.location.material.name.ends_with[chest]> && <player.item_in_hand.material.name.equals[golden_axe]>:
            - adjust <context.location> remove_quickshop
        on player right clicks chest ignorecancelled:true bukkit_priority:monitor:
        - if !<context.location.has_town> && <player.has_permission[shop.access.wilderness]>:
            - determine cancelled:false
        - if <context.location.town.name||1> == <player.town.name||2> && <player.has_permission[shop.access.town]>:
            - determine cancelled:false