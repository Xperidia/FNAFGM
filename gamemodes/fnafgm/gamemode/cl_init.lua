--[[---------------------------------------------------------

	Five Nights at Freddy's Gamemode for Garry's Mod
			by VictorienXP@Xperidia (2015-2020)

	"Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]

include('shared.lua')

DEFINE_BASECLASS("gamemode_base")
local SandboxClass = baseclass.Get("gamemode_sandbox")
DeriveGamemode("sandbox")

if !sfont and GM.FT == 2 then

	sfont = "OCR A Std"
	sfont2 = "Graph 35+ pix"
	sfont3 = sfont
	sfont4 = sfont2

elseif !sfont and GM.FT == 3 then

	sfont = "5Computers In Love"
	sfont2 = "Graph 35+ pix"
	sfont3 = sfont
	sfont4 = sfont2

elseif !sfont and GM.FT == 4 then

	sfont = "Graph 35+ pix"
	sfont2 = sfont
	sfont3 = "Precious"
	sfont4 = "DJB Get Digital"

elseif !sfont then

	sfont = "Graph 35+ pix"
	sfont2 = sfont
	sfont3 = sfont
	sfont4 = sfont2

end

for _, addon in pairs(engine.GetAddons()) do

	if addon.wsid == "104575630" and addon.mounted then
		CreateClientConVar("ragdollmover_rotatebutton", 109, false, false) -- Ragdoll Mover "fix" https://steamcommunity.com/sharedfiles/filedetails/?id=104575630
	end

end

concommand.Add("fnafgm_menu", function(ply)

	fnafgmMenu()

end)

surface.CreateFont("FNAFGMTIME", {
	font = sfont2,
	size = 38,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})
surface.CreateFont("FNAFGMATIME", {
	font = sfont3,
	size = 38,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})
surface.CreateFont("FNAFGM4TIME", {
	font = sfont4,
	size = 50,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})
surface.CreateFont("FNAFGMA4TIME", {
	font = sfont3,
	size = 100,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = true,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})
surface.CreateFont("FNAFGMNIGHT", {
	font = sfont2,
	size = 22,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})
surface.CreateFont("FNAFGMCH", {
	font = sfont,
	size = 110,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})
surface.CreateFont("FNAFGMID", {
	font = sfont,
	size = 14,
	weight = 1000,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})
surface.CreateFont("FNAFGMTXT", {
	font = sfont2,
	size = 12,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = false,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})
surface.CreateFont("FNAFGMCHECK", {
	font = "akbar",
	size = 40,
	weight = 0,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
})

function GM:DrawFnafButton(w, h, color)

	draw.RoundedBox(0, 1, 1, w - 2, h - 2, Color(color.r, color.g, color.b, 32))

	surface.SetDrawColor(color.r, color.g, color.b, 128)

	draw.NoTexture()

	surface.DrawLine(w / 2 - 64, h / 2 - 16, w / 2, h / 2)
	surface.DrawLine(w / 2, h / 2, w / 2 + 64, h / 2 - 16)

	surface.DrawLine(w / 2 - 64, h / 2, w / 2, h / 2 + 16)
	surface.DrawLine(w / 2, h / 2 + 16, w / 2 + 64, h / 2)

	surface.DrawOutlinedRect(0, 0, w, h)

end

include('cl_scoreboard.lua')
include('cl_voice.lua')
include('cl_fnafview.lua')
include('cl_menu.lua')
include('cl_secret.lua')
include('cl_monitor_shared.lua')


function fnafgmWarn()

	if !IsMounted("cstrike") and (game.GetMap() == "freddysnoevent" or game.GetMap() == "fnaf2noevents"
	or game.GetMap() == "fnaf3" or game.GetMap() == "fnaf4house" or game.GetMap() == "fnaf4noclips"
	or game.GetMap() == "fnaf4versus") and fnafgm_cl_warn:GetBool() then

		LocalPlayer():PrintMessage(HUD_PRINTTALK, GAMEMODE.TranslatedStrings.warn_css or GAMEMODE.Strings.en.warn_css)
		notification.AddLegacy(GAMEMODE.TranslatedStrings.warn_css or GAMEMODE.Strings.en.warn_css, NOTIFY_ERROR, 10)
		surface.PlaySound("buttons/button10.wav")

	end

	if !GAMEMODE.Vars.gamemode_init_done or !GAMEMODE.Vars.gamemode_init_done_s then

		LocalPlayer():PrintMessage(HUD_PRINTTALK, [[
Alert!
The gamemode initialization failed! (GM:Initialize())
Because of this the gamemode might not work properly!
This issue is certainly caused by another addon. Please check all your installed addons.
]])
		notification.AddLegacy("The gamemode initialization failed!", NOTIFY_ERROR, 10)
		surface.PlaySound("buttons/button10.wav")

	end

end


function GM:DrawDeathNotice(x, y)
	if fnafgm_sandbox_enable:GetBool() then
		BaseClass.DrawDeathNotice(self, x, y)
	end
end


function GM:HUDWeaponPickedUp(wep)
	if fnafgm_sandbox_enable:GetBool() then
		BaseClass.HUDWeaponPickedUp(self, wep)
	end
end

function GM:HUDItemPickedUp(itemname)
	if fnafgm_sandbox_enable:GetBool() then
		BaseClass.HUDItemPickedUp(self, itemname)
	end
end

function GM:HUDAmmoPickedUp(itemname, amount)
	if fnafgm_sandbox_enable:GetBool() then
		BaseClass.HUDAmmoPickedUp(self, itemname, amount)
	end
end


function GM:HUDDrawTargetID()

	local tr = util.GetPlayerTrace(LocalPlayer())
	local trace = util.TraceLine(tr)
	if !trace.Hit then return end
	if !trace.HitNonWorld then return end

	local text = "ERROR"
	local font = "FNAFGMID"

	if !GAMEMODE.Vars.fnafviewactive and !IsValid(GAMEMODE.Vars.Monitor)
	and (trace.Entity:IsPlayer() and (LocalPlayer():Team() == trace.Entity:Team() or LocalPlayer():Team() == 2 or LocalPlayer():Team() == TEAM_SPECTATOR)) then
		text = trace.Entity:Nick()
	elseif debugmode then
		text = trace.Entity:GetClass()
	else
		return
	end

	surface.SetFont(font)
	local w, h = surface.GetTextSize(text)

	local MouseX, MouseY = gui.MousePos()

	if MouseX == 0 && MouseY == 0 then

		MouseX = ScrW() / 2
		MouseY = ScrH() / 2

	end

	local x = MouseX
	local y = MouseY

	x = x - w / 2
	y = y + 30

	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText(text, font, x + 1, y + 1, Color(0,0,0,120))
	draw.SimpleText(text, font, x + 2, y + 2, Color(0,0,0,50))
	draw.SimpleText(text, font, x, y, self:GetTeamColor(trace.Entity))

end


local fnafgmHUDhide = {
	CHudHealth			= true,
	CHudBattery			= true,
	CHudDamageIndicator	= true,
	CHudDeathNotice		= true,
	CHudZoom			= true
}

function GM:HUDShouldDraw(name)

	if name == "CHudDamageIndicator" then
		return false
	elseif fnafgm_sandbox_enable:GetBool() then
		return SandboxClass.HUDShouldDraw(self, name)
	elseif name == "CHudCrosshair" and LocalPlayer():Team() == TEAM_UNASSIGNED then
		return false
	elseif name == "CHudCrosshair" and GAMEMODE.Vars.fnafviewactive then
		return false
	elseif name == "CHudCrosshair" and engine.IsPlayingDemo() then
		return false
	elseif name == "CHudCrosshair" and (GAMEMODE.Vars.tempostart or GAMEMODE.Vars.gameend or GAMEMODE.Vars.nightpassed) then
		return false
	elseif fnafgmHUDhide[name] then
		return false
	end

	return BaseClass.HUDShouldDraw(self, name)

end


net.Receive("fnafgmVarsUpdate", function(len)

	GAMEMODE.Vars.startday = tobool(net.ReadBit())
	GAMEMODE.Vars.gameend = tobool(net.ReadBit())
	GAMEMODE.Vars.iniok = tobool(net.ReadBit())
	GAMEMODE.Vars.time = net.ReadInt(5)
	GAMEMODE.Vars.AMPM = net.ReadString()
	GAMEMODE.Vars.night = net.ReadInt(32)
	GAMEMODE.Vars.nightpassed = tobool(net.ReadBit())
	GAMEMODE.Vars.tempostart = tobool(net.ReadBit())
	GAMEMODE.Vars.mute = tobool(net.ReadBit())
	GAMEMODE.Vars.overfive = tobool(net.ReadBit())
	GAMEMODE.Vars.gamemode_init_done_s = tobool(net.ReadBit())

end)

net.Receive("fnafgmShowCheck", function(len)

	GAMEMODE.Vars.willviewcheck = tobool(net.ReadBit())
	local plus = tobool(net.ReadBit())

	GAMEMODE:CallEnding(plus)

end)

net.Receive("fnafgmPowerUpdate", function(len)

	GAMEMODE.Vars.power = net.ReadInt(20)
	GAMEMODE.Vars.powerusage = net.ReadInt(6)
	GAMEMODE.Vars.poweroff = tobool(net.ReadBit())
	GAMEMODE.Vars.powertot = net.ReadInt(16)

end)

net.Receive("fnafgmDS", function(len)

	GAMEMODE.Vars.DS = tobool(net.ReadBit())

end)

net.Receive("fnafgmCallIntro", function(len) GAMEMODE:CallIntro() end)

net.Receive("fnafgmAnimatronicsList", function(len)

	GAMEMODE.Vars.Animatronics = net.ReadTable()

end)

net.Receive("fnafgmStart", function(len)

	GAMEMODE.Vars.WillStart = net.ReadFloat()

end)

net.Receive("fnafgmAnimatronicsController", function(len)
	GAMEMODE:Monitor(true)
end)


function GM:CallIntro()
	if file.Exists("materials/" .. string.lower(GAMEMODE.ShortName) .. "/introscreen/" .. game.GetMap() .. "_" .. GetConVarString("gmod_language") .. ".vmt", "GAME") then
		GAMEMODE.Vars.IntroScreen = string.lower(GAMEMODE.ShortName) .. "/introscreen/" .. game.GetMap() .. "_" .. GetConVarString("gmod_language")
	elseif file.Exists("materials/" .. string.lower(GAMEMODE.ShortName) .. "/introscreen/" .. game.GetMap() .. "_en.vmt", "GAME") then
		GAMEMODE.Vars.IntroScreen = string.lower(GAMEMODE.ShortName) .. "/introscreen/" .. game.GetMap() .. "_en"
	elseif file.Exists("materials/fnafgm/introscreen/" .. game.GetMap() .. "_" .. GetConVarString("gmod_language") .. ".vmt", "GAME") then
		GAMEMODE.Vars.IntroScreen = "fnafgm/introscreen/" .. game.GetMap() .. "_" .. GetConVarString("gmod_language")
	elseif file.Exists("materials/fnafgm/introscreen/" .. game.GetMap() .. "_en.vmt", "GAME") then
		GAMEMODE.Vars.IntroScreen = "fnafgm/introscreen/" .. game.GetMap() .. "_en"
	end
end


function GM:CallEnding(plus)

	local add = ""

	if plus then
		add = "_6"
	end

	if file.Exists("materials/" .. string.lower(GAMEMODE.ShortName) .. "/endscreen/" .. game.GetMap() .. "_" .. GetConVarString("gmod_language") .. add .. ".vmt", "GAME") then
		GAMEMODE.Vars.EndScreen = string.lower(GAMEMODE.ShortName) .. "/endscreen/" .. game.GetMap() .. "_" .. GetConVarString("gmod_language") .. add
	elseif file.Exists("materials/" .. string.lower(GAMEMODE.ShortName) .. "/endscreen/" .. game.GetMap() .. "_en" .. add .. ".vmt", "GAME") then
		GAMEMODE.Vars.EndScreen = string.lower(GAMEMODE.ShortName) .. "/endscreen/" .. game.GetMap() .. "_en" .. add
	elseif file.Exists("materials/fnafgm/endscreen/" .. game.GetMap() .. "_" .. GetConVarString("gmod_language") .. add .. ".vmt", "GAME") then
		GAMEMODE.Vars.EndScreen = "fnafgm/endscreen/" .. game.GetMap() .. "_" .. GetConVarString("gmod_language") .. add
	elseif file.Exists("materials/fnafgm/endscreen/" .. game.GetMap() .. "_en" .. add .. ".vmt", "GAME") then
		GAMEMODE.Vars.EndScreen = "fnafgm/endscreen/" .. game.GetMap() .. "_en" .. add
	end

end


function GM:HUDPaint()

	if GetConVarNumber("cl_drawhud") == 0 then return end

	hook.Run("HUDDrawTargetID")
	if fnafgm_sandbox_enable:GetBool() then
		hook.Run("HUDDrawPickupHistory")
		hook.Run("DrawDeathNotice", 0.85, 0.04)
	end

	local client = LocalPlayer()

	if GAMEMODE.Vars.b87 then return end

	local H = 46
	if client:Team() != TEAM_UNASSIGNED then

		if GAMEMODE.Vars.nightpassed or GAMEMODE.Vars.gameend then

			draw.DrawText(GAMEMODE.Vars.time .. " " .. GAMEMODE.Vars.AMPM, "FNAFGMCH", ScrW() * 0.515, ScrH() * 0.410, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)

		elseif !GAMEMODE.Vars.startday then

			local time = math.Truncate((GAMEMODE.Vars.WillStart or -1) - CurTime())

			if time >= 0 then
				if time <= 0 then time = 0 end
				draw.DrawText((GAMEMODE.TranslatedStrings.nightwillstart or GAMEMODE.Strings.en.nightwillstart) .. " " .. time .. "s", "FNAFGMTIME", ScrW() / 2, ScrH() * 0.2, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)
				draw.DrawText((GAMEMODE.TranslatedStrings.tonight or GAMEMODE.Strings.en.tonight) .. " " .. (GAMEMODE.Vars.night or 0) + 1, "FNAFGMNIGHT", ScrW() / 2, ScrH() * 0.25, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)
			else
				draw.DrawText((GAMEMODE.TranslatedStrings.tonight or GAMEMODE.Strings.en.tonight) .. " " .. (GAMEMODE.Vars.night or 0) + 1, "FNAFGMNIGHT", ScrW() - 64, H + 64, GAMEMODE.Colors_default, TEXT_ALIGN_RIGHT)
			end

			if client:Team() == 2 then
				draw.DrawText(string.upper(GAMEMODE.TranslatedStrings.startanimatronics or GAMEMODE.Strings.en.startanimatronics), "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.4, Color(170, 0, 0, 255), TEXT_ALIGN_CENTER)
			end

		elseif !GAMEMODE.Vars.tempostart then

			if game.GetMap() == "fnaf4house" or game.GetMap() == "fnaf4noclips" or game.GetMap() == "fnaf4versus" then

				if (GAMEMODE.Vars.Halloween or (GetConVar("fnafgm_forceseasonalevent") ~= nil and GetConVar("fnafgm_forceseasonalevent"):GetInt() == 3)) then
					GAMEMODE.Vars.time = math.random(1, 12)
					if math.random(0, 10000) < 5000 then
						GAMEMODE.Vars.AMPM = "PM"
					elseif math.random(0, 10000) > 5000 then
						GAMEMODE.Vars.AMPM = "AM"
					else
						GAMEMODE.Vars.time = 666
						GAMEMODE.Vars.AMPM = ""
					end
				end

				draw.DrawText(GAMEMODE.Vars.time .. " " .. GAMEMODE.Vars.AMPM, "FNAFGM4TIME", ScrW() - 52, H, Color(100, 100, 100, 255), TEXT_ALIGN_RIGHT)

			elseif GAMEMODE.FT == 2 and !GAMEMODE.Vars.usingsafezone then

				draw.DrawText(GAMEMODE.Vars.time .. " " .. GAMEMODE.Vars.AMPM, "FNAFGMNIGHT", ScrW() - 64, H + 32, GAMEMODE.Colors_default, TEXT_ALIGN_RIGHT)
				draw.DrawText((GAMEMODE.TranslatedStrings.night or GAMEMODE.Strings.en.night) .. " " .. GAMEMODE.Vars.night, "FNAFGMNIGHT", ScrW() - 64, H, GAMEMODE.Colors_default, TEXT_ALIGN_RIGHT)

				if GAMEMODE.Vars.power != 0 then

					draw.DrawText(GAMEMODE.TranslatedStrings.flashlight or GAMEMODE.Strings.en.flashlight, "FNAFGMTXT", 128, 64 + 12, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)

					local idsb = 5

					local powersb = GAMEMODE.Vars.powertot / 5
					if powersb / 2 >= GAMEMODE.Vars.power then
						idsb = 1
					elseif powersb >= GAMEMODE.Vars.power then
						idsb = 1
					elseif powersb * 2 >= GAMEMODE.Vars.power then
						idsb = 2
					elseif powersb * 3 >= GAMEMODE.Vars.power then
						idsb = 3
					elseif powersb * 4 >= GAMEMODE.Vars.power then
						idsb = 4
					end

					if powersb / 2 <= GAMEMODE.Vars.power or math.fmod(math.Round(CurTime()), 2) == 0 then

						local usagetexture = {
							texture = surface.GetTextureID(GAMEMODE.Materials_battery .. idsb),
							color	= Color(255, 255, 255, 255),
							x 	= 64,
							y 	= H + 54,
							w 	= 128,
							h 	= 64
						}

						draw.TexturedQuad(usagetexture)

					end

				end

			elseif GAMEMODE.FT != 2 and (client:Team() != 1 or (!GAMEMODE.Vars.poweroff and client:Alive()) or (!game.SinglePlayer() and !client:Alive() and !GAMEMODE.Vars.poweroff)) then

				local time = GAMEMODE.Vars.time
				local AMPM = GAMEMODE.Vars.AMPM
				local night = GAMEMODE.Vars.night
				local nighttxt = GAMEMODE.TranslatedStrings.night or GAMEMODE.Strings.en.night
				local power = GAMEMODE.Vars.power
				local powerusage = GAMEMODE.Vars.powerusage
				local powerhs = ScrH() - H
				if fnafgm_sandbox_enable:GetBool() then
					powerhs = ScrH() / 2 - H / 2
				end

				if (GAMEMODE.Vars.AprilFool or (GetConVar("fnafgm_forceseasonalevent") ~= nil and GetConVar("fnafgm_forceseasonalevent"):GetInt() == 2)) then
					powerusage = math.random(1, 6)
				end

				if (GAMEMODE.Vars.Halloween or (GetConVar("fnafgm_forceseasonalevent") ~= nil and GetConVar("fnafgm_forceseasonalevent"):GetInt() == 3)) then
					power = math.random(1, 100)
					powerusage = math.random(1, 6)
					time = math.random(1, 12)
					night = 666
					if math.random(0, 10000) < 5000 then
						AMPM = "PM"
						nighttxt = "Day"
					elseif math.random(0, 10000) > 5000 then
						AMPM = "AM"
						nighttxt = "Night"
					else
						time = 666
						AMPM = ""
						nighttxt = ""
						night = "IT'S ME"
						power = 666
						powerusage = 666
					end
				end

				draw.DrawText(time .. " " .. AMPM, "FNAFGMTIME", ScrW() - 52, H, GAMEMODE.Colors_default, TEXT_ALIGN_RIGHT)
				draw.DrawText(nighttxt .. " " .. night, "FNAFGMNIGHT", ScrW() - 64, H + 64, GAMEMODE.Colors_default, TEXT_ALIGN_RIGHT)

				if power != 0 then draw.DrawText((GAMEMODE.TranslatedStrings.powerleft or GAMEMODE.Strings.en.powerleft) .. power .. "%", "FNAFGMNIGHT", 64, powerhs - 64, GAMEMODE.Colors_default, TEXT_ALIGN_LEFT) end

				if powerusage == 0 or power == 0 then

				elseif powerusage > 0 and powerusage < 7 then

					draw.DrawText(GAMEMODE.TranslatedStrings.usage or GAMEMODE.Strings.en.usage, "FNAFGMNIGHT", 64, powerhs - 24, GAMEMODE.Colors_default, TEXT_ALIGN_LEFT)

					local usagetexture = {
						texture	= surface.GetTextureID(GAMEMODE.Materials_usage .. powerusage),
						color	= Color(255, 255, 255, 255),
						x 		= 180,
						y 		= powerhs - 30,
						w 		= 128,
						h 		= 64
					}

					draw.TexturedQuad(usagetexture)

				elseif powerusage < 0 then

					draw.DrawText((GAMEMODE.TranslatedStrings.usage or GAMEMODE.Strings.en.usage) .. " ?", "FNAFGMNIGHT", 64, powerhs - 24, GAMEMODE.Colors_default, TEXT_ALIGN_LEFT)

				else

					draw.DrawText((GAMEMODE.TranslatedStrings.usage or GAMEMODE.Strings.en.usage) .. " " .. powerusage, "FNAFGMNIGHT", 64, powerhs - 24, GAMEMODE.Colors_default, TEXT_ALIGN_LEFT)

				end

			end

			if client:Team() ~= 1 or !client:Alive() and !game.SinglePlayer() then
				local alivec = 0
				for k, v in pairs(player.GetAll()) do
					if v:Alive() and v:Team() == 1 then
						alivec = alivec + 1
					end
				end
				draw.DrawText(team.GetName(1) .. ": " .. alivec .. "/" .. team.NumPlayers(1), "FNAFGMID", 46, H, GAMEMODE.Colors_default, TEXT_ALIGN_LEFT)
			end

		elseif game.GetMap() == "fnaf4house" or game.GetMap() == "fnaf4noclips" or game.GetMap() == "fnaf4versus" then

			draw.DrawText((GAMEMODE.TranslatedStrings.night or GAMEMODE.Strings.en.night) .. " " .. GAMEMODE.Vars.night, "FNAFGMA4TIME", 32, 32, GAMEMODE.Colors_default, TEXT_ALIGN_LEFT)

		else

			draw.DrawText(GAMEMODE.Vars.time .. ":00 " .. GAMEMODE.Vars.AMPM, "FNAFGMATIME", ScrW() * 0.5, ScrH() * 0.44, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)

			local suff = "th"

			if GAMEMODE.Vars.night == 1 then
				suff = "st"
			elseif GAMEMODE.Vars.night == 2 then
				suff = "nd"
			elseif GAMEMODE.Vars.night == 3 then
				suff = "rd"
			end

			draw.DrawText(GAMEMODE.Vars.night .. suff .. " " .. (GAMEMODE.TranslatedStrings.night or GAMEMODE.Strings.en.night), "FNAFGMATIME", ScrW() * 0.5, ScrH() * 0.50, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)

		end

	end

	if GAMEMODE.Vars.SGvsA and client:Team() == TEAM_UNASSIGNED and !GAMEMODE.Vars.poweroff then
		draw.DrawText(string.upper(GAMEMODE.TranslatedStrings.unassigned_SGvsA or GAMEMODE.Strings.en.unassigned_SGvsA), "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.8, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)
	elseif client:Team() == TEAM_UNASSIGNED and GAMEMODE.Vars.poweroff and game.GetMap() != "fnaf2noevents" then
		draw.DrawText(string.upper(GAMEMODE.TranslatedStrings.unassigned_powerdown or GAMEMODE.Strings.en.unassigned_powerdown), "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.48, Color(170, 0, 0, 255), TEXT_ALIGN_CENTER)
	end

	if GAMEMODE.Vars.willviewcheck and client:Team() == TEAM_UNASSIGNED then

		if game.GetMap() == "freddysnoevent" then

			draw.DrawText(client:GetName(), "FNAFGMCHECK", ScrW() / 2 - 50, ScrH() / 2 - 4, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)

		elseif game.GetMap() == "fnaf2noevents" and !GAMEMODE.Vars.overfive then

			draw.DrawText(client:GetName(), "FNAFGMCHECK", ScrW() / 2 - 50, ScrH() / 2 - 50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)

		elseif game.GetMap() == "fnaf2noevents" then

			draw.DrawText(client:GetName(), "FNAFGMCHECK", 128, ScrH() - 370, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)

		elseif game.GetMap() == "fnap_scc" then

			draw.DrawText(client:GetName(), "FNAFGMCHECK", ScrW() / 2 - 50, ScrH() / 2 - 45, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)

		end

	end

end

hook.Add("PreDrawHalos", "fnafgmHalos", function()

	if GetConVar("fnafgm_cl_disablehalos") and GetConVar("fnafgm_cl_disablehalos"):GetBool() then return end

	local client = LocalPlayer()
	local tab = {}
	local tab2 = {}
	local tab3 = {}

	if game.GetMap() == "fnap_scc" and client:Team() == 1 and !GAMEMODE.Vars.startday and !GAMEMODE.Vars.nightpassed and !GAMEMODE.Vars.gameend then

		local BoxCorner = Vector(-313, -408, 0)
		local OppositeCorner = Vector(-374, -371, -70)

		for k,v in pairs(ents.FindInBox(BoxCorner,OppositeCorner)) do
			if v:GetClass() == "prop_dynamic" then
				table.insert(tab, v)
			end
		end

		halo.Add(tab, GAMEMODE.Colors_surl, 1, 1, 1, true, true)

	end

	if client:Team() == 2 then

		for k,v in pairs(player.GetAll()) do
			if v:Team() == 1 and client:Alive() and v:Alive() then
				table.insert(tab, v)
			end
		end

		for k,v in pairs(ents.FindByClass("fnafgm_animatronic")) do
			if client:Alive() then
				table.insert(tab2, v)
			end
		end

		halo.Add(tab, Color(170, 0, 0), 1, 1, 1, true, true)
		halo.Add(tab2, Color(85, 85, 85), 1, 1, 1, true, true)

	end

	if client:Team() == TEAM_SPECTATOR then

		for k,v in pairs(player.GetAll()) do
			if v:Team() == 1 and v:Alive() then
				table.insert(tab, v)
			end
		end

		for k,v in pairs(player.GetAll()) do
			if v:Team() == 2 and v:Alive() then
				table.insert(tab2, v)
			end
		end

		for k,v in pairs(ents.FindByClass("fnafgm_animatronic")) do
			table.insert(tab3, v)
		end

		halo.Add(tab, team.GetColor(1), 1, 1, 1, true, true)
		halo.Add(tab2, team.GetColor(2), 1, 1, 1, true, true)
		halo.Add(tab3, team.GetColor(2), 1, 1, 1, true, true)

	end

end )


hook.Add("HUDPaint", "fnafgmInfo", function()

	if GetConVarNumber("cl_drawhud") == 0 then return end

	if !fnafgm_cl_hideversion:GetBool() then

		if GetConVar("fnafgm_forceseasonalevent") ~= nil and GetConVar("fnafgm_forceseasonalevent"):GetInt() == 2 then
			GAMEMODE.Vars.seasonaltext = " - April Fool"
		elseif GetConVar("fnafgm_forceseasonalevent") ~= nil and GetConVar("fnafgm_forceseasonalevent"):GetInt() == 3 then
			GAMEMODE.Vars.seasonaltext = " - Halloween"
		elseif GetConVar("fnafgm_forceseasonalevent") ~= nil and GetConVar("fnafgm_forceseasonalevent"):GetInt() == 4 then
			GAMEMODE.Vars.seasonaltext = " - Christmas"
		elseif !GAMEMODE.Vars.AprilFool and !GAMEMODE.Vars.Halloween and !GAMEMODE.Vars.Christmas and GetConVar("fnafgm_forceseasonalevent") ~= nil and GetConVar("fnafgm_forceseasonalevent"):GetInt() == 0 then
			GAMEMODE.Vars.seasonaltext = ""
		end

		draw.DrawText((GAMEMODE.ShortName or "?") .. " V" .. (GAMEMODE.Version or "?") .. (GAMEMODE.Vars.modetext or "") .. (GAMEMODE.Vars.seasonaltext or ""), "Trebuchet24", ScrW() - 8, ScrH() - 28, Color(100, 100, 100, 255), TEXT_ALIGN_RIGHT)


	end

	if game.GetMap() == "freddys" or game.GetMap() == "fnaf2" or game.GetMap() == "fnaf_freddypizzaevents" then
		draw.DrawText("Sorry but this map is not supported anymore.", "DermaLarge", ScrW() * 0.5, ScrH() - 64, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
	elseif game.GetMap() == "fnaf4versus" then
		draw.DrawText("Sorry but this map is not supported for now.", "DermaLarge", ScrW() * 0.5, ScrH() - 64, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
	elseif game.GetMap() == "fnaf2noevents" or game.GetMap() == "fnaf3" or game.GetMap() == "fnaf4house" or game.GetMap() == "fnaf4noclips" then
		draw.DrawText("Sorry but this map doesn't have events for now.", "DermaLarge", ScrW() * 0.5, ScrH() - 64, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER)
	end

	if (GAMEMODE.Vars.AprilFool or (GetConVar("fnafgm_forceseasonalevent") ~= nil and GetConVar("fnafgm_forceseasonalevent"):GetInt() == 2)) and (game.GetMap() == "freddys" or game.GetMap() == "freddysnoevent") then
		cam.Start3D(EyePos(), EyeAngles())
			render.SetMaterial(Material("fnafgm/troll"))
			render.DrawSprite(Vector(-78, -1052, 145), 50, 50, GAMEMODE.Colors_default)
		cam.End3D()
	end

end)


function GM:OnPlayerChat(player, strText, bTeamOnly, bPlayerIsDead)

	local tab = {}


	if bPlayerIsDead then
		table.insert(tab, Color(255, 30, 40))
		table.insert(tab, "*DEAD* ")
	end

	if bTeamOnly then
		table.insert(tab, Color(30, 160, 40))
		table.insert(tab, "(TEAM) ")
	end

	if IsValid(player) then
		local rankid = player:GetNWInt("XperidiaRank", 0)
		local rankname = player:GetNWString("XperidiaRankName", "<Unknown rank name>")
		local rankcolor = player:GetNWString("XperidiaRankColor", "255 255 255 255")
		if rankid > 0 then
			table.insert(tab, string.ToColor(rankcolor))
			table.insert(tab, "{Xperidia " .. rankname .. "} ")
		end
		if player:GetUserGroup() != "user" then
			table.insert(tab, Color(255, 255, 255))
			table.insert(tab, "[" .. string.upper(string.sub(player:GetUserGroup(), 1, 1)) .. string.sub(player:GetUserGroup(), 2) .. "] ")
		end
		table.insert(tab, player)
	else
		table.insert(tab, "Console")
	end

	table.insert(tab, GAMEMODE.Colors_defaultchat)
	table.insert(tab, ": " .. strText)

	chat.AddText(unpack(tab))

	if fnafgm_cl_chatsound:GetBool() then chat.PlaySound() end
	if fnafgm_cl_flashwindow:GetBool() then system.FlashWindow() end

	return true

end


function GM:RenderScreenspaceEffects()
	local client = LocalPlayer()
	if client:Team() == 1 and IsValid(GAMEMODE.Vars.Monitor) and game.GetMap() == "freddysnoevent" and GAMEMODE.Vars.lastcam == 11 then
		local colormod = {
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 0,
			[ "$pp_colour_addb" ] = 0,
			[ "$pp_colour_brightness" ] = 0,
			[ "$pp_colour_contrast" ] = 0,
			[ "$pp_colour_colour" ] = 0,
			[ "$pp_colour_mulr" ] = 0,
			[ "$pp_colour_mulg" ] = 0,
			[ "$pp_colour_mulb" ] = 0
		}
		DrawColorModify(colormod)
	elseif client:Team() == 2 and !client:Alive() then
		local colormod = {
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 0,
			[ "$pp_colour_addb" ] = 0,
			[ "$pp_colour_brightness" ] = 0,
			[ "$pp_colour_contrast" ] = 0.1,
			[ "$pp_colour_colour" ] = 0,
			[ "$pp_colour_mulr" ] = 0,
			[ "$pp_colour_mulg" ] = 0,
			[ "$pp_colour_mulb" ] = 0
		}
		DrawColorModify(colormod)
	end
	if IsValid(FNaFView) and !IsValid(GAMEMODE.Vars.Monitor) then
		DrawToyTown(1, ScrH() / 4)
	end
	if GAMEMODE.Vars.Jumpscare then
		DrawMaterialOverlay(GAMEMODE.Vars.Jumpscare, 0)
	end
	if client:Team() == 1 and IsValid(GAMEMODE.Vars.Monitor) and (GAMEMODE.Vars.VideoLoss or 0) == GAMEMODE.Vars.lastcam then
		DrawMaterialOverlay(GAMEMODE.Materials_static, 0)
	end
	if client:Team() == 1 and IsValid(GAMEMODE.Vars.Monitor) then
		DrawMaterialOverlay(GAMEMODE.Materials_camstatic, 0)
	end
	if client:Team() == 1 and IsValid(GAMEMODE.Vars.Monitor) and client:GetViewEntity().GetCamID and (client:GetViewEntity():GetCamID() != GAMEMODE.Vars.lastcam or (GAMEMODE.Vars.stempo or 0) > CurTime()) then
		DrawMaterialOverlay(GAMEMODE.Materials_switch, 0)
		if client:GetViewEntity():GetCamID() != GAMEMODE.Vars.lastcam then GAMEMODE.Vars.stempo = CurTime() + 0.1 end
	end
	if client:Team() == 2 and IsValid(GAMEMODE.Vars.Monitor) then
		DrawMaterialOverlay(GAMEMODE.Materials_animatronicsvision, 0)
	end
	if client:Team() == TEAM_UNASSIGNED and GAMEMODE.Vars.IntroScreen then
		DrawMaterialOverlay(GAMEMODE.Vars.IntroScreen, 0)
	end
	if client:Team() == TEAM_UNASSIGNED and GAMEMODE.Vars.EndScreen then
		DrawMaterialOverlay(GAMEMODE.Vars.EndScreen, 0)
	end
	if GAMEMODE.Vars.b87 then
		DrawMaterialOverlay(GAMEMODE.Materials_goldenfreddy, 0)
	end
end


function GM:JumpscareOverlay(jumpscare,dur)

	if file.Exists("materials/" .. jumpscare .. ".vmt", "GAME") then

		GAMEMODE.Vars.Jumpscare = jumpscare

		if timer.Exists("fnafgmJumpscareReset") then

			timer.Adjust("fnafgmJumpscareReset", dur or GetConVar("fnafgm_deathscreendelay"):GetInt() or 1, 1, function()

				GAMEMODE.Vars.Jumpscare = nil

				timer.Remove("fnafgmJumpscareReset")

			end)

		else

			timer.Create("fnafgmJumpscareReset", dur or GetConVar("fnafgm_deathscreendelay"):GetInt() or 1, 1, function()

				GAMEMODE.Vars.Jumpscare = nil

				timer.Remove("fnafgmJumpscareReset")

			end)

		end

	end

end


function GM:VideoLoss()

	GAMEMODE.Vars.VideoLoss = GAMEMODE.Vars.lastcam

	LocalPlayer():EmitSound("fnafgm_garble" .. math.random(1, 3))

	if timer.Exists("fnafgmVideoLoss") then

		timer.Adjust("fnafgmVideoLoss", 5, 1, function()

			GAMEMODE.Vars.VideoLoss = nil

			timer.Remove("fnafgmVideoLoss")

		end)

	else

		timer.Create("fnafgmVideoLoss", 5, 1, function()

			GAMEMODE.Vars.VideoLoss = nil

			timer.Remove("fnafgmVideoLoss")

		end)

	end

end


local undomodelblend = false
local matWhite = Material("models/debug/debugwhite")

function GM:PrePlayerDraw(ply)
	if ply:Team() != 1 or ply == LocalPlayer() then return end
	local radius = 10
	if radius > 0 then
		local eyepos = EyePos()
		local dist = ply:NearestPoint(eyepos):Distance(eyepos)
		if dist < radius then
			local blend = math.max((dist / radius) ^ 1.4, 0.04)
			render.SetBlend(blend)
			if blend < 0.4 then
				render.ModelMaterialOverride(matWhite)
				render.SetColorModulation(0.2, 0.2, 0.2)
			end
			undomodelblend = true
		end
	end
end

function GM:PostPlayerDraw(ply)
	if undomodelblend then
		render.SetBlend(1)
		render.ModelMaterialOverride()
		render.SetColorModulation(1, 1, 1)
		undomodelblend = false
	end
end


function GM:ShowTeam()

	if !IsValid(self.TeamSelectFrame) then

		-- Simple team selection box
		self.TeamSelectFrame = vgui.Create("DFrame")
		self.TeamSelectFrame:SetTitle("Pick Team")

		local AllTeams = team.GetAllTeams()
		local x = 4
		local y = 284
		for ID, TeamInfo in pairs ( AllTeams ) do

			if ID != TEAM_CONNECTING && ID != TEAM_UNASSIGNED then

				local Team = vgui.Create("DButton", self.TeamSelectFrame)
				function Team.DoClick() self:HideTeam() RunConsoleCommand("changeteam", ID) end
				Team:SetPos(x, 24)
				Team:SetSize(256, 256)
				Team:SetText(TeamInfo.Name)
				Team:SetTextColor(TeamInfo.Color)
				Team:SetFont("FNAFGMID")

				if IsValid(LocalPlayer()) && LocalPlayer():Team() == ID then
					Team:SetDisabled(true)
					Team:SetTextColor(Color(40, 40, 40))
					Team.Paint = function(self, w, h)
						draw.RoundedBox(4, 4, 4, w-8, h-8, Color(0, 0, 0, 150))
					end
				else
					Team:SetTextColor(TeamInfo.Color)
					Team.Paint = function(self, w, h)
						draw.RoundedBox(4, 4, 4, w-8, h-8, Color(255, 255, 255, 150))
					end
				end

				x = x + 256

			end

		end

		if GAMEMODE.AllowAutoTeam then

			local Team = vgui.Create("DButton", self.TeamSelectFrame)
			function Team.DoClick() self:HideTeam() RunConsoleCommand("autoteam") end
			Team:SetPos(4 + x / 3, 280)
			Team:SetSize(x / 3 - 4, 32)
			Team:SetText("Auto")
			Team:SetTextColor(GAMEMODE.Colors_default)
			Team:SetFont("FNAFGMTXT")
			Team.Paint = function(self, w, h)
				draw.RoundedBox(4, 4, 4, w - 8, h - 8, Color(255, 255, 255, 150))
			end

			y = y + 32

		end

		self.TeamSelectFrame:SetSize(x + 4, y)
		self.TeamSelectFrame:SetDraggable(true)
		self.TeamSelectFrame:SetScreenLock(true)
		self.TeamSelectFrame:SetPaintShadow(true)
		self.TeamSelectFrame:Center()
		self.TeamSelectFrame:MakePopup()
		self.TeamSelectFrame:SetKeyboardInputEnabled(false)
		self.TeamSelectFrame.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 128))
		end

	else
		self.TeamSelectFrame:Close()
	end

end


net.Receive("fnafgmMapSelect", function(len)
	GAMEMODE:MapSelect(net.ReadTable())
end)

function GM:MapSelect(AvMaps)

	if IsValid(MapSelectF) then return end

	MapSelectF = vgui.Create("DFrame")
	MapSelectF:SetTitle("Map select")

	local AllMaps = GAMEMODE.MapList
	local num = 0
	for ID, Map in pairs(AllMaps) do
		num = num + 1
	end
	local calc = math.Clamp(256 * 3 / num, 100, 256 )
	local size = calc
	local x = 4
	local mx = size
	local y = size + 24
	local n = 0
	local nmax = math.Clamp(math.ceil(num / 1.5), 3, 5)

	for ID, Map in SortedPairsByValue(AllMaps) do

		n = n + 1
		if n == nmax then
			n = 1
			y = y + size
			x = 4 + size
		else
			x = x + size
			if x > mx then mx = x end
		end

		local MapI = vgui.Create("DButton", MapSelectF)
		MapI:SetPos(x - size, y - size)
		MapI:SetSize(size, size)
		MapI:SetText(Map)
		MapI:SetContentAlignment(2)
		MapI:SetFont("FNAFGMID")
		MapI:SetTextColor(Color(255, 255, 255, 0))

		local png
		local path = "maps/" .. ID .. ".png"
		if file.Exists(path, "GAME") then
			png = Material(path, "noclamp smooth")
			MapI.OnCursorEntered = function()
				MapI:SetTextColor(Color(255, 255, 255, 255))
			end
			MapI.OnCursorExited = function()
				MapI:SetTextColor(Color(255, 255, 255, 0))
			end
		else
			local path = "maps/thumb/" .. ID .. ".png"
			if file.Exists(path, "GAME") then
				png = Material(path, "noclamp smooth")
				MapI.OnCursorEntered = function()
					MapI:SetTextColor(Color(255, 255, 255, 255))
				end
				MapI.OnCursorExited = function()
					MapI:SetTextColor(Color( 255, 255, 255, 0))
				end
			else
				png = Material("maps/thumb/noicon.png", "noclamp smooth")
				MapI:SetTextColor(Color(255, 255, 255))
			end
		end

		if game.GetMap() == ID then
			MapI.Paint = function(self, w, h)
				surface.SetMaterial(png)
				surface.SetDrawColor(85, 85, 85, 255)
				surface.DrawTexturedRect(0, 0, size, size)
			end
		elseif !AvMaps[ID] then
			MapI:SetTextColor(Color(255, 0, 0))
			MapI.Paint = function(self, w, h)
				surface.SetMaterial(png)
				surface.SetDrawColor(128, 64, 64, 255)
				surface.DrawTexturedRect(0, 0, size, size)
			end
			if GAMEMODE.MapListLinks[ID] then
				function MapI.DoClick()
					gui.OpenURL(GAMEMODE.MapListLinks[ID])
				end
			end
		else
			MapI.Paint = function( self, w, h )
				surface.SetMaterial(png)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawTexturedRect(0, 0, size, size)
			end
			function MapI.DoClick()
				fnafgmChangeMap(ID)
			end
		end

	end

	MapSelectF:SetSize(mx + 4, y + 4)
	MapSelectF:SetDraggable(true)
	MapSelectF:SetScreenLock(true)
	MapSelectF:SetPaintShadow(true)
	MapSelectF:Center()
	MapSelectF:MakePopup()
	MapSelectF:SetKeyboardInputEnabled(false)
	MapSelectF.Paint = function(self, w, h)
		Derma_DrawBackgroundBlur(self)
		draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 128))
	end

end


function fnafgmSetView(id)
	net.Start("fnafgmSetView")
		net.WriteFloat(id)
	net.SendToServer()
end

function fnafgmMuteCall()
	net.Start("fnafgmMuteCall")
	net.SendToServer()
end

function fnafgmSafeZone()
	net.Start("fnafgmSafeZone")
	net.SendToServer()
end

function fnafgmShutLights()
	net.Start("fnafgmShutLights")
	net.SendToServer()
end

function fnafgmUseLight(id)
	net.Start("fnafgmUseLight")
		net.WriteFloat(id)
	net.SendToServer()
end

function fnafgmChangeMap(map)
	net.Start("fnafgmChangeMap")
		net.WriteString(map)
	net.SendToServer()
end

function fnafgmCamLight(id, rstate)
	net.Start("fnafgmCamLight")
		net.WriteFloat(id)
		net.WriteBool(rstate)
	net.SendToServer()
end

net.Receive("fnafgmNotif", function(len)

	local str = net.ReadString() or ""
	local ne = net.ReadInt(3) or 0
	local dur = net.ReadFloat() or 5
	local sound = net.ReadBit() or false

	if GAMEMODE.TranslatedStrings[str] or GAMEMODE.Strings.en[str] then
		str = GAMEMODE.TranslatedStrings[str] or GAMEMODE.Strings.en[str]
	end

	fnafgmNotif(str,ne,dur,sound)

end)
function fnafgmNotif(str, ne, dur, sound)
	notification.AddLegacy(str, ne, dur, sound)
	if !tobool(sound) then return end
	if ne == NOTIFY_HINT then
		surface.PlaySound("ambient/water/drip" .. math.random(1, 4) .. ".wav")
	elseif ne == NOTIFY_ERROR then
		surface.PlaySound("buttons/button10.wav")
	else
		chat.PlaySound()
	end

	if fnafgm_cl_flashwindow:GetBool() then system.FlashWindow() end
end

function GM:SetAnimatronicPos(a, apos)

	net.Start("fnafgmSetAnimatronicPos")
		net.WriteInt(a, 6)
		net.WriteInt(apos, 6)
	net.SendToServer()

end

function GM:AnimatronicTaunt(a)

	net.Start("fnafgmAnimatronicTaunt")
		net.WriteInt(a, 5)
	net.SendToServer()

end

net.Receive("fnafgmAnimatronicTauntSnd", function(len)

	local ply = LocalPlayer()

	if ply:Team() == TEAM_CONNECTING or ply:Team() == TEAM_UNASSIGNED then return end

	local a = net.ReadInt(5)

	if GAMEMODE.Vars.Animatronics[a][1] then LocalPlayer():EmitSound("fnafgm_" .. a .. "_" .. math.random(1, #GAMEMODE.Sound_Animatronic[a])) end

end)

function GM:SpawnMenuEnabled()
	return fnafgm_sandbox_load_spawn_menu:GetBool() or fnafgm_sandbox_enable:GetBool()
end

function GM:SpawnMenuOpen()
	return fnafgm_sandbox_enable:GetBool()
end

function GM:ContextMenuOpen()
	return true
end

function GM:OnContextMenuOpen()
	if fnafgm_sandbox_enable:GetBool() then
		SandboxClass.OnContextMenuOpen(self)
	else
		RunConsoleCommand("playermodel_selector")
	end
end
