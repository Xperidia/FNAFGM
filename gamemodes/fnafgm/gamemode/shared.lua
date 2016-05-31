DEFINE_BASECLASS( "gamemode_base" )

include( "player_class/player_securityguard.lua" )
include( "player_class/player_animatronic_controller.lua" )

GM.Name 	= "Five Nights at Freddy's"
GM.ShortName = "FNAFGM"
GM.Author 	= "Xperidia"
GM.Email 	= "contact@Xperidia.com"
GM.Website 	= "go.Xperidia.com/FNAFGM"
GM.OfficialVersion 	= 2.04
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
GM.IsFNAFGMDerived = true

GM.FT = 1

if game.GetMap()=="fnaf2noevents" then
	GM.FT = 2
elseif game.GetMap()=="fnaf3" then
	GM.FT = 3
elseif game.GetMap()=="fnaf4house" or game.GetMap()=="fnaf4noclips" or game.GetMap()=="fnaf4versus" then
	GM.FT = 4
end

--[[ Gamemode constants for derivations ]]--
GM.TimeBase = 12
GM.TimeEnd = 6
GM.AMPM = "AM"
GM.AMPM_End = "AM"
GM.NightBase = 0
GM.NightEnd = 5
GM.HourTime = 86
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
GM.Sound_foxystep = Sound("fnafgm/run.ogg")
GM.Sound_foxyknock = Sound("fnafgm/knock.ogg")
GM.Sound_securitycampop = Sound("fnafgm/monitoron.ogg")
GM.Sound_securitycamdown = Sound("fnafgm/camdown.ogg")
GM.Sound_securitycampop2 = Sound("fnafgm/monitoron2.ogg")
GM.Sound_securitycamdown2 = Sound("fnafgm/monitoroff2.ogg")
GM.Sound_securitycampop3 = Sound("fnafgm/monitoron3.ogg")
GM.Sound_securitycamdown3 = Sound("fnafgm/monitoroff3.ogg")
GM.Sound_camselect = Sound("fnafgm/camselect.ogg")
GM.Sound_lighterror = Sound("fnafgm/lighterror.ogg")
GM.Sound_end = {
	freddysnoevent = Sound("fnafgm/end.ogg"),
	fnaf2noevents = Sound("fnafgm/end2.ogg")
}
GM.Sound_Animatronic = {}
GM.Sound_Animatronic[0] = { Sound("fnafgm/freddy1.ogg"), Sound("fnafgm/freddy2.ogg"), Sound("fnafgm/freddy3.ogg") }
GM.Sound_Animatronic[1] = { Sound("fnafgm/cb1.ogg"), Sound("fnafgm/cb2.ogg"), Sound("fnafgm/cb3.ogg"), Sound("fnafgm/cb4.ogg") }
GM.Sound_Animatronic[2] = { Sound("fnafgm/cb1.ogg"), Sound("fnafgm/cb2.ogg"), Sound("fnafgm/cb3.ogg"), Sound("fnafgm/cb4.ogg") }
GM.Sound_Animatronic[3] = { Sound("fnafgm/piratesong2.ogg") }
GM.Sound_Animatronic[4] = { Sound("fnafgm/goldenfreddy.ogg") }

GM.Sound_Calls = {
	freddysnoevent = { "fnafgm/voiceover1.ogg", "fnafgm/voiceover2.ogg", "fnafgm/voiceover3.ogg", "fnafgm/voiceover4.ogg", "fnafgm/voiceover5.ogg" }
}
GM.Sound_maskon = Sound("fnafgm/maskon.ogg")
GM.Sound_maskoff = Sound("fnafgm/maskoff.ogg")
GM.Sound_windowscare = Sound("fnafgm/windowscare.ogg")

GM.TranslatedStrings = {}

GM.Strings = {
	en = {
		sg = "Security guards",
		animatronics = "Animatronics",
		animatronic = "Animatronic",
		tonight = "To Night",
		night = "Night",
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
		warn_css = "Counter Strike: Source is not mounted. You will have missing textures and ERROR.",
		links = "Link(s)",
		faqbtn = "FAQ",
		config = "Configuration",
		hidever = "Hide version",
		dhud = "Draw HUD (Caution! This is a Garry's Mod convar)",
		infoat = "Informations/Misc",
		lang = "Language",
		changemap = "Change Map",
		resetsave = "Reset save",
		debugmenu = "Debug Menu (Debug access only)",
		start = "Start",
		stop = "Stop/Restart",
		reset = "Reset",
		autofnafview = "Auto put FNaF View",
		exitfnafview = "Exit FNaF View",
		refreshbypass = "Refresh Bypass",
		chatsound = "Chat sound",
		flashwindow = "Flashes the window on notifications (Windows only)",
		password = "Password",
		saveserver = "Save your own progress on servers",
		progressinfo = "Last saved night",
		disablexpsc = "Disable Xperidia's Show Case",
		disablehalo = "Disable halos (Improve performance)",
		nightwillstart = "The night will start in",
		togglesgvsa = "Toggle SGvsA",
		now_sgvsa = "The game is now in PvP SGvsA mode!",
		now_normal = "The game is now in normal mode!",
		nosp = "Not in singleplayer!",
		nosg = "There is no security guards!",
		gamebeenreset = "The game has been reset!",
		notsgvsa = "You're not in SGvsA mode!"
	},
	fr = {
		tonight = "Vers la nuit",
		startanimatronics = "Le courant est allumé",
		unassigned_SGvsA = "Choisissez un camp",
		unassigned_powerdown = "Vous ne pouvez pas rejoindre quand il n'y a plus d'energie !",
		monitor = "Moniteur",
		monitor_inst = "Faites un clic droit pour ouvrir le Moniteur. Faites un clic gauche pour utliser les boutons. Rechargez pour entrer en vue FNaF.",
		monitor_purp = "Surveiller le restaurant.",
		spectator = "Spectateur",
		warn_css = "Counter Strike: Source n'est pas monté. Vous aurez des textures manquantes et des ERROR.",
		links = "Lien(s)",
		faqbtn = "FAQ",
		hidever = "Masquer la version",
		dhud = "Dessiner l'HUD (Attention ! Paramètre de Garry's Mod)",
		infoat = "Informations/Divers",
		lang = "Langage",
		changemap = "Changer de Map",
		resetsave = "Effacer la sauvegarde",
		debugmenu = "Menu Debug (Accès debug uniquement)",
		start = "Démarrer",
		stop = "Arrêter/Redémarrer",
		reset = "Rénitialiser",
		autofnafview = "Activer automatiquement la vue FNaF",
		exitfnafview = "Quitter la vue FNaF",
		refreshbypass = "Recharger les Bypass",
		chatsound = "Sons du chat",
		flashwindow = "Activer l'alerte fenêtre (Windows uniquement)",
		password = "Mot de passe",
		saveserver = "Sauvegarde de la progression sur les serveurs",
		progressinfo = "Dernière nuit sauvegardée ",
		disablexpsc = "Désactiver Xperidia's Show Case",
		disablehalo = "Désactiver les halos (Améliore la performance)",
		nightwillstart = "La nuit va démarrer dans",
		togglesgvsa = "Activer/Désactiver SGvsA",
		now_sgvsa = "Le jeu est désormais en mode PvP SGvsA !",
		now_normal = "Le jeu est désormais en mode normal !",
		nosp = "Pas en solo !",
		nosg = "Il n'y a pas de gardes de sécurité !",
		gamebeenreset = "Le jeu a été réinitialisé !",
		notsgvsa = "Le jeu n'est pas en mode SGvsA !"
	},
	tr = { --Translation by http://steamcommunity.com/profiles/76561198118981905/
		sg = "Güvenlik Görevlileri",
		animatronics = "Animasyoncular",
		animatronic = "Animasyoncu",
		tonight = "Bu Gece",
		--night = "Gece",
		startanimatronics = "Ana güç açýk",
		unassigned_SGvsA = "Takým seçin",
		powerleft = "Kalan güç:",
		usage = "Kullanýlan:",
		unassigned_powerdown = "Güç kapalýyken oyuna katýlamassýn!",
		flashlight = "El feneri",
		monitor = "Monitör",
		monitor_inst = "Sað týkla monitörü açýn.Sol týkla düðmelere basýn.Cephane yenileme tuþuna basarak FNaF Görüþüne geçin.",
		monitor_purp = "Restoraný izleyin.",
		spectator = "Ýzleyici",
		warn_css = "Counter Strike: Source yüklenmedi ya da seçilmedi.Haritada HATA ve Bulunamayan Texturelar var.",
		links = "Link(ler)",
		faqbtn = "Yardým",
		config = "Yapýlandýrma",
		hidever = "Versiyonu gizle",
		dhud = "HUD'ý göster",
		infoat = "Bilgiler/Çeþitli",
		lang = "Dil",
		changemap = "Harita deðiþtir",
		resetsave = "Kaydý sýfýrla",
		debugmenu = "Hata ayýklama Menüsü (sadece izinliler)",
		start = "Baþla",
		stop = "Durdur/Baþtan",
		reset = "Baþtan",
		autofnafview = "Otomatik FNaF görüþüne geç",
		exitfnafview = "FNaF görüþünden çýk",
		chatsound = "Konuþma sesleri",
		password = "Þifre",
		saveserver = "Yaptýðýnýz ilerlemeyi kaydedin",
		progressinfo = "Son kaydedilmiþ gece",
		disablexpsc = "Xperidia'nýn Vitrinini kapatýn"
	},
	ru = { --Translation by http://steamcommunity.com/profiles/76561198135819236 and http://steamcommunity.com/profiles/76561198146926505
		sg = "Охранники",
		animatronics = "Аниматроники",
		animatronic = "Аниматроник",
		tonight = "На ночь",
		--night = "Ночь",
		startanimatronics = "Главное питание включено",
		foxy = "Фокси",
		freddy = "Фредди",
		chica = "Чика",
		bonnie = "Бонни",
		goldenfreddy = "Золотой Фредди",
		unassigned_SGvsA = "Выберите команду",
		--powerleft = "Энергии осталось:",
		--usage = "Используется:",
		unassigned_powerdown = "Вы не можете присоединиться, если энергии нет!",
		flashlight = "Фонарик",
		monitor = "Монитор",
		monitor_inst = "Щелкните правой кнопкой мыши, чтобы открыть монитор. Щелкните левой кнопкой мыши, чтобы использовать кнопки. Перезарядитесь, чтобы войти в ФНаФ вид.",
		monitor_purp = "Контролируйте ресторан.",
		spectator = "Зритель",
		warn_css = "Counter-Strike: Source не установлен. Вы будете иметь недостающие текстуры и ERRORы.",
		links = "Ссылка(и)",
		faqbtn = "ЧАВО",
		config = "Конфиг",
		hidever = "Скрыть версию",
		dhud = "Показать HUD",
		infoat = "Информация/Разное",
		lang = "Язык",
		changemap = "Сменить Карту",
		resetsave = "Сброс сохранения",
		debugmenu = "Меню Отладки (токо доступ отладчика)",
		start = "Старт",
		stop = "Стоп/Перезапуск",
		reset = "Сброс",
		autofnafview = "Автоматом ставить ФНаФ Вид",
		exitfnafview = "Выйти из ФНаФ Вида",
		refreshbypass = "Обновить Байпас",
		chatsound = "Звук Чата",
		flashwindow = "Высвечивать окно уведомлениями (токо Windows)",
		password = "Пароль",
		saveserver = "Сохранять свой прогресс на серверах",
		progressinfo = "Последния сохраненная ночь",
		disablexpsc = "Отключить витрину Xperidia",
		disablehalo = "Отключить ореолы (Повышает производительность)"
	},
	uk = { --Translation by http://steamcommunity.com/profiles/76561198135819236
		sg = "Охоронці",
		animatronics = "Аніматроніки",
		animatronic = "Аніматронік",
		tonight = "На Ніч",
		--night = "Ніч",
		startanimatronics = "Головне харчування включено",
		foxy = "Фоксі",
		freddy = "Фредді",
		chica = "Чіка",
		bonnie = "Бонні",
		goldenfreddy = "Золотий Фредді",
		unassigned_SGvsA = "Виберіть команду",
		--powerleft = "Енергії залишилося:",
		--usage = "Використовується:",
		unassigned_powerdown = "Ви не можете приєднатися, якщо енергії немає!",
		flashlight = "Ліхтарик",
		monitor = "Монітор",
		monitor_inst = "Клацніть правою кнопкою миші, щоб відкрити монітор. Клацніть лівою кнопкою миші, щоб використовувати кнопки. Перезарядитесь, щоб увійти в ФНаФ вигляд.",
		monitor_purp = "Контролюйте ресторан.",
		spectator = "Глядач",
		warn_css = "Counter-Strike: Source не встановлено. Ви будете мати відсутні текстури і ERRORы.",
		links = "Посилання",
		faqbtn = "Питання",
		config = "Конфіг",
		hidever = "Приховати версію",
		dhud = "Показати HUD",
		infoat = "Інформація/Різне",
		lang = "Мова",
		changemap = "Змінити Карту",
		resetsave = "Скидання збереження",
		debugmenu = "Меню Налагодження (тільки Дебаг доступ)",
		start = "Старт",
		stop = "Стоп/Перезапуск",
		reset = "Скидання",
		autofnafview = "Автоматично ставити ФНаФ Вигляд",
		exitfnafview = "Вийти з ФНаФ Виду",
		refreshbypass = "Оновити Байпас",
		chatsound = "Звук Чату",
		flashwindow = "Висвічувати вікно повідомленнями (тільки Windows)",
		password = "Пароль",
		saveserver = "Зберігати свій прогрес на серверах",
		progressinfo = "Остання збережена ніч"
	}
}

function GM:LoadLanguage(lang)
	
	if lang!="" and GAMEMODE.Strings[lang] then
		GAMEMODE.TranslatedStrings = GAMEMODE.Strings[lang]
		GAMEMODE:Log("'"..lang.."' strings loaded!")
	elseif lang!="" then
		table.Empty(GAMEMODE.TranslatedStrings)
		GAMEMODE:Log("'"..lang.."' is not supported! Default strings loaded! If you want to do a translation, please go here: http://steamcommunity.com/workshop/filedetails/discussion/408243366/523897653295354408/")
	end
	
end

GM.Spawns_sg = { "info_player_start", "info_player_terrorist" }
GM.Spawns_animatronics = { "info_player_counterterrorist", "fnafgm_teamanimatronics_start" }

GM.SecurityRoom = {
	freddysnoevent = { Vector(-160,-1275,60), Vector(0,-1058,170) },
	fnaf2noevents = { Vector(-138,-340,0), Vector(138,128,190) },
	fnaf3 = { Vector(-174,-342,65), Vector(174,-178,190) },
	fnaf4house = { Vector(-756,-190,0), Vector(-514,125,128) },
	fnaf4noclips = { Vector(-756,-190,0), Vector(-514,125,128) }
}

GM.DeadBodiesTeleport = {
	freddysnoevent = { Vector(-508, -25, 92), Vector(-580, -124, 92), Vector(-500, -120, 92), Vector(-508, -192, 92) },
	fnaf2noevents = { Vector(-412, 1431, 92), Vector(-290, 1482, 92), Vector(-223, 1436, 92), Vector(-328, 1414, 92) }
}

GM.FNaFView = {
	freddysnoevent = { Vector( -80, -1224, 64 ), Angle( 0, 90, 0 ), Angle( 0, 136, 0 ), Angle( 0, 44, 0 ) },
	fnaf2noevents = { Vector( 0, -300, 0 ), Angle( 0, 90, 0 ), Angle( 0, 136, 0 ), Angle( 0, 44, 0 ) },
	fnaf3 = { Vector( 14, -300, 64 ), Angle( 0, 90, 0 ), Angle( 0, 140, 0 ), Angle( 0, 80, 0 ) }
}

GM.Materials_static = "fnafgm/overlays/static"
GM.Materials_camstatic = "fnafgm/overlays/camstatic"
GM.Materials_goldenfreddy = "fnafgm/overlays/goldenfreddy"
GM.Materials_animatronicsvision = "effects/combine_binocoverlay"
GM.Materials_mapfreddys = "fnafgm/maps/freddys"
GM.Materials_mapfnaf2 = "fnafgm/maps/fnaf2"
GM.Materials_usage = "fnafgm/usage/usage_"
GM.Materials_battery = "fnafgm/battery/battery_"
GM.Materials_animatronic = "fnafgm/weapons/freddy"
GM.Materials_foxy = "fnafgm/weapons/foxy"
GM.Materials_fnaf2deathcam = "fnafgm/overlays/fnaf2deathcam"

GM.Models_dead = { Model("models/splinks/fnaf/bonnie/bonnie.mdl"), Model("models/splinks/fnaf/chica/chica.mdl"), Model("models/splinks/fnaf/freddy/freddy.mdl") }
GM.Models_defaultplayermodels = {"barney", "male10", "male11", "male12", "male13", "male14", "male15", "male16", "male17", "male18"}
GM.Models_bonnie = Model("models/splinks/fnaf/bonnie/player_bonnie.mdl")
GM.Models_chica = Model("models/splinks/fnaf/chica/player_chica.mdl")
GM.Models_foxy = Model("models/splinks/fnaf/foxy/player_foxy.mdl")
GM.Models_freddy = Model("models/splinks/fnaf/freddy/player_freddy.mdl")
GM.Models_goldenfreddy = Model("models/splinks/fnaf/golden_freddy/player_golden_freddy.mdl")

GM.CamsNames = {
	freddysnoevent_1 = "West Hall Corner",
	freddysnoevent_2 = "West Hall",
	freddysnoevent_3 = "Supply Closet",
	freddysnoevent_4 = "East Hall",
	freddysnoevent_5 = "East Hall Corner",
	freddysnoevent_6 = "Backstage",
	freddysnoevent_7 = "Show Stage",
	freddysnoevent_8 = "Restroom",
	freddysnoevent_9 = "Pirate Cove",
	freddysnoevent_10 = "Dining Area",
	freddysnoevent_11 = "Kitchen",
	freddysnoevent_12 = "Office",
	fnaf2noevents_1 = "Party Room 1",
	fnaf2noevents_2 = "Party Room 2",
	fnaf2noevents_3 = "Party Room 3",
	fnaf2noevents_4 = "Party Room 4",
	fnaf2noevents_5 = "Right Air Vent",
	fnaf2noevents_6 = "Left Air Vent",
	fnaf2noevents_7 = "Main Hall",
	fnaf2noevents_8 = "Parts/Service",
	fnaf2noevents_9 = "Kid's Cove",
	fnaf2noevents_10 = "Prize Corner",
	fnaf2noevents_11 = "Game Area",
	fnaf2noevents_12 = "Show Stage",
	fnaf2noevents_13 = "Office"
}

GM.MapList = {
	freddysnoevent = "FNaF 1",
	fnaf2noevents = "FNaF 2",
	fnaf3 = "FNaF 3",
	fnaf4house = "FNaF 4"
	--fnaf4versus = "FNaF 4 PvP"
}

GM.MapListLinks = {
	freddysnoevent = "http://steamcommunity.com/sharedfiles/filedetails/?id=311282498",
	fnaf2noevents = "http://steamcommunity.com/sharedfiles/filedetails/?id=342417402",
	fnaf3 = "http://steamcommunity.com/sharedfiles/filedetails/?id=409285826",
	fnaf4house = "http://steamcommunity.com/sharedfiles/filedetails/?id=493003146"
	--fnaf4versus = "http://steamcommunity.com/sharedfiles/filedetails/?id=493003146"
}

GM.Animatronic = {}
GM.Animatronic.Freddy = 0
GM.Animatronic.Bonnie = 1
GM.Animatronic.Chica = 2
GM.Animatronic.Foxy = 3
GM.Animatronic.GoldenFreddy = 4
GM.Animatronic.ToyFreddy = 5
GM.Animatronic.ToyBonnie = 6
GM.Animatronic.ToyChica = 7
GM.Animatronic.Mangle = 8
GM.Animatronic.Puppet = 9
GM.Animatronic.Springtrap = 10

GM.AnimatronicName = {}
GM.AnimatronicName[0] = "Freddy"
GM.AnimatronicName[1] = "Bonnie"
GM.AnimatronicName[2] = "Chica"
GM.AnimatronicName[3] = "Foxy"
GM.AnimatronicName[4] = "Golden Freddy"
GM.AnimatronicName[5] = "Toy Freddy"
GM.AnimatronicName[6] = "Toy Bonnie"
GM.AnimatronicName[7] = "Toy Chica"
GM.AnimatronicName[8] = "Mangle"
GM.AnimatronicName[9] = "The Puppet"
GM.AnimatronicName[10] = "Springtrap"

GM.Animatronic_Models = {}
GM.Animatronic_Models[GM.Animatronic.Freddy] = {}
GM.Animatronic_Models[GM.Animatronic.Freddy].freddysnoevent = Model("models/splinks/fnaf/freddy/combine_freddy.mdl")
GM.Animatronic_Models[GM.Animatronic.Bonnie] = {}
GM.Animatronic_Models[GM.Animatronic.Bonnie].freddysnoevent = Model("models/splinks/fnaf/bonnie/combine_bonnie.mdl")
GM.Animatronic_Models[GM.Animatronic.Chica] = {}
GM.Animatronic_Models[GM.Animatronic.Chica].freddysnoevent = Model("models/splinks/fnaf/chica/combine_chica.mdl")
GM.Animatronic_Models[GM.Animatronic.Foxy] = {}
GM.Animatronic_Models[GM.Animatronic.Foxy].freddysnoevent = Model("models/splinks/fnaf/foxy/combine_foxy.mdl")
GM.Animatronic_Models[GM.Animatronic.GoldenFreddy] = {}
GM.Animatronic_Models[GM.Animatronic.GoldenFreddy].freddysnoevent = Model("models/splinks/fnaf/golden_freddy/combine_golden_freddy.mdl")

GM.APos = {}
GM.APos.freddysnoevent = {
	WHC = 1,
	WH = 2,
	SC = 3,
	EH = 4,
	EHC = 5,
	Backstage = 6,
	SS = 7,
	Restroom = 8,
	PC = 9,
	DA = 10,
	Kitchen = 11,
	Office = 12
}
GM.APos.fnaf2noevents = {
	PR1 = 1,
	PR2 = 2,
	PR3 = 3,
	PR4 = 4,
	RAV = 5,
	LAV = 6,
	MH = 7,
	PS = 8,
	KC = 9,
	PC = 10,
	GA = 11,
	SS = 12,
	Office = 13
}

GM.ASSEye = {}

GM.AnimatronicAPos = {}
GM.AnimatronicAPos[GM.Animatronic.Freddy] = {}
GM.AnimatronicAPos[GM.Animatronic.Bonnie] = {}
GM.AnimatronicAPos[GM.Animatronic.Chica] = {}
GM.AnimatronicAPos[GM.Animatronic.Foxy] = {}
GM.AnimatronicAPos[GM.Animatronic.GoldenFreddy] = {}
GM.AnimatronicAPos[GM.Animatronic.ToyFreddy] = {}
GM.AnimatronicAPos[GM.Animatronic.ToyBonnie] = {}
GM.AnimatronicAPos[GM.Animatronic.ToyChica] = {}
GM.AnimatronicAPos[GM.Animatronic.Mangle] = {}
GM.AnimatronicAPos[GM.Animatronic.Puppet] = {}
GM.AnimatronicAPos[GM.Animatronic.Springtrap] = {}

GM.AnimatronicAPos[GM.Animatronic.Freddy].freddysnoevent = {}
GM.AnimatronicAPos[GM.Animatronic.Freddy].freddysnoevent[GM.APos.freddysnoevent.EH] = { Vector(65,-740,65), Angle(0,265,0) }
GM.AnimatronicAPos[GM.Animatronic.Freddy].freddysnoevent[GM.APos.freddysnoevent.EHC] = { Vector(41,-1244,65), Angle(0,120,0) }
GM.AnimatronicAPos[GM.Animatronic.Freddy].freddysnoevent[GM.APos.freddysnoevent.SS] = { Vector(14,174,100), Angle(0,270,0) }
GM.AnimatronicAPos[GM.Animatronic.Freddy].freddysnoevent[GM.APos.freddysnoevent.Restroom] = { Vector(609,-174,65), Angle(0,136,0) }
GM.AnimatronicAPos[GM.Animatronic.Freddy].freddysnoevent[GM.APos.freddysnoevent.DA] = { Vector(98,-266,65), Angle(0,134,0) }
GM.AnimatronicAPos[GM.Animatronic.Freddy].freddysnoevent[GM.APos.freddysnoevent.Kitchen] = { Vector(270,-1004,64), Angle(0,90,0) }
GM.AnimatronicAPos[GM.Animatronic.Freddy].freddysnoevent[GM.APos.freddysnoevent.Office] = { Vector(43,-1171,65), Angle(0,180,0) }

GM.AnimatronicAPos[GM.Animatronic.Bonnie].freddysnoevent = {}
GM.AnimatronicAPos[GM.Animatronic.Bonnie].freddysnoevent[GM.APos.freddysnoevent.WHC] = { Vector(-218,-1294,65), Angle(0,91,0) }
GM.AnimatronicAPos[GM.Animatronic.Bonnie].freddysnoevent[GM.APos.freddysnoevent.WH] = { Vector(-222,-554,65), Angle(0,270,0) }
GM.AnimatronicAPos[GM.Animatronic.Bonnie].freddysnoevent[GM.APos.freddysnoevent.SC] = { Vector(-376,-734,65), Angle(0,0,0) }
GM.AnimatronicAPos[GM.Animatronic.Bonnie].freddysnoevent[GM.APos.freddysnoevent.Backstage] = { Vector(-432,-94,65), Angle(0,270,0) }
GM.AnimatronicAPos[GM.Animatronic.Bonnie].freddysnoevent[GM.APos.freddysnoevent.SS] = { Vector(-104,192,94), Angle(0,292,0) }
GM.AnimatronicAPos[GM.Animatronic.Bonnie].freddysnoevent[GM.APos.freddysnoevent.DA] = { Vector(-158,-110,65), Angle(0,79,0) }
GM.AnimatronicAPos[GM.Animatronic.Bonnie].freddysnoevent[GM.APos.freddysnoevent.Office] = { Vector(-206,-1172,65), Angle(0,0,0) }

GM.AnimatronicAPos[GM.Animatronic.Chica].freddysnoevent = {}
GM.AnimatronicAPos[GM.Animatronic.Chica].freddysnoevent[GM.APos.freddysnoevent.EH] = { Vector(62,-894,70), Angle(0,260,0) }
GM.AnimatronicAPos[GM.Animatronic.Chica].freddysnoevent[GM.APos.freddysnoevent.EHC] = { Vector(64,-1290,70), Angle(0,111,0) }
GM.AnimatronicAPos[GM.Animatronic.Chica].freddysnoevent[GM.APos.freddysnoevent.SS] = { Vector(106,198,96), Angle(0,258,0) }
GM.AnimatronicAPos[GM.Animatronic.Chica].freddysnoevent[GM.APos.freddysnoevent.Restroom] = { Vector(513,-284,70), Angle(0,87,0) }
GM.AnimatronicAPos[GM.Animatronic.Chica].freddysnoevent[GM.APos.freddysnoevent.DA] = { Vector(-30,-274,65), Angle(0,116,0) }
GM.AnimatronicAPos[GM.Animatronic.Chica].freddysnoevent[GM.APos.freddysnoevent.Office] = { Vector(32,-1080,70), Angle(0,211,0) }

GM.AnimatronicAPos[GM.Animatronic.Foxy].freddysnoevent = {}
GM.AnimatronicAPos[GM.Animatronic.Foxy].freddysnoevent[GM.APos.freddysnoevent.PC] = { Vector(-475,-358,90), Angle(0,0,0) }
GM.AnimatronicAPos[GM.Animatronic.Foxy].freddysnoevent[GM.APos.freddysnoevent.Office] = { Vector(-475,-358,90), Angle(0,0,0) }

GM.AnimatronicAPos[GM.Animatronic.GoldenFreddy].freddysnoevent = {}
GM.AnimatronicAPos[GM.Animatronic.GoldenFreddy].freddysnoevent[GM.APos.freddysnoevent.Kitchen] = { Vector(305,-899,108), Angle(0,0,0) }


GM.AnimatronicAPos[GM.Animatronic.ToyFreddy].fnaf2noevents = {}
GM.AnimatronicAPos[GM.Animatronic.ToyFreddy].fnaf2noevents[GM.APos.fnaf2noevents.GA] = { Vector(768,847,1), Angle(0,270,0) }
GM.AnimatronicAPos[GM.Animatronic.ToyFreddy].fnaf2noevents[GM.APos.fnaf2noevents.SS] = { Vector(1196,1535,32), Angle(0,270,0) }
GM.AnimatronicAPos[GM.Animatronic.ToyFreddy].fnaf2noevents[GM.APos.fnaf2noevents.Office] = { Vector(38,15,0), Angle(0,263,0) }

GM.AnimatronicAPos[GM.Animatronic.ToyBonnie].fnaf2noevents = {}
GM.AnimatronicAPos[GM.Animatronic.ToyBonnie].fnaf2noevents[GM.APos.fnaf2noevents.PR3] = { Vector(-334.211,937.728,0), Angle(0,321.5,0) }
GM.AnimatronicAPos[GM.Animatronic.ToyBonnie].fnaf2noevents[GM.APos.fnaf2noevents.PR4] = { Vector(298,856,0), Angle(0,205,0) }
GM.AnimatronicAPos[GM.Animatronic.ToyBonnie].fnaf2noevents[GM.APos.fnaf2noevents.SS] = { Vector(1140,1536,32), Angle(0,270,0) }
GM.AnimatronicAPos[GM.Animatronic.ToyBonnie].fnaf2noevents[GM.APos.fnaf2noevents.Office] = { Vector(332,-226,2), Angle(0,180,0) }

GM.AnimatronicAPos[GM.Animatronic.ToyChica].fnaf2noevents = {}
GM.AnimatronicAPos[GM.Animatronic.ToyChica].fnaf2noevents[GM.APos.fnaf2noevents.PR1] = { Vector(-440,210,0), Angle(0,355,0) }
GM.AnimatronicAPos[GM.Animatronic.ToyChica].fnaf2noevents[GM.APos.fnaf2noevents.PR4] = { Vector(496,962,0), Angle(0,200,0) }
GM.AnimatronicAPos[GM.Animatronic.ToyChica].fnaf2noevents[GM.APos.fnaf2noevents.LAV] = { Vector(-346,-226,0), Angle(0,10,0) }
GM.AnimatronicAPos[GM.Animatronic.ToyChica].fnaf2noevents[GM.APos.fnaf2noevents.MH] = { Vector(232,1204,0), Angle(0,0,0) }
GM.AnimatronicAPos[GM.Animatronic.ToyChica].fnaf2noevents[GM.APos.fnaf2noevents.SS] = { Vector(1256,1536,32), Angle(0,270,0) }
GM.AnimatronicAPos[GM.Animatronic.ToyChica].fnaf2noevents[GM.APos.fnaf2noevents.Office] = { Vector(0,162,0), Angle(0,270,0) }


GM.AnimatronicsCD = {}
GM.AnimatronicsCD[GM.Animatronic.Freddy] = {}
GM.AnimatronicsCD[GM.Animatronic.Freddy].freddysnoevent = {}
GM.AnimatronicsCD[GM.Animatronic.Freddy].freddysnoevent[0] = 10
GM.AnimatronicsCD[GM.Animatronic.Freddy].freddysnoevent[1] = -1
GM.AnimatronicsCD[GM.Animatronic.Freddy].freddysnoevent[2] = -1
GM.AnimatronicsCD[GM.Animatronic.Freddy].freddysnoevent[3] = 30
GM.AnimatronicsCD[GM.Animatronic.Freddy].freddysnoevent[4] = 30
GM.AnimatronicsCD[GM.Animatronic.Freddy].freddysnoevent[5] = 16
GM.AnimatronicsCD[GM.Animatronic.Freddy].freddysnoevent[6] = 6
GM.AnimatronicsCD[GM.Animatronic.Bonnie] = {}
GM.AnimatronicsCD[GM.Animatronic.Bonnie].freddysnoevent = {}
GM.AnimatronicsCD[GM.Animatronic.Bonnie].freddysnoevent[0] = 10
GM.AnimatronicsCD[GM.Animatronic.Bonnie].freddysnoevent[1] = 60
GM.AnimatronicsCD[GM.Animatronic.Bonnie].freddysnoevent[2] = 40
GM.AnimatronicsCD[GM.Animatronic.Bonnie].freddysnoevent[3] = 30
GM.AnimatronicsCD[GM.Animatronic.Bonnie].freddysnoevent[4] = 20
GM.AnimatronicsCD[GM.Animatronic.Bonnie].freddysnoevent[5] = 16
GM.AnimatronicsCD[GM.Animatronic.Bonnie].freddysnoevent[6] = 6
GM.AnimatronicsCD[GM.Animatronic.Chica] = {}
GM.AnimatronicsCD[GM.Animatronic.Chica].freddysnoevent = {}
GM.AnimatronicsCD[GM.Animatronic.Chica].freddysnoevent[0] = 10
GM.AnimatronicsCD[GM.Animatronic.Chica].freddysnoevent[1] = 60
GM.AnimatronicsCD[GM.Animatronic.Chica].freddysnoevent[2] = 40
GM.AnimatronicsCD[GM.Animatronic.Chica].freddysnoevent[3] = 30
GM.AnimatronicsCD[GM.Animatronic.Chica].freddysnoevent[4] = 20
GM.AnimatronicsCD[GM.Animatronic.Chica].freddysnoevent[5] = 16
GM.AnimatronicsCD[GM.Animatronic.Chica].freddysnoevent[6] = 6
GM.AnimatronicsCD[GM.Animatronic.Foxy] = {}
GM.AnimatronicsCD[GM.Animatronic.Foxy].freddysnoevent = {}
GM.AnimatronicsCD[GM.Animatronic.Foxy].freddysnoevent[0] = 60
GM.AnimatronicsCD[GM.Animatronic.Foxy].freddysnoevent[1] = -1
GM.AnimatronicsCD[GM.Animatronic.Foxy].freddysnoevent[2] = 200
GM.AnimatronicsCD[GM.Animatronic.Foxy].freddysnoevent[3] = 120
GM.AnimatronicsCD[GM.Animatronic.Foxy].freddysnoevent[4] = 120
GM.AnimatronicsCD[GM.Animatronic.Foxy].freddysnoevent[5] = 120
GM.AnimatronicsCD[GM.Animatronic.Foxy].freddysnoevent[6] = 60

GM.AnimatronicsMaxCD = {}
GM.AnimatronicsMaxCD[GM.Animatronic.Freddy] = {}
GM.AnimatronicsMaxCD[GM.Animatronic.Freddy].freddysnoevent = {}
GM.AnimatronicsMaxCD[GM.Animatronic.Freddy].freddysnoevent[0] = 10
GM.AnimatronicsMaxCD[GM.Animatronic.Freddy].freddysnoevent[1] = -1
GM.AnimatronicsMaxCD[GM.Animatronic.Freddy].freddysnoevent[2] = -1
GM.AnimatronicsMaxCD[GM.Animatronic.Freddy].freddysnoevent[3] = 90
GM.AnimatronicsMaxCD[GM.Animatronic.Freddy].freddysnoevent[4] = 60
GM.AnimatronicsMaxCD[GM.Animatronic.Freddy].freddysnoevent[5] = 30
GM.AnimatronicsMaxCD[GM.Animatronic.Freddy].freddysnoevent[6] = 10
GM.AnimatronicsMaxCD[GM.Animatronic.Bonnie] = {}
GM.AnimatronicsMaxCD[GM.Animatronic.Bonnie].freddysnoevent = {}
GM.AnimatronicsMaxCD[GM.Animatronic.Bonnie].freddysnoevent[0] = 10
GM.AnimatronicsMaxCD[GM.Animatronic.Bonnie].freddysnoevent[1] = 90
GM.AnimatronicsMaxCD[GM.Animatronic.Bonnie].freddysnoevent[2] = 60
GM.AnimatronicsMaxCD[GM.Animatronic.Bonnie].freddysnoevent[3] = 45
GM.AnimatronicsMaxCD[GM.Animatronic.Bonnie].freddysnoevent[4] = 30
GM.AnimatronicsMaxCD[GM.Animatronic.Bonnie].freddysnoevent[5] = 30
GM.AnimatronicsMaxCD[GM.Animatronic.Bonnie].freddysnoevent[6] = 10
GM.AnimatronicsMaxCD[GM.Animatronic.Chica] = {}
GM.AnimatronicsMaxCD[GM.Animatronic.Chica].freddysnoevent = {}
GM.AnimatronicsMaxCD[GM.Animatronic.Chica].freddysnoevent[0] = 10
GM.AnimatronicsMaxCD[GM.Animatronic.Chica].freddysnoevent[1] = 90
GM.AnimatronicsMaxCD[GM.Animatronic.Chica].freddysnoevent[2] = 60
GM.AnimatronicsMaxCD[GM.Animatronic.Chica].freddysnoevent[3] = 45
GM.AnimatronicsMaxCD[GM.Animatronic.Chica].freddysnoevent[4] = 30
GM.AnimatronicsMaxCD[GM.Animatronic.Chica].freddysnoevent[5] = 30
GM.AnimatronicsMaxCD[GM.Animatronic.Chica].freddysnoevent[6] = 10
GM.AnimatronicsMaxCD[GM.Animatronic.Foxy] = {}
GM.AnimatronicsMaxCD[GM.Animatronic.Foxy].freddysnoevent = {}
GM.AnimatronicsMaxCD[GM.Animatronic.Foxy].freddysnoevent[0] = 170
GM.AnimatronicsMaxCD[GM.Animatronic.Foxy].freddysnoevent[1] = -1
GM.AnimatronicsMaxCD[GM.Animatronic.Foxy].freddysnoevent[2] = 500
GM.AnimatronicsMaxCD[GM.Animatronic.Foxy].freddysnoevent[3] = 400
GM.AnimatronicsMaxCD[GM.Animatronic.Foxy].freddysnoevent[4] = 300
GM.AnimatronicsMaxCD[GM.Animatronic.Foxy].freddysnoevent[5] = 170
GM.AnimatronicsMaxCD[GM.Animatronic.Foxy].freddysnoevent[6] = 170

GM.AnimatronicsSkins = {}

GM.AnimatronicsFlex = {}

GM.AnimatronicsAnim = {}

GM.Vars = {}

--[CVAR]--
fnafgm_deathscreendelay = CreateConVar( "fnafgm_deathscreendelay", 1, FCVAR_REPLICATED, "The death screen delay. (Time of the jumpscare)" )
fnafgm_deathscreenduration = CreateConVar( "fnafgm_deathscreenduration", 10, FCVAR_REPLICATED, "The death screen duration." )
fnafgm_autorespawn = CreateConVar( "fnafgm_autorespawn", 0, FCVAR_REPLICATED, "Auto respawn after the death screen." )
fnafgm_allowflashlight = CreateConVar( "fnafgm_allowflashlight", 0, FCVAR_REPLICATED, "Enables/Disables the player's flashlight. (Except for admins)" )
fnafgm_respawnenabled = CreateConVar( "fnafgm_respawnenabled", 1, FCVAR_REPLICATED, "Enable/Disable the respawn. (Except for admins)" )
fnafgm_deathscreenfade = CreateConVar( "fnafgm_deathscreenfade", 1, FCVAR_REPLICATED, "Enable/Disable the death screen fade." )
fnafgm_deathscreenoverlay = CreateConVar( "fnafgm_deathscreenoverlay", 1, FCVAR_REPLICATED, "Enable/Disable the death screen overlay." )
fnafgm_ragdollinstantremove = CreateConVar( "fnafgm_ragdollinstantremove", 0, FCVAR_REPLICATED, "Instant remove dead bodies." )
fnafgm_ragdolloverride = CreateConVar( "fnafgm_ragdolloverride", 1, FCVAR_REPLICATED, "Change the dead bodies." )
fnafgm_autocleanupmap = CreateConVar( "fnafgm_autocleanupmap", 1, FCVAR_REPLICATED, "Auto clean up when the server is empty." )
fnafgm_preventdoorkill = CreateConVar( "fnafgm_preventdoorkill", 1, FCVAR_REPLICATED, "The doors are the main cause of death. So stop these killers by putting a value of 1" )
fnafgm_timethink_endlesstime = CreateConVar( "fnafgm_timethink_endlesstime", 0, FCVAR_REPLICATED, "The time will be endless. (Don't use this)" )
fnafgm_timethink_infinitenights = CreateConVar( "fnafgm_timethink_infinitenights", 0, FCVAR_REPLICATED, "The nights will be endless." )
fnafgm_forceseasonalevent = CreateConVar( "fnafgm_forceseasonalevent", 0, FCVAR_REPLICATED, "2 for April Fool. 3 for Halloween. 4 for Christmas" )
fnafgm_killextsrplayers = CreateConVar( "fnafgm_killextsrplayers", 1, FCVAR_REPLICATED, "Stay in the security room otherwise you risk getting caught by the animatronics." )
fnafgm_playermodel = CreateConVar( "fnafgm_playermodel", "none", FCVAR_REPLICATED, "Override the player model." )
fnafgm_playerskin = CreateConVar( "fnafgm_playerskin", "0", FCVAR_REPLICATED, "Override the skin to use, if the model has any." )
fnafgm_playerbodygroups = CreateConVar( "fnafgm_playerbodygroups", "0", FCVAR_REPLICATED, "Override the bodygroups to use, if the model has any." )
fnafgm_playercolor = CreateConVar( "fnafgm_playercolor", "0.24 0.34 0.41", FCVAR_REPLICATED, "The value is a Vector - so between 0-1 - not between 0-255." )
fnafgm_respawndelay = CreateConVar( "fnafgm_respawndelay", 0, FCVAR_REPLICATED, "Time before respawn. (After the death screen)" )
fnafgm_enablebypass = CreateConVar( "fnafgm_enablebypass", 0, FCVAR_REPLICATED, "Enable the bypass funcs." )
fnafgm_pinionsupport = CreateConVar( "fnafgm_pinionsupport", 0, FCVAR_REPLICATED, "Enable Pinion ads between nights and other." )
fnafgm_timethink_autostart = CreateConVar( "fnafgm_timethink_autostart", 1, FCVAR_REPLICATED, "Start the night automatically." )
fnafgm_timethink_autostartdelay = CreateConVar( "fnafgm_timethink_autostartdelay", 60, FCVAR_REPLICATED, "Auto start delay." )
fnafgm_disablemapsmonitors = CreateConVar( "fnafgm_disablemapsmonitors", 1, FCVAR_REPLICATED, "If the gamemode should disable the map's monitors." )
fnafgm_disablepower = CreateConVar( "fnafgm_disablepower", 0, FCVAR_REPLICATED, "Disable the power." )
fnafgm_forcesavingloading = CreateConVar( "fnafgm_forcesavingloading", 0, FCVAR_REPLICATED, "Force save and load for dedicated servers." )
fnafgm_enablecreatorsbypass = CreateConVar( "fnafgm_enablecreatorsbypass", 0, FCVAR_REPLICATED, "Allows the gamemode's creators to use bypass funcs." )
fnafgm_enabledevmode = CreateConVar( "fnafgm_enabledevmode", 0, FCVAR_REPLICATED, "Dev mode and more logs." )
fnafgm_sgvsa = CreateConVar( "fnafgm_sgvsa", 0, FCVAR_REPLICATED, "Enable PvP SGvsA mode." )

fnafgm_cl_hideversion = CreateClientConVar( "fnafgm_cl_hideversion", 0, true, false )
fnafgm_cl_warn = CreateClientConVar( "fnafgm_cl_warn", 1, true, false )
fnafgm_cl_autofnafview = CreateClientConVar( "fnafgm_cl_autofnafview", 1, true, true )
fnafgm_cl_chatsound = CreateClientConVar( "fnafgm_cl_chatsound", 1, true, false )
fnafgm_cl_flashwindow = CreateClientConVar( "fnafgm_cl_flashwindow", 1, true, false )
fnafgm_cl_saveonservers = CreateClientConVar( "fnafgm_cl_saveonservers", 1, true, false )
fnafgm_cl_disablexpsc = CreateClientConVar( "fnafgm_cl_disablexpsc", 0, true, false )
fnafgm_cl_disablehalos = CreateClientConVar( "fnafgm_cl_disablehalos", 0, true, false )


function GM:Initialize()

	GAMEMODE:LoadLanguage(GetConVarString("gmod_language"))
	
	cvars.AddChangeCallback( "gmod_language", function( convar_name, value_old, value_new )
		GAMEMODE:LoadLanguage(value_new)
	end)
	
	GAMEMODE.Vars.startday = false
	GAMEMODE.Vars.gameend = false
	GAMEMODE.Vars.iniok = false
	GAMEMODE.Vars.time = GAMEMODE.TimeBase
	GAMEMODE.Vars.AMPM = GAMEMODE.AMPM
	GAMEMODE.Vars.night = GAMEMODE.NightBase
	GAMEMODE.Vars.nightpassed = false
	GAMEMODE.Vars.tempostart = false
	GAMEMODE.Vars.mute = true
	GAMEMODE.Vars.overfive = false
	GAMEMODE.Vars.power = 0
	GAMEMODE.Vars.powerusage = GAMEMODE.Power_Usage_Base
	GAMEMODE.Vars.powertot = GAMEMODE.Power_Max
	GAMEMODE.Vars.poweroff = false
	GAMEMODE.Vars.SGvsA = false
	GAMEMODE.Vars.AprilFool = false
	GAMEMODE.Vars.Halloween = false
	GAMEMODE.Vars.Christmas = false
	GAMEMODE.Vars.b87 = false
	GAMEMODE.Vars.seasonaltext = ""
	GAMEMODE.Vars.modetext = ""
	GAMEMODE.Vars.fnafview = false
	GAMEMODE.Vars.fnafviewactive = false
	GAMEMODE.Vars.fnafgmWorkShop = false
	GAMEMODE.Vars.lastversion = 0
	GAMEMODE.Vars.lastderivversion = 0
	GAMEMODE.Vars.Animatronics = {}
	
	if !file.IsDir( ( string.lower(GAMEMODE.ShortName) or "fnafgm" ), "DATA" ) then
		file.CreateDir( ( string.lower(GAMEMODE.ShortName) or "fnafgm" ) )
	elseif !file.IsDir( "fnafgm", "DATA" ) then
		file.CreateDir( "fnafgm" )
	end
	
	
	local Timestamp = os.time()
	if (os.date( "%d/%m" , Timestamp )=="01/04") then --SeasonalEvents
		GAMEMODE.Vars.AprilFool = true
		GAMEMODE.Vars.seasonaltext = " - April Fool"
	elseif (os.date( "%d/%m" , Timestamp )=="31/10") then
		GAMEMODE.Vars.Halloween = true
		GAMEMODE.Vars.seasonaltext = " - Halloween"
	elseif (os.date( "%d/%m" , Timestamp )=="24/12") or (os.date( "%d/%m" , Timestamp )=="25/12") then
		GAMEMODE.Vars.Christmas = true
		GAMEMODE.Vars.seasonaltext = " - Christmas"
		GAMEMODE.Power_Max = 125
	end
	
	
	if fnafgm_sgvsa:GetBool() and !game.SinglePlayer() then
		GAMEMODE.Vars.SGvsA = true
		GAMEMODE.Vars.modetext = " - PvP SGvsA"
	end
	
	if !game.SinglePlayer() then
		
		cvars.AddChangeCallback( "fnafgm_sgvsa", function( convar_name, value_old, value_new )
			if tonumber(value_new)>=1 then
				GAMEMODE.Vars.SGvsA = true
				GAMEMODE.Vars.modetext = " - PvP SGvsA"
				GAMEMODE:Log( "The game is now in PvP SGvsA mode!" )
				if SERVER then
					net.Start( "fnafgmNotif" )
						net.WriteString( "now_sgvsa" )
						net.WriteInt(4,3)
						net.WriteFloat(5)
						net.WriteBit(true)
					net.Broadcast()
					if !game.IsDedicated() then
						for k, v in pairs(player.GetAll()) do
							if v:IsListenServerHost() then
								v:SendLua([[GAMEMODE.Vars.SGvsA = true GAMEMODE.Vars.modetext = " - PvP SGvsA"]])
							end
						end
					end
				end
			else
				GAMEMODE.Vars.SGvsA = false
				GAMEMODE.Vars.modetext = ""
				GAMEMODE:Log( "The game is now in normal mode!" )
				if SERVER then
					net.Start( "fnafgmNotif" )
						net.WriteString( "now_normal" )
						net.WriteInt(4,3)
						net.WriteFloat(5)
						net.WriteBit(true)
					net.Broadcast()
					if !game.IsDedicated() then
						for k, v in pairs(player.GetAll()) do
							if v:IsListenServerHost() then
								v:SendLua([[GAMEMODE.Vars.SGvsA = false GAMEMODE.Vars.modetext = ""]])
							end
						end
					end
				end
			end
		end)
		
	end
	
	
	if GetHostName()=="1987" then --Not a easter egg ^^
		GAMEMODE.Vars.AprilFool = false
		GAMEMODE.Vars.Halloween = false
		GAMEMODE.Vars.SGvsA = false
		GAMEMODE.Vars.b87 = true
		GAMEMODE.Vars.modetext = " - '87"
	end
	
	
	for _, addon in pairs(engine.GetAddons()) do
		
		if addon.wsid == "408243366" and addon.mounted then
			GAMEMODE.Vars.fnafgmWorkShop = true
		end
		
	end
	
	for key, val in pairs(GAMEMODE.Sound_Animatronic) do
		for k, v in pairs(GAMEMODE.Sound_Animatronic[key]) do
			sound.Add( {
				name = "fnafgm_"..key.."_"..k,
				channel = CHAN_STATIC,
				volume = 1.0,
				level = 0,
				sound = v
			} )
		end
	end
	
	for k, v in pairs(GAMEMODE.Sound_end) do
		sound.Add( {
			name = "fnafgm_end_"..k,
			channel = CHAN_STATIC,
			volume = 1.0,
			level = 0,
			sound = v
		} )
	end
	
	sound.Add( {
		name = "fnafgm_campop",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_securitycampop
	} )
	sound.Add( {
		name = "fnafgm_campop2",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_securitycampop2
	} )
	sound.Add( {
		name = "fnafgm_campop3",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_securitycampop3
	} )
	sound.Add( {
		name = "fnafgm_camdown",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_securitycamdown
	} )
	sound.Add( {
		name = "fnafgm_camdown2",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_securitycamdown2
	} )
	sound.Add( {
		name = "fnafgm_camdown3",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_securitycamdown3
	} )
	sound.Add( {
		name = "fnafgm_camselect",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_camselect
	} )
	sound.Add( {
		name = "fnafgm_maskon",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_maskon
	} )
	sound.Add( {
		name = "fnafgm_maskoff",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_maskoff
	} )
	sound.Add( {
		name = "fnafgm_scream",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_xscream
	} )
	sound.Add( {
		name = "fnafgm_scream2",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_xscream2
	} )
	sound.Add( {
		name = "fnafgm_foxyknock",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_foxyknock
	} )
	sound.Add( {
		name = "fnafgm_foxystep",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_foxystep
	} )
	sound.Add( {
		name = "fnafgm_lighterror",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_lighterror
	} )
	sound.Add( {
		name = "fnafgm_startday",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_startday
	} )
	sound.Add( {
		name = "fnafgm_windowscare",
		channel = CHAN_AUTO,
		volume = 1.0,
		level = 0,
		sound = GAMEMODE.Sound_windowscare
	} )
	
	if SERVER then
		
		GAMEMODE.Vars.mapoverrideok = false
		GAMEMODE.Vars.norespawn = false
		GAMEMODE.Vars.active = false
		GAMEMODE.Vars.updateavailable = false
		GAMEMODE.Vars.derivupdateavailable = false
		GAMEMODE.ListGroup = {}
		GAMEMODE.Vars.powerdrain = GAMEMODE.Power_Drain_Time
		GAMEMODE.Vars.tabused = {}
		GAMEMODE.Vars.powerchecktime = nil
		GAMEMODE.Vars.oldpowerdrain = nil
		GAMEMODE.Vars.LightUse = {}
		GAMEMODE.Vars.DoorClosed = {}
		GAMEMODE.Vars.usingsafedoor = {}
		GAMEMODE.Vars.foxyknockdoorpena = 2
		GAMEMODE.Vars.addfoxyknockdoorpena = 4
		GAMEMODE.Vars.checkRestartNight = false
		
		if !game.SinglePlayer() then
			timer.Create( "fnafgmAutoCleanUp", 5, 0, fnafgmAutoCleanUp)
		end
		
		timer.Create( "fnafgmCheckForNewVersion", 21600, 0, fnafgmCheckForNewVersion)
		
		GAMEMODE:RefreshBypass()
		
	end
	
	timer.Create( "fnafgmLoadProgress", 2, 1, GAMEMODE.LoadProgress)
	
end


function GM:SaveProgress(erase)
	
	if SERVER and ( !GAMEMODE.Vars.SGvsA  and ( !game.IsDedicated() or fnafgm_forcesavingloading:GetBool() ) ) then
		
		if !file.IsDir( ( string.lower(GAMEMODE.ShortName) or "fnafgm" ).."/progress", "DATA") then
			file.CreateDir( ( string.lower(GAMEMODE.ShortName) or "fnafgm" ).."/progress" )
		end
		
		local tab = {}
		
		if erase then
			tab.Night = 0
		elseif GAMEMODE.Vars.night>=GAMEMODE.NightEnd then
			tab.Night = GAMEMODE.NightEnd
		else
			tab.Night = GAMEMODE.Vars.night
		end
		
		file.Write( ( string.lower(GAMEMODE.ShortName) or "fnafgm" ).."/progress/" .. game.GetMap() .. ".txt", util.TableToJSON( tab ) )
		
		GAMEMODE:Log("Progression saved! ("..tab.Night..")")
		
	end
	
	if CLIENT and !GAMEMODE.Vars.SGvsA and ( fnafgm_cl_saveonservers:GetBool() or erase ) then
		
		local filep = file.Read( ( string.lower(GAMEMODE.ShortName) or "fnafgm" ).."/progress/" .. game.GetMap() .. ".txt" )
		
		if ( filep and !erase ) then
		
			local tab = util.JSONToTable( filep )
			if ( tab ) then
				
				if ( tab.Night ) then
					if tab.Night>GAMEMODE.Vars.night then
						return
					end
				end
				
			end
		
		elseif !file.IsDir( ( string.lower(GAMEMODE.ShortName) or "fnafgm" ).."/progress", "DATA" ) then
			file.CreateDir( ( string.lower(GAMEMODE.ShortName) or "fnafgm" ).."/progress" )
		end
		
		local tab = {}
		
		if erase then
			tab.Night = 0
		elseif GAMEMODE.Vars.night>=GAMEMODE.NightEnd then
			tab.Night = GAMEMODE.NightEnd
		else
			tab.Night = GAMEMODE.Vars.night
		end
		
		file.Write( ( string.lower(GAMEMODE.ShortName) or "fnafgm" ).."/progress/" .. game.GetMap() .. ".txt", util.TableToJSON( tab ) )
		
		GAMEMODE:Log("Progression saved! ("..tab.Night..")")
		
	end
	
end


function GM:LoadProgress()
	
	if SERVER and ( !GAMEMODE.Vars.SGvsA  and ( !game.IsDedicated() or fnafgm_forcesavingloading:GetBool() ) ) then
		
		local filep = file.Read( ( string.lower(GAMEMODE.ShortName) or "fnafgm" ).."/progress/" .. game.GetMap() .. ".txt" )
		
		if ( filep ) then
		
			local tab = util.JSONToTable( filep )
			if ( tab ) then
				
				if ( tab.Night ) then
					if tab.Night>=GAMEMODE.NightEnd then
						GAMEMODE.Vars.night = GAMEMODE.NightEnd
					else
						GAMEMODE.Vars.night = tab.Night
					end
				end
				
				GAMEMODE:Log("Progression loaded! ("..GAMEMODE.Vars.night..")")
				
				return
				
			end
			
		end
		
	end
	
	if CLIENT and !GAMEMODE.Vars.SGvsA then
		
		local filep = file.Read( ( string.lower(GAMEMODE.ShortName) or "fnafgm" ).."/progress/" .. game.GetMap() .. ".txt" )
		
		if ( filep ) then
		
			local tab = util.JSONToTable( filep )
			if ( tab ) then
				
				if ( tab.Night ) then
					if tab.Night>=GAMEMODE.NightEnd then
						nightp = GAMEMODE.NightEnd+1
					else
						nightp = tab.Night+1
					end
				end
				
			end
			
		end
		
	end
	
end


function GM:RefreshBypass()
	
	if SERVER then
		GAMEMODE:Log("Checking bypasses...")
		local files, dir = file.Find("fnafgm/groups/" .. "*", "DATA")
		table.Empty(GAMEMODE.ListGroup)
		for k, v in pairs(files) do
			GAMEMODE.ListGroup["group_"..string.StripExtension(v)] = string.Explode( "|", file.Read("fnafgm/groups/"..v, "DATA") )
		end
		if table.Count(GAMEMODE.ListGroup)==0 then
			GAMEMODE:Log("No bypasses detected!")
		else
			PrintTable(GAMEMODE.ListGroup)
			GAMEMODE:Log("Bypasses checked!")
		end
	end
	
end


function GM:CreateTeams()
	
	team.SetUp( 1, tostring(GAMEMODE.TranslatedStrings.sg or GAMEMODE.Strings.en.sg), GAMEMODE.Colors_sg )
	team.SetClass(1, { "player_fnafgmsecurityguard" } )
	if game.GetMap()=="freddysnoevent" or game.GetMap()=="fnaf2noevents" then
		team.SetSpawnPoint( 1, { "info_player_terrorist" } )
	elseif game.GetMap()=="fnaf_freddypizzaevents" then
		team.SetSpawnPoint( 1, { "info_player_deathmatch" } )
	else
		team.SetSpawnPoint( 1, GAMEMODE.Spawns_sg )
	end
	
	team.SetUp( 2, tostring(GAMEMODE.TranslatedStrings.animatronics or GAMEMODE.Strings.en.animatronics), GAMEMODE.Colors_animatronics )
	team.SetClass(2, { "player_fnafgm_animatronic_controller" } )
	team.SetSpawnPoint( 2, GAMEMODE.Spawns_animatronics )
	
	team.SetUp(TEAM_SPECTATOR, tostring(GAMEMODE.TranslatedStrings.spectator or GAMEMODE.Strings.en.spectator), Color(128, 128, 128))
	
	team.SetUp(TEAM_UNASSIGNED, "Unassigned", Color(128, 128, 128), false)
	
end


function GM:CheckCreator(pl) --To easly debug others servers and credit
	if pl:SteamID()=="STEAM_0:1:18280147" then
		return true
	end
	return false
end


function GM:CheckDerivCreator(pl) --To credit you when you are detected
	return false
end


function GM:CustomCheck(pl,what) --Custom groups funcs
	
	if GAMEMODE.ListGroup["group_"..pl:GetUserGroup()] and table.HasValue(GAMEMODE.ListGroup["group_"..pl:GetUserGroup()], what) then
		return true
	elseif pl.XperidiaRank and pl.XperidiaRank>0 and GAMEMODE.ListGroup["group_premium"] and table.HasValue(GAMEMODE.ListGroup["group_premium"], what) then
		return true
	end
	
	return false
	
end


function GM:CheckPlayerSecurityRoom(ply)
	
	if (GAMEMODE.SecurityRoom[game.GetMap()]) then
		
		local ret = ply:GetPos():WithinAABox( GAMEMODE.SecurityRoom[game.GetMap()][1], GAMEMODE.SecurityRoom[game.GetMap()][2] )
		
		if ret then
			
			return true
			
		end
		
		if GAMEMODE.SecurityRoom[game.GetMap()][3] then
			
			local ret = ply:GetPos():WithinAABox( GAMEMODE.SecurityRoom[game.GetMap()][3], GAMEMODE.SecurityRoom[game.GetMap()][4] )
			
			if ret then
				
				return true
				
			end
			
		end
		
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


function GM:Move( ply, mv )

	if CLIENT and GAMEMODE.Vars.fnafviewactive then return true end
	
	if SERVER and ply.fnafviewactive then return true end
	
	if ( drive.Move( ply, mv ) ) then return true end
	
	if ( player_manager.RunClass( ply, "Move", mv ) ) then return true end
	
	return false

end


function GM:FinishMove( ply, mv )
	
	if CLIENT and GAMEMODE.Vars.fnafviewactive then return true end
	
	if SERVER and ply.fnafviewactive then return true end
	
	if ( drive.FinishMove( ply, mv ) ) then return true end
	if ( player_manager.RunClass( ply, "FinishMove", mv ) ) then return true end
	
end


function GM:GoFNaFView(ply,auto)
	
	GAMEMODE.Vars.fnafview = true
	
	if SERVER then 
		if GAMEMODE.FNaFView[game.GetMap()] and ply:Team()==1 and ply:Alive() then
			if !auto or ply:GetInfoNum("fnafgm_cl_autofnafview", 1)==1 then ply:SendLua([[GAMEMODE:GoFNaFView()]]) end
			if GAMEMODE.FNaFView[game.GetMap()][1] then ply:SetPos( GAMEMODE.FNaFView[game.GetMap()][1] ) end
			if GAMEMODE.FNaFView[game.GetMap()][2] then ply:SetEyeAngles( GAMEMODE.FNaFView[game.GetMap()][2] ) end
		end
	end
	
	if CLIENT then
		if !GAMEMODE.Vars.FNaFViewLastTime or GAMEMODE.Vars.FNaFViewLastTime+0.5<SysTime() then GAMEMODE:FNaFViewHUD() end
	end
	
end


timer.Create( "fnafgmAnimatronicsCD", 1, 0, function()
	
	if tobool(GAMEMODE.Vars.startday) then
		
		for k, v in pairs ( GAMEMODE.Vars.Animatronics ) do
			
			if GAMEMODE.Vars.Animatronics[k][3] and GAMEMODE.Vars.Animatronics[k][3]>0 then
				GAMEMODE.Vars.Animatronics[k][3] = GAMEMODE.Vars.Animatronics[k][3] - 1
			end
			
		end
		
		if CLIENT and IsValid(AnimatronicsControllerGUI) then
			
			if IsValid(AnimatronicsControllerGUI.Freddy) and IsValid(AnimatronicsControllerGUI.FreddyTxt) and GAMEMODE.Vars.Animatronics[GAMEMODE.Animatronic.Freddy][3]>0 then
				local val = GAMEMODE.Vars.Animatronics[GAMEMODE.Animatronic.Freddy][3]
				AnimatronicsControllerGUI.FreddyTxt:SetText( val.."s" )
				AnimatronicsControllerGUI.Freddy:SetImageColor( Color( 85, 85, 85, 255 ) )
			elseif IsValid(AnimatronicsControllerGUI.Freddy) and IsValid(AnimatronicsControllerGUI.FreddyTxt) and GAMEMODE.Vars.Animatronics[GAMEMODE.Animatronic.Freddy][3]==0 then
				AnimatronicsControllerGUI.FreddyTxt:SetText( "" )
				AnimatronicsControllerGUI.Freddy:SetImageColor( Color( 255, 255, 255, 255 ) )
			end
			
			if IsValid(AnimatronicsControllerGUI.Bonnie) and IsValid(AnimatronicsControllerGUI.BonnieTxt) and GAMEMODE.Vars.Animatronics[GAMEMODE.Animatronic.Bonnie][3]>0 then
				local val = GAMEMODE.Vars.Animatronics[GAMEMODE.Animatronic.Bonnie][3]
				AnimatronicsControllerGUI.BonnieTxt:SetText( val.."s" )
				AnimatronicsControllerGUI.Bonnie:SetImageColor( Color( 85, 85, 85, 255 ) )
			elseif IsValid(AnimatronicsControllerGUI.Bonnie) and IsValid(AnimatronicsControllerGUI.BonnieTxt) and GAMEMODE.Vars.Animatronics[GAMEMODE.Animatronic.Bonnie][3]==0 then
				AnimatronicsControllerGUI.BonnieTxt:SetText( "" )
				AnimatronicsControllerGUI.Bonnie:SetImageColor( Color( 255, 255, 255, 255 ) )
			end
			
			if IsValid(AnimatronicsControllerGUI.Chica) and IsValid(AnimatronicsControllerGUI.ChicaTxt) and GAMEMODE.Vars.Animatronics[GAMEMODE.Animatronic.Chica][3]>0 then
				local val = GAMEMODE.Vars.Animatronics[GAMEMODE.Animatronic.Chica][3]
				AnimatronicsControllerGUI.ChicaTxt:SetText( val.."s" )
				AnimatronicsControllerGUI.Chica:SetImageColor( Color( 85, 85, 85, 255 ) )
			elseif IsValid(AnimatronicsControllerGUI.Chica) and IsValid(AnimatronicsControllerGUI.ChicaTxt) and GAMEMODE.Vars.Animatronics[GAMEMODE.Animatronic.Chica][3]==0 then
				AnimatronicsControllerGUI.ChicaTxt:SetText( "" )
				AnimatronicsControllerGUI.Chica:SetImageColor( Color( 255, 255, 255, 255 ) )
			end
			
			if IsValid(AnimatronicsControllerGUI.Foxy) and IsValid(AnimatronicsControllerGUI.FoxyTxt) and GAMEMODE.Vars.Animatronics[GAMEMODE.Animatronic.Foxy][3]>0 then
				local val = GAMEMODE.Vars.Animatronics[GAMEMODE.Animatronic.Foxy][3]
				AnimatronicsControllerGUI.FoxyTxt:SetText( val.."s" )
				AnimatronicsControllerGUI.Foxy:SetImageColor( Color( 85, 85, 85, 255 ) )
			elseif IsValid(AnimatronicsControllerGUI.Foxy) and IsValid(AnimatronicsControllerGUI.FoxyTxt) and GAMEMODE.Vars.Animatronics[GAMEMODE.Animatronic.Foxy][3]==0 then
				AnimatronicsControllerGUI.FoxyTxt:SetText( "" )
				AnimatronicsControllerGUI.Foxy:SetImageColor( Color( 255, 255, 255, 255 ) )
			end
			
			if IsValid(AnimatronicsControllerGUI.FreddyBtn) and GAMEMODE.Vars.Animatronics[0][4]>CurTime() then
				AnimatronicsControllerGUI.FreddyBtn:SetText(math.Truncate(GAMEMODE.Vars.Animatronics[0][4]-CurTime(),0).."s")
			elseif IsValid(AnimatronicsControllerGUI.FreddyBtn) then
				AnimatronicsControllerGUI.FreddyBtn:SetText("TAUNT")
			end
			
			if IsValid(AnimatronicsControllerGUI.BonnieBtn) and GAMEMODE.Vars.Animatronics[1][4]>CurTime() then
				AnimatronicsControllerGUI.BonnieBtn:SetText(math.Truncate(GAMEMODE.Vars.Animatronics[1][4]-CurTime(),0).."s")
			elseif IsValid(AnimatronicsControllerGUI.BonnieBtn) then
				AnimatronicsControllerGUI.BonnieBtn:SetText("TAUNT")
			end
			
			if IsValid(AnimatronicsControllerGUI.ChicaBtn) and GAMEMODE.Vars.Animatronics[2][4]>CurTime() then
				AnimatronicsControllerGUI.ChicaBtn:SetText(math.Truncate(GAMEMODE.Vars.Animatronics[2][4]-CurTime(),0).."s")
			elseif IsValid(AnimatronicsControllerGUI.ChicaBtn) then
				AnimatronicsControllerGUI.ChicaBtn:SetText("TAUNT")
			end
			
			if IsValid(AnimatronicsControllerGUI.FoxyBtn) and GAMEMODE.Vars.Animatronics[3][4]>CurTime() then
				AnimatronicsControllerGUI.FoxyBtn:SetText(math.Truncate(GAMEMODE.Vars.Animatronics[3][4]-CurTime(),0).."s")
			elseif IsValid(AnimatronicsControllerGUI.FoxyBtn) then
				AnimatronicsControllerGUI.FoxyBtn:SetText("TAUNT")
			end
			
			hook.Call("fnafgmCustomAnimatronicsCD")
			
		end
		
	end
	
end)


function GM:Log(str,tn,hardcore)
	
	local name = (GAMEMODE.ShortName or "FNAFGM")
	if tn then name = "FNAFGM" end
	
	if hardcore and !fnafgm_enabledevmode:GetBool() then return end
	
	if game.IsDedicated() or GAMEMODE.Vars.DS then
		local tmstmp = os.time()
		local time = os.date( "L %m/%d/%Y - %H:%M:%S" , tmstmp )
		Msg( time..": ["..name.."] "..(str or "This was a log message, but something went wrong").."\n" )
	else
		Msg( "["..name.."] "..(str or "This was a log message, but something went wrong").."\n" )
	end
	
end


function GM:RetrieveXperidiaAccountRank(ply)
	
	if !SERVER then return end
	
	if !IsValid(ply) then return end
	
	if ply:IsBot() then return end
	
	if !ply.XperidiaRankLastTime or ply.XperidiaRankLastTime+3600<SysTime() then
		
		local steamid = ply:SteamID64()
		
		local XperidiaRanks = { "Premium", "Creator", "Administrator" }
		
		GAMEMODE:Log("Retrieving the Xperidia Rank for "..ply:GetName().."...",nil,true)
		
		http.Post( "https://www.xperidia.com/UCP/rank.php", { steamid = steamid },
		function( responseText, contentLength, responseHeaders, statusCode )
			
			if !IsValid(ply) then return end
			
			if statusCode == 200 then
				
				local rank = tonumber(string.Right(responseText, contentLength-3))
				ply.XperidiaRank = rank
				ply:SetNWInt( "XperidiaRank", rank )
				ply.XperidiaRankLastTime = SysTime()
				
				if XperidiaRanks[rank] then
					GAMEMODE:Log("The Xperidia Rank for "..ply:GetName().." is "..XperidiaRanks[rank])
				else
					GAMEMODE:Log(ply:GetName().." doesn't have any Xperidia Rank...",nil,true)
				end
				
			else
				GAMEMODE:Log("Error while retriving Xperidia Rank for "..ply:GetName().." (ERROR "..statusCode..")")
			end
			
		end, 
		function( errorMessage )
			
			GAMEMODE:Log(errorMessage)
			
		end )
		
	end
	
end
