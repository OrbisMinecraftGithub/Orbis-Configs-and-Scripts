animal_lag_prevention:
    type: world
    debug: false
    data:
        types:
        - sheep
        - rabbit
        - cow
        - pig
    events:
        on delta time minutely every:10:
        - foreach <script.data_key[data.types]> as:animal_type:
            - remove <world[world].entities[<[animal_type]>].filter[location.has_town.not]>
            - wait 1s

chunk_lag_prevention:
    type: world
    debug: false
    events:
        on delta time minutely every:5:
        - if <server.worlds.parse[loaded_chunks].combine.size.is_more_than[50000]>:
            - foreach <server.worlds.parse[loaded_chunks].combine> as:c:
                - adjust <[c]> force_loaded:false
        on server start:
        - wait 1m
        - if <server.worlds.parse[loaded_chunks].combine.size.is_more_than[50000]>:
            - foreach <server.worlds.parse[loaded_chunks].combine> as:c:
                - adjust <[c]> force_loaded:false