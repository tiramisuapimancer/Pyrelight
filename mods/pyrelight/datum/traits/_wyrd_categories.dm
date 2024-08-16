// TODO: actual effects
/decl/trait/wyrd/fire
	name = "Burning Sign"
	description = "Affinity for the New School of alchemical working (energy, force, fire, lightning). TODO."
	incompatible_with = list(
		/decl/trait/wyrd/deep,
		/decl/trait/wyrd/sky,
		/decl/trait/wyrd/wild,
		/decl/trait/wyrd/flesh
	)
	uid = "trait_wyrd_flame"

/decl/trait/wyrd/sky
	name = "Sky Sign"
	description = "Affinity for the sun, moon and stars, cold, air, wind, light, sky. Associated with the magical traditions of the Steppe and Nine Mothers. TODO."
	incompatible_with = list(
		/decl/trait/wyrd/deep,
		/decl/trait/wyrd/fire,
		/decl/trait/wyrd/wild,
		/decl/trait/wyrd/flesh
	)
	uid = "trait_wyrd_sky"

/decl/trait/wyrd/deep
	name = "Hollow Sign"
	description = "Affinity for stone, darkness, the depths, the earth. Associated with the magical traditions of kobaloi and dvergr. TODO."
	incompatible_with = list(
		/decl/trait/wyrd/sky,
		/decl/trait/wyrd/fire,
		/decl/trait/wyrd/wild,
		/decl/trait/wyrd/flesh
	)
	uid = "trait_wyrd_hollow"

/decl/trait/wyrd/flesh
	name = "Rose Sign"
	description = "Affinity for blood, flesh, bone - healing, necromancy, blood alchemy, manipulation of living material. TODO."
	incompatible_with = list(
		/decl/trait/wyrd/sky,
		/decl/trait/wyrd/fire,
		/decl/trait/wyrd/wild,
		/decl/trait/wyrd/deep
	)
	uid = "trait_wyrd_flesh"

/decl/trait/wyrd/wild
	name = "Wild Sign"
	description = "A wyrdling is a human whose soul has been touched by the primeveal \
	anima of the wilds, carried down through blood and manifesting in strange ways. The \
	wyrdmarked are often treated with mistrust or fear by the general populace, leading \
	many to cover their wyrdmarks and hide their nature."
	permitted_species = list(SPECIES_HUMAN)
	uid = "trait_wyrd_wild"
	incompatible_with = list(
		/decl/trait/wyrd/fire,
		/decl/trait/wyrd/sky,
		/decl/trait/wyrd/deep,
		/decl/trait/wyrd/flesh
	)
