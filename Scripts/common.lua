----------------------------------------------------------------------------------
-- A set of useful vectors, so they don't have to be created on the fly everytime.
-- As references to these are kept please make sure that code using these
-- references does not modify the content.
----------------------------------------------------------------------------------
g_Vectors =
{
	v000={x=0,y=0,z=0},
	v001={x=0,y=0,z=1},
	v010={x=0,y=1,z=0},
	v011={x=0,y=1,z=1},
	v100={x=1,y=0,z=0},
	v101={x=1,y=0,z=1},
	v110={x=1,y=1,z=0},
	v111={x=1,y=1,z=1},

	up = {x=0,y=0,z=1},
	down = {x=0,y=0,z=-1},

	temp={x=0,y=0,z=0},
	tempColor={x=0,y=0,z=0},

	--PointInsideBBox temp vectors
	temp_v1={x=0,y=0,z=0},
	temp_v2={x=0,y=0,z=0},
	temp_v3={x=0,y=0,z=0},
	temp_v4={x=0,y=0,z=0},
}

--------------------------------------------------------------------------------
-- Reads a table from a file, and returns it
--------------------------------------------------------------------------------
-- the file should contain only line of the type:
-- keyname = value
--------------------------------------------------------------------------------
function ReadTableFromFile(szFilename, LineMode)

	local hfile = openfile(szFilename, "r");

	if (hfile == nil) then
		return
	end

	local iEqual;
	local tList = {};
	local szLine = read(hfile, "*l");
	local szProp;
	local szValue;

	while (szLine ~= nil) do
	
		if (strlen(szLine) > 0) then
			if (strsub(szLine, -1) == "\n") then
				szLine = strsub(szLine, 1, strlen(szLine)-1);
			end	
		end
		
		if (strlen(szLine) > 0) then
			if (LineMode) then
				tinsert(tList, szLine);
			else
				if (strlen(szLine) > 0) then
	
					iEqual = strfind(szLine, "=", 1, 1);
	
					if (iEqual) then
						szProp = strsub(szLine, 1, iEqual-1);
						szValue = strsub(szLine, iEqual+1, -1);
	
						tList[szProp] = szValue;
					else
						tList[szLine] = 0;
					end
				end
			end
		end
		
		szLine = read(hfile, "*l");
	end

	closefile(hfile);

	if (LineMode) then
		tList.n = nil;
	end

	return tList;
end

-------------------------------------------------------
-- Convert seconds to mm:ss string
-------------------------------------------------------
function SecondsToString(iSeconds)

	local iMinutes = floor(iSeconds / 60);

	return sprintf("%.2d:%.2d", iMinutes, iSeconds - (iMinutes * 60));
end

-------------------------------------------------------
-- Broadcast Console Print - use only on the server (verbosity 1)
-------------------------------------------------------
function BroadcastConsolePrint(str)
	-- RCP remote console printout
	Server:BroadcastCommand("RCP "..str);
	if not Client then
		System:LogAlways(str);
	end
end


--------------------------------------------------------------------------------
-- Get the Localized version of the string
--------------------------------------------------------------------------------
function Localize(Token)
	if (strsub(Token, 1, 1) ~= "@") then
		if Token then
			return "@"..Token;
		end
		return "nil";
	else
		return Token;
	end
end

-------------------------------------------------------
-- C like printf
-------------------------------------------------------
function printf(...)
  System:LogToConsole(call(format,arg))
end
-------------------------------------------------------
-- C like sprintf
-------------------------------------------------------
function sprintf(...)
  return call(format,arg)
end

-------------------------------------------------------
-- tokenize a string
-- BEWARE: this code doesn't handle special character like @ very well
-- \return a table containing the tokens
-------------------------------------------------------
function tokenize(str)
	local toks={}
	local cmd=gsub(str,"(%S+)",function (s) tinsert(%toks,s) end);
	toks.n=nil;
	return toks;
end


-------------------------------------------------------
--untokenize a string
--returns a string containing the strings (other types are ignored) connected with " "
-------------------------------------------------------
function untokenize(toktable)
	local fullstring="";

	for i,tok in toktable do
		if type(tok)=="string" then
			if fullstring=="" then
				fullstring=tok;
			else
				fullstring=fullstring.." "..tok;
			end
		end
	end

	return fullstring;
end

-------------------------------------------------------
--Clone a table
-------------------------------------------------------
function new(_obj)
	if(type(_obj)=="table") then
		local newInstance={};
		for i,field in _obj do
			if(type(field)=="table") then
				newInstance[i]=new(field);
			else
				newInstance[i]=field;
			end
		end
		return newInstance;
	else
		return _obj;
	end
end

-------------------------------------------------------
--copy table source into the table dest skipping functions
-------------------------------------------------------
function merge(dest,source,recursive)
	for i,v in source do
		if(type(v)~="function") then
			if(recursive) then
				if(type(v)=="table")then
					dest[i]={};
					merge(dest[i],v,recursive);
				else
					dest[i]=v;
				end
			else
				dest[i]=v;
			end
		end
	end
end

-------------------------------------------------------
--copy table source into the table dest with functions
-------------------------------------------------------
function mergef(dest,source,recursive)
	for i,v in source do
		if(recursive) then
			if(type(v)=="table")then
				dest[i]={};
				mergef(dest[i],v,recursive);
			else
				dest[i]=v;
			end
		else
			dest[i]=v;
		end
	end
end

g_dump_tabs=0;
function dump(_class,no_func)
	if not _class then
		System:Log("$2nil");
	else
		local str="";
		for n=0,g_dump_tabs,1 do
			str=str.."  ";
		end
		for i,field in _class do
			if(type(field)=="table") then
				g_dump_tabs=g_dump_tabs+1;
				System:Log(str.."$4"..i.."$1= {");
				dump(field);
				System:Log(str.."$1}");
				g_dump_tabs=g_dump_tabs-1;
			else
				if(type(field)=="number" ) then
					System:Log("$2"..str.."$6"..i.."$1=$8"..field);
				elseif(type(field) == "string") then
					System:Log("$2"..str.."$6"..i.."$1=$8".."\""..field.."\"");
				else
					if(not no_func)then
						if(type(field)=="function")then
							System:Log("$2"..str.."$5"..i.."()");
						else
							System:Log("$2"..str.."$7"..i.."$8<userdata>");
						end
					end
				end
			end
		end
	end
end


-------------------------------------------------------
-- dump all globals variable (that might take a while - the system checks against circles)
function gdump()
	local referenced={}
	local xdump=function (_class,no_func)
		local str="";
		for n=0,g_dump_tabs,1 do
			str=str.."  ";
		end
		for i,field in _class do
			if(type(field)=="table") then
				if(not %referenced[field])then
					g_dump_tabs=g_dump_tabs+1;
					System:Log(str..i.."= {");
					local idx=getn(%referenced)+1;
					%referenced[field]=idx;
					xdumpa(field);
					System:Log(str.."}");
					g_dump_tabs=g_dump_tabs-1;
				else
					System:Log(str..i.."=referenced["..tonumber(%referenced[field]).."]");
				end
			else
				if(type(field)=="number" ) then
					System:Log(str..i.."="..field);
				elseif(type(field) == "string") then
					System:Log(str..i.."=".."\""..field.."\"");
				else
					if(not no_func)then
						if(type(field)=="function")then
							System:Log(str..i.."()");
						else
							System:Log(str..i.."<userdata>");
						end
					end
				end
			end
		end
	end
	xdumpa=xdump;
	xdump(globals());
	referenced=nil;
end

-----------------------------------------------------------------------------
function dotproduct3d(a,b)
   return (a.x * b.x) + (a.y * b.y) + (a.z * b.z);
end

function LogVec(name,v)
	return format("%s = (%f %f %f)",name,v.x,v.y,v.z);
end

function CopyVector(dest,src)
	dest.x=src.x;
	dest.y=src.y;
	dest.z=src.z;
end
----------------------------------
function SumVectors(a,b)
	return {x=a.x+b.x,y=a.y+b.y,z=a.z+b.z};
end

----------------------------------
function FastSumVectors(dest,a,b)
	dest.x=a.x+b.x;
	dest.y=a.y+b.y;
	dest.z=a.z+b.z;
end

----------------------------------
function DifferenceVectors(a,b)
	return {x=a.x-b.x,y=a.y-b.y,z=a.z-b.z};
end

----------------------------------
function FastDifferenceVectors(dest,a,b)
	dest.x=a.x-b.x;
	dest.y=a.y-b.y;
	dest.z=a.z-b.z;
end

----------------------------------
function ProductVectors(a,b)
	return {x=a.x*b.x,y=a.y*b.y,z=a.z*b.z};
end

----------------------------------
function FastProductVectors(dest,a,b)
	dest.x=a.x*b.x;
	dest.y=a.y*b.y;
	dest.z=a.z*b.z;
end

----------------------------------
function LengthSqVector(a)
	return (a.x * a.x + a.y * a.y + a.z * a.z);
end

----------------------------------
function ScaleVector(a,b)
	return {x=a.x*b,y=a.y*b,z=a.z*b};
end

function ScaleVectorInPlace(a,b)
	a.x=a.x*b;
	a.y=a.y*b;
	a.z=a.z*b;
end

function ConvertToRadAngles(dest,src)
		local x=rad(src.z+180.0);
		local y=rad((-src.x)+90.0)
		local z=rad(src.y);

	  dest.x=-sin(y)*sin(x);
	  dest.y= sin(y)*cos(x);
	  dest.z=-cos(y);
end

function ConvertVectorToCameraAngles(dest,src)

		local	fForward;
		local	fYaw,fPitch;

		local temp = g_Vectors.temp;
		CopyVector( temp,src );

		NormalizeVector(temp)


		--first check for simple case
		if (temp.y==0 and temp.x==0) then
			--looking up/down
			fYaw=0;
			if (temp.z>0)then
				fPitch=90;
			else
				fPitch=270;
			end

		else
			if (temp.x~=0)then

				fYaw=atan2((temp.y),(temp.x))*(180.0/PI);

			else
				--lokking left/right
				if (temp.y>0) then
					fYaw=90;
				else
					fYaw=270;
				end
			end
			if (fYaw<0)then
				fYaw=fYaw+360;
			end

			fForward=sqrt(temp.x*temp.x+temp.y*temp.y);
			fPitch=(atan2(temp.z,fForward)*180.0/PI);
			if (fPitch<0)then
				fPitch=fPitch+360;
			end

		end

		--y = -fPitch;
		--x = fYaw;
		--z = 0;
		temp.x=-fPitch;
		temp.y=0; --can't calculate roll without an up vector
		temp.z=fYaw+90;

		--clamp again
		if (temp.x>360)then
			temp.x=temp.x-360;
		else
			if(temp.x<-360)then
				temp.x=temp.x+360;
			end
		end

		if (temp.z>360)then
			temp.z=temp.z-360;
		else
			if (temp.z<-360) then
				temp.z=temp.z+360;
			end
		end
		dest.x=temp.x
		dest.y=temp.y
		dest.z=temp.z

	end
----------------------------------
function ResetEnemies()
	local entities=System:GetEntities();
	for i, entity in entities do
		if (entity.Behaviour) then
			System:LogToConsole("$6Resetting "..entity.GetName().."...");
			entity:OnReset();
--			if (entity.cnt) then
--				entity.cnt.health = 100;
--				entity.AnimationSystemEnabled = 1;
--				entity.EnablePhysics(1);
--			end
		end
	end
end

----------------------------------
function NormalizeVector(a)
	local len=sqrt(LengthSqVector(a));
	local multiplier;
	if(len>0)then
		multiplier=1/len;
	else
		multiplier=0.0001;
	end
	a.x=a.x*multiplier;
	a.y=a.y*multiplier;
	a.z=a.z*multiplier;
end
----------------------------------
function FastScaleVector(dest,a,b)
	dest.x=a.x*b;
	dest.y=a.y*b;
	dest.z=a.z*b;
end

--linear interpolation
----------------------------------
function LerpColors(a,b,k)
	g_Vectors.tempColor[1] = a[1]+(b[1]-a[1])*k
	g_Vectors.tempColor[2] = a[2]+(b[2]-a[2])*k
	g_Vectors.tempColor[3] = a[3]+(b[3]-a[3])*k
	return g_Vectors.tempColor;
end

----------------------------------
function Lerp(a,b,k)
	return (a + (b - a)*k);
end


----------------------------------
function __max(a, b)
	if (a > b) then
		return a;
	else
		return b;
	end
end

----------------------------------
function GetPlayerWeaponInfo( player )
	if (player == nil or player.cnt == nil) then
		return nil;
	end
	local weaponid = player.cnt.weaponid;
	local weaponstate = player.WeaponState;
	if (weaponid~=nil and weaponstate~=nil) then
		if (weaponstate[weaponid] == nil) then
			-- init the weapon
			BasicPlayer.ScriptInitWeapon(player, player.cnt.weapon.name);
		end
		return weaponstate[weaponid];
	end

	return nil;
end

----------------------------------
--IsDay=1;
--LockToggle=0;
--OldSun=1;
--function ToggleDayNight( SetToDay, DontChangeSky, DontChangeSun )
--	if (SetToDay) then
--		IsDay=SetToDay;
--	else
--		if (LockToggle==0) then
--			IsDay=1-IsDay;
--		end
--	end
--	if (IsDay~=0) then
--		if ( DontChangeSun == nil ) then
--			e_sun=OldSun;
--		end
--		local	color = {x=1, y=1, z=1};
--		System.SetWorldColor( color );
--  		System:SetWorldColorRatio( 1 );
--		System.SetMaxFogDistRatio(1, 1, 1, 1);
--		if ( DontChangeSky == nil ) then
--			System:SetSkyBox("InfRedGal", 0, nil);
--		end
--	else
--		if ( DontChangeSun == nil ) then
--			OldSun=e_sun;
--			e_sun=0;
--		end
--		local	color = {x=.1, y=.1, z=.3};
--		System.SetWorldColor( color );
--  		System:SetWorldColorRatio( 0.15 );
--		System.SetMaxFogDistRatio(1, 0, 0, 0);
--		if ( DontChangeSky == nil ) then
--			System:SetSkyBox("NightSky", 0, nil);
--		end
--	end
--end

----------------------------------
function IsMaterialUnpierceble(material)
	if(material==nil)then
		System:LogToConsole("IsMaterialUnpierceble material is nil");
		return 1
	end
	if(material.gameplay_physic==nil)then
		System:LogToConsole("IsMaterialUnpierceble material.gameplay_physic is nil");
		return 1
	end
	return material.gameplay_physic.piercing_resistence;
end


----------------------------------
function ExecuteMaterial(pos,normal,material,bSound, target_id, ipart, PlaySoundObj)

	if( not pos ) then
		System:Log("\001  ExecuteMaterial with NULL pos <<<<<<< "  );
		do return end;
	end

	if(material == nil) then
	--	System.LogToConsole("material is nil");
		do return end;
	end

	local particles=material.particles;
	local loadedsounds=material.loadedsounds;

	if (loadedsounds == nil) then
		--System:Log("****************/////////////////--------------material , loadedsounds was nil");
		material.loadedsounds={};
		loadedsounds=material.loadedsounds;
	end

	local sounds=material.sounds;
	local decal=material.decal;
	local particleEffects=material.particleEffects;

	--PARTICLES----------------
	if(particles ~= nil) then
		if((particles.clippable==nil) or (particles.clippable and in_frustum))then
			for i,particle in particles do
				--System:Log("g_gore="..getglobal("g_gore"));
				if((not particle.gore) or (getglobal("g_gore")==1) or (getglobal("g_gore")==2)) then
					Particle:CreateParticle(pos,normal,particle);
				end
			end
		end
	end

	--PARTICLES EFFECTS----------------
	if(particleEffects ~= nil) then
		--System:Log("g_gore="..getglobal("g_gore"));
		if ((not particleEffects.gore) or (getglobal("g_gore")==1) or (getglobal("g_gore")==2)) then
			if (particleEffects.scale) then
				Particle:SpawnEffect(pos,normal, particleEffects.name,particleEffects.scale );
			else
				Particle:SpawnEffect(pos,normal, particleEffects.name );
			end
		end
	end

	--SOUNDS------------------
	if((sounds ~= nil) and (bSound ~= nil)) then

		local nsounds=getn(sounds);

		if(nsounds > 0) then

			--local sound=sounds[random(1,nsounds)];

			-- grab a random position in the table
			-- only do this if we are NOT on min spec
			local slot=1;
			if (tonumber(getglobal("sys_spec")) ~= 0) then
				slot = random(1,nsounds);
			end

			-- check if this sound was already loaded
			local sound=loadedsounds[slot];

			if (sound==nil) then
				-- if not, try to load it

				local sounddesc=sounds[slot];

				--System:Log("///////////////////////////////ExecuteMaterial: loading sound "..sounddesc[1]);

				sound=Sound:Load3DSound(sounddesc[1],sounddesc[2],sounddesc[3],sounddesc[4],sounddesc[5]);
				-- add it to the table
				loadedsounds[slot]=sound;
			--else
			--	local sounddesc=sounds[slot];
			--	System:Log("********************************ExecuteMaterial: Sound was found "..sounddesc[1]);
			end



			if (PlaySoundObj==nil) then
				Sound:SetSoundPosition(sound,pos);
				Sound:PlaySound(sound,bSound);
			else
				PlaySoundObj:PlaySound(sound,bSound);
			end
		end

	end

	--DECAL-------------------
	if(decal ~= nil) then

		if(g_gore == "0" and decal.gore ) then return end

		local rotation=0;
		local scale=decal.scale;
		local lifetime=decal.lifetime;
		if(decal.random_scale~=nil)then
			scale=scale+((scale*0.01)*random(0,decal.random_scale));
		end
		if(decal.random_rotation~=nil)then
			rotation=random(0,decal.random_rotation);
		end
		if(lifetime==nil)then
			lifetime=16;
		end

		Particle:CreateDecal(pos, normal, scale, lifetime, decal.texture, decal.object, rotation);
	end

end



----------------------------------
--
--	for bullets hits
--  passes target and bullet direction to CreateDecal
--	hit.pos, hit.normal, hit.target_material.bullet_hit, hit.play_mat_sound, hit.dir, hit.target_id, hit.ipart
--function ExecuteMaterial2(pos,normal,material,bSound, dir, target_id, ipart)
function ExecuteMaterial2(hit,mat_field)

	if (hit == nil) then
		return;
	end

	if (hit.target_material == nil) then
		return;
	end

	if(hit.target_material[mat_field] == nil) then
	--	System.LogToConsole("material is nil");
		do return end;
	end
	local mat=hit.target_material[mat_field]
	local particles=mat.particles;
	local loadedsounds=mat.loadedsounds;

	if (loadedsounds == nil) then
		--System:Log("****************/////////////////--------------material , loadedsounds was nil");
		mat.loadedsounds={};
		loadedsounds=mat.loadedsounds;
	end

	local sounds=mat.sounds;
	local decal=mat.decal;

	--PARTICLES EFFECTS----------------
	if(not hit.suppressParticleEffect)then
		ExecuteMaterial_Particles(hit,mat_field);
	end

	--PARTICLES----------------
	if(particles ~= nil) then
		if((particles.clippable==nil) or (particles.clippable and in_frustum))then
			for i,particle in particles do
				if((g_gore == "1") or (g_gore=="2") or (not particle.gore) ) then
					Particle:CreateParticle(hit.pos,hit.normal,particle);
				end
			end
		end
	end

	--SOUNDS------------------
	if((sounds ~= nil) and (hit.play_mat_sound ~= nil)) then

		local nsounds=getn(sounds);

		if(nsounds > 0) then

			--local sound=sounds[random(1,nsounds)]

			-- grab a random position in the table
			-- only do this if we are NOT on min-spec
			local slot=1;
			if (tonumber(getglobal("sys_spec")) ~= 0) then
				slot = random(1,nsounds);
			end

			-- check if this sound was already loaded
			local sound=loadedsounds[slot];
			if (sound==nil) then
				-- if not, try to load it
				local sounddesc=sounds[slot];
				--System:Log("////////////////////////////ExecuteMaterial2: loading sound "..sounddesc[1]);
				sound=Sound:Load3DSound(sounddesc[1],sounddesc[2],sounddesc[3],sounddesc[4],sounddesc[5]);
				-- add it to the table
				loadedsounds[slot]=sound;
			--else
			--	local sounddesc=sounds[slot];
			--	System:Log("********************************ExecuteMaterial: Sound was found "..sounddesc[1]);
			end

			local AIInfo = sounds[slot][6];
			if (AIInfo) then
			AI:SoundEvent(hit.shooter.id,pos,AIInfo.fRadius,AIInfo.fThreat,AIInfo.fInterest,hit.shooter.id);
			end


			Sound:SetSoundPosition(sound,hit.pos);
			Sound:PlaySound(sound,hit.play_mat_sound);
		end

	end

--System:Log("decal >>> ");

	--DECAL-------------------
	if(decal ~= nil) then

--System:Log("decal >>> ON");

		if(g_gore == "0" and decal.gore ) then return end

		-- no blood decals on local player in SP game
		if(hit.target and hit.target==_localplayer and (not Game:IsMultiplayer())) then return end

--System:Log("decal >>> gore");

		local rotation=0;
		local scale=decal.scale;
		local lifetime=decal.lifetime;
		if(decal.random_scale~=nil)then
			scale=scale+((scale*0.01)*random(0,decal.random_scale));
		end
		if(decal.random_rotation~=nil)then
			rotation=random(0,decal.random_rotation);
		end
		if(lifetime==nil)then
			lifetime=16;
		end

		if(hit.target_id) then

--System:Log("decal >>> ID "..hit.target_id);

			if(hit.ipart) then
				Particle:CreateDecal(hit.pos, hit.normal, scale, lifetime, decal.texture, decal.object, rotation, hit.dir, hit.target_id, hit.ipart);
			else
				Particle:CreateDecal(hit.pos, hit.normal, scale, lifetime, decal.texture, decal.object, rotation, hit.dir, hit.target_id);
			end
		elseif(hit.targetStat) then

--System:Log("decal >>> STAT  ");
			Particle:CreateDecal(hit.pos, hit.normal, scale, lifetime, decal.texture, decal.object, rotation, hit.dir, 0, 0, hit.targetStat);
		else
--System:Log("decal >>> TERRAIN ");
			Particle:CreateDecal(hit.pos, hit.normal, scale, lifetime, decal.texture, decal.object, rotation, hit.dir);
		end
	end

end



function ExecuteMaterial_Particles(hit,mat_field)

	local mat=hit.target_material[mat_field];
	local particleEffects=mat.particleEffects;

	if(particleEffects) then
		if((g_gore == "1") or (g_gore == "2") or (not particleEffects.gore)) then
			if (particleEffects.scale) then
				Particle:SpawnEffect(hit.pos,hit.normal, particleEffects.name,particleEffects.scale );
			else
				Particle:SpawnEffect(hit.pos,hit.normal, particleEffects.name );
			end
		end
	end
end


----------------------------------
function BroadcastEvent( sender,Event  )
	-- Check if Event Target for this input event exists.
	if (sender.Events) then
		--System:Log( "Events found" );
		local eventTargets = sender.Events[Event];
		if (eventTargets) then
			--System:Log( "Events Targets found" );
			for i, target in eventTargets do
				local TargetId = target[1];
				local TargetEvent = target[2];
				--System:Log( "Target: "..TargetId.."/"..TargetEvent );

				if (TargetId == 0) then
					-- If TargetId refer to global Mission table.
					if Mission then
						local func = Mission["Event_"..TargetEvent];
						if (func ~= nil) then
							func( sender )
						else
							System:Log( "Mission does not support event "..TargetEvent );
						end
					end
				else
					-- If TargetId refere to Entity.
					local entity = System:GetEntity(TargetId);
					if (entity ~= nil) then

						--local TargetName=entity:GetName();
						--System:Log( "Entity Named "..TargetName.." Found." );
						--System:Log( "Calling method: "..TargetName..":Event_"..TargetEvent );
						local func = entity["Event_"..TargetEvent];
						if (func ~= nil) then
							func( entity,sender )
--						else
--							System:Log( "Entity "..TargetName.." does not support event "..TargetEvent );
						end
--					else
--						System:Log( "Entity Named "..TargetName.." Not Found." );
					end
				end
 			end
 		end
 	end
end

----------------------------------
function count(_table)
	local count=0;
	for idx,i in _table do
		count=count+1;
	end
	return count;
end

----------------------------------
function append(_table, item)
	local i=count(_table) + 1;
	_table[i] = item;
end

----------------------------------
function HideWeapon()
	g_HideWeapons = 1;
end

function ShowWeapon()
	g_HideWeapons = nil;
end

function DumpEntities()
	local ents=System:GetEntities();
	System:Log("Entities dump");
	for idx,e in ents do
		local pos=e:GetPos();
		local ang=e:GetAngles();
		System:Log("["..tostring(e.id).."]..name="..e:GetName().." clsid="..tostring(e.classid)..format(" pos=%.03f,%.03f,%.03f",pos.x,pos.y,pos.z)..format(" ang=%.03f,%.03f,%.03f",ang.x,ang.y,ang.z));
	end
end

--///////////////////////////////////////////////////////////////////////////////////
function SetEntitiesState(state,classid)
	local ents=System:GetEntities();
	System:Log("Entities dump");
	for idx,e in ents do
		if(e.classid==classid)then
			e:GotoState(state);
			local pos=e:GetPos();
			System:Log("["..tostring(e.id).."]..name="..e:GetName().." classid="..tostring(e.classid).." pos="..pos.x..","..pos.y..","..pos.z);
		end
	end
end

--///////////////////////////////////////////////////////////////////////////////////
function AIReload()
	Script:ReloadScript("Scripts/AI/aiconfig.lua");
end

--///////////////////////////////////////////////////////////////////////////////////
-- useful when you want pass a parameter which might be empty to C++
-- without this call you have to check for existance of the parameter and for nil
-- with it you just need to check for nil
function tonotnil( ValOrNil )
	return ValOrNil;
end


--///////////////////////////////////////////////////////////////////////////////////
-- \param parameterno 1..
function GetParameterNo( textline, parameterno )
	if textline then
		local tokens=tokenize(textline);
	
		return tokens[parameterno];
	end
end

--///////////////////////////////////////////////////////////////////////////////////
CommonCallbacks= {
};

--///////////////////////////////////////////////////////////////////////////////////
function CommonCallbacks:OnCollide(hit)
	local mat=Game:GetMaterialBySurfaceID(hit.matId);
	ExecuteMaterial(hit.vPos,hit.vNorm,mat.object_impact,1);
	--System:Log("OK....");
end

function GetParticleCollisionStatus(ent)
	local stat=ent:GetParticleCollisionStatus()
	if(stat)then
		--System:Log("stat.target_material="..stat.target_material);
		stat.target_material=Game:GetMaterialBySurfaceID(stat.target_material);

		if(stat.target_material.type~="obstruct") then
			return stat;
		end
--System:Log("stat.target_material="..stat.target_material.type);
		return stat;
	end
end

-----------------------------------------------------------------------------------------
-- Benchmark functions.
-----------------------------------------------------------------------------------------
function StartBenchmark1( name )
	System:Log( "************ StartBenchmark1 ************ " );
	--profile = 0;
	setglobal("profile",0);
	--demo_num_runs=10;
	setglobal("demo_num_runs",10);
	Game:StartDemoPlay( name )
end

function StartBenchmark2( name )
	System:Log( "************ StartBenchmark1 ************ " );
	--profile = -1;
	setglobal("profile",-1);
	--demo_num_runs=10;
	setglobal("demo_num_runs",10);
	Game:StartDemoPlay( name )
end

--------------------------------------------------------------------------
----- globals to manage the number of splash effects ---------------------
--------------------------------------------------------------------------
g_curSplashes = 0;
g_maxSplashes = 8;
g_lastSplashTime = 0;
g_SplashDuration = 2;

-------------------------------------------------------------------
--return if the point is inside ent:localbbox, bias means how close the point could be to the bbox to be considered inside.
--the test dont take into account a real box, but an ellipsoid based on entity rotation and localbbox size.
function PointInsideBBox(point,ent,bias)

	local epos = ent:GetPos();
	local deltapos = g_Vectors.temp_v1;

	deltapos.x = point.x-epos.x;
	deltapos.y = point.y-epos.y;
	deltapos.z = point.z-epos.z;

	--I dont use NormalizeVector() because I need the lenght of the vector
	local deltalen = sqrt(LengthSqVector(deltapos));
	local normalizelen = 1.0/deltalen;

	if  (deltalen <= 0) then normalizelen = 0.0001; end

	deltapos.x = deltapos.x * normalizelen;
	deltapos.y = deltapos.y * normalizelen;
	deltapos.z = deltapos.z * normalizelen;

	local evecfwd = g_Vectors.temp_v2;
	local evecright = g_Vectors.temp_v3;
	local evecup = g_Vectors.temp_v4;

	merge(evecfwd,ent:GetDirectionVector(0));
	merge(evecright,ent:GetDirectionVector(1));
	merge(evecup,ent:GetDirectionVector(2));

	local dot_fwd = dotproduct3d(evecfwd,deltapos);
	local dot_right = dotproduct3d(evecright,deltapos);
	local dot_up = dotproduct3d(evecup,deltapos);

	local bbox = ent:GetLocalBBox(nil,nil);
	local max = bbox.max;

	--Hud:AddMessage("dot_fwd:"..dot_fwd..",dot_right:"..dot_right..",fwd_len:"..max.y..",right_len:"..max.x);

	local distfrombbox = abs(dot_fwd)*max.y*bias + abs(dot_right)*max.x*bias + abs(dot_up)*max.z*bias;

	--Hud:AddMessage("distfrombbox:"..distfrombbox..",deltalen:"..deltalen);

	if (deltalen-distfrombbox < bias) then
		return 1;
	else
		return nil;
	end
end

-----------------------------------------------------------------------------------------
function CreateEntityLight( entity, radius, r, g, b, lifeTime, pos )

	local doProjectileLight = tonumber(getglobal("cl_projectile_light"));
	
	if(doProjectileLight==0) then return end
	
	local lightPos = pos;
	if(not lightPos) then
		 lightPos = entity:GetPos();
	end	 

	if (doProjectileLight == 1) then		-- no specular
		-- vPos, fRadius, DiffR, DiffG, DiffB, DiffA, SpecR, SpecG, SpecB, SpecA, fLifeTime
		entity:AddDynamicLight(lightPos, radius, r, g, b, 1, 0, 0, 0, 0, lifeTime);
	elseif (doProjectileLight == 2) then		-- with specular
		entity:AddDynamicLight(lightPos, radius, r, g, b, 1, r, g, b, 1, lifeTime);
	end
end


-----------------------------------------------------------------------------------------
function toNumberOrZero( inValue )
	local ret=tonumber(inValue);
	
	if ret then
		return ret;
	else
		return 0;
	end
end

-------------------------------------------------------------------------------------------
function EntitiesDistSq(ent1,ent2)

	if (ent1.GetPos==nil or ent2.GetPos==nil) then return 0 end
	
	local delta = g_Vectors.temp_v1;
	
	CopyVector(delta,ent1:GetPos());
	
	local epos = ent2:GetPos();
					
	delta.x = delta.x - epos.x;
	delta.y = delta.y - epos.y;
	delta.z = delta.z - epos.z;
		
	return (LengthSqVector(delta));
end

-------------------------------------------------------------------
-- gloabl to indicate that a ui reload was requested commited by UI:Reload( ... ), will be reset by UI:Init()
g_reload_ui = 0;
