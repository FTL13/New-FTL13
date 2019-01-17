// Use this game mode how you want, it should only do some basic FTL setup and stuff.

/datum/game_mode/ftl
	name = "FTL basic gamemode"
	probability = 100 // for testing, so this one gets chosen every time
	
	config_tag = "ftl basic"
	report_type = "ftl_basic"
	
	announce_span = "notice"
	announce_text = "Have fun!"

/datum/game_mode/ftl/pre_setup()
	message_admins("Pre setup.")
	return 1

/datum/game_mode/ftl/post_setup(report)
	message_admins("Post setup [report]")
	gamemode_ready = TRUE
	return 1

/datum/game_mode/ftl/generate_report()
	message_admins("Generate report.")

/datum/game_mode/ftl/generate_station_goals()
	message_admins("Generate station goals.")

/datum/game_mode/ftl/send_intercept(report = 0)
	message_admins("Send intercept. [report]")