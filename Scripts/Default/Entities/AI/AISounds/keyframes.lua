AI_ANIM_KEYFRAMES = {

	BASE_HUMAN_MODEL = {
		SoundEvents={
--			{"srunfwd_start",	8, KEYFRAME_ALLOW_AI_MOVE  },
--			{"srunleft_start",	8, KEYFRAME_ALLOW_AI_MOVE  },
--			{"srunright_start",	10, KEYFRAME_ALLOW_AI_MOVE  },
--			{"srunback_start",		8, KEYFRAME_ALLOW_AI_MOVE  },
--			{"srun_turnaround_start",	21, KEYFRAME_ALLOW_AI_MOVE  },

			{"srunfwd",		7  },
			{"srunfwd",		19 },
			{"srunback",		5  },
			{"srunback",		14 },
			
			{"swalkback", 		0  },
			{"swalkback", 		16 },
			{"swalkfwd",  		2  },
			{"swalkfwd",  		19 },
			
			{"xwalkfwd", 		2  },
			{"xwalkfwd", 		26 },
			{"xwalkback", 		0  },
			{"xwalkback", 		23 },
			
			{"cwalkback",		9  },
			{"cwalkback",		33 },
			{"cwalkfwd",		12 },
			{"cwalkfwd",		31 },

	    		{"pwalkfwd",		3  },
			{"pwalkback",		3  },

			{"arunback",		6  },
			{"arunback", 		15 },
			{"arunfwd", 		7  },
			{"arunfwd", 		19 },
			
			{"awalkback", 		1  },
			{"awalkback", 		17 },
			{"awalkfwd", 		1  },
			{"awalkfwd", 		20 },
			
			{"draw01", 		14, KEYFRAME_HOLD_GUN },
			{"draw02", 		9, KEYFRAME_HOLD_GUN },
			{"draw03", 		12, KEYFRAME_HOLD_GUN },
			{"draw04", 		14, KEYFRAME_HOLD_GUN },
			{"holster01", 		25, KEYFRAME_HOLSTER_GUN },
			{"holster02", 		35, KEYFRAME_HOLSTER_GUN },
			
			{"_fixfence_loop",	8,	Sound:Load3DSound("SOUNDS/items/ratchet.wav",SOUND_UNSCALABLE,100,5,30)},
		
	--		{"cwalkfwd",		1,Sound:Load3DSound("SOUNDS/ai/pain/pain5.wav",SOUND_UNSCALABLE,250,150,230)},

		},
	},

-----------------------------------------------------------------------------------------------------

	VALERIE = {
		SoundEvents={
			{"srunfwd",		7  },
			{"srunfwd",		19 },
			{"srunback",		5  },
			{"srunback",		14 },
			{"swalkback", 		0  },
			{"swalkback", 		16 },
			{"swalkfwd",  		2  },
			{"swalkfwd",  		19 },
			{"arunback",		6  },
			{"arunback", 		15 },
			{"arunfwd", 		7  },
			{"arunfwd", 		19 },
			{"awalkback", 		1  },
			{"awalkback", 		17 },
			{"awalkfwd", 		1  },
			{"awalkfwd", 		20 },
			{"val_bomb_start", 		457, KEYFRAME_JOB_ATTACH_MODEL_NOW },
			
			
		},
	},

-----------------------------------------------------------------------------------------------------

	-- this was previously in MutantBeserker_x.lua
	MUTANT_ABBERATION = {
		SoundEvents={
			{"srunfwd",	0,			},
			{"srunfwd",	10,			},
			{"srunfwd",	20,			},
			{"srunback",	5,			},
			{"srunback",	13,			},
			
			{"swalkback",   2,			},
			{"swalkback",   18,		},
			{"swalkfwd",     3,		},
			{"swalkfwd",    20,		},
			
			{"arunfwd",	0,			},
			{"arunfwd",	10,			},
			{"arunfwd",	20,			},
			{"arunback",	5,			},
			{"arunback",	13,			},
			
			{"awalkback",   2,			},
			{"awalkback",   18,		},
			{"awalkfwd",     3,		},
			{"awalkfwd",    20,		},
			
			{"attack_melee1", 15, KEYFRAME_APPLY_MELEE},
			--{"attack_melee1", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/melee1.wav",SOUND_UNSCALABLE,255,5,30)},
			{"attack_melee1", 9, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"attack_melee2", 15, KEYFRAME_APPLY_MELEE},
			--{"attack_melee2", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/melee2.wav",SOUND_UNSCALABLE,255,5,30)},
			{"attack_melee2", 12, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"attack_melee3", 11, KEYFRAME_APPLY_MELEE},
			--{"attack_melee3", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/melee3.wav",SOUND_UNSCALABLE,255,5,30)},
			{"attack_melee3", 7, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"attack_melee4", 14, KEYFRAME_APPLY_MELEE},
			--{"attack_melee4", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/melee3.wav",SOUND_UNSCALABLE,255,5,30)},
			{"attack_melee4", 9, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"attack_melee4", 18, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"idle00", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/abidle3.wav",SOUND_UNSCALABLE,255,5,190)},
			{"idle01", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/abidle1.wav",SOUND_UNSCALABLE,255,5,190)},
			{"idle03", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/abidle2.wav",SOUND_UNSCALABLE,255,5,190)},
			{"jump_forward1", 16, KEYFRAME_APPLY_MELEE},
			{"jump_forward2", 17, KEYFRAME_APPLY_MELEE},
			{"jump_forward3", 21, KEYFRAME_APPLY_MELEE},
			{"jump_forward4", 22, KEYFRAME_APPLY_MELEE},
		},
	},
-----------------------------------------------------------------------------------------------------

	MUTANT_BIG = {
		SoundEvents={

			--- EXAMPLE FOR STEVE
			--{"sidle",	1,	KEYFRAME_BREATH_SOUND	},
			--- END EXAMPLE

			{"fire_special00",	7,	KEYFRAME_FIRE_RIGHTHAND	},

--			{"srunfwd",	0,			},
--			{"srunfwd",	10,			},
--			{"srunfwd",	20,			},
--			{"srunback",	5,			},
--			{"srunback",	13,			},
--			
--			{"swalkback",   2,			},
--			{"swalkback",   18,			},
--			{"swalkfwd",     3,			},
--			{"swalkfwd",    20,			},
			
			{"srunfwd",	3,			},
			{"srunfwd",	17,			},
			{"srunback",	9,			},
			{"srunback",	22,			},
			
			{"swalkback",   2,			},
			{"swalkback",   22,			},
			{"swalkfwd",     3,			},
			{"swalkfwd",    23,			},
			
			{"arunfwd",	3,			},
			{"arunfwd",	17,			},
			{"arunback",	9,			},
			{"arunback",	22,			},
			
			{"awalkback",   2,			},
			{"awalkback",   22,			},
			{"awalkfwd",     3,			},
			{"awalkfwd",    23,			},
	--		amin name		frame		soundfile
		
			{"attack_melee1",	4,	Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee1swipeF4.wav",SOUND_UNSCALABLE,175,2,60)},
			{"attack_melee1",	10,		KEYFRAME_APPLY_MELEE},

			{"attack_melee1",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_6.wav",SOUND_UNSCALABLE,255,2,200)},
			{"attack_melee2",	13,	Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee2swipeF13.wav",SOUND_UNSCALABLE,175,2,60)},
			{"attack_melee2",	16,		KEYFRAME_APPLY_MELEE},
			{"attack_melee2",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_1.wav",SOUND_UNSCALABLE,255,2,200)},
			{"attack_melee3",	10,	Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee3swipeF10.wav",SOUND_UNSCALABLE,175,2,60)},
			{"attack_melee3",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_2.wav",SOUND_UNSCALABLE,255,2,200)},
			{"attack_melee3",	16,		KEYFRAME_APPLY_MELEE},
			{"attack_melee4",	10,	Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee4swipeF10.wav",SOUND_UNSCALABLE,175,2,60)},
			{"attack_melee4",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_4.wav",SOUND_UNSCALABLE,255,2,200)},
			{"attack_melee4",	12,		KEYFRAME_APPLY_MELEE},
			{"idle00",	7,	KEYFRAME_BREATH_SOUND	},
			{"idle01",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_6.wav",SOUND_UNSCALABLE,255,2,200)},
			{"idle02",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_1.wav",SOUND_UNSCALABLE,255,2,200)},
			{"idle03",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_5.wav",SOUND_UNSCALABLE,255,2,200)},
			{"idle04",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_8.wav",SOUND_UNSCALABLE,255,2,200)},
			{"idle05",	7,	KEYFRAME_BREATH_SOUND	},
		},
	},

-----------------------------------------------------------------------------------------------------

	MUTANT_MONKEY = {
		SoundEvents={
			{"srunfwd",	0,			},
			{"srunfwd",	10,			},
			{"srunfwd",	20,			},
			{"srunback",	5,			},
			{"srunback",	13,			},
			
			{"swalkback",   2,			},
			{"swalkback",   18,		},
			{"swalkfwd",     3,		},
			{"swalkfwd",    20,		},
			
			{"arunfwd",	0,			},
			{"arunfwd",	10,			},
			{"arunfwd",	20,			},
			{"arunback",	5,			},
			{"arunback",	13,			},
			
			{"awalkback",   2,			},
			{"awalkback",   18,		},
			{"awalkfwd",     3,		},
			{"awalkfwd",    20,		},
			
			{"attack_melee1", 8, KEYFRAME_APPLY_MELEE},
			--{"attack_melee1", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/melee1.wav",SOUND_UNSCALABLE,255,5,30)},
			{"attack_melee1", 3, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"attack_melee2", 8, KEYFRAME_APPLY_MELEE},
			--{"attack_melee2", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/melee2.wav",SOUND_UNSCALABLE,255,5,30)},
			{"attack_melee2", 5, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"attack_melee3", 8, KEYFRAME_APPLY_MELEE},
			--{"attack_melee3", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/melee3.wav",SOUND_UNSCALABLE,255,5,30)},
			{"attack_melee3", 5, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"idle00", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/abidle3.wav",SOUND_UNSCALABLE,255,5,190)},
			{"idle01", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/abidle1.wav",SOUND_UNSCALABLE,255,5,190)},
			{"idle03", 1, Sound:Load3DSound("SOUNDS/mutants/ab1/abidle2.wav",SOUND_UNSCALABLE,255,5,190)},
			{"jump_forward1", 23, KEYFRAME_APPLY_MELEE},
			{"jump_forward2", 23, KEYFRAME_APPLY_MELEE},
			{"jump_forward3", 24, KEYFRAME_APPLY_MELEE},
			{"jump_forward4", 22, KEYFRAME_APPLY_MELEE},


		},
	},

-----------------------------------------------------------------------------------------------------
	MUTANT_STEALTH = {
		SoundEvents={
			{"srunfwd",	9,			},
			{"srunfwd",	20,			},
			{"srunback",	3,			},
			{"srunback",	15,			},
			
			{"swalkback",   3,			},
			{"swalkback",   23,		},
			{"swalkfwd",     3,		},
			{"swalkfwd",    18,		},
			
			{"arunfwd",	9,			},
			{"arunfwd",	20,			},
			{"arunback",	3,			},
			{"arunback",	15,			},
			
			{"awalkback",   3,			},
			{"awalkback",   23,		},
			{"awalkfwd",     3,		},
			{"awalkfwd",    18,		},
			
			{"cwalkfwd",	4,			},
			{"cwalkfwd",	21,			},
			
			{"attack_melee1", 13, KEYFRAME_APPLY_MELEE},
			--{"attack_melee1", 21, KEYFRAME_APPLY_MELEE},
			{"attack_melee1", 7, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"attack_melee1", 15, Sound:Load3DSound("SOUNDS/weapons/machete/fire2.wav",SOUND_UNSCALABLE,255,5,60)},
			{"grenade", 63, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"grenade", 67, Sound:Load3DSound("SOUNDS/mutants/cover/exert_7.wav",SOUND_UNSCALABLE,255,5,190)},
		},
	},
-----------------------------------------------------------------------------------------------------
	MUTANT_FAST = {
		SoundEvents={
			{"srunfwd",	0,			},
			{"srunfwd",	10,			},
			{"srunfwd",	20,			},
			{"srunback",	5,			},
			{"srunback",	13,			},
			
			{"swalkback",   2,			},
			{"swalkback",   18,		},
			{"swalkfwd",     3,		},
			{"swalkfwd",    20,		},
			
			{"arunfwd",	0,			},
			{"arunfwd",	10,			},
			{"arunfwd",	20,			},
			{"arunback",	5,			},
			{"arunback",	13,			},
			
			{"awalkback",   2,			},
			{"awalkback",   18,		},
			{"awalkfwd",     3,		},
			{"awalkfwd",    20,		},
			
			{"attack_melee1", 11, KEYFRAME_APPLY_MELEE},
			{"attack_melee1", 3, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"attack_melee1", 3, Sound:Load3DSound("SOUNDS/mutants/fast/exert1.wav",SOUND_UNSCALABLE,255,5,190)},
			{"attack_melee2", 11, KEYFRAME_APPLY_MELEE},
			{"attack_melee2", 23, Sound:Load3DSound("SOUNDS/weapons/machete/fire1.wav",SOUND_UNSCALABLE,255,5,60)},
			{"attack_melee2", 21, Sound:Load3DSound("SOUNDS/mutants/fast/exert2.wav",SOUND_UNSCALABLE,255,5,190)},
			{"attack_melee2", 17, KEYFRAME_APPLY_MELEE},
			{"attack_melee3", 22, KEYFRAME_APPLY_MELEE},
			{"attack_melee3", 3, Sound:Load3DSound("SOUNDS/mutants/fast/exert3.wav",SOUND_UNSCALABLE,255,5,190)},
			{"attack_melee_special1", 28, KEYFRAME_APPLY_MELEE},
		},	
	},
-----------------------------------------------------------------------------------------------------
	NPC = {
		SoundEvents={
			{"srunfwd",	0,			},
			{"srunfwd",	10,			},
			{"srunfwd",	20,			},
			{"srunback",	5,			},
			{"srunback",	13,			},
			{"sstealthfwd", 6,			},
			{"sstealthfwd", 28,		},
			{"sstealthback", 3,		},
			{"sstealthback", 26,		},
			{"swalkback",   2,			},
			{"swalkback",   18,		},
			{"swalkfwd",     3,		},
			{"swalkfwd",    20,		},
			{"cwalkback",	17,			},
			{"cwalkback",	31,			},
			{"cwalkfwd",	4,			},
			{"cwalkfwd",	21,			},
			{"pwalkfwd",	3,			},
		},
	},
-----------------------------------------------------------------------------------------------------
	PIG = {
		SoundEvents={
			{"srunfwd",	0,			},
			{"srunfwd",	10,			},
			{"srunfwd",	20,			},
			{"srunback",	5,			},
			{"srunback",	13,			},
			{"swalkback",   2,			},
			{"swalkback",   18,		},
			{"swalkfwd",     3,		},
			{"swalkfwd",    20,		},
			{"cwalkback",	17,			},
			{"cwalkback",	31,			},
			{"cwalkfwd",	4,			},
			{"cwalkfwd",	21,			},
		},
	},

------------------------------------------------------------------------------------------------------
	WORM = {
		SoundEvents={
			{"swalkfwd",     3,		},
			{"swalkfwd",    20,		},
			{"awalkfwd",     3,		},
			{"awalkfwd",    20,		},
			{"attack_melee1", 8, KEYFRAME_APPLY_MELEE},
		},
	},

	SHARK = {
		SoundEvents={
			{"attack_melee1", 9, KEYFRAME_APPLY_MELEE},
			{"attack_melee2", 8, KEYFRAME_APPLY_MELEE},
		},
	},


	MUTANT_OMEGA = {
		SoundEvents={
			{"srunfwd",	19,			},
			{"srunfwd",	37,			},
			{"srunback",	14,			},
			{"srunback",	30,			},
			{"swalkback",   22,			},
			{"swalkback",   48,			},
			{"swalkfwd",    18,			},
			{"swalkfwd",    41,			},
			{"fire_special00",    23,		KEYFRAME_FIRE_LEFTTOP},
			{"fire_special01",    0,		KEYFRAME_FIRE_RIGHTHAND	},
			{"fire_special02",    0,		KEYFRAME_FIRE_LEFTHAND	},
			{"fire_special03",    0,		KEYFRAME_FIRE_RIGHTHAND	},
			{"fire_special04",    23,		KEYFRAME_FIRE_RIGHTHAND },

	--		amin name		frame		soundfile
		
			{"attack_melee1",	4,	Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee1swipeF4.wav",SOUND_UNSCALABLE,175,2,20)},
			{"attack_melee1",	12,		KEYFRAME_APPLY_MELEE},

			{"attack_melee1",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_6.wav",SOUND_UNSCALABLE,175,2,20)},
			{"attack_melee2",	13,	Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee2swipeF13.wav",SOUND_UNSCALABLE,175,2,20)},
			{"attack_melee2",	16,		KEYFRAME_APPLY_MELEE},
			{"attack_melee2",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_1.wav",SOUND_UNSCALABLE,175,2,20)},
			{"attack_melee3",	10,	Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee3swipeF10.wav",SOUND_UNSCALABLE,175,2,20)},
			{"attack_melee3",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_2.wav",SOUND_UNSCALABLE,175,2,20)},
			{"attack_melee3",	17,		KEYFRAME_APPLY_MELEE},
			{"attack_melee4",	10,	Sound:Load3DSound("SOUNDS/mutants/cover/cover_melee4swipeF10.wav",SOUND_UNSCALABLE,175,2,20)},
			{"attack_melee4",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/exert_4.wav",SOUND_UNSCALABLE,175,2,20)},
			{"attack_melee4",	16,		KEYFRAME_APPLY_MELEE},
			{"idle01",	1,	Sound:Load3DSound("SOUNDS/mutants/cover/growl2.wav",SOUND_UNSCALABLE,175,2,20)},
		},
	},
}