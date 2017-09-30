-- All the characters defined

AICharacter = {

	AVAILABLE = {

	
		Krieger		= "Scripts/AI/Characters/Personalities/Krieger.lua",
		Crowe		= "Scripts/AI/Characters/Personalities/Crowe.lua",
		Screwed		= "Scripts/AI/Characters/Personalities/Screwed.lua",
		Fast		= "Scripts/AI/Characters/Personalities/Fast.lua",
		Big		= "Scripts/AI/Characters/Personalities/Big.lua",
		Stealth		= "Scripts/AI/Characters/Personalities/Stealth.lua",
		Morph		= "Scripts/AI/Characters/Personalities/Morph.lua",
		ModMorph	= "Scripts/AI/Characters/Personalities/ModMorph.lua",
		Chimp		= "Scripts/AI/Characters/Personalities/Chimp.lua",
		--Baboon		= "Scripts/AI/Characters/Personalities/Baboon.lua",
		Pig		= "Scripts/AI/Characters/Personalities/Pig.lua",
		Cover		= "Scripts/AI/Characters/Personalities/Cover.lua",
		CoverGuard	= "Scripts/AI/Characters/Personalities/CoverGuard.lua",
		Scout		= "Scripts/AI/Characters/Personalities/Scout.lua",
		Swat		= "Scripts/AI/Characters/Personalities/Swat.lua",
		Rear		= "Scripts/AI/Characters/Personalities/Rear.lua",	
		Sniper  		= "Scripts/AI/Characters/Personalities/Sniper.lua",
		TLAttack2		= "Scripts/AI/Characters/Personalities/TLAttack2.lua",
		TLDefense	= "Scripts/AI/Characters/Personalities/TLDefense.lua",
		Scientist		= "Scripts/AI/Characters/Personalities/Scientist.lua",
		--------------------------------------------------
		TLFakeAttack	= "Scripts/AI/Characters/Personalities/TLFakeAttack.lua",
		--------------------------------------------------

		--------------------------------------------------
		--- here are vehicles
		--------------------------------------------------
		-- helicopters
		HeliCargo	=	"SCRIPTS/AI/Characters/vehicles/HeliCargo.lua",
		HeliAssault	=	"SCRIPTS/AI/Characters/vehicles/HeliAssault.lua",		
		--------------------------------------------------
		-- cars
		FWDVehicle		=	"SCRIPTS/AI/Characters/vehicles/fwdvehicle.lua",
		--------------------------------------------------
		-- boats
		InflatableBoat		=	"SCRIPTS/AI/Characters/vehicles/InflatableBoat.lua",
		BoatGun			=	"SCRIPTS/AI/Characters/vehicles/BoatGun.lua",		
		
		--------------------------------------------------

--		Footballer	= "Scripts/AI/Characters/Personalities/Footballer.lua",

		---PUT TEMP STUFF HERE
		--------------------------------------------------

	
	},
}

System:LogToConsole("LOADED AI CHARACTERS");

Script:ReloadScript("Scripts/AI/Characters/DEFAULT.lua");


function AICharacter:LoadAll()
	
	for name,filename in self.AVAILABLE do	
		System:Log("Preloading character "..name);
		Script:ReloadScript(filename);
	end


end

