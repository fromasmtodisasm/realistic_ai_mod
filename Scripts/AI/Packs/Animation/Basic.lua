

ANIMATIONPACK.Basic = {

	HIDE_END_EFFECT = {
				{
				PROBABILITY = 1000,
				animationName = "rollfwd",
				duration = 1.5,
				layer = 4,
				blend_time = 0.13,
				},
		  },
---------------------------------------------------------------------------------
	I_SEE_YOU = {
				{
				PROBABILITY = 1000,
				animationName = "first_contact",
				duration = 1.5,
				layer = 0,
				blend_time = 0.13,
				},
		  },
---------------------------------------------------------------------------------
	I_NO_SEE_YOU = {
				{
				PROBABILITY = 1000,
				animationName = "enemy_target_lost",
				duration = 1.5,
				layer = 0,
				blend_time = 0.13,
				},
		  },
---------------------------------------------------------------------------------
	I_HEAR_YOU = {
				{
				PROBABILITY = 1000,
				animationName = "sSoundheard",
				duration = 1.5,
				layer = 0,
				blend_time = 0.13,
				},
		  },
-----------------------------------------------------------------------------------
	ACT_SURPRISED = {
	--AI reacts to unexpected event such as player seen
				{
				PROBABILITY = 100,
				animationName = "suprise01",
				duration = 0,
				layer = 1,
				blend_time = 0.3,
				},
				{
				PROBABILITY = 100,
				animationName = "suprise02",
				duration = 0,
				layer = 1,
				blend_time = 0.3,
				},
				{
				PROBABILITY = 100,
				animationName = "suprise03",
				duration = 0,
				layer = 1,
				blend_time = 0.3,
				},

			 },
------------------------------------------------------------------------------------
	RESPOND_DOWN = {
	--Team member responds to one of their team members down, eg call for help
				{
				PROBABILITY = 100,
				animationName = "suprise01",
				duration = 0,
				layer = 1,
				blend_time = 0.3,
				}
			},
------------------------------------------------------------------------------------
	FIRST_CONTACT = {
	--The enemy has some kind of contact with a target, but has yet to establish whether it is a hostile or a friendly one.	
				{
				PROBABILITY = 100,
				animationName = "first_contact",
				duration = 0,
				layer = 1,
				blend_time = 0.3,
				}
			},
------------------------------------------------------------------------------------
	ENEMY_TARGET_LOST = {
	--The enemy lost the contact with his immediate hostile target.
				{
				PROBABILITY = 100,
				animationName = "enemy_target_lost",
				duration = 0,
				layer = 1,
				blend_time = 0.3,
				}
			},
------------------------------------------------------------------------------------
	CALL_REINFORCEMENTS = {
	--The enemy lost the contact with his immediate hostile target.
				{
				PROBABILITY = 500,
				animationName = "reinforcements_wave1",
				duration = 0,
				layer = 4,
				blend_time = 0.3,
				},

				{
				PROBABILITY = 500,
				animationName = "reinforcements_wave2",
				duration = 0,
				layer = 4,
				blend_time = 0.3,
				}
			},
------------------------------------------------------------------------------------

}