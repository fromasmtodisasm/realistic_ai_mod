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
--				min = 12,
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
SOUNDPACK.Valerie = {
-----------------------------------------------------------------------------------

-----------------------------------------------------------------------------------
	LETS_CONTINUE = {
		-- valerie says this when she is ready to resume a special behaviour, like following or leading
				{
				PROBABILITY = 250,
				soundFile = "languages/missiontalk/swamp/swamp_specific_K_4.wav",
				-- lets go
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 250,
				soundFile = "languages/missiontalk/swamp/swamp_specific_K_5.wav",
				-- go..go..go
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},

			 },



-----------------------------------------------------------------------------------
	WE_HAVE_BEEN_DISCOVERED = {
		-- valerie says this when she is coming out of a special behaviour like leading or following because she 
		-- saw or heard something
				{
				PROBABILITY = 125,
				soundFile = "languages/missiontalk/swamp/swamp_specific_E_4.wav",
				-- we got company
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 125,
				soundFile = "languages/missiontalk/swamp/swamp_specific_E_16.wav",
				-- careful, Jack
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 125,
				soundFile = "languages/missiontalk/swamp/swamp_specific_E_8.wav",
				-- over there
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 125,
				soundFile = "languages/missiontalk/swamp/swamp_specific_E_9.wav",
				-- get em
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				

			 },

-----------------------------------------------------------------------------------
	THERE_IS_STILL_SOMEONE = {
		-- valerie says this when she thinks that there are still some alerted people in the vicinity
				{
				PROBABILITY = 200,
				soundFile = "languages/missiontalk/swamp/still_someone_a1.wav",
				-- hang on
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 200,
				soundFile = "languages/missiontalk/swamp/still_someone_a2.wav",
				-- right on top of us
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 200,
				soundFile = "languages/missiontalk/swamp/still_someone_a3.wav",
				-- damm it
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				
			 },


-----------------------------------------------------------------------------------
	-- FOLLOWING_PLAYER = {
		-- valerie says this when she starts following the player
			-- {
			-- PROBABILITY = 333,
			--	soundFile = "languages/missiontalk/swamp/following_player_a1.wav",
			--	-- right behind you
			--	Volume = 255,
			--	min = 12,
			--	max = 300,
			--	sound_unscalable = 0,
			--	},
			--	{
			--	PROBABILITY = 333,
			--	soundFile = "languages/missiontalk/swamp/following_player_a2.wav",
			--	-- hang on, I am coming
			--	Volume = 255,
			--	min = 12,
			--	max = 300,
			--	sound_unscalable = 0,
			--	},
			--	{
			--	PROBABILITY = 333,
			--	soundFile = "languages/missiontalk/swamp/following_player_a3.wav",
			--	-- I've got your back
			--	Volume = 255,
			--	min = 12,
			--	max = 300,
			--	sound_unscalable = 0,
			--	},
		--	 },

-----------------------------------------------------------------------------------
	SPECIAL_GOT_TO_WAYPOINT = {
		-- valerie says this when she has reached a leading waypoint - she is calling the player to come
				{
				PROBABILITY = 190,
				soundFile = "languages/missiontalk/swamp/go_to_waypoint_a1.wav",
				-- move it... hurry up
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 190,
				soundFile = "languages/missiontalk/swamp/go_to_waypoint_a2.wav",
				-- keep it up, Jack
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 190,
				soundFile = "languages/missiontalk/swamp/go_to_waypoint_a3.wav",
				-- follow me, Jack
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				
				

			 },


-----------------------------------------------------------------------------------
	-- RANDOM_IDLE_SOUND = { },
			 
			 
-----------------------------------------------------------------------------------
	--  RELOADING = { },
			 
-----------------------------------------------------------------------------------
	--AI_AGGRESSIVE = {
	--AI reacts to unexpected event such as player seen
	-- eg. what the heck, crikey
				--{
				--PROBABILITY = 20,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--sound_unscalable = 0,
				--},
				
				

			-- },
-----------------------------------------------------------------------------------
	--ACT_AFRAID = {
	--AI fear gestures
	--eg. "Aaaargh!" , help
				--{
				--PROBABILITY = 500,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--sound_unscalable = 0,
				--},
				
				

			 --},
-----------------------------------------------------------------------------------
	--POINTING = {
	--AI sights the player and points to where he can be found
	--"There he is!", "There"
				--{
				--PROBABILITY = 500,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--sound_unscalable = 0,
				--},
				
				

			-- },
-----------------------------------------------------------------------------------
	--AI_DOWN = {
	--AI calls out that they have been hit
	-- sound of pain
				--{
				--PROBABILITY = 250,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--sound_unscalable = 0,
				--},
				
				

			-- },
-----------------------------------------------------------------------------------
	--RESPOND_DOWN = {
	--Team member responds to one of their team members down
	-- eg. "Man hit!"
				--{
				--PROBABILITY = 500,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--sound_unscalable = 0,
				--},
				
				

			-- },
---------------------------------------------------------------------------------
	ORDER_RECEIVED = {
	--This signal is generated when a team member accepts an order from the leader
	--eg. "Right"
				{
				PROBABILITY = 100,
				soundFile = "LANGUAGES/voicepacks/Val/affirmative_1.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 100,
				soundFile = "LANGUAGES/voicepacks/Val/affirmative_2.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 100,
				soundFile = "LANGUAGES/voicepacks/Val/affirmative_3.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 100,
				soundFile = "LANGUAGES/voicepacks/Val/affirmative_4.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 100,
				soundFile = "LANGUAGES/voicepacks/Val/affirmative_5.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 100,
				soundFile = "LANGUAGES/voicepacks/Val/affirmative_6.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 100,
				soundFile = "LANGUAGES/voicepacks/Val/affirmative_7.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 100,
				soundFile = "LANGUAGES/voicepacks/Val/affirmative_8.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 100,
				soundFile = "LANGUAGES/voicepacks/Val/affirmative_9.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 100,
				soundFile = "LANGUAGES/voicepacks/Val/affirmative_10.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				
				

			 },
---------------------------------------------------------------------------------
	--GRENADE_SEEN = {
	--This signal is generated when an AI sees a grenade that could threaten him.
	--eg. "Incoming", "Grenade!"
				--{
				--PROBABILITY = 1000,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--sound_unscalable = 0,
				--},
				
				

			 --},
---------------------------------------------------------------------------------
	--GAS_GRENADE_EFFECT = {
	--Suffocation noises / animation in response to a gas grenade.
	--eg. <Suffocating noises> <Wheezing noises>
				--{
				--PROBABILITY = 500,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--sound_unscalable = 0,
				--},
				
				

			 --},
------------------------------------------------------------------------------------
	-- FLASHBANG_GRENADE_EFFECT = {
	--Blinded  noises / animation in response to a flashbang grenade.
	--eg. "I cant see" "Im blinded"
				
				
			--  },
------------------------------------------------------------------------------------
	--RESPOND_CLEAR = {
	--Team member responds with clear sign after status check from Leader
				--{
				--PROBABILITY = 500,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--sound_unscalable = 0,
				--},
				
				

			-- },
-----------------------------------------------------------------------------------
	-- IDLE_TO_INTERESTED_GROUP  = {

			-- },


	-- IDLE_TO_INTERESTED  = {
	--Enemy was previously careless and happy. There was a sound or another type of target, 
	--but he could not decide whether it was an enemy. He should not be overly aggressive.
	-- eg. "Huh?" "Mmmh?"


			--  },
------------------------------------------------------------------------------------

	-- FIRST_HOSTILE_CONTACT_GROUP = {
	--The enemy has perceived a hostile target for the first time. 
	--He would not say “There HE is”, because that implies that he already had HIM as a target.
	--eg. "There!", "Intruder"
							
				
			--  },

------------------------------------------------------------------------------------
				

	-- FIRST_HOSTILE_CONTACT = {
	--The enemy has perceived a hostile target for the first time. 
	--He would not say “There HE is”, because that implies that he already had HIM as a target.
	--eg. "There!", "Intruder"
					
				

			--  },
------------------------------------------------------------------------------------
	 --STAY_ALERT = {
	--The enemy had some sort of disturbance or was otherwise threatened, but after some minutes 
	--there is no follow up. So now he is just about to relax a little bit, but stay alerted.
	--eg. "Somethings there - I know it!", "Keep alert!"
				--{
				--PROBABILITY = 500,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--sound_unscalable = 0,
				--},
				
				

			-- },
------------------------------------------------------------------------------------
	-- ENEMY_TARGET_LOST_GROUP = {
				
				
				

			--  },
------------------------------------------------------------------------------------
	
	-- ENEMY_TARGET_LOST = {
	--The enemy lost the contact with his immediate hostile target. 
	--This doesn’t happen every time the hostile target hides behind a rock 
	--this happens after there wasn’t any contact with it for some minutes.
	--eg. "Dammit - I lost him!", "Where did he go?"
				
				
				

			--  },
------------------------------------------------------------------------------------
	--ENEMY_TARGET_REGAIN = {
	--The enemy has regained contact with a target that he was engaged with before 
	--or was otherwise threatened by. “There he is” would do nicely here.
				--{
				--PROBABILITY = 120,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--sound_unscalable = 0,
				--},
				
				

			-- },
			 
------------------------------------------------------------------------------------
	--LO_DEFENSIVE = {
	--Team leader requests that the team protect the objective
				--{
				--PROBABILITY = 500,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--soundFile = "SOUNDS/e3dialog/voiceA/R_voiceA.wav",
				--radioVolume = 50,
				--sound_unscalable = 0,
				--},
				
				

			-- },
------------------------------------------------------------------------------------
	-- IDLE_TO_THREATENED = {
	--Enemy was careless and happy before, and now there is an obviously hostile target 
	--which may or may not be an actual enemy (can be an explosion or a gunshot).
	-- eg. "Holy cow!"

								

			--  },
------------------------------------------------------------------------------------
	GETTING_SHOT_AT = {
	--I think this one is fairly self-explanatory, but just in case – this is when 
	--the enemy detects that someone is shooting at him (emphasis on someone!!!). 
	--He does not know who!
	--eg. "Someones shooting at me !"
				{
				PROBABILITY = 90,
				soundFile = "LANGUAGES/voicepacks/Val/receive_fire_alone_1.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 70,
				soundFile = "LANGUAGES/voicepacks/Val/receive_fire_alone_2.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 70,
				soundFile = "LANGUAGES/voicepacks/Val/receive_fire_alone_3.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 70,
				soundFile = "LANGUAGES/voicepacks/Val/receive_fire_alone_4.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 70,
				soundFile = "LANGUAGES/voicepacks/Val/receive_fire_alone_5.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 70,
				soundFile = "LANGUAGES/voicepacks/Val/receive_fire_alone_6.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 70,
				soundFile = "LANGUAGES/voicepacks/Val/receive_fire_alone_8.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 70,
				soundFile = "LANGUAGES/voicepacks/Val/receive_fire_alone_9.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 70,
				soundFile = "LANGUAGES/voicepacks/Val/receive_fire_alone_10.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 70,
				soundFile = "LANGUAGES/voicepacks/Val/receive_fire_alone_11.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 70,
				soundFile = "LANGUAGES/voicepacks/Val/receive_fire_alone_12.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 70,
				soundFile = "LANGUAGES/voicepacks/Val/receive_fire_alone_13.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 70,
				soundFile = "LANGUAGES/voicepacks/Val/receive_fire_alone_14.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
				{
				PROBABILITY = 70,
				soundFile = "LANGUAGES/voicepacks/Val/receive_fire_alone_15.wav",
				Volume = 255,
				min = 12,
				max = 300,
				sound_unscalable = 0,
				},
			 },
------------------------------------------------------------------------------------
	-- FRIEND_DEATH = {
	--The enemy detected that one of his friends (people with the same group as him) 
	--has just been shoot, or otherwise died. He does not know who shot him!
	--eg. "Man hit!"
								

			--  },
------------------------------------------------------------------------------------
	--DEAD_BODY_FOUND = {
	--The enemy found a dead body. He does not know who killed him.
	--eg. "Man down!"
				--{
				--PROBABILITY = 500,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--sound_unscalable = 0,
				--},
				
				

			 --},

------------------------------------------------------------------------------------
	-- INTERESTED_TO_IDLE_GROUP = {
		
			--  },

------------------------------------------------------------------------------------
	-- INTERESTED_TO_IDLE = {
	--There was some kind of target, but it somehow went away, and the 
	--enemy has no desire to pursue it any further.
	--eg. "They don't pay me enough for this crap!", "Whatever"
				
			--  },
------------------------------------------------------------------------------------
	-- GET_REINFORCEMENTS = {
	--Enemy announces that he will go and try to get reinforcements.
	--eg. "I'll get help!"
				
			--  },
------------------------------------------------------------------------------------
	-- CALL_REINFORCEMENTS = {
	--Enemy uses radio or similiar to call reinforcements.
	--eg. "We need help here!"
				
			-- },
------------------------------------------------------------------------------------
	-- FIRE_IN_THE_HOLE = {
	--The AI is about to throw a grenade (of any kind so far, later we can classify it).
	-- eg. "Fire in the hole!", "Grenade"
				
			--  },
------------------------------------------------------------------------------------
	-- LO_SPLIT_LEFT = {
	--Leader order (LO) for a portion of the team to split left.
				
				
				

			--  },
------------------------------------------------------------------------------------
	-- LO_SPLIT_RIGHT = {
	--Leader order (LO) for a portion of the team to split right.
				
				
				

			--  },
------------------------------------------------------------------------------------
	-- LO_LEFT_ADVANCE = {
	--Left sub-team should advance.
					

			--  },
------------------------------------------------------------------------------------
	-- LO_RIGHT_ADVANCE = {
	--Right sub-team should advance
				
			--  },
------------------------------------------------------------------------------------
	--LO_STATUS_CHECK = {
	--Team leader requests general status check from team. Status checks are 
	--used to communicate to player that the AI are communicating intelligently
	--should not be used too often.
				--{
				--PROBABILITY = 500,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--soundFile = "SOUNDS/e3dialog/voiceA/R_voiceA.wav",
				--radioVolume = 50,
				--sound_unscalable = 0,
				--},
				
				

			 --},
------------------------------------------------------------------------------------
	--LO_STATUS_LEFT = {
	--Team leader requests status check from LEFT team
				--{
				--PROBABILITY = 500,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--soundFile = "SOUNDS/e3dialog/voiceA/R_voiceA.wav",
				--radioVolume = 50,
				--sound_unscalable = 0,
				--},
				
				

			-- },
------------------------------------------------------------------------------------
	--LO_STATUS_RIGHT = {
	--Team leader requests status check from RIGHT team
				--{
				--PROBABILITY = 500,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--soundFile = "SOUNDS/e3dialog/voiceA/R_voiceA.wav",
				--radioVolume = 50,
				--sound_unscalable = 0,
				--},
				
				

			 --},
			 
------------------------------------------------------------------------------------
	--TELL_LEADER_BAD_NEWS = {
	--Enemy explains to leader that they are being attacked and he needs help
	-- this should be about 3 seconds	
				--PROBABILITY = 1000,
				--soundFile = "SOUNDS/e3dialog/voiceA/_voiceA.wav",
				--Volume = 255,
				--min = 12,
				--max = 300,
				--sound_unscalable = 0,

			 	--},

			
------------------------------------------------------------------------------------
	-- THREATEN = {
	--AI threatens the player while attacking	
	--eg. I'm gonna tear you apart!			
				
			-- },


}