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
GM.Website 	= "go.Xperidia.com/FNAFGM"
GM.OfficialVersion 	= 1.172
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
GM.Sound_end = {
	freddys = Sound("fnafgm/end.ogg"),
	fnaf2 = Sound("fnafgm/end2.ogg")
}
GM.Sound_Foxy = Sound("fnafgm/piratesong2.ogg")
GM.Sound_ChicaBonnie = { Sound("fnafgm/cb1.ogg"), Sound("fnafgm/cb2.ogg"), Sound("fnafgm/cb3.ogg"), Sound("fnafgm/cb4.ogg") }
GM.Sound_Freddy = { Sound("fnafgm/freddy1.ogg"), Sound("fnafgm/freddy2.ogg"), Sound("fnafgm/freddy3.ogg") }
GM.Sound_GoldenFoxy = Sound("fnafgm/goldenfreddy.ogg")
GM.Sound_Calls = {
	freddys = { "fnafgm/voiceover1.ogg", "fnafgm/voiceover2.ogg", "fnafgm/voiceover3.ogg", "fnafgm/voiceover4.ogg", "fnafgm/voiceover5.ogg" }
}
GM.Sound_maskon = Sound("fnafgm/maskon.ogg")
GM.Sound_maskoff = Sound("fnafgm/maskoff.ogg")

GM.TranslatedStrings = {}

GM.Strings = {
	en = {
		sg = "Security guards",
		animatronics = "Animatronics",
		animatronic = "Animatronic",
		tonight = "To Night",
		night = "Night",
		freddys = "Turn off the main power to start the night",
		fnaf2 = "Turn on the %s to start the night",
		fnaf_freddypizzaevents = "Type !start to start the map",
		startanimatronics = "The main power is on",
		foxy = "Foxy",
		freddy = "Freddy",
		chica = "Chica",
		bonnie = "Bonnie",
		goldenfreddy = "Golden Freddy",
		unassigned_SGvsA = "Choose a team",
		powerleft = "Power left:",
		usage = "Usage:",
		unassigned_powerdown = "You can't join when the power is down!",
		flashlight = "flashlight",
		monitor = "Monitor",
		monitor_inst = "Right click to open the Monitor. Left click to use buttons. Reload to enter FNaF view.",
		monitor_purp = "Monitor the restaurant.",
		spectator = "Spectator",
		warn_font = "The font is not installed/up to date! Read the installation instructions in the Workshop page by pressing F1",
		warn_css = "Counter Strike: Source is not mounted. You will have missing textures and ERROR.",
		links = "Link(s)",
		fonthint = "Read installation instructions in the Workshop page\nto install the font",
		faqbtn = "Questions/Help/FAQ/Tips",
		config = "Configuration",
		hidever = "Hide version",
		dhud = "Draw HUD (Caution! This is a Garry's Mod convar)",
		infoat = "Informations/Misc",
		fontloaded = "Font loaded",
		lang = "Language",
		changemap = "Change Map",
		resetsave = "Reset save (Host only)",
		debugmenu = "Debug Menu (Debug access only)",
		start = "Start",
		stop = "Stop/Restart",
		reset = "Reset",
		autofnafview = "Auto put FNaF View",
		exitfnafview = "Exit FNaF View",
		refreshbypass = "Refresh Bypass",
		chatsound = "Chat sound",
		flashwindow = "Flashes the window on notifications (Windows only)",
		password = "Password"
	},
	fr = {
		freddys = "Coupez le courant pour démarrer la nuit",
		fnaf2 = "Activez les %s pour démarrer la nuit",
		fnaf_freddypizzaevents = "TAPPEZ !START POUR DÉMARRER",
		startanimatronics = "Le courant est allumé",
		unassigned_SGvsA = "Choisissez un camp",
		unassigned_powerdown = "Vous ne pouvez pas rejoindre quand il n'y a plus d'energie !",
		monitor = "Moniteur",
		monitor_inst = "Faites un clic droit pour ouvrir le Moniteur. Faites un clic gauche pour utliser les boutons. Rechargez pour entrer en vue FNaF.",
		monitor_purp = "Surveiller le restaurant.",
		spectator = "Spectateur",
		warn_font = "La police n'est pas installée/à jour! Lisez les instructions d'installation sur la page Workshop en appuyant sur F1",
		warn_css = "Counter Strike: Source n'est pas monté. Vous aurez des textures manquantes et des ERROR.",
		links = "Lien(s)",
		faqbtn = "Questions/Aide/FAQ/Astuces",
		fonthint = "Lisez les instructions d'installation sur la page Workshop\npour installer la police",
		hidever = "Masquer la version",
		dhud = "Dessiner l'HUD (Attention ! Paramètre de Garry's Mod)",
		infoat = "Informations/Divers",
		fontloaded = "Police installée",
		lang = "Langage",
		changemap = "Changer de Map",
		resetsave = "Effacer la sauvegarde (Hôte uniquement)",
		debugmenu = "Menu Debug (Accès debug uniquement)",
		start = "Démarrer",
		stop = "Arrêter/Redémarrer",
		reset = "Rénitialiser",
		autofnafview = "Activer automatiquement la vue FNaF",
		exitfnafview = "Quitter la vue FNaF",
		refreshbypass = "Recharger les Bypass",
		chatsound = "Sons du chat",
		flashwindow = "Activer l'alerte fenêtre (Windows uniquement)",
		password = "Mot de passe"
	},
	tr = { --Translation by http://steamcommunity.com/profiles/76561198118981905/
		animatronics = "Animasyoncuları",
		freddys = "Ana gücü kapatarak başlayın",
		fnaf2 = "%s açarak başlayın",
		fnaf_freddypizzaevents = "!start Yazarak oyunu başlatın",
		startanimatronics = "Ana güç açık",
		unassigned_normal = "Herhangi bir tuşa basarak oyuna girin",
		unassigned_SGvsA = "TAKIM SEÇİN",
		unassigned_powerdown = "Güç kapalıyken giremezsin!",
		monitor = "Ekran",
		monitor_inst = "Sağ Tıklayarak Ekranı Açın. Sol Tıklayarak Düğmeleri Kullanın. Silah doldurma tuşu ile Fnaf görüşüne geçin.",
		monitor_purp = "Restoranı İzleyin.",
		spectator = "İzleyici",
		warn_font = "Font yüklenmedi/En Son sürüm değil! Yükleme adımlarını Atölye sayfasından yada F1 e basarak Görebilirsiniz",
		warn_css = "Counter Strike: Source Oyunda Doğrulanmadı. Kayıp texture ve HATALARIN Var.",
		fonthint = "Yükleme adımlarını Atölye sayfasında okuyabilirsiniz\nFont yüklenmemiş.",
		faqbtn = "Sorular/Yardım/FAQ/İpuçları",
		config = "Ayarlar",
		hidever = "Versionu Gizle",
		dhud = "HUD u göster (Uyarı! Bu Garry's mod HUD u)",
		infoat = "Bilgiler/Misc",
		fontloaded = "Font Yüklendi",
		lang = "Dil",
		changemap = "Haritayı Değiştir",
		resetsave = "Kaydı Sil (Sadece Serveri Yapan)",
		debugmenu = "Debug Menüsü (Sadece Debug yapma İzni olan)",
		start = "Başla",
		stop = "Dur/Tekrar Başlat",
		autofnafview = "Otamatik Fnaf görüşü",
		exitfnafview = "Fnaf Görüşünden Çık"
	}

}

function fnafgmLoadLanguage(lang)
	
	if lang!="" and GAMEMODE.Strings[lang] then
		--table.Merge( GAMEMODE.TranslatedStrings, GAMEMODE.Strings[lang] )
		GAMEMODE.TranslatedStrings = GAMEMODE.Strings[lang]
		MsgC( Color( 255, 255, 85 ), "FNAFGM: '"..lang.."' strings loaded!\n" )
	elseif lang!="" then
		--table.Merge( GAMEMODE.TranslatedStrings, GAMEMODE.Strings["en"] )
		table.Empty(GAMEMODE.TranslatedStrings)
		MsgC( Color( 255, 255, 85 ), "FNAFGM: '"..lang.."' is not supported! Default strings loaded! If you want to do a translation, please go here: http://steamcommunity.com/workshop/filedetails/discussion/408243366/523897653295354408/\n" )
	end
	
end

GM.Spawns_sg = { "info_player_start", "info_player_terrorist" }
GM.Spawns_animatronics = { "info_player_counterterrorist" }

GM.SecurityRoom = {
	freddys = { Vector(-160,-1275,60), Vector(0,-1058,170) },
	freddysnoevent = { Vector(-160,-1275,60), Vector(0,-1058,170) },
	fnaf2 = { Vector(138,-340,190), Vector(-138,128,0) },
	fnaf_freddypizzaevents = { Vector(-325,1765,125), Vector(-623,2095,0) },
	fnaf3 = { Vector(-174,-178,190), Vector(174,-342,65) },
	fnaf4house = { Vector(-756,125,128), Vector(-514,-190,0) },
	fnaf4noclips = { Vector(-756,125,128), Vector(-514,-190,0) }
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
	fnaf_freddypizzaevents = { Vector(329, 654, 64) }
}

GM.FNaFView = {
	freddys = { Vector( -80, -1224, 64 ), Angle( 0, 90, 0 ), Angle( 0, 136, 0 ), Angle( 0, 44, 0 ) },
	freddysnoevent = { Vector( -80, -1224, 64 ), Angle( 0, 90, 0 ), Angle( 0, 136, 0 ), Angle( 0, 44, 0 ) },
	fnaf2 = { Vector( 0, -300, 0 ), Angle( 0, 90, 0 ), Angle( 0, 136, 0 ), Angle( 0, 44, 0 ) },
	fnaf3 = { Vector( 14, -300, 64 ), Angle( 0, 90, 0 ), Angle( 0, 140, 0 ), Angle( 0, 80, 0 ) }
}

GM.Materials_static = "fnafgm/static"
GM.Materials_camstatic = "fnafgm/camstatic"
GM.Materials_goldenfreddy = "fnafgm/goldenfreddy"
GM.Materials_animatronicsvision = "effects/combine_binocoverlay"
GM.Materials_mapfreddys = "fnafgm/mapfreddys"
GM.Materials_mapfnaf2 = "fnafgm/mapfnaf2"
GM.Materials_usage = "fnafgm/usage_"
GM.Materials_battery = "fnafgm/battery_"
GM.Materials_intro = {
	freddys = { en = "fnafgm/intro" },
	freddysnoevent = { en = "fnafgm/intro" },
	fnaf2 = { en = "fnafgm/introfnaf2" }
}
GM.Materials_end = {
	freddys = { "fnafgm/end", "fnafgm/end6" },
	fnaf2 = { "fnafgm/endfnaf2", "fnafgm/endfnaf2_6" }
}
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
	fnaf2_12 = "Show Stage"
}

GM.MapList = {
	freddys = "FNaF 1",
	freddysnoevent = "SGvsA",
	fnaf2 = "FNaF 2",
	fnaf3 = "FNaF 3",
	fnaf4house = "FNaF 4",
	fnaf4noclips = "FNaF 4 NC",
	fnaf4versus = "FNaF 4 PvP",
	fnaf_freddypizzaevents = "FNaF Mix"
}

GM.MapListLinks = {
	freddys = "http://steamcommunity.com/sharedfiles/filedetails/?id=300674206",
	freddysnoevent = "http://steamcommunity.com/sharedfiles/filedetails/?id=311282498",
	fnaf2 = "http://steamcommunity.com/sharedfiles/filedetails/?id=382153719",
	fnaf3 = "http://steamcommunity.com/sharedfiles/filedetails/?id=409285826",
	fnaf4house = "http://steamcommunity.com/sharedfiles/filedetails/?id=493003146",
	fnaf4noclips = "http://steamcommunity.com/sharedfiles/filedetails/?id=493003146",
	fnaf4versus = "http://steamcommunity.com/sharedfiles/filedetails/?id=493003146",
	fnaf_freddypizzaevents = "http://steamcommunity.com/sharedfiles/filedetails/?id=410244396"
}


function GM:Initialize()

	fnafgmLoadLanguage(GetConVarString("gmod_language"))
	
	cvars.AddChangeCallback( "gmod_language", function( convar_name, value_old, value_new )
		fnafgmLoadLanguage(value_new)
	end)
	
	startday = false
	gameend = false
	iniok = false
	time = GAMEMODE.TimeBase
	AMPM = GAMEMODE.AMPM
	night = GAMEMODE.NightBase
	nightpassed = false
	tempostart = false
	mute = true
	overfive = false
	power = 0
	powerusage = GAMEMODE.Power_Usage_Base
	powertot = GAMEMODE.Power_Max
	poweroff = false
	SGvsA = false
	AprilFool = false
	Halloween = false
	b87 = false
	seasonaltext = ""
	modetext = ""
	fnafview = false
	fnafviewactive = false
	fnafgmWorkShop = false
	lastversion = 0
	lastderivversion = 0
	
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
	
	
	if (game.GetMap()=="freddysnoevent" or game.GetMap()=="fnaf4versus") then
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
	
	
	for _, addon in pairs(engine.GetAddons()) do
		
		if addon.wsid == "408243366" and addon.mounted then
			fnafgmWorkShop = true
		end
		
	end
	
	if SERVER then
		
		hourtime = GAMEMODE.HourTime
		mapoverrideok = false
		norespawn = false
		active = false
		updateavailable = false
		derivupdateavailable = false
		listgroup = {}
		avisible = {}
		powerdrain = GAMEMODE.Power_Drain_Time
		tabused = {}
		powerchecktime = nil
		oldpowerdrain = nil
		LightUse = {}
		DoorClosed = {}
		light1usewait = false
		light2usewait = false
		finishedweek = 0
		usingsafedoor = {}
		foxyknockdoorpena = 2
		addfoxyknockdoorpena = 4
		checkRestartNight = false
		
		if !game.SinglePlayer() then
			timer.Create( "fnafgmAutoCleanUp", 5, 0, fnafgmAutoCleanUp)
		end
		
		timer.Create( "fnafgmCheckForNewVersion", 21600, 0, fnafgmCheckForNewVersion)
		
		fnafgmrefreshbypass()
		
		if !game.IsDedicated() and !SGvsA then
			
			local file = file.Read( "fnafgm/progress/" .. game.GetMap() .. ".txt" )
			
			if ( file ) then
			
				local tab = util.JSONToTable( file )
				if ( tab ) then
					if ( tab.Night ) then night = tab.Night end
					MsgC( Color( 255, 255, 85 ), "FNAFGM: Progression loaded!\n" )
				end
				
			end
			
		end
	
	end
	
	
	
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


function GM:CreateTeams()
	
	team.SetUp( 1, tostring(GAMEMODE.TranslatedStrings.sg or GAMEMODE.Strings.en.sg), GAMEMODE.Colors_sg )
	team.SetClass(1, { "player_fnafgmsecurityguard" } )
	if game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent" or game.GetMap()=="fnaf2" then
		team.SetSpawnPoint( 1, { "info_player_terrorist" } )
	elseif game.GetMap()=="fnaf_freddypizzaevents" then
		team.SetSpawnPoint( 1, { "info_player_deathmatch" } )
	else
		team.SetSpawnPoint( 1, GAMEMODE.Spawns_sg )
	end
	
	team.SetUp( 2, tostring(GAMEMODE.TranslatedStrings.animatronics or GAMEMODE.Strings.en.animatronics), GAMEMODE.Colors_animatronics )
	team.SetClass(2, { "player_fnafgmfoxy", "player_fnafgmfreddy", "player_fnafgmbonnie", "player_fnafgmchica" }, SGvsA)
	team.SetSpawnPoint( 2, GAMEMODE.Spawns_animatronics )
	
	team.SetUp(TEAM_SPECTATOR, tostring(GAMEMODE.TranslatedStrings.spectator or GAMEMODE.Strings.en.spectator), Color(128, 128, 128))
	
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

