// used for identifying artifacts but could probably be expanded for a bunch of other miscallenous uses

// artifact identification is specified in attackby in artifactprocs
/////////////////////////////////////////////////// Identification scroll ///////////////////////////////////

/obj/item/identification_scroll
	name = "Scroll of Identify"
	icon = 'icons/obj/scroll.dmi'
	icon_state = "identify_scroll"
	flags = FPRINT | TABLEPASS
	w_class = 2.0
	item_state = "paper"
	throw_speed = 4
	throw_range = 20
	var/used = 0
	desc = "An old scroll that reads KERNOD WEL"


	attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
		if(used == 0)
			used = 1
			playsound(user.loc, "sound/effects/flameswoosh.ogg", 100, 1)
			user.visible_message("<span style=\"color:red\">As [user.name] reads from the [name] it fades into ash!</span>")
			var/tmp/message = pick("Blessed", "Cursed", "Uncursed")
			user.visible_message("<span style=\"color:red\">That's [message] [M.name]!</span>")
			if(cmptext(message, "Blessed"))
				if(iscarbon(M) && M.reagents)
					M.reagents.add_reagent("glitter_harmless", 2)  //some fancy glitter on blessed people
			user.u_equip(src)
			src.dropped()
			qdel(src)