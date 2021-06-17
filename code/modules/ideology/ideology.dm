/var/global/list/ideologies = list( \
	"���������" = new/datum/ideology/monarchism(), \
	"����������" = new/datum/ideology/liberalism(), \
	"���������������" = new/datum/ideology/libert(), \
	"������" = new/datum/ideology/fascism(), \
	"���������" = new/datum/ideology/communism() \
	)

/datum/ideology
	var/name = "default"
	var/p_name = ""
	var/description = ""
	var/global_leader = ""
	var/mob/living/carbon/human/station_leader = null
	var/ideology_flag = null

	var/has_leader = 0
	var/is_legal = 1
	var/is_election_started = 0

	var/list/mob/living/carbon/human/followers = list()
	var/list/mob/living/carbon/human/election_candidates = list()

	var/area/elections_area

/datum/ideology/New()
	..()
	name = ideology_flag

/datum/ideology/proc/choose_leader()
	if(station_leader && has_leader)
		station_leader = null
		has_leader = 0
	var/list/candidates = list()
	for(var/mob/living/carbon/human/H in followers)
		if(H.stat == DEAD || H.stat == UNCONSCIOUS || H.mind.special_role || !H.client)
			continue
		candidates.Add(H)
	if(!candidates.len)
		return
	station_leader = pick(candidates)
	to_chat(station_leader, "<b>������ �� - ����� ��������� [src.ideology_flag]!</b>")
	has_leader = 1

/datum/ideology/proc/initiate_elections(var/mob/initiator, var/area/A)
	is_election_started = 1

	var/leader_votes = 0
	var/leader = null

	elections_area = A

	for(var/mob/living/M in elections_area)
		if(M.mob_ideology == src)
			to_chat(M, "<h2><b>[initiator.name] ����������� ����������� �� ������ ���������!</b></h2><br>")
			to_chat(M, "<span class='alert'>� ����� ���� 180 ������ �� ��, ����� ������� ������ ���������.</span>")
			M.verbs += /mob/living/carbon/human/proc/choose_candidate

	spawn(1800)
		if(!election_candidates.len)
			for(var/mob/M in followers)
				to_chat(M, "<h2><b>����� �� ������������ �� ������ ������.</b></h2>")
				is_election_started = 0
				return

		for(var/candidate in election_candidates)
			if(!leader_votes && !leader)
				leader_votes = election_candidates[candidate]
				leader = candidate
			if(election_candidates[candidate] > leader_votes)
				leader_votes = election_candidates[candidate]
				leader = candidate
			if(election_candidates[candidate] < leader_votes)
				continue
			if(election_candidates[candidate] == leader_votes)
				if(rand(50))
					leader = candidate
					leader_votes = election_candidates[candidate]

		var/mob/winner = leader
		for(var/mob/M in followers)
			to_chat(M, "<h2><B>[winner.name] ������ �������!</B><h2>")

		station_leader = winner
		has_leader = 1
		is_election_started = 0
		elections_area = null


/datum/ideology/monarchism
	p_name = "���������� ������� ������"
	description = "���������� ������������ ������� �����. ��� �� ������ �����-���� ������� ������� � ����������� � ������� ������������ ���� �������. ������ ����� ���� �����������, �������� ���������� ��������� ������."
	global_leader = "����� ��� ���������"
	ideology_flag = IDEOLOGY_MONARCHISM

/datum/ideology/liberalism
	p_name = "������� ������� � ���������"
	description = "�������� ������ ������� ��������������, ������� ������� � ������� ����������� ������ � �����������. �� ������� �������� - ������� � �������������."
	global_leader = "����� ������"
	ideology_flag = IDEOLOGY_LIBERALISM

/datum/ideology/libert
	p_name = "������� \"������������ �� ������� �����������\""
	description = "������-����������� ��� �������������. ��� ��������� �� ���������� ����������� � ������ ��������������� ������������ � ��������� ���������� �����. �� ����� - �� ������ �������, ��� ������ �����, ����� ������ �������������."
	global_leader = "����� �������"
	ideology_flag = IDEOLOGY_LIBERT

	is_legal = 0

/datum/ideology/fascism
	p_name = "��������� ������ \"������������� ������������\" � ������ ������ ��������"
	description = "������. ��������� � ������������. ��� ��������� �� ����� �����������, ������� ��������� ���� ������, �������, �������� ��������� ���� � ��������� ��������. �� ����������� ����� ������� ������ �� � ������ � �����."
	global_leader = "������ �������"
	ideology_flag = IDEOLOGY_FASCISM

	is_legal = 0

/datum/ideology/communism
	p_name = "����������������� �������"
	description = "���������� ������ �� �������� ������������ ���������� �����. �� ������� - �����������, ���������� �� ���������� ���������, ������������ ������������� �� �������� ������������ � ���������� ������������. ��� �� �������� 12 ����� ������ � ����� ��������� ��� 10 �����."
	global_leader = "��������� �������"
	ideology_flag = IDEOLOGY_COMMUNISM

	is_legal = 0

/mob/living/carbon/human/verb/ideology_info()
	set name = "���������"
	set category = "IC"

	if(src.mob_ideology)
		var/message = "<span class='notice'>����� ����������: <b>[src.mob_ideology.name]</b>, "
		if(src.mob_ideology.has_leader)
			message += "��������������� <b>[src.mob_ideology.station_leader.real_name]</b>."
		else
			message += "� ������� ��� ������."
		message += "<br>[src.mob_ideology.description]</span>"
		to_chat(usr, message)
	else
		to_chat(usr, "�� �� ������������ ������������ �����-���� ���������.")