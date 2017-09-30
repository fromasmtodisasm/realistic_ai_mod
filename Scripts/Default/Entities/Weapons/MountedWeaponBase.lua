MountedWeapon=
{
	weaponid=0,
--	name = "Mounted",
	fireOn = 0,
	Properties = {
--		fileGunCGF = "Objects/Weapons/ntw20/ntw20_bind.cgf",
--		fileGunModel = "Objects/Weapons/ntw20/ntw20.cga",
		angHLimit = 0, --
		angVLimitMin = -45,	-- up direction default  -50 -- -20
		angVLimitMax = 45,	-- down direction default 20 -- 10

		mountHeight = 1.1,
		mountRadius = .8,
		mountHandle = .6,

		bUserPhys = 0,
		bHidden = 0,
	},

	theUser = nil,
	direction = {x=0,y=0,z=0},
	clientPhysics = 0,

	-- if the weapon supports zooming then enter this...
	ZoomActive = 0,												-- initially always 0
	MaxZoomSteps = 4,
	ZoomSteps = {2,3,4,8,},

	---------------------------------------------------
	timeout = 2,
	lastusetime = 0,
}

-------------
function MountedWeapon:OnPropertyChange()
	if (self.Properties.bHidden~=0) then
		self:GotoState("Hidden")
	else
		self:GotoState("Idle")
	end
end

-------------
function MountedWeapon:OnReset()
	--System:Log("\005 ** NOW ON RESET MOUNTED WEAPON **")
	-- if (self.user) then
		--System:Log("User Bounded !!!!!!!")
	-- end
	self.direction = new(self:GetAngles())
	self.par = 0
	self.StartAnimationTime = nil
	self.StopAnimationTime = nil
	self.AlreadySpinning = nil
	self:AbortUse()
	self:ResetAnimation(0)

	if (self.Properties.bHidden~=0) then
		self:GotoState("Hidden")
	else
		self.engaged = 0
		self:GotoState("Idle")
	end

	AI:RegisterWithAI(self.id,AIOBJECT_MOUNTEDWEAPON)
end

-------------
function MountedWeapon:OnShutDown()
	--System:Log("\005 MountedWeapon:OnShutDown()")
	-- if self.isBound then
	if self.isBound and self.isBound.ReleaseMountedWeapon then
		-- Hud:AddMessage(self:GetName()..": MountedWeapon/OnShutDown/ReleaseMountedWeapon")
		System:Log(self:GetName()..": MountedWeapon/OnShutDown/ReleaseMountedWeapon")
		self.isBound:ReleaseMountedWeapon(1)
	end
	self:AbortUse()
end


-------------
function MountedWeapon:Physicalize()
	if (not self.IsPhisicalized) then
		--System:Log("\005 MountedWeapon:Physicalize()")
--		self:LoadObject(self.Properties.fileGunCGF,0,1)
--		self:LoadCharacter(self.Properties.fileGunCGF,0)
		self:LoadCharacter(self.fileGunModel,0)
		self:ResetAnimation(0)
--		self:StartAnimation(0,"idle11")
--		self:CreateStaticEntity(100,0)

--		System:Log("##############################################################################################")
--		System:Log("##############################################################################################")
--		System:Log("##############################################################################################")
		self.IsPhisicalized = 1
		self:EnablePhysics(0)

		if (self.Properties.bHidden~=0) then
			self:DrawCharacter(0,0) -- Hide Character.
		else
			self:DrawCharacter(0,1) -- Show Character.
		end
	end
end
-------------
function MountedWeapon:RegisterStates()
	self:RegisterState("Idle")
	self:RegisterState("Used")
	self:RegisterState("Hidden")
	self.fireOn = 0
end
-------------
function MountedWeapon:Client_OnInit()

	self:NetPresent(0)
--	System:Log("MountedWeapon:Client_OnInit()")
	Game:AddWeapon(self.weapon)

	self.initialAngle = new(self:GetAngles(1))

	self:RegisterStates()
	self:Physicalize()
	self:DrawObject(0,1)
	self:RenderShadow(1)
--	self:EnablePhysics(1)
	self:SetTimer(500)
--	AI:RegisterWithAI(self.id,AIOBJECT_MOUNTEDWEAPON)
end
-------------
function MountedWeapon:Server_OnInit()

	self:NetPresent(0)
	if (self.Properties.gunCGF) then
		self.Properties.fileGunCGF=self.Properties.gunCGF
		self.Properties.gunCGF=nil
	end

	self.initialAngle = new(self:GetAngles(1))

	self:OnReset()

--	self:RegisterWithAI(AIOBJECT_MOUNTEDWEAPON)
--	System:Log("MountedWeapon:Server_OnInit()")
	for i,val in WeaponClassesEx do
		if (i==self.weapon) then
--			System:Log("weapon="..i)
			self.weaponid=val.id
			break
		end
	end
	self:RegisterStates()
	self:Physicalize()

	if (self.Properties.bHidden~=0) then
		self:GotoState("Hidden")
	else
		self:GotoState("Idle")
	end
end
-------------
function MountedWeapon:Client_Idle_OnContact(collider)

	if (self.isBound) then return end		-- it's mounted on vehicle - gunner entered by vehicle
	if (self.user) then return end
	if (collider==_localplayer) then

		-- see if close to handle
		if (self:IsClose(collider:GetPos())==0) then return end
		Hud.label = self.message --"Press USE KEY to use this weapon..."
	end
end
-------------
function MountedWeapon:OnBind(player,par)

--local	vPos = new(self:GetPos())

	self.lastselected = player.cnt:GetCurrWeaponId()

  	player.current_mounted_weapon = self
	player.cnt.lock_weapon=1

--	System:Log("player.cnt:MakeWeaponAvailable("..self.weaponid..",1)")
	player.cnt:MakeWeaponAvailable(self.weaponid,1)
--	System:Log("player.cnt:SetCurrWeapon("..self.weaponid..")")
	player.cnt:SetCurrWeapon(self.weaponid,self.id)
	--

--	player:SetAngles(g_Vectors.v000)

--	System:Log("MountedWeapon:OnBind("..player:GetName()..")")
	self.user=player
	player.cnt:SetAngleLimitBase(self.initialAngle)
	if (self.Properties.angHLimit > 0) then
		player.cnt:SetMinAngleLimitH(-self.Properties.angHLimit)
		player.cnt:SetMaxAngleLimitH(self.Properties.angHLimit)
		player.cnt:EnableAngleLimitH(1)
	else
		player.cnt:EnableAngleLimitH(0)
	end
	player.cnt:SetMinAngleLimitV(self.Properties.angVLimitMin)
	player.cnt:SetMaxAngleLimitV(self.Properties.angVLimitMax)
--	self:DrawObject(0,0)

	player.cnt:RedirectInputTo(self.id)
--	player.cnt:UsingMountedWeapon(self:GetPos())

	if (self.isBound==nil) then
		player:StartAnimation(0,"sidle")
	end
	player.cnt.AnimationSystemEnabled = 0
	----------------------

	--local dir=new(self:GetDirectionVector())
	--local pos=new(self:GetPos())
	--ScaleVectorInPlace(dir,.7)
	--FastSumVectors(pos,pos,dir)
	--FastDifferenceVectors(pos,self:GetPos(),pos)
	--pos.z=-1
--	player:SetPos({x=0,y=.7,z=-1})
	--player.cnt:SetPivot(self:GetPos())
	if (self.Properties.bUserPhys==0) then
		player:ActivatePhysics(0)
	end
	self.user=player

--	self:ActivatePhysics(0)	-- not to hit it with bullets
	self:EnablePhysics(0)
	self:NetPresent(1)
	self:GotoState("Used")
	self:UpdateUser(0)
	if (player==_localplayer) then
		self:Event_PlayerIn()
	end
end

-------------
function MountedWeapon:ReleaseUser()
	self.par=0
--  System:Log("MountedWeapon:StopUsing")

	-- fixme -
	-- not good,should never happen
	if (self.user and self.user.GetPos==nil) then
		--System:Log("\001 MountedWeapon:AbortUse  >>>>   mounted weapon user is carrupted ")
		return
	end

	if (not self.user) then return end

	self.user.cnt:EnableAngleLimitH(nil)
	self.user.cnt:SetMinAngleLimitV(self.user.normMinAngle)
	self.user.cnt:SetMaxAngleLimitV(self.user.normMaxAngle)

	self.user.cnt:RedirectInputTo(0)

	-- stop fireing animation
	self.user.cnt.lock_weapon=nil
	self.user.current_mounted_weapon = nil

	self.user:ActivatePhysics(1)
	self.user.cnt.AnimationSystemEnabled = 1
	self.user:SetAngles(self:GetAngles(1))

	self.user.cnt:ResetRotateHead()
--	user:SetAngles({x=0,y=0,z=100})

	-- make sure that the player is still alive
	if (self.user.cnt.health > 0) then
		if (self.lastselected) then
			self.user.cnt:SetCurrWeapon(self.lastselected)	-- select prev weapon
			self.user.lastselected=nil
		else
			self.user.cnt:SetCurrWeapon()	-- just deselect mounted weapon
		end
		self.user.cnt:MakeWeaponAvailable(self.weaponid,0)
	end


	if (self.user==_localplayer) then
		self:Event_PlayerOut()
	end

	--set last safe angles
	local ang=self:GetAngles(1)
	ang.z = self.user.cnt.SafeMntAngZ
	self:SetAngles(ang)
	self.user.ThisIsMortar=nil
	self.user.OnPressFire=nil
	self.timeout = 2
	self.user.HelicopterIs = nil
	self.user = nil
	self.engaged = 0
end

-------------
function MountedWeapon:Server_Idle_OnContact(collider)

--System:Log(" MountedWeapon:Server_Idle_OnContact ")

	if (self.isBound) then return end		-- it's mounted on vehicle - gunner entered by vehicle

	if (self.user) then return end

	if (collider.type~="Player") then return end

	if (collider.cnt.use_pressed and (collider.cnt.health>0)) then

		-- here we check if the positin at mounted weapon is available -
		-- player is not colliding with something when use it
		local dir=self:GetDirectionVector()
		dir.z=0
		NormalizeVector(dir)
		local userPos = self:GetPos()
		userPos.x = userPos.x - dir.x*self.Properties.mountRadius
		userPos.y = userPos.y - dir.y*self.Properties.mountRadius
		userPos.z = userPos.z-self.Properties.mountHeight
		-- if cant stand there - can't use it
		local distAround = .2
		if (not collider.cnt:CanStand(userPos)) then
			userPos.x = userPos.x + distAround
			if (not collider.cnt:CanStand(userPos)) then
				userPos.x = userPos.x - distAround*2
				if (not collider.cnt:CanStand(userPos)) then
					userPos.x = userPos.x + distAround
					userPos.y = userPos.y + distAround
					if (not collider.cnt:CanStand(userPos)) then
						userPos.y = userPos.y - distAround*2
						if (not collider.cnt:CanStand(userPos)) then return end
					end
				end
			end
		end
--		if (not collider.cnt:CanStand(userPos)) then return end

		-- see if close to handle
		if (self:IsClose(collider:GetPos())==0) then return end

		collider.cnt.use_pressed = nil
		self:SetGunner(collider)
	end
end
-------------
function MountedWeapon:SetGunner(player)
	--System:Log("MountedWeapon:SetGunner()")
	-- deactivate binoculars
	if player==_localplayer then
		if ClientStuff.vlayers:IsActive("Binoculars") then
			ClientStuff.vlayers:DeactivateLayer("Binoculars")
		end
	else
		player.AI_AtWeapon = 1
	end
	self:OnBind(player)
	local Weapon = player.cnt.weapon
	for i,CurFireParameters in Weapon.FireParams do -- i - номер режима. Всё, теперь песня в ушах звенит!
		player.weapon_info.SndInstances[i]["FireLoop"] = Sound:Load3DSound("Sounds/Weapons/mounted/fire_mono.mp3",flags,CurFireParameters.SoundMinMaxVol[1],CurFireParameters.SoundMinMaxVol[2],CurFireParameters.SoundMinMaxVol[3]) -- От третьего лица.
		player.weapon_info.SndInstances[i]["FireLoopStereo"] = Sound:LoadSound("Sounds/Weapons/mounted/fire_stereo.mp3") -- От первого лица.
		player.weapon_info.SndInstances[i]["TrailOff"] = Sound:Load3DSound("Sounds/Weapons/mounted/fire_end_mono.mp3",flags,CurFireParameters.SoundMinMaxVol[1],1,20)
		player.weapon_info.SndInstances[i]["TrailOffStereo"] = Sound:LoadSound("Sounds/Weapons/mounted/fire_end_stereo.mp3")
	end
	-- Hud:AddMessage("FireModeParams.FireLoop: "..FireModeParams.FireLoop)
end


-------------
function MountedWeapon:AbortUse()
	if (not self.user) then return end
	self:ReleaseUser()--------------
	self:DrawObject(0,1)
	self:DrawCharacter(0,1)
	self:GotoState("Idle")
	self:NetPresent(0)
end

-------------
function MountedWeapon:UpdateUser(dt)
	if self.user then
		local dir=self:GetDirectionVector()
		local handlerPos = self:GetBonePos("hands")
		if handlerPos and self.user.SetHandsIKTarget then	-- use halper if available -- self.user.SetHandsIKTarget - был nil
			self.user:SetHandsIKTarget(handlerPos)
		else
			handlerPos = self:GetPos()
			handlerPos.x = handlerPos.x - dir.x*self.Properties.mountHandle
			handlerPos.y = handlerPos.y - dir.y*self.Properties.mountHandle
			handlerPos.z = handlerPos.z - dir.z*self.Properties.mountHandle
		end

		-- if not self.isBound then
		if not self.isBound or (self.isBound and self.engaged==1) then -- Убрать второе условие, что в скобках, если получится извлечь координаты из хелпера. Это чтобы хоть как то устанавливалась позиция.
			-- System:Log(self:GetName().." not self.isBound")
			dir.z=0
			NormalizeVector(dir)
			local userPos = self:GetPos()
			userPos.x = userPos.x - dir.x*self.Properties.mountRadius
			userPos.y = userPos.y - dir.y*self.Properties.mountRadius

			userPos.z = userPos.z-self.Properties.mountHeight
		--		userPos.z = userPos.z + 5
			self.user:SetPos(userPos)
		end
		-- if self.isBound and self.engaged==1 then
			-- self.user:SetPos(self.isBound:GetHelperPos(self.isBound.gunnerT.in_helper,1)) -- Находит, но извлекает нулевые координаты.
			-- -- System:Log(self:GetName().." self.isBound: "..self.isBound.gunnerT.in_helper)
		-- end
		-- we don't want to notify physics - not to tilt the cilinder
		self.user:SetAngles(self:GetAngles(1),1)
	end
end
-------------
function MountedWeapon:Client_Used_OnUpdate(dt)
--	if (not self.isBound and self.user==_localplayer) then	-- if not in vehicle and user is localplayer
--		Hud.label = "Press USE KEY to stop using this weapon..."
--	end
	self:UpdateUser(dt)
end
-------------
function MountedWeapon:Server_NotUsed_OnUpdate(dt)
	if self.user and self.user.ThisIsMortar then return end
	-- if self.AlreadySpinning then self.AlreadySpinning = nil end
	if not self.StopAnimationSpeed and not self.StartAnim then return end
	if self.StartAnimationSpeed and self.fireOn==0 then
		self.StopAnimationAdvancedSpeed = self.StartAnimationSpeed
		self.StartAnimationSpeed = nil
	end
	if self.StartAnimationTime then self.StartAnimationTime = nil end
	if not self.StopAnimationTime and (self.fireOn==1 or self.StartAnim) then
		self.StopAnimationTime = _time
		self.StartAnim = nil
		self.fireOn = 0
	end
	if self.StopAnimationTime then
		if self.StopAnimationAdvancedSpeed then
			self.StopAnimationSpeed = _time-self.StopAnimationTime
			self.StopAnimationSpeed = 1-(self.StopAnimationSpeed-self.StopAnimationAdvancedSpeed)
		else
			self.StopAnimationSpeed = (_time-self.StopAnimationTime)
			self.StopAnimationSpeed = 1-self.StopAnimationSpeed
		end
		if self.StopAnimationSpeed > 1 then	self.StopAnimationSpeed = 1	end
		if self.StopAnimationSpeed < 0 then
			self.StopAnimationSpeed = 0
			self.StopAnimationTime = nil
			self.StopAnimationAdvancedSpeed = nil
		end
		self:SetAnimationSpeed(self.StopAnimationSpeed)
		if self.StopAnimationSpeed==0 then
			self.StopAnimationSpeed = nil
		end
	end
end

function MountedWeapon:Server_Used_OnUpdate(dt)
	if not self.user or not self.user.ThisIsMortar then -- not self.user почему-то как-то не был найден.
	-- Всё это дело заставляет пушку прежде чем стрелять раскручиваться.
	-- Итак, после раскрутки ствола пулемёт открывает огонь, после отпускания кнопки огня прекращает стрелять, кручение ствола прекращается.
	-- Старт анимации происходит только один раз, дальше регулируется только скорость анимации. Во время раскрутки или остановки можно нажимать, или отпускать
	-- кнопку огня, то есть просто крутить стволы.
	-- Пока не хватает звука во время кручения стовла, но до открытия огня и нормальной анимации только крутящегося ствола без дёргания туда-сюда, и,
	-- , желательно, более детализованной модели M134.
	if self.par==1 or self.OnPressFire then -- Когда игрок жмёт кнопку огня.
		if not self.StartAnimationTime then self.StartAnimationTime = _time end
		if not self.StartAnim then
			self.StopAnimationTime = nil
			self.StartAnim = 1
			-- self:StartAnimation(0,"default") -- А может скорость возможно указать?
			if not self.AlreadySpinning then -- Старт анимации нужен только один раз, где бы ещё нормальную анимацию достать...
				self:StartAnimation(0,"default",4,1.5,0)
				self.AlreadySpinning = 1
			end
		end
		if self.fireOn==0 then
			if self.StopAnimationSpeed then -- Чем медленее было раскручено, тем дольше стартует.
				self.StartAnimationSpeed = (_time-self.StartAnimationTime)*2
				self.StartAnimationSpeed = (self.StartAnimationSpeed+self.StopAnimationSpeed)
				-- System:Log("AnimationSpeed: "..self.StartAnimationSpeed..", time: ".._time)
			else
				self.StartAnimationSpeed = (_time-self.StartAnimationTime)*2
			end
			if self.StartAnimationSpeed > 1 then self.StartAnimationSpeed = 1 end
			if self.StartAnimationSpeed < 0 then self.StartAnimationSpeed = 0 end
			self:SetAnimationSpeed(self.StartAnimationSpeed)
		end
		if self.StartAnimationSpeed==1 and self.fireOn==0 then
			self.fireOn = 1 -- Разрешить стрелять.
			self.StartAnimationSpeed = nil
		end
	else
		if self.StartAnimationSpeed and self.fireOn==0 then
			self.StopAnimationAdvancedSpeed = self.StartAnimationSpeed
			self.StartAnimationSpeed = nil
		end
		if self.StartAnimationTime then self.StartAnimationTime = nil end
		if not self.StopAnimationTime and (self.fireOn==1 or self.StartAnim) then
			self.StopAnimationTime = _time
			self.StartAnim = nil
			self.fireOn = 0
		end
		if self.StopAnimationTime then
			if self.StopAnimationAdvancedSpeed then -- Чем быстрее раскрутилось, тем дольше тормозит.
				self.StopAnimationSpeed = _time-self.StopAnimationTime
				self.StopAnimationSpeed = 1-(self.StopAnimationSpeed-self.StopAnimationAdvancedSpeed)
				-- System:Log("AnimationSpeed: "..self.StopAnimationSpeed..", time: ".._time)
			else
				self.StopAnimationSpeed = (_time-self.StopAnimationTime)
				self.StopAnimationSpeed = 1-self.StopAnimationSpeed
				-- System:Log("AnimationSpeed: "..self.StopAnimationSpeed..", time: ".._time)
			end
			if self.StopAnimationSpeed > 1 then	self.StopAnimationSpeed = 1	end
			if self.StopAnimationSpeed < 0 then
				self.StopAnimationSpeed = 0
				self.StopAnimationTime = nil
				self.StopAnimationAdvancedSpeed = nil
			end
			self:SetAnimationSpeed(self.StopAnimationSpeed)
			if self.StopAnimationSpeed==0 then
				self.StopAnimationSpeed = nil
			end
		end
	end
	end
	if (self.user) then
		if self.user.cnt.health<=0 or (self.user.cnt and self.user.cnt.use_pressed and self.isBound==nil) then -- self.user.cnt был nil
			if (_time-self.lastusetime<1) then
				do return end
			end
			self.lastusetime=_time
--			System:Log("###############FREEING THE WEAPON")
			self.user.cnt.use_pressed = nil
			self:AbortUse()
		else
			self:UpdateUser(dt)
		end
	end
end

-------------
function MountedWeapon:Client_Used_OnEvent(event,par)
	self.par=par
	if self.user and self.user.ThisIsMortar then -- self.user был nil
		-- -- Hud:AddMessage(self.user:GetName()..": self.user.ThisIsMortar")
		-- if (event==ScriptEvent_Fire) then
			-- if (par==0)	then
	-- --System:Log("FireAnim ################")
				-- self.fireOn = 0
	-- --			self:StartAnimation(0,"")
				-- self:ResetAnimation(0)
			-- else
				-- if (self.fireOn==0) then
	-- --System:Log("FireAnim ................")
	-- --				self:StartAnimation(0,"fire")
					self:StartAnimation(0,"default") -- Всё остальное тысячу лет не нужно для мортиры.
					self.fireOn = 1 -- А это нужно?
				-- end
			-- end
		-- end
	end
end

---------------
--function MountedWeapon:OnUse(collider)
--
--System:Log(">>>>>>>>>>>>>>>>>>>>>>>> <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  FREEING THE WEAPON")
--
--	if (_time-self.lastusetime<2) then
--		--do return end
--		return 0
--	end
--
--	self.lastusetime=_time
--
--	if (self:GetState()=="Idle") then
--		collider.cnt.use_pressed = nil
--		self:SetGunner(collider)
--	else
--		System:Log("###############FREEING THE WEAPON")
--		self.user.cnt.use_pressed = nil
--		self:AbortUse()
--	end
--
--	return 1
--end

-------------
function MountedWeapon:IsClose(pos)

local handlerPos = self:GetBonePos("hands")

	if (handlerPos) then
		FastDifferenceVectors(handlerPos,handlerPos,pos)
		handlerPos.z = 0
		local dist = LengthSqVector(handlerPos)
		if (dist<.8) then return 1 end
		return 0
	else
		return 1
	end
end

-------------
-- Events.
-------------
function MountedWeapon:Event_Activate(sender)
	self:EnableUpdate(1)
	self:GotoState("Idle")
end

function MountedWeapon:Event_Hide(sender)
	self:GotoState("Hidden")
end

function MountedWeapon:Event_Unhide(sender)
	if (self:GetState()=="Hidden") then
		self:GotoState("Idle")
	end
end

----------------------------------------------------
--
function MountedWeapon:Event_PlayerIn(params)

	BroadcastEvent(self,"PlayerIn")

end

----------------------------------------------------
--
function MountedWeapon:Event_PlayerOut(params)

	BroadcastEvent(self,"PlayerOut")

end

-------------
MountedWeapon.Client={
	OnInit=MountedWeapon.Client_OnInit,
	Idle={
		OnBeginState = function(self)
			self:DrawCharacter(0,1) -- Show it
			self.user = nil
			-- self:ResetAnimation(0)
		end,
		OnContact=MountedWeapon.Client_Idle_OnContact,
		OnBind=MountedWeapon.OnBind,
	},
	Used={
		OnBeginState = function(self)
			self:DrawCharacter(0,1) -- Show it
		end,
		OnUpdate=MountedWeapon.Client_Used_OnUpdate,
		OnBind=MountedWeapon.OnBind,
		OnEvent=MountedWeapon.Client_Used_OnEvent,
		OnEndState = function(self)
			self:ReleaseUser()
--			self:DrawObject(0,1)
--			self:DrawCharacter(0,1)
		end,
	},
	Hidden = {
		OnBeginState = function(self)
			self:ReleaseUser()
			--self:DrawObject(0,0) -- Hide object.
			self:DrawCharacter(0,0) -- Hide Character.
			self.engaged = 1
		end,
		OnEndState = function(self)
			self:DrawCharacter(0,1) -- Draw Character.
			self.engaged = 0
		end,
	},
}
-------------
MountedWeapon.Server={
	OnInit=MountedWeapon.Server_OnInit,
	OnShutDown=MountedWeapon.OnShutDown,
	Idle={
		OnBeginState = function(self)
		end,
		OnContact=MountedWeapon.Server_Idle_OnContact,
		OnUpdate=MountedWeapon.Server_NotUsed_OnUpdate,
	},
	Used={
		OnBeginState = function(self)
		end,
		OnUpdate=MountedWeapon.Server_Used_OnUpdate,
	},
	Hidden = {
		OnBeginState = function(self)
			self:ReleaseUser()
			--self:DrawObject(0,0) -- Hide object.
			--self:DrawCharacter(0,0) -- Draw Character.
		end,
		OnUpdate=MountedWeapon.Server_NotUsed_OnUpdate,
	},
}


----------------------------------------------------
--
--
function MountedWeapon:OnSave(stm)
	stm:WriteFloat(self.initialAngle.x)
	stm:WriteFloat(self.initialAngle.y)
	stm:WriteFloat(self.initialAngle.z)
	stm:WriteFloat(self.engaged)
end

----------------------------------------------------
--
--
function MountedWeapon:OnLoad(stm)
	self.initialAngle.x = stm:ReadFloat()
	self.initialAngle.y = stm:ReadFloat()
	self.initialAngle.z = stm:ReadFloat()
	self.engaged = stm:ReadFloat()
end

----------
function CreateMountedWeapon(child)
	--System:Log("\001 CreateMountedWeapon --------------------------------------------------")
	local newt={}
	mergef(newt,MountedWeapon,1)
	mergef(newt,child,1)
	return newt
end


