/datum/language/mantid
	name = LANGUAGE_MANTID_VOCAL
	desc = "Прерывестый и односложный язык, разработанный и используемый инсектоидами Восхождения."
	speech_verb = "щёлкает"
	ask_verb = "чирикает"
	exclaim_verb = "скрежещет"
	colour = "alien"
	syllables = list("-","=","+","_","|","/")
	space_chance = 0
	key = "|"
	flags = RESTRICTED
	shorthand = "ВЗ"
	machine_understands = FALSE
	var/list/correct_mouthbits = list(
		SPECIES_NABBER,
		SPECIES_MANTID_ALATE,
		SPECIES_MANTID_GYNE,
		SPECIES_MONARCH_QUEEN,
		SPECIES_MONARCH_WORKER
	)

/datum/language/mantid/can_be_spoken_properly_by(var/mob/speaker)
	var/mob/living/S = speaker
	if(!istype(S))
		return FALSE
	if(S.isSynthetic())
		return TRUE
	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		if(H.species.name in correct_mouthbits)
			return TRUE
	return FALSE

/datum/language/mantid/muddle(var/message)
	message = replacetext(message, "...",  ".")
	message = replacetext(message, "!?",   ".")
	message = replacetext(message, "?!",   ".")
	message = replacetext(message, "!",    ".")
	message = replacetext(message, "?",    ".")
	message = replacetext(message, ",",    "")
	message = replacetext(message, ";",    "")
	message = replacetext(message, ":",    "")
	message = replacetext(message, ".",    "...")
	message = replacetext(message, "&#39", "'")
	return message

/datum/language/mantid/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	. = ..(speaker, message, speaker.real_name)

/datum/language/mantid/nonvocal
	key = "]"
	name = LANGUAGE_MANTID_NONVOCAL
	desc = "Комплексный визуальный язык, использующий яркие вспишки био-люминисцентного света в качестве метода передачи информации. Используется Кхармаани из Восхождения."
	colour = "alien"
	speech_verb = "сигналит"
	ask_verb = "моргает"
	exclaim_verb = "интенсивно сигналит"
	flags = RESTRICTED | NO_STUTTER | SIGNLANG
	shorthand = "ВС"

#define MANTID_SCRAMBLE_CACHE_LEN 20
/datum/language/mantid/nonvocal/scramble(var/input)
	if(input in scramble_cache)
		var/n = scramble_cache[input]
		scramble_cache -= input
		scramble_cache[input] = n
		return n
	var/i = length_char(input)
	var/scrambled_text = ""
	while(i)
		i--
		scrambled_text += "<font color='[get_random_colour(1)]'>*</font>"
	scramble_cache[input] = scrambled_text
	if(scramble_cache.len > MANTID_SCRAMBLE_CACHE_LEN)
		scramble_cache.Cut(1, scramble_cache.len-MANTID_SCRAMBLE_CACHE_LEN-1)
	return scrambled_text
#undef MANTID_SCRAMBLE_CACHE_LEN

/datum/language/mantid/nonvocal/can_speak_special(var/mob/living/speaker)
	if(istype(speaker) && speaker.isSynthetic())
		return TRUE
	else if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		return (H.species.name == SPECIES_MANTID_ALATE || H.species.name == SPECIES_MANTID_GYNE)
	return FALSE

/datum/language/mantid/worldnet
	key = "\["
	name = LANGUAGE_MANTID_BROADCAST
	desc = "Инопланетяне Восхождения имеют самоподдерживающаюся сеть под названием 'Ворлднет' для поддержания связи между собой."
	colour = "alien"
	speech_verb = "сигналит"
	ask_verb = "моргает"
	exclaim_verb = "интенсивно сигналит"
	flags = RESTRICTED | NO_STUTTER | NONVERBAL | HIVEMIND 
	shorthand = "ВВН"

/datum/language/mantid/worldnet/check_special_condition(var/mob/living/carbon/other)
	if(istype(other, /mob/living/silicon/robot/flying/ascent))
		return TRUE
	if(istype(other) && (locate(/obj/item/organ/internal/controller) in other.internal_organs))
		return TRUE
	return FALSE
