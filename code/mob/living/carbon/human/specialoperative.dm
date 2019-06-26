// for assjam, from Gerhazo. Features a tranquilizer pistol, a 12 ammo tranquilizer clip, both using the safari kit tranq darts(sodium tiophental) and a new misc. antagonist human subtype similar to macho, a stealth operative with a sneaking suit, forementioned pistol, some other miscallenous gear and automatic counter-melee parrying and disarming capability ///
// extremely powerful in melee fights, however as frail to ranged gunfire as anyone else
/obj/item/ammo/bullets/tranq_darts/syndicate/clip
	icon_state = "pistol_clip"
	name = ".308 tranquilizer darts clip"
	amount_left = 12
	max_amount = 12

/obj/item/gun/kinetic/tranq_pistol
	name = "Tranquilizer Pistol"
	desc = "A handgun with an integrated flash and noise suppressor with the capability of firing tranquilizer darts for non-lethal takedowns."
	icon_state = "silenced"
	w_class = 2
	silenced = 1
	force = 7
	caliber = 0.308
	max_ammo_capacity = 12
	auto_eject = 1

	New()
		ammo = new/obj/item/ammo/bullets/tranq_darts/syndicate/clip //sodium thiopental darts
		current_projectile = new/datum/projectile/bullet/tranq_dart/syndicate
		..()




/mob/living/carbon/human/specialoperative

	var/melee_parry_chance = 65  //BASICS OF CQC

	New()
		..()

		spawn(0)
		if(src.bioHolder && src.bioHolder.mobAppearance)
			src.bioHolder.mobAppearance.customization_first = "Trimmed"
			src.bioHolder.mobAppearance.customization_second = "Full Beard"

			spawn(10)
				src.bioHolder.mobAppearance.UpdateMob()

		src.real_name = pick("Solid", "Solidus", "Liquid", "Gas", "Plasma", "Punished", "Naked") + " " + pick("Snake", "Serpent", "Cobra", "Anaconda", "Viper")

		src.equip_if_possible(new /obj/item/clothing/shoes/swat(src), slot_shoes)
		src.equip_if_possible(new /obj/item/clothing/under/misc/syndicate(src), slot_w_uniform)
		src.equip_if_possible(new /obj/item/clothing/suit/armor/sneaking_suit(src), slot_wear_suit)
		src.equip_if_possible(new /obj/item/storage/fanny(src), slot_belt)
		src.equip_if_possible(new /obj/item/device/radio/headset(src), slot_ears)
		src.equip_if_possible(new /obj/item/clothing/gloves/swat(src), slot_gloves)

		src.equip_if_possible(new /obj/item/gun/kinetic/tranq_pistol(src), slot_in_belt)
		src.equip_if_possible(new /obj/item/ammo/bullets/tranq_darts/syndicate/clip(src), slot_in_belt)
		src.equip_if_possible(new /obj/item/medical/bruise_pack(src), slot_in_belt)
		src.equip_if_possible(new /obj/item/medical/ointment(src), slot_in_belt)
		src.equip_if_possible(new /obj/item/reagent_containers/emergency_injector/epinephrine, slot_in_belt)
		src.equip_if_possible(new /obj/item/handcuffs/tape_roll(src), slot_in_belt)
		src.equip_if_possible(new /obj/item/breaching_charge/thermite(src), slot_r_store)

		var/obj/item/paper/pocketpaper = new /obj/item/paper(src)
		pocketpaper.name = "refresher"
		pocketpaper.info = "This document is a summary of the equipment you've been provided with for this mission, [src.real_name]. We know you're a pro, but it doesn't hurt to be prepared. Inside your fanny pack you will find a tranquilizer pistol loaded with 12 tranquilizer darts, along with a spare clip to reload. The payload is sodium thiopental, a single dart of which will put someone out of commision for a short while in a matter of seconds and two will ensure they stay there for quite a bit. You will also find an assortment of medicine as well as a roll of duct tape to restrain targets. Lastly, there is an extremely powerful breaching charge in your pocket. It's not discreet, but it gets the job done if you ever need to breach an area quick and loud. You've also been provided a headset with access to the general radio channel. To move around the operation site, you will need to procure appropriate ID cards from the local personnel. They might try to fight back, but your pistol should pacify them. Your CQC training will let you easily win any melee encounter, but don't get overconfident since you're as vulnerable as anyone else against any kind of ranged weaponry. Good luck."
		pocketpaper.icon_state = "paper"
		src.equip_if_possible(pocketpaper, slot_l_store)


	show_inv(mob/user)
		if (user != src && !src.stat && prob(melee_parry_chance))
			specop_parry(user)
			return
		..()
		return

	attack_hand(mob/user)
		if (user != src && !src.stat && prob(melee_parry_chance))
			src.visible_message("<span style=\"color:red\"><B>[user] attempts to attack [src]!</B></span>")
			playsound(src.loc, "sound/weapons/punchmiss.ogg", 50, 1)  // todo: might also be a missing sound, I think? this is when you punch open air with regular fists special attack
			sleep(2)
			specop_parry(user)
			return
		..()
		return

	attackby(obj/item/W, mob/user)
		if (user != src && !src.stat && prob(melee_parry_chance))  // was also checking for !src.weakened but modern goon has a different system for these things *shrug
			src.visible_message("<span style=\"color:red\"><B>[user] swings at [src] with the [W.name]!</B></span>")
			playsound(src.loc, "sound/weapons/punchmiss.ogg", 50, 1) // todo: might also be a missing sound, I think? this is when you punch open air with regular fists special attack
			sleep(2)
			specop_parry(user, W)
			return
		..()
		return



	proc/specop_parry(mob/M, obj/item/W) // heavily based on macho parry, but with the wrestling strike for countering punches
		if (M)
			src.dir = get_dir(src, M)
			if (W)
				W.cant_self_remove = 0
				W.set_loc(src)
				M.u_equip(W)
				W.layer = HUD_LAYER
				src.put_in_hand_or_drop(W)
				src.visible_message("<span style=\"color:red\"><B>[src] grabs the [W.name] out of [M]'s hands, shoving [M] to the ground!</B></span>")

				M.changeStatus("weakened", max(50, M.getStatusDuration("weakened")))

				playsound(src.loc, "sound/weapons/thudswoosh.ogg", 65, 1) // todo: incorrect/missing soundpath since 2016, this is the grab sound
			else
				//src.visible_message("<span style=\"color:red\"><B>[src] parries [M]'s attack, knocking them to the ground!</B></span>")
				var/turf/T = get_turf(src)
				if (T && isturf(T) && M && isturf(M.loc))
					playsound(src.loc, "swing_hit", 50, 1)

					spawn (0)
						for (var/i = 0, i < 4, i++)
							src.dir = turn(src.dir, 90)

						src.set_loc(M.loc)
						spawn (4)
							if (src && (M && isturf(M) && get_dist(M, src) <= 1))
								src.set_loc(M)

					src.visible_message("<span style=\"color:red\"><b>[src] pushes [M]'s arm to the side and counters with a karate chop!</b></span>")
					random_brute_damage(M, 10)
					playsound(src.loc, "sound/effects/fleshbr1.ogg", 75, 1) // todo: incorrect/missing soundpath since  2016, this is the suplex bone-breaking sound

					M.changeStatus("weakened", max(50, M.getStatusDuration("weakened")))
					M.change_misstep_chance(25)
		return