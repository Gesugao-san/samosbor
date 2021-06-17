/datum/wish/concentrate
	name = "concentrate_wish"
	description = ""
	success_event = /datum/happiness_event/desired_concentrate
	var/list/concentrate_types = list(
										"red" = "redcon",
										"blue" = "bluecon",
										"green" = "greencon",
										"yellow" = "yellowcon"
										)

	var/list/color_translation = list("red" = "�������", "blue" = "�������", "green" = "������", "yellow" = "�����")
	var/desired_concentrate = null
	success_message = "<span class='info'>� ���� �������� ����������.</span>\n"


/datum/wish/concentrate/New(var/mob/living/carbon/human/holder)
	..(holder)

	var/picked = pick(concentrate_types)

	var/concentrate_type = concentrate_types[picked]

	src.desired_concentrate = concentrate_type

	var/rus_name = color_translation[picked]


	description = "<span class='info'>����� ���� [rus_name] ����������.</span>"