-- Global root table of behaviours

AIBehaviour = {

	AVAILABLE = {
	

		MountedGuy		= "Scripts/AI/Behaviors/Personalities/SHARED/Combat/MountedGuy.lua",

		-- JOBS
		----------------------------------------------------------	
		--patrols
		Job_PatrolPath		= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_PatrolPath.lua",
		Job_PatrolPathNoIdle	= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_PatrolPathNoIdle.lua",
		Job_PatrolCircle	= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_PatrolCircle.lua",
		Job_FormPatrolCircle	= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_FormPatrolCircle.lua",
		Job_PatrolLinear	= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_PatrolLinear.lua",
		Job_FormPatrolLinear	= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_FormPatrolLinear.lua",
		Job_PatrolNode		= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_PatrolNode.lua",
		Job_FormPatrolNode	= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_FormPatrolNode.lua",
		Job_CarryBox		= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_CarryBox.lua",
		Job_PracticeFire	= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_PracticeFire.lua",
		Job_Investigate		= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_Investigate.lua",
		Job_RunTo		= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_RunTo.lua",
		Job_RunToActivated	= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_RunToActivated.lua",
		
		-- standing
		Job_Observe		= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_Observe.lua",
		Job_StandIdle		= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_StandIdle.lua",	
		Job_ProneIdle		= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_ProneIdle.lua",	

		SpecialGuy		= "Scripts/AI/Behaviors/Personalities/SPECIAL/SpecialGuy.lua",	
		Job_CroweOne    	= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/Job_CroweOne.lua",
		
		
		
		MutantJob_Idling	= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/MutantJob_Idling.lua",
		MutantJob_Jumper	= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/MutantJob_Jumper.lua",
		MutantCaged		= "Scripts/AI/Behaviors/Personalities/SHARED/Combat/MutantCaged.lua",
		MorpherJob_Morph	= "Scripts/AI/Behaviors/Personalities/SHARED/Jobs/MorpherJob_Morph.lua",

		----------------------------------------------------------	
		-- TEST SCRIPT
		----------------------------------------------------------	
		mutant_dummy		= "Scripts/AI/Behaviors/mutant_dummy.lua",	

		
	},
	
	INTERNAL = {

		Idle_Talk		= "Scripts/AI/Behaviors/Personalities/SHARED/Idles/Idle_Talk.lua",

			
		------------------------------------------------------------
		-- SCOUT
		------------------------------------------------------------	
		ScoutIdle		= "Scripts/AI/Behaviors/Personalities/Scout/ScoutIdle.lua",
		ScoutAlert		= "Scripts/AI/Behaviors/Personalities/Scout/ScoutAlert.lua",
		ScoutAttack		= "Scripts/AI/Behaviors/Personalities/Scout/ScoutAttack.lua",
		ScoutHunt		= "Scripts/AI/Behaviors/Personalities/Scout/ScoutHunt.lua",
		ScoutRedIdle		= "Scripts/AI/Behaviors/Personalities/Scout/ScoutRedIdle.lua",
		ScoutBlackIdle		= "Scripts/AI/Behaviors/Personalities/Scout/ScoutBlackIdle.lua",

		-- COVER
		----------------------------------------------------------
		CoverIdle       	= "Scripts/AI/Behaviors/Personalities/Cover/CoverIdle.lua",
		CoverInterested       	= "Scripts/AI/Behaviors/Personalities/Cover/CoverInterested.lua",
		CoverThreatened       	= "Scripts/AI/Behaviors/Personalities/Cover/CoverThreatened.lua",
		CoverAlert       	= "Scripts/AI/Behaviors/Personalities/Cover/CoverAlert.lua",
		CoverHold       	= "Scripts/AI/Behaviors/Personalities/Cover/CoverHold.lua",
		CoverTEAMHold       	= "Scripts/AI/Behaviors/Personalities/Cover/CoverTEAMHold.lua",
		CoverAttack       	= "Scripts/AI/Behaviors/Personalities/Cover/CoverAttack.lua",
		CoverForm       	= "Scripts/AI/Behaviors/Personalities/Cover/CoverForm.lua",
		CoverWait		= "Scripts/AI/Behaviors/Personalities/Cover/CoverWait.lua",
		CoverRedIdle    	= "Scripts/AI/Behaviors/Personalities/Cover/CoverRedIdle.lua",
		CoverBlackIdle  	= "Scripts/AI/Behaviors/Personalities/Cover/CoverBlackIdle.lua",


		CoverGuardIdle       	= "Scripts/AI/Behaviors/Personalities/Guards/CoverGuardIdle.lua",

		-- REAR
		----------------------------------------------------------
		RearIdle		= "Scripts/AI/Behaviors/Personalities/Rear/RearIdle.lua",				
		RearAlert		= "Scripts/AI/Behaviors/Personalities/Rear/RearAlert.lua",
		RearAttack		= "Scripts/AI/Behaviors/Personalities/Rear/RearAttack.lua",




		----------------------------------------------------------	
		-- VEHICLES
		----------------------------------------------------------			
		-- passenger for vehicles
		InVehicle 			= "SCRIPTS/AI/Behaviors/Personalities/SHARED/Other/InVehicle.lua",
		--	cars
--		CarHumveeIdle			= "Scripts/AI/Behaviors/Vehicles/Car/Car_idle.lua",				
		Car_idle			= "Scripts/AI/Behaviors/Vehicles/Car/Car_idle.lua",		
		Car_transport	= "Scripts/AI/Behaviors/Vehicles/Car/Car_transport.lua",
		Car_goto			= "Scripts/AI/Behaviors/Vehicles/Car/Car_goto.lua",
		Car_path			= "Scripts/AI/Behaviors/Vehicles/Car/Car_path.lua",
		Car_patrol		= "Scripts/AI/Behaviors/Vehicles/Car/Car_patrol.lua",
		Car_chase			= "Scripts/AI/Behaviors/Vehicles/Car/Car_chase.lua",		
		--	boat
--		BoatZodiacIdle			= "Scripts/AI/Behaviors/Vehicles/Boat/Boat_idle.lua",		
--		BoatGunIdle			= "Scripts/AI/Behaviors/Vehicles/Boat/Boat_idle.lua",		
		Boat_idle			= "Scripts/AI/Behaviors/Vehicles/Boat/Boat_idle.lua",
		Boat_path			= "Scripts/AI/Behaviors/Vehicles/Boat/Boat_path.lua",
		Boat_patrol			= "Scripts/AI/Behaviors/Vehicles/Boat/Boat_patrol.lua",		
		Boat_attack		= "Scripts/AI/Behaviors/Vehicles/Boat/Boat_attack.lua",
		Boat_transport		= "Scripts/AI/Behaviors/Vehicles/Boat/Boat_transport.lua",		
		--	helicopters
--		HeliV22Idle			= "Scripts/AI/Behaviors/Vehicles/Helicopter/Heli_idle.lua",		
--		HeliAssaultIdle			= "Scripts/AI/Behaviors/Vehicles/Helicopter/Heli_idle.lua",		
		Heli_idle			= "Scripts/AI/Behaviors/Vehicles/Helicopter/Heli_idle.lua",		
		Heli_path			= "Scripts/AI/Behaviors/Vehicles/Helicopter/Heli_path.lua",
		Heli_patrol			= "Scripts/AI/Behaviors/Vehicles/Helicopter/Heli_patrol.lua",
		Heli_goto			= "Scripts/AI/Behaviors/Vehicles/Helicopter/Heli_goto.lua",
		Heli_transport 		= "Scripts/AI/Behaviors/Vehicles/Helicopter/Heli_transport.lua",
		Heli_attack		= "Scripts/AI/Behaviors/Vehicles/Helicopter/Heli_attack.lua",

		-- MUTANTS
		------------------------------------------------------------
		ScrewedIdle		= "Scripts/AI/Behaviors/Personalities/Mutants/Screwed/ScrewedIdle.lua",
		ScrewedAttack		= "Scripts/AI/Behaviors/Personalities/Mutants/Screwed/ScrewedAttack.lua",

		------------------------------------------------------------
		FastIdle		= "Scripts/AI/Behaviors/Personalities/Mutants/Fast/FastIdle.lua",
		FastAttack		= "Scripts/AI/Behaviors/Personalities/Mutants/Fast/FastAttack.lua",
		FastSeek		= "Scripts/AI/Behaviors/Personalities/Mutants/Fast/FastSeek.lua",

		------------------------------------------------------------
		BigIdle			= "Scripts/AI/Behaviors/Personalities/Mutants/Big/BigIdle.lua",
		BigAttack		= "Scripts/AI/Behaviors/Personalities/Mutants/Big/BigAttack.lua",

		------------------------------------------------------------
		StealthIdle		= "Scripts/AI/Behaviors/Personalities/Mutants/Stealth/StealthIdle.lua",
		StealthAttack		= "Scripts/AI/Behaviors/Personalities/Mutants/Stealth/StealthAttack.lua",
		StealthAlert		= "Scripts/AI/Behaviors/Personalities/Mutants/Stealth/StealthAlert.lua",

		------------------------------------------------------------
		ChimpIdle		= "Scripts/AI/Behaviors/Personalities/Mutants/Chimp/ChimpIdle.lua",
		ChimpAttack		= "Scripts/AI/Behaviors/Personalities/Mutants/Chimp/ChimpAttack.lua",
		ChimpSurround		= "Scripts/AI/Behaviors/Personalities/Mutants/Chimp/ChimpSurround.lua",

		------------------------------------------------------------
		BaboonIdle		= "Scripts/AI/Behaviors/Personalities/Mutants/Baboon/BaboonIdle.lua",
		BaboonAttack		= "Scripts/AI/Behaviors/Personalities/Mutants/Baboon/BaboonAttack.lua",


		------------------------------------------------------------
		MorphIdle		= "Scripts/AI/Behaviors/Personalities/Mutants/Morpher/MorphIdle.lua",
		MorphAttack		= "Scripts/AI/Behaviors/Personalities/Mutants/Morpher/MorphAttack.lua",
		MorphAlert		= "Scripts/AI/Behaviors/Personalities/Mutants/Morpher/MorphAlert.lua",
		MorphCloaked		= "Scripts/AI/Behaviors/Personalities/Mutants/Morpher/MorphCloaked.lua",

		------------------------------------------------------------
		ModMorphIdle		= "Scripts/AI/Behaviors/Personalities/Mutants/ModMorpher/ModMorphIdle.lua",
		ModMorphAttack		= "Scripts/AI/Behaviors/Personalities/Mutants/ModMorpher/ModMorphAttack.lua",
		ModMorphAlert		= "Scripts/AI/Behaviors/Personalities/Mutants/ModMorpher/ModMorphAlert.lua",
		ModMorphCloaked		= "Scripts/AI/Behaviors/Personalities/Mutants/ModMorpher/ModMorphCloaked.lua",


		------------------------------------------------------------
		CroweIdle		= "Scripts/AI/Behaviors/Personalities/Special/Crowe/CroweIdle.lua",
		CroweAttack		= "Scripts/AI/Behaviors/Personalities/Special/Crowe/CroweAttack.lua",
		------------------------------------------------------------
		KriegerIdle		= "Scripts/AI/Behaviors/Personalities/Special/Krieger/KriegerIdle.lua",
		KriegerAttack		= "Scripts/AI/Behaviors/Personalities/Special/Krieger/KriegerAttack.lua",



		----------------------------------------------------------	
		-- MERCENARIES
		----------------------------------------------------------
		SwatIdle		= "Scripts/AI/Behaviors/Personalities/Swat/SwatIdle.lua",
		SwatAlert		= "Scripts/AI/Behaviors/Personalities/Swat/SwatAlert.lua",
		SwatThreatened  	= "Scripts/AI/Behaviors/Personalities/Swat/SwatThreatened.lua",
		SwatAttack		= "Scripts/AI/Behaviors/Personalities/Swat/SwatAttack.lua",
		SwatHunt		= "Scripts/AI/Behaviors/Personalities/Swat/SwatHunt.lua",
		SwatGroupReady		= "Scripts/AI/Behaviors/Personalities/Swat/SwatGroupReady.lua",
		SwatGroupWait		= "Scripts/AI/Behaviors/Personalities/Swat/SwatGroupWait.lua",
		SwatGroupAdvance	= "Scripts/AI/Behaviors/Personalities/Swat/SwatGroupAdvance.lua",
		----------------------------------------------------------
		ScientistIdle		= "Scripts/AI/Behaviors/Personalities/Scientist/ScientistIdle.lua",
		ScientistAlert		= "Scripts/AI/Behaviors/Personalities/Scientist/ScientistAlert.lua",
		ScientistThreatened  		= "Scripts/AI/Behaviors/Personalities/Scientist/ScientistThreatened.lua",
		ScientistAttack		= "Scripts/AI/Behaviors/Personalities/Scientist/ScientistAttack.lua",
		----------------------------------------------------------							
		SniperIdle		= "Scripts/AI/Behaviors/Personalities/Sniper/SniperIdle.lua",								
		----------------------------------------------------------							
		TLDefenseIdle		= "Scripts/AI/Behaviors/Personalities/TeamLeaders/TLDefenseIdle.lua",							
		TLAttack2Idle   	= "Scripts/AI/Behaviors/Personalities/TeamLeaders/TLAttack2Idle.lua",
		TLAttack2Attack 	= "Scripts/AI/Behaviors/Personalities/TeamLeaders/TLAttack2Attack.lua",
		----------------------------------------------------------
		TLFakeAttack	 	= "Scripts/AI/Behaviors/Personalities/TeamLeaders/TLFakeAttack.lua",


		----------------------------------------------------------	
		-- ANIMALS
		----------------------------------------------------------
		Pig			= "Scripts/AI/Behaviors/Personalities/Animals/Pig.lua",


		----------------------------------------------------------	
		-- SHARED COMBAT
		------------------------------------------------------------	
		RunToAlarm		= "Scripts/AI/Behaviors/Personalities/SHARED/Combat/RunToAlarm.lua",
		RunToFriend		= "Scripts/AI/Behaviors/Personalities/SHARED/Combat/RunToFriend.lua",
		UnderFire		= "Scripts/AI/Behaviors/Personalities/Shared/Combat/UnderFire.lua",
		MountedGuy		= "Scripts/AI/Behaviors/Personalities/SHARED/Combat/MountedGuy.lua",
--		UseElevator		= "Scripts/AI/Behaviors/Personalities/SHARED/Combat/UseElevator.lua",
--		UseFlyingFox		= "Scripts/AI/Behaviors/Personalities/SHARED/Combat/UseFlyingFox.lua",
		DigIn			= "Scripts/AI/Behaviors/Personalities/SHARED/Combat/DigIn.lua",
		LeanFire		= "Scripts/AI/Behaviors/Personalities/SHARED/Combat/LeanFire.lua",
		SharedReinforce		= "Scripts/AI/Behaviors/Personalities/SHARED/Combat/SharedReinforce.lua",
		SharedRetreat		= "Scripts/AI/Behaviors/Personalities/SHARED/Combat/SharedRetreat.lua",
		HoldPosition		= "Scripts/AI/Behaviors/Personalities/SHARED/Combat/HoldPosition.lua",

		MutantJumping		= "Scripts/AI/Behaviors/Personalities/SHARED/Combat/MutantJumping.lua",

		SpecialLead		= "Scripts/AI/Behaviors/Personalities/SHARED/Other/SpecialLead.lua",
		SpecialFollow		= "Scripts/AI/Behaviors/Personalities/SHARED/Other/SpecialFollow.lua",
		SpecialDumb		= "Scripts/AI/Behaviors/Personalities/SHARED/Other/SpecialDumb.lua",
		SpecialHold		= "Scripts/AI/Behaviors/Personalities/SHARED/Other/SpecialHold.lua",
		Swim			= "Scripts/AI/Behaviors/Personalities/SHARED/Other/Swim.lua",
		ClimbLadder		= "Scripts/AI/Behaviors/Personalities/SHARED/Other/ClimbLadder.lua",


	},
	
}

System:LogToConsole("LOADED AI BEHAVIOURS");

-- do not delete this line
Script:ReloadScript("Scripts/AI/Behaviors/DEFAULT.lua");
---------------------------------------------------------


-- load all idle scripts
Script:ReloadScript("Scripts/AI/Behaviors/Personalities/SHARED/Idles/AnimIdles.lua");
--------------------------------------------------------



function AIBehaviour:LoadAll()
	
	for name,filename in self.AVAILABLE do	
		System:Log("Preloading behaviour "..name)
		Script:ReloadScript(filename);
	end

	for name,filename in self.INTERNAL do	
		System:Log("Preloading behaviour "..name)
		Script:ReloadScript(filename);
	end

end











