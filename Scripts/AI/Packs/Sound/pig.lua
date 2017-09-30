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
--				Volume = 255,
--				min = 2,
--				max = 300,
--				sound_unscalable = 1,
--				},
-- Probability determines how often a wave is played in response to the signal
-- To allow for possibility of no sound in response to a signal, sounds should sum
-- to less than 1000. eg. if you dont want sound to be played every single time 
-- player receives an order might have total PROBABILITY for all sounds = 500.
--------------------------------------------------
--    Created By: <your_name>
--   Description: <short_description>
--------------------------
SOUNDPACK.pig = {
-----------------------------------------------------------------------------------
	CHATTERING = {
	-- general background mutants type muttering, creepiness good 
				{
				PROBABILITY = 100,
				soundFile = "SOUNDS/pig/piggrunt1.wav",
				Volume = 155,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				
				{
				PROBABILITY = 100,
				soundFile = "SOUNDS/pig/piggrunt1.wav",
				Volume = 155,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 100,
				soundFile = "SOUNDS/pig/piggrunt3.wav",
				Volume = 155,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 100,
				soundFile = "SOUNDS/pig/piggrunt4.wav",
				Volume = 155,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
-----------------------------------------------------------------------------------
	PAIN = {
	--response to being hit by bullets eg. aaghh!, ouch would not be considered sufficiently macho
				{
				PROBABILITY = 333,
				soundFile = "SOUNDS/pig/pigpain1.wav",
				Volume = 155,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				
				
				{
				PROBABILITY = 333,
				soundFile = "SOUNDS/pig/pigpain2.wav",
				Volume = 155,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 333,
				soundFile = "SOUNDS/pig/pigpain3.wav",
				Volume = 155,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
-----------------------------------------------------------------------------------
	DEATH = {
	-- sad ballad of death - eg. aaaaaaaaaaggghhhh! oh... Im dieing tell .....
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/pig/pigdeath.wav",
				Volume = 155,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				
			 },
-----------------------------------------------------------------------------------
	JUMP = {
	-- sound of mutants leaving ground and flying through the air
				{
				PROBABILITY = 1000,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
			 
-----------------------------------------------------------------------------------
	EAT = {
	-- mutant eating corpses sound
				{
				PROBABILITY = 1000,
				soundFile = "",
				Volume = 125,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
			 
-----------------------------------------------------------------------------------
	MELEE_SWIPE = {
	-- fearsome sound of mutant claw slicing through air
				{
				PROBABILITY = 333,
				soundFile = "",
				Volume = 55,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 333,
				soundFile = "",
				Volume = 55,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 333,
				soundFile = "",
				Volume = 55,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
			 
-----------------------------------------------------------------------------------
	MELEE_BITE = {
	-- chomp
				{
				PROBABILITY = 500,
				soundFile = "",
				Volume = 55,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "",
				Volume = 55,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			 },
-----------------------------------------------------------------------------------
	MELEE_ATTACK = {
	-- horrible grunting and salivating a terror to behold
				{
				PROBABILITY = 83,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 83,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 83,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 83,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 83,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 83,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 83,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 83,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 83,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 83,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 83,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 83,
				soundFile = "",
				Volume = 255,
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
				Volume = 255,
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
				Volume = 255,
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
				PROBABILITY = 166,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 166,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 166,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 166,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 166,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 166,
				soundFile = "",
				Volume = 255,
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
				Volume = 255,
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
				PROBABILITY = 500,
				soundFile = "",
				Volume = 255,
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
				Volume = 255,
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
				PROBABILITY = 500,
				soundFile = "",
				Volume = 255,
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
				Volume = 255,
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
				Volume = 255,
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
				Volume = 255,
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
				Volume = 255,
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
				Volume = 255,
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
				Volume = 255,
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
				Volume = 255,
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
				PROBABILITY = 500,
				soundFile = "",
				Volume = 255,
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
				PROBABILITY = 250,
				soundFile = "",
				Volume = 255,
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
				PROBABILITY = 500,
				soundFile = "",
				Volume = 255,
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
				Volume = 255,
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
				Volume = 255,
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
				Volume = 255,
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
				Volume = 255,
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
				Volume = 255,
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
				Volume = 255,
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
				PROBABILITY = 500,
				soundFile = "",
				Volume = 255,
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
				PROBABILITY = 500,
				soundFile = "",
				Volume = 255,
				min = 2,
				max = 300,
				sound_unscalable = 0,
				},
			}			
}