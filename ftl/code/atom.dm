/atom/proc/ftl_contents_explosion(severity, target)
	return //For handling the effects of explosions on contents that would not normally be effected

/atom/proc/ftl_ex_act(severity, target)
	set waitfor = FALSE
	ftl_contents_explosion(severity, target)