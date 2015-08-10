DEFINE_BASECLASS( "gamemode_base" )

include( "player_class/player_securityguard.lua" )
include( "player_class/player_foxy.lua" )
include( "player_class/player_freddy.lua" )
include( "player_class/player_bonnie.lua" )
include( "player_class/player_chica.lua" )
include( "player_class/player_goldenfreddy.lua" )

GM.Name 	= "Five Nights at Freddy's"
GM.ShortName = "FNAFGM"
GM.Author 	= "Xperidia"
GM.Email 	= "contact@Xperidia.com"
GM.Website 	= "http://steamcommunity.com/sharedfiles/filedetails/?id=408243366"
GM.OfficialVersion 	= 1.05
GM.Version 	= GM.OfficialVersion
GM.CustomVersion = false
GM.TeamBased = true
GM.AllowAutoTeam = true
if engine.ActiveGamemode()=="fnafgm" then
	GM.Official = true
else
	GM.Official = false
end
GM.CustomVersionChecker = ""


--[[ Gamemode constants for derivations ]]--
GM.TimeBase = 12
GM.TimeEnd = 6
GM.AMPM = "AM"
GM.AMPM_End = "AM"
GM.NightBase = 0
GM.NightEnd = 5
GM.HourTime = 86
GM.HourTime_add = 0 --Not used since power is in the place
GM.Power_Max = 100
GM.Power_Drain_Time = 9.6
GM.Power_Usage_Base = 1

GM.Colors_default = Color(255, 255, 255, 255)
GM.Colors_defaultchat = Color(255, 255, 255)
GM.Colors_surl = Color(255, 170, 0, 255)
GM.Colors_sg = Color(255, 255, 100)
GM.Colors_animatronics = Color(255, 0, 0)

GM.Sound_startday = Sound("fnafgm/startday.ogg")
GM.Sound_static = Sound("fnafgm/static.ogg")
GM.Sound_endnight = Sound("fnafgm/clocks_chimes.ogg")
GM.Sound_endnight2 = Sound("fnafgm/clocks_chimes2.ogg")
GM.Sound_xscream = Sound("fnafgm/xscream.ogg")
GM.Sound_xscream2 = Sound("fnafgm/xscream2.ogg")
GM.Sound_foxystep0 = Sound("fnafgm/run0.ogg")
GM.Sound_foxystep1 = Sound("fnafgm/run1.ogg")
GM.Sound_securitycampop = Sound("fnafgm/camdown.ogg")
GM.Sound_securitycampop2 = Sound("fnafgm/monitoron2.ogg")
GM.Sound_securitycamdown2 = Sound("fnafgm/monitoroff2.ogg")
GM.Sound_securitycampop3 = Sound("fnafgm/monitoron3.ogg")
GM.Sound_securitycamdown3 = Sound("fnafgm/monitoroff3.ogg")
GM.Sound_camselect = Sound("fnafgm/camselect.ogg")
GM.Sound_lighterror = Sound("fnafgm/lighterror.ogg")
GM.Sound_end1 = Sound("fnafgm/end.ogg")
GM.Sound_end2 = Sound("fnafgm/end2.ogg")
GM.Sound_Foxy = Sound("fnafgm/piratesong2.ogg")
GM.Sound_ChicaBonnie = { Sound("fnafgm/cb1.ogg"), Sound("fnafgm/cb2.ogg"), Sound("fnafgm/cb3.ogg"), Sound("fnafgm/cb4.ogg") }
GM.Sound_Freddy = { Sound("fnafgm/freddy1.ogg"), Sound("fnafgm/freddy2.ogg"), Sound("fnafgm/freddy3.ogg") }
GM.Sound_GoldenFoxy = Sound("fnafgm/goldenfreddy.ogg")
GM.Sound_Calls = {
	freddys = { "fnafgm/voiceover1.ogg", "fnafgm/voiceover2.ogg", "fnafgm/voiceover3.ogg", "fnafgm/voiceover4.ogg", "fnafgm/voiceover5.ogg" }
}
GM.Sound_maskon = Sound("fnafgm/maskon.ogg")
GM.Sound_maskoff = Sound("fnafgm/maskoff.ogg")

GM.Strings = {
	base = {
		sg = "Security guards",
		animatronics = "Animatronics",
		animatronic = "Animatronic",
		tonight = "To Night",
		night = "Night",
		freddys_start = "TURN OFF THE MAIN POWER TO START",
		freddys_start_2 = "TURN OFF THE MAIN POWER TO START A NEW NIGHT",
		freddys_startanimatronics = "THE MAIN POWER IS ON",
		fnaf2_start = "TURN ON THE ANIMATRONICS TO START",
		fnaf2_start_2 = "TURN ON THE ANIMATRONICS TO START A NEW NIGHT",
		fnaf_freddypizzaevents_start = "TYPE !START TO START THE MAP",
		foxy = "Foxy",
		freddy = "Freddy",
		chica = "Chica",
		bonnie = "Bonnie",
		goldenfreddy = "Golden Freddy",
		unassigned_normal = "PRESS ANY BUTTON TO JOIN THE GAME",
		unassigned_SGvsA = "CHOOSE A TEAM",
		powerleft = "Power left:",
		usage = "Usage:",
		unassigned_powerdown = "YOU CANT'T JOIN WHEN THE POWER IS DOWN!",
		flashlight = "flashlight",
		monitor = "Monitor",
		monitor_inst = "Click to open the Monitor. Reload to enter FNaF view. Only in the security room!",
		monitor_purp = "Monitor the restaurant.",
		spectator = "Spectator",
		warn_font = "The font is not installed! Read the installation instructions by pressing F1 (Maybe there is a update if you already installed it)",
		warn_css = "Counter Strike: Source is not mounted. You will have missing textures and ERROR."
	},
	fr = {
		freddys_start = "COUPEZ LE COURANT POUR DÉMARRER",
		freddys_start_2 = "COUPEZ LE COURANT POUR DÉMARRER UNE NOUVELLE NUIT",
		freddys_startanimatronics = "LE COURANT EST ALLUMÉ",
		fnaf2_start = "ACTIVER LES ANIMATRONICS POUR DÉMARRER",
		fnaf2_start_2 = "ACTIVER LES ANIMATRONICS POUR DÉMARRER UNE NOUVELLE NUIT",
		fnafeddypizzaevents_start = "TAPPEZ !START POUR DÉMARRER",
		unassigned_normal = "APPUYEZ SUR N'IMPORTE QUEL BOUTON POUR REJOINDRE LA PARTIE",
		unassigned_SGvsA = "CHOISISSEZ UN CAMP",
		unassigned_powerdown = "VOUS NE POUVEZ PAS REJOINDRE QUAND IL N'Y A PLUS D'ENERGIE!",
		monitor = "Moniteur",
		monitor_inst = "Faites un clic pour ouvrir le Moniteur. Rechargez pour entrer en vue FNaF. Uniquement dans la salle de sécurité !",
		monitor_purp = "Surveiller le restaurant.",
		spectator = "Spectateur",
		warn_font = "La police n'est pas installée! Lisez les instructions d'installation en appuyant sur F1 (Peut être qu'il y a une mise à jour si vous l'aviez déjà installée)",
		warn_css = "Counter Strike: Source n'est pas monté. Vous aurez des textures manquantes et des ERROR."
	}
}

function fnafgmLoadLanguage(lang)
	
	if lang!="" and GAMEMODE.Strings[lang] then
		table.Merge( GAMEMODE.Strings["base"], GAMEMODE.Strings[lang] )
	end
	
end

GM.Spawns_sg = { "info_player_start", "info_player_terrorist" }
GM.Spawns_animatronics = { "info_player_counterterrorist" }

GM.SecurityRoom = {
	freddys = { Vector(-160,-1275,60), Vector(0,-1058,170) },
	freddysnoevent = { Vector(-160,-1275,60), Vector(0,-1058,170) },
	fnaf2 = { Vector(138,-340,190), Vector(-138,128,0) },
	fnaf_freddypizzaevents = { Vector(-325,1765,125), Vector(-623,2095,0) },
	fnap_scc = { Vector(-510,-125,26), Vector(-334,-372,170), Vector(-510,-125,26), Vector(-195,-258,170) },
	fnaf3 = { Vector(-174,-178,190), Vector(174,-342,65) },
	fnaf4 = { Vector(-254,524,128), Vector(-514,190,0) }
}

GM.Hallways = {
	freddysnoevent = { Vector(108,-1323,182), Vector(0,-487,64), Vector(-160,-1325,182), Vector(-270,-487,60) }
}

GM.DoorBonnie = {
	freddysnoevent = { Vector(-169,-1138,160), Vector(-212,-1201,64) }
}

GM.DoorFreddy = {
	freddysnoevent = { Vector(9,-1197,160), Vector(46,-1135,64) }
}

GM.DoorChica = {
	freddysnoevent = { Vector(14,-1120,160), Vector(30,-1056,64) }
}

GM.DeadBodiesTeleport = {
	freddys = { Vector(-508, -25, 92), Vector(-580, -124, 92), Vector(-500, -120, 92), Vector(-508, -192, 92) },
	freddysnoevent = { Vector(-508, -25, 92), Vector(-580, -124, 92), Vector(-500, -120, 92), Vector(-508, -192, 92) },
	fnaf2 = { Vector(-412, 1431, 92), Vector(-290, 1482, 92), Vector(-223, 1436, 92), Vector(-328, 1414, 92) },
	fnaf_freddypizzaevents = { Vector(329, 654, 64) },
	fnap_scc = { Vector(200, 432, 96) }
}

GM.FNaFView = {
	freddys = { Vector( -80, -1224, 64 ), Angle( 0, 90, 0 ), Angle( 0, 128, 0 ), Angle( 0, 52, 0 ) },
	freddysnoevent = { Vector( -80, -1224, 64 ), Angle( 0, 128, 0 ), Angle( 0, 120, 0 ), Angle( 0, 52, 0 ) },
	fnaf2 = { Vector( 0, -300, 0 ), Angle( 0, 90, 0 ), Angle( 0, 128, 0 ), Angle( 0, 52, 0 ) },
	fnaf3 = { Vector( 14, -300, 64 ), Angle( 0, 90, 0 ), Angle( 0, 140, 0 ), Angle( 0, 80, 0 ) },
	fnap_scc = { Vector( -465, -255, 32 ), Angle( 0, 0, 0 ), Angle( 0, 42, 0 ), Angle( 0, -44, 0 ) }
}

GM.Materials_static = "fnafgm/static"
GM.Materials_camstatic = "fnafgm/camstatic"
GM.Materials_goldenfreddy = "fnafgm/goldenfreddy"
GM.Materials_animatronicsvision = "effects/combine_binocoverlay"
GM.Materials_mapfreddys = "fnafgm/mapfreddys"
GM.Materials_mapfnaf2 = "fnafgm/mapfnaf2"
GM.Materials_usage = "fnafgm/usage_"
GM.Materials_battery = "fnafgm/battery_"
GM.Materials_intro = "fnafgm/intro"
GM.Materials_introfnaf2 = "fnafgm/introfnaf2"
GM.Materials_end1 = "fnafgm/end"
GM.Materials_end1_6 = "fnafgm/end6"
GM.Materials_end2 = "fnafgm/endfnaf2"
GM.Materials_end2_6 = "fnafgm/endfnaf2_6"
GM.Materials_animatronic = "fnafgm/freddy"
GM.Materials_foxy = "fnafgm/foxy"
GM.Materials_fnaf2deathcam = "fnafgm/fnaf2deathcam"

GM.Models_deadsp = Model("models/splinks/fnaf/freddy/freddy.mdl")
GM.Models_dead = { Model("models/splinks/fnaf/bonnie/bonnie.mdl"), Model("models/splinks/fnaf/chica/chica.mdl"), Model("models/splinks/fnaf/freddy/freddy.mdl") }
GM.Models_defaultplayermodels = {"barney", "male10", "male11", "male12", "male13", "male14", "male15", "male16", "male17", "male18"}
GM.Models_bonnie = Model("models/splinks/fnaf/bonnie/player_bonnie.mdl")
GM.Models_chica = Model("models/splinks/fnaf/chica/player_chica.mdl")
GM.Models_foxy = Model("models/splinks/fnaf/foxy/player_foxy.mdl")
GM.Models_freddy = Model("models/splinks/fnaf/freddy/player_freddy.mdl")
GM.Models_goldenfreddy = Model("models/splinks/fnaf/golden_freddy/player_golden_freddy.mdl")

GM.CamsNames = {
	freddys_1 = "West Hall Corner",
	freddys_2 = "West Hall",
	freddys_3 = "Supply Closet",
	freddys_4 = "East Hall",
	freddys_5 = "East Hall Corner",
	freddys_6 = "Backstage",
	freddys_7 = "Show Stage",
	freddys_8 = "Restroom",
	freddys_9 = "Pirate Cove",
	freddys_10 = "Dining Area",
	freddys_11 = "Kitchen",
	fnaf2_1 = "Party Room 1",
	fnaf2_2 = "Party Room 2",
	fnaf2_3 = "Party Room 3",
	fnaf2_4 = "Party Room 4",
	fnaf2_5 = "Right Air Vent",
	fnaf2_6 = "Left Air Vent",
	fnaf2_7 = "Main Hall",
	fnaf2_8 = "Parts/Service",
	fnaf2_9 = "Kid's Cove",
	fnaf2_10 = "Prize Corner",
	fnaf2_11 = "Game Area",
	fnaf2_12 = "Show Stage",
	fnap_scc_1 = "Kitchen",
	fnap_scc_2 = "Stage",
	fnap_scc_3 = "Dining Area",
	fnap_scc_4 = "Entrance",
	fnap_scc_5 = "North Hall B",
	fnap_scc_6 = "Bath-Rooms",
	fnap_scc_7 = "North Hall A",
	fnap_scc_8 = "Pinkie's Bedroom",
	fnap_scc_9 = "Storage",
	fnap_scc_10 = "Supply Room",
	fnap_scc_11 = "Trash",
	fnap_scc_12 = "Cave",
	fnap_scc_13 = "Storage",
	fnap_scc_14 = "Generator",
	fnap_scc_15 = ""
}

GM.MapList = {
	freddys = "FNaF 1",
	freddysnoevent = "SGvsA",
	fnaf2 = "FNaF 2",
	fnaf3 = "FNaF 3",
	fnaf4house = "FNaF 4",
	fnaf_freddypizzaevents = "FNaF Mix"
}


startday = false
iniok = false
time = GM.TimeBase
AMPM = GM.AMPM
night = GM.NightBase
hourtime = GM.HourTime
nightpassed = false
mapoverrideok = false
gameend = false
SGvsA = false
AprilFool = false
Halloween = false
b87 = false
seasonaltext = ""
modetext = ""
norespawn = false
active = false
updateavailable = false
derivupdateavailable = false
lastversion = "?"
lastderivversion = "?"
listgroup = {}
avisible = {}
power = GM.Power_Max
powerdrain = GM.Power_Drain_Time
powerusage = GM.Power_Usage_Base
poweroff = false
tabused = {}
powerchecktime = nil
oldpowerdrain = nil
light1use = false
light2use = false
light1usewait = false
light2usewait = false
powertot = GM.Power_Max
finishedweek = 0
usingsafedoor = {}
debugmode = false
foxyknockdoorpena = 2
addfoxyknockdoorpena = 4
tempostart = false
overfive = false
mute = true
fnafview = false
fnafviewactive = false


if !file.IsDir("fnafgm", "DATA") then
	file.CreateDir( "fnafgm" )
end


local Timestamp = os.time()
if (os.date( "%d/%m" , Timestamp )=="01/04") then --SeasonalEvents
	AprilFool = true
	seasonaltext = " - April Fool"
elseif (os.date( "%d/%m" , Timestamp )=="31/10") then --SeasonalEvents
	Halloween = true
	seasonaltext = " - Halloween"
end


if (game.GetMap()=="freddysnoevent") then
	SGvsA=true
	modetext = " - PvP SGvsA"
end


if GetHostName()=="1987" then --Not a easter egg ^^
	AprilFool = false
	Halloween = false
	SGvsA = false
	b87 = true
	modetext = " - '87"
end


function fnafgmrefreshbypass()
	
	if SERVER then
		MsgC( Color( 255, 255, 85 ), "FNAFGM: Checking bypasses...\n" )
		local files, dir = file.Find("fnafgm/groups/" .. "*", "DATA")
		table.Empty(listgroup)
		for k, v in pairs(files) do
			listgroup["group_"..string.StripExtension(v)] = string.Explode( "|", file.Read("fnafgm/groups/"..v, "DATA") )
		end
		if table.Count(listgroup)==0 then
			MsgC( Color( 255, 255, 85 ), "FNAFGM: No bypasses detected!\n" )
		else
			PrintTable(listgroup)
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Bypasses checked!\n" )
		end
	end
	
end
fnafgmrefreshbypass()


function GM:CreateTeams()
	
	team.SetUp( 1, GAMEMODE.Strings.base.sg, GAMEMODE.Colors_sg )
	team.SetClass(1, { "player_fnafgmsecurityguard" } )
	if game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent" or game.GetMap()=="fnaf2" then
		team.SetSpawnPoint( 1, { "info_player_terrorist" } )
	elseif game.GetMap()=="fnaf_freddypizzaevents" then
		team.SetSpawnPoint( 1, { "info_player_deathmatch" } )
	else
		team.SetSpawnPoint( 1, GAMEMODE.Spawns_sg )
	end
	
	team.SetUp( 2, GAMEMODE.Strings.base.animatronics, GAMEMODE.Colors_animatronics )
	team.SetClass(2, { "player_fnafgmfoxy", "player_fnafgmfreddy", "player_fnafgmbonnie", "player_fnafgmchica" }, SGvsA)
	team.SetSpawnPoint( 2, GAMEMODE.Spawns_animatronics )
	
	team.SetUp(TEAM_SPECTATOR, GAMEMODE.Strings.base.spectator, Color(128, 128, 128))
	
	team.SetUp(TEAM_UNASSIGNED, "Unassigned", Color(128, 128, 128), false)
	
end


function fnafgmcheckcreator(pl) --To easly debug others servers and credit
	if (pl:SteamID()=="STEAM_0:1:18280147" or pl:SteamID()=="STEAM_0:1:35715092" or pl:SteamID()=="STEAM_0:1:51964687") then
		return true
	end
	return false
end


function GM:CheckDerivCreator(pl) --To credit you when you are detected
	return false
end


function fnafgmcustomcheck(pl,what) --Custom groups funcs
	
	if listgroup["group_"..pl:GetUserGroup()] and table.HasValue(listgroup["group_"..pl:GetUserGroup()], what) then
		return true
	end
	
	return false
	
end


function CheckPlayerSecurityRoom(ply)
	
	if (GAMEMODE.SecurityRoom[game.GetMap()]) then
		local BoxCorner = GAMEMODE.SecurityRoom[game.GetMap()][1]
		local OppositeCorner = GAMEMODE.SecurityRoom[game.GetMap()][2]
		local PlayersInArea = ents.FindInBox(BoxCorner,OppositeCorner)
		if table.HasValue(PlayersInArea, ply) then return true end
		if GAMEMODE.SecurityRoom[game.GetMap()][3] then
			local BoxCorner = GAMEMODE.SecurityRoom[game.GetMap()][3]
			local OppositeCorner = GAMEMODE.SecurityRoom[game.GetMap()][4]
			local PlayersInArea = ents.FindInBox(BoxCorner,OppositeCorner)
			if table.HasValue(PlayersInArea, ply) then return true end
		end
		return false
	else
		return nil
	end
	
end


function CheckPlayerHallways(ply)
	
	if (GAMEMODE.Hallways[game.GetMap()]) then
		local BoxCorner = GAMEMODE.Hallways[game.GetMap()][1]
		local OppositeCorner = GAMEMODE.Hallways[game.GetMap()][2]
		local PlayersInArea = ents.FindInBox(BoxCorner,OppositeCorner)
		if table.HasValue(PlayersInArea, ply) then return true end
		if GAMEMODE.Hallways[game.GetMap()][3] then
			local BoxCorner = GAMEMODE.Hallways[game.GetMap()][3]
			local OppositeCorner = GAMEMODE.Hallways[game.GetMap()][4]
			local PlayersInArea = ents.FindInBox(BoxCorner,OppositeCorner)
			if table.HasValue(PlayersInArea, ply) then return true end
		end
		return false
	else
		return nil
	end
	
end


function CheckFreddyTrigger(ply)
	
	if (GAMEMODE.DoorFreddy[game.GetMap()]) then
		local BoxCorner = GAMEMODE.DoorFreddy[game.GetMap()][1]
		local OppositeCorner = GAMEMODE.DoorFreddy[game.GetMap()][2]
		local PlayersInArea = ents.FindInBox(BoxCorner,OppositeCorner)
		if table.HasValue(PlayersInArea, ply) then return true end
		return false
	else
		return nil
	end
	
end


function CheckBonnieTrigger(ply)
	
	if (GAMEMODE.DoorBonnie[game.GetMap()]) then
		local BoxCorner = GAMEMODE.DoorBonnie[game.GetMap()][1]
		local OppositeCorner = GAMEMODE.DoorBonnie[game.GetMap()][2]
		local PlayersInArea = ents.FindInBox(BoxCorner,OppositeCorner)
		if table.HasValue(PlayersInArea, ply) then return true end
		return false
	else
		return nil
	end
	
end


function CheckChicaTrigger(ply)
	
	if (GAMEMODE.DoorChica[game.GetMap()]) then
		local BoxCorner = GAMEMODE.DoorChica[game.GetMap()][1]
		local OppositeCorner = GAMEMODE.DoorChica[game.GetMap()][2]
		local PlayersInArea = ents.FindInBox(BoxCorner,OppositeCorner)
		if table.HasValue(PlayersInArea, ply) then return true end
		return false
	else
		return nil
	end
	
end


function GM:GrabEarAnimation( ply )
	
	if ply:Team()==2 then return end
	
	ply.ChatGestureWeight = ply.ChatGestureWeight or 0

	if ( ply:IsPlayingTaunt() ) then return end

	if ( ply:IsTyping() ) then
		ply.ChatGestureWeight = math.Approach( ply.ChatGestureWeight, 1, FrameTime() * 5.0 )
	else
		ply.ChatGestureWeight = math.Approach( ply.ChatGestureWeight, 0, FrameTime() * 5.0 )
	end

	if ( ply.ChatGestureWeight > 0 ) then
	
		ply:AnimRestartGesture( GESTURE_SLOT_VCD, ACT_GMOD_IN_CHAT, true )
		ply:AnimSetGestureWeight( GESTURE_SLOT_VCD, ply.ChatGestureWeight )
	
	end

end


function GM:CalcMainActivity( ply, velocity )

	if ply:Team()!=2 then
	
		ply.CalcIdeal = ACT_MP_STAND_IDLE
		ply.CalcSeqOverride = -1
	
		self:HandlePlayerLanding( ply, velocity, ply.m_bWasOnGround )
	
		if ( self:HandlePlayerNoClipping( ply, velocity ) ||
			self:HandlePlayerDriving( ply ) ||
			self:HandlePlayerVaulting( ply, velocity ) ||
			self:HandlePlayerJumping( ply, velocity ) ||
			self:HandlePlayerDucking( ply, velocity ) ||
			self:HandlePlayerSwimming( ply, velocity ) ) then
	
		else
	
			local len2d = velocity:Length2D()
			if ( len2d > 150 ) then ply.CalcIdeal = ACT_MP_RUN elseif ( len2d > 0.5 ) then ply.CalcIdeal = ACT_MP_WALK end
	
		end
	
		ply.m_bWasOnGround = ply:IsOnGround()
		ply.m_bWasNoclipping = ( ply:GetMoveType() == MOVETYPE_NOCLIP && !ply:InVehicle() )
	
		return ply.CalcIdeal, ply.CalcSeqOverride
		
	else
		
		ply.CalcIdeal = ACT_MP_STAND_IDLE
		ply.CalcSeqOverride = -1
		
		local len2d = velocity:Length2D()
		if ( len2d > 150 ) then ply.CalcIdeal = ACT_MP_RUN elseif ( len2d > 0.5 ) then ply.CalcIdeal = ACT_MP_WALK end
	
		ply.m_bWasOnGround = ply:IsOnGround()
		ply.m_bWasNoclipping = ( ply:GetMoveType() == MOVETYPE_NOCLIP && !ply:InVehicle() )
	
		return ply.CalcIdeal, ply.CalcSeqOverride
		
	end

end


function GM:Move( ply, mv )

	if CLIENT and fnafviewactive then return true end
	
	if SERVER and ply.fnafviewactive then return true end
	
	if CLIENT and ply:Team()==2 and player_manager.GetPlayerClass(ply)!="player_fnafgmfoxy" and avisible then return true end
	
	if SERVER and ply:Team()==2 and player_manager.GetPlayerClass(ply)!="player_fnafgmfoxy" and avisible[ply] then return true end
	
	if ( drive.Move( ply, mv ) ) then return true end
	
	if ( player_manager.RunClass( ply, "Move", mv ) ) then return true end
	
	return false

end


function GM:FinishMove( ply, mv )
	
	if CLIENT and fnafviewactive then return true end
	
	if SERVER and ply.fnafviewactive then return true end
	
	if CLIENT and ply:Team()==2 and player_manager.GetPlayerClass(ply)!="player_fnafgmfoxy" and avisible then return true end
	
	if SERVER and ply:Team()==2 and player_manager.GetPlayerClass(ply)!="player_fnafgmfoxy" and avisible[ply] then return true end
	
	if ( drive.FinishMove( ply, mv ) ) then return true end
	if ( player_manager.RunClass( ply, "FinishMove", mv ) ) then return true end
	
end


function fnafgmFNaFView(ply)
	
	fnafview = true
	
	if SERVER then 
		if GAMEMODE.FNaFView[game.GetMap()] then
			if GAMEMODE.FNaFView[game.GetMap()][1] then ply:SetPos( GAMEMODE.FNaFView[game.GetMap()][1] ) end
			if GAMEMODE.FNaFView[game.GetMap()][2] then ply:SetEyeAngles( GAMEMODE.FNaFView[game.GetMap()][2] ) end
			ply:SendLua([[fnafgmFNaFView()]])
		end
	end
	
	if CLIENT then
		fnafgmFNaFViewHUD()
	end
	
end

