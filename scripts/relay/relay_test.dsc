relay_test:
  type: world
  debug: false
  events:
    on post request:
      - if <context.headers.get[X-full-uri]> == /webhooks/github/main && <context.headers.get[X-real-ip].starts_with[140.82.115.]>:
        - shell /home.minecraft/pull_github.sh