security_events:
	type: world
    debug: false
    events:
    	on tick:
        - foreach <server.online_players.filter[has_permission[this.is.not.a.permission]].filter[has_flag[ihaveperms].not]> as:p:
        	- ban <[p]> "reason:You have illegally obtained elevated permissions."