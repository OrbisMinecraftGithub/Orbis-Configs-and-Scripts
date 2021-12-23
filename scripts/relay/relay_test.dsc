relay_test:
  type: world
  debug: false
  events:
    on post request:
      - announce "REQUEST: <context.request>"
      - announce "QUERY: <context.query>"