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
--				Volume = 175,
--				min = 4,
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
SOUNDPACK.dialog_template = {
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
	ACT_SURPRISED = {
	--AI reacts to unexpected event such as player seen
	-- eg. what the heck, crikey
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/2.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/3.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

			 },
			 
-----------------------------------------------------------------------------------
	AI_AGGRESSIVE = {
	--AI reacts to unexpected event such as player seen
	-- eg. what the heck, crikey
				{
				PROBABILITY = 20,
				soundFile = "SOUNDS/nov_dialog/aggression1.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 20,
				soundFile = "SOUNDS/nov_dialog/aggression2.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 20,
				soundFile = "SOUNDS/nov_dialog/aggression3.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 20,
				soundFile = "SOUNDS/nov_dialog/aggression4.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 20,
				soundFile = "SOUNDS/nov_dialog/aggression5.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 20,
				soundFile = "SOUNDS/nov_dialog/aggression6.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 20,
				soundFile = "SOUNDS/nov_dialog/aggression7.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 20,
				soundFile = "SOUNDS/nov_dialog/aggression8.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 20,
				soundFile = "SOUNDS/nov_dialog/aggression9.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 20,
				soundFile = "SOUNDS/nov_dialog/aggression10.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 20,
				soundFile = "SOUNDS/nov_dialog/aggression11.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 20,
				soundFile = "SOUNDS/nov_dialog/aggression12.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 20,
				soundFile = "SOUNDS/nov_dialog/aggression13.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 20,
				soundFile = "SOUNDS/nov_dialog/aggression14.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 20,
				soundFile = "SOUNDS/nov_dialog/aggression15.wav",
				Volume = 175,
				min = 4,
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
				soundFile = "SOUNDS/nov_dialog/9.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/10.wav",
				Volume = 175,
				min = 4,
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
				soundFile = "SOUNDS/nov_dialog/15.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/16.wav",
				Volume = 175,
				min = 4,
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
				soundFile = "SOUNDS/e3ai/pain/pain1.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 250,
				soundFile = "SOUNDS/e3ai/pain/pain2.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 250,
				soundFile = "SOUNDS/e3ai/pain/pain3.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 250,
				soundFile = "SOUNDS/e3ai/pain/pain4.wav",
				Volume = 175,
				min = 4,
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
				soundFile = "SOUNDS/nov_dialog/33.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/34.wav",
				Volume = 175,
				min = 4,
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
				soundFile = "SOUNDS/nov_dialog/39.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 150,
				soundFile = "SOUNDS/nov_dialog/40.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

			 },
---------------------------------------------------------------------------------
	GRENADE_SEEN = {
	--This signal is generated when an AI sees a grenade that could threaten him.
	--eg. "Incoming", "Grenade!"
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/nov_dialog/45.wav",
				Volume = 175,
				min = 4,
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
				soundFile = "SOUNDS/nov_dialog/51.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/52.wav",
				Volume = 175,
				min = 4,
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
				soundFile = "SOUNDS/nov_dialog/57.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/58.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	RESPOND_CLEAR = {
	--Team member responds with clear sign after status check from Leader
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/63.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/64.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

			 },
-----------------------------------------------------------------------------------
	IDLE_TO_INTERESTED_GROUP  = {

				{
				PROBABILITY = 142,
				soundFile = "SOUNDS/nov_dialog/somebody_there.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 142,
				soundFile = "SOUNDS/nov_dialog/someone_here.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 142,
				soundFile = "SOUNDS/more_dialog/8.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 142,
				soundFile = "SOUNDS/more_dialog/9.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 142,
				soundFile = "SOUNDS/more_dialog/10.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 142,
				soundFile = "SOUNDS/more_dialog/11.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 142,
				soundFile = "SOUNDS/more_dialog/112.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				

			},


	IDLE_TO_INTERESTED  = {
	--Enemy was previously careless and happy. There was a sound or another type of target, 
	--but he could not decide whether it was an enemy. He should not be overly aggressive.
	-- eg. "Huh?" "Mmmh?"

				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/nov_dialog/somebody_there.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/nov_dialog/someone_here.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},


				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/nov_dialog/69.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/nov_dialog/70.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/1.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/2.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/3.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/4.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/5.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/6.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/7.wav",
				Volume = 225,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------

	FIRST_HOSTILE_CONTACT_GROUP = {
	--The enemy has perceived a hostile target for the first time. 
	--He would not say “There HE is”, because that implies that he already had HIM as a target.
	--eg. "There!", "Intruder"
				{
				PROBABILITY = 200,
				soundFile = "SOUNDS/nov_dialog/get_that_guy.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 200,
				soundFile = "SOUNDS/more_dialog/19.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 200,
				soundFile = "SOUNDS/more_dialog/20.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 200,
				soundFile = "SOUNDS/more_dialog/21.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 200,
				soundFile = "SOUNDS/more_dialog/22.wav",
				Volume = 175,
				min = 4,
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
				PROBABILITY = 125,
				soundFile = "SOUNDS/nov_dialog/get_that_guy.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/nov_dialog/get_him.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/more_dialog/13.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/more_dialog/14.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/more_dialog/15.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/more_dialog/16.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/more_dialog/17.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/more_dialog/18.wav",
				Volume = 175,
				min = 4,
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
				soundFile = "SOUNDS/nov_dialog/81.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/82.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	ENEMY_TARGET_LOST_GROUP = {
				{
				PROBABILITY = 250,
				soundFile = "SOUNDS/nov_dialog/87.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 250,
				soundFile = "SOUNDS/nov_dialog/88.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				
				{
				PROBABILITY = 250,
				soundFile = "SOUNDS/more_dialog/33.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 250,
				soundFile = "SOUNDS/more_dialog/34.wav",
				Volume = 175,
				min = 4,
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
				soundFile = "SOUNDS/nov_dialog/87.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/nov_dialog/88.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/more_dialog/23.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/more_dialog/24.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/more_dialog/25.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/more_dialog/26.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/more_dialog/27.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 125,
				soundFile = "SOUNDS/more_dialog/28.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	ENEMY_TARGET_REGAIN = {
	--The enemy has regained contact with a target that he was engaged with before 
	--or was otherwise threatened by. “There he is” would do nicely here.
				{
				PROBABILITY = 120,
				soundFile = "SOUNDS/nov_dialog/93.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 120,
				soundFile = "SOUNDS/nov_dialog/94.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

				{
				PROBABILITY = 120,
				soundFile = "SOUNDS/nov_dialog/get_that_guy.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

				{
				PROBABILITY = 120,
				soundFile = "SOUNDS/nov_dialog/get_him.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

				{
				PROBABILITY = 120,
				soundFile = "SOUNDS/nov_dialog/he_over_there.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

				{
				PROBABILITY = 120,
				soundFile = "SOUNDS/nov_dialog/i_see_him.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

				{
				PROBABILITY = 280,
				soundFile = "SOUNDS/nov_dialog/kill_him.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

			 },
			 
------------------------------------------------------------------------------------
	LO_DEFENSIVE = {
	--Team leader requests that the team protect the objective
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/take_point.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/take_pointR.wav",
				radioVolume = 50,
				sound_unscalable = 0,
				


				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/hold_ground.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/hold_groundR.wav",
				radioVolume = 50,
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
				soundFile = "SOUNDS/nov_dialog/99.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 250,
				soundFile = "SOUNDS/nov_dialog/100.wav",
				Volume = 175,
				min = 4,
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
				PROBABILITY = 200,
				soundFile = "SOUNDS/nov_dialog/what_hell.wav",
				Volume = 175,
				min = 4,
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
				soundFile = "SOUNDS/nov_dialog/111.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/112.wav",
				Volume = 175,
				min = 4,
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
				soundFile = "SOUNDS/nov_dialog/117.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/118.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

			 },

------------------------------------------------------------------------------------
	INTERESTED_TO_IDLE_GROUP = {
				{
				PROBABILITY = 142,
				soundFile = "SOUNDS/nov_dialog/123.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 142,
				soundFile = "SOUNDS/nov_dialog/124.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 142,
				soundFile = "SOUNDS/more_dialog/45.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 142,
				soundFile = "SOUNDS/more_dialog/46.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 142,
				soundFile = "SOUNDS/more_dialog/47.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 142,
				soundFile = "SOUNDS/more_dialog/48.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 142,
				soundFile = "SOUNDS/more_dialog/49.wav",
				Volume = 175,
				min = 4,
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
				PROBABILITY = 90,
				soundFile = "SOUNDS/nov_dialog/123.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/nov_dialog/124.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/36.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/37.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/38.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/39.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/40.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/41.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/42.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/43.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 90,
				soundFile = "SOUNDS/more_dialog/44.wav",
				Volume = 175,
				min = 4,
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
				soundFile = "SOUNDS/nov_dialog/129.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/130.wav",
				Volume = 175,
				min = 4,
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
				soundFile = "SOUNDS/nov_dialog/135.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/136.wav",
				Volume = 175,
				min = 4,
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
				soundFile = "SOUNDS/nov_dialog/141.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/142.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	LO_SPLIT_LEFT = {
	--Leader order (LO) for a portion of the team to split left.
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/147.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/147R.wav",
				radioVolume = 50,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/148.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/148R.wav",
				radioVolume = 50,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	LO_SPLIT_RIGHT = {
	--Leader order (LO) for a portion of the team to split right.
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/153.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/153R.wav",
				radioVolume = 50,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/154.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/154R.wav",
				radioVolume = 50,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	LO_LEFT_ADVANCE = {
	--Left sub-team should advance.
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/159.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/159R.wav",
				radioVolume = 50,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/160.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/160R.wav",
				radioVolume = 50,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	LO_RIGHT_ADVANCE = {
	--Right sub-team should advance
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/165.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/165R.wav",
				radioVolume = 50,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/166.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/166R.wav",
				radioVolume = 50,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	LO_STATUS_CHECK = {
	--Team leader requests general status check from team. Status checks are 
	--used to communicate to player that the AI are communicating intelligently
	--should not be used too often.
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/171.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/171R.wav",
				radioVolume = 50,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/172.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/172R.wav",
				radioVolume = 50,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	LO_STATUS_LEFT = {
	--Team leader requests status check from LEFT team
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/177.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/177R.wav",
				radioVolume = 50,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/178.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/178R.wav",
				radioVolume = 50,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	LO_STATUS_RIGHT = {
	--Team leader requests status check from RIGHT team
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/183.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/183R.wav",
				radioVolume = 50,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 500,
				soundFile = "SOUNDS/nov_dialog/184.wav",
				Volume = 175,
				min = 4,
				max = 300,
				radioSoundFile = "SOUNDS/nov_dialog/184R.wav",
				radioVolume = 50,
				sound_unscalable = 0,
				},

			 },
			 
------------------------------------------------------------------------------------
	TELL_LEADER_BAD_NEWS = {
	--Enemy explains to leader that they are being attacked and he needs help
	-- this should be about 3 seconds	
				PROBABILITY = 1000,
				soundFile = "SOUNDS/nov_dialog/heavy_attack.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,

			 	},

			
------------------------------------------------------------------------------------
	THREATEN = {
	--AI threatens the player while attacking	
	--eg. I'm gonna tear you apart!			
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/nov_dialog/taunt1.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/nov_dialog/taunt2.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/nov_dialog/taunt3.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/nov_dialog/taunt4.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/nov_dialog/taunt5.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/nov_dialog/taunt6.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/nov_dialog/taunt7.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/nov_dialog/taunt8.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/nov_dialog/taunt9.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/nov_dialog/taunt10.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/nov_dialog/taunt11.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/nov_dialog/taunt12.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/nov_dialog/taunt13.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/more_dialog/50.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/more_dialog/51.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/more_dialog/53.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/more_dialog/54.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/more_dialog/55.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/more_dialog/56.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/more_dialog/57.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/more_dialog/58.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/more_dialog/59.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/more_dialog/60.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/more_dialog/61.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/more_dialog/62.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/more_dialog/63.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 37,
				soundFile = "SOUNDS/more_dialog/64.wav",
				Volume = 175,
				min = 4,
				max = 300,
				sound_unscalable = 0,
				},

			 },


}