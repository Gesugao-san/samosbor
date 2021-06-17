//*------------------------------------------------*
//*� ���� � ��� ���� ��������, ������� �� ��������!*
//*------------------------------------------------*
client/var/honor //�����!
client/var/rank //�� ����� ��������� �� ������. ��� ���� ����, ��� ����� ����������, ��������.
var/honor_today = 0
var/true_branded_guys = 0
var/honor_geheimpolizei = 0

client/proc/load_honor(var/lckey) //�������� ����� ����� �� ��.
	establish_db_connection()
	if(!dbcon.IsConnected())
		return 0
	var/DBQuery/honor_load = dbcon.NewQuery("SELECT honor FROM honorsystem WHERE byond='[ckey(lckey)]'")
	if(!honor_load.Execute())
		return 0
	if(honor_load.NextRow()) //Shitcoded.
		return text2num(honor_load.item[1])
	else
		return give_first_honor() //��� � ���� - ��������� ���� give_first_honor � ���������� �������� 0 (��� ������������ ������)

client/proc/load_rank(var/rhonor) //���� ��� ����������� �����
	var/lrank = "�����������"
	if(rhonor <= -100)					lrank =  "������������"
	if(rhonor < -50 && rhonor > -100)	lrank =  "����������"
	if(rhonor < -30 && rhonor >= -50)	lrank =  "������"
	if(rhonor < -10 && rhonor >= -30)	lrank =  "���������"
	if(rhonor < 0 && rhonor >= -10)		lrank =  "��������"
	if(rhonor > 0 && rhonor <= 10)		lrank =  "��������� �������"
	if(rhonor > 10 && rhonor <= 30)		lrank =  "��������������"
	if(rhonor > 30 && rhonor <= 50)		lrank =  "�����������"
	if(rhonor > 50 && rhonor < 100)		lrank =  "�������"
	if(rhonor >= 100)					lrank =  "�������������"
	return lrank

client/proc/update_honor(var/uhonor) //��� ����, ����� �������� �������� �����. uhonor - ��, �� ��� ����� ����������.
	var/DBQuery/update_honor = dbcon.NewQuery("UPDATE honorsystem SET honor=[uhonor] WHERE byond='[ckey]'")
	update_honor.Execute()
	honor = load_honor(ckey)

client/proc/minus_honor(var/mhonor)
	update_honor(honor-mhonor)
	honor_today += mhonor

client/proc/plus_honor(var/phonor)
	update_honor(honor+phonor)

mob/proc/check_honor(var/nhonor)
	if(client.honor >= nhonor)	return 1
	else
		to_chat(usr, "��� �� ������� �����. ���������� �� [nhonor-client.honor] ������.")
		return 0

client/proc/give_first_honor() //��� ��������� ���� ����� ���, ���� ��� � ����.
	var/DBQuery/give_first_honor = dbcon.NewQuery("INSERT INTO honorsystem (byond, honor) VALUES ('[ckey]', 0)")
	give_first_honor.Execute()
	return 0 //���������� �������� 0, ����� ���� ��� ������ ��� ��� �����, ���� ��� ��� � ��-�-�-�-�-�... �����!

client/New() //�������������� ����������.
	..()
	honor = load_honor(ckey)
	rank = load_rank(honor)

mob/verb/honor_about()
	set category = "Honor"
	set name = "About Honor System"
	src << " ��, ���������, ��?\n������, ������� <b>�����</b> ���&#255;�� �� ������ ������� ���� � ������ ������� ������ �� ��. ������ ������ ������ - ����� ���. ���?"

mob/verb/honor_respawn() //������� ��� ���, � ���� ���� ��� �����. ������ ������ �������? ������ ��� ���� �� ����� ������������.
	var/cost = 5
	set category = "Honor"
	set name = "New Life"
	if(check_honor(cost))
		if(!istype(src, /mob/observer/ghost/))
			to_chat(usr, " <span class='notice'><B>�������� ����� ����� �� ������ ���� ������ ���������.</B></span>")
			return
		if(!(ticker && ticker.mode))
			to_chat(usr, " <span class='notice'><B>�� �� ������ ����������&#255; ������.</B></span>")
			return
		else if(!MayRespawn(1, 0))
			return
		client.minus_honor(cost)
		to_chat(usr, " ��������� ����� ����� � ����.")
		to_chat(usr, " <span class='notice'><B>�� ������ ������� ���������.</B></span>")
		announce_ghost_joinleave(client, 0)
		var/mob/new_player/M = new /mob/new_player()
		M.key = key
		log_and_message_admins("���������&#255;, ��������&#255; ������� �����.", M)

mob/verb/honor_shuttle()
	var/cost = 10
	set category = "Honor"
	set name = "Call Shuttle"
	if(check_honor(cost))
		if(!ticker || !evacuation_controller)	return
		if(alert(src, "Are you sure?", "Confirm", "Yes", "No") != "Yes")	return
		if(ticker.mode.auto_recall_shuttle)
			if(input("The evacuation will just be cancelled if you call it. Call anyway?") in list("Confirm", "Cancel") != "Confirm")	return
		var/choice = input("Is this an emergency evacuation or a crew transfer?") in list("Emergency", "Crew Transfer")
		evacuation_controller.call_evacuation(usr, (choice == "Emergency"))
		client.minus_honor(cost)
		log_and_message_admins("honor-called an evacuation.")

mob/verb/honor_clearall() // ����������� ����!
	var/cost = 100
	set category = "Honor"
	set name = "Defile �ll"
	if(check_honor(cost))
		var/DBQuery/defile_all = dbcon.NewQuery("UPDATE honorsystem SET honor=0")
		defile_all.Execute()
		world << "<span class='danger'><B>[ckey] ���������� ����! ���&#255;��� ���� �����, �������! ������ �� ��� ����������.</B></span>"
		client.minus_honor(cost)
		log_and_message_admins("���� ����������, ����!! ������ �� ���������, ����!!!", src)
		for(var/client/C)
			C.honor = C.load_honor(C.ckey)
			C << " <span class='danger'><B>��&#255;-&#255;-&#255;-&#255;-&#255;-&#255;-&#255;!!</B></span>"