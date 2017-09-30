Script:ReloadScript("Scripts/Default/Entities/Others/BasicEntity.lua")

	-- Исправить: при подборе последенего выброшенного оружия, оно всегда перезаряжается заного(у игрока теряются целые магазины).
	-- То ли последнее оружие не сохраняет инфу о количесве патронов в магазине, то ли при его подборе эта инфа неправильно/не читается(скорее всего).
	-- Все подствольные гранаты, даже находящиеся в запасе, вообще бесследно исчезают.
	-- Подобранные пушки с физикой в редакторе появляются только после перезагрузки скриптов!
function BasicEntity:PhysPickTopPocketAndClips(guy,pick_type,ammo_type,add_amount,max_ammo,pick_id,wpns_count)
		local AddValue = add_amount * 1
		local temp_amount = add_amount * 1
		if (AddValue > 0) then
			local serverSlot = Server:GetServerSlotByEntityId(guy.id)
			if (pick_id==1) then
			-- top up weapon clips:
				local weaponInfo = guy.WeaponState
				weaponInfo = weaponInfo[WeaponClassesEx[pick_type].id]
				if (weaponInfo) then
					local weaponTable = getglobal(weaponInfo.Name)
					local distributed = nil
					-- now we find the fire mode of the weapon,which uses this ammo type
					for i,fireMode in weaponTable.FireParams do
						if (fireMode.AmmoType==ammo_type and fireMode.ai_mode==0 and not distributed) then
							local bpc = fireMode.bullets_per_clip - weaponInfo.AmmoInClip[i]
							local to_add = min(bpc,AddValue)
							AddValue = AddValue - to_add
							weaponInfo.AmmoInClip[i] = weaponInfo.AmmoInClip[i] + to_add
							distributed = 1
							temp_amount = AddValue * 1
							if (AddValue <= 0) and (serverSlot) then
								serverSlot:SendCommand("HUD A "..ammo_type.." "..to_add)
								return temp_amount
							end
						end
					end
				end
			end -- pickid

			local c_ammo = guy:GetAmmoAmount(ammo_type)
			if (c_ammo >= max_ammo) or (AddValue <= 0) then return temp_amount  end

			if (c_ammo + AddValue > max_ammo) then
				AddValue = AddValue - ((c_ammo + AddValue) - max_ammo)
			end
			guy:AddAmmo(ammo_type,AddValue)
			temp_amount = temp_amount - AddValue
			if (serverSlot) then
				serverSlot:SendCommand("HUD A "..ammo_type.." "..AddValue)
			end
		end
		return temp_amount
end

function BasicEntity:PhysPickTouched(player) -- Противоположность: BasicWeapon.Server:Drop(Params)
	if player.pp_lastdrop_p then return end
	if self.pp_lastdrop and self.pp_lastdrop > _time then return end
	local pick_id = 0
	local serverSlot = {}
	local pick_type = strfind(self.Properties.Animation.Animation,"weapon_") -- Так, если в переменной есть этот текст...
	if pick_type then
		-- Hud:AddMessage(player:GetName()..": pick_type 0: "..pick_type) -- Вернуло еденицу, наверно одно совпадение.
		pick_type = strsub(self.Properties.Animation.Animation,pick_type+7) -- К этой еденице ещё семь символов?
		-- Hud:AddMessage(player:GetName()..": pick_type 1:  "..pick_type) -- А вот уже и нормальное название.
		local pick_type2 -- Это будет номер ячейки в таблице.
		for i,val in GrenadesClasses do
			if val==pick_type then pick_type2=i break end
		end
		if (WeaponClassesEx[pick_type]) then
			local has_this_gun
			local has_hands
			local wpns_count=0
			local wsl = player.cnt:GetWeaponsSlots()
			if (not wsl) then return end
			for i,val in wsl do
				if (val~=0) then
					wpns_count=wpns_count+1
					if (val.name==pick_type) then has_this_gun=val break end
					if (val.name=="Hands") then
						has_hands = 1
						wpns_count=wpns_count-1
					-- elseif (val.name=="EngineerTool") then
						-- has_hands = 2
						-- wpns_count=wpns_count-1
					end
				end
			end
			local SaveWeaponName
			if player.cnt.weapon then
				SaveWeaponName = player.cnt.weapon.name
			end
			-- take weapon first
			if wpns_count < 4 and not has_this_gun then
				-- -- get rid of hands/engineer tool
				-- -- if (has_hands) then
					-- -- if (wpns_count==3) then
						-- -- if (player.cnt.weapon) and (player.cnt.weapon.name=="Hands") then
							-- -- player.cnt:SetCurrWeapon()
							-- -- --player.do_pp_choose = 1
						-- -- elseif (player.cnt.weapon) and (player.cnt.weapon.name=="EngineerTool") then
							-- -- player.cnt:SetCurrWeapon()
							-- -- --player.do_pp_choose = 1
						-- -- end
						-- -- player.cnt:MakeWeaponAvailable(9,0)
						-- -- player.cnt:MakeWeaponAvailable(27,0)
					-- -- elseif (wpns_count<3) and (player.cnt.weapon) and (player.cnt.weapon.name=="Hands") then
						-- -- player.cnt:SetCurrWeapon()
					-- -- end
				-- -- end
				if not player.ai and has_hands then
					player.cnt:MakeWeaponAvailable(9,0)
				end
				local WeaponId = WeaponClassesEx[pick_type].id
				player.cnt:MakeWeaponAvailable(WeaponId)
				if not player.GunTableOfRandomTrace then player.GunTableOfRandomTrace = {} end
				if not player.GunTableOfRandomTrace[WeaponId] then player.GunTableOfRandomTrace[WeaponId] = {} end
				if not player.GunTableOfRandomTrace[WeaponId].Color then player.GunTableOfRandomTrace[WeaponId].Color = {} end
				if self.RandomColor then
					player.GunTableOfRandomTrace[WeaponId].Color = self.RandomColor
				else
					player.GunTableOfRandomTrace[WeaponId].Color = nil
				end
				if not player.ai then
					if wpns_count==0 or SaveWeaponName=="Hands" then
						player.cnt:SetCurrWeapon(WeaponId)
					end
				else
					-- BasicPlayer.AddItemInWeaponPack(player,"Weapon",WeaponClassesEx[pick_type].name) -- Добавить оружие в пак оружия, чтобы ИИ мог его использовать. Не катит, оружие в текущих слотах не появляется. Смог расширить количество слотов. А с паками можно что-нибудь придумать.
					player.cnt:SetCurrWeapon(WeaponId)
					AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",player.id)
				end
				self:SetPos({x=.01,y=.01,z=.01})
				AI:RegisterWithAI(self.id,0)
				self.Properties.Animation.AvailableWeapon = nil
				BroadcastEvent(self,"Remove")
				pick_id = 1
				serverSlot = Server:GetServerSlotByEntityId(player.id)
				if (serverSlot) then
					serverSlot:SendCommand("HUD W "..WeaponId)
				end
				AI:SoundEvent(player.id,self:GetPos(),3,.5,.5,player.id)
			end
			-- add weapon clips content,take needed amount from clips to pockets
			local ammo_type = 0
			local max_ammo = 0
			local sum_ammo = self.Properties.Animation.fAmmo_Primary + self.Properties.Animation.fAmmo_Secondary
			-- 1. primary ammo
			ammo_type = self.Properties.Animation.sAmmotype_Primary
			max_ammo = MaxAmmo[ammo_type]
			if (max_ammo) then
				self.Properties.Animation.fAmmo_Primary = self:PhysPickTopPocketAndClips(player,pick_type,ammo_type,self.Properties.Animation.fAmmo_Primary,max_ammo,pick_id,wpns_count)
			end
			-- 2. secondary ammo
			ammo_type = self.Properties.Animation.sAmmotype_Secondary
			max_ammo = MaxAmmo[ammo_type]
			if (max_ammo) then
				self.Properties.Animation.fAmmo_Secondary = self:PhysPickTopPocketAndClips(player,pick_type,ammo_type,self.Properties.Animation.fAmmo_Secondary,max_ammo,pick_id,wpns_count)
			end
			-- check if something is picked from this item:
			if (self.Properties.Animation.fAmmo_Primary + self.Properties.Animation.fAmmo_Secondary~=sum_ammo) and (pick_id~=1) then
				pick_id = 2
				if player.ai then
					AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",player.id)
				end
			end
			-- play pickup sound
			if pick_id>0 and self.pp_sound then
				-- if (pick_id >= 0) and (self.pp_sound) then
				local ppsound = Sound:Load3DSound(self.pp_sound)
				if ppsound then
					-- if (pick_id==1) and (player.cnt.weapon==nil) then
					-- else
						Sound:SetSoundVolume(ppsound,239)
						local pppos = player:GetPos()
						pppos.z = pppos.z + .6
						Sound:SetSoundPosition(ppsound,pppos)
						Sound:PlaySound(ppsound,1)
					-- end
				end
			end
			-- remove weapon pickup if picked
			if pick_id==1 then
				if not player.cnt.weapon then
					-- player.cnt:SelectNextWeapon()
					-- -- player.cnt:DeselectWeapon()
					-- Hud:AddMessage(player:GetName()..": SetCurrWeapon: "..pick_type.."("..WeaponClassesEx[pick_type].id..")")
					-- System:Log(player:GetName()..": SetCurrWeapon: "..pick_type.."("..WeaponClassesEx[pick_type].id..")")
					player.cnt:SetCurrWeapon(WeaponClassesEx[pick_type].id)
					if player==_localplayer then
						BasicWeapon:Show(player) -- Чтобы вновь подобранное оруже отобразилось.
					end
				end
				Server:RemoveEntity(self.id)
			end
		elseif GrenadesClasses[pick_type2] then -- __PickAmmo(self,collider,entering,ammo_type,amount)
			if not self.Properties.Animation.fAmmo_Primary or self.Properties.Animation.fAmmo_Primary==0 then return end
			local ammo_type = self.Properties.Animation.sAmmotype_Primary
			-- if not ammo_type or ammo_type=="Unlimited" then return nil end
			local max_ammo = MaxAmmo[ammo_type]
			local to_add = self.Properties.Animation.fAmmo_Primary
			local curr_amount = player:GetAmmoAmount(ammo_type)
			local serverSlot = Server:GetServerSlotByEntityId(player.id)
			if not max_ammo or curr_amount>=max_ammo then
				if not self.LastTime or _time>self.LastTime+6 then
					if serverSlot then
						serverSlot:SendCommand("HUD A "..ammo_type.." -1")
					end
					self.LastTime=_time
				end
				return nil
			end
			if curr_amount+to_add>max_ammo then
				to_add=max_ammo-curr_amount
			end
			if to_add<=0 then return end
			-- System:Log("toadd "..tostring(to_add))
			player:AddAmmo(ammo_type,to_add)
			-- send ammo catch
			if serverSlot then
				serverSlot:SendCommand("HUD A "..ammo_type.." "..to_add)
			end
			if player.ai then
				AI:Signal(0,1,"EXIT_SEARCH_AMMUNITION",player.id)
			end
			-- play pickup sound
			if self.pp_sound then
				-- if (pick_id >= 0) and (self.pp_sound) then
				local ppsound = Sound:Load3DSound(self.pp_sound)
				if ppsound then
					-- if (pick_id==1) and (player.cnt.weapon==nil) then
					-- else
						Sound:SetSoundVolume(ppsound,239)
						local pppos = player:GetPos()
						pppos.z = pppos.z + .6
						Sound:SetSoundPosition(ppsound,pppos)
						Sound:PlaySound(ppsound,1)
					-- end
				end
			end
			-- return (amount-to_add)
			self.Properties.Animation.fAmmo_Primary = self.Properties.Animation.fAmmo_Primary-to_add
			if self.Properties.Animation.fAmmo_Primary==0 then
				Server:RemoveEntity(self.id)
			end
		else
			Hud:AddMessage("WEAPON: "..pick_type.." IS NOT PRESENT IN WEAPONS CLASSES!")
		end
	end

	-- Далее код будет новее.
	-- if (not guy.ai) and (not guy.theVehicle) then
		-- if (guy.pp_lastdrop_p) then return end
		-- if (self.pp_lastdrop) and (self.pp_lastdrop > _time) then return end
		-- if (self.is_health) then
			-- if (guy.cnt.health < guy.cnt.max_health) and (self.Properties.Animation.fAmount > 0) then
				-- local actual_heal = floor((guy.cnt.max_health/100) * self.Properties.Animation.fAmount)
				-- if (guy.cnt.health + actual_heal > guy.cnt.max_health) then
					-- actual_heal = guy.cnt.max_health - guy.cnt.health
				-- end
				-- guy.cnt.health = guy.cnt.health + actual_heal
				-- actual_heal = floor(actual_heal/guy.cnt.max_health * 100)
				-- self:SetPos({x=.01,y=.01,z=.01})
				-- BroadcastEvent(self, "Remove")
				-- local bandages = 0
				-- if (Mission and Mission.alienworld) or (guy.items and guy.items.aliensuit) then
				-- elseif (toNumberOrZero(getglobal("gr_bleeding"))~=0) and (guy.Ammo["Bandage"]) then
					-- if (guy.items) and (guy.items.bleed_range) then
						-- bandages = 1
					-- else
						-- bandages = 2
					-- end
					-- local bamount = MaxAmmo["Bandage"] - guy:GetAmmoAmount("Bandage")
					-- if (bamount < bandages) then
						-- bandages = bamount
					-- end
					-- if (bandages > 0) then
						-- guy:AddAmmo("Bandage", bandages)
					-- end
				-- end
				-- if (guy.items) then
					-- guy.items.bleed_range = nil
				-- end
				-- local serverSlot = Server:GetServerSlotByEntityId(guy.id)
				-- if (serverSlot) then
					-- if (bandages > 0) then
						-- serverSlot:SendCommand("HUD P 2 "..self.Properties.Animation.fAmount.." "..bandages)
					-- else
						-- serverSlot:SendCommand("HUD P 2 "..self.Properties.Animation.fAmount)
					-- end
				-- end
				-- self.Properties.Animation.fAmount = 0
				-- -- play pickup sound
				-- if (self.pp_sound) then
					-- local ppsound = Sound:Load3DSound(self.pp_sound)
					-- if (ppsound) then
						-- Sound:SetSoundVolume(ppsound,242)
						-- local pppos = guy:GetPos()
						-- pppos.z = pppos.z + .8
						-- Sound:SetSoundPosition(ppsound,pppos)
						-- Sound:PlaySound(ppsound,1)
					-- end
				-- end
				-- Server:RemoveEntity(self.id,1)
				-- self = nil
			-- end
			-- return
		-- end
		-- local pick_id = 0
		-- local serverSlot = {}
		-- local pick_type = strfind(self.Properties.Animation.Animation,"weapon_")
		-- if (pick_type) then
			-- pick_type = strsub(self.Properties.Animation.Animation,pick_type+7)
			-- if (WeaponClassesEx[pick_type]) then
				-- local has_this_gun
				-- local has_hands
				-- local wpns_count=0
				-- local wsl = guy.cnt:GetWeaponsSlots()
				-- if (not wsl) then return end
				-- for i,val in wsl do
					-- if (val~=0) then
					-- wpns_count=wpns_count+1
						-- if (val.name==pick_type) then has_this_gun=val  break  end
						-- if (val.name=="Hands") then has_hands = 1  wpns_count=wpns_count-1
						-- elseif (val.name=="EngineerTool") then has_hands = 2  wpns_count=wpns_count-1  end
					-- end
				-- end

				-- -- take weapon first
				-- if (wpns_count < 4) and (has_this_gun==nil) then

					-- -- get rid of hands/engineer tool
					-- if (has_hands) then
						-- if (wpns_count==3) then
							-- if (guy.cnt.weapon) and (guy.cnt.weapon.name=="Hands") then
								-- guy.cnt:SetCurrWeapon()
								-- --guy.do_pp_choose = 1
							-- elseif (guy.cnt.weapon) and (guy.cnt.weapon.name=="EngineerTool") then
								-- guy.cnt:SetCurrWeapon()
								-- --guy.do_pp_choose = 1
							-- end
							-- guy.cnt:MakeWeaponAvailable(9,0)
							-- guy.cnt:MakeWeaponAvailable(27,0)
						-- elseif (wpns_count<3) and (guy.cnt.weapon) and (guy.cnt.weapon.name=="Hands") then
								-- guy.cnt:SetCurrWeapon()
						-- end
					-- end

					-- guy.cnt:MakeWeaponAvailable(WeaponClassesEx[pick_type].id)
					-- self:SetPos({x=.01,y=.01,z=.01})
					-- BroadcastEvent(self, "Remove")
					-- pick_id = 1
					-- serverSlot = Server:GetServerSlotByEntityId(guy.id)
					-- if (serverSlot) then
						-- serverSlot:SendCommand("HUD W "..WeaponClassesEx[pick_type].id)
					-- end

				-- end

				-- -- add weapon clips content, take needed amount from clips to pockets
				-- local ammo_type = 0
				-- local max_ammo = 0
				-- local sum_ammo = self.Properties.Animation.fAmmo_Primary + self.Properties.Animation.fAmmo_Secondary

				-- -- 1. primary ammo
				-- ammo_type = self.Properties.Animation.sAmmotype_Primary
				-- max_ammo = MaxAmmo[ammo_type]
				-- if (max_ammo) then
					-- self.Properties.Animation.fAmmo_Primary = self:PhysPickTopPocketAndClips(guy, pick_type, ammo_type, self.Properties.Animation.fAmmo_Primary, max_ammo, pick_id, wpns_count)
				-- end

				-- -- 2. secondary ammo
				-- ammo_type = self.Properties.Animation.sAmmotype_Secondary
				-- max_ammo = MaxAmmo[ammo_type]
				-- if (max_ammo) then
					-- self.Properties.Animation.fAmmo_Secondary = self:PhysPickTopPocketAndClips(guy, pick_type, ammo_type, self.Properties.Animation.fAmmo_Secondary, max_ammo, pick_id, wpns_count)
				-- end

				-- -- check if something is picked from this item:
				-- if (self.Properties.Animation.fAmmo_Primary + self.Properties.Animation.fAmmo_Secondary~=sum_ammo) and (pick_id~=1) then
					-- pick_id = 2
				-- end

				-- -- play pickup sound
				-- if (pick_id > 0) and (self.pp_sound) then
					-- local ppsound = Sound:Load3DSound(self.pp_sound)
					-- if (ppsound) then
						-- if (pick_id==1) and (guy.cnt.weapon==nil) then
						-- else
							-- Sound:SetSoundVolume(ppsound,239)
							-- local pppos = guy:GetPos()
							-- pppos.z = pppos.z + .6
							-- Sound:SetSoundPosition(ppsound,pppos)
							-- Sound:PlaySound(ppsound,1)
						-- end
					-- end
				-- end

				-- -- remove weapon pickup if picked
				-- if (pick_id==1) then
					-- if (guy.cnt.weapon==nil) then
						-- guy.cnt:SetCurrWeapon(WeaponClassesEx[pick_type].id)
					-- end
					-- Server:RemoveEntity(self.id)
				-- end

			-- else
				-- Hud:AddMessage("WEAPON: "..pick_type.." IS NOT PRESENT IN WEAPONS CLASSES!")
			-- end
		-- end
	-- end
end