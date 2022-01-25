Spectator_only:
  type: world
  debug: false
  events:
    after player joins:
      - adjust <player> gamemode:spectator
    on player changes gamemode:
      - determine cancelled