command_removelag:
    type: command
    name: removelag
    debug: false
    script:
    - if <player.has_permission[orbis.command.removelag]>:
        - announce "<&c>Preparing to remove lag."
        - define chunks <server.worlds.parse[loaded_chunks].combine.size>
        - define entities <server.worlds.parse[living_entities.filter[location.has_town.not]].combine.size>
        - remove <server.worlds.parse[living_entities.filter[location.has_town.not]].combine>
        - define threshold 50
        - define chunks <server.worlds.parse[loaded_chunks].combine>
        - foreach <[chunks]> as:c:
            - define i:+:1
            - if <[i].is_more_than_or_equal_to[<[threshold]>]>:
                - define i 0
                - wait 1t
            - adjust <[c]> force_loaded:false
        - remove <server.worlds.parse[living_entities.filter[location.has_town.not]].combine>
        - announce "<&c>Removed..."
        - announce "<&c> - <[chunks].sub[<server.worlds.parse[loaded_chunks].combine.size>]> chunks"
        - announce "<&c> - <[entities].sub[<server.worlds.parse[living_entities.filter[location.has_town.not]].combine.size>]> Living Entities"
    - else:
        - narrate "<&c>You do not have permission for that command."