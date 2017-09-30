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
--				sound_unscalable = 0,
--				},
-- Probability determines how often a wave is played in response to the signal
-- To allow for possibility of no sound in response to a signal, sounds should sum
-- to less than 1000. eg. if you dont want sound to be played every single time 
-- player receives an order might have total PROBABILITY for all sounds = 500.
--------------------------------------------------
--    Created By: <steve>
--   Description: <short_description>
--------------------------

SOUNDPACK.TemplateSteve = {
---------------------------------------------------------------------------------
	LOOK_FOR_COVER = {
	--This signal is generated when the enemy is trying to find a hiding spot
				{
				PROBABILITY = 300,
				soundFile = "SOUNDS/",
				Volume = 120,
				min = 2,
				max = 15,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 700,
				soundFile = "SOUNDS/",
				Volume = 120,
				min = 2,
				max = 15,
				sound_unscalable = 0,
				},

			 },
-----------------------------------------------------------------------------------
	ACT_SURPRISED = {
	--AI reacts to unexpected event such as player seen
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,

			 },
-----------------------------------------------------------------------------------
	ACT_AFRAID = {
	--AI fear gestures
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/d1.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/d2.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/d3.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/d4.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/d5.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
-----------------------------------------------------------------------------------
	POINTING = {
	--AI sights the player and points to where he can be found
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/ainame/c1.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/ainame/c2.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/ainame/c3.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/ainame/c4.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/ainame/c5.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/ainame/c6.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/ainame/c7.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
			 

-----------------------------------------------------------------------------------
	AI_DOWN = {
	--AI calls out that they have been hit
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/g1.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/g2.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/g3.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/g4.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/g5.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
-----------------------------------------------------------------------------------
	RESPOND_DOWN = {
	--Team member responds to one of their team members down, eg call for help
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/f1.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/f2.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/f3.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/f4.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
-----------------------------------------------------------------------------------
	LOW_AMMO = {
	--Team member announces that they have low ammo / need ammo
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/h1.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/h2.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/h3.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/h4.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/h5.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/h6.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/h7.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/h8.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/h9.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
-----------------------------------------------------------------------------------
	BLINDED = {
	--AI visibility limited
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/i1.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/i2.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/i3.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/i4.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	IN_POSITION = {
	--Generated when a team member has successfully finished a relocation order or movement order from the team leader.
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	ORDER_RECEIVED = {
	--This signal is generated when a team member accepts an order from the leader
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	RESPOND_CLEAR = {
	--Team member responds with clear sign after status check from Leader
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/b1.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/b2.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/b3.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/b4.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/b5.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/b6.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	FIRST_CONTACT = {
	--The enemy has some kind of contact with a target, but has yet to establish whether it is a hostile or a friendly one.
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/m1.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/m2.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/m3.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/m4.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/m5.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/m6.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	FIRST_HOSTILE_CONTACT = {
	--The enemy has perceived a hostile target for the first time.
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/l1.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/l2.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/l3.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/l4.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	
	ENEMY_TARGET_LOST = {
	--The enemy lost the contact with his immediate hostile target.
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/o1.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/o2.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/o3.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/o4.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/o5.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/o6.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/o7.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/o8.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/o9.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/o10.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/o11.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/o12.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	ENEMY_TARGET_REGAIN = {
	--The enemy has regained contact with the lost target.
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/p1.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/p2.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/p3.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/p4.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/p5.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	SCARY_EVENT = {
	--The enemy has heard or otherwise felt (but not seen) a scary thing happen.
				{	
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/d1.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{	
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/d2.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{	
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/d3.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{	
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/d4.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{	
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/d5.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	DISTURBANCE = {
	--The enemy feels a disturbance in the force. Something has changed in the environment but the enemy cannot pinpoint its source.
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/k1.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/k2.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/k3.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	FIRE_IN_THE_HOLE = {
	--The enemy is about to throw a grenade (of any kind so far, later we can classify it).
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	LO_SPLIT_LEFT = {
	--Leader order (LO) for a portion of the team to split left. Bravo, delta
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/e1.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/e4.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/e6.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/e17.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/e19.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/e21.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				

			 },
------------------------------------------------------------------------------------
	LO_SPLIT_RIGHT = {
	--Leader order (LO) for a portion of the team to split right. Alpha charle
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/e2.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/e5.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/e7.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/e16.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/18.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/e20.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	LO_LEFT_ADVANCE = {
	--Left sub-team should advance. Bravo team, Delta team
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e3.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e23.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e34.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e35.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e36.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e37.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e38.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e39.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e40.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e41.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e42.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e43.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e44.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e45.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e46.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e47.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e48.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e49.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				

			 },
------------------------------------------------------------------------------------
	LO_RIGHT_ADVANCE = {
	--Right sub-team should advance.Alpha team, Charle team 
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e3.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e22.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e26.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e27.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e28.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e29.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e30.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e31.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e32.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e33.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e42.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e43.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e44.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e45.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e46.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e47.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e48.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 55,
				soundFile = "Sounds/dialog/max/e49.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 }
------------------------------------------------------------------------------------
	LO_STATUS_CHECK = {
	--Team leader requests general status check from team. Status checks are 
	--used to communicate to player that the AI are communicating intelligently
	--should not be used too often.
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/a1_all.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/a2_all.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/a8_all.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/a9_all.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	LO_STATUS_LEFT = {
	--Team leader requests status check from LEFT team Bravo team, Delta team
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/a1_bravo.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/a2_bravo.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/a8_bravo.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/a9_bravo.wav",
				Volume = 225,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},

			 },
------------------------------------------------------------------------------------
	LO_STATUS_RIGHT = {
	--Team leader requests status check from RIGHT team. Alpha team, Charle team
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/a1_alpha.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/a2_alpha.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/a8_alpha.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 1000,
				soundFile = "SOUNDS/dialog/AIname/a9_alpha.wav",
				Volume = 255,
				min = 1,
				max = 100000,
				sound_unscalable = 0,
				},
				
			},
				
---------------------------------------------------------------------------------
	REQUEST_JOIN = {
	--Team member asks to join new group
				{
				PROBABILITY = 300,
				soundFile = "SOUNDS/dialog/AIname/??.wav",
				Volume = 120,
				min = 2,
				max = 15,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 700,
				soundFile = "SOUNDS/dialog/AIname/??.wav",
				Volume = 120,
				min = 2,
				max = 15,
				sound_unscalable = 0,
				},
				
			}'
				
---------------------------------------------------------------------------------
	TO_ACCEPT = {
	--Team leader accepts the new recruit
				{
				PROBABILITY = 300,
				soundFile = "SOUNDS/dialog/AIname/??.wav",
				Volume = 120,
				min = 2,
				max = 15,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 700,
				soundFile = "SOUNDS/dialog/AIname/??.wav",
				Volume = 120,
				min = 2,
				max = 15,
				sound_unscalable = 0,
				},
				
			},
				
---------------------------------------------------------------------------------
	TO_REJECT = {
	--Team leader rejects the new recruit
				{
				PROBABILITY = 300,
				soundFile = "SOUNDS/dialog/AIname/??.wav",
				Volume = 120,
				min = 2,
				max = 15,
				sound_unscalable = 0,
				},
				
				{
				PROBABILITY = 700,
				soundFile = "SOUNDS/dialog/AIname/??.wav",
				Volume = 120,
				min = 2,
				max = 15,
				sound_unscalable = 0,
				},
				
			 },
------------------------------------------------------------------------------------
}