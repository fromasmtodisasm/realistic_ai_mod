AIAnchor = {
	--job anchors
	AIANCHOR_WHEEL		= 101, -- tighten wheel nuts etc for car
	AIANCHOR_TOOLBOX		= 102, -- location for toolbox eg. for fix car goes off to toolbox return to where he was working
	AIANCHOR_HOOD		= 103, -- car hood or anywhere else want to briefly stop and fix something on car
	AIANCHOR_FENCE		= 104, -- AI fix fence can also be used for other generic fixing
	AIANCHOR_FENCE_LONG	= 105, -- AI fix fence for a long duration

	AIANCHOR_CLIPBOARD	= 106, -- AI inspects some apparatus, makes notes on clibpoard
	AIANCHOR_SIT_WRITE	= 107, -- AI is sitting down writing stuff
	AIANCHOR_SIT_TYPE		= 108, -- AI is sitting down typing

	AIANCHOR_PUSHBUTTON	= 110, -- button on the wall for AI to push - head height
	AIANCHOR_PUTDOWN	= 112,
	RESPOND_TO_REINFORCEMENT  =113,
	PUSH_THIS_WAY		  =114,
	SLEEP				= 115,
	SHOOTING_TARGET		= 116,
	EXERCISE_HERE		= 117,
	PLAY_CARDS_HERE		= 118,
	AIANCHOR_WARMHANDS	= 119,
	AIANCHOR_RAMPAGE		= 120,	
	GUN_RACK		= 121, 	-- this is a place where there are guns to be picked up from
	DO_SOMETHING_SPECIAL	= 122, 
	SWIM_HERE		= 123,
	AIANCHOR_MUTATED		=124, -- for Valerie in Volcano
	PLANT_BOMB_HERE		= 125,

	--jobs which use entity which can be bound to AI
	AIANCHOR_PICKUP		= 151, -- AI can pick up crate etc and move to AIANCHOR_PUTDOWN
	AIANCHOR_PUTDOWN		= 152,
	AIANCHOR_CHAIR		= 153, -- swivel chair for AI to sit down, chair binds to AI so will move forward
	AIANCHOR_MICROSCOPE	= 154, -- microsocpe for scientist AI to peer into - atm need props
	AIANCHOR_BEAKER		= 155, -- AI pours fluid between beakers, holds up looks at it
	AIANCHOR_MAGAZINE		= 156, -- AI sitting down picks up magazine and reads it 

	AIANCHOR_DINNER1		= 158, -- mutant chomping down on some corpse flesh
	AIANCHOR_DINNER2		= 159, -- mutant chomping down on some corpse flesh
	FISH_HERE			= 160, -- AI casts rod and fishes for a while
	AIANCHOR_EXAMINATION	= 161, -- AI conducts autopsy on a specimen.
	MUTANT_LOCK		= 162,
	USE_RADIO_ANIM		= 163,
	
	--idle anchors
	AIANCHOR_RELIEF		= 201,
	AIANCHOR_SMOKE		= 202,
	AIANCHOR_STAND_TYPE	= 203,  -- something interesting to look at on wall
	AIANCHOR_SEAT		= 204,  -- place for AI to sit down. Seat does not bind to AI
	AIANCHOR_OBSERVE	= 205,
	AIANCHOR_FLASHLIGHT	= 206,
	AIANCHOR_THROW_FLARE	= 207,
	AIANCHOR_NOTIFY_GROUP_DELAY	= 208,
	USE_THIS_MOUNTED_WEAPON	= 209,
	HOLD_YOUR_FIRE		= 210,
	HOLD_THIS_POSITION	= 211,
	MUTANT_JUMP_TARGET  	= 212,
	MUTANT_JUMP_TARGET_WALKING  = 213,
	MUTANT_AIRDUCT  	= 214,
	MUTANT_JUMP_SMALL  	= 215,
	MORPH_HERE		 	= 216,
	INVESTIGATE_HERE		= 217,
	RETREAT_WHEN_HALVED	= 218,
	SPECIAL_STAND_TYPE	= 219,
	SPECIAL_ENTERCODE	= 220,
	SPECIAL_ENABLE_TRIGGER  = 221,
	SPECIAL_HOLD_SPOT	= 222,
	RETREAT_HERE		= 223,
	SEAT_PRECISE		= 224,  -- place for AI to sit down. Seat does not bind to AI

	
	--combat anchors
	AIANCHOR_SHOOTSPOTSTAND		= 311,
	AIANCHOR_SHOOTSPOTCROUCH	= 312,
	AIANCHOR_REINFORCEPOINT		= 313,
	AIANCHOR_PROTECT_THIS_POINT	= 314,
	SNIPER_POTSHOT			= 315,
	
	--scientist combat anchors
	AIANCHOR_PUSH_ALARM	= 352, --scientist push alarm to bring guard
	
	AIANCHOR_RANDOM_TALK 	= 400,
	AIANCHOR_MISSION_TALK 	= 401,
	BLIND_ALARM		= 402,
	MISSION_TALK_INPLACE	= 403,
	PLACEHOLDER		= 404,
	

	
	--vehicles - eter boat spots
	AIANCHOR_BOATENTER_SPOT		= 510, 
	AIANCHOR_BOATATTACK_SPOT	= 511, 	-- attack spot for boat should be placed along beaches
						-- when target is on ground, boat will use this spots to attack	
	-- thise anchors are created by vehicles scripts - don't place them manually!!!!!
	z_CARENTER_DRIVER	= 512, 
	z_CARENTER_GUNNER	= 513, 		
	z_CARENTER_PASSENGER1	= 514, 
	z_CARENTER_PASSENGER2	= 515, 
	z_CARENTER_PASSENGER3	= 516, 
	z_CARENTER_PASSENGER4	= 517, 			
	z_CARENTER_PASSENGER5	= 518, 	
	z_CARENTER_PASSENGER6	= 519, 	
	z_CARENTER_PASSENGER7	= 520,
	z_CARENTER_PASSENGER8	= 521,
	z_CARENTER_PASSENGER9	= 522,
	z_CARENTER_PASSENGER10	= 523,
	z_HELYENTER		= 524,
	
	
	
	-- dont modify this, add more stuff above this line
	AIOBJECT_DAMAGEGRENADE	= 200,
	AIOBJECT_SWIVIL_CHAIR		= 600,
	AIOBJECT_FLYING_FOX		= 601,
	AIOBJECT_CARRY_CRATE		= 650,
}