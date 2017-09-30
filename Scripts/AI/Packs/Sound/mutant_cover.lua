-- TEMPLATE
-- DO NOT MODIFY THIS TEMPLATE
--
-- This template has all the readability signals currently in use.  
-- Change the <Template> string to the pack name
-- 
-- To switch between alternate sound responses add a new set of 
-- bracketed parameters, making sure there is a comma after the bracket eg,
--				{
--				PROBABILITY = 500,
--				soundFile = "SOUNDS/<full path to wav file>",
--				Volume = 125,
--				min = 2,
--				max = 300,
--				sound_unscalable = 1,
--				},
-- Probability determines how often a wave is played in response to the signal
-- To allow for possibility of no sound in response to a signal, sounds should sum
-- to less than 1000. eg. if you dont want sound to be played every single time 
-- player receives an order might have total PROBABILITY for all sounds = 500.
--------------------------------------------------
--    Created By: <steve>
--   Description: <short_description>
--------------------------
SOUNDPACK.mutant_cover = {
-----------------------------------------------------------------------------------
	CHATTERING = {
	-- general background mutant type muttering, creepiness good 
				{
				PROBABILITY = 25,
				soundFile = "SOUNDS/mutants/cover/chattering_1.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 25,
				soundFile = "SOUNDS/mutants/cover/chattering_2.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 25,
				soundFile = "SOUNDS/mutants/cover/chattering_3.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 25,
				soundFile = "SOUNDS/mutants/cover/chattering_4.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 25,
				soundFile = "SOUNDS/mutants/cover/chattering_5.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 25,
				soundFile = "SOUNDS/mutants/cover/chattering_6.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 25,
				soundFile = "SOUNDS/mutants/cover/chattering_7.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 25,
				soundFile = "SOUNDS/mutants/cover/chattering_8.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 25,
				soundFile = "SOUNDS/mutants/cover/chattering_9.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 25,
				soundFile = "SOUNDS/mutants/cover/chattering_10.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 25,
				soundFile = "SOUNDS/mutants/cover/chattering_11.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 25,
				soundFile = "SOUNDS/mutants/cover/chattering_12.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 25,
				soundFile = "SOUNDS/mutants/cover/chattering_13.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
-----------------------------------------------------------------------------------
	JUMP = {
	-- sound of mutant leaving ground and flying through the air
				{
				PROBABILITY = 500,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
-----------------------------------------------------------------------------------
	MELEE_ATTACK = {
	-- horrible grunting and salivating a terror to behold
				{
				PROBABILITY = 500,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
-----------------------------------------------------------------------------------
	ACT_SURPRISED = {
	--AI reacts to unexpected event such as player seen
	-- eg. what the heck, crikey
				{
				PROBABILITY = 500,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
			 
-----------------------------------------------------------------------------------
	AI_AGGRESSIVE = {
	--aggressive sounds
				{
				PROBABILITY = 20,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	THREATEN = {
	--AI threatens the player while attacking	
	--eg. I'm gonna tear you apart!			
				{
				PROBABILITY = 50,
				soundFile = "SOUNDS/mutants/cover/threaten_1.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 50,
				soundFile = "SOUNDS/mutants/cover/threaten_2.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 50,
				soundFile = "SOUNDS/mutants/cover/threaten_3.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 50,
				soundFile = "SOUNDS/mutants/cover/threaten_4.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 50,
				soundFile = "SOUNDS/mutants/cover/threaten_5.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 50,
				soundFile = "SOUNDS/mutants/cover/threaten_6.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 50,
				soundFile = "SOUNDS/mutants/cover/threaten_7.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 50,
				soundFile = "SOUNDS/mutants/cover/threaten_8.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
		},
-----------------------------------------------------------------------------------
	ACT_AFRAID = {
	--AI fear gestures
	--eg. "Aaaargh!" , help
				{
				PROBABILITY = 500,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
-----------------------------------------------------------------------------------
	POINTING = {
	--AI sights the player and points to where he can be found
	--"There he is!", "There"
				{
				PROBABILITY = 200,
				soundFile = "SOUNDS/mutants/cover/pointing_1.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 200,
				soundFile = "SOUNDS/mutants/cover/pointing_2.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 200,
				soundFile = "SOUNDS/mutants/cover/pointing_3.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 200,
				soundFile = "SOUNDS/mutants/cover/pointing_4.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 200,
				soundFile = "SOUNDS/mutants/cover/pointing_5.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
-----------------------------------------------------------------------------------
	AI_DOWN = {
	--AI calls out that they have been hit
	-- sound of pain
				{
				PROBABILITY = 250,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
-----------------------------------------------------------------------------------
	RESPOND_DOWN = {
	--Team member responds to one of their team members down
	-- eg. "Man hit!"
				{
				PROBABILITY = 225,
				soundFile = "SOUNDS/mutants/cover/respond_down_1.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 225,
				soundFile = "SOUNDS/mutants/cover/respond_down_2.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 225,
				soundFile = "SOUNDS/mutants/cover/respond_down_3.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 225,
				soundFile = "SOUNDS/mutants/cover/respond_down_4.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
---------------------------------------------------------------------------------

	ORDER_RECEIVED = {
	--This signal is generated when a team member accepts an order from the leader
	--eg. "Right"
				{
				PROBABILITY = 150,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
---------------------------------------------------------------------------------
	GRENADE_SEEN = {
	--This signal is generated when an AI sees a grenade that could threaten him.
	--eg. "Incoming", "Grenade!"
				{
				PROBABILITY = 500,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
---------------------------------------------------------------------------------
	GAS_GRENADE_EFFECT = {
	--Suffocation noises / animation in response to a gas grenade.
	--eg. <Suffocating noises> <Wheezing noises>
				{
				PROBABILITY = 500,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	FLASHBANG_GRENADE_EFFECT = {
	--Blinded  noises / animation in response to a flashbang grenade.
	--eg. "I cant see" "Im blinded"
				{
				PROBABILITY = 500,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	RESPOND_CLEAR = {
	--Team member responds with clear sign after status check from Leader
				{
				PROBABILITY = 500,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	IDLE_TO_INTERESTED  = {
	--Enemy was previously careless and happy. There was a sound or another type of target, 
	--but he could not decide whether it was an enemy. He should not be overly aggressive.
	-- eg. "Huh?" "Mmmh?"
				{
				PROBABILITY = 250,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	FIRST_HOSTILE_CONTACT = {
	--The enemy has perceived a hostile target for the first time. 
	--He would not say “There HE is”, because that implies that he already had HIM as a target.
	--eg. "There!", "Intruder"
				{
				PROBABILITY = 250,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	 STAY_ALERT = {
	--The enemy had some sort of disturbance or was otherwise threatened, but after some minutes 
	--there is no follow up. So now he is just about to relax a little bit, but stay alerted.
	--eg. "Somethings there - I know it!", "Keep alert!"
				{
				PROBABILITY = 250,
				soundFile = "SOUNDS/mutants/cover/stay_alert_1.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 250,
				soundFile = "SOUNDS/mutants/cover/stay_alert_2.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 250,
				soundFile = "SOUNDS/mutants/cover/stay_alert_3.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 250,
				soundFile = "SOUNDS/mutants/cover/stay_alert_4.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	
	ENEMY_TARGET_LOST = {
	--The enemy lost the contact with his immediate hostile target. 
	--This doesn’t happen every time the hostile target hides behind a rock 
	--this happens after there wasn’t any contact with it for some minutes.
	--eg. "Dammit - I lost him!", "Where did he go?"
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/mutants/cover/enemy_target_lost_1.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/mutants/cover/enemy_target_lost_2.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/mutants/cover/enemy_target_lost_3.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/mutants/cover/enemy_target_lost_4.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/mutants/cover/enemy_target_lost_5.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	ENEMY_TARGET_REGAIN = {
	--The enemy has regained contact with a target that he was engaged with before 
	--or was otherwise threatened by. “There he is” would do nicely here.
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/mutants/cover/enemy_target_regain_1.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/mutants/cover/enemy_target_regain_2.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/mutants/cover/enemy_target_regain_3.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/mutants/cover/enemy_target_regain_4.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/mutants/cover/enemy_target_regain_5.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	IDLE_TO_THREATENED = {
	--Enemy was careless and happy before, and now there is an obviously hostile target 
	--which may or may not be an actual enemy (can be an explosion or a gunshot).
	-- eg. "Holy cow!"
				{
				PROBABILITY = 250,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	GETTING_SHOT_AT = {
	--I think this one is fairly self-explanatory, but just in case – this is when 
	--the enemy detects that someone is shooting at him (emphasis on someone!!!). 
	--He does not know who!
	--eg. "Someones shooting at me !"
				{
				PROBABILITY = 50,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	FRIEND_DEATH = {
	--The enemy detected that one of his friends (people with the same group as him) 
	--has just been shoot, or otherwise died. He does not know who shot him!
	--eg. "Man hit!"
				{
				PROBABILITY = 500,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	DEAD_BODY_FOUND = {
	--The enemy found a dead body. He does not know who killed him.
	--eg. "Man down!"
				{
				PROBABILITY = 500,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	INTERESTED_TO_IDLE = {
	--There was some kind of target, but it somehow went away, and the 
	--enemy has no desire to pursue it any further.
	--eg. "They don't pay me enough for this crap!", "Whatever"
				{
				PROBABILITY = 250,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	GET_REINFORCEMENTS = {
	--Enemy announces that he will go and try to get reinforcements.
	--eg. "I'll get help!"
				{
				PROBABILITY = 500,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	CALL_REINFORCEMENTS = {
	--Enemy uses radio or similiar to call reinforcements.
	--eg. "We need help here!"
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/mutants/cover/call_reinforcements_1.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/mutants/cover/call_reinforcements_2.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/mutants/cover/call_reinforcements_3.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/mutants/cover/call_reinforcements_4.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/mutants/cover/call_reinforcements_5.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	FIRE_IN_THE_HOLE = {
	--The AI is about to throw a grenade (of any kind so far, later we can classify it).
	-- eg. "Fire in the hole!", "Grenade"
				{
				PROBABILITY = 200,
				soundFile = "SOUNDS/mutants/cover/fire_in_the_hole_1.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 200,
				soundFile = "SOUNDS/mutants/cover/fire_in_the_hole_2.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 200,
				soundFile = "SOUNDS/mutants/cover/fire_in_the_hole_3.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 200,
				soundFile = "SOUNDS/mutants/cover/fire_in_the_hole_4.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 200,
				soundFile = "SOUNDS/mutants/cover/fire_in_the_hole_5.wav",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			}		


	
}