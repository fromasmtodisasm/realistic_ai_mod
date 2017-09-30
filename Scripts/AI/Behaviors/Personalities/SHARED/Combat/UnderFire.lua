--------------------------------------------------
--    Created By: Petar
--   Description: 	This gets called when the guy knows something has happened (he is getting shot at,does not know by whom),or he is hit. Basically
--  			he doesnt know what to do,so he just kinda sticks to cover and tries to find out who is shooting him
--------------------------
--
AIBehaviour.UnderFire = {
	Name = "UnderFire",
	NOPREVIOUS = 1,

	OnPlayerSeen = function(self,entity,fDistance,NotContact)
		entity:TriggerEvent(AIEVENT_CLEAR)
		AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY_ON_ATTACK(entity)
	end,
	---------------------------------------------
	OnInterestingSoundHeard = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_CLEAR)
	end,
	---------------------------------------------
	OnThreateningSoundHeard = function(self,entity,fDistance)
		entity:TriggerEvent(AIEVENT_CLEAR)
	end,

	OnKnownDamage = function(self,entity,sender)
		-- called when the enemy is damaged
		-- entity:ChangeAIParameter(AIPARAM_COMMRANGE,10)
		AIBehaviour.DEFAULT:HEADS_UP_GUYS_ANY(entity)
		-- entity:ChangeAIParameter(AIPARAM_COMMRANGE,entity.Properties.commrange)
		entity:InsertSubpipe(0,"not_so_random_hide_from",sender.id) -- убрать у других
		entity:InsertSubpipe(0,"scared_shoot",sender.id)
		entity:InsertSubpipe(0,"DropBeaconAt",sender.id)
	end,

	OnBulletRain = function(self,entity,sender)
		-- entity:InsertSubpipe(0,"not_so_random_hide_from")
		entity:InsertSubpipe(0,"randomhide_trace")
	end,

	OnSomethingDiedNearest = function(self,entity,sender)
		if entity.sees~=1 then
			entity:InsertSubpipe(0,"LookAtTheBodyInAction",sender.id)
		end
	end,

	OnSomethingDiedNearest_x = function(self,entity,sender)
	end,

	TRY_TO_LOCATE_SOURCE = function(self,entity,sender) -- Исправить: может начать игнорировать звуки врагов рядом.
		entity:TriggerEvent(AIEVENT_CLEAR)
		entity:SelectPipe(0,"lookaround_30seconds")
	end,
}