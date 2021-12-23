relay_test:
  type: world
  debug: false
  events:
    on post request:
      - if <context.headers.get[X-full-uri]> == /webhooks/github/main && <context.headers.get[X-real-ip].starts_with[140.82.115.]>:
        - announce to_console "Pulling Github"
        - shell /home.minecraft/pull_github.sh
        - wait 5s
        - announce to_console "Reloading all servers"
        - bungeerun <bungee.list_servers> bungee_reload_all
      - else:
        - announce to_console "HEADERS: <context.headers>"