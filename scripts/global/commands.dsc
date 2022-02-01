command_website:
    type: command
    name: web
    description: Visit the server website.
    usage: /web
    aliases:
    - website
    script:
    - narrate "<&6>Visit our website at <&click[https://orbismc.com/].type[OPEN_URL]><&e><&n>OrbisMC.com/<&end_click><&6>!"

command_store:
    type: command
    name: store
    description: Visit the server store.
    usage: /store
    script:
    - narrate "<&6>Visit our server store at <element[Store.Orb].color_gradient[from=#5764e1;to=#8affff].on_click[http://store.orbismc.com].type[OPEN_URL].on_hover[<&6>Buy <&e>ranks <&6>and <&e>perks<&6>!]><element[isMC.com].color_gradient[from=#8affff;to=#5764e1].on_click[http://store.orb].type[OPEN_URL].on_hover[<&6>Buy <&e>ranks <&6>and <&e>perks<&6>!]>"

command_rules:
    type: command
    name: rules
    description: See the server rules.
    usage: /rules
    script:
    - narrate "<&6>See our rules at <&click[https://orbismc.com/rules].type[OPEN_URL]><&e><&n>OrbisMC.com/rules<&end_click><&6>!"

blocked_commands:
    type: command
    name: pl
    aliases:
    - plugins
    - bukkit:pl
    - bukkit:plugins
    script:
    - narrate "<&c>You do not have permission for this command."

command_map:
    type: command
    name: map
    description: Visit the server map.
    usage: /map
    script:
    - narrate "<&6>Visit our server map at <&click[https://map.orbismc.com/].type[OPEN_URL]><&e><&n>Map.OrbisMC.com/<&end_click><&6>!"
