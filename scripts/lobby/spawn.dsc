spawn_in_spawn:
	type: world
    debug: false
    events:
    	on player join:
        - teleport <player> <world[lobby].spawn_location.add[<location[0.5,0,0.5]>].center>
        - wait 1t
        - adjust <player> gamemode:adventure
        
command_website:
	type: command
    name: web
    description: Visit the server website.
    usage: /web
    aliases:
    - website
    script:
    - narrate "<&e>Visit our website at <&click[https://orbismc.com/].type[OPEN_URL]><&l><&n>OrbisMC.com/<&end_click>"

command_store:
	type: command
    name: store
    description: Visit the server store.
    usage: /store
    script:
    - narrate "<&e>Visit our server store at <&click[https://store.orbismc.com/].type[OPEN_URL]><&l><&n>Store.OrbisMC.com/<&end_click>"

command_rules:
	type: command
    name: rules
    description: See the server rules.
    usage: /rules
    script:
    - narrate "<&e>See our rules at <&click[https://orbismc.com/rules].type[OPEN_URL]><&l><&n>OrbisMC.com/rules<&end_click>"
    
blocked_commands:
	type: command
    name: pl
    aliases:
    - plugins
    - bukkit:pl
    - bukkit:plugins
    script:
    - narrate "<&c>You do not have permission for this command."
    