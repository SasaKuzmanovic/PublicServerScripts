Config = {}

Config.Animations = {
	
	{
		name  = 'festives',
		label = 'Veselo',
		items = {
	    	{label = "Zapali", type = "scenario", data = {anim = "WORLD_HUMAN_SMOKING"}},
	    	{label = "Glazbenik", type = "scenario", data = {anim = "WORLD_HUMAN_MUSICIAN"}},
	    	{label = "Dj", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@dj", anim = "dj"}},
	    	{label = "Kava", type = "scenario", data = {anim = "WORLD_HUMAN_DRINKING"}},
	    	{label = "Pivo", type = "scenario", data = {anim = "WORLD_HUMAN_PARTYING"}},
	    	{label = "Zracna gitara", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@air_guitar", anim = "air_guitar"}},
	    	{label = "Air Shagging", type = "anim", data = {lib = "anim@mp_player_intcelebrationfemale@air_shagging", anim = "air_shagging"}},
	    	{label = "Rock'n'roll", type = "anim", data = {lib = "mp_player_int_upperrock", anim = "mp_player_int_rock"}},
	    	{label = "Pusenje jointa", type = "scenario", data = {anim = "WORLD_HUMAN_SMOKING_POT"}},
	    	{label = "Pijanac", type = "anim", data = {lib = "amb@world_human_bum_standing@drunk@idle_a", anim = "idle_a"}},
	    	{label = "Povracanje", type = "anim", data = {lib = "oddjobs@taxi@tie", anim = "vomit_outside"}},
		}
	},

	{
		name  = 'greetings',
		label = 'Pozdravi',
		items = {
	    	{label = "Pozdrav", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_hello"}},
	    	{label = "Mahanje", type = "anim", data = {lib = "mp_common", anim = "givetake1_a"}},
	    	{label = "Rukovanje", type = "anim", data = {lib = "mp_ped_interaction", anim = "handshake_guy_a"}},
	    	{label = "Grljenje", type = "anim", data = {lib = "mp_ped_interaction", anim = "hugs_guy_a"}},
	    	{label = "Salutiranje", type = "anim", data = {lib = "mp_player_int_uppersalute", anim = "mp_player_int_salute"}},
		}
	},

	{
		name  = 'work',
		label = 'Posao',
		items = {
	    	{label = "Osumnjičeni: Predaj se", type = "anim", data = {lib = "random@arrests@busted", anim = "idle_c"}},
	    	{label = "Pecanje", type = "scenario", data = {anim = "world_human_stand_fishing"}},
	    	{label = "Policija : Istraga", type = "anim", data = {lib = "amb@code_human_police_investigate@idle_b", anim = "idle_f"}},
	    	{label = "Policija : Koristi radio", type = "anim", data = {lib = "random@arrests", anim = "generic_radio_chatter"}},
	    	{label = "Policija : Promet", type = "scenario", data = {anim = "WORLD_HUMAN_CAR_PARK_ATTENDANT"}},
	    	{label = "Policija : Dvogled", type = "scenario", data = {anim = "WORLD_HUMAN_BINOCULARS"}},
	    	{label = "Poljoprivreda : Sadenje", type = "scenario", data = {anim = "world_human_gardener_plant"}},
	    	{label = "Mehanicar : Popravak motora", type = "anim", data = {lib = "mini@repair", anim = "fixing_a_ped"}},
	    	{label = "Lijecnik : Klecanje", type = "scenario", data = {anim = "CODE_HUMAN_MEDIC_KNEEL"}},
	    	{label = "Taxi : Pricaj sa musterijom", type = "anim", data = {lib = "oddjobs@taxi@driver", anim = "leanover_idle"}},
	    	{label = "Taxi : Daj racun", type = "anim", data = {lib = "oddjobs@taxi@cyi", anim = "std_hand_off_ps_passenger"}},
	    	{label = "Prodavac : Daj", type = "anim", data = {lib = "mp_am_hold_up", anim = "purchase_beerbox_shopkeeper"}},
	    	{label = "Barmen : Posluga pica", type = "anim", data = {lib = "mini@drinking", anim = "shots_barman_b"}},
	    	{label = "Novinar : Slikanje", type = "scenario", data = {anim = "WORLD_HUMAN_PAPARAZZI"}},
	    	{label = "Svi poslovi : Zapisivanje", type = "scenario", data = {anim = "WORLD_HUMAN_CLIPBOARD"}},
	    	{label = "Svi poslovi : Cekic", type = "scenario", data = {anim = "WORLD_HUMAN_HAMMERING"}},
	    	{label = "Prosjak : Drzanje natpisa", type = "scenario", data = {anim = "WORLD_HUMAN_BUM_FREEWAY"}},
	    	{label = "Prosjak : Ljudski kip", type = "scenario", data = {anim = "WORLD_HUMAN_HUMAN_STATUE"}},
		}
	},

	{
		name  = 'humors',
		label = 'Zabava',
		items = {
	    	{label = "Bodrenje", type = "scenario", data = {anim = "WORLD_HUMAN_CHEERING"}},
	    	{label = "Super", type = "anim", data = {lib = "mp_action", anim = "thanks_male_06"}},
	    	{label = "Pokazati", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_point"}},
	    	{label = "Dodi vamo", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_come_here_soft"}}, 
	    	{label = "Samo daj", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_bring_it_on"}},
	    	{label = "Ja", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_me"}},
	    	{label = "Znao sam", type = "anim", data = {lib = "anim@am_hold_up@male", anim = "shoplift_high"}},
	    	{label = "Iscrpljen", type = "scenario", data = {lib = "amb@world_human_jog_standing@male@idle_b", anim = "idle_d"}},
	    	{label = "Ja sam govno", type = "scenario", data = {lib = "amb@world_human_bum_standing@depressed@idle_a", anim = "idle_a"}},
	    	{label = "Zasto", type = "anim", data = {lib = "anim@mp_player_intcelebrationmale@face_palm", anim = "face_palm"}},
	    	{label = "Smiri se", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_easy_now"}},
	    	{label = "Sta sam ucinio?", type = "anim", data = {lib = "oddjobs@assassinate@multi@", anim = "react_big_variations_a"}},
	    	{label = "Strah", type = "anim", data = {lib = "amb@code_human_cower_stand@male@react_cowering", anim = "base_right"}},
	    	{label = "Oces se tuci ?", type = "anim", data = {lib = "anim@deathmatch_intros@unarmed", anim = "intro_male_unarmed_e"}},
	    	{label = "Nemoguce !", type = "anim", data = {lib = "gestures@m@standing@casual", anim = "gesture_damn"}},
	    	{label = "Zagrljaj", type = "anim", data = {lib = "mp_ped_interaction", anim = "kisses_guy_a"}},
	    	{label = "Srednjak", type = "anim", data = {lib = "mp_player_int_upperfinger", anim = "mp_player_int_finger_01_enter"}},
	    	{label = "Ti lutalice", type = "anim", data = {lib = "mp_player_int_upperwank", anim = "mp_player_int_wank_01"}},
	    	{label = "Metak u glavu", type = "anim", data = {lib = "mp_suicide", anim = "pistol"}},
		}
	},

	{
		name  = 'sports',
		label = 'Sport',
		items = {
	    	{label = "Pokazi misice", type = "anim", data = {lib = "amb@world_human_muscle_flex@arms_at_side@base", anim = "base"}},
	    	{label = "Podigni uteg", type = "anim", data = {lib = "amb@world_human_muscle_free_weights@male@barbell@base", anim = "base"}},
	    	{label = "Radi sklekove", type = "anim", data = {lib = "amb@world_human_push_ups@male@base", anim = "base"}},
	    	{label = "Radi trbusnjake", type = "anim", data = {lib = "amb@world_human_sit_ups@male@base", anim = "base"}},
	    	{label = "Radi jogu", type = "anim", data = {lib = "amb@world_human_yoga@male@base", anim = "base_a"}},
		}
	},

	{
		name  = 'misc',
		label = 'Razno',
		items = {
	    	{label = "Pij kavu", type = "anim", data = {lib = "amb@world_human_aa_coffee@idle_a", anim = "idle_a"}},
	    	{label = "Sjedni", type = "anim", data = {lib = "anim@heists@prison_heistunfinished_biztarget_idle", anim = "target_idle"}},
	    	{label = "Nasloni se na zid", type = "scenario", data = {anim = "world_human_leaning"}},
	    	{label = "Suncaj ledja", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE_BACK"}},
	    	{label = "Suncaj stomak", type = "scenario", data = {anim = "WORLD_HUMAN_SUNBATHE"}},
	    	{label = "Cisti", type = "scenario", data = {anim = "world_human_maid_clean"}},
	    	{label = "Rotsilj", type = "scenario", data = {anim = "PROP_HUMAN_BBQ"}},
	    	{label = "Trazi", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_bj_to_prop_female"}},
	    	{label = "Uslikaj selfie", type = "scenario", data = {anim = "world_human_tourist_mobile"}},
	    	{label = "Slusaj vrata/zid", type = "anim", data = {lib = "mini@safe_cracking", anim = "idle_base"}}, 
		}
	},

	{
		name  = 'attitudem',
		label = 'Stilovi hodanja',
		items = {
	    	{label = "Normalan musko", type = "attitude", data = {lib = "move_m@confident", anim = "move_m@confident"}},
	    	{label = "Normalan zensko", type = "attitude", data = {lib = "move_f@heels@c", anim = "move_f@heels@c"}},
	    	{label = "Depresivan musko", type = "attitude", data = {lib = "move_m@depressed@a", anim = "move_m@depressed@a"}},
	    	{label = "Depresivan zensko", type = "attitude", data = {lib = "move_f@depressed@a", anim = "move_f@depressed@a"}},
	    	{label = "Biznis", type = "attitude", data = {lib = "move_m@business@a", anim = "move_m@business@a"}},
	    	{label = "Odlucan", type = "attitude", data = {lib = "move_m@brave@a", anim = "move_m@brave@a"}},
	    	{label = "Neformalan", type = "attitude", data = {lib = "move_m@casual@a", anim = "move_m@casual@a"}},
	    	{label = "Pojeo previse", type = "attitude", data = {lib = "move_m@fat@a", anim = "move_m@fat@a"}},
	    	{label = "Hipster", type = "attitude", data = {lib = "move_m@hipster@a", anim = "move_m@hipster@a"}},
	    	{label = "Ozljedjen", type = "attitude", data = {lib = "move_m@injured", anim = "move_m@injured"}},
	    	{label = "U zurbi", type = "attitude", data = {lib = "move_m@hurry@a", anim = "move_m@hurry@a"}},
	    	{label = "Skitnica", type = "attitude", data = {lib = "move_m@hobo@a", anim = "move_m@hobo@a"}},
	    	{label = "Tuzan", type = "attitude", data = {lib = "move_m@sad@a", anim = "move_m@sad@a"}},
	    	{label = "Misicav", type = "attitude", data = {lib = "move_m@muscle@a", anim = "move_m@muscle@a"}},
	    	{label = "Sokiran", type = "attitude", data = {lib = "move_m@shocked@a", anim = "move_m@shocked@a"}},
	    	{label = "Tajnovit", type = "attitude", data = {lib = "move_m@shadyped@a", anim = "move_m@shadyped@a"}},
	    	{label = "Buzzed", type = "attitude", data = {lib = "move_m@buzzed", anim = "move_m@buzzed"}},
	    	{label = "Brze", type = "attitude", data = {lib = "move_m@hurry_butch@a", anim = "move_m@hurry_butch@a"}},
	    	{label = "Ponosan", type = "attitude", data = {lib = "move_m@money", anim = "move_m@money"}},
	    	{label = "Kratka utrka", type = "attitude", data = {lib = "move_m@quick", anim = "move_m@quick"}},
	    	{label = "Ljudozder", type = "attitude", data = {lib = "move_f@maneater", anim = "move_f@maneater"}},
	    	{label = "Sassy", type = "attitude", data = {lib = "move_f@sassy", anim = "move_f@sassy"}},	
	    	{label = "Arogantan", type = "attitude", data = {lib = "move_f@arrogant@a", anim = "move_f@arrogant@a"}},
		}
	},
	{
		name  = 'porn',
		label = 'Porn',
		items = {
	    	{label = "Muskarac dobija blowjob u autu", type = "anim", data = {lib = "oddjobs@towing", anim = "m_blow_job_loop"}},
	    	{label = "Zena daje blowjob u autu", type = "anim", data = {lib = "oddjobs@towing", anim = "f_blow_job_loop"}},
	    	{label = "Muskarac dole u autu", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_player"}},
	    	{label = "Zena gore u autu", type = "anim", data = {lib = "mini@prostitutes@sexlow_veh", anim = "low_car_sex_loop_female"}},
	    	{label = "Pocesi jaja", type = "anim", data = {lib = "mp_player_int_uppergrab_crotch", anim = "mp_player_int_grab_crotch"}},
	    	{label = "Kurva 1", type = "anim", data = {lib = "mini@strip_club@idles@stripper", anim = "stripper_idle_02"}},
	    	{label = "Kurva 2", type = "scenario", data = {anim = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS"}},
	    	{label = "Kurva 3", type = "anim", data = {lib = "mini@strip_club@backroom@", anim = "stripper_b_backroom_idle_b"}},
	    	{label = "Striptiz 1", type = "anim", data = {lib = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1", anim = "ld_girl_a_song_a_p1_f"}},
	    	{label = "Striptiz 2", type = "anim", data = {lib = "mini@strip_club@private_dance@part2", anim = "priv_dance_p2"}},
	    	{label = "Striptiz na koljenima", type = "anim", data = {lib = "mini@strip_club@private_dance@part3", anim = "priv_dance_p3"}},
			}
	},

}