
rules_data:
    type: data
    rules:
        1:
            name: World Rules.
            1:
                name: Teleport trapping.
                description:
                - Trapping your town spawn or nether portal to where a player will die and lose their items is not allowed as it griefs their gameplay.
                punishments:
                    1:
                        type: warn
                    2:
                        type: warn
                    3:
                        type: ban 12h
                    4:
                        type: ban 1d
                    5:
                        type: ban 3d
                    6:
                        type: assessment
            2:
                name: Stealing.
                description:
                - Stealing from a town, nations and players is allowed. It is up to each player to protect their personal assets.
                punishments: []
            3:
                name: Afking.
                description:
                - Using a method to afk so the anti-afk does not kick you is not allowed and will be punished.
                punishments:
                    1:
                        type: warn
                    2:
                        type: warn
                    3:
                        type: warn
                    4:
                        type: ban 1d
                    5:
                        type: ban 3d
                    6:
                        type: ban 10d
                    7:
                        type: assessment
            4:
                name: Wilderness griefing.
                description:
                - You are allowed to grief buildings found in the wilderness zone as long as they are not close to a town’s claim. However breaking ice ways, roads, railways or anything that connects one town to another town is not allowed. You must not grief these.
                punishments:
                    1:
                        type: warn
                        rollback: true
                    2:
                        type: ban 12h
                        rollback: true
                    3:
                        type: ban 1d
                        rollback: true
                    4:
                        type: ban 7d
                        rollback: true
                    5:
                        type: assessment
            5:
                name: Major Wilderness Terraforming.
                description:
                - This is not allowed as it will alter the Dynmap, if a player is found of doing this they will be warned and their terraforming will be removed. Major terraforming includes – Draining large lakes/rivers/seas, building platforms to cover the map.
                punishments: '?'
            6:
                name: Map Art.
                description:
                - Map Art is allowed as long as it is appropriate this mean that the map cannot contain the following... nudity, sexual contents, racist sexist or homophobic imagery. It also cannot interfere with other towns. If you have permission from the town mayor to build it close to his town then it is allowed.
                punishments:
                    1:
                        type: ban 12h
                        rollback: true
                    2:
                        type: ban 2d
                        rollback: true
                    3:
                        type: ban 7d
                        rollback: true
                    4:
                        type: ban 14d
                        rollback: true
                    5:
                        type: ban 7d
                        rollback: true
                    6:
                        type: assessment
            7:
                name: Lava Casting/Use of Lava/Water.
                description:
                - Using lava or water to grief is not allowed. Players can request a rollback if this happens.
                punishments:
                    1:
                        type: warn
                        rollback: true
                    2:
                        type: warn
                        rollback: true
                    3:
                        type: ban 12h
                        rollback: true
                    4:
                        type: ban 3d
                        rollback: true
                    5:
                        type: ban 7d
                        rollback: true
                    6:
                        type: assessment
            8:
                name: Lag Machines and Flying Machines.
                description:
                - Making Lag machines or flying machines is not allowed and could result in bans if found to be made.
                punishments:
                    1:
                        type: ban 30d
                        extra: Remove lag or flying machine.
                    2:
                        type: ban 60d
                        extra: Remove lag or flying machine.
                    3:
                        type: ban perm
                        extra: Remove lag or flying machine.
        2:
            name: Behaviour.
            1:
                name: Spamming.
                description:
                - Sending messages which disrupt chat flow is not allowed.
                punishments:
                    1:
                        type: warn
                    2:
                        type: mute 1h
                    3:
                        type: mute 3h
                    4:
                        type: mute 7h
                    5:
                        type: mute 12h
                    6:
                        type: mute 17h
                    7:
                        type: mute 1d
                    8:
                        type: mute 3d
                    9:
                        type: mute 7d
                    10:
                        type: assessment
            2:
                name: Unwanted Behaviour.
                1:
                    name: Usage of derogatory Terms.
                    description: []
                    punishments:
                        1:
                            type: mute 7d
                            clear_chat: true
                        2:
                            type: mute 14d
                            clear_chat: true
                        3:
                            type: mute 30d
                            clear_chat: true
                2:
                    name: Explicit Talk about nsfw.
                    description:
                    - Explicit Talk about Sex, alcohol, drugs and topics related to this.
                    punishments:
                        1:
                            type: mute 3d
                            clear_chat: true
                        2:
                            type: mute 7d
                            clear_chat: true
                        3:
                            type: mute 14d
                            clear_chat: true
                        4:
                            type: mute 30d
                            clear_chat: true
                3:
                    name: Forms Of Bullying.
                    description: []
                    punishments:
                        1:
                            type: mute 3d
                            clear_chat: true
                        2:
                            type: mute 7d
                            clear_chat: true
                        3:
                            type: mute 14d
                            clear_chat: true
                        4:
                            type: mute 30d
                            clear_chat: true
                4:
                    name: Inciting violence or explicit forms of hate speech.
                    description:
                    - Inciting violence or explicit forms of hate speech against racial and social minorities. This includes discrimination, racism, sexism, homophobia, etc.
                    punishments:
                        1:
                            type: mute 7d
                            clear_chat: true
                        2:
                            type: mute 14d
                            clear_chat: true
                        3:
                            type: mute 30d
                            clear_chat: true
            3:
                name: Language used in chats.
                description:
                - We insist that you stick to using English in global chat (General and Trade) at all times, however we do allow you to talk in different languages in other chats for example local, town and nation.
                punishments:
                    1:
                        type: warn
                    2:
                        type: mute 1h
                    3:
                        type: mute 3h
                    4:
                        type: mute 7h
                    5:
                        type: mute 12h
                    6:
                        type: mute 17h
                    7:
                        type: mute 1d
                    8:
                        type: mute 3d
                    9:
                        type: mute 7d
                    10:
                        type: assessment
            4:
                name: Sharing Links.
                description:
                - Sending links is not allowed to protect our players from things like ip-loggers, this does not just include sending links in the server but if you are found sending malicious links to people on applications like discord you will be punished as well.
                punishments:
                    1:
                        type: mute 1d
                        clear_chat: true
                    2:
                        type: mute 3d
                        clear_chat: true
                    3:
                        type: mute 7d
                        clear_chat: true
                    4:
                        type: mute 14d
                        clear_chat: true
                    5:
                        type: mute 30d
                        clear_chat: true
            5:
                name: Advertising.
                description:
                - Advertising is allowed if it’s related to the server, for example advertising your shop. However, advertising other servers is not allowed.
                punishments:
                    1:
                        type: warn
                    2:
                        type: mute 1h
                    3:
                        type: mute 3h
                    4:
                        type: mute 7h
                    5:
                        type: mute 12h
                    6:
                        type: mute 17h
                    7:
                        type: mute 1d
                    8:
                        type: mute 3d
                    9:
                        type: mute 7d
                    10:
                        type: assessment
            6:
                name: Personal Details/Information.
                description:
                - Sharing personal information without the user giving you permission is strictly forbidden, this includes – home addresses, phone numbers, social media networks that the player is on, occupation location, family relations, IP-Address, pictures of the person.
                punishments:
                    1:
                        type: ban perm
            7:
                name: Impersonation.
                description:
                - Impersonating a member or staff in chat is not allowed.
                punishments:
                    1:
                        type: warn
                    2:
                        type: warn
                    3:
                        type: ban 1d
                    4:
                        type: ban 3d
                    5:
                        type: ban 7d
                    6:
                        type: ban 14d
            8:
                name: Selling items/services/items for real life money.
                description:
                - Players are not allowed to sell in-game items or services for real life money, however players are allowed to trade for in-game ranks. For example an item for Vip rank.
                punishments:
                    1:
                        type: ban perm
            9:
                name: Bypassing Chat-filter.
                description:
                - Bypassing Chat-filter is not allowed as it is there to protect our players and ensure no-one feels hurt.
                punishments:
                    1:
                        type: warn
                    2:
                        type: mute 1h
                    3:
                        type: mute 3h
                    4:
                        type: mute 7h
                    5:
                        type: mute 12h
                    6:
                        type: mute 17h
                    7:
                        type: mute 1d
                    8:
                        type: mute 3d
                    9:
                        type: mute 7d
                    10:
                        type: assessment
            10:
                name: Self Harm.
                description:
                - Discussing topics like self-harm is not allowed and will result in a major punishment.
                punishments:
                    1:
                        type: mute 6h
                    2:
                        type: mute 12h
                    3:
                        type: mute 1d
                    4:
                        type: mute 3d
                    5:
                        type: mute 7d
                    6:
                        type: mute 10d
                    7:
                        type: mute 14d
                    8:
                        type: mute 21d
                    9:
                        type: mute perm
        3:
            name: Limitations.
            1:
                name: Alternate Accounts.
                description:
                - Alternate Accounts (alts) are forbidden. Each player is allowed an account. If a player is found to be using an alternate account to gain an in-game advantage or to bypass a ban the players Alternate Account and their main account will be banned.
                punishments:
                    1:
                        type: warn
                    2:
                        type: ban perm
            2:
                name: Clients and Modifications to gain an advantage.
                description:
                - Cheat clients otherwise known as “hacked clients”, macros and other modifications to vanilla minecraft that give you an advantage on gameplay are not allowed.
                - This rule does not apply to the following...
                - Lunar/Badlion clients modifications
                - Optifine
                - Clients which improve performance
                - Litematica (excluding printing which is not allowed)
                - Minimap Mods which show no more then the Dynmap this means that the mini-map does not show Players, Caves and Mobs
                punishments:
                    1:
                        type: ban 7d
                    2:
                        type: ban 30d
                    3:
                        type: ban 60d
                    4:
                        type: ban 90d
                    5:
                        type: ban perm
            3:
                name: Exploiting.
                description:
                - Players intentionally exploiting from: hacks, rules, glitches, exploits found in-game will be punished.
                punishments:
                    1:
                        type: warn
                    2:
                        type: ban 12h
                    3:
                        type: ban 1d
                    4:
                        type: ban 3d
                    5:
                        type: ban 7d
                    6:
                        type: ban 14d
            4:
                name: Game Glitches.
                description:
                - Using in-game bugs,exploits for example duping is not allowed.
                punishments:
                    1:
                        type: warn
                    2:
                        type: ban 12h
                    3:
                        type: ban 1d
                    4:
                        type: ban 3d
                    5:
                        type: ban 7d
                    6:
                        type: ban 14d
            5:
                name: Duplicating items using Game Glitches.
                description: []
                punishments:
                    1:
                        type: ban perm
        4:
            name: Towny Rules.
            1:
                name: Town Claiming.
                description:
                - Creating a town for the intentions to block another town’s ability to claim more plots is not allowed.
                - Making straight line claims (claims arms extending from towns) is not allowed. Creating claims around a cost line or river line is allowed.
                - Connecting town claims is allowed as long as players can start sieges at 50% or more of your town’s border. Staff will assess if the town is set up to be unreasonably hard to siege.
                - Towns are not allowed to have unclaimed areas inside of their borders as this can increase the town’s size on Dynmap significantly.
                punishments:
                    1:
                        type: warn
                        rollback: true
                    2:
                        type: ban 3d
                        rollback: true
                    3:
                        type: ban 7d
                        rollback: true
                    4:
                        type: ban 14d
                        rollback: true
                    5:
                        type: ban 30d
                        rollback: true
            2:
                name: Destroying land around a town.
                description:
                - Players may not damage land around a 3-chunk radius of town’s claims. Players caught breaking this rule will be warned and if it is continued it may result in ban.
                - Placing or removing blocks at a siege event is allowed when it is necessary, after the siege event if the siege area is badly griefed town mayors can request a rollback.
                punishments:
                    1:
                        type: warning
                        rollback: true
                    2:
                        type: ban 3d
                        rollback: true
                    3:
                        type: ban 7d
                        rollback: true
                    4:
                        type: ban 14d
                        rollback: true
            3:
                name: Camping towns.
                description:
                - Staying in or around a town’s claims with an intent to kill someone from it for more than 20 minutes is camping a town. A player can report you for this and there is a chance that you’ll get punished for it.
                punishments: TODO
            4:
                name: Toggling Pvp
                description:
                - Toggling pvp in the town is not allowed however it can be done if the player is give a 20 second notice.
                punishments: TODO
        5:
            name: Sieges/PVP
            1:
                name: Underground capping.
                description:
                - Players are not allowed to cap a siege banner in a closed area.
                punishments: TODO
            2:
                name: Point Feeding.
                description:
                - Point Feeding is not allowed, a player is not allowed to intentionally die at a siege banner just to give advantage to the opposing side. This will be investigated by the staff team if the player makes a support ticket about the case. If there was major point feeding found there may be a chance that the points and the siege is reset.
                - Players who encourage others to point feed at banners for example by paying them in-game items and currency will be punished alongside the point feeder.
                punishments: TODO
            3:
                name: Sieging a Town for immunity.
                description:
                - People found to be besieging a town just to give that town immunity from sieges will be punished if they’re reported to staff by opening a support ticket or if spotted by a staff member.
                punishments: TODO
            4:
                name: Pulling Military Rank.
                description:
                - Taking away someone’s military rank at a siege zone for the reason so you will not lose points is not allowed and both players will be punished
                punishments: TODO
            5:
                name: Engaging in PVP.
                description:
                - After a player has killed someone they are advised not to attack that player unless they engage them in combat however Players are allowed to kill the same people 3 times a hour.
                punishments: TODO
            6:
                name: In-Game cosmetics.
                description:
                - Using cosmetics at a siege zone is not allowed as it can distract players and also make pvp easier for the person using them.
                punishments: TODO
            7:
                name: Siege Towns
                description:
                - Claiming land for the intention of gaining an advantage in siege which is located in a siege zone is not allowed. A town can be used to spawn to a siege however must be atleast 20 chunks away from the besieged town.
                punishments: TODO
        6:
            name: Naming
            1:
                name: Naming nations/towns.
                description:
                - Before Creating a nation or a town we encourage the player to make sure that their chosen name complies with our name policy. The following rules are...
                - Nations or Towns cannot be named after a real-life terrorist organisation
                - They cannot be named after Nazi Germany or the Ussr this includes variants of these names for example | The Third Reich|
                - Do not name your nation or town after a discriminatory phrase
                - Names cannot be toxic/offensive
                punishments: TODO
            2:
                name: Minecraft Accounts.
                description:
                - The following things are not allowed to be inappropriate, offensive, anything related to nsfw or to advertise something...
                - Usernames
                - Nicknames
                - Player Skins
                - Towny Titles
                punishments: TODO
