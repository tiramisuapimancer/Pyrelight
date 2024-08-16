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
	var/mob/living/transformation_mob_type

/obj/item/clothing/mask/ghost_caul/get_preview_screen_locs()
	var/static/list/override_preview_screen_locs = list(
		"1" = "character_preview_map:1,4:36",
		"2" = "character_preview_map:1,3:31",
		"4" = "character_preview_map:1,2:26",
		"8" = "character_preview_map:1,1:21"
	)
	return override_preview_screen_locs

// Used to provide wyrdling mob preview.
/obj/item/clothing/mask/ghost_caul/adjust_mob_overlay(mob/living/user_mob, bodytype, image/overlay, slot, bodypart, use_fallback_if_icon_missing)
	if(overlay && (istype(user_mob, /mob/living/human/dummy) || istype(loc, /mob/living/human/dummy)))
		var/mutable_appearance/faux = new /mutable_appearance(transformation_mob_type)
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
	// TODO
	to_chat(user, SPAN_WARNING("You attempt to veer into your [transformation_mob_type::name] semblance, but find yourself strangely unable."))
	return TRUE

/obj/item/clothing/mask/ghost_caul/fox
	name                    = "fox mask"
	transformation_trait    = /decl/trait/wyrd/wild/animal_form/fox
	transformation_mob_type = /mob/living/simple_animal/passive/fox

/obj/item/clothing/mask/ghost_caul/deer
	name                    = "deer mask"
	transformation_trait    = /decl/trait/wyrd/wild/animal_form/deer
	transformation_mob_type = /mob/living/simple_animal/passive/deer

/obj/item/clothing/mask/ghost_caul/rabbit
	name                    = "rabbit mask"
	transformation_trait    = /decl/trait/wyrd/wild/animal_form/rabbit
	transformation_mob_type = /mob/living/simple_animal/passive/rabbit

/obj/item/clothing/mask/ghost_caul/bear
	name                    = "bear mask"
	transformation_trait    = /decl/trait/wyrd/wild/animal_form/bear
	transformation_mob_type = /mob/living/simple_animal/hostile/bear
