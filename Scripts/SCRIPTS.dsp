# Microsoft Developer Studio Project File - Name="SCRIPTS" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Generic Project" 0x010a

CFG=SCRIPTS - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "SCRIPTS.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "SCRIPTS.mak" CFG="SCRIPTS - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "SCRIPTS - Win32 Release" (based on "Win32 (x86) Generic Project")
!MESSAGE "SCRIPTS - Win32 Debug" (based on "Win32 (x86) Generic Project")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""$/MasterCD_Programmers/SCRIPTS", LHSAAAAA"
# PROP Scc_LocalPath "."
MTL=midl.exe

!IF  "$(CFG)" == "SCRIPTS - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""

!ELSEIF  "$(CFG)" == "SCRIPTS - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""

!ENDIF 

# Begin Target

# Name "SCRIPTS - Win32 Release"
# Name "SCRIPTS - Win32 Debug"
# Begin Group "Default"

# PROP Default_Filter ""
# Begin Group "Entities"

# PROP Default_Filter ""
# Begin Group "AITest"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\AItest\WarmSniper.lua
# End Source File
# End Group
# Begin Group "Aliens"

# PROP Default_Filter ""
# Begin Group "Alien"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\Aliens\Alien\Alien.lua
# End Source File
# End Group
# End Group
# Begin Group "Ammo"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\Ammo\ammo_ag36.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Ammo\ammo_at4.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Ammo\ammo_aw50.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Ammo\ammo_g36.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Ammo\ammo_mach.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Ammo\ammo_pistol.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Ammo\ammo_pistol2.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Ammo\ammo_pistol_1.lua
# End Source File
# End Group
# Begin Group "Breakables"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\Breakables\vodka.lua
# End Source File
# End Group
# Begin Group "ClimbableTrees"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\ClimbableTrees\ClimbableTree01.lua
# End Source File
# End Group
# Begin Group "dinosaur"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\dinosaur\Iguan.lua
# End Source File
# End Group
# Begin Group "Elevators"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\Elevators\ball.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Elevators\elevator1.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Elevators\elevator2.lua
# End Source File
# End Group
# Begin Group "Flags"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\Flags\conquer_flag.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Flags\flag_blue.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Flags\flag_red.lua
# End Source File
# End Group
# Begin Group "Health"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\Health\Medikit.lua
# End Source File
# End Group
# Begin Group "Ladders"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\Ladders\ladder.lua
# End Source File
# End Group
# Begin Group "npc"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\npc\npc.lua
# End Source File
# End Group
# Begin Group "Others"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\Others\CameraTargetPoint.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Others\fan.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Others\fan2.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Others\TestWall.lua
# End Source File
# End Group
# Begin Group "Particle"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\Particle\Smoke.lua
# End Source File
# End Group
# Begin Group "PLAYER"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\PLAYER\BasicPlayer.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\PLAYER\car.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\PLAYER\player.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\PLAYER\PlayerSystem.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\PLAYER\tree.lua
# End Source File
# End Group
# Begin Group "Sound"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\Sound\AmbientSound.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Sound\RandomAmbientSound.lua
# End Source File
# End Group
# Begin Group "Triggers"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\Triggers\BallTrigger.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Triggers\BriefTrigger.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Triggers\door.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Triggers\EnterTrigger.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Triggers\Trigger0.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Triggers\Waypoint.lua
# End Source File
# End Group
# Begin Group "Vehicles"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\Vehicles\car.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Vehicles\jeep.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Vehicles\quad.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Vehicles\turret.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Vehicles\VehicleSystem.lua
# End Source File
# End Group
# Begin Group "Weapons"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Entities\Weapons\AG36.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\AlienRocket.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\AW50.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\Barett.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\BasicWeapon.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\Binoculars.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\BiPod.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\DE.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\DroppedWeapon.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\FTBSniping.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\G11.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\Grenade.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\M4.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\Mortar.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\mounted.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\MP5.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\OICW.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\P90.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\Pancor.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\RL.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\Rocket.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\Shocker.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\smount.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Entities\Weapons\WeaponSystem.lua
# End Source File
# End Group
# End Group
# Begin Group "Hud"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Default\Hud\Binoculars.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Hud\HeatVision.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Hud\Hud.Lua
# End Source File
# Begin Source File

SOURCE=.\Default\Hud\NightVision.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Hud\Zoom.lua
# End Source File
# End Group
# Begin Group "Missions"

# PROP Default_Filter ""
# End Group
# Begin Source File

SOURCE=.\Default\GameRules.lua
# End Source File
# Begin Source File

SOURCE=.\Default\Inventory.lua
# End Source File
# End Group
# Begin Group "AI"

# PROP Default_Filter ""
# End Group
# Begin Group "GameStuff"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\GameStuff\TeamGame.lua
# End Source File
# End Group
# End Target
# End Project
