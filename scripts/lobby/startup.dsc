
startup_handler:
    type: world
    debug: false
    events:
        on server start:
        - createworld lobby generator:Terra<&co>DEFAULT
        on player right clicks armor_stand:
        - if <player.has_permission[lobby.interact].not>:
	        - determine cancelled
        on delta time secondly:
        - stop
        - foreach <bungee.list_servers> as:s:
        	- ~bungeetag server:<[s]> <server.online_players> save:entry
            - define size:|::<entry[entry].result>
        - flag server network.players:<[size].combine>