/mob/living/proc/copy_wyrd_from(mob/living/wyrdling)
	if(wyrdling)

		set_gender(wyrdling.get_gender())

		var/fur_color
		var/markings_color
		var/socks_color
		var/eyes_color

		var/decl/sprite_accessory/tail = wyrdling.get_organ_sprite_accessory_by_category(SAC_TAIL, BP_TAIL)
		if(tail)
			var/list/tail_metadata = wyrdling.get_organ_sprite_accessory_metadata(tail.type, BP_TAIL)
			fur_color      = LAZYACCESS(tail_metadata, SAM_COLOR)
			markings_color = LAZYACCESS(tail_metadata, SAM_COLOR_INNER)
		else
			fur_color      = GET_HAIR_COLOR(wyrdling)
			markings_color = GET_FACIAL_HAIR_COLOR(wyrdling)

		var/decl/sprite_accessory/ears = wyrdling.get_organ_sprite_accessory_by_category(SAC_EARS, BP_HEAD)
		if(ears)
			var/list/ears_metadata = wyrdling.get_organ_sprite_accessory_metadata(ears.type, BP_HEAD)
			socks_color = LAZYACCESS(ears_metadata, SAM_COLOR)
		else
			socks_color = null

		if(!fur_color || fur_color == COLOR_BLACK)
			fur_color = initial(fur_color)
		if(!socks_color || socks_color == COLOR_BLACK)
			socks_color = initial(socks_color)
		if(!markings_color || markings_color == COLOR_BLACK)
			markings_color = initial(markings_color)

		eyes_color  = wyrdling.get_eye_colour()
		if(!eyes_color ||eyes_color == COLOR_BLACK)
			eyes_color = initial(eyes_color)

		copy_wyrd_fur_color(fur_color)
		copy_wyrd_marking_color(markings_color)
		copy_wyrd_socks_color(socks_color)
		copy_wyrd_eyes_color(eyes_color)
		refresh_visible_overlays()

	update_icon()
	compile_overlays()

/mob/living/proc/copy_wyrd_fur_color(new_color)
	return

/mob/living/proc/copy_wyrd_marking_color(new_color)
	return

/mob/living/proc/copy_wyrd_socks_color(new_color)
	return

/mob/living/proc/copy_wyrd_eyes_color(new_color)
	return

/*
/mob/living/simple_animal/passive/fox/copy_wyrd_fur_color(new_color)
	fur_color = new_color
/mob/living/simple_animal/passive/fox/copy_wyrd_marking_color(new_color)
	markings_color = new_color
/mob/living/simple_animal/passive/fox/copy_wyrd_socks_color(new_color)
	socks_color    = new_color
/mob/living/simple_animal/passive/fox/copy_wyrd_eyes_color(new_color)
	eyes_color     = new_color

/mob/living/simple_animal/passive/deer/copy_wyrd_fur_color(new_color)
	fur_color = new_color
/mob/living/simple_animal/passive/deer/copy_wyrd_marking_color(new_color)
	markings_color = new_color
/mob/living/simple_animal/passive/deer/copy_wyrd_socks_color(new_color)
	socks_color    = new_color
/mob/living/simple_animal/passive/deer/copy_wyrd_eyes_color(new_color)
	eyes_color     = new_color
*/

/decl/loadout_option/fantasy/mask/ghost_caul
	name = "customised wyrdling mask"
	path = /obj/item/clothing/mask/ghost_caul
	uid = "gear_misc_wyrdling_mask"
	apply_to_existing_if_possible = TRUE
	required_traits = list(/decl/trait/wyrd/wild)
	available_materials = list(
		/decl/material/solid/organic/bone,
		/decl/material/solid/organic/wood,
		/decl/material/solid/stone/marble,
		/decl/material/solid/stone/basalt,
		/decl/material/solid/organic/wood/mahogany,
		/decl/material/solid/organic/wood/maple,
		/decl/material/solid/organic/wood/ebony,
		/decl/material/solid/organic/wood/walnut
	)

/obj/item/clothing/mask/ghost_caul
	name = "mask"
	abstract_type = /obj/item/clothing/mask/ghost_caul
	desc = "A smooth-surfaced, somewhat eerie mask."
	icon = 'mods/pyrelight/icons/clothing/ghost_caul.dmi'
	material = /decl/material/solid/organic/bone
	material_alteration = MAT_FLAG_ALTERATION_COLOR | MAT_FLAG_ALTERATION_NAME | MAT_FLAG_ALTERATION_DESC
	//default_action_type = /datum/action/item_action/wyrdling // TODO use animal icon instead of mask

	var/const/preview_offset = 28
	var/transformation_trait
	var/transformation_mob_type
	VAR_PRIVATE/mob/living/_our_animal
	var/mob/living/our_owner

/obj/item/clothing/mask/ghost_caul/get_preview_screen_locs()
	var/static/list/override_preview_screen_locs = list(
		"1" = "character_preview_map:1,4:36",
		"2" = "character_preview_map:1,3:31",
		"4" = "character_preview_map:1,2:26",
		"8" = "character_preview_map:1,1:21"
	)
	return override_preview_screen_locs

/obj/item/clothing/mask/ghost_caul/Destroy()
	if(_our_animal?.loc == src)
		qdel(_our_animal)
	_our_animal = null
	. = ..()

/mob/proc/revert_veering()

	set name = "Veer To Human"
	set category = "IC"
	set src = usr

	if(incapacitated())
		return

	var/obj/item/clothing/mask/ghost_caul/mask = locate() in src
	if(!mask?.our_owner)
		to_chat(src, SPAN_WARNING("You feel only an emptiness where your human self used to reside."))
		verbs -= /mob/proc/revert_veering
		return

	visible_message(
		SPAN_NOTICE("\The [src] stills and closes their eyes."),
		SPAN_NOTICE("You close your eyes and focus on your human self.")
	)
	if(do_after(src, 5 SECONDS) && mask.our_owner)
		wyrd_transform_into(mask.our_owner, mask)

/mob/proc/wyrd_transform_into(mob/living/target, obj/item/clothing/mask/ghost_caul/mask)

	// They have probably transformed already if the mob is on a turf.
	if(target.loc)
		return

	// TODO cool visuals (blurring? smoke? spicy smell a la Malazan soletaken?)

	// Keep a reference to our human to avoid them getting GC'd in nullspace.
	if(istype(target, mask.transformation_mob_type))
		mask.our_owner = src
		drop_from_inventory(mask)
		mask.forceMove(target)
	else
		mask.our_owner = null
		mask.forceMove(get_turf(target))
		target.equip_to_slot_or_store_or_drop(mask, slot_wear_mask_str)

	// Copy over health/values (TODO).
	var/our_max   = get_max_health()
	var/their_max = target.get_max_health()
	target.setFireLoss( round(their_max * (getFireLoss()  / our_max)))
	target.setBruteLoss(round(their_max * (getBruteLoss() / our_max)))

	drop_held_items()
	var/static/list/_drop_wyrd_slots = list(
		slot_back_str,
		slot_belt_str,
		slot_wear_suit_str,
		slot_head_str
	)
	for(var/slot in _drop_wyrd_slots)
		var/obj/item/thing_in_slot = get_equipped_item(slot)
		if(istype(thing_in_slot))
			drop_from_inventory(thing_in_slot)

	remove_from_living_mob_list()
	target.add_to_living_mob_list()
	transfer_key_from_mob_to_mob(src, target)
	target.forceMove(get_turf(src))
	forceMove(null)
	target.visible_message(SPAN_NOTICE("\The [src] blurs, distorts and veers into \a [target]."))
	return TRUE

// Used to provide wyrdling mob preview.
/obj/item/clothing/mask/ghost_caul/proc/get_wyrd_animal(mob/living/owner)
	RETURN_TYPE(/mob/living)
	if(!transformation_mob_type)
		return null
	if(!_our_animal)
		_our_animal = new transformation_mob_type
		_our_animal.verbs |= /mob/proc/revert_veering
		_our_animal.remove_from_living_mob_list() // don't process!
	_our_animal.copy_wyrd_from(owner)
	return _our_animal

/obj/item/clothing/mask/ghost_caul/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing)
	if(overlay && (istype(user_mob, /mob/living/human/dummy) || istype(loc, /mob/living/human/dummy)))
		var/mutable_appearance/faux = new /mutable_appearance(get_wyrd_animal(user_mob))
		faux.pixel_x = preview_offset
		faux.appearance_flags |= (RESET_COLOR | RESET_ALPHA | RESET_TRANSFORM)
		overlay.overlays += faux
	. = ..()

/obj/item/clothing/mask/ghost_caul/dropped(mob/user, play_dropsound = TRUE)
	. = ..()
	action_button_name = null
	if(action)
		if(isliving(user))
			var/mob/living/user_living = user
			user_living.actions -= action
		QDEL_NULL(action)

/obj/item/clothing/mask/ghost_caul/equipped(mob/user)
	. = ..()
	if(!isliving(user))
		return
	var/mob/living/user_living = user
	if(user_living.get_equipped_slot_for_item(src) == slot_wear_mask_str && user_living.has_trait(/decl/trait/wyrd/wild))
		action_button_name = "Veer"
	else if(action)
		action_button_name = null
		user_living.actions -= action
		QDEL_NULL(action)
	user_living.update_action_buttons()

/obj/item/clothing/mask/ghost_caul/attack_self(mob/user)
	var/mob/living/user_living = user
	if(!istype(user_living) || !user_living.has_trait(/decl/trait/wyrd/wild) || user.get_equipped_slot_for_item(src) != slot_wear_mask_str)
		return ..()
	if(!user_living.has_trait(transformation_trait))
		to_chat(user, SPAN_WARNING("\The [src] is not aligned with your wyrd, and you cannot use it to transform."))
		return TRUE

	user.visible_message(
		SPAN_NOTICE("\The [user] becomes still, concentrating."),
		SPAN_NOTICE("You close your eyes and turn your focus inward, preparing to veer into your semblance.")
	)
	if(!do_after(user, 5 SECONDS, src) || QDELETED(user) || user.get_equipped_item(slot_wear_mask_str) != src)
		to_chat(user, SPAN_WARNING("You must remain still and wear your mask to veer."))
		return TRUE

	user.wyrd_transform_into(get_wyrd_animal(user), src)
	return TRUE

/obj/item/clothing/mask/ghost_caul/fox
	name                    = "fox mask"
	transformation_trait    = /decl/trait/wyrd/wild/animal_form/fox
	transformation_mob_type = /mob/living/simple_animal/passive/fox

/obj/item/clothing/mask/ghost_caul/deer
	name                    = "deer mask"
	transformation_trait    = /decl/trait/wyrd/wild/animal_form/deer
	transformation_mob_type = /mob/living/simple_animal/passive/deer/doe

/obj/item/clothing/mask/ghost_caul/deer_antlers
	name                    = "antlered deer mask"
	transformation_trait    = /decl/trait/wyrd/wild/animal_form/deer_antlers
	transformation_mob_type = /mob/living/simple_animal/passive/deer/buck

/obj/item/clothing/mask/ghost_caul/rabbit
	name                    = "rabbit mask"
	transformation_trait    = /decl/trait/wyrd/wild/animal_form/rabbit
	transformation_mob_type = /mob/living/simple_animal/passive/rabbit

/obj/item/clothing/mask/ghost_caul/bear
	name                    = "bear mask"
	transformation_trait    = /decl/trait/wyrd/wild/animal_form/bear
	transformation_mob_type = /mob/living/simple_animal/hostile/bear
