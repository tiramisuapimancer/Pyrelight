/mob/living/human
	var/_eye_colour

// Eyes! TODO, make these a marking.
/mob/living/human/get_eye_colour()
	// Force an evil red glow for undead mobs.
	if(stat == CONSCIOUS && has_trait(/decl/trait/undead))
		return COLOR_RED
	return _eye_colour

/mob/living/human/death(gibbed)
	. = ..()
	if(!QDELETED(src) && has_trait(/decl/trait/undead))
		var/obj/item/organ/external/head/head = get_organ(BP_HEAD)
		head.glowing_eyes = initial(head.glowing_eyes)
		update_eyes()

/mob/living/human/set_eye_colour(var/new_color, var/skip_update = FALSE)
	if((. = ..()))
		_eye_colour = new_color
		if(!skip_update)
			update_eyes()
			update_body()
