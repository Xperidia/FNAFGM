--[[---------------------------------------------------------

	Five Nights at Freddy's Gamemode for Garry's Mod
			by VickyFrenzy@Xperidia (2015-2025)

	"Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]

AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_voice.lua")
AddCSLuaFile("cl_fnafview.lua")
AddCSLuaFile("cl_menu.lua")
AddCSLuaFile("cl_keypad.lua")
AddCSLuaFile("cl_monitor_shared.lua")

include("shared.lua")

resource.AddWorkshop("363563548")

if player_manager.AllValidModels()["Guard_01"] then -- Use http://steamcommunity.com/sharedfiles/filedetails/?id=169011381 if available
	resource.AddWorkshop("169011381")
end

DEFINE_BASECLASS("gamemode_base")
local SandboxClass = baseclass.Get("gamemode_sandbox")
DeriveGamemode("sandbox")

util.AddNetworkString("fnafgmVarsUpdate")
util.AddNetworkString("fnafgmShowCheck")
util.AddNetworkString("fnafgmSetView")
util.AddNetworkString("fnafgmMuteCall")
util.AddNetworkString("fnafgmSafeZone")
util.AddNetworkString("fnafgmShutLights")
util.AddNetworkString("fnafgmUseLight")
util.AddNetworkString("fnafgmMapSelect")
util.AddNetworkString("fnafgmChangeMap")
util.AddNetworkString("fnafgmDS")
util.AddNetworkString("fnafgmNotif")
util.AddNetworkString("fnafgmSecurityTablet")
util.AddNetworkString("fnafgmCloseTablet")
util.AddNetworkString("fnafgmCallIntro")
util.AddNetworkString("fnafgmAnimatronicsController")
util.AddNetworkString("fnafgmAnimatronicsList")
util.AddNetworkString("fnafgmPowerUpdate")
util.AddNetworkString("fnafgmTabUsed")
util.AddNetworkString("fnafgmfnafViewActive")
util.AddNetworkString("fnafgmSetAnimatronicPos")
util.AddNetworkString("fnafgmAnimatronicTaunt")
util.AddNetworkString("fnafgmAnimatronicTauntSnd")
util.AddNetworkString("fnafgmCamLight")
util.AddNetworkString("fnafgmStart")
util.AddNetworkString("fnafgm_keypad")
util.AddNetworkString("fnafgm_password_input")

function GM:PlayerNoClip(pl, on)
	if pl:InVehicle() then return false end
	if game.SinglePlayer() then return true end
	if fnafgmPlayerCanByPass(pl, "noclip") then return true end
end

function GM:PlayerSpawn(ply)
	if ply:GetViewEntity() ~= ply then ply:SetViewEntity(ply) end

	if ply:Team() == TEAM_UNASSIGNED or ply:Team() == TEAM_SPECTATOR then
		ply:SetPos(ply:GetPos() + Vector(0, 0, 32))
	end

	fnafgmVarsUpdate()

	if ply:Team() == 1 or ply:Team() == 2 then
		player_manager.SetPlayerClass(ply, team.GetClass(ply:Team())[1])
	end

	if fnafgm_sandbox_enable:GetBool() and ply:Team() == 1 then
		SandboxClass.PlayerSpawn(self, ply)
		ply:Give("fnafgm_securitytablet")
	elseif fnafgm_sandbox_enable:GetBool() and ply:Team() == 2 then
		SandboxClass.PlayerSpawn(self, ply)
		ply:Give("fnafgm_animatronic_controller")
	else
		BaseClass.PlayerSpawn(self, ply)
	end

	if fnafgmPlayerCanByPass(ply, "run") then ply:SetRunSpeed(400) end
	if fnafgmPlayerCanByPass(ply, "jump") then ply:SetJumpPower(200) end

	if ply:Team() ~= TEAM_UNASSIGNED then ply:ConCommand("pp_mat_overlay ''") end

	if ply:Team() ~= TEAM_UNASSIGNED then
		if not GAMEMODE.MapList[game.GetMap()] then
			GAMEMODE:MapSelect(ply)
		else
			ply:SendLua("fnafgmWarn()")
		end
	end

	if GAMEMODE.Vars.b87 then
		ply:SendLua([[LocalPlayer():EmitSound("fnafgm_scream2")]])
		GAMEMODE.Vars.norespawn = true
		local userid = ply:UserID()
		timer.Create("fnafgm87" .. userid, 20, 1, function()
			if IsValid(ply) and (not ply:IsListenServerHost() and not fnafgmPlayerCanByPass(ply, "debug")) then
				ply:Kick("'87")
			end
			timer.Remove("fnafgm87" .. userid)
		end)
	end

	if ply:Team() == 1 or ply:Team() == 2 then
		ply:SetRenderMode(RENDERMODE_NORMAL)
		ply:SetMoveType(MOVETYPE_WALK)
	elseif ply:Team() == TEAM_SPECTATOR then
		ply:SetMoveType(MOVETYPE_NOCLIP)
	end

	if fnafgm_timethink_autostart:GetBool() and not fnafgm_sandbox_enable:GetBool() and ply:Team() == 1 and not timer.Exists("fnafgmStart") and not GAMEMODE.Vars.startday and not GAMEMODE.Vars.tempostart and GAMEMODE.MapList[game.GetMap()] then
		if not game.SinglePlayer() then
			local delay = fnafgm_timethink_autostartdelay:GetFloat()
			net.Start("fnafgmStart")
			net.WriteFloat(CurTime() + delay)
			net.Broadcast()
			timer.Create("fnafgmStart", delay, 1, function() GAMEMODE:StartNight(ply) end)
		else
			timer.Create("fnafgmStart", 0.02, 1, function() GAMEMODE:StartNight(ply) end)
		end
	elseif timer.Exists("fnafgmStart") then
		net.Start("fnafgmStart")
		net.WriteFloat(CurTime() + timer.TimeLeft("fnafgmStart"))
		net.Broadcast()
	end

	local userid = ply:UserID()
	if GAMEMODE.Vars.startday and not GAMEMODE.Vars.tempostart and not GAMEMODE.Vars.nightpassed and not GAMEMODE.Vars.gameend and ply:Team() == 1 and GAMEMODE.FNaFView[game.GetMap()] then
		if GAMEMODE.FNaFView[game.GetMap()][1] then ply:SetPos(GAMEMODE.FNaFView[game.GetMap()][1]) end
		if GAMEMODE.FNaFView[game.GetMap()][2] then ply:SetEyeAngles(GAMEMODE.FNaFView[game.GetMap()][2]) end
		timer.Create("fnafgmTempoFNaFView" .. userid, 0.1, 1, function()
			if IsValid(ply) then
				GAMEMODE:GoFNaFView(ply, true)
				if GAMEMODE.FNaFView[game.GetMap()][1] then ply:SetPos(GAMEMODE.FNaFView[game.GetMap()][1]) end
				if GAMEMODE.FNaFView[game.GetMap()][2] then ply:SetEyeAngles(GAMEMODE.FNaFView[game.GetMap()][2]) end
			end

			timer.Remove("fnafgmTempoFNaFView" .. userid)
		end)
	end

	if ply:Team() == 2 then
		timer.Create("fnafgmTempoAC" .. userid, 0.1, 1, function()
			if IsValid(ply) and ply:Team() == 2 then
				net.Start("fnafgmAnimatronicsController")
				net.Send(ply)
			end

			timer.Remove("fnafgmTempoAC" .. userid)
		end)
	end
end

function GM:PlayerShouldTakeDamage(ply, attacker)
	if game.SinglePlayer() then return true end

	-- No player vs player damage
	if attacker:IsValid() and attacker:IsPlayer() and ply:Team() == attacker:Team() and not fnafgmPlayerCanByPass(attacker, "friendlyfire") then
		return false
	end

	if ply:Team() == 1 and attacker:GetClass() == "func_door" and fnafgm_preventdoorkill:GetBool() then
		if GAMEMODE.FNaFView[game.GetMap()][1] then
			ply:SetPos(GAMEMODE.FNaFView[game.GetMap()][1])
			return false
		else
			local doorsafe = GAMEMODE:PlayerSelectSpawn(ply):GetPos()
			ply:SetPos(doorsafe)
			return false
		end
	end

	-- Default, let the player be hurt
	return true
end

function GM:RetrieveXperidiaAccountRank(ply)
	if not IsValid(ply) then return end
	if ply:IsBot() then return end
	if not ply.XperidiaRankLastTime or ply.XperidiaRankLastTime + 3600 < SysTime() then
		local steamid = ply:SteamID64()
		GAMEMODE:Log("Retrieving the Xperidia Rank for " .. ply:GetName() .. "...", nil, true)
		http.Post("https://api.xperidia.com/account/rank/v1", {steamid = steamid},
		function(responseText, contentLength, responseHeaders, statusCode)
			if not IsValid(ply) then return end
			if statusCode == 200 then
				local rank_info = util.JSONToTable(responseText)
				if rank_info and rank_info.id then
					ply.XperidiaRank = rank_info
					ply:SetNWInt("XperidiaRank", rank_info.id)
					ply:SetNWString("XperidiaRankName", rank_info.name)
					if rank_info.color and #rank_info.color == 6 then ply:SetNWString("XperidiaRankColor", tonumber("0x" .. rank_info.color:sub(1, 2)) .. " " .. tonumber("0x" .. rank_info.color:sub(3, 4)) .. " " .. tonumber("0x" .. rank_info.color:sub(5, 6)) .. " 255") end
					ply.XperidiaRankLastTime = SysTime()
					if rank_info.id ~= 0 and rank_info.name then
						GAMEMODE:Log("The Xperidia Rank for " .. ply:GetName() .. " is " .. rank_info.name .. " (" .. rank_info.id .. ")")
					elseif rank_info.id ~= 0 then
						GAMEMODE:Log("The Xperidia Rank for " .. ply:GetName() .. " is " .. rank_info.id)
					else
						GAMEMODE:Log(ply:GetName() .. " doesn't have any Xperidia Rank...", nil, true)
					end
				end
			else
				GAMEMODE:Log("Error while retriving Xperidia Rank for " .. ply:GetName() .. " (HTTP " .. (statusCode or "?") .. ")")
			end
		end, function(errorMessage) GAMEMODE:Log(errorMessage) end)
	end
end

--[[---------------------------------------------------------
   Called once on the player's first spawn
-----------------------------------------------------------]]
function GM:PlayerInitialSpawn(ply)
	GAMEMODE:RetrieveXperidiaAccountRank(ply)
	if not ply:IsBot() then
		net.Start("fnafgmCallIntro")
		net.Send(ply)
		if not GAMEMODE.MapList[game.GetMap()] then GAMEMODE:MapSelect(ply) end
	end

	if GAMEMODE.Vars.SGvsA and not ply:IsBot() then
		ply:SetTeam(TEAM_UNASSIGNED)
		ply:ConCommand("gm_showteam")
	elseif not GAMEMODE.Vars.SGvsA and not ply:IsBot() then
		ply:SetTeam(TEAM_UNASSIGNED)
	elseif ply:IsBot() then
		ply:SetTeam(1)
	end

	fnafgmMapOverrides()
	GAMEMODE.Vars.active = true
	net.Start("fnafgmDS")
	net.WriteBit(game.IsDedicated())
	net.Send(ply)
	if GAMEMODE.Vars.Animatronics ~= {} then
		net.Start("fnafgmAnimatronicsList")
		net.WriteTable(GAMEMODE.Vars.Animatronics)
		net.Send(ply)
	end

	if not game.IsDedicated() and ply:IsListenServerHost() then ply:SetNWBool("IsListenServerHost", true) end
end

concommand.Add("fnafgm_mapselect", function(ply) GAMEMODE:MapSelect(ply) end)
function GM:MapSelect(ply)
	if not ply:IsListenServerHost() and not ply:IsAdmin() and game.GetMap() ~= "gm_construct" and game.GetMap() ~= "gm_flatgrass" then return end
	local AvMaps = {}
	for k, v in pairs(GAMEMODE.MapList) do
		if file.Exists("maps/" .. k .. ".bsp", "GAME") then
			AvMaps[k] = true
		else
			AvMaps[k] = false
		end
	end

	net.Start("fnafgmMapSelect")
	net.WriteTable(AvMaps)
	net.Send(ply)
end

function GM:ChangeMap(ply, map)
	if ply:IsListenServerHost() or ply:IsAdmin() or game.GetMap() == "gm_construct" or game.GetMap() == "gm_flatgrass" then
		GAMEMODE:Log("Map changing to " .. map .. " because of " .. ply:GetName())
		RunConsoleCommand("changelevel", map)
	else
		ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! (Not admin/host)")
		net.Start("fnafgmNotif")
		net.WriteString("Nope, you can't do that! (Not admin/host)")
		net.WriteInt(1, 3)
		net.WriteFloat(5)
		net.WriteBit(true)
		net.Send(ply)
	end
end
net.Receive("fnafgmChangeMap", function(bits, ply)
	local map = net.ReadString()
	GAMEMODE:ChangeMap(ply, map)
end)

function GM:PlayerRequestTeam(ply, teamid)
	-- No changing teams if not teambased!
	if GAMEMODE.Vars.norespawn and teamid == 1 then
		ply:ChatPrint("You can't do this now!")
		net.Start("fnafgmNotif")
		net.WriteString("You can't do this now!")
		net.WriteInt(1, 3)
		net.WriteFloat(5)
		net.WriteBit(true)
		net.Send(ply)
		return
	elseif teamid ~= 1 and game.SinglePlayer() then
		ply:ChatPrint("Not in singleplayer!")
		net.Start("fnafgmNotif")
		net.WriteString("nosp")
		net.WriteInt(1, 3)
		net.WriteFloat(5)
		net.WriteBit(true)
		net.Send(ply)
		return
	elseif not GAMEMODE.Vars.SGvsA and teamid == 2 and not fnafgmPlayerCanByPass(ply, "debug") then
		ply:ChatPrint("You're not in SGvsA mode!")
		net.Start("fnafgmNotif")
		net.WriteString("notsgvsa")
		net.WriteInt(1, 3)
		net.WriteFloat(5)
		net.WriteBit(true)
		net.Send(ply)
		return
	elseif not GAMEMODE.Vars.SGvsA and teamid == TEAM_SPECTATOR and not fnafgmPlayerCanByPass(ply, "spectator") then
		ply:ChatPrint("Nope, you can't do that! (Need spectator bypass)")
		net.Start("fnafgmNotif")
		net.WriteString("Nope, you can't do that! (Need spectator bypass)")
		net.WriteInt(1, 3)
		net.WriteFloat(5)
		net.WriteBit(true)
		net.Send(ply)
		return
	elseif teamid == TEAM_SPECTATOR and not GetConVar("mp_allowspectators"):GetBool() and not fnafgmPlayerCanByPass(ply, "spectator") then
		ply:ChatPrint("Spectator mode is disabled!")
		return
	elseif GAMEMODE.Vars.b87 then
		return
	end

	-- This team isn't joinable
	if not team.Joinable(teamid) then
		ply:ChatPrint("This is disabled!")
		return
	end

	-- This team isn't joinable
	if not GAMEMODE:PlayerCanJoinTeam(ply, teamid) then
		-- Messages here should be outputted by this function
		return
	end

	GAMEMODE:PlayerJoinTeam(ply, teamid)
end

function GM:PlayerCanJoinTeam(ply, teamid)
	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10
	if ply.LastTeamSwitch and RealTime() - ply.LastTeamSwitch < TimeBetweenSwitches then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 1
		ply:ChatPrint(Format("Please wait %i more seconds before trying to change team again", (TimeBetweenSwitches - (RealTime() - ply.LastTeamSwitch)) + 1))
		return false
	end

	-- Already on this team!
	if ply:Team() == teamid then
		ply:ChatPrint("You're already on that team")
		net.Start("fnafgmNotif")
		net.WriteString("You're already on that team")
		net.WriteInt(1, 3)
		net.WriteFloat(5)
		net.WriteBit(true)
		net.Send(ply)
		return false
	end

	-- Animatronics full!
	if teamid == 2 and team.NumPlayers(teamid) >= 4 and not fnafgmPlayerCanByPass(ply, "goldenfreddy") then
		ply:ChatPrint("Sorry this team is full!")
		net.Start("fnafgmNotif")
		net.WriteString("Sorry this team is full!")
		net.WriteInt(1, 3)
		net.WriteFloat(5)
		net.WriteBit(true)
		net.Send(ply)
		return false
	end
	return true
end

function GM:PlayerSpawnAsSpectator(pl)
	pl:StripWeapons()
	if pl:Team() == TEAM_UNASSIGNED then
		pl:Spectate(OBS_MODE_FREEZECAM)
		return
	end

	pl:SetTeam(TEAM_SPECTATOR)
	pl:Spectate(OBS_MODE_ROAMING)
end

function GM:KeyPress(ply, key)
	if GAMEMODE.Vars.SGvsA and ply:Team() == TEAM_UNASSIGNED and (ply:KeyPressed(IN_ATTACK) or ply:KeyPressed(IN_ATTACK2) or ply:KeyPressed(IN_JUMP)) and not GAMEMODE.Vars.norespawn then
		ply:ConCommand("gm_showteam")
	elseif not GAMEMODE.Vars.SGvsA and ply:Team() == TEAM_UNASSIGNED and not ply:KeyPressed(IN_SCORE) and not GAMEMODE.Vars.b87 and not GAMEMODE.Vars.norespawn then
		GAMEMODE:PlayerRequestTeam(ply, 1)
	end
end

function GM:DoPlayerDeath(ply, attacker, dmginfo)
	ply:CreateRagdoll()
	ply:AddDeaths(1)
end

function GM:PostPlayerDeath(ply)
	GAMEMODE:RetrieveXperidiaAccountRank(ply)
	ply:SendLua([[GAMEMODE.Vars.lastcam=nil]])
	local userid = ply:UserID()
	local oldteam = ply:Team()
	if not GAMEMODE.Vars.nightpassed and not GAMEMODE.Vars.gameend and ply:Team() == 1 and not GAMEMODE.Vars.b87 then
		if fnafgmPlayerCanByPass(ply, "fastrespawn") then
			ply.NextSpawnTime = CurTime() + fnafgm_deathscreendelay:GetInt() + 1
		else
			ply.NextSpawnTime = CurTime() + fnafgm_deathscreendelay:GetInt() + fnafgm_deathscreenduration:GetInt() + fnafgm_respawndelay:GetInt()
		end

		local ent = ply:GetRagdollEntity()
		if fnafgm_ragdollinstantremove:GetBool() and IsValid(ent) then --Ragdoll zone
			ent:Remove() --Ragdoll remove
		elseif IsValid(ent) then
			if fnafgm_ragdolloverride:GetBool() then --Ragdoll model
				if table.Count(GAMEMODE.Models_dead) ~= 0 then
					local modele = table.Random(GAMEMODE.Models_dead)
					if file.Exists(modele, "GAME") then ent:SetModel(modele) end
				end
				if GAMEMODE.DeadBodiesTeleport[game.GetMap()] then
					ply:SetPos(table.Random(GAMEMODE.DeadBodiesTeleport[game.GetMap()]))
				end
			end
		end
		if fnafgm_deathscreenfade:GetBool() then --Screen fade
			ply:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 65536)
		end

		timer.Create("fnafgmStaticStart" .. userid, fnafgm_deathscreendelay:GetInt(), 1, function()
			if not GAMEMODE.Vars.nightpassed and IsValid(ply) and not ply:Alive() and ply:Team() == 1 then
				if game.GetMap() == "freddysnoevent" and ents.FindByName("fnafgm_Cam6")[1] then
					ply:SetViewEntity(ents.FindByName("fnafgm_Cam6")[1])
				elseif game.GetMap() == "fnaf2noevents" and ents.FindByName("DeathCam")[1] then
					ply:SetViewEntity(ents.FindByName("DeathCam")[1])
				end

				if fnafgm_deathscreenoverlay:GetBool() then --Static screen
					if game.SinglePlayer() then --Stop sound
						ply:ConCommand("stopsound")
					else
						ply:SendLua([[RunConsoleCommand("stopsound")]])
					end

					ply:ConCommand("pp_mat_overlay " .. GAMEMODE.Materials_static)
					ply:ConCommand("play " .. GAMEMODE.Sound_static)
				else
					ply:ConCommand("pp_mat_overlay ''")
				end

				timer.Create("fnafgmStaticEnd" .. userid, fnafgm_deathscreenduration:GetInt(), 1, function()
					if not GAMEMODE.Vars.nightpassed and IsValid(ply) and not ply:Alive() then
						ply:ConCommand("pp_mat_overlay ''")
						if game.GetMap() == "fnaf2noevents" then ply:ConCommand("pp_mat_overlay " .. GAMEMODE.Materials_fnaf2deathcam) end
						ply:ScreenFade(16, color_black, 0, 0)
						if not game.SinglePlayer() then
							if fnafgm_respawndelay:GetInt() == 0 then
								if (fnafgm_autorespawn:GetBool() and fnafgm_respawnenabled:GetBool()) and not GAMEMODE.Vars.norespawn then
									ply:Spawn()
								elseif fnafgm_respawnenabled:GetBool() and not GAMEMODE.Vars.norespawn then
									ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn")
									ply:SendLua([[chat.PlaySound()]])
								elseif not GAMEMODE.Vars.norespawn then
									ply:PrintMessage(HUD_PRINTTALK, "You will respawn after the night or when all the players are dead.")
									ply:SendLua([[chat.PlaySound()]])
								end
							else
								if fnafgm_respawnenabled:GetBool() and not GAMEMODE.Vars.norespawn then
									ply:PrintMessage(HUD_PRINTCENTER, "You will respawn in " .. fnafgm_respawndelay:GetInt() .. "s")
									ply:SendLua([[chat.PlaySound()]])
								elseif not GAMEMODE.Vars.norespawn then
									ply:PrintMessage(HUD_PRINTTALK, "You will respawn after the night or when all the players are dead.")
									ply:SendLua([[chat.PlaySound()]])
								end

								timer.Create("fnafgmRespawn" .. userid, fnafgm_respawndelay:GetInt(), 1, function()
									if not GAMEMODE.Vars.nightpassed and IsValid(ply) and not ply:Alive() then
										if (fnafgm_autorespawn:GetBool() and fnafgm_respawnenabled:GetBool()) and not GAMEMODE.Vars.norespawn then
											ply:Spawn()
										elseif fnafgm_respawnenabled:GetBool() and not GAMEMODE.Vars.norespawn then
											ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn")
											ply:SendLua([[chat.PlaySound()]])
										end
									end

									timer.Remove("fnafgmRespawn" .. userid)
								end)
							end
						end
					end

					timer.Remove("fnafgmStaticEnd" .. userid)
				end)
			elseif not GAMEMODE.Vars.nightpassed and IsValid(ply) and not ply:Alive() and ply:Team() ~= 1 then
				ply:ConCommand("pp_mat_overlay ''")
				ply:ScreenFade(16, color_black, 0, 0)
			end

			timer.Remove("fnafgmStaticStart" .. userid)
		end)
	elseif GAMEMODE.Vars.nightpassed or GAMEMODE.Vars.gameend then
		ply.NextSpawnTime = CurTime() + 11
	elseif ply:Team() == 2 then
		if fnafgmPlayerCanByPass(ply, "fastrespawn") then
			ply.NextSpawnTime = CurTime() + 1
		else
			ply.NextSpawnTime = CurTime() + fnafgm_respawndelay:GetInt()
		end

		local ent = ply:GetRagdollEntity()
		if IsValid(ent) then --Ragdoll remove
			ent:Remove()
		end

		if fnafgm_respawndelay:GetInt() == 0 then
			timer.Create("fnafgmRespawn" .. userid, 1, 1, function()
				if not GAMEMODE.Vars.nightpassed and IsValid(ply) and not ply:Alive() then
					if fnafgm_autorespawn:GetBool() and not GAMEMODE.Vars.norespawn then
						ply:Spawn()
					elseif fnafgm_respawnenabled:GetBool() and not GAMEMODE.Vars.norespawn then
						ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn")
						ply:SendLua([[chat.PlaySound()]])
					end
				end

				timer.Remove("fnafgmRespawn" .. userid)
			end)
		else
			if not GAMEMODE.Vars.norespawn then
				ply:PrintMessage(HUD_PRINTCENTER, "You will respawn in " .. fnafgm_respawndelay:GetInt() .. "s")
				ply:SendLua([[chat.PlaySound()]])
			end

			timer.Create("fnafgmRespawn" .. userid, fnafgm_respawndelay:GetInt(), 1, function()
				if not GAMEMODE.Vars.nightpassed and IsValid(ply) and not ply:Alive() then
					if fnafgm_autorespawn:GetBool() and not GAMEMODE.Vars.norespawn then
						ply:Spawn()
					elseif not GAMEMODE.Vars.norespawn then
						ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn")
						ply:SendLua([[chat.PlaySound()]])
					end
				end

				timer.Remove("fnafgmRespawn" .. userid)
			end)
		end
	else
		if fnafgmPlayerCanByPass(ply, "fastrespawn") or ply:Team() == TEAM_UNASSIGNED then
			ply.NextSpawnTime = CurTime() + 0.001
		else
			ply.NextSpawnTime = CurTime() + fnafgm_respawndelay:GetInt()
		end

		if fnafgm_respawndelay:GetInt() == 0 or ply:Team() == TEAM_UNASSIGNED then
			timer.Create("fnafgmRespawn" .. userid, 0.001, 1, function()
				if not GAMEMODE.Vars.nightpassed and IsValid(ply) and not ply:Alive() then
					if (fnafgm_autorespawn:GetBool() or oldteam == TEAM_UNASSIGNED) and not GAMEMODE.Vars.norespawn then
						ply:Spawn()
					elseif not GAMEMODE.Vars.norespawn then
						ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn")
						ply:SendLua([[chat.PlaySound()]])
					end
				end

				timer.Remove("fnafgmRespawn" .. userid)
			end)
		else
			if not GAMEMODE.Vars.norespawn then
				ply:PrintMessage(HUD_PRINTCENTER, "You will respawn in " .. fnafgm_respawndelay:GetInt() .. "s")
				ply:SendLua([[chat.PlaySound()]])
			end

			timer.Create("fnafgmRespawn" .. userid, fnafgm_respawndelay:GetInt(), 1, function()
				if not GAMEMODE.Vars.nightpassed and IsValid(ply) and not ply:Alive() then
					if fnafgm_autorespawn:GetBool() and not GAMEMODE.Vars.norespawn then
						ply:Spawn()
					elseif not GAMEMODE.Vars.norespawn then
						ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn")
						ply:SendLua([[chat.PlaySound()]])
					end
				end

				timer.Remove("fnafgmRespawn" .. userid)
			end)
		end
	end
end

function GM:PlayerDeathSound()
	return true
end

function GM:PlayerDeathThink(pl)
	local players = team.GetPlayers(pl:Team())
	if not game.SinglePlayer() then
		if pl:KeyPressed(IN_ATTACK) then
			if not pl.SpecID then pl.SpecID = 1 end
			pl.SpecID = pl.SpecID + 1
			if pl.SpecID > #players then pl.SpecID = 1 end
			pl:SpectateEntity(players[pl.SpecID])
		elseif pl:KeyPressed(IN_ATTACK2) then
			if not pl.SpecID then pl.SpecID = 1 end
			pl.SpecID = pl.SpecID - 1
			if pl.SpecID <= 0 then pl.SpecID = #players end
			pl:SpectateEntity(players[pl.SpecID])
		end
	end

	if GAMEMODE.Vars.norespawn then return end
	if not fnafgm_respawnenabled:GetBool() and not fnafgmPlayerCanByPass(pl, "canrespawn") then return end
	if pl.NextSpawnTime and pl.NextSpawnTime > CurTime() then return end
	if pl:KeyPressed(IN_ATTACK) or pl:KeyPressed(IN_ATTACK2) or pl:KeyPressed(IN_JUMP) then pl:Spawn() end
end

function GM:ShouldCollide(ent1, ent2)
	if (ent1:IsPlayer() and ent2:IsRagdoll()) or (ent1:IsRagdoll() and ent2:IsPlayer()) or (ent1:IsRagdoll() and ent2:IsRagdoll()) then return false end
	if ent1:IsPlayer() and ent2:IsPlayer() then return false end
	return true
end

function GM:PlayerSpray(ply)
	if fnafgmPlayerCanByPass(ply, "spray") then
		return false
	else
		return true
	end
end

function fnafgmUse(ply, ent, test, test2)
	if debugmode and IsValid(ent) then print(ent:GetName() .. " [" .. ent:GetClass() .. "] " .. tostring(ent:GetPos())) end
	hook.Call("fnafgmUseCustom", nil, ply, ent, test, test2)
	if IsValid(ply) and ply:Team() ~= 1 and not test and not fnafgmPlayerCanByPass(ply, "debug") then return false end
	if game.GetMap() == "freddysnoevent" then
		if door1btn and IsValid(door1btn) and ent == door1btn and not GAMEMODE.Vars.DoorWait1 then
			GAMEMODE.Vars.DoorWait1 = true
			ent:Fire("use")
			if IsValid(ply) and not GAMEMODE.Vars.DoorClosed[1] then
				GAMEMODE:Log("Left button used by " .. ply:GetName() .. " (The door was open)")
			elseif IsValid(ply) and GAMEMODE.Vars.DoorClosed[1] then
				GAMEMODE:Log("Left button used by " .. ply:GetName() .. " (The door was closed)")
			end

			timer.Create("fnafgmDoorWait1", 0.7, 1, function()
				GAMEMODE.Vars.DoorWait1 = false
				timer.Remove("fnafgmDoorWait1")
			end)
			return false
		elseif door1btn and IsValid(door1btn) and ent == door1btn and GAMEMODE.Vars.DoorWait1 then
			return false
		end

		if door2btn and IsValid(door2btn) and ent == door2btn and not GAMEMODE.Vars.DoorWait2 then
			GAMEMODE.Vars.DoorWait2 = true
			ent:Fire("use")
			if IsValid(ply) and not GAMEMODE.Vars.DoorClosed[2] then
				GAMEMODE:Log("Right button used by " .. ply:GetName() .. " (The door was open)")
			elseif IsValid(ply) and GAMEMODE.Vars.DoorClosed[2] then
				GAMEMODE:Log("Right button used by " .. ply:GetName() .. " (The door was closed)")
			end

			timer.Create("fnafgmDoorWait2", 0.7, 1, function()
				GAMEMODE.Vars.DoorWait2 = false
				timer.Remove("fnafgmDoorWait2")
			end)
			return false
		elseif door2btn and IsValid(door2btn) and ent == door2btn and GAMEMODE.Vars.DoorWait2 then
			return false
		end

		if light1 and IsValid(light1) and ent == light1 then
			if not GAMEMODE.Vars.light1usewait and not GAMEMODE.Vars.poweroff then
				GAMEMODE.Vars.light1usewait = true
				light1:Fire("use")
				if GAMEMODE.Vars.LightUse[2] then light2:Fire("use") end
				timer.Create("fnafgmlight1usewait", 0.5, 1, function()
					GAMEMODE.Vars.light1usewait = false
					timer.Remove("fnafgmlight1usewait")
				end)
			end
			return false
		end

		if light2 and IsValid(light2) and ent == light2 then
			if not GAMEMODE.Vars.light2usewait and not GAMEMODE.Vars.poweroff then
				GAMEMODE.Vars.light2usewait = true
				light2:Fire("use")
				if GAMEMODE.Vars.LightUse[1] then light1:Fire("use") end
				timer.Create("fnafgmlight2usewait", 0.5, 1, function()
					GAMEMODE.Vars.light2usewait = false
					timer.Remove("fnafgmlight2usewait")
				end)
			end
			return false
		end
	end

	if game.GetMap() == "fnaf2noevents" then
		if light1 and IsValid(light1) and ent == light1 then
			if not GAMEMODE.Vars.light1usewait and not GAMEMODE.Vars.poweroff then
				if not GAMEMODE.Vars.LightUse[1] then light1:Fire("use") end
				GAMEMODE.Vars.LightUse[1] = true
				local timy = 0.05
				if test2 then timy = 1 end
				if timer.Exists("fnafgmlight1usewait") then
					timer.Adjust("fnafgmlight1usewait", timy, 1, function()
						light1:Fire("use")
						GAMEMODE.Vars.LightUse[1] = false
						timer.Remove("fnafgmlight1usewait")
					end)
				else
					timer.Create("fnafgmlight1usewait", timy, 1, function()
						light1:Fire("use")
						GAMEMODE.Vars.LightUse[1] = false
						timer.Remove("fnafgmlight1usewait")
					end)
				end
			elseif not GAMEMODE.Vars.light1usewait and GAMEMODE.Vars.poweroff then
				ply:SendLua([[LocalPlayer():EmitSound("fnafgm_lighterror")]])
				GAMEMODE.Vars.light1usewait = true
				timer.Create("fnafgmlight1usewait", 1, 1, function()
					GAMEMODE.Vars.light1usewait = false
					timer.Remove("fnafgmlight1usewait")
				end)
			end
			return false
		end

		if light2 and IsValid(light2) and ent == light2 then
			if not GAMEMODE.Vars.light2usewait and not GAMEMODE.Vars.poweroff then
				if not GAMEMODE.Vars.LightUse[2] then light2:Fire("use") end
				GAMEMODE.Vars.LightUse[2] = true
				local timy = 3
				if test2 then timy = 4 end
				if timer.Exists("fnafgmlight2usewait") then
					timer.Adjust("fnafgmlight2usewait", timy, 1, function()
						light2:Fire("use")
						GAMEMODE.Vars.LightUse[2] = false
						timer.Remove("fnafgmlight2usewait")
					end)
				else
					timer.Create("fnafgmlight2usewait", timy, 1, function()
						light2:Fire("use")
						GAMEMODE.Vars.LightUse[2] = false
						timer.Remove("fnafgmlight2usewait")
					end)
				end
			elseif not GAMEMODE.Vars.light2usewait and GAMEMODE.Vars.poweroff then
				ply:SendLua([[LocalPlayer():EmitSound("fnafgm_lighterror")]])
				GAMEMODE.Vars.light2usewait = true
				timer.Create("fnafgmlight2usewait", 1, 1, function()
					GAMEMODE.Vars.light2usewait = false
					timer.Remove("fnafgmlight2usewait")
				end)
			end
			return false
		end

		if light3 and IsValid(light3) and ent == light3 then
			if not GAMEMODE.Vars.light3usewait and not GAMEMODE.Vars.poweroff then
				if not GAMEMODE.Vars.LightUse[3] then light3:Fire("use") end
				GAMEMODE.Vars.LightUse[3] = true
				local timy = 0.05
				if test2 then timy = 1 end
				if timer.Exists("fnafgmlight3usewait") then
					timer.Adjust("fnafgmlight3usewait", timy, 1, function()
						light3:Fire("use")
						GAMEMODE.Vars.LightUse[3] = false
						timer.Remove("fnafgmlight3usewait")
					end)
				else
					timer.Create("fnafgmlight3usewait", timy, 1, function()
						light3:Fire("use")
						GAMEMODE.Vars.LightUse[3] = false
						timer.Remove("fnafgmlight3usewait")
					end)
				end
			elseif not GAMEMODE.Vars.light3usewait and GAMEMODE.Vars.poweroff then
				ply:SendLua([[LocalPlayer():EmitSound("fnafgm_lighterror")]])
				GAMEMODE.Vars.light3usewait = true
				timer.Create("fnafgmlight3usewait", 1, 1, function()
					GAMEMODE.Vars.light3usewait = false
					timer.Remove("fnafgmlight3usewait")
				end)
			end
			return false
		end

		if safedoor and safedoor:IsValid() and ent == safedoor and not GAMEMODE.Vars.usingsafedoor[ply] then
			ply:SetPos(Vector(-46, -450, 0))
			GAMEMODE.Vars.usingsafedoor[ply] = true
		elseif safedoor and safedoor:IsValid() and ent == safedoor and GAMEMODE.Vars.usingsafedoor[ply] then
			ply:SetPos(Vector(-46, -320, 0))
			GAMEMODE.Vars.usingsafedoor[ply] = false
		end
	end

	if test2 and ent and ent:GetClass() == "func_button" then
		ent:Fire("use")
		return false
	end

	if test2 and ent and ent:GetClass() == "fnafgm_keypad" then
		ent:Use(ply, ply, 1, 0)
		return false
	end
end
hook.Add("PlayerUse", "fnafgmUse", fnafgmUse)

function GM:StartNight(ply)
	timer.Remove("fnafgmStart")
	if GAMEMODE.Vars.startday then return end
	if #team.GetPlayers(1) == 0 then
		net.Start("fnafgmNotif")
		net.WriteString("nosg")
		net.WriteInt(1, 3)
		net.WriteFloat(5)
		net.WriteBit(true)
		net.Broadcast()
		return
	end

	local nope = hook.Call("fnafgmCustomStart", ply)
	if not nope then
		if game.GetMap() == "freddysnoevent" then
			GAMEMODE:SetNightTemplate(true)
			if GAMEMODE.Vars.Halloween or fnafgm_forceseasonalevent:GetInt() == 3 then sound.Play("fnafgm/robotvoice.wav", Vector(-80, -1163, 128), 150) end
			for k, v in pairs(ents.FindByName("Lights")) do
				v:Fire("TurnOff")
			end
			for k, v in pairs(ents.FindByName("PowerDown")) do
				v:Fire("PlaySound")
			end
			for k, v in pairs(ents.FindByName("SpotLights")) do
				v:Fire("TurnOff")
			end
			for k, v in pairs(ents.FindByName("SpotLights2")) do
				v:Fire("TurnOff")
			end
			for k, v in pairs(ents.FindByName("CameraLights")) do
				v:Fire("TurnOn")
			end
			for k, v in pairs(ents.FindByName("cc2")) do
				v:Fire("Enable")
			end
			ents.FindByName("Powerlvl")[1]:Fire("Enable")
			GAMEMODE:CreateAnimatronic(GAMEMODE.Animatronic.Freddy, GAMEMODE.APos.freddysnoevent.SS)
			GAMEMODE:CreateAnimatronic(GAMEMODE.Animatronic.Bonnie, GAMEMODE.APos.freddysnoevent.SS)
			GAMEMODE:CreateAnimatronic(GAMEMODE.Animatronic.Chica, GAMEMODE.APos.freddysnoevent.SS)
			GAMEMODE:CreateAnimatronic(GAMEMODE.Animatronic.Foxy, GAMEMODE.APos.freddysnoevent.PC)
			fnafgmVarsUpdate()
			for k, v in pairs(team.GetPlayers(1)) do
				if v:Alive() then v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 2.5) end
			end

			timer.Create("fnafgmTempoStartM", 0.01, 1, function()
				for k, v in pairs(player.GetAll()) do
					if v:Team() == 1 and v:Alive() then
						v:SetPos(Vector(-80, -1224, 64))
						v:SetEyeAngles(Angle(0, 90, 0))
					end
				end

				timer.Remove("fnafgmTempoStartM")
			end)

			timer.Create("fnafgmTempoStart", 2.5, 1, function()
				GAMEMODE.Vars.tempostart = false
				fnafgmVarsUpdate()
				fnafgmPowerUpdate()
				for k, v in pairs(team.GetPlayers(1)) do
					GAMEMODE:GoFNaFView(v, true)
				end

				timer.Create("fnafgmTimeThink", GAMEMODE.HourTime, 0, fnafgmTimeThink)
				timer.Remove("fnafgmTempoStart")
			end)

			for k, v in pairs(GAMEMODE.Vars.Animatronics) do
				if GAMEMODE.AnimatronicsCD[k] and GAMEMODE.AnimatronicsCD[k][game.GetMap()] and GAMEMODE.AnimatronicsMaxCD[k] and GAMEMODE.AnimatronicsMaxCD[k][game.GetMap()] then
					local randtime = math.random(GAMEMODE.AnimatronicsCD[k][game.GetMap()][GAMEMODE.Vars.night] or GAMEMODE.AnimatronicsCD[k][game.GetMap()][0], GAMEMODE.AnimatronicsMaxCD[k][game.GetMap()][GAMEMODE.Vars.night] or GAMEMODE.AnimatronicsMaxCD[k][game.GetMap()][0])
					if GAMEMODE.AnimatronicsCD[k][game.GetMap()][GAMEMODE.Vars.night] ~= -1 then timer.Create("fnafgmAnimatronicMove" .. k, randtime, 0, function() GAMEMODE:AutoMoveAnimatronic(k) end) end
				else
					GAMEMODE:Log("Missing or incomplete cooldown info for animatronic " .. ((GAMEMODE.AnimatronicName[k] .. " (" .. (k or 0) .. ")") or k or 0) .. "!")
				end
			end
		elseif game.GetMap() == "fnaf2noevents" then
			GAMEMODE:SetNightTemplate(false)
			if GAMEMODE.Vars.night == 1 then
				GAMEMODE.Vars.power = 115
				GAMEMODE.Vars.powertot = 115
			elseif GAMEMODE.Vars.night == 2 then
				GAMEMODE.Vars.power = 100
				GAMEMODE.Vars.powertot = 100
			elseif GAMEMODE.Vars.night == 3 then
				GAMEMODE.Vars.power = 85
				GAMEMODE.Vars.powertot = 85
			elseif GAMEMODE.Vars.night == 4 then
				GAMEMODE.Vars.power = 67
				GAMEMODE.Vars.powertot = 67
			else
				GAMEMODE.Vars.power = 50
				GAMEMODE.Vars.powertot = 50
			end

			fnafgmVarsUpdate()
			for k, v in pairs(team.GetPlayers(1)) do
				if v:Alive() then v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 2.5) end
			end

			timer.Create("fnafgmTempoStartM", 0.01, 1, function()
				for k, v in pairs(player.GetAll()) do
					if v:Team() == 1 and v:Alive() and not v.IsOnSecurityRoom then
						local spawn = GAMEMODE:PlayerSelectSpawn(v):GetPos()
						v:SetPos(spawn)
						v:SetEyeAngles(Angle(0, 90, 0))
					end
				end

				timer.Remove("fnafgmTempoStartM")
			end)

			timer.Create("fnafgmTempoStart", 2.5, 1, function()
				GAMEMODE.Vars.tempostart = false
				fnafgmVarsUpdate()
				fnafgmPowerUpdate()
				for k, v in pairs(team.GetPlayers(1)) do
					GAMEMODE:GoFNaFView(v, true)
				end

				timer.Create("fnafgmTimeThink", GAMEMODE.HourTime, 0, fnafgmTimeThink)
				timer.Remove("fnafgmTempoStart")
			end)
		elseif game.GetMap() == "fnaf3" then
			GAMEMODE:SetNightTemplate(true)
			fnafgmVarsUpdate()
			for k, v in pairs(team.GetPlayers(1)) do
				if v:Alive() then
					v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 2.5)
					v:SendLua([[LocalPlayer():EmitSound("fnafgm_startday")]])
				end
			end

			timer.Create("fnafgmTempoStartM", 0.01, 1, function()
				for k, v in pairs(player.GetAll()) do
					if v:Team() == 1 and v:Alive() and not v.IsOnSecurityRoom then
						local spawn = GAMEMODE:PlayerSelectSpawn(v):GetPos()
						v:SetPos(spawn)
						v:SetEyeAngles(Angle(0, 90, 0))
					end
				end

				timer.Remove("fnafgmTempoStartM")
			end)

			timer.Create("fnafgmTempoStart", 2.5, 1, function()
				GAMEMODE.Vars.tempostart = false
				fnafgmVarsUpdate()
				for k, v in pairs(team.GetPlayers(1)) do
					GAMEMODE:GoFNaFView(v, true)
				end

				timer.Create("fnafgmTimeThink", GAMEMODE.HourTime, 0, fnafgmTimeThink)
				timer.Remove("fnafgmTempoStart")
			end)
		elseif game.GetMap() == "fnaf4house" or game.GetMap() == "fnaf4noclips" or game.GetMap() == "fnaf4versus" then
			GAMEMODE:SetNightTemplate(false)
			if PlushTrapWin then
				GAMEMODE.Vars.time = 2
				PlushTrapWin = false
			else
				GAMEMODE.Vars.time = GAMEMODE.TimeBase
			end

			fnafgmVarsUpdate()
			if game.GetMap() ~= "fnaf4versus" then
				for k, v in pairs(ents.FindByClass("info_player_start")) do
					v:Remove()
				end

				local spawn = ents.Create("info_player_start")
				spawn:SetPos(Vector(-640, -63, 0))
				spawn:SetAngles(Angle(0, 90, 0))
				spawn:Spawn()
			end

			for k, v in pairs(team.GetPlayers(1)) do
				if v:Alive() then v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 2.5) end
			end

			if game.GetMap() ~= "fnaf4versus" then
				timer.Create("fnafgmTempoStartM", 0.01, 1, function()
					for k, v in pairs(player.GetAll()) do
						if v:Team() == 1 and v:Alive() and not v.IsOnSecurityRoom then
							v:SetPos(Vector(-640, -63, 0))
							v:SetEyeAngles(Angle(0, 90, 0))
						end
					end

					timer.Remove("fnafgmTempoStartM")
				end)
			end

			timer.Create("fnafgmTempoStart", 2.5, 1, function()
				GAMEMODE.Vars.tempostart = false
				fnafgmVarsUpdate()
				fnafgmPowerUpdate()
				for k, v in pairs(team.GetPlayers(1)) do
					GAMEMODE:GoFNaFView(v, true)
				end

				timer.Create("fnafgmTimeThink", GAMEMODE.HourTime, 0, fnafgmTimeThink)
				timer.Remove("fnafgmTempoStart")
			end)
		elseif game.GetMap() ~= "gm_construct" and game.GetMap() ~= "gm_flatgrass" then
			GAMEMODE:SetNightTemplate(true)
			fnafgmVarsUpdate()
			for k, v in pairs(team.GetPlayers(1)) do
				if v:Alive() then v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 2.5) end
			end

			timer.Create("fnafgmTempoStartM", 0.01, 1, function()
				for k, v in pairs(player.GetAll()) do
					if v:Team() == 1 and v:Alive() and not v.IsOnSecurityRoom then
						local spawn = GAMEMODE:PlayerSelectSpawn(v):GetPos()
						v:SetPos(spawn)
						v:SetEyeAngles(Angle(0, 90, 0))
					end
				end

				timer.Remove("fnafgmTempoStartM")
			end)

			timer.Create("fnafgmTempoStart", 2.5, 1, function()
				GAMEMODE.Vars.tempostart = false
				fnafgmVarsUpdate()
				for k, v in pairs(team.GetPlayers(1)) do
					GAMEMODE:GoFNaFView(v, true)
				end

				timer.Create("fnafgmTimeThink", GAMEMODE.HourTime, 0, fnafgmTimeThink)
				timer.Remove("fnafgmTempoStart")
			end)
		end
	end

	if IsValid(ply) then
		GAMEMODE:Log("Night " .. GAMEMODE.Vars.night .. " started by " .. ply:GetName())
	else
		GAMEMODE:Log("Night " .. GAMEMODE.Vars.night .. " started by console/map/other")
	end
end

function GM:SetNightTemplate(power)
	if not GAMEMODE.Vars.night then
		ErrorNoHalt("[FNAFGM] Alert! \"GAMEMODE.Vars.night\" wasn't set!\nThere might be a critical initialization issue!\nThis issue is certainly caused by another addon. Please check all your installed addons.\n")
		if not GAMEMODE.Vars.tabused then GAMEMODE.Vars.tabused = {} end
		if not GAMEMODE.Vars.LightUse then GAMEMODE.Vars.LightUse = {} end
		if not GAMEMODE.Vars.DoorClosed then GAMEMODE.Vars.DoorClosed = {} end
		if not GAMEMODE.Vars.usingsafedoor then GAMEMODE.Vars.usingsafedoor = {} end
	end

	GAMEMODE.Vars.startday = true
	GAMEMODE.Vars.tempostart = true
	GAMEMODE.Vars.night = (GAMEMODE.Vars.night or 0) + 1
	GAMEMODE.Vars.AMPM = GAMEMODE.AMPM
	GAMEMODE.Vars.time = GAMEMODE.TimeBase
	if power then GAMEMODE.Vars.power = GAMEMODE.Power_Max end
	GAMEMODE.Vars.nightpassed = false
	GAMEMODE.Vars.iniok = true
end

function fnafgmAutoCleanUp()
	if fnafgm_autocleanupmap:GetBool() and GAMEMODE.Vars.active and not alive then
		local online = false
		for k, v in pairs(player.GetAll()) do
			online = true
		end

		if not online then
			GAMEMODE:Log("Auto clean up")
			if not GAMEMODE:RestartMapIfWeShould() then
				GAMEMODE.Vars.active = false
				fnafgmResetGame()
				fnafgmMapOverrides()
				GAMEMODE:LoadProgress()
			end
		end
	end
end

function fnafgmRestartNight()
	if GAMEMODE.Vars.iniok and GAMEMODE.Vars.mapoverrideok and GAMEMODE.Vars.startday and GAMEMODE.Vars.active then
		game.CleanUpMap()
		timer.Remove("fnafgmTimeThink")
		timer.Remove("fnafgmPowerOff1")
		timer.Remove("fnafgmPowerOff2")
		timer.Remove("fnafgmPowerOff3")
		GAMEMODE.Vars.night = GAMEMODE.Vars.night - 1
		GAMEMODE.Vars.time = GAMEMODE.TimeBase
		GAMEMODE.Vars.AMPM = GAMEMODE.AMPM
		GAMEMODE.Vars.poweroff = false
		GAMEMODE.Vars.powerchecktime = nil
		GAMEMODE.Vars.oldpowerdrain = nil
		table.Empty(GAMEMODE.Vars.tabused)
		table.Empty(GAMEMODE.Vars.usingsafedoor)
		GAMEMODE.Vars.startday = false
		GAMEMODE.Vars.tempostart = false
		GAMEMODE.Vars.nightpassed = false
		GAMEMODE.Vars.mapoverrideok = false
		table.Empty(GAMEMODE.Vars.LightUse)
		table.Empty(GAMEMODE.Vars.DoorClosed)
		GAMEMODE.Vars.mute = true
		timer.Remove("fnafgmEndCall")
		GAMEMODE.Vars.foxyknockdoorpena = 2
		GAMEMODE.Vars.addfoxyknockdoorpena = 4
		fnafgmMapOverrides()
		fnafgmVarsUpdate()
		for k, v in pairs(player.GetAll()) do
			if game.SinglePlayer() then --Stop sound
				v:ConCommand("stopsound")
			else
				v:SendLua([[RunConsoleCommand("stopsound")]])
			end
			if v:Team() == 1 or v:Team() == 2 then
				v:Spawn()
				v:SetViewEntity(v)
			end
		end

		GAMEMODE.Vars.norespawn = false
		GAMEMODE.Vars.checkRestartNight = false
		GAMEMODE:Log("The night is reset")
	end
end

function fnafgmResetGame()
	game.CleanUpMap()
	GAMEMODE.Vars.startday = false
	GAMEMODE.Vars.tempostart = false
	GAMEMODE.Vars.iniok = false
	GAMEMODE.Vars.mapoverrideok = false
	GAMEMODE.Vars.time = GAMEMODE.TimeBase
	GAMEMODE.Vars.AMPM = GAMEMODE.AMPM
	GAMEMODE.Vars.poweroff = false
	GAMEMODE.Vars.powerchecktime = nil
	GAMEMODE.Vars.oldpowerdrain = nil
	table.Empty(GAMEMODE.Vars.LightUse)
	table.Empty(GAMEMODE.Vars.DoorClosed)
	table.Empty(GAMEMODE.Vars.tabused)
	table.Empty(GAMEMODE.Vars.usingsafedoor)
	GAMEMODE.Vars.night = GAMEMODE.NightBase
	GAMEMODE.Vars.norespawn = false
	GAMEMODE.Vars.nightpassed = false
	GAMEMODE.Vars.gameend = false
	GAMEMODE.Vars.checkRestartNight = false
	GAMEMODE.Vars.mute = true
	timer.Remove("fnafgmEndCall")
	timer.Remove("fnafgmTimeThink")
	timer.Remove("fnafgmPreRestartNight")
	timer.Remove("fnafgmRestartNight")
	timer.Remove("fnafgmNightPassed")
	timer.Remove("fnafgmPowerOff1")
	timer.Remove("fnafgmPowerOff2")
	timer.Remove("fnafgmPowerOff3")
	GAMEMODE.Vars.foxyknockdoorpena = 2
	GAMEMODE.Vars.addfoxyknockdoorpena = 4
	fnafgmVarsUpdate()
end

function fnafgmMapOverrides()
	if not GAMEMODE.Vars.mapoverrideok then
		hook.Call("fnafgmMapOverridesCustom")
		if game.GetMap() == "freddysnoevent" then
			for k, v in pairs(ents.FindByName("Pwrbtn")) do
				v:Remove()
			end

			for k, v in pairs(ents.FindByName("powerconsumotion")) do
				v:Remove()
			end

			for k, v in pairs(ents.FindByName("genroomkey")) do
				v:Remove()
			end

			for k, v in pairs(ents.FindByName("Door1")) do
				door1 = v
			end

			for k, v in pairs(ents.FindByName("Door2")) do
				door2 = v
			end

			for k, v in pairs(ents.FindByName("Door1button")) do
				door1btn = v
			end

			for k, v in pairs(ents.FindByName("Door2button")) do
				door2btn = v
			end

			for k, v in pairs(ents.FindByName("doorlightglow")) do
				door1light = v
			end

			for k, v in pairs(ents.FindByName("doorlight2glow")) do
				door2light = v
			end

			for k, v in pairs(ents.FindByName("Light1button")) do
				light1 = v
			end

			for k, v in pairs(ents.FindByName("Light2button")) do
				light2 = v
			end

			if fnafgm_disablemapsmonitors:GetBool() then
				for k, v in pairs(ents.FindByName("Securicam")) do
					v:Fire("Color", "0 0 0")
				end

				for k, v in pairs(ents.FindByName("Cambutton")) do
					v:Remove()
				end
			end

			for k, v in pairs(ents.FindByName("powerbar")) do
				v:Remove()
			end

			for k, v in pairs(ents.FindByName("Genbutton")) do
				v:Remove()
			end

			ents.FindByName("Door1")[1]:Fire("addoutput", "OnFullyOpen fnafgm_link,DoorOpen,1,0,-1")
			ents.FindByName("Door1")[1]:Fire("addoutput", "OnClose fnafgm_link,DoorClosing,1,0,-1")
			ents.FindByName("Door2")[1]:Fire("addoutput", "OnFullyOpen fnafgm_link,DoorOpen,2,0,-1")
			ents.FindByName("Door2")[1]:Fire("addoutput", "OnClose fnafgm_link,DoorClosing,2,0,-1")
			ents.FindByName("Light1button")[1]:Fire("addoutput", "OnIn fnafgm_link,LightOn,1,0,-1")
			ents.FindByName("Light1button")[1]:Fire("addoutput", "OnOut fnafgm_link,LightOff,1,0,-1")
			ents.FindByName("Light2button")[1]:Fire("addoutput", "OnIn fnafgm_link,LightOn,2,0,-1")
			ents.FindByName("Light2button")[1]:Fire("addoutput", "OnOut fnafgm_link,LightOff,2,0,-1")
			local spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-140, -1237, 70))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-28, -1237, 70))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-54, -1200, 70))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-106, -1200, 70))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-78, -1150, 70))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(-593, 336, 256))
			spawn:SetAngles(Angle(0, 135, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(-687, 334, 256))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(-753, 335, 256))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(-832, 321, 256))
			spawn:SetAngles(Angle(0, 45, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(-850, 425, 256))
			spawn:SetAngles(Angle(0, 0, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(-845, 531, 256))
			spawn:SetAngles(Angle(0, 0, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(-854, 601, 256))
			spawn:SetAngles(Angle(0, -45, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(-750, 583, 256))
			spawn:SetAngles(Angle(0, -90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(-662, 583, 256))
			spawn:SetAngles(Angle(0, -90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(-561, 583, 256))
			spawn:SetAngles(Angle(0, -135, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(-555, 444, 256))
			spawn:SetAngles(Angle(0, 180, 0))
			spawn:Spawn()
			local fnafgm_link = ents.Create("fnafgm_link")
			fnafgm_link:SetName("fnafgm_link")
			fnafgm_link:SetPos(Vector(-86, -1146, 0))
			fnafgm_link:Spawn()
			for k, v in pairs(ents.FindByClass("point_camera")) do
				local CAM = ents.Create("fnafgm_camera")
				CAM:SetPos(v:GetPos())
				CAM:SetAngles(v:GetAngles())
				CAM:SetName("fnafgm_" .. v:GetName())
				if v:GetKeyValues().parentname ~= "" then
					local parent = ents.FindByName(v:GetKeyValues().parentname)[1]
					if IsValid(parent) then CAM:SetParent(parent) end
				end

				CAM:Spawn()
				v:Fire("SetOff")
			end

			local KitchenCam = ents.Create("fnafgm_camera")
			KitchenCam:SetPos(Vector(235, -1050, 97))
			KitchenCam:SetAngles(Angle(-33, 64, 15))
			KitchenCam:SetName("fnafgm_Cam11")
			KitchenCam:Spawn()
			local OfficeCam = ents.Create("fnafgm_camera")
			OfficeCam:SetPos(Vector(-82, -1254, 170))
			OfficeCam:SetAngles(Angle(30, 90, 0))
			OfficeCam:SetName("fnafgm_Cam12")
			OfficeCam:Spawn()
			GAMEMODE:CreateAnimatronic(GAMEMODE.Animatronic.Freddy, GAMEMODE.APos.freddysnoevent.SS)
			GAMEMODE:CreateAnimatronic(GAMEMODE.Animatronic.Bonnie, GAMEMODE.APos.freddysnoevent.SS)
			GAMEMODE:CreateAnimatronic(GAMEMODE.Animatronic.Chica, GAMEMODE.APos.freddysnoevent.SS)
			GAMEMODE:CreateAnimatronic(GAMEMODE.Animatronic.Foxy, GAMEMODE.APos.freddysnoevent.PC)
			--GAMEMODE:CreateAnimatronic(GAMEMODE.Animatronic.GoldenFreddy, GAMEMODE.APos.freddysnoevent.Kitchen)
			GAMEMODE.Vars.mapoverrideok = true
		elseif game.GetMap() == "fnaf2noevents" then
			for k, v in pairs(ents.FindByName("toybutt")) do
				btn = v
			end

			for k, v in pairs(ents.FindByName("misfitbutt")) do
				btnm = v
			end

			local BoxCorner = Vector(-149, -281, 65)
			local OppositeCorner = Vector(-163, -273, 47)
			for k, v in pairs(ents.FindByClass("func_button")) do
				if table.HasValue(ents.FindInBox(BoxCorner, OppositeCorner), v) then light1 = v end
			end

			local BoxCorner = Vector(-2, -240, 42)
			local OppositeCorner = Vector(-2, -240, 42)
			for k, v in pairs(ents.FindByClass("func_button")) do
				if table.HasValue(ents.FindInBox(BoxCorner, OppositeCorner), v) then light2 = v end
			end

			local BoxCorner = Vector(152, -284, 62)
			local OppositeCorner = Vector(177, -257, 40)
			for k, v in pairs(ents.FindByClass("func_button")) do
				if table.HasValue(ents.FindInBox(BoxCorner, OppositeCorner), v) then light3 = v end
			end

			if fnafgm_disablemapsmonitors:GetBool() then
				for k, v in pairs(ents.FindByClass("func_monitor")) do
					if GAMEMODE:CheckPlayerSecurityRoom(v) then v:Fire("Color", "0 0 0") end
				end

				for k, v in pairs(ents.FindByName("Cambutton")) do
					v:Remove()
				end
			end

			local BoxCorner = Vector(-85, -330, 120)
			local OppositeCorner = Vector(0, -380, 0)
			for k, v in pairs(ents.FindByClass("prop_door_rotating")) do
				if table.HasValue(ents.FindInBox(BoxCorner, OppositeCorner), v) then
					v:Fire("lock")
					safedoor = v
				end
			end

			local BoxCorner = Vector(-85, -333, 40)
			local OppositeCorner = Vector(-180, -364, 113)
			for k, v in pairs(ents.FindInBox(BoxCorner, OppositeCorner)) do
				if v:GetClass() == "func_button" or v:GetClass() == "func_breakable" then v:Remove() end
			end

			local spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(116, -320, 0))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(46, -320, 0))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(0, -320, 0))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-120, -320, 0))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(0, -154, 0))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(102, -205, 0))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-62, -240, 0))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(42, -270, 0))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(0, -270, 0))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(28, -190, 0))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-25, -190, 0))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-50, -282, 0))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			local DeathCam = ents.Create("fnafgm_camera")
			DeathCam:SetPos(Vector(-227, 1340, 48))
			DeathCam:SetAngles(Angle(-2, 117, 0))
			DeathCam:SetName("DeathCam")
			DeathCam:Spawn()
			local SafeZoneCam = ents.Create("fnafgm_camera")
			SafeZoneCam:SetPos(GAMEMODE.FNaFView[game.GetMap()][1] + Vector(0, 0, 64))
			SafeZoneCam:SetAngles(GAMEMODE.FNaFView[game.GetMap()][2])
			SafeZoneCam:SetName("SafeZoneCam")
			SafeZoneCam:Spawn()
			for k, v in pairs(ents.FindByClass("point_camera")) do
				local CAM = ents.Create("fnafgm_camera")
				CAM:SetPos(v:GetPos())
				CAM:SetAngles(v:GetAngles())
				CAM:SetName("fnafgm_" .. v:GetName())
				if v:GetKeyValues().parentname ~= "" then
					local parent = ents.FindByName(v:GetKeyValues().parentname)[1]
					if IsValid(parent) then CAM:SetParent(parent) end
				end
				CAM:Spawn()
				v:Fire("SetOff")
			end

			GAMEMODE:CreateAnimatronic(GAMEMODE.Animatronic.ToyFreddy, GAMEMODE.APos.fnaf2noevents.SS)
			GAMEMODE:CreateAnimatronic(GAMEMODE.Animatronic.ToyBonnie, GAMEMODE.APos.fnaf2noevents.SS)
			GAMEMODE:CreateAnimatronic(GAMEMODE.Animatronic.ToyChica, GAMEMODE.APos.fnaf2noevents.SS)
			GAMEMODE.Vars.mapoverrideok = true
		elseif game.GetMap() == "fnaf3" then
			local CAM = ents.Create("fnafgm_camera")
			CAM:SetPos(Vector(-226, -310, 190))
			CAM:SetAngles(Angle(37, -102, 0))
			CAM:SetName("fnafgm_Cam1")
			CAM:Spawn()
			CAM = ents.Create("fnafgm_camera")
			CAM:SetPos(Vector(256, -102, 158))
			CAM:SetAngles(Angle(4, 114, 0))
			CAM:SetName("fnafgm_Cam2")
			CAM:Spawn()
			CAM = ents.Create("fnafgm_camera")
			CAM:SetPos(Vector(317, -183, 170))
			CAM:SetAngles(Angle(60, 92, 0))
			CAM:SetName("fnafgm_Cam3")
			CAM:Spawn()
			CAM = ents.Create("fnafgm_camera")
			CAM:SetPos(Vector(350, -193, 150))
			CAM:SetAngles(Angle(34, 90, 0))
			CAM:SetName("fnafgm_Cam4")
			CAM:Spawn()
			CAM = ents.Create("fnafgm_camera")
			CAM:SetPos(Vector(14, 150, 140))
			CAM:SetAngles(Angle(16, -180, 0))
			CAM:SetName("fnafgm_Cam5")
			CAM:Spawn()
			CAM = ents.Create("fnafgm_camera")
			CAM:SetPos(Vector(-415, 100, 142))
			CAM:SetAngles(Angle(28, 96, 0))
			CAM:SetName("fnafgm_Cam6")
			CAM:Spawn()
			CAM = ents.Create("fnafgm_camera")
			CAM:SetPos(Vector(-396, 253, 137))
			CAM:SetAngles(Angle(24, 91, 0))
			CAM:SetName("fnafgm_Cam7")
			CAM:Spawn()
			CAM = ents.Create("fnafgm_camera")
			CAM:SetPos(Vector(-248, 248, 139))
			CAM:SetAngles(Angle(21, 25, 0))
			CAM:SetName("fnafgm_Cam8")
			CAM:Spawn()
			CAM = ents.Create("fnafgm_camera")
			CAM:SetPos(Vector(58, 363, 163))
			CAM:SetAngles(Angle(15, 13, 0))
			CAM:SetName("fnafgm_Cam9")
			CAM:Spawn()
			CAM = ents.Create("fnafgm_camera")
			CAM:SetPos(Vector(293, 362, 173))
			CAM:SetAngles(Angle(27, 36, 0))
			CAM:SetName("fnafgm_Cam10")
			CAM:Spawn()
			CAM = ents.Create("fnafgm_camera")
			CAM:SetPos(Vector(-627, 527, 78))
			CAM:SetAngles(Angle(-1, 3, 0))
			CAM:SetName("fnafgm_Cam11")
			CAM:Spawn()
			CAM = ents.Create("fnafgm_camera")
			CAM:SetPos(Vector(-585, 310, 98))
			CAM:SetAngles(Angle(6, 158, 0))
			CAM:SetName("fnafgm_Cam12")
			CAM:Spawn()
			CAM = ents.Create("fnafgm_camera")
			CAM:SetPos(Vector(-184, 19, 105))
			CAM:SetAngles(Angle(35, -178, 0))
			CAM:SetName("fnafgm_Cam13")
			CAM:Spawn()
			CAM = ents.Create("fnafgm_camera")
			CAM:SetPos(Vector(477, 0, 94))
			CAM:SetAngles(Angle(0, 90, 0))
			CAM:SetName("fnafgm_Cam14")
			CAM:Spawn()
			CAM = ents.Create("fnafgm_camera")
			CAM:SetPos(Vector(218, -244, 117))
			CAM:SetAngles(Angle(18, -59, 0))
			CAM:SetName("fnafgm_Cam15")
			CAM:Spawn()
			GAMEMODE.Vars.mapoverrideok = true
		elseif game.GetMap() == "fnaf4versus" then
			local spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-640, -8, -136))
			spawn:SetAngles(Angle(0, 180, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-600, 172, -136))
			spawn:SetAngles(Angle(0, 180, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-738, 71, -136))
			spawn:SetAngles(Angle(0, 0, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-508, -24, -136))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-416, 56, -136))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-524, 86, -136))
			spawn:SetAngles(Angle(0, 0, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-728, -150, 0))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-560, -128, 0))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_terrorist")
			spawn:SetPos(Vector(-640, -58, 0))
			spawn:SetAngles(Angle(0, 90, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(-2519, -770, -68))
			spawn:SetAngles(Angle(0, 30, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(-2450, 1770, -68))
			spawn:SetAngles(Angle(0, -30, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(1260, 1955, -68))
			spawn:SetAngles(Angle(0, -130, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(1108, -929, -68))
			spawn:SetAngles(Angle(0, 130, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(-2466, -160, -68))
			spawn:SetAngles(Angle(0, 36, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(-2453, 1168, -68))
			spawn:SetAngles(Angle(0, -30, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(990, 937, -68))
			spawn:SetAngles(Angle(0, -140, 0))
			spawn:Spawn()
			spawn = ents.Create("info_player_counterterrorist")
			spawn:SetPos(Vector(1111, 150, -68))
			spawn:SetAngles(Angle(0, 130, 0))
			spawn:Spawn()
			GAMEMODE.Vars.mapoverrideok = true
		elseif not GAMEMODE.Vars.mapoverrideok then
			for k, v in pairs(ents.FindByClass("point_camera")) do
				local CAM = ents.Create("fnafgm_camera")
				CAM:SetPos(v:GetPos())
				CAM:SetAngles(v:GetAngles())
				CAM:SetName("fnafgm_" .. v:GetName())
				if v:GetKeyValues().parentname ~= "" then
					local parent = ents.FindByName(v:GetKeyValues().parentname)[1]
					if IsValid(parent) then CAM:SetParent(parent) end
				end
				CAM:Spawn()
			end

			GAMEMODE.Vars.mapoverrideok = true
			GAMEMODE:Log("There is no map overrides for this map...")
		end

		GAMEMODE:Log("Map overrides done")
	end
end

function fnafgmVarsUpdate()
	net.Start("fnafgmVarsUpdate")
	net.WriteBit(GAMEMODE.Vars.startday)
	net.WriteBit(GAMEMODE.Vars.gameend)
	net.WriteBit(GAMEMODE.Vars.iniok)
	net.WriteInt(GAMEMODE.Vars.time or 0, 5)
	net.WriteString(GAMEMODE.Vars.AMPM or "AM")
	net.WriteInt(GAMEMODE.Vars.night or 0, 32)
	net.WriteBit(GAMEMODE.Vars.nightpassed)
	net.WriteBit(GAMEMODE.Vars.tempostart)
	net.WriteBit(GAMEMODE.Vars.mute)
	net.WriteBit(GAMEMODE.Vars.overfive)
	net.WriteBit(GAMEMODE.Vars.gamemode_init_done)
	net.Broadcast()
end

function fnafgmTimeThink()
	if GAMEMODE.Vars.time == 12 and GAMEMODE.Vars.AMPM == "AM" then
		GAMEMODE.Vars.time = 1
	elseif GAMEMODE.Vars.time == 11 and GAMEMODE.Vars.AMPM == "AM" then
		GAMEMODE.Vars.time = 12
		GAMEMODE.Vars.AMPM = "PM"
	elseif GAMEMODE.Vars.time == 11 and GAMEMODE.Vars.AMPM == "PM" then
		GAMEMODE.Vars.time = 12
		GAMEMODE.Vars.AMPM = "AM"
		GAMEMODE.Vars.night = GAMEMODE.Vars.night + 1
	elseif GAMEMODE.Vars.time == 12 and GAMEMODE.Vars.AMPM == "PM" then
		GAMEMODE.Vars.time = 1
	else
		GAMEMODE.Vars.time = GAMEMODE.Vars.time + 1
	end

	GAMEMODE:Log(GAMEMODE.Vars.time .. GAMEMODE.Vars.AMPM .. " (Power left: " .. GAMEMODE.Vars.power .. "%)")
	if GAMEMODE.Vars.time == GAMEMODE.TimeEnd and GAMEMODE.Vars.night >= GAMEMODE.NightEnd and GAMEMODE.Vars.AMPM == GAMEMODE.AMPM_End and not fnafgm_timethink_infinitenights:GetBool() then
		GAMEMODE:Log("Last night passed (" .. GAMEMODE.Vars.night .. ") (Power left: " .. GAMEMODE.Vars.power .. "%)")
		GAMEMODE.Vars.startday = false
		GAMEMODE.Vars.gameend = true
		timer.Remove("fnafgmTimeThink")
		timer.Remove("fnafgmPowerOff1")
		timer.Remove("fnafgmPowerOff2")
		timer.Remove("fnafgmPowerOff3")
		GAMEMODE.Vars.poweroff = false
		GAMEMODE.Vars.powerchecktime = nil
		GAMEMODE.Vars.oldpowerdrain = nil
		GAMEMODE.Vars.foxyknockdoorpena = 2
		GAMEMODE.Vars.addfoxyknockdoorpena = 4
		table.Empty(GAMEMODE.Vars.tabused)
		table.Empty(GAMEMODE.Vars.usingsafedoor)
		for k, v in pairs(player.GetAll()) do
			if v:GetViewEntity() ~= v then v:SetViewEntity(v) end
			if v:Team() == 1 then
				v:ConCommand("pp_mat_overlay ''")
				v:AddFrags(1)
			end
		end
		game.CleanUpMap()
		if GAMEMODE.Vars.night > GAMEMODE.NightEnd then GAMEMODE.Vars.overfive = true end
		for k, v in pairs(player.GetAll()) do
			if game.SinglePlayer() then --Stop sound
				v:ConCommand("stopsound")
			else
				v:SendLua([[RunConsoleCommand("stopsound")]])
			end

			if GAMEMODE.FT == 2 then
				v:ConCommand("play " .. GAMEMODE.Sound_endnight2)
			else
				v:ConCommand("play " .. GAMEMODE.Sound_endnight)
			end
			v:ConCommand("pp_mat_overlay ''")
			v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 65536)
			if (v:Team() == 1 or v:Team() == 2) and v:Alive() then v:KillSilent() end
			v:SendLua([[GAMEMODE:SaveProgress()]])
		end

		if game.IsDedicated() then GAMEMODE:SaveProgress() end
		timer.Create("fnafgmNightPassed", 11, 1, function()
			fnafgmResetGame()
			if not game.IsDedicated() then GAMEMODE.Vars.night = GAMEMODE.NightEnd end
			fnafgmMapOverrides()
			if file.Exists("materials/" .. string.lower(GAMEMODE.ShortName) .. "/endscreen/" .. game.GetMap() .. "_en" .. ".vmt", "GAME") or file.Exists("materials/fnafgm/endscreen/" .. game.GetMap() .. "_en" .. ".vmt", "GAME") then
				local plus = false
				if GAMEMODE.Vars.night > GAMEMODE.NightEnd then plus = true end
				net.Start("fnafgmShowCheck")
				net.WriteBit(true)
				net.WriteBit(plus)
				net.Broadcast()
				for k, v in pairs(player.GetAll()) do
					v:ScreenFade(16, color_black, 0, 0)
					if v:Team() == 1 or v:Team() == 2 then
						v:SetTeam(TEAM_UNASSIGNED)
						if GAMEMODE.Sound_end[game.GetMap()] then
							v:SendLua([[LocalPlayer():EmitSound("fnafgm_end_"..game.GetMap())]])
						end
					end
				end

				timer.Create("fnafgmAfterCheck", 19.287, 1, function()
					for k, v in pairs(team.GetPlayers(TEAM_UNASSIGNED)) do
						v:SetTeam(1)
						v:Spawn()
					end

					timer.Remove("fnafgmAfterCheck")
				end)
			else
				for k, v in pairs(player.GetAll()) do
					v:ScreenFade(16, color_black, 0, 0)
					if v:Team() == 1 or v:Team() == 2 then v:Spawn() end
				end
			end

			GAMEMODE.Vars.gameend = false
			GAMEMODE.Vars.norespawn = false
			fnafgmVarsUpdate()
			if GAMEMODE.Vars.night == GAMEMODE.NightEnd then
				GAMEMODE:Log("Ready to start the hell!")
			else
				GAMEMODE:Log("Ready to start a new week!")
			end
			timer.Remove("fnafgmNightPassed")
		end)
	elseif GAMEMODE.Vars.time == GAMEMODE.TimeEnd and GAMEMODE.Vars.AMPM == GAMEMODE.AMPM_End and not fnafgm_timethink_endlesstime:GetBool() then
		GAMEMODE:Log("Night " .. GAMEMODE.Vars.night .. " passed (Power left: " .. GAMEMODE.Vars.power .. "%)")
		GAMEMODE.Vars.startday = false
		GAMEMODE.Vars.nightpassed = true
		timer.Remove("fnafgmTimeThink")
		timer.Remove("fnafgmPowerOff1")
		timer.Remove("fnafgmPowerOff2")
		timer.Remove("fnafgmPowerOff3")
		GAMEMODE.Vars.powerchecktime = nil
		GAMEMODE.Vars.oldpowerdrain = nil
		GAMEMODE.Vars.poweroff = false
		GAMEMODE.Vars.foxyknockdoorpena = 2
		GAMEMODE.Vars.addfoxyknockdoorpena = 4
		game.CleanUpMap()
		table.Empty(GAMEMODE.Vars.LightUse)
		table.Empty(GAMEMODE.Vars.DoorClosed)
		GAMEMODE.Vars.mapoverrideok = false
		fnafgmMapOverrides()
		table.Empty(GAMEMODE.Vars.tabused)
		table.Empty(GAMEMODE.Vars.usingsafedoor)
		for k, v in pairs(player.GetAll()) do
			if game.SinglePlayer() then --Stop sound
				v:ConCommand("stopsound")
			else
				v:SendLua([[RunConsoleCommand("stopsound")]])
			end

			if GAMEMODE.FT == 2 then
				v:ConCommand("play " .. GAMEMODE.Sound_endnight2)
			else
				v:ConCommand("play " .. GAMEMODE.Sound_endnight)
			end

			v:ConCommand("pp_mat_overlay ''")
			if v:Team() == 1 then v:AddFrags(1) end
			v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 65536)
			if (v:Team() == 1 or v:Team() == 2) and v:Alive() then v:KillSilent() end
			v:SendLua([[GAMEMODE:SaveProgress()]])
		end

		GAMEMODE:SaveProgress()
		timer.Create("fnafgmNightPassed", 11, 1, function()
			for k, v in pairs(player.GetAll()) do
				v:ScreenFade(16, color_black, 0, 0)
				if v:Team() == 1 or v:Team() == 2 then v:Spawn() end
			end

			GAMEMODE.Vars.nightpassed = false
			GAMEMODE.Vars.norespawn = false
			fnafgmVarsUpdate()
			GAMEMODE:Log("Ready to start a new night")
			timer.Remove("fnafgmNightPassed")
		end)
	end

	fnafgmVarsUpdate()
end

function GM:FinishMove(ply, mv)
	local userid = ply:UserID()
	local IsOnSecurityRoom = GAMEMODE:CheckPlayerSecurityRoom(ply)
	if not ply.IsOnSecurityRoom or ply.IsOnSecurityRoom ~= IsOnSecurityRoom then ply.IsOnSecurityRoom = IsOnSecurityRoom end
	if fnafgm_killextsrplayers:GetBool() and IsOnSecurityRoom ~= nil then
		if IsOnSecurityRoom or not ply:Alive() then
			if timer.Exists("fnafgmPlayerSecurityRoomNot" .. userid) then timer.Remove("fnafgmPlayerSecurityRoomNot" .. userid) end
		elseif not IsOnSecurityRoom and not timer.Exists("fnafgmPlayerSecurityRoomNot" .. userid) and ply:Alive() and GAMEMODE.Vars.startday and not GAMEMODE.Vars.tempostart and ply:Team() == 1 and not fnafgmPlayerCanByPass(ply, "nokillextsr") then
			local PSRTT = 5
			if game.GetMap() == "fnaf2noevents" then PSRTT = 21 end
			timer.Create("fnafgmPlayerSecurityRoomNot" .. userid, PSRTT, 1, function()
				if IsValid(ply) then
					ply:SendLua([[LocalPlayer():EmitSound("fnafgm_4_1")]])
					ply:Kill()
					GAMEMODE:Log(ply:GetName() .. " is dead by the outside!")
				end

				timer.Remove("fnafgmPlayerSecurityRoomNot" .. userid)
			end)
		end
	end

	if drive.FinishMove(ply, mv) then return true end
	if player_manager.RunClass(ply, "FinishMove", mv) then return true end
end

concommand.Add("fnafgm_debug_info", function(ply)
	local txt = "\n \n[DEBUG INFO]\n \n"
	local function appendtxt(str) txt = txt .. " " .. str .. "\n" end
	local function appendtxtl(str) txt = txt .. "  > " .. str .. "\n" end
	local function linebreak() txt = txt .. "\n \n" end
	local convars = {fnafgm_deathscreendelay, fnafgm_deathscreenduration,
		fnafgm_autorespawn, fnafgm_allowflashlight, fnafgm_respawnenabled,
		fnafgm_deathscreenfade, fnafgm_deathscreenoverlay, fnafgm_ragdollinstantremove,
		fnafgm_ragdolloverride, fnafgm_autocleanupmap, fnafgm_preventdoorkill,
		fnafgm_timethink_endlesstime, fnafgm_timethink_infinitenights,
		fnafgm_forceseasonalevent, fnafgm_killextsrplayers, fnafgm_playermodel,
		fnafgm_playerskin, fnafgm_playerbodygroups, fnafgm_playercolor,
		fnafgm_respawndelay, fnafgm_enablebypass, fnafgm_timethink_autostart,
		fnafgm_timethink_autostartdelay, fnafgm_disablemapsmonitors, fnafgm_disablepower,
		fnafgm_forcesavingloading, fnafgm_enablecreatorsbypass, fnafgm_enabledevmode,
		fnafgm_sgvsa, fnafgm_autorestartmap}

	appendtxt(GAMEMODE.Name .. " Gamemode V" .. tostring(GAMEMODE.Version or "error") .. " by " .. GAMEMODE.Author)
	if not GAMEMODE.Official then appendtxt("Derived from Five Nights at Freddy's Gamemode V" .. tostring(GAMEMODE.OfficialVersion or "error") .. " by Xperidia") end
	linebreak()
	appendtxtl("Is FNAFGM mounted from WorkShop? " .. tostring(GAMEMODE.Vars.fnafgmWorkShop))
	linebreak()
	appendtxtl("Windows? " .. tostring(system.IsWindows()))
	appendtxtl("OSX? " .. tostring(system.IsOSX()))
	appendtxtl("Linux? " .. tostring(system.IsLinux()))
	linebreak()
	appendtxtl("SINGLEPLAYER? " .. tostring(game.SinglePlayer()))
	appendtxtl("SERVER? " .. tostring(SERVER))
	appendtxtl("DS? " .. tostring(game.IsDedicated()))
	linebreak()
	appendtxtl("MAP: " .. game.GetMap())
	appendtxtl("MAP Version: " .. tostring(game.GetMapVersion()))
	linebreak()
	appendtxt("[CONVARS]")
	for k, v in pairs(convars) do
		appendtxtl(v:GetName() .. " " .. v:GetString())
	end
	linebreak()
	appendtxt("[GAME VARS]")
	for k, v in pairs(GAMEMODE.Vars) do
		appendtxtl(tostring(k) .. " = " .. tostring(v))
	end
	linebreak()
	appendtxt("[PlayerUse Hooks]")
	for k, v in pairs(hook.GetTable()["PlayerUse"]) do
		appendtxtl(tostring(k))
	end
	linebreak()

	if not game.IsDedicated() or (IsValid(ply) and fnafgmPlayerCanByPass(ply, "debug")) then
		for k, v in pairs(string.Explode("\n", txt)) do
			ply:PrintMessage(HUD_PRINTCONSOLE, v)
		end
	elseif not IsValid(ply) then
		print(txt)
	end
end)

function fnafgmPlayerCanByPass(ply, what)
	if not IsValid(ply) then return end
	if (fnafgm_enablebypass:GetBool() or game.IsDedicated()) and ply:IsAdmin() then
		return true
	elseif (GAMEMODE:CheckCreator(ply) or GAMEMODE:CheckDerivCreator(ply)) and fnafgm_enablecreatorsbypass:GetBool() then
		return true
	elseif GAMEMODE:CustomCheck(ply, what) then
		return true
	else
		return false
	end
end

concommand.Add("fnafgm_version", function(ply)
	if IsValid(ply) then
		ply:PrintMessage(HUD_PRINTCONSOLE, GAMEMODE.Name .. " Gamemode V" .. tostring(GAMEMODE.Version or "error") .. " by " .. GAMEMODE.Author)
		if not GAMEMODE.Official then ply:PrintMessage(HUD_PRINTCONSOLE, "Derived from Five Nights at Freddy's Gamemode V" .. tostring(GAMEMODE.OfficialVersion or "error") .. " by VickyFrenzy@Xperidia") end
	else
		print(GAMEMODE.Name .. " Gamemode V" .. tostring(GAMEMODE.Version or "error") .. " by " .. GAMEMODE.Author)
		if not GAMEMODE.Official then print("Derived from Five Nights at Freddy's Gamemode V" .. tostring(GAMEMODE.OfficialVersion or "error") .. " by VickyFrenzy@Xperidia") end
	end
end)

function fnafgmSetView(ply, id)
	local cam = ents.FindByName("Cam" .. id)[1]
	local fnafgmCam = ents.FindByName("fnafgm_Cam" .. id)[1]
	local isok = false
	if IsValid(fnafgmCam) and IsValid(ply) then
		ply:SetViewEntity(fnafgmCam)
		isok = true
	elseif IsValid(cam) and IsValid(ply) then
		cam:Fire("SetOn")
		ply:SetViewEntity(cam)
		isok = true
	elseif IsValid(ply) and id == 0 then
		ply:SetViewEntity(ply)
		isok = true
	elseif IsValid(ply) and id == 11 then
		local cam = ents.FindByName("fnafgm_CamOff")[1]
		if IsValid(cam) then
			ply:SetViewEntity(cam)
			isok = true
		end
	end

	if isok then ply.lastcam = id end
	if id == 0 then return end
	if GAMEMODE.CamsNames[game.GetMap() .. "_" .. id] then
		GAMEMODE:Log(ply:GetName() .. " requested " .. GAMEMODE.CamsNames[game.GetMap() .. "_" .. id] .. " camera (" .. id .. ") | Granted? " .. tostring(isok), nil, true)
	else
		GAMEMODE:Log(ply:GetName() .. " requested camera " .. id .. " | Granted? " .. tostring(isok), nil, true)
	end
end
net.Receive("fnafgmSetView", function(bits, ply)
	local id = net.ReadFloat()
	if not id then return end
	fnafgmSetView(ply, id)
end)

function fnafgmMuteCall()
	local call = ents.FindByName("Callman")[1]
	if IsValid(call) then
		call:Fire("use")
	else
		call = ents.FindByName("fnafgm_CallButton")[1]
		if IsValid(call) then call:Fire("use") end
	end
end
net.Receive("fnafgmMuteCall", function(bits, ply) fnafgmMuteCall() end)

function fnafgmSafeZone(ply)
	if not IsValid(ply) then return end
	if not GAMEMODE.Vars.usingsafedoor[ply] then
		ply:SetPos(Vector(-46, -450, 0))
		if IsValid(SafeZoneCam) then ply:SetViewEntity(SafeZoneCam) end
		ply:ConCommand("pp_mat_overlay " .. GAMEMODE.Materials_fnaf2deathcam)
		GAMEMODE.Vars.usingsafedoor[ply] = true
	elseif GAMEMODE.Vars.usingsafedoor[ply] then
		ply:SetPos(GAMEMODE.FNaFView[game.GetMap()][1])
		ply:SetEyeAngles(GAMEMODE.FNaFView[game.GetMap()][2])
		ply:SetViewEntity(ply)
		ply:ConCommand("pp_mat_overlay ''")
		GAMEMODE.Vars.usingsafedoor[ply] = false
	end
end
net.Receive("fnafgmSafeZone", function(bits, ply) fnafgmSafeZone(ply) end)

function fnafgmShutLights()
	if game.GetMap() == "fnaf2noevents" then return end
	if not fnafgm_smart_power_management:GetBool() then return end
	if light1 and IsValid(light1) and GAMEMODE.Vars.LightUse[1] then light1:Fire("use") end
	if light2 and IsValid(light2) and GAMEMODE.Vars.LightUse[2] then light2:Fire("use") end
end

net.Receive("fnafgmShutLights", function(bits, ply) fnafgmShutLights() end)
function fnafgmUseLight(id, ply)
	if id == 1 and light1 and IsValid(light1) and not GAMEMODE.Vars.light1usewait then
		fnafgmUse(ply, light1, false, true)
	elseif id == 2 and light2 and IsValid(light2) and not GAMEMODE.Vars.light2usewait then
		fnafgmUse(ply, light2, false, true)
	elseif id == 3 and light3 and IsValid(light3) and not GAMEMODE.Vars.light3usewait then
		fnafgmUse(ply, light3, false, true)
	end
end

net.Receive("fnafgmUseLight", function(bits, ply)
	local id = net.ReadFloat()
	if not id then return end
	fnafgmUseLight(id, ply)
end)

concommand.Add("fnafgm_debug_start", function(ply) GAMEMODE:StartNight(ply) end)

concommand.Add("fnafgm_debug_reset", function(ply)
	if (IsValid(ply) and fnafgmPlayerCanByPass(ply, "debug")) or not IsValid(ply) then
		fnafgmResetGame()
		fnafgmMapOverrides()
		fnafgmVarsUpdate()
		net.Start("fnafgmNotif")
		net.WriteString("gamebeenreset")
		net.WriteInt(4, 3)
		net.WriteFloat(5)
		net.WriteBit(true)
		net.Broadcast()
		if IsValid(ply) then
			GAMEMODE:Log("The game has been reset by " .. ply:GetName())
		else
			GAMEMODE:Log("The game has been reset by console")
		end
	elseif IsValid(ply) then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! (Need debug access)")
		net.Start("fnafgmNotif")
		net.WriteString("Nope, you can't do that! (Need debug access)")
		net.WriteInt(1, 3)
		net.WriteFloat(5)
		net.WriteBit(true)
		net.Send(ply)
	end
end)

concommand.Add("fnafgm_debug_refreshbypass", function(ply)
	if (IsValid(ply) and fnafgmPlayerCanByPass(ply, "debug")) or not IsValid(ply) then
		GAMEMODE:RefreshBypass()
	end
end)

concommand.Add("fnafgm_debug_restart", function(ply)
	if (IsValid(ply) and fnafgmPlayerCanByPass(ply, "debug")) or not IsValid(ply) then
		if GAMEMODE.Vars.iniok and GAMEMODE.Vars.mapoverrideok and GAMEMODE.Vars.startday and GAMEMODE.Vars.active then
			GAMEMODE.Vars.norespawn = true
			for k, v in pairs(player.GetAll()) do
				if (v:Team() == 1 or v:Team() == 2) and v:Alive() then v:KillSilent() end
			end

			if IsValid(ply) then
				GAMEMODE:Log("The game will be stoped/restarted by " .. ply:GetName())
			else
				GAMEMODE:Log("The game will be stoped/restarted by console")
			end
		end
	elseif IsValid(ply) then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! (Need debug access)")
		net.Start("fnafgmNotif")
		net.WriteString("Nope, you can't do that! (Need debug access)")
		net.WriteInt(1, 3)
		net.WriteFloat(5)
		net.WriteBit(true)
		net.Send(ply)
	end
end)

function GM:PlayerSwitchFlashlight(ply, on)
	if not on then return true end
	if ply:Team() == 1 and fnafgm_allowflashlight:GetBool() or fnafgmPlayerCanByPass(ply, "flashlight") then
		return true
	end

	if GAMEMODE.FT == 2 and not GAMEMODE.Vars.poweroff then return true end
	if GAMEMODE.FT == 2 and GAMEMODE.Vars.poweroff then
		ply:SendLua([[LocalPlayer():EmitSound("fnafgm_lighterror")]])
	end
	if fnafgm_sandbox_enable:GetBool() then return true end
	return false
end

function GM:PlayerSay(ply, text, teamonly)
	local comm = string.lower(text)
	if comm == "!start" then
		self:StartNight(ply)
	elseif comm == "/start" then
		self:StartNight(ply)
		return ""
	elseif comm == "!" .. string.lower(self.ShortName) then
		ply:SendLua("fnafgmMenu()")
	elseif comm == "/" .. string.lower(self.ShortName) then
		ply:SendLua("fnafgmMenu()")
		return ""
	end
	return text
end

function GM:Think()
	hook.Call("fnafgmCustomPowerCalc")
	if GAMEMODE.Vars.iniok and GAMEMODE.Vars.mapoverrideok and GAMEMODE.Vars.startday and GAMEMODE.Vars.active and (game.GetMap() == "freddysnoevent") then
		GAMEMODE.Vars.powerusage = GAMEMODE.Power_Usage_Base
		if GAMEMODE.Vars.poweroff or fnafgm_disablepower:GetBool() then
			GAMEMODE.Vars.powerusage = 0
		else
			local tabactualuse = false --Calc tab usage
			for k, v in pairs(team.GetPlayers(1)) do
				if GAMEMODE.Vars.tabused[v] and GAMEMODE.Vars.tabused[v] == true then tabactualuse = true end
			end

			if tabactualuse then -- Tab use
				GAMEMODE.Vars.powerusage = GAMEMODE.Vars.powerusage + 1
			end

			if GAMEMODE.Vars.DoorClosed[1] then -- Door 1 use
				GAMEMODE.Vars.powerusage = GAMEMODE.Vars.powerusage + 1
			end

			if GAMEMODE.Vars.DoorClosed[2] then -- Door 2 use
				GAMEMODE.Vars.powerusage = GAMEMODE.Vars.powerusage + 1
			end

			if GAMEMODE.Vars.LightUse[1] or GAMEMODE.Vars.LightUse[2] then -- Lights use
				GAMEMODE.Vars.powerusage = GAMEMODE.Vars.powerusage + 1
			end

			if GAMEMODE.Vars.AprilFool or fnafgm_forceseasonalevent:GetInt() == 2 then -- Troll use
				GAMEMODE.Vars.powerusage = GAMEMODE.Vars.powerusage + 5
			end
		end

		if GAMEMODE.Vars.powerusage == 0 then
			GAMEMODE.Vars.powerdrain = 0
		else
			GAMEMODE.Vars.powerdrain = GAMEMODE.Power_Drain_Time
			for i = 1, GAMEMODE.Vars.powerusage - 1 do
				GAMEMODE.Vars.powerdrain = GAMEMODE.Vars.powerdrain / 2
			end

			if GAMEMODE.Vars.powerchecktime == nil and GAMEMODE.Vars.oldpowerdrain == nil and not GAMEMODE.Vars.poweroff then
				GAMEMODE.Vars.powerchecktime = CurTime() + GAMEMODE.Vars.powerdrain
				GAMEMODE.Vars.oldpowerdrain = GAMEMODE.Vars.powerdrain
			elseif GAMEMODE.Vars.powerchecktime ~= nil and GAMEMODE.Vars.oldpowerdrain ~= nil and not GAMEMODE.Vars.poweroff then
				local calcchangepower = GAMEMODE.Vars.oldpowerdrain - GAMEMODE.Vars.powerdrain
				if GAMEMODE.Vars.powerchecktime <= CurTime() + calcchangepower then
					GAMEMODE.Vars.powerchecktime = nil
					GAMEMODE.Vars.oldpowerdrain = nil
					GAMEMODE.Vars.power = GAMEMODE.Vars.power - 1
					ents.FindByName("Powerlvl")[1]:Fire("SetValue", 100)
				end
			end
		end

		if GAMEMODE.Vars.power <= 0 and not GAMEMODE.Vars.poweroff then
			GAMEMODE.Vars.power = 0
			ents.FindByName("Powerlvl")[1]:Fire("SetValue", 1)
			ents.FindByName("doorbeam1")[1]:Fire("LightOff")
			ents.FindByName("doorbeam2")[1]:Fire("LightOff")
			if game.GetMap() == "freddysnoevent" then
				for k, v in pairs(ents.FindByClass("light")) do
					v:Fire("TurnOff")
				end
				for k, v in pairs(ents.FindByClass("light_spot")) do
					v:Fire("TurnOff")
				end
				for k, v in pairs(ents.FindByClass("env_projectedtexture")) do
					v:Fire("TurnOff")
				end

				for k, v in pairs(GAMEMODE.Vars.Animatronics) do
					GAMEMODE:SetAnimatronicPos(nil, k, GAMEMODE.APos[game.GetMap()].SS)
					timer.Remove("fnafgmAnimatronicMove" .. k)
				end

				timer.Create("fnafgmPowerOff1", 5, 1, function()
					local fred = GAMEMODE.Vars.Animatronics[GAMEMODE.Animatronic.Freddy][1]
					if IsValid(fred) then
						fred:SetPos(Vector(-206, -1172, 65))
						fred:SetAngles(Angle(0, 0, 0))
					end

					for k, v in pairs(player.GetAll()) do
						v:ConCommand("play " .. "freddys/muffledtune.wav")
						if v:Team() == 1 and v:Alive() and not v.IsOnSecurityRoom then v:SetPos(Vector(-80, -1224, 64)) end
					end

					timer.Remove("fnafgmPowerOff1")
				end)

				timer.Create("fnafgmPowerOff2", 24.58, 1, function()
					for k, v in pairs(team.GetPlayers(1)) do
						v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 65536)
					end
					timer.Remove("fnafgmPowerOff2")
				end)

				timer.Create("fnafgmPowerOff3", 29.58, 1, function()
					for k, v in pairs(team.GetPlayers(1)) do
						if v:Alive() then
							v:Kill()
							v:ConCommand("pp_mat_overlay fnafgm/screamers/freddysnoevent_0")
							v:SendLua([[LocalPlayer():EmitSound("fnafgm_scream")]])
						end
					end
					timer.Remove("fnafgmPowerOff3")
				end)
			end

			GAMEMODE.Vars.poweroff = true
			GAMEMODE.Vars.norespawn = true
			GAMEMODE:Log("The power is gone :)")
		end

		fnafgmPowerUpdate()
	elseif GAMEMODE.Vars.iniok and GAMEMODE.Vars.mapoverrideok and GAMEMODE.Vars.startday and GAMEMODE.Vars.active and (game.GetMap() == "fnaf2noevents") then
		GAMEMODE.Vars.powerusage = 0
		if not GAMEMODE.Vars.poweroff and not fnafgm_disablepower:GetBool() then
			if GAMEMODE.Vars.LightUse[1] or GAMEMODE.Vars.LightUse[2] or GAMEMODE.Vars.LightUse[3] then -- Lights use
				GAMEMODE.Vars.powerusage = GAMEMODE.Vars.powerusage + 1
			end

			for k, v in pairs(ents.FindByClass("fnafgm_camera")) do
				if v.GetLightState and v:GetLightState() then
					GAMEMODE.Vars.powerusage = GAMEMODE.Vars.powerusage + 1
					break
				end
			end

			for k, v in pairs(team.GetPlayers(1)) do
				if v:FlashlightIsOn() then
					GAMEMODE.Vars.powerusage = GAMEMODE.Vars.powerusage + 1
				end
			end
		end

		if GAMEMODE.Vars.powerusage == 0 or not GAMEMODE.Vars.powerchecktime then
			GAMEMODE.Vars.powerchecktime = CurTime() + 1
		else
			if GAMEMODE.Vars.powerchecktime <= CurTime() then
				GAMEMODE.Vars.powerchecktime = CurTime() + 1
				GAMEMODE.Vars.power = GAMEMODE.Vars.power - 1
			end
		end

		if GAMEMODE.Vars.power == 0 and not GAMEMODE.Vars.poweroff then
			GAMEMODE.Vars.poweroff = true
			for k, v in pairs(team.GetPlayers(1)) do
				if v:FlashlightIsOn() and not fnafgmPlayerCanByPass(v, "flashlight") then
					v:Flashlight(false)
					v:SendLua([[LocalPlayer():EmitSound("fnafgm_lighterror")]])
				end
			end

			GAMEMODE:Log("The battery is dead")
		end

		fnafgmPowerUpdate()
	end

	if not GAMEMODE.Vars.checkRestartNight and GAMEMODE.Vars.iniok and GAMEMODE.Vars.mapoverrideok and GAMEMODE.Vars.startday and GAMEMODE.Vars.active then
		GAMEMODE.Vars.checkRestartNight = true
		local alive = false
		for k, v in pairs(player.GetAll()) do
			if v:Alive() and v:Team() == 1 then alive = true end
		end

		if not alive then
			GAMEMODE.Vars.norespawn = true
			for k, v in pairs(GAMEMODE.Vars.Animatronics) do
				timer.Remove("fnafgmAnimatronicMove" .. k)
			end

			if not game.SinglePlayer() then
				net.Start("fnafgmNotif")
				net.WriteString("The " .. tostring(GAMEMODE.TranslatedStrings.night or GAMEMODE.Strings.en.night) .. " will be reset in " .. fnafgm_deathscreendelay:GetInt() + fnafgm_deathscreenduration:GetInt() + fnafgm_respawndelay:GetInt() .. "s...")
				net.WriteInt(0, 3)
				net.WriteFloat(5)
				net.WriteBit(true)
				net.Broadcast()
				GAMEMODE:Log("The security guards are dead, the night will be reset")
			end

			hook.Call("fnafgmGeneralDeath")
			timer.Remove("fnafgmTimeThink")
			timer.Remove("fnafgmPowerOff1")
			timer.Remove("fnafgmPowerOff2")
			timer.Remove("fnafgmPowerOff3")

			local delay = fnafgm_deathscreendelay:GetInt() + fnafgm_deathscreenduration:GetInt() + fnafgm_respawndelay:GetInt()

			if game.SinglePlayer() then delay = fnafgm_deathscreendelay:GetInt() + fnafgm_deathscreenduration:GetInt() + 2 end

			timer.Create("fnafgmPreRestartNight", delay, 1, function()
				for k, v in pairs(player.GetAll()) do
					if (v:Team() == 1 or v:Team() == 2) and v:Alive() then v:KillSilent() end
					if v:Team() == 2 then v:AddFrags(1) end
				end

				timer.Remove("fnafgmPreRestartNight")
			end)

			timer.Create("fnafgmRestartNight", delay + 0.1, 1, function()
				if not GAMEMODE:RestartMapIfWeShould() then fnafgmRestartNight() end
				timer.Remove("fnafgmRestartNight")
			end)
		else
			GAMEMODE.Vars.checkRestartNight = false
		end
	end
end

function fnafgmPowerUpdate()
	net.Start("fnafgmPowerUpdate")
	net.WriteInt(GAMEMODE.Vars.power or 0, 20)
	net.WriteInt(GAMEMODE.Vars.powerusage or 0, 6)
	net.WriteBit(GAMEMODE.Vars.poweroff)
	net.WriteInt(GAMEMODE.Vars.powertot or GAMEMODE.Power_Max or 100, 16)
	net.Broadcast()
end

net.Receive("fnafgmTabUsed", function(len, ply)
	local state = tobool(net.ReadBit())
	GAMEMODE.Vars.tabused[ply] = state
	if state then
		GAMEMODE:Log(ply:GetName() .. " is using the monitor")
	elseif not state then
		GAMEMODE:Log(ply:GetName() .. " closed the monitor")
	end
end)

net.Receive("fnafgmfnafViewActive", function(len, ply) ply.fnafviewactive = tobool(net.ReadBit()) end)

function GM:PlayerShouldTaunt(ply, actid)
	if fnafgmPlayerCanByPass(ply, "act") or fnafgm_sandbox_enable:GetBool() then return true end
	ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! (Need act bypass)")
	net.Start("fnafgmNotif")
	net.WriteString("Nope, you can't do that! (Need act bypass)")
	net.WriteInt(1, 3)
	net.WriteFloat(5)
	net.WriteBit(true)
	net.Send(ply)
	return false
end

concommand.Add("autoteam", function(ply)
	if team.NumPlayers(2) >= 4 then hook.Call("PlayerRequestTeam", GAMEMODE, ply, 1) end
	local ID = math.random(1, 2)
	if ply:Team() == 1 then
		hook.Call("PlayerRequestTeam", GAMEMODE, ply, 2)
	elseif ply:Team() == 2 then
		hook.Call("PlayerRequestTeam", GAMEMODE, ply, 1)
	else
		hook.Call("PlayerRequestTeam", GAMEMODE, ply, math.random(1, 2))
	end
end)

function GM:PlayerCanHearPlayersVoice(pListener, pTalker)
	if pListener:Team() == TEAM_UNASSIGNED or pTalker:Team() == TEAM_UNASSIGNED then return false, false end
	return true, false
end

function GM:ShowHelp(ply)
	ply:SendLua("fnafgmMenu()")
end

function GM:ShutDown()
	for k, v in pairs(player.GetAll()) do
		if v:GetViewEntity() ~= v then v:SetViewEntity(v) end
	end

	if GetConVar("sv_loadingurl"):GetString() == "https://assets.xperidia.com/garrysmod/loading.html#auto"
	or GetConVar("sv_loadingurl"):GetString() == "https://xperidia.com/GMOD/loading/?auto" then
		RunConsoleCommand("sv_loadingurl", "") --Put back the default Garry's Mod loading screen...
	end
end

concommand.Add("fnafgm_debug_createcamera", function(ply, str)
	if IsValid(ply) and fnafgmPlayerCanByPass(ply, "debug") then
		GAMEMODE:CreateCamera(nil, nil, nil, nil, nil, nil, ply)
	elseif IsValid(ply) then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! (Need debug access)")
		net.Start("fnafgmNotif")
		net.WriteString("Nope, you can't do that! (Need debug access)")
		net.WriteInt(1, 3)
		net.WriteFloat(5)
		net.WriteBit(true)
		net.Send(ply)
	end
end)
function GM:CreateCamera(x, y, z, pitch, yaw, roll, ply)
	local num = table.Count(ents.FindByClass("fnafgm_camera")) + 1
	local pos = Vector(x, y, z)
	local angles = Angle(pitch, yaw, roll)
	if IsValid(ply) then
		pos = ply:GetPos()
		angles = ply:EyeAngles()
	end
	local CAM = ents.Create("fnafgm_camera")
	CAM:SetPos(pos)
	CAM:SetAngles(angles)
	CAM:SetName("fnafgm_Cam" .. num)
	CAM:Spawn()
	if IsValid(ply) then
		GAMEMODE:Log("fnafgm_Cam" .. num .. " created by " .. ply:GetName())
	else
		GAMEMODE:Log("fnafgm_Cam" .. num .. " created by console/script", nil, true)
	end
end

concommand.Add("fnafgm_debug_createanimatronic", function(ply, str, tbl, str)
	if IsValid(ply) and fnafgmPlayerCanByPass(ply, "debug") then
		GAMEMODE:CreateAnimatronic(tonumber(tbl[1] or 0), tonumber(tbl[2] or 7), ply)
	elseif IsValid(ply) then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! (Need debug access)")
		net.Start("fnafgmNotif")
		net.WriteString("Nope, you can't do that! (Need debug access)")
		net.WriteInt(1, 3)
		net.WriteFloat(5)
		net.WriteBit(true)
		net.Send(ply)
	elseif not IsValid(ply) then
		GAMEMODE:CreateAnimatronic(tonumber(tbl[1] or 0), tonumber(tbl[2] or 7))
	end
end, nil, "Create a new Animatronic. Arguments: AType APos")

function GM:CreateAnimatronic(a, apos, ply)
	if GAMEMODE.Vars.Animatronics and GAMEMODE.Vars.Animatronics[a] and GAMEMODE.Vars.Animatronics[a][1] and IsValid(GAMEMODE.Vars.Animatronics[a][1]) then GAMEMODE.Vars.Animatronics[a][1]:Remove() end
	local ent = ents.Create("fnafgm_animatronic")
	if GAMEMODE.AnimatronicAPos[a] and GAMEMODE.AnimatronicAPos[a][game.GetMap()] and GAMEMODE.AnimatronicAPos[a][game.GetMap()][apos] then
		ent:SetPos(GAMEMODE.AnimatronicAPos[a][game.GetMap()][apos][1])
		ent:SetAngles(GAMEMODE.AnimatronicAPos[a][game.GetMap()][apos][2])
	elseif IsValid(ply) then
		ent:SetPos(ply:GetPos() or Vector(0, 0, 0))
		ent:SetAngles(ply:GetAngles() or Angle(0, 0, 0))
	end

	ent:SetAType(a or 0)
	ent:SetAPos(apos or 7)
	ent:Spawn()
	if IsValid(ply) then
		GAMEMODE:Log("Animatronic " .. ((GAMEMODE.AnimatronicName[a] .. " (" .. (a or 0) .. ")") or a or 0) .. " created by " .. ply:GetName() .. " in " .. ((GAMEMODE.CamsNames[game.GetMap() .. "_" .. apos] .. " (" .. (apos or 7) .. ")") or apos or 7))
	else
		GAMEMODE:Log("Animatronic " .. ((GAMEMODE.AnimatronicName[a] .. " (" .. (a or 0) .. ")") or a or 0) .. " created by console/script in " .. ((GAMEMODE.CamsNames[game.GetMap() .. "_" .. apos] .. " (" .. (apos or 7) .. ")") or apos or 7), nil, true)
	end
end

net.Receive("fnafgmSetAnimatronicPos", function(len, ply)
	local a = net.ReadInt(6)
	local apos = net.ReadInt(6)
	GAMEMODE:SetAnimatronicPos(ply, a, apos)
end)

function GM:SetAnimatronicPos(ply, a, apos)
	ent = GAMEMODE.Vars.Animatronics[a][1]
	if GAMEMODE.AnimatronicAPos[a] and GAMEMODE.AnimatronicAPos[a][game.GetMap()] and GAMEMODE.AnimatronicAPos[a][game.GetMap()][apos] and IsValid(ent) then
		if not GAMEMODE.Vars.startday then return end
		if IsValid(ply) and GAMEMODE.Vars.Animatronics[a][3] == -1 then return end
		if IsValid(ply) and (GAMEMODE.Vars.Animatronics[a][2] == GAMEMODE.APos[game.GetMap()].Office) then return end
		ent:SetAPos(apos or 7)
		if apos ~= GAMEMODE.APos[game.GetMap()].Office and apos ~= GAMEMODE.APos[game.GetMap()].Kitchen and apos ~= GAMEMODE.APos[game.GetMap()].SS then
			local camera = ents.FindByName("fnafgm_Cam" .. apos)[1]
			if IsValid(camera) then ent:SetEyeTarget(camera:EyePos()) end
		elseif apos ~= nil and apos == GAMEMODE.APos[game.GetMap()].SS and GAMEMODE.ASSEye[game.GetMap()] then
			ent:SetEyeTarget(GAMEMODE.ASSEye[game.GetMap()])
		end

		local cd = 0
		if not GAMEMODE.Vars.startday and GAMEMODE.AnimatronicsCD[a] and GAMEMODE.AnimatronicsCD[a][game.GetMap()] and GAMEMODE.AnimatronicsCD[a][game.GetMap()][GAMEMODE.Vars.night + 1] then
			cd = GAMEMODE.AnimatronicsCD[a][game.GetMap()][GAMEMODE.Vars.night + 1]
		elseif GAMEMODE.AnimatronicsCD[a] and GAMEMODE.AnimatronicsCD[a][game.GetMap()] and GAMEMODE.AnimatronicsCD[a][game.GetMap()][GAMEMODE.Vars.night] then
			cd = GAMEMODE.AnimatronicsCD[a][game.GetMap()][GAMEMODE.Vars.night]
		elseif GAMEMODE.AnimatronicsCD[a] and GAMEMODE.AnimatronicsCD[a][game.GetMap()] and GAMEMODE.AnimatronicsCD[a][game.GetMap()][0] then
			cd = GAMEMODE.AnimatronicsCD[a][game.GetMap()][0]
		else
			GAMEMODE:Log("Missing or incomplete cooldown info for animatronic " .. ((GAMEMODE.AnimatronicName[a] .. " (" .. (a or 0) .. ")") or a or 0) .. "!")
		end

		if apos == GAMEMODE.APos[game.GetMap()].Office then
			ent:GoJumpscare()
		elseif GAMEMODE.Vars.Animatronics[a][2] == GAMEMODE.APos[game.GetMap()].Office then
			cd = GAMEMODE.Vars.Animatronics[a][3]
		end

		if GAMEMODE.AnimatronicsSkins[a] and GAMEMODE.AnimatronicsSkins[a][game.GetMap()] and GAMEMODE.AnimatronicsSkins[a][game.GetMap()][apos] then
			ent:SetSkin(GAMEMODE.AnimatronicsSkins[a][game.GetMap()][apos])
		else
			ent:SetSkin(0)
		end

		local nflex = ent:GetFlexNum()
		for i = 0, nflex - 1 do
			ent:SetFlexWeight(i, 0)
		end

		if GAMEMODE.AnimatronicsFlex[a] and GAMEMODE.AnimatronicsFlex[a][game.GetMap()] and GAMEMODE.AnimatronicsFlex[a][game.GetMap()][apos] then
			for k, v in pairs(GAMEMODE.AnimatronicsFlex[a][game.GetMap()][apos]) do
				ent:SetFlexWeight(v[1], v[2])
			end
		end

		if GAMEMODE.AnimatronicsAnim[a] and GAMEMODE.AnimatronicsAnim[a][game.GetMap()] and GAMEMODE.AnimatronicsAnim[a][game.GetMap()][apos] then
			ent:SetSequence(ent:LookupSequence(GAMEMODE.AnimatronicsAnim[a][game.GetMap()][apos]))
			ent:ResetSequenceInfo()
			ent:SetCycle(0)
			ent:SetPlaybackRate(1)
		else
			ent:SetSequence(ent:LookupSequence("Idle_Unarmed"))
			ent:ResetSequenceInfo()
			ent:SetPlaybackRate(0)
		end

		for k, v in pairs(player.GetAll()) do
			if v:Team() == 1 and GAMEMODE.Vars.tabused[v] and (v.lastcam == apos or v.lastcam == GAMEMODE.Vars.Animatronics[a][2]) then
				v:SendLua("GAMEMODE:VideoLoss()")
			end
		end

		GAMEMODE.Vars.Animatronics[a] = {ent, apos, cd, GAMEMODE.Vars.Animatronics[a][4]}
		net.Start("fnafgmAnimatronicsList")
		net.WriteTable(GAMEMODE.Vars.Animatronics)
		net.Broadcast()
		if IsValid(ply) then
			GAMEMODE:Log("Animatronic " .. ((GAMEMODE.AnimatronicName[a] .. " (" .. (a or 0) .. ")") or a or 0) .. " moved to " .. ((GAMEMODE.CamsNames[game.GetMap() .. "_" .. apos] .. " (" .. (apos or 7) .. ")") or apos or 7) .. " by " .. ply:GetName())
		else
			GAMEMODE:Log("Animatronic " .. ((GAMEMODE.AnimatronicName[a] .. " (" .. (a or 0) .. ")") or a or 0) .. " moved to " .. ((GAMEMODE.CamsNames[game.GetMap() .. "_" .. apos] .. " (" .. (apos or 7) .. ")") or apos or 7) .. " by console/script", nil, true)
		end
	end
end

net.Receive("fnafgmAnimatronicTaunt", function(len, ply)
	local a = net.ReadInt(5)
	if IsValid(GAMEMODE.Vars.Animatronics[a][1]) then GAMEMODE.Vars.Animatronics[a][1]:Taunt(ply) end
end)

function GM:AutoMoveAnimatronic(a)
	if GAMEMODE.Vars.startday and not GAMEMODE.Vars.SGvsA and not GAMEMODE.Vars.poweroff then
		local papos = table.GetKeys(GAMEMODE.AnimatronicAPos[a][game.GetMap()])

		table.RemoveByValue(papos, GAMEMODE.APos[game.GetMap()].SS)

		if game.GetMap() == "freddysnoevent" then
			table.RemoveByValue(papos, GAMEMODE.APos["freddysnoevent"].PC)
		end

		local apos = table.Random(papos)

		apos = hook.Call("fnafgmChangeAutoMove", nil, a) or apos

		if GAMEMODE.Vars.Animatronics[a][2] ~= GAMEMODE.APos[game.GetMap()].Office then
			GAMEMODE:SetAnimatronicPos(nil, a, apos)
		end

		local randtime = math.random(GAMEMODE.AnimatronicsCD[a][game.GetMap()][GAMEMODE.Vars.night] or GAMEMODE.AnimatronicsCD[a][game.GetMap()][0], GAMEMODE.AnimatronicsMaxCD[a][game.GetMap()][GAMEMODE.Vars.night] or GAMEMODE.AnimatronicsMaxCD[a][game.GetMap()][0])
		if GAMEMODE.AnimatronicsCD[a][game.GetMap()][GAMEMODE.Vars.night] ~= -1 then
			timer.Adjust("fnafgmAnimatronicMove" .. a, randtime, 0, function() GAMEMODE:AutoMoveAnimatronic(a) end)
		end
		if a == GAMEMODE.Animatronic.Freddy then
			GAMEMODE.Vars.Animatronics[a][1]:Taunt()
		end
	elseif not GAMEMODE.Vars.startday then
		timer.Remove("fnafgmAnimatronicMove" .. a)
	end
end

function GM:CamLight(ply, id, rstate)
	if GAMEMODE.FT ~= 2 then return end
	if GAMEMODE.Vars.poweroff and rstate ~= false then return end
	local camera = ents.FindByName("fnafgm_Cam" .. id)[1]

	if not IsValid(camera) then return end

	local camstate = camera:GetLightState()
	if camstate == rstate then return end

	if rstate == true then
		camera:SwitchLight(true)
	elseif rstate == false then
		camera:SwitchLight(false)
	else
		camera:Light()
	end

	camstate = camera:GetLightState()

	if id == 0 then return end

	if GAMEMODE.CamsNames[game.GetMap() .. "_" .. id] then
		GAMEMODE:Log(ply:GetName() .. " toggle camera light of " .. GAMEMODE.CamsNames[game.GetMap() .. "_" .. id] .. " (" .. id .. ") | New state: " .. Either(camstate, "on", "off"), nil, true)
	else
		GAMEMODE:Log(ply:GetName() .. " toggle camera light " .. id .. " | New state: " .. Either(camstate, "on", "off"), nil, true)
	end
end

net.Receive("fnafgmCamLight", function(bits, ply)
	local id = net.ReadFloat()
	local rstate = tobool(net.ReadBool())
	if not id then return end
	GAMEMODE:CamLight(ply, id, rstate)
end)
concommand.Add("fnafgm_debug_light", function(ply, cmd, args)
	if IsValid(ply) and fnafgmPlayerCanByPass(ply, "debug") then
		GAMEMODE:CamLight(ply, args[1])
	elseif IsValid(ply) then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! (Need debug access)")
		net.Start("fnafgmNotif")
		net.WriteString("Nope, you can't do that! (Need debug access)")
		net.WriteInt(1, 3)
		net.WriteFloat(5)
		net.WriteBit(true)
		net.Send(ply)
	end
end)

concommand.Add("fnafgm_togglesgvsa", function(ply, str)
	if IsValid(ply) and (ply:IsListenServerHost() or ply:IsAdmin()) then
		fnafgm_sgvsa:SetBool(not fnafgm_sgvsa:GetBool())
	elseif IsValid(ply) then
		ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! (Not admin/host)")
		net.Start("fnafgmNotif")
		net.WriteString("Nope, you can't do that! (Not admin/host)")
		net.WriteInt(1, 3)
		net.WriteFloat(5)
		net.WriteBit(true)
		net.Send(ply)
	else
		fnafgm_sgvsa:SetBool(not fnafgm_sgvsa:GetBool())
	end
end)

function GM:RestartMapIfWeShould()
	if fnafgm_autorestartmap:GetBool() and CurTime() > 21600 then
		GAMEMODE:Log("The map has been active for too long. Reloading...")
		RunConsoleCommand("changelevel", game.GetMap())
		return true
	end
end

function GM:PlayerSpawnObject(ply)
	if not fnafgm_sandbox_enable:GetBool() and not ply:IsSuperAdmin() then
		return false
	end
	return SandboxClass.PlayerSpawnObject(self, ply)
end

function GM:CanPlayerUnfreeze(ply, entity, physobject)
	if not fnafgm_sandbox_enable:GetBool() and not ply:IsSuperAdmin() then
		return false
	end
	return SandboxClass.CanPlayerUnfreeze(self, ply, entity, physobject)
end

function GM:PlayerSpawnVehicle(ply, model, vname, vtable)
	if not fnafgm_sandbox_enable:GetBool() and not ply:IsSuperAdmin() then
		return false
	end
	return SandboxClass.PlayerSpawnVehicle(self, ply, model, vname, vtable)
end

function GM:PlayerSpawnSWEP(ply, wname, wtable)
	if not fnafgm_sandbox_enable:GetBool() and not ply:IsSuperAdmin() then
		return false
	end
	return SandboxClass.PlayerSpawnSWEP(self, ply, wname, wtable)
end

function GM:PlayerGiveSWEP(ply, wname, wtable)
	if not fnafgm_sandbox_enable:GetBool() and not ply:IsSuperAdmin() then
		return false
	end
	return SandboxClass.PlayerGiveSWEP(self, ply, wname, wtable)
end

function GM:PlayerSpawnSENT(ply, name)
	if not fnafgm_sandbox_enable:GetBool() and not ply:IsSuperAdmin() then
		return false
	end
	return SandboxClass.PlayerSpawnSENT(self, ply, name)
end

function GM:PlayerSpawnNPC(ply, npc_type, equipment)
	if not fnafgm_sandbox_enable:GetBool() and not ply:IsSuperAdmin() then
		return false
	end
	return SandboxClass.PlayerSpawnNPC(self, ply, npc_type, equipment)
end

function GM:PlayerButtonDown(ply, btn)
	if fnafgm_sandbox_enable:GetBool() or ply:IsSuperAdmin() then
		SandboxClass.PlayerButtonDown(self, ply, btn)
	end
end

function GM:PlayerButtonUp(ply, btn)
	if fnafgm_sandbox_enable:GetBool() or ply:IsSuperAdmin() then
		SandboxClass.PlayerButtonUp(self, ply, btn)
	end
end

net.Receive("fnafgm_password_input", function(len, ply)
	local password = net.ReadString()
	local ent = net.ReadEntity()
	ent:PasswordInput(password, ply)
end)

function GM:TriggerLinkOutput(output, activator, data)
	for k, v in pairs(ents.FindByClass("fnafgm_link")) do
		v:TriggerOutput(output, activator, data)
	end
end
