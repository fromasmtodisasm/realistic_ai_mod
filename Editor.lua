-- Tigs editor settings

-- how to call a script in lua
-- Script:LoadScript("path/relative/to/mastercd");

-- how to call a script in the editor
-- goto tools -> Configure Tools... and make a new entry
-- in the entry, add the following:
-- #togglep_draw_helpers()
-- change 'toggle_draw_helpers' to the function you wish to call

Input:BindCommandToKey("#ToggleGod()","backspace",1);

-- general
LuaEditor=notepad
OpenLastProject=0
s_MusicEnable=1
s_SoundEnable=1
g_god=1

-- video/screendisplay
--GL_TextureFilter=GL_LINEAR_MIPMAP_NEAREST
GL_TextureFilter=GL_LINEAR_MIPMAP_LINEAR
r_Width=640	
r_Height=480
r_DisplayInfo=0
r_Gamma=1
cl_Display_HUD=0

-- editing function defaults
e_portals=1
CV_ind_AmbientColor=0
p_draw_helpers=0
ai_debugdraw=0
ai_hidedraw=0
r_ExcludeShader=0

-----------------------------------------
-- editor functions
-----------------------------------------

----------------------------------------
-- Decrease and increase the ambient colour of indoors
function AmbientColorDecrease()
	if tonumber(CV_ind_AmbientColor)>0 then
		CV_ind_AmbientColor=CV_ind_AmbientColor-0.01;
		System:LogToConsole("\001AmbientColor (indoor) decreased ["..CV_ind_AmbientColor.."]");
	else
		System:LogToConsole("\001CV_ind_AmbientColor (indoor) can not go any darker!");
	end 
end

function AmbientColorIncrease()
	if tonumber(CV_ind_AmbientColor)<1 then
		CV_ind_AmbientColor=CV_ind_AmbientColor+0.01;
		System:LogToConsole("\001AmbientColor (indoor) Increased ["..CV_ind_AmbientColor.."]");
	else
		System:LogToConsole("\001CV_ind_AmbientColor (indoor) can not go any Brighter!");
	end 
end
----------------------------------------
-- Decrease and increase the gamma
function GammaDecrease()
	if tonumber(r_Gamma)>0 then
		r_Gamma=r_Gamma-0.1;
		System:LogToConsole("\001Gamma decreased to ["..r_Gamma.."]");
	else
		System:LogToConsole("\001Gamma can not go any dimmer!");
	end 
end

function GammaIncrease()
	if tonumber(r_Gamma)<2 then
		r_Gamma=r_Gamma+0.1;
		System:LogToConsole("\001Gamma Increased to ["..r_Gamma.."]");
	else
		System:LogToConsole("\001Gamma can not go any Brighter!");
	end 
end
----------------------------------------
-- toggle gamma 1/2
function toggle_Gamma()
	if tonumber(r_Gamma)<2 then
		r_Gamma=r_Gamma+1;
		System:LogToConsole("\001Gamma now ["..r_Gamma.."]");
	else
		r_Gamma=1;
		System:LogToConsole("\001Gamma now ["..r_Gamma.."]");
	end 
end
----------------------------------------
-- toggle though log_Verbosity 
function toggleLog_Verbosity()
	if (tonumber(log_Verbosity)<5) then
		log_Verbosity=log_Verbosity+1;
		System:LogToConsole("\001Verbosity level now ["..log_Verbosity.."]");
	else 
		log_Verbosity=1;
		System:LogToConsole("\001Verbosity level now ["..log_Verbosity.."]");
	end 
end
----------------------------------------
-- toggle though r_DebugLights  
function toggler_DebugLights()
	if (tonumber(r_DebugLights)<3) then
		r_DebugLights=r_DebugLights+1;
		System:LogToConsole("\001Debuglights level now ["..r_DebugLights.."]");
	else 
		r_DebugLights=0;
		System:LogToConsole("\001Debuglights level now ["..r_DebugLights.."]");
	end 
end
----------------------------------------
-- toggle the p_drawhelps (physic boxes)
function togglep_draw_helpers()
	if (tonumber(p_draw_helpers)<1) then
		p_draw_helpers=2306;
		System:LogToConsole("\001p_draw_helpers set to ["..p_draw_helpers.."]");
	else 
		p_draw_helpers=0;
		System:LogToConsole("\001p_draw_helpers set to ["..p_draw_helpers.."]");
	end 
end
----------------------------------------
-- toggle though r_ShowLines 
function toggler_ShowLines()
	if (tonumber(r_ShowLines)<2) then
		r_ShowLines=r_ShowLines+1;
		System:LogToConsole("\001ShowLines level now ["..r_ShowLines.."]");
	else 
		r_ShowLines=0;
		System:LogToConsole("\001ShowLines level now ["..r_ShowLines.."]");
	end 
end
----------------------------------------
-- toggle though e_Portals 0/1/2/3/4
function togglee_Portals()
	if (tonumber(e_portals)<4) then
		e_portals=e_portals+1;
		System:LogToConsole("\001Showing portal areas ["..e_portals.."]");
	else 
		e_portals=0;
		System:LogToConsole("\001Disabling drawing of Portals ["..e_portals.."]");
	end 
end
----------------------------------------
-- toggle though ai_debugdraw
function toggleai_debug()
	if (tonumber(ai_debugdraw)>0) then
		ai_debugdraw=0;
		ai_drawplayernode=0;
		System:LogToConsole("\001AI debug is OFF ["..ai_debugdraw.."]");
	else 
		ai_debugdraw=1;
		ai_drawplayernode=1;
		System:LogToConsole("\001AI debug is ON ["..ai_debugdraw.."]");
	end 
end
----------------------------------------
-- toggle though ai_hidedraw
--	ai_debugdraw=1;
--	ai_drawplayernode=1;
--	ai_hidedraw=1;
--	ai_agentstats=0;  
function toggleai_hidedraw()
	if (tonumber(ai_hidedraw)>0) then
		ai_debugdraw=0;
		ai_drawplayernode=0;
		ai_hidedraw=0;
		ai_agentstats=1;
		System:LogToConsole("\001AI hide info is OFF ["..ai_hidedraw.."]");
	else 
		ai_debugdraw=1;
		ai_drawplayernode=1;
		ai_hidedraw=1;
		ai_agentstats=0;
		System:LogToConsole("\001AI hide info is ON ["..ai_hidedraw.."]");
	end 
end

----------------------------------------
-- toggle though leaves drawn/not drawn
function toggle_leavesshaderdraw()
	if (tonumber(r_ExcludeShader)~=0) then
		r_ExcludeShader=0;
		System:LogToConsole("\001templplants shader is on]");
	else 
		r_ExcludeShader="templplants";
		System:LogToConsole("\001templplants shader is off]");
	end 
end

-- toggle though e_terrain_debug 
function toggler_terrain_debug()
	if (tonumber(e_terrain_debug)<2) then
		e_terrain_debug=e_terrain_debug+1;
		System:LogToConsole("\001terrain_debug level now ["..e_terrain_debug.."]");
	else 
		e_terrain_debug=0;
		System:LogToConsole("\001terrain_debug level now ["..e_terrain_debug.."]");
	end 
end
----------------------------------------
-- make hires screenshot
function hires_screenshoot()
	e_hires_screenshoot=1;
end
----------------------------------------
-- toggle though e_terrain_debug 
function sound_off()
	if (tonumber(s_SoundEnable)>0) then
		s_SoundEnable=0;
		s_MusicEnable=1;
		s_MusicEnable=0;
		System:LogToConsole("\001 sound off");
	else 
		s_SoundEnable=1;
		s_MusicEnable=1;
		System:LogToConsole("\001 sound on");
	end 
end


--- functions---
function ToggleGod()

	if (not god) then
		god=1;
	else
		god=1-god;
	end
	if (god==1) then
		System:LogToConsole("God-Mode ON");
	else
		System:LogToConsole("God-Mode OFF");
	end
end

