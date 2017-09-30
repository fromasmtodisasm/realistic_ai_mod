-- TEMPLATE
-- DO NOT MODIFY THIS TEMPLATE
--
-- This template has all the readability signals currently in use.  
-- Change the <Template> string to the pack name
-- 
-- To switch between alternate sound responses add a new set of 
-- bracketed parameters, making sure there is a comma after the bracket eg,
--				{
--				PROBABILITY = 300,
--				soundFile = "SOUNDS/<full path to wav file>",
--				Volume = 120,
--				min = 2,
--				max = 15,
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

SOUNDPACK.Template = {
-----------------------------------------------------------------------------------
	AI_AGGRESSIVE = {
	--AI reacts to unexpected event such as player seen
	-- eg. what the heck, crikey
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
-----------------------------------------------------------------------------------
	ACT_SURPRISED = {
	--AI reacts to unexpected event such as player seen
	-- eg. what the heck, crikey
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
-----------------------------------------------------------------------------------
	ACT_AFRAID = {
	--AI fear gestures
	--eg. "Aaaargh!" , help
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
-----------------------------------------------------------------------------------
	POINTING = {
	--AI sights the player and points to where he can be found
	--"There he is!", "There"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },

-----------------------------------------------------------------------------------
	AI_DOWN = {
	--AI calls out that they have been hit
	-- sound of pain
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
-----------------------------------------------------------------------------------
	RESPOND_DOWN = {
	--Team member responds to one of their team members down
	-- eg. "Man hit!"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
---------------------------------------------------------------------------------
	ORDER_RECEIVED = {
	--This signal is generated when a team member accepts an order from the leader
	--eg. "Right"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
---------------------------------------------------------------------------------
	GRENADE_SEEN = {
	--This signal is generated when an AI sees a grenade that could threaten him.
	--eg. "Incoming", "Grenade!"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
---------------------------------------------------------------------------------
	GAS_GRENADE_EFFECT = {
	--Suffocation noises / animation in response to a gas grenade.
	--eg. <Suffocating noises> <Wheezing noises>
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	FLASHBANG_GRENADE_EFFECT = {
	--Blinded  noises / animation in response to a flashbang grenade.
	--eg. "I cant see" "Im blinded"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	RESPOND_CLEAR = {
	--Team member responds with clear sign after status check from Leader
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	IDLE_TO_INTERESTED  = {
	--Enemy was previously careless and happy. There was a sound or another type of target, 
	--but he could not decide whether it was an enemy. He should not be overly aggressive.
	-- eg. "Huh?" "Mmmh?"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	FIRST_HOSTILE_CONTACT = {
	--The enemy has perceived a hostile target for the first time. 
	--He would not say “There HE is”, because that implies that he already had HIM as a target.
	--eg. "There!", "Intruder"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	 STAY_ALERT = {
	--The enemy had some sort of disturbance or was otherwise threatened, but after some minutes 
	--there is no follow up. So now he is just about to relax a little bit, but stay alerted.
	--eg. "Somethings there - I know it!", "Keep alert!"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	
	ENEMY_TARGET_LOST = {
	--The enemy lost the contact with his immediate hostile target. 
	--This doesn’t happen every time the hostile target hides behind a rock 
	--this happens after there wasn’t any contact with it for some minutes.
	--eg. "Dammit - I lost him!", "Where did he go?"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	ENEMY_TARGET_REGAIN = {
	--The enemy has regained contact with a target that he was engaged with before 
	--or was otherwise threatened by. “There he is” would do nicely here.
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	IDLE_TO_THREATENED = {
	--Enemy was careless and happy before, and now there is an obviously hostile target 
	--which may or may not be an actual enemy (can be an explosion or a gunshot).
	-- eg. "Holy cow!"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	GETTING_SHOT_AT = {
	--I think this one is fairly self-explanatory, but just in case – this is when 
	--the enemy detects that someone is shooting at him (emphasis on someone!!!). 
	--He does not know who!
	--eg. "Someones shooting at me !"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	FRIEND_DEATH = {
	--The enemy detected that one of his friends (people with the same group as him) 
	--has just been shoot, or otherwise died. He does not know who shot him!
	--eg. "Man hit!"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	DEAD_BODY_FOUND = {
	--The enemy found a dead body. He does not know who killed him.
	--eg. "Man down!"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	INTERESTED_TO_IDLE = {
	--There was some kind of target, but it somehow went away, and the 
	--enemy has no desire to pursue it any further.
	--eg. "They don't pay me enough for this crap!", "Whatever"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	GET_REINFORCEMENTS = {
	--Enemy announces that he will go and try to get reinforcements.
	--eg. "I'll get help!"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	CALL_REINFORCEMENTS = {
	--Enemy uses radio or similiar to call reinforcements.
	--eg. "We need help here!"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	FIRE_IN_THE_HOLE = {
	--The AI is about to throw a grenade (of any kind so far, later we can classify it).
	-- eg. "Fire in the hole!", "Grenade"
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	LO_SPLIT_LEFT = {
	--Leader order (LO) for a portion of the team to split left.
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	LO_SPLIT_RIGHT = {
	--Leader order (LO) for a portion of the team to split right.
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	LO_LEFT_ADVANCE = {
	--Left sub-team should advance.
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	LO_RIGHT_ADVANCE = {
	--Right sub-team should advance
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	LO_STATUS_CHECK = {
	--Team leader requests general status check from team. Status checks are 
	--used to communicate to player that the AI are communicating intelligently
	--should not be used too often.
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	LO_STATUS_LEFT = {
	--Team leader requests status check from LEFT team
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	LO_STATUS_RIGHT = {
	--Team leader requests status check from RIGHT team
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	LO_DEFENSIVE = {
	--Team leader requests that the team protect the objective
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	THREATEN = {
	--AI threatens the player while attacking	
	--eg. I'm gonna tear you apart!			
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },
------------------------------------------------------------------------------------
	TELL_LEADER_BAD_NEWS = {
	--Enemy explains to leader that they are being attacked and he needs help
	-- this should be about 3 seconds	
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 2,
				min = 0,
				max = 0,
				sound_unscalable = 0,

			 },


}