/datum/event_of_round
	var/id = "default" //����� ����������, � ����� � ���
	var/event_message = "�� �� ������ ���� ��� �������."
	var/required_players = 0 //����� �� ��� ������?

/datum/event_of_round/New()
	..()

/datum/event_of_round/proc/announce_event()
	to_world("<h1 class='alert'>�� ������� ������:</h1>")
	to_world("<br>[event_message]<br>")
	return

/datum/event_of_round/proc/apply_event()
	return

/*datum/event_of_round/stolen_airlocks
	id = "stolenairlocks"
	event_message = "��� ����� ���� �������� � �������� �� ������� ����� ������������ ���� ������������ �� ���� �������!"

/datum/event_of_round/stolen_airlocks/apply_event()
	for(var/obj/machinery/door/airlock/A in station_airlocks)
		if(!istype(A, /obj/machinery/door/airlock/external))
			var/obj/machinery/door/unpowered/simple/S = new()
			S.loc = A.loc
			qdel(A)

/datum/event_of_round/without_light
	id = "withoutlight"
	event_message = "��-�� �������� � ��������� �������� �������� ��� ����������."

/datum/event_of_round/without_light/apply_event()
	lightsout(0,0)
	for(var/obj/item/device/flashlight/F)
		F.on = 0
		F.update_icon()*/

/datum/event_of_round/mom_i_wont_die
	id = "momiwontdie"
	event_message = "�������� �������� �� �������� �������."
