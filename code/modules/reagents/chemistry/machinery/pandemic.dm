/obj/machinery/computer/virusmaker
	name = "Virus Creator"
	desc = "A fancy computer that can produce it's own bio engineered viruses."
	density = 1
	anchored = 1
	icon = 'icons/obj/chemical.dmi'
	icon_state = "mixer0"
	circuit = /obj/item/weapon/circuitboard/virusmaker
	use_power = 1
	idle_power_usage = 20

/obj/machinery/computer/virusmaker/attack_hand(mob/user)
	if(..())
		return
	if(!user)
		return

	var/i = 5

	var/datum/disease/advance/D = new(0, null)
	D.symptoms = list()

	var/list/symptoms = list()
	symptoms += "Done"
	symptoms += list_symptoms.Copy()
	do
		if(user)
			var/symptom = input(user, "Choose a symptom to add ([i] remaining)", "Choose a Symptom") in symptoms
			if(isnull(symptom))
				return
			else if(istext(symptom))
				i = 0
			else if(ispath(symptom))
				var/datum/symptom/S = new symptom
				if(!D.HasSymptom(S))
					D.symptoms += S
					i -= 1
	while(i > 0)

	if(D.symptoms.len > 0)

		var/new_name = stripped_input(user, "Name your new disease.", "New Name")
		if(!new_name)
			return
		D.AssignName(new_name)
		D.Refresh()
	//if(D)
		//if(D.data && D.data["viruses"])
			//var/list/viruses = D.data["viruses"]
	var/obj/item/weapon/reagent_containers/glass/bottle/B = new/obj/item/weapon/reagent_containers/glass/bottle(src.loc)
	B.icon_state = "bottle3"
	B.pixel_x = rand(-3, 3)
	B.pixel_y = rand(-3, 3)
	var/list/data = list("viruses"=list(D))
	B.name = "[D.name] culture bottle"
	B.desc = "A small bottle. Contains [D.agent] culture in synthblood medium."
	B.reagents.add_reagent("blood",25,data)
