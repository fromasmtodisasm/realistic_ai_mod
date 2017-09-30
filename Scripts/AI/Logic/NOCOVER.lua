--------------------------
--    Created By: Petar
--   Description: <short_description>
-- 2003-01-09 amanda simple reduction in probability for roll manoevers
--------------------------
--


NOCOVER = {

	Available_pipes = {
		"comeout_standfire",
		"comeout_crouchfire",
--		"comeout_kneelfire",
--		"comeout_roll",
	},

	count = 2,
	position = 1,
}


function NOCOVER:GetPipe()

	if (NOCOVER.position > NOCOVER.count) then 
		NOCOVER.position = 1;
	end	
	
	NOCOVER.position = NOCOVER.position + 1;

	return NOCOVER.Available_pipes[NOCOVER.position - 1];
	
end

-- this function will select one of a range of close combat attacks and make the enemy execute it
function NOCOVER:SelectAttack( entity )
	
	-- search for a shootspot first within 10 meters AND looking at target
	local shootspot = AI:GetAnchor(entity.id,AIAnchor.AIANCHOR_SHOOTSPOTSTAND,10);
	if (shootspot) then 
		entity:SelectPipe(0,"shoot_from_spot",shootspot);
		entity:InsertSubpipe(0,"setup_combat");
		do return end
	end

	shootspot = AI:GetAnchor(entity.id,AIAnchor.AIANCHOR_SHOOTSPOTCROUCH,10);
	if (shootspot) then 
		entity:SelectPipe(0,"shoot_from_spot",shootspot);
		entity:InsertSubpipe(0,"setup_crouch");
		do return end
	end

	-- comeout normally
	entity:TriggerEvent(AIEVENT_CLEAR);
	
end
