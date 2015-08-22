--[[---------------------------------------------------------

  Five Nights at Freddy's Gamemode

  "Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]

-- These files get sent to the client

AddCSLuaFile( "shared.lua" )
AddCSLuaFile( "cl_scoreboard.lua" )
AddCSLuaFile( "cl_voice.lua" )
AddCSLuaFile( "cl_fnafview.lua" )
AddCSLuaFile( "cl_menu.lua" )

include( 'shared.lua' )

resource.AddWorkshop( "363563548" )
if game.GetMap()=="fnaf2" then resource.AddWorkshop( "382155331" ) end
if game.GetMap()=="fnaf_freddypizzaevents" then
	resource.AddWorkshop( "407563661" )
	resource.AddWorkshop( "423349175" )
	resource.AddWorkshop( "382393981" )
end
if player_manager.AllValidModels()["Guard_01"] then -- Use http://steamcommunity.com/sharedfiles/filedetails/?id=169011381 if available
	resource.AddWorkshop( "169011381" )
end

--
-- Make BaseClass available
--
DEFINE_BASECLASS( "gamemode_base" )


local fnafgm_deathscreendelay = CreateConVar( "fnafgm_deathscreendelay", 1, FCVAR_REPLICATED, "The death screen delay. (Time of the jumpscare)" )
local fnafgm_deathscreenduration = CreateConVar( "fnafgm_deathscreenduration", 10, FCVAR_REPLICATED, "The death screen duration." )
local fnafgm_autorespawn = CreateConVar( "fnafgm_autorespawn", 0, FCVAR_REPLICATED, "Auto respawn after the death screen." )
local fnafgm_allowflashlight = CreateConVar( "fnafgm_allowflashlight", 0, FCVAR_REPLICATED, "Enables/Disables the player's flashlight. (Except for admins)" )
local fnafgm_respawnenabled = CreateConVar( "fnafgm_respawnenabled", 1, FCVAR_REPLICATED, "Enable/Disable the respawn. (Except for admins)" )
local fnafgm_deathscreenfade = CreateConVar( "fnafgm_deathscreenfade", 1, FCVAR_REPLICATED, "Enable/Disable the death screen fade." )
local fnafgm_deathscreenoverlay = CreateConVar( "fnafgm_deathscreenoverlay", 1, FCVAR_REPLICATED, "Enable/Disable the death screen overlay." )
local fnafgm_ragdollinstantremove = CreateConVar( "fnafgm_ragdollinstantremove", 0, FCVAR_REPLICATED, "Instant remove dead bodies." )
local fnafgm_ragdolloverride = CreateConVar( "fnafgm_ragdolloverride", 1, FCVAR_REPLICATED, "Change the dead bodies." )
local fnafgm_autocleanupmap = CreateConVar( "fnafgm_autocleanupmap", 1, FCVAR_REPLICATED, "Auto clean up when the server is empty." )
local fnafgm_preventdoorkill = CreateConVar( "fnafgm_preventdoorkill", 1, FCVAR_REPLICATED, "The doors are the main cause of death. So stop these killers by putting a value of 1" )
local fnafgm_timethink_endlesstime = CreateConVar( "fnafgm_timethink_endlesstime", 0, FCVAR_REPLICATED, "The time will be endless." )
local fnafgm_timethink_infinitenights = CreateConVar( "fnafgm_timethink_infinitenights", 0, FCVAR_REPLICATED, "The nights will be endless." )
local fnafgm_forceseasonalevent = CreateConVar( "fnafgm_forceseasonalevent", 0, FCVAR_REPLICATED, "2 for April Fool. 3 for Halloween" )
local fnafgm_killextsrplayers = CreateConVar( "fnafgm_killextsrplayers", 1, FCVAR_REPLICATED, "Stay in the security room otherwise you risk getting caught by the animatronics." )
local fnafgm_playermodel = CreateConVar( "fnafgm_playermodel", "none", FCVAR_REPLICATED, "Override the player model." )
local fnafgm_playerskin = CreateConVar( "fnafgm_playerskin", "0", FCVAR_REPLICATED, "Override the skin to use, if the model has any." )
local fnafgm_playerbodygroups = CreateConVar( "fnafgm_playerbodygroups", "0", FCVAR_REPLICATED, "Override the bodygroups to use, if the model has any." )
local fnafgm_playercolor = CreateConVar( "fnafgm_playercolor", "0.24 0.34 0.41", FCVAR_REPLICATED, "The value is a Vector - so between 0-1 - not between 0-255." )
local fnafgm_respawndelay = CreateConVar( "fnafgm_respawndelay", 0, FCVAR_REPLICATED, "The time before respawn. (After the death screen)" )
local fnafgm_enablebypass = CreateConVar( "fnafgm_enablebypass", tostring(game.IsDedicated()), FCVAR_REPLICATED, "Enable admins, gamemode creators and customs groups bypass funcs." )
local fnafgm_pinionsupport = CreateConVar( "fnafgm_pinionsupport", 0, FCVAR_REPLICATED, "Enable Pinion ads between nights and other." )
local fnafgm_fnafview_auto = CreateConVar( "fnafgm_fnafview_auto", 1, FCVAR_REPLICATED, "Auto use FNaF View." )
local fnafgm_timethink_autostart = CreateConVar( "fnafgm_timethink_autostart", 0, FCVAR_REPLICATED, "Start the night automatically." )

util.AddNetworkString( "fnafgmShowCheck" )
util.AddNetworkString( "fnafgmSetView" )
util.AddNetworkString( "fnafgmMuteCall" )
util.AddNetworkString( "fnafgmSafeZone" )
util.AddNetworkString( "fnafgmShutLights" )
util.AddNetworkString( "fnafgmMapSelect" )
util.AddNetworkString( "fnafgmChangeMap" )
function GM:Initialize()
	
	checkAliveInProgress = false
	checkRestartNight = false
	
	if !game.SinglePlayer() then
		timer.Create( "fnafgmAutoCleanUp", 5, 0, fnafgmAutoCleanUp)
	end
	
	fnafgmCheckForNewVersion(nil,false)
	timer.Create( "fnafgmCheckForNewVersion", 21600, 0, fnafgmCheckForNewVersion)
	
	fnafgmLoadLanguage(GetConVarString("gmod_language"))
	
	if !game.IsDedicated() and !SGvsA then
		
		local file = file.Read( "fnafgm/progress/" .. game.GetMap() .. ".txt" )
		if ( file ) then
		
			local tab = util.JSONToTable( file )
			if ( tab ) then
				
				if ( tab.Night ) then night = tab.Night end
				--if ( tab.FinishedWeek ) then finishedweek = tab.FinishedWeek end
				
				MsgC( Color( 255, 255, 85 ), "FNAFGM: Progression loaded!\n" )
				
			end
		
		end
	
	end
	
end


function GM:SaveProgress()
	
	if !game.IsDedicated() and !SGvsA then
		
		if !file.IsDir("fnafgm/progress", "DATA") then
			file.CreateDir( "fnafgm/progress" )
		end
		
		local tab = {}
		
		if night>=GAMEMODE.NightEnd then
			tab.Night = GAMEMODE.NightEnd
		else
			tab.Night = night
		end
		
		--tab.FinishedWeek = finishedweek
		
		file.Write( "fnafgm/progress/" .. game.GetMap() .. ".txt", util.TableToJSON( tab ) )
		
		MsgC( Color( 255, 255, 85 ), "FNAFGM: Progression saved!\n" )
		
	end
	
end


concommand.Add("fnafgm_resetprogress", function( ply )
	fnafgmResetProgress(ply)
end)
function fnafgmResetProgress(ply)
	
	if !ply:IsListenServerHost() and !SGvsA then ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! :)") return end
	
	if !file.IsDir("fnafgm/progress", "DATA") then
		file.CreateDir( "fnafgm/progress" )
	end
	
	local tab = {}
	
	tab.Night = 0
	
	--tab.FinishedWeek = finishedweek
	
	file.Write( "fnafgm/progress/" .. game.GetMap() .. ".txt", util.TableToJSON( tab ) )
	
	MsgC( Color( 255, 255, 85 ), "FNAFGM: Progression reseted!\n" )
	
end


function GM:PlayerNoClip( pl, on )
	
	if ( pl:InVehicle() ) then return false end
	
	if ( game.SinglePlayer() ) then return true end
	
	if fnafgmPlayerCanByPass(pl,"noclip") then return true end
	
end


function GM:PlayerSpawn( pl )
	
	if pl:GetViewEntity()!=pl then
		pl:SetViewEntity(pl)
	end
	
	if pl:Team()==TEAM_UNASSIGNED or pl:Team()==TEAM_SPECTATOR then
		pl:SetPos( pl:GetPos() + Vector( 0, 0, 32 ) )
	end
	
	fnafgmVarsUpdate()
	
	if pl:Team()==1 then
		
		player_manager.SetPlayerClass( pl, table.Random(team.GetClass(pl:Team())) )
		
	elseif pl:Team()==2 then
		
		local availableclass = { "player_fnafgmfoxy", "player_fnafgmfreddy", "player_fnafgmbonnie", "player_fnafgmchica" }
		
		for k, v in pairs(team.GetPlayers(2)) do
			
			if v!=pl then
				
				table.RemoveByValue(availableclass, player_manager.GetPlayerClass(v))
				
			end
			
		end
		
		if table.Count(availableclass)==0 and !fnafgmPlayerCanByPass(pl,"goldenfreddy") then
			
			pl:SendLua([[chat.PlaySound()]])
			pl:PrintMessage(HUD_PRINTTALK, "Sorry this team is full!")
			
			pl:SetTeam(1)
			
			if pl:Alive() then
				pl:KillSilent()
			end
			
			return
		
		elseif table.Count(availableclass)==0 and fnafgmPlayerCanByPass(pl,"goldenfreddy") then
			
			player_manager.SetPlayerClass( pl, "player_fnafgmgoldenfreddy" )
			
		else
			
			player_manager.SetPlayerClass( pl, table.Random(availableclass) )
			
		end
		
	end
	
	BaseClass.PlayerSpawn( self, pl )
	
	if player_manager.GetPlayerClass(pl)=="player_fnafgmfoxy" then
		pl:SetPos( Vector( -364, -356, 64 ) )
		pl:SetEyeAngles( Angle( 0, 0, 0 ) )
	elseif player_manager.GetPlayerClass(pl)=="player_fnafgmgoldenfreddy" then
		pl:SetPos( Vector( 285, -510, 64 ) )
		pl:SetEyeAngles( Angle( 0, 90, 0 ) )
	end
	
	if fnafgmPlayerCanByPass(pl,"run") and pl:Team()==1 then 
		pl:SetRunSpeed(400)
	end
	
	if fnafgmPlayerCanByPass(pl,"jump") then 
		pl:SetJumpPower(200)
	end
	
	if pl:Team()==2 then
		pl:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_animatronicsvision )
		if startday then
			pl:Freeze(false)
		else
			pl:Freeze(true)
		end
	elseif pl:Team()!=TEAM_UNASSIGNED then
		pl:ConCommand( "pp_mat_overlay ''" )
	end
	
	if pl:Team()!=TEAM_UNASSIGNED then
		pl:ConCommand( "pp_mat_overlay ''" )
		pl:SendLua([[fnafgmWarn()]])
		if game.GetMap()=="gm_construct" or game.GetMap()=="gm_flatgrass" then
			fnafgmMapSelect(pl)
		end
	end
	
	if b87 then
		pl:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_goldenfreddy )
		pl:ConCommand("play "..GAMEMODE.Sound_xscream2)
		norespawn = true
		local userid = pl:UserID()
		timer.Create( "fnafgm87"..userid, 20, 1, function()
			if IsValid(pl) and (!pl:IsListenServerHost() and !fnafgmPlayerCanByPass(ply,"debug")) then
				pl:Kick( "'87" )
			end
			timer.Remove("fnafgm87"..userid)
		end)
	end
	
	if ( pl:Team()==2 ) then
		pl:SetCustomCollisionCheck(true)
	end
	
	if ( pl:Team()==1 or pl:Team()==2 ) then
		pl:SetRenderMode(RENDERMODE_NORMAL)
		pl:SetMoveType(MOVETYPE_WALK)
	elseif ( pl:Team()==TEAM_SPECTATOR ) then
		pl:SetMoveType(MOVETYPE_NOCLIP)
	end
	
	if ( game.SinglePlayer() and !nightpassed and !gameend and iniok and startday ) then
		timer.Create( "fnafgmTempoRestart", 0.001, 1, function()
			fnafgmRestartNight()
			timer.Remove( "fnafgmTempoRestart" )
		end)
	end
	
	if ( game.SinglePlayer() or fnafgm_timethink_autostart:GetBool() ) and pl:Team()==1 then
		timer.Create( "fnafgmStart", 0.002, 1, function()
			fnafgmUse(pl, nil, true)
			timer.Remove( "fnafgmStart" )
		end)
	end
	
	local userid = pl:UserID()
	
	if !game.SinglePlayer() and fnafgm_fnafview_auto:GetBool() and startday and !tempostart and !nightpassed and !gameend and pl:Team()==1 then 
		timer.Create( "fnafgmTempoFNaFView"..userid, 0.001, 1, function()
			if IsValid(pl) and pl:Team()==1 then
				fnafgmFNaFView(pl)
			end
			timer.Remove( "fnafgmTempoFNaFView"..userid )
		end)
	end
	
end


function GM:PlayerShouldTakeDamage( ply, attacker )
	
	if ( game.SinglePlayer() ) then return true end

	-- No player vs player damage
	if ( attacker:IsValid() and attacker:IsPlayer() and ply:Team()==attacker:Team() and !fnafgmPlayerCanByPass(attacker,"friendlyfire") ) then
		return false
	end
	
	if ( ( game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent" ) and ply:Team()==1 and attacker:GetClass()=="func_door" and fnafgm_preventdoorkill:GetBool() ) then
		local doorsafe = GAMEMODE:PlayerSelectSpawn( ply ):GetPos()
		if IsValid(tp) then
			doorsafe = tp:GetPos()
		end
		ply:SetPos( doorsafe )
		return false
	end
	
	-- Default, let the player be hurt
	return true

end



--[[---------------------------------------------------------
   Called once on the player's first spawn
-----------------------------------------------------------]]
function GM:PlayerInitialSpawn( ply )
	
	if ply:IsAdmin() or fnafgmcheckcreator(ply) then
		fnafgmCheckForNewVersion(ply,false)
	end
	
	if SGvsA and !ply:IsBot() then
		ply:SetTeam( TEAM_UNASSIGNED )
		ply:ConCommand( "gm_showteam" )
		ply:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_intro )
	elseif !SGvsA and !ply:IsBot() then
		ply:SetTeam( TEAM_UNASSIGNED )
		if game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent" then
			ply:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_intro )
		elseif game.GetMap()=="fnaf2" then
			ply:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_introfnaf2 )
		elseif game.GetMap()=="fnaf3" then
			--ply:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_introfnaf3 )
		elseif game.GetMap()=="fnaf4" then
			
		elseif game.GetMap()=="fnap_scc" then
			--ply:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_introfnap1 )
		elseif game.GetMap()=="gm_construct" or game.GetMap()=="gm_flatgrass" then
			fnafgmMapSelect(ply)
		end
	elseif ply:IsBot() then
		ply:SetTeam(1)
	end
	
	fnafgmMapOverrides()
	fnafgmCheckUpdate()
	if !GAMEMODE.Official then fnafgmCheckUpdateD() end
	
	active = true
	
end


concommand.Add("fnafgm_mapselect", function( ply )
	fnafgmMapSelect(ply)
end)
function fnafgmMapSelect(ply)
	
	if !ply:IsListenServerHost() and !ply:IsAdmin() and !game.GetMap()=="gm_construct" and !game.GetMap()=="gm_flatgrass" then return end
	
	local AvMaps = {}
	
	for k, v in pairs ( GAMEMODE.MapList ) do
		
		if file.Exists( "maps/"..k..".bsp", "GAME" ) then
			AvMaps[k]=true
		else
			AvMaps[k]=false
		end
		
	end
	
	net.Start( "fnafgmMapSelect" )
		net.WriteTable( AvMaps )
	net.Send(ply)
	
end

function fnafgmChangeMap(ply,map)
	
	if ply:IsListenServerHost() or ply:IsAdmin() or game.GetMap()=="gm_construct" or game.GetMap()=="gm_flatgrass" then
		
		MsgC( Color( 255, 255, 85 ), "FNAFGM: Map changing to "..map.." because of "..ply:GetName().."\n" )
		RunConsoleCommand( "changelevel", map )
		
	else
		
		ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! :)")
		
	end
	
end
net.Receive( "fnafgmChangeMap",function(bits,ply)
	local map = net.ReadString()
	fnafgmChangeMap(ply,map)
end )


function GM:PlayerRequestTeam( ply, teamid )

	-- No changing teams if not teambased!
	if ( norespawn and teamid==1 ) then 
		ply:ChatPrint( "You can't do this now!" )
		return
	elseif ( !SGvsA and teamid==2 ) then 
		ply:ChatPrint( "You're not in SGvsA mode!" )
		return
	elseif (!SGvsA and teamid==TEAM_SPECTATOR and !fnafgmPlayerCanByPass(ply,"spectator") ) then
		ply:ChatPrint( "You can't!" )
		return
	elseif (teamid==TEAM_SPECTATOR and !GetConVar("mp_allowspectators"):GetBool() and !fnafgmPlayerCanByPass(ply,"spectator") ) then
		ply:ChatPrint( "Spectator mode is disabled!" )
		return
	elseif b87 then
		ply:ChatPrint( "'87" )
		return
	end
	
	-- This team isn't joinable
	if ( !team.Joinable( teamid ) ) then
		ply:ChatPrint( "This is disabled!" )
	return end
	
	-- This team isn't joinable
	if ( !GAMEMODE:PlayerCanJoinTeam( ply, teamid ) ) then
		-- Messages here should be outputted by this function
	return end
	
	GAMEMODE:PlayerJoinTeam( ply, teamid )

end


function GM:PlayerCanJoinTeam( ply, teamid )
	
	local TimeBetweenSwitches = GAMEMODE.SecondsBetweenTeamSwitches or 10
	if ( ply.LastTeamSwitch && RealTime()-ply.LastTeamSwitch < TimeBetweenSwitches ) then
		ply.LastTeamSwitch = ply.LastTeamSwitch + 1
		ply:ChatPrint( Format( "Please wait %i more seconds before trying to change team again", ( TimeBetweenSwitches - ( RealTime() - ply.LastTeamSwitch ) ) + 1 ) )
		return false
	end
	
	-- Already on this team!
	if ( ply:Team() == teamid ) then
		ply:ChatPrint( "You're already on that team" )
		return false
	end
	
	-- Animatronics full!
	if ( teamid==2 and team.NumPlayers(teamid)>=4 and !fnafgmPlayerCanByPass(ply,"goldenfreddy") ) then
		ply:ChatPrint( "Sorry this team is full!" )
		return false
	end
	
	return true
	
end


function GM:PlayerSpawnAsSpectator( pl )

	pl:StripWeapons()
	
	if ( pl:Team() == TEAM_UNASSIGNED ) then
	
		pl:Spectate( OBS_MODE_FREEZECAM )
		return
		
	end

	pl:SetTeam( TEAM_SPECTATOR )
	pl:Spectate( OBS_MODE_ROAMING )

end


function GM:KeyPress( ply, key )
	
	if SGvsA and ply:Team()==TEAM_UNASSIGNED and ( ply:KeyPressed( IN_ATTACK ) || ply:KeyPressed( IN_ATTACK2 ) || ply:KeyPressed( IN_JUMP ) ) and !norespawn then
		ply:ConCommand( "gm_showteam" )
	elseif !SGvsA and ply:Team()==TEAM_UNASSIGNED and !ply:KeyPressed( IN_SCORE ) and !b87 and !norespawn then
		GAMEMODE:PlayerRequestTeam( ply, 1 )
	end
	
end


function GM:PostPlayerDeath( ply )
	
	if newTeam~=2 then
		ply:Freeze(false)
	end
	
	local userid = ply:UserID()
	local oldteam = ply:Team()
	
	if ( !nightpassed and !gameend and ply:Team()==1 and !b87 ) then
		
		if fnafgmPlayerCanByPass(ply,"fastrespawn") then ply.NextSpawnTime = CurTime() + fnafgm_deathscreendelay:GetInt() + 1 else ply.NextSpawnTime = CurTime() + fnafgm_deathscreendelay:GetInt()+fnafgm_deathscreenduration:GetInt()+fnafgm_respawndelay:GetInt() end
	
		local ent = ply:GetRagdollEntity()
	
		if fnafgm_ragdollinstantremove:GetBool() and IsValid(ent) then --Ragdoll zone
			ent:Remove() --Ragdoll remove
		elseif IsValid(ent) then
			if fnafgm_ragdolloverride:GetBool() then --Ragdoll model
				ent:SetCustomCollisionCheck(true)
				if !game.SinglePlayer() then
					if table.Count(GAMEMODE.Models_dead)!=0 then
						ent:SetModel(table.Random(GAMEMODE.Models_dead))
					end
					if GAMEMODE.DeadBodiesTeleport[game.GetMap()] then
						ply:SetPos( table.Random(GAMEMODE.DeadBodiesTeleport[game.GetMap()]) )
					end
				else
					if GAMEMODE.Models_deadsp!=nil then
						ent:SetModel(GAMEMODE.Models_deadsp)
					end
					if game.GetMap()=="freddys" then
						ply:SetPos( Vector(-484, -160, 92) )
					end
				end
				
			end
		end
	
		if fnafgm_deathscreenfade:GetBool() then ply:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 65536 ) end --Screen fade
		
		timer.Create( "fnafgmStaticStart"..userid, fnafgm_deathscreendelay:GetInt(), 1, function()
			
			if (!nightpassed and IsValid(ply) and !ply:Alive() and ply:Team()==1) then
				
				if ((fnafgm_pinionsupport:GetBool()) and (!fnafgm_respawnenabled:GetBool() or norespawn)) then Pinion:ShowMOTD(ply) end
				
				if game.GetMap()=="freddys" and ents.FindByName( "fnafgm_Cam6" )[1] then
					ply:SetViewEntity( ents.FindByName( "fnafgm_Cam6" )[1] )
				elseif game.GetMap()=="fnaf2" and ents.FindByName( "DeathCam" )[1] then
					ply:SetViewEntity( ents.FindByName( "DeathCam" )[1] )
				end
				
				if game.SinglePlayer() then
					timer.Remove("fnafgmTimeThink")
					if game.GetMap()=="freddys" and !poweroff then
						ents.FindByName( "FoxyTime" )[1]:Fire("Kill")
						ents.FindByName( "EventTimer" )[1]:Fire("Kill")
						ents.FindByName( "EventTimer2" )[1]:Fire("Kill")
					end
				end
				
				if fnafgm_deathscreenoverlay:GetBool() then --Static screen
					if ( game.SinglePlayer() ) then ply:ConCommand("stopsound") else ply:SendLua([[RunConsoleCommand("stopsound")]]) end --Stop sound
					ply:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_static )
					ply:ConCommand("play "..GAMEMODE.Sound_static)
				else
					ply:ConCommand( "pp_mat_overlay ''" )
				end
				
				timer.Create( "fnafgmStaticEnd"..userid, fnafgm_deathscreenduration:GetInt(), 1, function()
					
					if (!nightpassed and IsValid(ply) and !ply:Alive()) then
						
						ply:ConCommand( "pp_mat_overlay ''" )
						if game.GetMap()=="fnaf2" then
							ply:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_fnaf2deathcam )
						end
						ply:ScreenFade(16, color_black, 0, 0 )
						
						if fnafgm_respawndelay:GetInt()==0 then
							
							if ((fnafgm_autorespawn:GetBool() and fnafgm_respawnenabled:GetBool()) and !norespawn) then ply:Spawn() elseif fnafgm_respawnenabled:GetBool() and !norespawn then ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn") ply:SendLua([[chat.PlaySound()]]) elseif !norespawn then ply:PrintMessage(HUD_PRINTTALK, "You will respawn after the night or when all the players are dead.") ply:SendLua([[chat.PlaySound()]]) end
						
						else
							
							if (fnafgm_respawnenabled:GetBool() and !norespawn) then ply:PrintMessage(HUD_PRINTCENTER, "You will respawn in "..fnafgm_respawndelay:GetInt().."s") ply:SendLua([[chat.PlaySound()]]) elseif !norespawn then ply:PrintMessage(HUD_PRINTTALK, "You will respawn after the night or when all the players are dead.") ply:SendLua([[chat.PlaySound()]]) end
							
							timer.Create( "fnafgmRespawn"..userid, fnafgm_respawndelay:GetInt(), 1, function()
								
								if (!nightpassed and IsValid(ply) and !ply:Alive()) then
								
									if ((fnafgm_autorespawn:GetBool() and fnafgm_respawnenabled:GetBool()) and !norespawn) then ply:Spawn() elseif fnafgm_respawnenabled:GetBool() and !norespawn then ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn") ply:SendLua([[chat.PlaySound()]]) end
									
								end
								
								timer.Remove("fnafgmRespawn"..userid)
								
							end)
							
						end
						
						
					end
					
					timer.Remove("fnafgmStaticEnd"..userid)
				end)
				
			elseif (!nightpassed and IsValid(ply) and !ply:Alive() and ply:Team()~=1) then
				
				ply:ConCommand( "pp_mat_overlay ''" )
				ply:ScreenFade(16, color_black, 0, 0 )
				
			end
			
			timer.Remove("fnafgmStaticStart"..userid)
			
		end)
		
	elseif nightpassed or gameend then
		
		ply.NextSpawnTime = CurTime() + 11
		
	elseif ( ply:Team()==2 ) then
		
		if fnafgmPlayerCanByPass(ply,"fastrespawn") then ply.NextSpawnTime = CurTime() + 1 else ply.NextSpawnTime = CurTime() + fnafgm_respawndelay:GetInt() end
		
		local ent = ply:GetRagdollEntity()
		if IsValid(ent) then ent:Remove() end --Ragdoll remove
		
		if fnafgm_respawndelay:GetInt()==0 then
							
			timer.Create( "fnafgmRespawn"..userid, 1, 1, function()
				
				if (!nightpassed and IsValid(ply) and !ply:Alive()) then
					
					if (fnafgm_autorespawn:GetBool() and !norespawn) then ply:Spawn() elseif fnafgm_respawnenabled:GetBool() and !norespawn then ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn") ply:SendLua([[chat.PlaySound()]]) end
				
				end
				
				timer.Remove("fnafgmRespawn"..userid)
				
			end)
			
		else
			
			if !norespawn then ply:PrintMessage(HUD_PRINTCENTER, "You will respawn in "..fnafgm_respawndelay:GetInt().."s") ply:SendLua([[chat.PlaySound()]]) end
			
			timer.Create( "fnafgmRespawn"..userid, fnafgm_respawndelay:GetInt(), 1, function()
									
				if (!nightpassed and IsValid(ply) and !ply:Alive()) then
					
					if (fnafgm_autorespawn:GetBool() and !norespawn) then ply:Spawn() elseif !norespawn then ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn") ply:SendLua([[chat.PlaySound()]]) end
					
				end
									
				timer.Remove("fnafgmRespawn"..userid)
			
			end)
		
		end
		
	else
		
		if fnafgmPlayerCanByPass(ply,"fastrespawn") or ply:Team()==TEAM_UNASSIGNED then ply.NextSpawnTime = CurTime() + 0.001 else ply.NextSpawnTime = CurTime() + fnafgm_respawndelay:GetInt() end
		
		if fnafgm_respawndelay:GetInt()==0 or ply:Team()==TEAM_UNASSIGNED then
			
			timer.Create( "fnafgmRespawn"..userid, 0.001, 1, function()
			
				if (!nightpassed and IsValid(ply) and !ply:Alive()) then
					
					if ((fnafgm_autorespawn:GetBool() or oldteam==TEAM_UNASSIGNED) and !norespawn) then ply:Spawn() elseif !norespawn then ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn") ply:SendLua([[chat.PlaySound()]]) end
					
				end
			
				timer.Remove("fnafgmRespawn"..userid)
				
			end)
			
		else
			
			if !norespawn then ply:PrintMessage(HUD_PRINTCENTER, "You will respawn in "..fnafgm_respawndelay:GetInt().."s") ply:SendLua([[chat.PlaySound()]]) end
			
			timer.Create( "fnafgmRespawn"..userid, fnafgm_respawndelay:GetInt(), 1, function()
								
				if (!nightpassed and IsValid(ply) and !ply:Alive()) then
								
					if (fnafgm_autorespawn:GetBool() and !norespawn) then ply:Spawn() elseif !norespawn then ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn") ply:SendLua([[chat.PlaySound()]]) end
										
				end
								
				timer.Remove("fnafgmRespawn"..userid)
		
			end)
		
		end
		
	end
	
end


function GM:PlayerDeathSound()
	return true
end


function GM:PlayerDeathThink( pl )
	
	local players = team.GetPlayers(pl:Team())

	if !game.SinglePlayer() then
		if pl:KeyPressed( IN_ATTACK ) then
			if !pl.SpecID then pl.SpecID = 1 end
			pl.SpecID = pl.SpecID + 1
			if pl.SpecID > #players then pl.SpecID = 1 end
			pl:SpectateEntity( players[ pl.SpecID ] )
		elseif pl:KeyPressed( IN_ATTACK2 ) then
			if !pl.SpecID then pl.SpecID = 1 end
			pl.SpecID = pl.SpecID - 1
			if pl.SpecID <= 0 then pl.SpecID = #players end
			pl:SpectateEntity( players[ pl.SpecID ] )
		end
	end
	
	if norespawn then return end
	
	if !fnafgm_respawnenabled:GetBool() and !fnafgmPlayerCanByPass(pl,"canrespawn") then return end
	
	if ( pl.NextSpawnTime && pl.NextSpawnTime > CurTime() ) then return end

	if ( pl:KeyPressed( IN_ATTACK ) || pl:KeyPressed( IN_ATTACK2 ) || pl:KeyPressed( IN_JUMP ) ) then
	
		pl:Spawn()
	
	end
	
end


function GM:ShouldCollide( ent1, ent2 )
	
	if ( ( ent1:IsPlayer() and ent2:IsRagdoll() ) or ( ent1:IsRagdoll() and ent2:IsPlayer() ) or ( ent1:IsRagdoll() and ent2:IsRagdoll() ) ) then
		return false
	end
	
	if ( ent1:IsPlayer() and ent2:IsPlayer() ) then
		return false
	end
	
	if ( ( ( ent1:IsPlayer() and ent1:Team()==2 and player_manager.GetPlayerClass(ent1)!="player_fnafgmfoxy" and !avisible[ent1] ) or ( ent2:IsPlayer() and ent2:Team()==2 and player_manager.GetPlayerClass(ent2)!="player_fnafgmfoxy" and !avisible[ent2] ) ) and ( ( ent1:GetClass()=="func_door_rotating" or ent1:GetName()=="receptdoors" or ent1:GetClass()=="func_brush" ) or ( ent2:GetClass()=="func_door_rotating" or ent2:GetName()=="receptdoors"or ent2:GetClass()=="func_brush" ) ) ) then
		return false
	end
	
	if ( ( ( ent1:IsPlayer() and player_manager.GetPlayerClass(ent1)=="player_fnafgmgoldenfreddy" and !avisible[ent1] ) or ( ent2:IsPlayer() and player_manager.GetPlayerClass(ent2)=="player_fnafgmgoldenfreddy" and !avisible[ent2] ) ) and ( ( ent1:GetClass()=="func_door_rotating" or ent1:GetClass()=="func_door" or ent1:GetClass()=="func_brush" ) or ( ent2:GetClass()=="func_door_rotating" or ent2:GetClass()=="func_door" or ent2:GetClass()=="func_brush" ) ) ) then
		return false
	end
	
	return true
	
end


function GM:PlayerSpray( ply )
	if fnafgmPlayerCanByPass(ply,"spray") then
		return false
	else
		return true
	end
end


function fnafgmUse(ply, ent, test)
	
	if debugmode and IsValid(ent) then ply:PrintMessage(HUD_PRINTTALK, "[DEBUG] SEE: "..ent:GetName().." ["..ent:GetClass().."] "..tostring(ent:GetPos())) end
	
	if IsValid(ply) and ply:Team()!=1 and !test and !fnafgmPlayerCanByPass(ply,"debug") then
		return false
	end
	
	if (game.GetMap()=="freddys") then
		
		if btn:IsValid() and ( ( ent==btn and ply:IsValid() and ply:Alive() ) or test ) and !startday then
			
			startday = true
			tempostart = true
			if Halloween or fnafgm_forceseasonalevent:GetInt()==3 then
				sound.Play( "fnafgm/robotvoice.wav", Vector( -80, -1163, 128 ), 150 )
			end
			night = night+1
			AMPM = GAMEMODE.AMPM
			time = GAMEMODE.TimeBase
			hourtime = hourtime+GAMEMODE.HourTime_add
			power = GAMEMODE.Power_Max
			poweroff = false
			nightpassed = false
			iniok = true
			norespawn = false
			foxyknockdoorpena = 2
			addfoxyknockdoorpena = 4
			
			btn:Fire("use")
			
			if Halloween or fnafgm_forceseasonalevent:GetInt()==3 then
				ents.FindByName( "EventTimer" )[1]:Fire("LowerRandomBound", 10)
				ents.FindByName( "EventTimer" )[1]:Fire("UpperRandomBound", 10)
				
				ents.FindByName( "FoxyTime" )[1]:Fire("LowerRandomBound", 60)
				ents.FindByName( "FoxyTime" )[1]:Fire("UpperRandomBound", 170)
				
				ents.FindByName( "EventTimer2" )[1]:Fire("LowerRandomBound", 10)
				ents.FindByName( "EventTimer2" )[1]:Fire("UpperRandomBound", 10)
			elseif night==1 then
				ents.FindByName( "EventTimer" )[1]:Fire("LowerRandomBound", 60)
				ents.FindByName( "EventTimer" )[1]:Fire("UpperRandomBound", 90)
				
				ents.FindByName( "FoxyTime" )[1]:Fire("LowerRandomBound", 1000)
				ents.FindByName( "FoxyTime" )[1]:Fire("UpperRandomBound", 1000)
				
				ents.FindByName( "EventTimer2" )[1]:Fire("LowerRandomBound", 1000)
				ents.FindByName( "EventTimer2" )[1]:Fire("UpperRandomBound", 1000)
			elseif night==2 then
				ents.FindByName( "EventTimer" )[1]:Fire("LowerRandomBound", 40)
				ents.FindByName( "EventTimer" )[1]:Fire("UpperRandomBound", 60)
				
				ents.FindByName( "FoxyTime" )[1]:Fire("LowerRandomBound", 200)
				ents.FindByName( "FoxyTime" )[1]:Fire("UpperRandomBound", 500)
				
				ents.FindByName( "EventTimer2" )[1]:Fire("LowerRandomBound", 1000)
				ents.FindByName( "EventTimer2" )[1]:Fire("UpperRandomBound", 1000)
			elseif night==3 then
				ents.FindByName( "EventTimer" )[1]:Fire("LowerRandomBound", 30)
				ents.FindByName( "EventTimer" )[1]:Fire("UpperRandomBound", 45)
				
				ents.FindByName( "FoxyTime" )[1]:Fire("LowerRandomBound", 120)
				ents.FindByName( "FoxyTime" )[1]:Fire("UpperRandomBound", 400)
				
				ents.FindByName( "EventTimer2" )[1]:Fire("LowerRandomBound", 30)
				ents.FindByName( "EventTimer2" )[1]:Fire("UpperRandomBound", 90)
			elseif night==4 then
				ents.FindByName( "EventTimer" )[1]:Fire("LowerRandomBound", 20)
				ents.FindByName( "EventTimer" )[1]:Fire("UpperRandomBound", 25)
				
				ents.FindByName( "FoxyTime" )[1]:Fire("LowerRandomBound", 120)
				ents.FindByName( "FoxyTime" )[1]:Fire("UpperRandomBound", 300)
				
				ents.FindByName( "EventTimer2" )[1]:Fire("LowerRandomBound", 30)
				ents.FindByName( "EventTimer2" )[1]:Fire("UpperRandomBound", 60)
			elseif night==5 then
				ents.FindByName( "EventTimer" )[1]:Fire("LowerRandomBound", 16)
				ents.FindByName( "EventTimer" )[1]:Fire("UpperRandomBound", 16)
				
				ents.FindByName( "FoxyTime" )[1]:Fire("LowerRandomBound", 120)
				ents.FindByName( "FoxyTime" )[1]:Fire("UpperRandomBound", 170)
				
				ents.FindByName( "EventTimer2" )[1]:Fire("LowerRandomBound", 16)
				ents.FindByName( "EventTimer2" )[1]:Fire("UpperRandomBound", 30)
			elseif night==6 then
				ents.FindByName( "EventTimer" )[1]:Fire("LowerRandomBound", 6)
				ents.FindByName( "EventTimer" )[1]:Fire("UpperRandomBound", 10)
				
				ents.FindByName( "FoxyTime" )[1]:Fire("LowerRandomBound", 60)
				ents.FindByName( "FoxyTime" )[1]:Fire("UpperRandomBound", 170)
				
				ents.FindByName( "EventTimer2" )[1]:Fire("LowerRandomBound", 6)
				ents.FindByName( "EventTimer2" )[1]:Fire("UpperRandomBound", 10)
			else
				ents.FindByName( "EventTimer" )[1]:Fire("LowerRandomBound", 6)
				ents.FindByName( "EventTimer" )[1]:Fire("UpperRandomBound", 6)
				
				ents.FindByName( "FoxyTime" )[1]:Fire("LowerRandomBound", 60)
				ents.FindByName( "FoxyTime" )[1]:Fire("UpperRandomBound", 60)
				
				ents.FindByName( "EventTimer2" )[1]:Fire("LowerRandomBound", 6)
				ents.FindByName( "EventTimer2" )[1]:Fire("UpperRandomBound", 6)
			end
			
			local sound = ""
			local mutetime = 0
			
			if night==1 then
				sound = GAMEMODE.Sound_Calls.freddys[1]
				mute = false
				mutetime = 207
			elseif night==2 then
				sound = GAMEMODE.Sound_Calls.freddys[2]
				mute = false
				mutetime = 104
			elseif night==3 then
				sound = GAMEMODE.Sound_Calls.freddys[3]
				mute = false
				mutetime = 75
			elseif night==4 then
				sound = GAMEMODE.Sound_Calls.freddys[4]
				mute = false
				mutetime = 65
			elseif night==5 then
				sound = GAMEMODE.Sound_Calls.freddys[5]
				mute = false
				mutetime = 37
			end
			
			for k, v in pairs(ents.FindByName("Collectcall")) do
				v:SetKeyValue( "message", sound )
			end
			
			for k, v in pairs(ents.FindByName("Callman")) do
				v:Fire("addoutput", "OnUseLocked Collectcall,Volume,0,0.00,1")
				v:Fire("addoutput", "OnUseLocked phonelight,ToggleSprite,none,0,1")
				v:Fire("addoutput", "OnUseLocked fnafgm_link,MuteCall,,0,-1")
			end
			
			fnafgmVarsUpdate()
			
			for k, v in pairs(team.GetPlayers(1)) do
				if v:Alive() then
					v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 2.5 )
				end
			end
			
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..night.." started\n" )
			
			timer.Create( "fnafgmTempoStartM", 0.01, 1, function()
				
				for k, v in pairs(team.GetPlayers(1)) do
					if v:Alive() and !CheckPlayerSecurityRoom(v) then
						local spawn = GAMEMODE:PlayerSelectSpawn( v ):GetPos()
						v:SetPos( spawn )
						v:SetEyeAngles(Angle( 0, 90, 0 ))
					end
				end
				
				
				if AprilFool or fnafgm_forceseasonalevent:GetInt()==2 then
					for k, v in pairs(ents.FindByName("secret")) do
						v:Fire("PlaySound")
					end
				end
				
				timer.Remove( "fnafgmTempoStartM" )
				
			end)
			
			timer.Create( "fnafgmTempoStart", 2.5, 1, function()
				
				tempostart = false
				fnafgmVarsUpdate()
				fnafgmPowerUpdate()
				
				if !mute then
				
					for k, v in pairs(ents.FindByName("Collectcall")) do
						v:Fire("PlaySound")
					end
					
					timer.Create( "fnafgmEndCall", mutetime, 1, function()
						mute = true
						for k, v in pairs(ents.FindByName("Callman")) do
							v:Fire("Use")
						end
					end)
					
				end
				if game.SinglePlayer() or fnafgm_fnafview_auto:GetBool() then 
					for k, v in pairs(team.GetPlayers(1)) do
						if v:Team()==1 and v:Alive() then
							fnafgmFNaFView(v)
						end
					end
				end
				
				timer.Create( "fnafgmTimeThink", hourtime, 0, fnafgmTimeThink)
				
				timer.Remove( "fnafgmTempoStart" )
				
			end)
			
			return false
			
		elseif btn:IsValid() and ent==btn then
			
			return false
			
		end
		
	elseif (game.GetMap()=="freddysnoevent") then
		
		if btn:IsValid() and ( ( ent==btn and ply:IsValid() and ply:Alive() ) or test ) and !startday then
			
			startday = true
			tempostart = true
			if Halloween or fnafgm_forceseasonalevent:GetInt()==3 then
				sound.Play( "fnafgm/robotvoice.wav", Vector( -80, -1163, 128 ), 150 )
			end
			night = night+1
			AMPM = GAMEMODE.AMPM
			time = GAMEMODE.TimeBase
			hourtime = hourtime+GAMEMODE.HourTime_add
			power = GAMEMODE.Power_Max
			poweroff = false
			nightpassed = false
			iniok = true
			norespawn = false
			
			btn:Fire("use")
			ents.FindByName( "Powerlvl" )[1]:Fire("Enable")
			
			fnafgmVarsUpdate()
			
			for k, v in pairs(team.GetPlayers(1)) do
				if v:Alive() then
					v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 2.5 )
				end
			end
			
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..night.." started\n" )
			
			timer.Create( "fnafgmTempoStartM", 0.01, 1, function()
				
				for k, v in pairs(team.GetPlayers(1)) do
					if v:Alive() and !CheckPlayerSecurityRoom(v) then
						local spawn = GAMEMODE:PlayerSelectSpawn( v ):GetPos()
						v:SetPos( spawn )
						v:SetEyeAngles(Angle( 0, 90, 0 ))
					end
				end
				
				timer.Remove( "fnafgmTempoStartM" )
				
			end)
			
			timer.Create( "fnafgmTempoStart", 2.5, 1, function()
				
				tempostart = false
				fnafgmVarsUpdate()
				fnafgmPowerUpdate()
				
				if fnafgm_fnafview_auto:GetBool() then 
					for k, v in pairs(team.GetPlayers(1)) do
						if v:Team()==1 and v:Alive() then
							fnafgmFNaFView(v)
						end
					end
				end
				
				timer.Create( "fnafgmTimeThink", hourtime, 0, fnafgmTimeThink)
				
				timer.Remove( "fnafgmTempoStart" )
				
			end)
			
			timer.Create( "fnafgmUnFreezeA", fnafgm_deathscreenduration:GetInt(), 1, function()
				for k, v in pairs(player.GetAll()) do
					if v:Team()==2 then
						v:Freeze(false)
					end
				end
				timer.Remove( "fnafgmUnFreezeA" )
			end)
			
			return false
		
		elseif btn:IsValid() and ent==btn then
			
			return false
			
		end
		
	elseif (game.GetMap()=="fnaf2") then
		
		if btn:IsValid() and btnm:IsValid() and !startday then
			
			if ( ( ( ent==btn or ent==btnm ) and ply:IsValid() and ply:Alive() ) or test) then
				
				startday = true
				tempostart = true
				night = night+1
				AMPM = GAMEMODE.AMPM
				time = GAMEMODE.TimeBase
				hourtime = hourtime+GAMEMODE.HourTime_add
				if night==1 then
					power = 115
					powertot = 115
				elseif night==2 then
					power = 100
					powertot = 100
				elseif night==3 then
					power = 85
					powertot = 85
				elseif night==4 then
					power = 67
					powertot = 67
				else
					power = 50
					powertot = 50
				end
				poweroff = false
				nightpassed = false
				iniok = true
				norespawn = false
				
				btn:Fire("use")
				btnm:Fire("use")
				
				fnafgmVarsUpdate()
			
				for k, v in pairs(team.GetPlayers(1)) do
					if v:Alive() then
						v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 2.5 )
					end
				end
				
				MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..night.." started\n" )
			
				timer.Create( "fnafgmTempoStartM", 0.01, 1, function()
					
					for k, v in pairs(team.GetPlayers(1)) do
						if v:Alive() and !CheckPlayerSecurityRoom(v) then
							local spawn = GAMEMODE:PlayerSelectSpawn( v ):GetPos()
							v:SetPos( spawn )
							v:SetEyeAngles(Angle( 0, 90, 0 ))
						end
					end
					
					timer.Remove( "fnafgmTempoStartM" )
					
				end)
			
				timer.Create( "fnafgmTempoStart", 2.5, 1, function()
					
					tempostart = false
					fnafgmVarsUpdate()
					fnafgmPowerUpdate()
					
					if game.SinglePlayer() or fnafgm_fnafview_auto:GetBool() then 
						for k, v in pairs(team.GetPlayers(1)) do
							if v:Team()==1 and v:Alive() then
								fnafgmFNaFView(v)
							end
						end
					end
					
					timer.Create( "fnafgmTimeThink", hourtime, 0, fnafgmTimeThink)
					
					timer.Remove( "fnafgmTempoStart" )
					
				end)
				
			end
			
		end
		
	elseif (game.GetMap()=="fnaf_freddypizzaevents") then
		
		if btn:IsValid() and ( ( ent==btn and ply:IsValid() and ply:Alive() ) or test ) and !startday then
				
			startday = true
			time = 0
			AMPM = ""
			nightpassed = false
			iniok = true
			norespawn = false
			
			fnafgmVarsUpdate()
			
			btn:Fire("use")
			
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Map started\n" )
		
		elseif btn:IsValid() and ( ( ent==btn and ply:IsValid() and ply:Alive() ) or test ) and startday then
			
			ply:SendLua([[chat.PlaySound()]])
			ply:PrintMessage(HUD_PRINTTALK, "Map already started!")
			
		end
	
	elseif (game.GetMap()=="fnap_scc") then
		
		if btn:IsValid() and ( ( ent==btn and ply:IsValid() and ply:Alive() ) or test ) and !startday then
			
			startday = true
			tempostart = true
			night = night+1
			AMPM = GAMEMODE.AMPM
			time = GAMEMODE.TimeBase
			hourtime = hourtime+GAMEMODE.HourTime_add
			nightpassed = false
			iniok = true
			norespawn = false
			foxyknockdoorpena = 2
			addfoxyknockdoorpena = 4
			
			btn:Fire("use")
			
			if Halloween or fnafgm_forceseasonalevent:GetInt()==3 then
				ents.FindByName( "RarityTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "RarityTimer" )[1]:Fire("UpperRandomBound", 7)
				
				ents.FindByName( "TwilightTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "TwilightTimer" )[1]:Fire("UpperRandomBound", 7)
				
				ents.FindByName( "FluttershyTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "FluttershyTimer" )[1]:Fire("UpperRandomBound", 7)
				
				ents.FindByName( "RainbowTimer" )[1]:Fire("LowerRandomBound", 30)
				ents.FindByName( "RainbowTimer" )[1]:Fire("UpperRandomBound", 120)
				ents.FindByName( "RainbowTimer2" )[1]:Fire("LowerRandomBound", 10)
				ents.FindByName( "RainbowTimer2" )[1]:Fire("UpperRandomBound", 20)
				
				ents.FindByName( "PinkieTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "PinkieTimer" )[1]:Fire("UpperRandomBound", 7)
				
				ents.FindByName( "ApplejackTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "ApplejackTimer" )[1]:Fire("UpperRandomBound", 7)
			elseif night==1 then
				ents.FindByName( "PinkieTimer" )[1]:Fire("Kill")
				ents.FindByName( "RainbowTimer" )[1]:Fire("Kill")
				ents.FindByName( "ApplejackTimer" )[1]:Fire("Kill")
				
				ents.FindByName( "RarityTimer" )[1]:Fire("LowerRandomBound", 40)
				ents.FindByName( "RarityTimer" )[1]:Fire("UpperRandomBound", 60)
				
				ents.FindByName( "TwilightTimer" )[1]:Fire("LowerRandomBound", 40)
				ents.FindByName( "TwilightTimer" )[1]:Fire("UpperRandomBound", 60)
				
				ents.FindByName( "FluttershyTimer" )[1]:Fire("LowerRandomBound", 40)
				ents.FindByName( "FluttershyTimer" )[1]:Fire("UpperRandomBound", 60)
			elseif night==2 then
				ents.FindByName( "PinkieTimer" )[1]:Fire("Kill")
				ents.FindByName( "ApplejackTimer" )[1]:Fire("Kill")
				
				ents.FindByName( "RarityTimer" )[1]:Fire("LowerRandomBound", 30)
				ents.FindByName( "RarityTimer" )[1]:Fire("UpperRandomBound", 50)
				
				ents.FindByName( "TwilightTimer" )[1]:Fire("LowerRandomBound", 30)
				ents.FindByName( "TwilightTimer" )[1]:Fire("UpperRandomBound", 50)
				
				ents.FindByName( "FluttershyTimer" )[1]:Fire("LowerRandomBound", 30)
				ents.FindByName( "FluttershyTimer" )[1]:Fire("UpperRandomBound", 50)
				
				ents.FindByName( "RainbowTimer" )[1]:Fire("LowerRandomBound", 150)
				ents.FindByName( "RainbowTimer" )[1]:Fire("UpperRandomBound", 400)
				ents.FindByName( "RainbowTimer2" )[1]:Fire("LowerRandomBound", 30)
				ents.FindByName( "RainbowTimer2" )[1]:Fire("UpperRandomBound", 50)
			elseif night==3 then
				ents.FindByName( "RarityTimer" )[1]:Fire("LowerRandomBound", 15)
				ents.FindByName( "RarityTimer" )[1]:Fire("UpperRandomBound", 30)
				
				ents.FindByName( "TwilightTimer" )[1]:Fire("LowerRandomBound", 15)
				ents.FindByName( "TwilightTimer" )[1]:Fire("UpperRandomBound", 30)
				
				ents.FindByName( "FluttershyTimer" )[1]:Fire("LowerRandomBound", 15)
				ents.FindByName( "FluttershyTimer" )[1]:Fire("UpperRandomBound", 30)
				
				ents.FindByName( "RainbowTimer" )[1]:Fire("LowerRandomBound", 120)
				ents.FindByName( "RainbowTimer" )[1]:Fire("UpperRandomBound", 300)
				ents.FindByName( "RainbowTimer2" )[1]:Fire("LowerRandomBound", 30)
				ents.FindByName( "RainbowTimer2" )[1]:Fire("UpperRandomBound", 50)
				
				ents.FindByName( "PinkieTimer" )[1]:Fire("LowerRandomBound", 20)
				ents.FindByName( "PinkieTimer" )[1]:Fire("UpperRandomBound", 40)
			elseif night==4 then
				ents.FindByName( "RarityTimer" )[1]:Fire("LowerRandomBound", 10)
				ents.FindByName( "RarityTimer" )[1]:Fire("UpperRandomBound", 20)
				
				ents.FindByName( "TwilightTimer" )[1]:Fire("LowerRandomBound", 10)
				ents.FindByName( "TwilightTimer" )[1]:Fire("UpperRandomBound", 20)
				
				ents.FindByName( "FluttershyTimer" )[1]:Fire("LowerRandomBound", 10)
				ents.FindByName( "FluttershyTimer" )[1]:Fire("UpperRandomBound", 20)
				
				ents.FindByName( "RainbowTimer" )[1]:Fire("LowerRandomBound", 60)
				ents.FindByName( "RainbowTimer" )[1]:Fire("UpperRandomBound", 260)
				ents.FindByName( "RainbowTimer2" )[1]:Fire("LowerRandomBound", 20)
				ents.FindByName( "RainbowTimer2" )[1]:Fire("UpperRandomBound", 40)
				
				ents.FindByName( "PinkieTimer" )[1]:Fire("LowerRandomBound", 10)
				ents.FindByName( "PinkieTimer" )[1]:Fire("UpperRandomBound", 20)
				
				ents.FindByName( "ApplejackTimer" )[1]:Fire("LowerRandomBound", 15)
				ents.FindByName( "ApplejackTimer" )[1]:Fire("UpperRandomBound", 30)
			elseif night==5 then
				ents.FindByName( "RarityTimer" )[1]:Fire("LowerRandomBound", 7)
				ents.FindByName( "RarityTimer" )[1]:Fire("UpperRandomBound", 10)
				
				ents.FindByName( "TwilightTimer" )[1]:Fire("LowerRandomBound", 7)
				ents.FindByName( "TwilightTimer" )[1]:Fire("UpperRandomBound", 10)
				
				ents.FindByName( "FluttershyTimer" )[1]:Fire("LowerRandomBound", 7)
				ents.FindByName( "FluttershyTimer" )[1]:Fire("UpperRandomBound", 10)
				
				ents.FindByName( "RainbowTimer" )[1]:Fire("LowerRandomBound", 60)
				ents.FindByName( "RainbowTimer" )[1]:Fire("UpperRandomBound", 160)
				ents.FindByName( "RainbowTimer2" )[1]:Fire("LowerRandomBound", 15)
				ents.FindByName( "RainbowTimer2" )[1]:Fire("UpperRandomBound", 30)
				
				ents.FindByName( "PinkieTimer" )[1]:Fire("LowerRandomBound", 7)
				ents.FindByName( "PinkieTimer" )[1]:Fire("UpperRandomBound", 10)
				
				ents.FindByName( "ApplejackTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "ApplejackTimer" )[1]:Fire("UpperRandomBound", 15)
			elseif night==6 then
				ents.FindByName( "RarityTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "RarityTimer" )[1]:Fire("UpperRandomBound", 7)
				
				ents.FindByName( "TwilightTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "TwilightTimer" )[1]:Fire("UpperRandomBound", 7)
				
				ents.FindByName( "FluttershyTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "FluttershyTimer" )[1]:Fire("UpperRandomBound", 7)
				
				ents.FindByName( "RainbowTimer" )[1]:Fire("LowerRandomBound", 30)
				ents.FindByName( "RainbowTimer" )[1]:Fire("UpperRandomBound", 120)
				ents.FindByName( "RainbowTimer2" )[1]:Fire("LowerRandomBound", 10)
				ents.FindByName( "RainbowTimer2" )[1]:Fire("UpperRandomBound", 20)
				
				ents.FindByName( "PinkieTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "PinkieTimer" )[1]:Fire("UpperRandomBound", 7)
				
				ents.FindByName( "ApplejackTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "ApplejackTimer" )[1]:Fire("UpperRandomBound", 7)
			else
				ents.FindByName( "RarityTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "RarityTimer" )[1]:Fire("UpperRandomBound", 7)
				
				ents.FindByName( "TwilightTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "TwilightTimer" )[1]:Fire("UpperRandomBound", 7)
				
				ents.FindByName( "FluttershyTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "FluttershyTimer" )[1]:Fire("UpperRandomBound", 7)
				
				ents.FindByName( "RainbowTimer" )[1]:Fire("LowerRandomBound", 30)
				ents.FindByName( "RainbowTimer" )[1]:Fire("UpperRandomBound", 120)
				ents.FindByName( "RainbowTimer2" )[1]:Fire("LowerRandomBound", 10)
				ents.FindByName( "RainbowTimer2" )[1]:Fire("UpperRandomBound", 20)
				
				ents.FindByName( "PinkieTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "PinkieTimer" )[1]:Fire("UpperRandomBound", 7)
				
				ents.FindByName( "ApplejackTimer" )[1]:Fire("LowerRandomBound", 5)
				ents.FindByName( "ApplejackTimer" )[1]:Fire("UpperRandomBound", 7)
			end
			
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..night.." started\n" )
			
			timer.Create( "fnafgmTempoStartU", 1.3, 1, function()
				
				fnafgmVarsUpdate()
				
				for k, v in pairs(team.GetPlayers(1)) do
					if v:Alive() then
						v:ScreenFade(SCREENFADE.OUT, color_black, 0.25, 8.2-1.3-0.25 )
					end
				end
				
				light1use = false
				light2use = false
				
				timer.Remove( "fnafgmTempoStartU" )
				
			end)
			
			timer.Create( "fnafgmTempoStartM", 1.6, 1, function()
				
				for k, v in pairs(team.GetPlayers(1)) do
					if v:Alive() and !CheckPlayerSecurityRoom(v) then
						local spawn = GAMEMODE:PlayerSelectSpawn( v ):GetPos()
						v:SetPos( spawn )
						v:SetEyeAngles(Angle( 0, 0, 0 ))
					end
				end
				
				timer.Remove( "fnafgmTempoStartM" )
				
			end)
			
			timer.Create( "fnafgmTempoStart", 8.2, 1, function()
				
				tempostart = false
				
				fnafgmVarsUpdate()
				fnafgmPowerUpdate()
				
				if game.SinglePlayer() or fnafgm_fnafview_auto:GetBool() then 
					for k, v in pairs(team.GetPlayers(1)) do
						if v:Team()==1 and v:Alive() then
							fnafgmFNaFView(v)
						end
					end
				end
				
				timer.Create( "fnafgmTimeThink", hourtime, 0, fnafgmTimeThink)
				
				timer.Remove( "fnafgmTempoStart" )
				
			end)
			
			return false
			
		elseif btn:IsValid() and ent==btn then
			
			return false
			
		end
	
	elseif test then
		
		if !startday then
			
			startday = true
			tempostart = true
			night = night+1
			AMPM = GAMEMODE.AMPM
			time = GAMEMODE.TimeBase
			hourtime = hourtime+GAMEMODE.HourTime_add
			power = GAMEMODE.Power_Max
			poweroff = false
			nightpassed = false
			iniok = true
			norespawn = false
			foxyknockdoorpena = 2
			addfoxyknockdoorpena = 4
				
			fnafgmVarsUpdate()
			
			for k, v in pairs(team.GetPlayers(1)) do
				if v:Alive() then
					v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 2.5 )
				end
			end
			
			MsgC( Color( 255, 255, 85 ), "FNAFGM: (MANUAL OVERRIDE) Night "..night.." started\n" )
		
			timer.Create( "fnafgmTempoStartM", 0.01, 1, function()
				
				for k, v in pairs(team.GetPlayers(1)) do
					if v:Alive() and !CheckPlayerSecurityRoom(v) then
						local spawn = GAMEMODE:PlayerSelectSpawn( v ):GetPos()
						v:SetPos( spawn )
						v:SetEyeAngles(Angle( 0, 90, 0 ))
					end
				end
				
				timer.Remove( "fnafgmTempoStartM" )
				
			end)
	
			timer.Create( "fnafgmTempoStart", 2.5, 1, function()
				
				tempostart = false
				fnafgmVarsUpdate()
				fnafgmPowerUpdate()
				
				if game.SinglePlayer() or fnafgm_fnafview_auto:GetBool() then 
					for k, v in pairs(team.GetPlayers(1)) do
						if v:Team()==1 and v:Alive() then
							fnafgmFNaFView(v)
						end
					end
				end
				
				timer.Create( "fnafgmTimeThink", hourtime, 0, fnafgmTimeThink)
				
				timer.Remove( "fnafgmTempoStart" )
				
			end)
			
		end
		
	end
	
	if game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent" then

		if door1btn and IsValid(door1btn) and ent==door1btn then
			ent:Fire("use")
			return false
		elseif door2btn and IsValid(door2btn) and ent==door2btn then
			ent:Fire("use")
			return false
		end
		
		if light1 and light1:IsValid() and ent==light1 then
			
			if !light1usewait and !poweroff then
					
				light1usewait = true
				light1use = !light1use
				light1:Fire("use")
				
				if light2use then
					light2use = !light2use
					light2:Fire("use")
				end
				
				timer.Create( "fnafgmlight1usewait", 0.5, 1, function()
					
					light1usewait = false
					
					timer.Remove( "fnafgmlight1usewait" )
					
				end)
				
			end
			
			return false
			
		end
		
		if light2 and light2:IsValid() and ent==light2 then
			
			if !light2usewait and !poweroff then
				
				light2usewait = true
				light2use = !light2use
				light2:Fire("use")
				
				if light1use then
					light1use = !light1use
					light1:Fire("use")
				end
				
				timer.Create( "fnafgmlight2usewait", 0.5, 1, function()
					
					light2usewait = false
					
					timer.Remove( "fnafgmlight2usewait" )
					
				end)
			
			end
			
			return false
			
		end
		
	end
		
	
	if game.GetMap()=="fnaf2" then
		
		if light1 and light1:IsValid() and ent==light1 then
			
			if !light1usewait and !poweroff then
					
				light1usewait = true
				light1use = true
				light1:Fire("use")
				
				timer.Create( "fnafgmlight1usewait", 2.1, 1, function()
					
					light1usewait = false
					light1use = false
					
					timer.Remove( "fnafgmlight1usewait" )
					
				end)
				
			elseif !light1usewait and poweroff then
			
				ply:ConCommand("play "..GAMEMODE.Sound_lighterror)
				light1usewait = true
				
				timer.Create( "fnafgmlight1usewait", 1, 1, function()
					
					light1usewait = false
					
					timer.Remove( "fnafgmlight1usewait" )
					
				end)
				
			end
			
			return false
			
		end
		
		if light2 and light2:IsValid() and ent==light2 then
			
			if !light2usewait and !poweroff then
				
				light2usewait = true
				light2use = true
				light2:Fire("use")
				
				timer.Create( "fnafgmlight2usewait", 3.1, 1, function()
					
					light2usewait = false
					light2use = false
					
					timer.Remove( "fnafgmlight2usewait" )
					
				end)
				
			elseif !light2usewait and poweroff then
			
				ply:ConCommand("play "..GAMEMODE.Sound_lighterror)
				light2usewait = true
				
				timer.Create( "fnafgmlight2usewait", 1, 1, function()
					
					light2usewait = false
					
					timer.Remove( "fnafgmlight2usewait" )
					
				end)
				
			end
			
			return false
			
		end
		
		if light3 and light3:IsValid() and ent==light3 then
			
			if !light3usewait and !poweroff then
				
				light3usewait = true
				light3use = true
				light3:Fire("use")
				
				timer.Create( "fnafgmlight3usewait", 2.1, 1, function()
					
					light3usewait = false
					light3use = false
					
					timer.Remove( "fnafgmlight3usewait" )
					
				end)
				
			elseif !light3usewait and poweroff then
			
				ply:ConCommand("play "..GAMEMODE.Sound_lighterror)
				light3usewait = true
				
				timer.Create( "fnafgmlight3usewait", 1, 1, function()
					
					light3usewait = false
					
					timer.Remove( "fnafgmlight3usewait" )
					
				end)
				
			end
			
			return false
			
		end
		
		if safedoor and safedoor:IsValid() and ent==safedoor and !usingsafedoor[ply] then
			
			ply:SetPos( Vector( -46, -450, 0 ) )
			
			usingsafedoor[ply]=true
			
		elseif safedoor and safedoor:IsValid() and ent==safedoor and usingsafedoor[ply] then
			
			ply:SetPos( Vector( -46, -320, 0 ) )
			
			usingsafedoor[ply]=false
			
		end
	
	end
	
	
	if game.GetMap()=="fnap_scc" then
		
		if door1btn and IsValid(door1btn) and ent==door1btn then
			ent:Fire("use")
			return false
		elseif door2btn and IsValid(door2btn) and ent==door2btn then
			ent:Fire("use")
			return false
		end
		
		if light1 and light1:IsValid() and ent==light1 then
			
			if !light1usewait and !poweroff then
					
				light1usewait = true
				light1use = !light1use
				light1:Fire("use")
				
				if light2use then
					light2use = !light2use
					light2:Fire("use")
				end
				
				timer.Create( "fnafgmlight1usewait", 1, 1, function()
					
					light1usewait = false
					
					timer.Remove( "fnafgmlight1usewait" )
					
				end)
				
			end
			
			return false
			
		end
		
		if light2 and light2:IsValid() and ent==light2 then
			
			if !light2usewait and !poweroff then
				
				light2usewait = true
				light2use = !light2use
				light2:Fire("use")
				
				if light1use then
					light1use = !light1use
					light1:Fire("use")
				end
				
				timer.Create( "fnafgmlight2usewait", 1, 1, function()
					
					light2usewait = false
					
					timer.Remove( "fnafgmlight2usewait" )
					
				end)
			
			end
			
			return false
			
		end
		
	end
	
	
end
hook.Add( "PlayerUse", "fnafgmUse", fnafgmUse )


function fnafgmAutoCleanUp()
	
	if fnafgm_autocleanupmap:GetBool() and active and !alive then
	
		local online = false
		
		for k, v in pairs(player.GetAll()) do
			online = true
		end

		if !online then
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Auto clean up\n" )
			active = false
			fnafgmResetGame()
			fnafgmMapOverrides()
		end
		
	end
	
end

function fnafgmRestartNight()
	
	if (iniok and mapoverrideok and startday and active) then
		
		game.CleanUpMap()
		timer.Remove("fnafgmFreddyTrigger")
		timer.Remove("fnafgmChicaTrigger")
		timer.Remove("fnafgmBonnieTrigger")
		timer.Remove("fnafgmTimeThink")
		timer.Remove("fnafgmPowerOff1")
		timer.Remove("fnafgmPowerOff2")
		timer.Remove("fnafgmPowerOff3")
		night = night-1
		time = GAMEMODE.TimeBase
		AMPM = GAMEMODE.AMPM
		hourtime = hourtime-GAMEMODE.HourTime_add
		power = GAMEMODE.Power_Max
		poweroff = false
		powerchecktime=nil
		oldpowerdrain=nil
		table.Empty(tabused)
		table.Empty(usingsafedoor)
		startday = false
		tempostart = false
		nightpassed = false
		mapoverrideok = false
		light1use = false
		light2use = false
		mute = true
		timer.Remove( "fnafgmEndCall" )
		FreddyTriggered = false
		ChicaTriggered = false
		BonnieTriggered = false
		fnafgmMapOverrides()
		fnafgmVarsUpdate()
		fnafgmPowerUpdate()
		for k, v in pairs(player.GetAll()) do
			if ( game.SinglePlayer() ) then v:ConCommand("stopsound") else v:SendLua([[RunConsoleCommand("stopsound")]]) end --Stop sound
			if v:Team()==1 or v:Team()==2 then
				v:Spawn()
				v:SetViewEntity(v)
			end
			if (fnafgm_pinionsupport:GetBool()) then Pinion:ShowMOTD(v) end
		end
		
		norespawn=false
		checkRestartNight=false
		
		MsgC( Color( 255, 255, 85 ), "FNAFGM: The night is reset\n" )
		
	end
	
end


function fnafgmResetGame()
	
	game.CleanUpMap()
	startday = false
	tempostart = false
	iniok = false
	mapoverrideok = false
	time = GAMEMODE.TimeBase
	AMPM = GAMEMODE.AMPM
	hourtime = GAMEMODE.HourTime
	power = GAMEMODE.Power_Max
	poweroff = false
	powerchecktime=nil
	oldpowerdrain=nil
	light1use = false
	light2use = false
	table.Empty(tabused)
	table.Empty(usingsafedoor)
	night = GAMEMODE.NightBase
	norespawn = false
	nightpassed = false
	gameend = false
	checkRestartNight = false
	mute = true
	timer.Remove( "fnafgmEndCall" )
	timer.Remove("fnafgmFreddyTrigger")
	timer.Remove("fnafgmChicaTrigger")
	timer.Remove("fnafgmBonnieTrigger")
	FreddyTriggered = false
	ChicaTriggered = false
	BonnieTriggered = false
	timer.Remove("fnafgmTimeThink")
	timer.Remove("fnafgmRestartNight")
	timer.Remove("fnafgmNightPassed")
	timer.Remove("fnafgmPowerOff1")
	timer.Remove("fnafgmPowerOff2")
	timer.Remove("fnafgmPowerOff3")
	fnafgmVarsUpdate()
	fnafgmPowerUpdate()
	
end


function fnafgmMapOverrides()
	
	if !mapoverrideok then
	
		if (game.GetMap()=="freddys") then
			
			for k, tmp in pairs(ents.FindByName("Pwrbtn")) do
				btn = tmp
			end
			
			for k, v in pairs(ents.FindByName("genroomkey")) do
				v:Remove()
			end
			
			for k, v in pairs(ents.FindByClass("prop_physics")) do
				if v and v:IsValid() then
					v:SetMoveType(MOVETYPE_CUSTOM)
				end
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
			
			for k, v in pairs(ents.FindByName("Securicam")) do
				v:Fire("Color", "0 0 0")
			end
			
			for k, v in pairs(ents.FindByName("Cambutton")) do
				v:Remove()
			end
			
			for k, v in pairs(ents.FindByName("powerbar")) do
				v:Remove()
			end
			
			for k, v in pairs(ents.FindByName("Callman")) do
				v:Fire("Lock")
			end
			
			if night>4 then
				for k, v in pairs(ents.FindByName("phonelight")) do
					v:Remove()
				end
			end
			
			for k, v in pairs(ents.FindByName("Genbutton")) do
				v:Remove()
			end
			
			local spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -140, -1237, 70 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -28, -1237, 70 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -54, -1200, 70 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -106, -1200, 70 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -78, -1150, 70 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			local fnafgm_link = ents.Create( "fnafgm_link" )
			fnafgm_link:SetName("fnafgm_link")
			fnafgm_link:SetPos( Vector( -86, -1146, 0 ) )
			fnafgm_link:Spawn()
			
			for k, v in pairs(ents.FindByClass("point_camera")) do
				local CAM = ents.Create( "fnafgm_camera" )
				CAM:SetPos( v:GetPos() )
				CAM:SetAngles( v:GetAngles() )
				CAM:SetName( "fnafgm_"..v:GetName() )
				if v:GetKeyValues().parentname!="" then 
					local parent = ents.FindByName( v:GetKeyValues().parentname )[1]
					if IsValid(parent) then
						CAM:SetParent(parent)
					end
				end
				CAM:Spawn()
				v:Fire("SetOff")
			end
			
			ents.FindByName( "foxytest" )[1]:Fire("addoutput", "OnTrigger fnafgm_link,FoxyKnockDoor,,0,-1")
			ents.FindByName( "foxytest2" )[1]:Fire("addoutput", "OnTrigger fnafgm_link,FoxyKnockDoor,,0,-1")
				
			ents.FindByName( "EventCase2" )[1]:Fire("addoutput", "OnCase05 fnafgm_link,Freddy,,0,-1")
			ents.FindByName( "freddyappear" )[1]:Fire("Kill")
				
			ents.FindByName( "EventCase" )[1]:Fire("addoutput", "OnCase09 fnafgm_link,Bonnie,,0,-1")
			ents.FindByName( "bonnieappear" )[1]:Fire("Kill")
				
			ents.FindByName( "EventCase" )[1]:Fire("addoutput", "OnCase13 fnafgm_link,Chica,,0,-1")
			ents.FindByName( "chicaappear" )[1]:Fire("Kill")
			
		elseif (game.GetMap()=="freddysnoevent") then
			
			for k, tmp in pairs(ents.FindByName("Pwrbtn")) do
				btn = tmp
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
			
			for k, v in pairs(ents.FindByName("Securicam")) do
				v:Fire("Color", "0 0 0")
			end
			
			for k, v in pairs(ents.FindByName("Cambutton")) do
				v:Remove()
			end
			
			for k, v in pairs(ents.FindByName("powerbar")) do
				v:Remove()
			end
			
			for k, v in pairs(ents.FindByName("Genbutton")) do
				v:Remove()
			end
			
			local spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -140, -1237, 70 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -28, -1237, 70 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -54, -1200, 70 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -106, -1200, 70 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -78, -1150, 70 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( 100, 160, 100 ) )
			spawn:SetAngles( Angle( 30, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( 0, 160, 100 ) )
			spawn:SetAngles( Angle( 30, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -110, 160, 100 ) )
			spawn:SetAngles( Angle( 30, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -150, 220, 100 ) )
			spawn:SetAngles( Angle( 30, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -30, 204, 100 ) )
			spawn:SetAngles( Angle( 30, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( 78, 210, 100 ) )
			spawn:SetAngles( Angle( 30, -90, 0 ) )
			spawn:Spawn()
			
			local fnafgm_link = ents.Create( "fnafgm_link" )
			fnafgm_link:SetName("fnafgm_link")
			fnafgm_link:SetPos( Vector( -86, -1146, 0 ) )
			fnafgm_link:Spawn()
			
			for k, v in pairs(ents.FindByClass("point_camera")) do
				local CAM = ents.Create( "fnafgm_camera" )
				CAM:SetPos( v:GetPos() )
				CAM:SetAngles( v:GetAngles() )
				CAM:SetName( "fnafgm_"..v:GetName() )
				if v:GetKeyValues().parentname!="" then 
					local parent = ents.FindByName( v:GetKeyValues().parentname )[1]
					if IsValid(parent) then
						CAM:SetParent(parent)
					end
				end
				CAM:Spawn()
				v:Fire("SetOff")
			end
			
		elseif (game.GetMap()=="fnaf2") then
			
			for k, v in pairs(ents.FindByName("toybutt")) do
				btn = v
			end
			
			for k, v in pairs(ents.FindByName("misfitbutt")) do
				btnm = v
			end
			
			local BoxCorner = Vector(-149,-281,65)
			local OppositeCorner = Vector(-163,-273,47)
			for k, v in pairs(ents.FindByClass("func_button")) do
				if table.HasValue(ents.FindInBox(BoxCorner,OppositeCorner), v) then
					light1 = v
				end
			end
			
			for k, v in pairs(ents.FindByName("FlashlightButton")) do
				light2 = v
			end
			
			local BoxCorner = Vector(152,-284,62)
			local OppositeCorner = Vector(177,-257,40)
			for k, v in pairs(ents.FindByClass("func_button")) do
				if table.HasValue(ents.FindInBox(BoxCorner,OppositeCorner), v) then
					light3 = v
				end
			end
			
			for k, v in pairs(ents.FindByClass("func_monitor")) do
				if CheckPlayerSecurityRoom(v) then
					v:Fire("Color", "0 0 0")
				end
			end
			
			for k, v in pairs(ents.FindByName("Cambutton")) do
				v:Remove()
			end
			
			local BoxCorner = Vector(-85,-330,120)
			local OppositeCorner = Vector(0,-380,0)
			for k, v in pairs(ents.FindByClass("prop_door_rotating")) do
				if table.HasValue(ents.FindInBox(BoxCorner,OppositeCorner), v) then
					v:Fire("lock")
					safedoor = v
				end
			end
			
			local BoxCorner = Vector(-85,-333,40)
			local OppositeCorner = Vector(-180,-364,113)
			for k, v in pairs(ents.FindInBox(BoxCorner,OppositeCorner)) do
				if v:GetClass()=="func_button" or v:GetClass()=="func_breakable" then
					v:Remove()
				end
			end
			
			local spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( 116, -320, 0 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( 46, -320, 0 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( 0, -320, 0 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -120, -320, 0 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( 0, -154, 0 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( 102, -205, 0 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -62, -240, 0 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( 42, -270, 0 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( 0, -270, 0 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( 28, -190, 0 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -25, -190, 0 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -50, -282, 0 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			local DeathCam = ents.Create( "fnafgm_camera" )
			DeathCam:SetPos( Vector( -227, 1340, 48 ) )
			DeathCam:SetAngles( Angle( -2, 117, 0 ) )
			DeathCam:SetName( "DeathCam" )
			DeathCam:Spawn()
			
			SafeZoneCam = ents.Create( "fnafgm_camera" )
			SafeZoneCam:SetPos( GAMEMODE.FNaFView[game.GetMap()][1] + Vector( 0, 0, 64 ) )
			SafeZoneCam:SetAngles( GAMEMODE.FNaFView[game.GetMap()][2] )
			SafeZoneCam:SetName( "SafeZoneCam" )
			SafeZoneCam:Spawn()
			
			for k, v in pairs(ents.FindByClass("point_camera")) do
				local CAM = ents.Create( "fnafgm_camera" )
				CAM:SetPos( v:GetPos() )
				CAM:SetAngles( v:GetAngles() )
				CAM:SetName( "fnafgm_"..v:GetName() )
				if v:GetKeyValues().parentname!="" then 
					local parent = ents.FindByName( v:GetKeyValues().parentname )[1]
					if IsValid(parent) then
						CAM:SetParent(parent)
					end
				end
				CAM:Spawn()
				v:Fire("SetOff")
			end
			
		elseif (game.GetMap()=="fnaf_freddypizzaevents") then
			
			for k, v in pairs(ents.FindByName("st_teleport")) do
				tp = v
			end
			
			local BoxCorner = Vector(-390,1790,385)
			local OppositeCorner = Vector(-420,1775,360)
			for k, v in pairs(ents.FindInBox(BoxCorner,OppositeCorner)) do
				btn = v
			end
			
			local spawn = ents.Create( "info_player_deathmatch" )
			spawn:SetPos( Vector( -600, 2060, 0 ) )
			spawn:SetAngles( Angle( 0, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_deathmatch" )
			spawn:SetPos( Vector( -550, 2060, 0 ) )
			spawn:SetAngles( Angle( 0, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_deathmatch" )
			spawn:SetPos( Vector( -500, 2060, 0 ) )
			spawn:SetAngles( Angle( 0, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_deathmatch" )
			spawn:SetPos( Vector( -450, 2060, 0 ) )
			spawn:SetAngles( Angle( 0, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_deathmatch" )
			spawn:SetPos( Vector( -400, 2060, 0 ) )
			spawn:SetAngles( Angle( 0, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_deathmatch" )
			spawn:SetPos( Vector( -350, 2060, 0 ) )
			spawn:SetAngles( Angle( 0, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_deathmatch" )
			spawn:SetPos( Vector( -600, 2010, 0 ) )
			spawn:SetAngles( Angle( 0, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_deathmatch" )
			spawn:SetPos( Vector( -550, 2010, 0 ) )
			spawn:SetAngles( Angle( 0, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_deathmatch" )
			spawn:SetPos( Vector( -500, 2010, 0 ) )
			spawn:SetAngles( Angle( 0, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_deathmatch" )
			spawn:SetPos( Vector( -450, 2010, 0 ) )
			spawn:SetAngles( Angle( 0, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_deathmatch" )
			spawn:SetPos( Vector( -400, 2010, 0 ) )
			spawn:SetAngles( Angle( 0, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_deathmatch" )
			spawn:SetPos( Vector( -350, 2010, 0 ) )
			spawn:SetAngles( Angle( 0, -90, 0 ) )
			spawn:Spawn()
			
			for k, v in pairs(ents.FindByClass("point_camera")) do
				local CAM = ents.Create( "fnafgm_camera" )
				CAM:SetPos( v:GetPos() )
				CAM:SetAngles( v:GetAngles() )
				CAM:SetName( "fnafgm_"..v:GetName() )
				if v:GetKeyValues().parentname!="" then 
					local parent = ents.FindByName( v:GetKeyValues().parentname )[1]
					if IsValid(parent) then
						CAM:SetParent(parent)
					end
				end
				CAM:Spawn()
			end
		
		
		elseif (game.GetMap()=="fnap_scc") then
			
			for k, v in pairs(ents.FindByName("TimerButton")) do
				btn = v
			end
			
			for k, v in pairs(ents.FindByName("DoorOffice1")) do
				door1 = v
			end
			
			for k, v in pairs(ents.FindByName("DoorOffice2")) do
				door2 = v
			end
			
			for k, v in pairs(ents.FindByName("Door1Light")) do
				light1 = v
			end
			
			for k, v in pairs(ents.FindByName("Door2Light")) do
				light2 = v
			end
			
			for k, v in pairs(ents.FindByName("OfficeLightSwitch")) do
				light3 = v
			end
			
			if night==0 then
				ents.FindByName( "CallButton" )[1]:Fire("addoutput", "OnPressed Call1,Playsound,none,0.00,1")
			elseif night==1 then
				ents.FindByName( "CallButton" )[1]:Fire("addoutput", "OnPressed Call2,Playsound,none,0.00,1")
			elseif night==2 then
				ents.FindByName( "CallButton" )[1]:Fire("addoutput", "OnPressed Call3,Playsound,none,0.00,1")
			elseif night==3 then
				ents.FindByName( "CallButton" )[1]:Fire("addoutput", "OnPressed Call4,Playsound,none,0.00,1")
			elseif night==4 then
				ents.FindByName( "CallButton" )[1]:Fire("addoutput", "OnPressed Call5,Playsound,none,0.00,1")
			elseif night==5 then
				ents.FindByName( "CallButton" )[1]:Fire("addoutput", "OnPressed Call6,Playsound,none,0.00,1")
			end
		
		elseif game.GetMap()=="fnaf3" then
			
			local CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(-226,-310,190) )
			CAM:SetAngles( Angle(37,-102,0) )
			CAM:SetName( "fnafgm_Cam1" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(256,-102,158) )
			CAM:SetAngles( Angle(4,114,0) )
			CAM:SetName( "fnafgm_Cam2" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(317,-183,170) )
			CAM:SetAngles( Angle(60,92,0) )
			CAM:SetName( "fnafgm_Cam3" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(350,-193,150) )
			CAM:SetAngles( Angle(34,90,0) )
			CAM:SetName( "fnafgm_Cam4" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(14,150,140) )
			CAM:SetAngles( Angle(16,-180,0) )
			CAM:SetName( "fnafgm_Cam5" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(-415,100,142) )
			CAM:SetAngles( Angle(28,96,0) )
			CAM:SetName( "fnafgm_Cam6" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(-396,253,137) )
			CAM:SetAngles( Angle(24,91,0) )
			CAM:SetName( "fnafgm_Cam7" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(-248,248,139) )
			CAM:SetAngles( Angle(21,25,0) )
			CAM:SetName( "fnafgm_Cam8" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(58,363,163) )
			CAM:SetAngles( Angle(15,13,0) )
			CAM:SetName( "fnafgm_Cam9" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(293,362,173) )
			CAM:SetAngles( Angle(27,36,0) )
			CAM:SetName( "fnafgm_Cam10" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(-627,527,78) )
			CAM:SetAngles( Angle(-1,3,0) )
			CAM:SetName( "fnafgm_Cam11" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(-585,310,98) )
			CAM:SetAngles( Angle(6,158,0) )
			CAM:SetName( "fnafgm_Cam12" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(-184,19,105) )
			CAM:SetAngles( Angle(35,-178,0) )
			CAM:SetName( "fnafgm_Cam13" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(477,0,94) )
			CAM:SetAngles( Angle(0,90,0) )
			CAM:SetName( "fnafgm_Cam14" )
			CAM:Spawn()
			
			CAM = ents.Create( "fnafgm_camera" )
			CAM:SetPos( Vector(218,-244,117) )
			CAM:SetAngles( Angle(18,-59,0) )
			CAM:SetName( "fnafgm_Cam15" )
			CAM:Spawn()
			
		elseif game.GetMap()=="fnaf4" then
			
			--Do somehing here lol
			
		else
			
			for k, v in pairs(ents.FindByClass("point_camera")) do
				local CAM = ents.Create( "fnafgm_camera" )
				CAM:SetPos( v:GetPos() )
				CAM:SetAngles( v:GetAngles() )
				CAM:SetName( "fnafgm_"..v:GetName() )
				if v:GetKeyValues().parentname!="" then 
					local parent = ents.FindByName( v:GetKeyValues().parentname )[1]
					if IsValid(parent) then
						CAM:SetParent(parent)
					end
				end
				CAM:Spawn()
			end
			
			MsgC( Color( 255, 255, 85 ), "FNAFGM: There is no special map overrides for this map :(\n" )
			
		end
		
		
		mapoverrideok = true
		MsgC( Color( 255, 255, 85 ), "FNAFGM: Map overrides done\n" )
		
	end
	
end


util.AddNetworkString( "fnafgmVarsUpdate" )
function fnafgmVarsUpdate()
	
	net.Start( "fnafgmVarsUpdate" )
		net.WriteBit( startday )
		net.WriteBit( gameend )
		net.WriteBit( iniok )
		net.WriteInt( time, 5 )
		net.WriteString( AMPM )
		net.WriteInt( night, 32 )
		net.WriteBit( nightpassed )
		net.WriteBit( tempostart )
		net.WriteBit( mute )
		net.WriteBit( overfive )
	net.Broadcast()
	
end


function fnafgmTimeThink()
	
	if (time == 12 and AMPM == "AM") then
		time = 1
	elseif (time == 11 and AMPM == "AM") then
		time = 12
		AMPM = "PM"
	elseif (time == 11 and AMPM == "PM") then
		time = 12
		AMPM = "AM"
		night = night+1
	elseif (time == 12 and AMPM == "PM") then
		time = 1
	else
		time = time+1
	end
	
	MsgC( Color( 255, 255, 85 ), "FNAFGM: "..time..AMPM.."\n" )
	
	if (time == GAMEMODE.TimeEnd and night >= GAMEMODE.NightEnd and AMPM == GAMEMODE.AMPM_End and !fnafgm_timethink_infinitenights:GetBool()) then
		
		MsgC( Color( 255, 255, 85 ), "FNAFGM: Last night passed ("..night..")\n" )
		startday = false
		gameend = true
		timer.Remove("fnafgmFreddyTrigger")
		timer.Remove("fnafgmChicaTrigger")
		timer.Remove("fnafgmBonnieTrigger")
		FreddyTriggered = false
		ChicaTriggered = false
		BonnieTriggered = false	
		timer.Remove("fnafgmTimeThink")
		timer.Remove("fnafgmPowerOff1")
		timer.Remove("fnafgmPowerOff2")
		timer.Remove("fnafgmPowerOff3")
		hourtime = GAMEMODE.HourTime
		power = GAMEMODE.Power_Max
		poweroff = false
		powerchecktime=nil
		oldpowerdrain=nil
		finishedweek = finishedweek + 1
		table.Empty(tabused)
		table.Empty(usingsafedoor)
		for k, v in pairs(player.GetAll()) do
			if v:GetViewEntity()!=v then
				v:SetViewEntity(v)
			end
			if v:Team()==1 then v:ConCommand( "pp_mat_overlay ''" ) end
		end
		game.CleanUpMap()
		fnafgmPowerUpdate()
		
		if night > GAMEMODE.NightEnd then
			overfive = true
		end
		
		for k, v in pairs(player.GetAll()) do
			if ( game.SinglePlayer() ) then v:ConCommand("stopsound") else v:SendLua([[RunConsoleCommand("stopsound")]]) end --Stop sound
			if game.GetMap()=="fnaf2" then
				v:ConCommand("play "..GAMEMODE.Sound_endnight2)
			else
				v:ConCommand("play "..GAMEMODE.Sound_endnight)
			end
			v:ConCommand( "pp_mat_overlay ''" )
			v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 65536 )
			if (v:Team()==1 or v:Team()==2) and v:Alive() then
				v:KillSilent()
			end
		end
		
		GAMEMODE:SaveProgress()
		
		timer.Create( "fnafgmNightPassed", 11, 1, function()
			
			if game.GetMap()=="freddys" or game.GetMap()=="fnaf2" then
			
				net.Start( "fnafgmShowCheck" )
					net.WriteBit( true )
				net.Broadcast()
				
				for k, v in pairs(player.GetAll()) do
					
					v:ScreenFade(16, color_black, 0, 0 )
					
					if v:Team()==1 or v:Team()==2 then
						
						v:SetTeam(TEAM_UNASSIGNED)
						if game.GetMap()=="freddys" and night==GAMEMODE.NightEnd and !overfive then
							v:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_end1 )
							v:ConCommand("play "..GAMEMODE.Sound_end1)
						elseif game.GetMap()=="freddys" then
							v:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_end1_6 )
							v:ConCommand("play "..GAMEMODE.Sound_end1)
						elseif game.GetMap()=="fnaf2" and night==GAMEMODE.NightEnd then
							v:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_end2 )
							v:ConCommand("play "..GAMEMODE.Sound_end2)
						elseif game.GetMap()=="fnaf2" and night>GAMEMODE.NightEnd then
							v:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_end2_6 )
							v:ConCommand("play "..GAMEMODE.Sound_end2)
						end	
						
					end
					
					if (fnafgm_pinionsupport:GetBool()) then Pinion:ShowMOTD(v) end
					
				end
				
				timer.Create( "fnafgmAfterCheck", 19.287, 1, function()
					
					for k, v in pairs(team.GetPlayers(TEAM_UNASSIGNED)) do
				
						v:SetTeam(1)
						v:Spawn()
					
					end
					
					timer.Remove("fnafgmAfterCheck")
						
				end)
				
			else
		
				for k, v in pairs(player.GetAll()) do
					
					v:ScreenFade(16, color_black, 0, 0 )
					
					if v:Team()==1 or v:Team()==2 then
						
						v:Spawn()
					
					end
					
					if (fnafgm_pinionsupport:GetBool()) then Pinion:ShowMOTD(v) end
				
				end
				
			end
			
			gameend = false
			norespawn = false
			fnafgmResetGame()
			if !game.IsDedicated() then night = GAMEMODE.NightEnd end
			fnafgmMapOverrides()
			fnafgmVarsUpdate()
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Ready to start a new week!\n" )
			timer.Remove("fnafgmNightPassed")
		
		end)
		
	elseif (time == GAMEMODE.TimeEnd and AMPM == GAMEMODE.AMPM_End and !fnafgm_timethink_endlesstime:GetBool()) then
		
		MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..night.." passed\n" )
		startday = false
		nightpassed = true	
		timer.Remove("fnafgmFreddyTrigger")
		timer.Remove("fnafgmChicaTrigger")
		timer.Remove("fnafgmBonnieTrigger")
		FreddyTriggered = false
		ChicaTriggered = false
		BonnieTriggered = false
		timer.Remove("fnafgmTimeThink")
		timer.Remove("fnafgmPowerOff1")
		timer.Remove("fnafgmPowerOff2")
		timer.Remove("fnafgmPowerOff3")
		power = GAMEMODE.Power_Max
		powerchecktime=nil
		oldpowerdrain=nil
		poweroff = false
		game.CleanUpMap()
		light1use = false
		light2use = false
		mapoverrideok = false
		fnafgmMapOverrides()
		table.Empty(tabused)
		table.Empty(usingsafedoor)
		fnafgmPowerUpdate()
		
		for k, v in pairs(player.GetAll()) do
			if ( game.SinglePlayer() ) then v:ConCommand("stopsound") else v:SendLua([[RunConsoleCommand("stopsound")]]) end --Stop sound
			if game.GetMap()=="fnaf2" then
				v:ConCommand("play "..GAMEMODE.Sound_endnight2)
			else
				v:ConCommand("play "..GAMEMODE.Sound_endnight)
			end
			v:ConCommand( "pp_mat_overlay ''" )
			v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 65536 )
			if (v:Team()==1 or v:Team()==2) and v:Alive() then
				v:KillSilent()
			end
		end
		
		GAMEMODE:SaveProgress()
		
		timer.Create( "fnafgmNightPassed", 11, 1, function()
			
			for k, v in pairs(player.GetAll()) do
				
				v:ScreenFade(16, color_black, 0, 0 )
				
				if v:Team()==1 or v:Team()==2 then
					v:Spawn()
				end
				
				if (fnafgm_pinionsupport:GetBool()) then Pinion:ShowMOTD(v) end
				
			end
			
			nightpassed = false
			norespawn = false
			fnafgmVarsUpdate()
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Ready to start a new night\n" )
			timer.Remove("fnafgmNightPassed")
			
		end)
	
	end
	
	fnafgmVarsUpdate()
	
end


function GM:FinishMove( ply, mv )
	
	local userid = ply:UserID()
	
	if !SGvsA and fnafgm_killextsrplayers:GetBool() and CheckPlayerSecurityRoom(ply)!=nil then
	
		if CheckPlayerSecurityRoom(ply) or !ply:Alive() then
			
			if timer.Exists( "fnafgmPlayerSecurityRoomNot"..userid ) then
				timer.Remove( "fnafgmPlayerSecurityRoomNot"..userid )
				if ply:Alive() and ply:Team()==1 then
					ply:ConCommand( "pp_mat_overlay ''" )
				end
			end
			
		elseif !CheckPlayerSecurityRoom(ply) and !timer.Exists( "fnafgmPlayerSecurityRoomNot"..userid ) and ply:Alive() and startday and !tempostart and ply:Team()==1 and !fnafgmPlayerCanByPass(ply,"nokillextsr") then
			
			local PSRTT=10
			if game.GetMap()=="fnaf2" then
				PSRTT=21
			end
			
			if !usingsafedoor[ply] then
				ply:PrintMessage(HUD_PRINTTALK, "Stay in the security room otherwise you risk getting caught by the "..GAMEMODE.Strings.base.animatronics)
				ply:SendLua([[chat.PlaySound()]])
				
				ply:ConCommand( "pp_mat_overlay effects/water_warp01" )
			end
			
			timer.Create( "fnafgmPlayerSecurityRoomNot"..userid, PSRTT, 1, function()
				
				if (IsValid(ply)) then
					ply:ConCommand("play "..GAMEMODE.Sound_GoldenFoxy)
					ply:Kill()
					MsgC(Color( 255, 255, 85 ), "FNAFGM: "..ply:GetName().." is dead by the outside!\n")
				end
				
				timer.Remove( "fnafgmPlayerSecurityRoomNot"..userid )
				
			end)
		end
	
	end
	
	if SGvsA and CheckPlayerSecurityRoom(ply) and ply:Team()==2 and ply:Alive() then
		
		if player_manager.GetPlayerClass(ply)=="player_fnafgmfoxy" then
		
			for k, v in pairs(player.GetAll()) do
				if CheckPlayerSecurityRoom(v) and v:Team()==1 and v:Alive() then
					
					ply:PrintMessage(HUD_PRINTTALK, "You hit "..v:GetName())
					v:ConCommand("play "..GAMEMODE.Sound_xscream)
					v:TakeDamage(100, ply )
					v:PrintMessage(HUD_PRINTTALK, GAMEMODE.Strings.base.foxy.." ("..ply:GetName()..") killed you!")
					MsgC(Color( 255, 255, 85 ), "FNAFGM: '"..ply:GetName().."' entered the security room and kill '"..v:GetName().."'\n")
					
				end
			end
		
			ply:TakeDamage(100, nil )
		
		end
		
	end
	
	if (game.GetMap()=="freddysnoevent") then
		
		local PSRTT=24
		
		if player_manager.GetPlayerClass(ply)=="player_fnafgmfoxy" then
			 PSRTT=5
		end
		
		if ( !CheckPlayerSecurityRoom(ply) and !CheckPlayerHallways(ply) ) or !ply:Alive() then
			
			if timer.Exists( "fnafgmPlayerHallway"..userid ) then
				timer.Remove( "fnafgmPlayerHallway"..userid )
			end
			
		elseif ( CheckPlayerSecurityRoom(ply) or CheckPlayerHallways(ply) ) and !timer.Exists( "fnafgmPlayerHallway"..userid ) and ply:Alive() and ply:Team()==2 then
			
			ply:SendLua([[chat.PlaySound()]])
			ply:PrintMessage(HUD_PRINTTALK, "If you stay here "..PSRTT.."s you will be killed.")
			
			timer.Create( "fnafgmPlayerHallway"..userid, PSRTT, 1, function()
				
				if (IsValid(ply)) then
					ply:Kill()
					MsgC(Color( 255, 255, 85 ), "FNAFGM: "..ply:GetName().." is dead by the hall!\n")
				end
				
				timer.Remove( "fnafgmPlayerHallway"..userid )
				
			end)
		end
	
	end
	
	if CheckFreddyTrigger(ply) and ply:Team()==2 and player_manager.GetPlayerClass(ply)=="player_fnafgmfreddy" and ply:Alive() and avisible[ply] and !timer.Exists( "fnafgmFreddyTrigger" ) and !FreddyTriggered then
		
		FreddyTriggered = true
		
		timer.Remove( "fnafgmPlayerHallway"..userid )
		
		ply:SetPos(Vector( 43, -1171, 65 ))
		ply:SetAngles(Angle( 0, 180, 0 ))
		ply:SetEyeAngles(Angle( 0, 180, 0 ))
		ply:Freeze(true)
		
		local timet=2.5
		if night==1 then
			timet=5.5
		elseif night==2 then
			timet=5
		elseif night==3 then
			timet=4.5
		elseif night==4 then
			timet=4
		elseif night==5 then
			timet=3.5
		elseif night==6 then
			timet=3
		end
		
		timer.Create( "fnafgmFreddyTrigger", timet, 1, function()
			
			if IsValid(ply) then
				ply:Freeze(false)
				ply:Kill()
			end
			
			if door2:GetPos()!=Vector(4.000000, -1168.000000, 112.000000) then
			
				for k, v in pairs(player.GetAll()) do
					if CheckPlayerSecurityRoom(v) and v:Team()==1 and v:Alive() then
						
						v:ConCommand( "pp_mat_overlay freddys/fazbear_deathscreen" )
						ply:PrintMessage(HUD_PRINTTALK, "You hit "..v:GetName())
						v:ConCommand("play "..GAMEMODE.Sound_xscream)
						v:TakeDamage(100, ply )
						v:PrintMessage(HUD_PRINTTALK, GAMEMODE.Strings.base.freddy.." ("..ply:GetName()..") killed you!")
						MsgC(Color( 255, 255, 85 ), "FNAFGM: '"..ply:GetName().."' entered the security room and kill '"..v:GetName().."'\n")
						
					end
				end
				
			end
			
			FreddyTriggered = false
			
			timer.Remove( "fnafgmFreddyTrigger" )
			
		end)
		
	end
	
	if CheckChicaTrigger(ply) and ply:Team()==2 and player_manager.GetPlayerClass(ply)=="player_fnafgmchica" and ply:Alive() and avisible[ply] and !timer.Exists( "fnafgmChicaTrigger" ) and !ChicaTriggered then
		
		ChicaTriggered = true
		
		timer.Remove( "fnafgmPlayerHallway"..userid )
		
		ply:SetPos(Vector( 32, -1080, 65 ))
		ply:SetAngles(Angle( 0, 211, 0 ))
		ply:SetEyeAngles(Angle( 0, 211, 0 ))
		ply:Freeze(true)
		
		local timet=2.5
		if night==1 then
			timet=5.5
		elseif night==2 then
			timet=5
		elseif night==3 then
			timet=4.5
		elseif night==4 then
			timet=4
		elseif night==5 then
			timet=3.5
		elseif night==6 then
			timet=3
		end
		
		timer.Create( "fnafgmChicaTrigger", timet, 1, function()
			
			if IsValid(ply) then
				ply:Freeze(false)
				ply:Kill()
			end
			
			if door2:GetPos()!=Vector(4.000000, -1168.000000, 112.000000) then
			
				for k, v in pairs(player.GetAll()) do
					if CheckPlayerSecurityRoom(v) and v:Team()==1 and v:Alive() then
						
						v:ConCommand( "pp_mat_overlay freddys/chicadeath" )
						ply:PrintMessage(HUD_PRINTTALK, "You hit "..v:GetName())
						v:ConCommand("play "..GAMEMODE.Sound_xscream)
						v:TakeDamage(100, ply )
						v:PrintMessage(HUD_PRINTTALK, GAMEMODE.Strings.base.chica.." ("..ply:GetName()..") killed you!")
						MsgC(Color( 255, 255, 85 ), "FNAFGM: '"..ply:GetName().."' entered the security room and kill '"..v:GetName().."'\n")
						
					end
				end
				
			end
			
			ChicaTriggered = false
			
			timer.Remove( "fnafgmChicaTrigger" )
			
		end)
		
	end
	
	if CheckBonnieTrigger(ply) and ply:Team()==2 and player_manager.GetPlayerClass(ply)=="player_fnafgmbonnie" and ply:Alive() and avisible[ply] and !timer.Exists( "fnafgmBonnieTrigger" ) and !BonnieTriggered then
		
		BonnieTriggered = true
		
		timer.Remove( "fnafgmPlayerHallway"..userid )
		
		ply:SetPos(Vector( -206, -1172, 65 ))
		ply:SetAngles(Angle( 0, 360, 0 ))
		ply:SetEyeAngles(Angle( 0, 360, 0 ))
		ply:Freeze(true)
		
		local timet=2.5
		if night==1 then
			timet=5.5
		elseif night==2 then
			timet=5
		elseif night==3 then
			timet=4.5
		elseif night==4 then
			timet=4
		elseif night==5 then
			timet=3.5
		elseif night==6 then
			timet=3
		end
		
		timer.Create( "fnafgmBonnieTrigger", timet, 1, function()
			
			if IsValid(ply) then
				ply:Freeze(false)
				ply:Kill()
			end
			
			if door1:GetPos()!=Vector(-164.000000, -1168.000000, 112.000000) then
			
				for k, v in pairs(player.GetAll()) do
					if CheckPlayerSecurityRoom(v) and v:Team()==1 and v:Alive() then
						
						v:ConCommand( "pp_mat_overlay freddys/bonniedeath" )
						ply:PrintMessage(HUD_PRINTTALK, "You hit "..v:GetName())
						v:ConCommand("play "..GAMEMODE.Sound_xscream)
						v:TakeDamage(100, ply )
						v:PrintMessage(HUD_PRINTTALK, GAMEMODE.Strings.base.bonnie.." ("..ply:GetName()..") killed you!")
						MsgC(Color( 255, 255, 85 ), "FNAFGM: '"..ply:GetName().."' entered the security room and kill '"..v:GetName().."'\n")
						
					end
				end
				
			end
			
			BonnieTriggered = false
			
			timer.Remove( "fnafgmBonnieTrigger" )
			
		end)
		
	end
	
	if ( drive.FinishMove( ply, mv ) ) then return true end
	if ( player_manager.RunClass( ply, "FinishMove", mv ) ) then return true end
	
end


concommand.Add( "fnafgm_debug_info", function(ply)
	
	if (!game.IsDedicated() or (IsValid(ply) and fnafgmPlayerCanByPass(ply,"debug"))) then
		ply:PrintMessage(HUD_PRINTCONSOLE, " ")
		ply:PrintMessage(HUD_PRINTCONSOLE, "[-DEBUG INFO-]")
		ply:PrintMessage(HUD_PRINTCONSOLE, " ")
		ply:PrintMessage(HUD_PRINTCONSOLE, " "..GAMEMODE.Name.." Gamemode V"..tostring(GAMEMODE.Version or "error").." by "..GAMEMODE.Author)
		if !GAMEMODE.Official then ply:PrintMessage(HUD_PRINTCONSOLE, " Derived from Five Nights at Freddy's Gamemode V"..tostring(GAMEMODE.OfficialVersion or "error").." by Xperidia") end
		ply:PrintMessage(HUD_PRINTCONSOLE, " FNAFGM Official? "..tostring(GAMEMODE.Official))
		ply:PrintMessage(HUD_PRINTCONSOLE, " ")
		ply:PrintMessage(HUD_PRINTCONSOLE, " Windows? "..tostring(system.IsWindows()))
		ply:PrintMessage(HUD_PRINTCONSOLE, " OSX? "..tostring(system.IsOSX()))
		ply:PrintMessage(HUD_PRINTCONSOLE, " Linux? "..tostring(system.IsLinux()))
		ply:PrintMessage(HUD_PRINTCONSOLE, " ")
		ply:PrintMessage(HUD_PRINTCONSOLE, " SINGLEPLAYER? "..tostring(game.SinglePlayer()))
		ply:PrintMessage(HUD_PRINTCONSOLE, " SERVER? "..tostring(SERVER))
		ply:PrintMessage(HUD_PRINTCONSOLE, " DS? "..tostring(game.IsDedicated()))
		ply:PrintMessage(HUD_PRINTCONSOLE, " ")
		ply:PrintMessage(HUD_PRINTCONSOLE, " MAP: "..game.GetMap())
		ply:PrintMessage(HUD_PRINTCONSOLE, " MAP Version: "..tostring(game.GetMapVersion()))
		ply:PrintMessage(HUD_PRINTCONSOLE, " ")
		ply:PrintMessage(HUD_PRINTCONSOLE, " [-CONVARS-]")
		ply:PrintMessage(HUD_PRINTCONSOLE, "  deathscreendelay "..fnafgm_deathscreendelay:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  deathscreenduration "..fnafgm_deathscreenduration:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  autorespawn "..fnafgm_autorespawn:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  allowflashlight "..fnafgm_allowflashlight:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  respawnenabled "..fnafgm_respawnenabled:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  deathscreenfade "..fnafgm_deathscreenfade:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  deathscreenoverlay "..fnafgm_deathscreenoverlay:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  ragdollinstantremove "..fnafgm_ragdollinstantremove:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  ragdolloverride "..fnafgm_ragdolloverride:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  autocleanupmap "..fnafgm_autocleanupmap:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  preventdoorkill "..fnafgm_preventdoorkill:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  timethink_endlesstime "..fnafgm_timethink_endlesstime:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  timethink_infinitenights "..fnafgm_timethink_infinitenights:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  forceseasonalevent "..fnafgm_forceseasonalevent:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  killextsrplayers "..fnafgm_killextsrplayers:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  playermodel "..fnafgm_playermodel:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  playerskin "..fnafgm_playerskin:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  playerbodygroups "..fnafgm_playerbodygroups:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  playercolor "..fnafgm_playercolor:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  respawndelay "..fnafgm_respawndelay:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  enablebypass "..fnafgm_enablebypass:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  pinionsupport "..fnafgm_pinionsupport:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  fnafview_auto "..fnafgm_fnafview_auto:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  fnafgm_timethink_autostart "..fnafgm_timethink_autostart:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, " ")
		ply:PrintMessage(HUD_PRINTCONSOLE, " [-GAME VARS-]")
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Day started: "..tostring(startday))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Initialized: "..tostring(iniok))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Time: "..tostring(time))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  AM/PM: "..tostring(AMPM))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Night: "..tostring(night))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Night passed: "..tostring(nightpassed))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Map override: "..tostring(mapoverrideok))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Hour time: "..tostring(hourtime))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Game end: "..tostring(gameend))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  SGvsA: "..tostring(SGvsA))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  April Fool: "..tostring(AprilFool))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Halloween: "..tostring(Halloween))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  No Respawn (temp): "..tostring(norespawn))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  '87: "..tostring(b87))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Active: "..tostring(active))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Power: "..tostring(power))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Power drain time: "..tostring(powerdrain))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Power usage: "..tostring(powerusage))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Power Off: "..tostring(poweroff))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Power check time: "..tostring(powerchecktime))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Old power drain time: "..tostring(oldpowerdrain))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Weeks completed: "..tostring(finishedweek))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Foxy will remove: "..tostring(foxyknockdoorpena).."%")
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Tempo start: "..tostring(tempostart))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Over 5: "..tostring(overfive))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  Call stopped: "..tostring(mute))
		ply:PrintMessage(HUD_PRINTCONSOLE, "  FNaF view: "..tostring(fnafview))
		ply:PrintMessage(HUD_PRINTCONSOLE, " ")
	elseif !IsValid(ply) then
		print(" ")
		print("[-DEBUG INFO-]")
		print(" ")
		print(" "..GAMEMODE.Name.." Gamemode V"..tostring(GAMEMODE.Version or "error").." by "..GAMEMODE.Author)
		if !GAMEMODE.Official then print(" Derived from Five Nights at Freddy's Gamemode V"..tostring(GAMEMODE.OfficialVersion or "error").." by Xperidia") end
		print(" FNAFGM Official? "..tostring(GAMEMODE.Official))
		print(" ")
		print(" Windows? "..tostring(system.IsWindows()))
		print(" OSX? "..tostring(system.IsOSX()))
		print(" Linux? "..tostring(system.IsLinux()))
		print(" ")
		print(" SINGLEPLAYER? "..tostring(game.SinglePlayer()))
		print(" SERVER? "..tostring(SERVER))
		print(" DS? "..tostring(game.IsDedicated()))
		print(" ")
		print(" MAP: "..game.GetMap())
		print(" MAP Version: "..tostring(game.GetMapVersion()))
		print(" ")
		print(" [-CONVARS-]")
		print("  deathscreendelay "..fnafgm_deathscreendelay:GetString())
		print("  deathscreenduration "..fnafgm_deathscreenduration:GetString())
		print("  autorespawn "..fnafgm_autorespawn:GetString())
		print("  allowflashlight "..fnafgm_allowflashlight:GetString())
		print("  respawnenabled "..fnafgm_respawnenabled:GetString())
		print("  deathscreenfade "..fnafgm_deathscreenfade:GetString())
		print("  deathscreenoverlay "..fnafgm_deathscreenoverlay:GetString())
		print("  ragdollinstantremove "..fnafgm_ragdollinstantremove:GetString())
		print("  ragdolloverride "..fnafgm_ragdolloverride:GetString())
		print("  autocleanupmap "..fnafgm_autocleanupmap:GetString())
		print("  preventdoorkill "..fnafgm_preventdoorkill:GetString())
		print("  timethink_endlessdays "..fnafgm_timethink_endlesstime:GetString())
		print("  timethink_infinitenights "..fnafgm_timethink_infinitenights:GetString())
		print("  forceseasonalevent "..fnafgm_forceseasonalevent:GetString())
		print("  killextsrplayers "..fnafgm_killextsrplayers:GetString())
		print("  playermodel "..fnafgm_playermodel:GetString())
		print("  playerskin "..fnafgm_playerskin:GetString())
		print("  playerbodygroups "..fnafgm_playerbodygroups:GetString())
		print("  playercolor "..fnafgm_playercolor:GetString())
		print("  respawndelay "..fnafgm_respawndelay:GetString())
		print("  enablebypass "..fnafgm_enablebypass:GetString())
		print("  pinionsupport "..fnafgm_pinionsupport:GetString())
		print("  fnafview_auto "..fnafgm_fnafview_auto:GetString())
		print("  fnafgm_timethink_autostart "..fnafgm_timethink_autostart:GetString())
		print(" ")
		print(" [-GAME VARS-]")
		print("  Day started: "..tostring(startday))
		print("  Initialized: "..tostring(iniok))
		print("  Time: "..tostring(time))
		print("  AM/PM: "..tostring(AMPM))
		print("  Night: "..tostring(night))
		print("  Night passed: "..tostring(nightpassed))
		print("  Map override: "..tostring(mapoverrideok))
		print("  Hour time: "..tostring(hourtime))
		print("  Game end: "..tostring(gameend))
		print("  SGvsA: "..tostring(SGvsA))
		print("  April Fool: "..tostring(AprilFool))
		print("  Halloween: "..tostring(Halloween))
		print("  No Respawn (temp): "..tostring(norespawn))
		print("  '87: "..tostring(b87))
		print("  Active: "..tostring(active))
		print("  Power: "..tostring(power))
		print("  Power drain time: "..tostring(powerdrain))
		print("  Power usage: "..tostring(powerusage))
		print("  Power Off: "..tostring(poweroff))
		print("  Power check time: "..tostring(powerchecktime))
		print("  Old power drain time: "..tostring(oldpowerdrain))
		print("  Weeks completed: "..tostring(finishedweek))
		print("  Foxy will remove: "..tostring(foxyknockdoorpena).."%")
		print("  Tempo start: "..tostring(tempostart))
		print("  Over 5: "..tostring(overfive))
		print("  Call stopped: "..tostring(mute))
		print("  FNaF view: "..tostring(fnafview))
		print(" ")
	end
end)


function fnafgmPlayerCanByPass(ply,what)
	
	if !IsValid(ply) then return end
	
	if fnafgm_enablebypass:GetBool() or what=="debug" then
		if ply:IsAdmin() then
			return true
		elseif fnafgmcheckcreator(ply) then
			return true
		elseif fnafgmcustomcheck(ply,what) then
			return true
		elseif GAMEMODE:CheckDerivCreator(ply) then
			return true
		else
			return false
		end
	else
		return false
	end
end


function GM:PlayerFootstep( ply, vPos, iFoot, strSoundName, fVolume, pFilter )

	if ply:Team()==2 then
		if player_manager.GetPlayerClass(ply)=="player_fnafgmfoxy" and CheckPlayerHallways(ply) and iFoot==0 then
			sound.Play( GAMEMODE.Sound_foxystep0, vPos, fVolume )
		elseif player_manager.GetPlayerClass(ply)=="player_fnafgmfoxy" and CheckPlayerHallways(ply) and iFoot==1 then
			sound.Play( GAMEMODE.Sound_foxystep1, vPos, fVolume )
		end
		return true
	end

end


util.AddNetworkString( "fnafgmCheckUpdate" )
function fnafgmCheckUpdate()
	
	net.Start( "fnafgmCheckUpdate" )
		net.WriteBit( updateavailable )
		net.WriteString( lastversion )
	net.Broadcast()
	
end

util.AddNetworkString( "fnafgmCheckUpdateD" )
function fnafgmCheckUpdateD()
	
	net.Start( "fnafgmCheckUpdateD" )
		net.WriteBit( derivupdateavailable )
		net.WriteString( lastderivversion )
	net.Broadcast()
	
end


function fnafgmCheckForNewVersion(ply,util)
	
	if !GAMEMODE.CustomVersion then
		
		http.Post( "http://xperidia.com/fnafgmversion.php",
		{ version = tostring(GAMEMODE.OfficialVersion or 0) }, 
		function( body, len, headers, code )
			
			if (string.match( body, "true" ) and code==200) then
				
				if IsValid(ply) and util==true then
					ply:PrintMessage(HUD_PRINTCONSOLE, "FNAFGM is up to date!")
				elseif util==true then
					MsgC( Color( 255, 255, 85 ), "FNAFGM is up to date!\n" )
				end
				updateavailable = false
				lastversion = tostring(GAMEMODE.OfficialVersion or "?")
				
			elseif (body and code==200) then
				
				if IsValid(ply) and !ply:IsListenServerHost() then ply:PrintMessage(HUD_PRINTTALK, "FNAFGM: An update is available! V"..string.Right(body, 4)) end
				MsgC( Color( 255, 255, 85 ), "FNAFGM: An update is available! V"..string.Right(body, 4).."\n" )
				updateavailable = true
				lastversion = string.Right(body, 4)
				
			else
				
				if IsValid(ply) then
					ply:PrintMessage(HUD_PRINTCONSOLE, "FNAFGM: An error occurred while checking version (server)")
				else
					MsgC( Color( 255, 255, 85 ), "FNAFGM: An error occurred while checking version (server)\n" )
				end
				
			end
			
			fnafgmCheckUpdate()
			
		end,
		function( error )
			
			if IsValid(ply) then
				ply:PrintMessage(HUD_PRINTCONSOLE, "FNAFGM: An error occurred when checking new version (link)")
			else
				MsgC( Color( 255, 255, 85 ), "FNAFGM: An error occurred when checking new version (link)\n" )
			end
			
		end
	
		);
		
	end
	
	if !GAMEMODE.Official and GAMEMODE.CustomVersionChecker!="" then
		
		http.Post( GAMEMODE.CustomVersionChecker,
		{ version = tostring(GAMEMODE.Version or 0) }, 
		function( body, len, headers, code )
			
			if (string.match( body, "true" ) and code==200) then
				
				if IsValid(ply) and util==true then
					ply:PrintMessage(HUD_PRINTCONSOLE, GAMEMODE.ShortName.." is up to date!")
				elseif util==true then
					MsgC( Color( 255, 255, 85 ), GAMEMODE.ShortName.." is up to date!\n" )
				end
				derivupdateavailable = false
				lastderivversion = tostring(GAMEMODE.Version or "?")
				
			elseif (body and code==200) then
				
				if IsValid(ply) and !ply:IsListenServerHost() then ply:PrintMessage(HUD_PRINTTALK, GAMEMODE.ShortName..": An update is available! V"..string.Right(body, 4)) end
				MsgC( Color( 255, 255, 85 ), GAMEMODE.ShortName..": An update is available! V"..string.Right(body, 4).."\n" )
				derivupdateavailable = true
				lastderivversion = string.Right(body, 4)
				
			else
				
				if IsValid(ply) then
					ply:PrintMessage(HUD_PRINTCONSOLE, GAMEMODE.ShortName..": An error occurred while checking version (server)")
				else
					MsgC( Color( 255, 255, 85 ), GAMEMODE.ShortName..": An error occurred while checking version (server)\n" )
				end
				
			end
			
			fnafgmCheckUpdateD()
			
		end,
		function( error )
			
			if IsValid(ply) then
				ply:PrintMessage(HUD_PRINTCONSOLE, GAMEMODE.ShortName..": An error when checking new version (link)")
			else
				MsgC( Color( 255, 255, 85 ), GAMEMODE.ShortName..": An error when checking new version (link)\n" )
			end
			
		end
	
		);
		
	end
	
end


concommand.Add("fnafgm_version", function(ply)
	if IsValid(ply) then
		ply:PrintMessage(HUD_PRINTCONSOLE, GAMEMODE.Name.." Gamemode V"..tostring(GAMEMODE.Version or "error").." by "..GAMEMODE.Author)
		if !GAMEMODE.Official then ply:PrintMessage(HUD_PRINTCONSOLE, "Derived from Five Nights at Freddy's Gamemode V"..tostring(GAMEMODE.OfficialVersion or "error").." by Xperidia") end
		fnafgmCheckForNewVersion(ply,true)
	else
		print(GAMEMODE.Name.." Gamemode V"..tostring(GAMEMODE.Version or "error").." by "..GAMEMODE.Author)
		if !GAMEMODE.Official then print("Derived from Five Nights at Freddy's Gamemode V"..tostring(GAMEMODE.OfficialVersion or "error").." by Xperidia") end
		fnafgmCheckForNewVersion(nil,true)
	end
end) 


function fnafgmSetCamera(id)
	local camlink = ents.FindByName( "camlink"..id )[1]
	local cam = ents.FindByName( "Cam"..id )[1]
	if ( IsValid(camlink) and IsValid(cam) ) then
		camlink:Fire( "SetCamera","Cam"..id,0 )
		cam:Fire( "SetOnAndTurnOthersOff",true,0 )
	elseif IsValid(camlink) and IsValid(ents.FindByName( "CamOff" )[1]) and id==11 then
		camlink:Fire( "SetCamera","CamOff",0 )
		ents.FindByName( "CamOff" )[1]:Fire( "SetOnAndTurnOthersOff",true,0 )
	end
end

function fnafgmMusicBox()
	local musicbox = ents.FindByName( "rotbutton" )[1]
	if ( IsValid(musicbox) ) then
		musicbox:Fire( "use" )
	end
end


function fnafgmSetView(ply,id)
	
	local cam = ents.FindByName( "Cam"..id )[1]
	local fnafgmCam = ents.FindByName( "fnafgm_Cam"..id )[1]
	
	if ( IsValid(fnafgmCam) and IsValid(ply) ) then
		ply:SetViewEntity( fnafgmCam )
	elseif ( IsValid(cam) and IsValid(ply) ) then
		cam:Fire( "SetOn" )
		ply:SetViewEntity( cam )
	elseif IsValid(ply) and id==0 then
		ply:SetViewEntity( ply )
	elseif IsValid(ply) and id==11 then
		local cam = ents.FindByName( "fnafgm_CamOff" )[1]
		if IsValid(cam) then
			ply:SetViewEntity( cam )
		end
	end
	
end
net.Receive( "fnafgmSetView",function(bits,ply)
	local id = net.ReadFloat()
	if (!id) then return end
	fnafgmSetView(ply,id)
end )


function fnafgmMuteCall()
	local call = ents.FindByName( "Callman" )[1]
	if ( IsValid(call) ) then
		call:Fire( "use" )
	end
end
net.Receive( "fnafgmMuteCall",function(bits,ply)
	fnafgmMuteCall()
end )


function fnafgmSafeZone(ply)
	
	if !IsValid(ply) then return end
	
	if !usingsafedoor[ply] then
			
		ply:SetPos( Vector( -46, -450, 0 ) )
		
		if IsValid(SafeZoneCam) then
			ply:SetViewEntity( SafeZoneCam )
		end
		
		ply:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_fnaf2deathcam )
		
		usingsafedoor[ply]=true
		
	elseif usingsafedoor[ply] then
		
		ply:SetPos( GAMEMODE.FNaFView[game.GetMap()][1] )
		ply:SetEyeAngles( GAMEMODE.FNaFView[game.GetMap()][2] )
		
		ply:SetViewEntity( ply )
		
		ply:ConCommand( "pp_mat_overlay ''" )
		
		usingsafedoor[ply]=false
		
	end
	
end
net.Receive( "fnafgmSafeZone",function(bits,ply)
	fnafgmSafeZone(ply)
end )


function fnafgmShutLights()
	
	if game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent" then
		
			if light1 and light1:IsValid() and light1use then
				light1use = !light1use
				light1:Fire("use")
			end
			
			if light2 and light2:IsValid() and light2use then
				light2use = !light2use
				light2:Fire("use")
			end
		
		end
	
end
net.Receive( "fnafgmShutLights",function(bits,ply)
	fnafgmShutLights()
end )


concommand.Add("fnafgm_debug_start", function(ply)
	
	if (IsValid(ply) and fnafgmPlayerCanByPass(ply,"debug")) or !IsValid(ply) then
		fnafgmUse(ply, nil, true)
	end
	
end)


concommand.Add("fnafgm_debug_reset", function(ply)
	
	if (IsValid(ply) and fnafgmPlayerCanByPass(ply,"debug")) or !IsValid(ply) then
		fnafgmResetGame()
		fnafgmMapOverrides()
		fnafgmVarsUpdate()
	end
	
end)


concommand.Add("fnafgm_debug_refreshbypass", function(ply)
	
	if (IsValid(ply) and fnafgmPlayerCanByPass(ply,"debug")) or !IsValid(ply) then
		fnafgmrefreshbypass()
	end
	
end)


concommand.Add("fnafgm_debug_restart", function(ply)
	
	if (IsValid(ply) and fnafgmPlayerCanByPass(ply,"debug")) or !IsValid(ply) then
		
		if (iniok and mapoverrideok and startday and active) then
			
			norespawn=true
			
			for k, v in pairs(player.GetAll()) do
				if (v:Team()==1 or v:Team()==2) and v:Alive() then
					v:KillSilent()
				end
			end
			
			fnafgmRestartNight()
			
		end
		
	end
	
end)


function GM:PlayerSwitchFlashlight(ply, on)
	
	if !on then
		
		return true
		
	end
	
	if ( ( ply:Team()==1 and fnafgm_allowflashlight:GetBool() ) or fnafgmPlayerCanByPass(ply,"flashlight") ) then
		
		return true
		
	end
	
	if (game.GetMap()=="fnaf2" and !poweroff) then
		
		return true
		
	end
	
	if (game.GetMap()=="fnaf2" and poweroff) then
	
		ply:ConCommand("play "..GAMEMODE.Sound_lighterror)
		
	end
	
	return false
	
end





function GM:PlayerSay( ply, text, teamonly )
	
	comm = string.lower( text ) -- Make the chat message entirely lowercase
	
	if ( comm == "!start" and ( game.GetMap()=="fnaf_freddypizzaevents" or fnafgmPlayerCanByPass(ply,"debug") ) ) then
		fnafgmUse(ply, nil, true)
	elseif ( comm == "/start" and ( game.GetMap()=="fnaf_freddypizzaevents" or fnafgmPlayerCanByPass(ply,"debug")) ) then
		fnafgmUse(ply, nil, true)
		return ""
	elseif ( comm == "!"..string.lower(GAMEMODE.ShortName) ) then
		ply:SendLua([[fnafgmMenu()]])
	elseif ( comm == "/"..string.lower(GAMEMODE.ShortName) ) then
		ply:SendLua([[fnafgmMenu()]])
		return ""
	elseif ( ( comm == "!stop" or comm == "!restart" ) and fnafgmPlayerCanByPass(ply,"debug") and iniok and mapoverrideok and startday and active ) then
		
		norespawn=true
		
		for k, v in pairs(player.GetAll()) do
			if (v:Team()==1 or v:Team()==2) and v:Alive() then
				v:KillSilent()
			end
		end
		
		fnafgmRestartNight()
		
	elseif ( ( comm == "/stop" or comm == "/restart" ) and fnafgmPlayerCanByPass(ply,"debug") and iniok and mapoverrideok and startday and active ) then
		
		norespawn=true
		
		for k, v in pairs(player.GetAll()) do
			if (v:Team()==1 or v:Team()==2) and v:Alive() then
				v:KillSilent()
			end
		end
		
		fnafgmRestartNight()
		
		return ""
	end
	
	return text

end


function GM:Think()
	
	if iniok and mapoverrideok and startday and active and (game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent") then
		
		powerusage = GAMEMODE.Power_Usage_Base
		
		if poweroff then
			
			powerusage = 0
			
			if door1:GetPos()==Vector(-164.000000, -1168.000000, 112.000000) then -- Door 1 use
				
				door1btn:Fire("use")
				door1btn:Fire("lock", "", 0.75)
				if IsValid(door1light) then
					door1light:Remove()
				end
				
			end
			
			
			if door2:GetPos()==Vector(4.000000, -1168.000000, 112.000000) then -- Door 2 use
				
				door2btn:Fire("use")
				door2btn:Fire("lock", "", 0.75)
				if IsValid(door2light) then
					door2light:Remove()
				end
				
			end
			
		else
		
			local tabactualuse = false --Calc tab usage
			
			for k, v in pairs(team.GetPlayers(1)) do
				
				if tabused[v] and tabused[v]==true then
						
					tabactualuse = true
					
				end
				
			end
			
			if tabactualuse then -- Tab use
				
				powerusage = powerusage+1
				
			end
			
			
			if door1:GetPos()==Vector(-164.000000, -1168.000000, 112.000000) then -- Door 1 use
				
				powerusage = powerusage+1
				
			end
			
			
			if door2:GetPos()==Vector(4.000000, -1168.000000, 112.000000) then -- Door 2 use
				
				powerusage = powerusage+1
				
			end
			
			
			if light1use or light2use then -- Lights use
				
				powerusage = powerusage+1
				
			end
			
			
			if AprilFool or fnafgm_forceseasonalevent:GetInt()==2 then -- Troll use
				
				powerusage = powerusage+5
				
			end
			
			
		end
		
		if powerusage==0 then
			
			powerdrain = 0
			
		else
			
			powerdrain = GAMEMODE.Power_Drain_Time
		
			for i=1, powerusage-1 do
				powerdrain = powerdrain/2
			end
			
			if powerchecktime==nil and oldpowerdrain==nil and !poweroff then
				
				powerchecktime = CurTime()+powerdrain
				oldpowerdrain = powerdrain
				
			elseif powerchecktime!=nil and oldpowerdrain!=nil and !poweroff then
				
				local calcchangepower = oldpowerdrain-powerdrain
				
				if powerchecktime<=CurTime()+calcchangepower then
					
					powerchecktime=nil
					oldpowerdrain=nil
					power = power-1
					ents.FindByName( "Powerlvl" )[1]:Fire("SetValue", 100)
				
				end
				
			end
		
		end
		
		if power<=0 and !poweroff then
			
			power=0
			
			ents.FindByName( "Powerlvl" )[1]:Fire("SetValue", 1)
			ents.FindByName( "doorbeam1" )[1]:Fire("LightOff")
			ents.FindByName( "doorbeam2" )[1]:Fire("LightOff")
			
			if game.GetMap()=="freddys" then
				
				for k, v in pairs(ents.FindByClass( "light" )) do
					v:Fire("TurnOff")
				end
				for k, v in pairs(ents.FindByClass( "light_spot" )) do
					v:Fire("TurnOff")
				end
				for k, v in pairs(ents.FindByClass( "env_projectedtexture" )) do
					v:Fire("TurnOff")
				end
				
				local foxy = ents.FindByName( "FoxyTime" )[1]
				if IsValid(foxy) then foxy:Fire("Kill") end
				foxy = ents.FindByName( "foxytest" )[1]
				if IsValid(foxy) then foxy:Fire("Kill") end
				foxy = ents.FindByName( "FoxyKilledYou" )[1]
				if IsValid(foxy) then foxy:Fire("Kill") end
				foxy = ents.FindByName( "foxydeath" )[1]
				if IsValid(foxy) then foxy:Fire("Kill") end
				local chbo = ents.FindByName( "EventTimer" )[1]
				if IsValid(chbo) then chbo:Fire("Kill") end
				local fred = ents.FindByName( "EventTimer2" )[1]
				if IsValid(fred) then fred:Fire("Kill") end
				ents.FindByName( "FreddyOfficeRelay" )[1]:Fire("Trigger")
				ents.FindByName( "ChicaOfficeRelay" )[1]:Fire("Trigger")
				ents.FindByName( "BonnieOfficeRelay" )[1]:Fire("Trigger")
				
				timer.Create( "fnafgmPowerOff1", 5, 1, function()
					ents.FindByName( "FreddyOffice" )[1]:SetPos(Vector( -193, -1115, 65 ))
					ents.FindByName( "FreddyOffice" )[1]:SetAngles(Angle( 0, 0, 35 ))
					ents.FindByName( "FreddyOffice" )[1]:Fire("Enable")
					ents.FindByName( "FreddyOffice" )[1]:Fire("EnableCollision")
					ents.FindByName( "BonnieOffice" )[1]:SetPos(Vector( 43, -1171, 65 ))
					ents.FindByName( "BonnieOffice" )[1]:SetAngles(Angle( 0, 180, 0 ))
					ents.FindByName( "BonnieOffice" )[1]:Fire("EnableCollision")
					for k, v in pairs(team.GetPlayers(1)) do
						v:ConCommand("play ".."freddys/muffledtune.wav")
						if v:Alive() and !CheckPlayerSecurityRoom(v) then
							local spawn = GAMEMODE:PlayerSelectSpawn( v ):GetPos()
							v:SetPos( spawn )
						end
					end
					timer.Remove("fnafgmPowerOff1")
				end)
				
				timer.Create( "fnafgmPowerOff2", 24.58, 1, function()
					for k, v in pairs(team.GetPlayers(1)) do
						v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 65536 )
					end
					timer.Remove("fnafgmPowerOff2")
				end)
				
				timer.Create( "fnafgmPowerOff3", 29.58, 1, function()
					ents.FindByName( "FreddyDeath" )[1]:Fire("Trigger")
					ents.FindByName( "freddytest" )[1]:Fire("Trigger")
					for k, v in pairs(team.GetPlayers(1)) do
						if v:Alive() then
							v:KillSilent()
						end
					end
					timer.Remove("fnafgmPowerOff3")
				end)
				
			end
			
			poweroff = true
			norespawn = true
			MsgC( Color( 255, 255, 85 ), "FNAFGM: The power is gone :)\n" )
		end
		
		fnafgmPowerUpdate()
		
		
		
	elseif iniok and mapoverrideok and startday and active and (game.GetMap()=="fnaf2") then
		
		
		powerusage = 0
		
		if !poweroff then
			
				
			if light1use or light2use or light3use then -- Lights use
				
				powerusage = powerusage + 1
				
			end
			
			for k, v in pairs(team.GetPlayers(1)) do
				
				if v:FlashlightIsOn() then
						
					powerusage = powerusage + 1
					
				end
				
			end
			
			
		end
		
		if powerusage==0 or !powerchecktime then
			
			powerchecktime = CurTime()+1
			
		else
			
			if powerchecktime<=CurTime() then
				
				powerchecktime = CurTime()+1
				power = power-1
				
			end
		
		end
		
		if power==0 and !poweroff then
			
			poweroff = true
			
			for k, v in pairs(team.GetPlayers(1)) do
				
				if v:FlashlightIsOn() and !fnafgmPlayerCanByPass(v,"flashlight") then
						
					v:Flashlight( false )
					
					v:ConCommand("play "..GAMEMODE.Sound_lighterror)
					
				end
				
			end
			
			MsgC( Color( 255, 255, 85 ), "FNAFGM: The battery is dead\n" )
			
		end
		
		fnafgmPowerUpdate()
		
	elseif iniok and mapoverrideok and startday and active and (game.GetMap()=="fnap_scc") then
		
		powerusage = GAMEMODE.Power_Usage_Base
		
		if poweroff then
			
			powerusage = 0
			
		else
		
			local tabactualuse = false --Calc tab usage
			
			for k, v in pairs(team.GetPlayers(1)) do
				
				if tabused[v] and tabused[v]==true then
						
					tabactualuse = true
					
				end
				
			end
			
			if tabactualuse then -- Tab use
				
				powerusage = powerusage+1
				
			end
			
			
			if door1:GetPos()==Vector(-432.010010, -376.000000, 79.879997) then -- Door 1 use
				
				powerusage = powerusage+1
				
			end
			
			
			if door2:GetPos()==Vector(-432.010010, -120.000000, 79.910004) then -- Door 2 use
				
				powerusage = powerusage+1
				
			end
			
			
			if light1use or light2use then -- Lights use
				
				powerusage = powerusage+1
				
			end
			
			
			if AprilFool or fnafgm_forceseasonalevent:GetInt()==2 then -- Troll use
				
				powerusage = powerusage+5
				
			end
			
			
		end
		
		if powerusage==0 then
			
			powerdrain = 0
			
		else
			
			powerdrain = GAMEMODE.Power_Drain_Time
		
			for i=1, powerusage-1 do
				powerdrain = powerdrain/2
			end
			
			if powerchecktime==nil and oldpowerdrain==nil and !poweroff then
				
				powerchecktime = CurTime()+powerdrain
				oldpowerdrain = powerdrain
				
			elseif powerchecktime!=nil and oldpowerdrain!=nil and !poweroff then
				
				local calcchangepower = oldpowerdrain-powerdrain
				
				if powerchecktime<=CurTime()+calcchangepower then
					
					powerchecktime=nil
					oldpowerdrain=nil
					power = power-1
					fnafgmDigits(power)
				
				end
				
			end
		
		end
		
		if power==0 and !poweroff then
			ents.FindByName( "NoMorePower" )[1]:Fire("use")
			for k, v in pairs(team.GetPlayers(1)) do
				local spawn = GAMEMODE:PlayerSelectSpawn( v ):GetPos()
				v:SetPos( spawn )
			end
			poweroff = true
			if !game.SinglePlayer() then norespawn = true end
			MsgC( Color( 255, 255, 85 ), "FNAFGM: The power is gone :)\n" )
		end
		
		fnafgmPowerUpdate()
		
	end
	
	if !game.SinglePlayer() and !checkRestartNight and iniok and mapoverrideok and startday and active then
		
		checkRestartNight=true
		
		local alive = false
		
		for k, v in pairs(player.GetAll()) do
			if v:Alive() and v:Team()==1 then
				alive = true
			end
		end

		if !alive then
			
			norespawn=true
			
			PrintMessage(HUD_PRINTTALK, "All the "..team.GetName(1).." are dead!")
			PrintMessage(HUD_PRINTTALK, "The "..GAMEMODE.Strings.base.night.." will reset in "..fnafgm_deathscreendelay:GetInt()+fnafgm_deathscreenduration:GetInt()+fnafgm_respawndelay:GetInt().."s...")
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Everybody is dead, the night will reset\n" )
			
			timer.Remove("fnafgmTimeThink")
			timer.Remove("fnafgmPowerOff1")
			timer.Remove("fnafgmPowerOff2")
			timer.Remove("fnafgmPowerOff3")
			
			timer.Create( "fnafgmRestartNight", fnafgm_deathscreendelay:GetInt()+fnafgm_deathscreenduration:GetInt()+fnafgm_respawndelay:GetInt()+0.1, 1, function()
				
				for k, v in pairs(player.GetAll()) do
					if (v:Team()==1 or v:Team()==2) and v:Alive() then
						v:KillSilent()
					end
				end
				
				fnafgmRestartNight()
				
				timer.Remove( "fnafgmRestartNight" )
				
			end)
			
		else
			checkRestartNight=false
		end
		
	end
	
	
end


function fnafgmDigits(n)
	
	if !n then return end
	
	if n>99 then
		n=99
	elseif n<0 then
		n=0
	end
	
	left = math.floor(n/10)
	right = math.fmod(n,10)
	
	if left==0 and n!=0 then
		ents.FindByName( "Timer_#1_SegmentE1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentF1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentD1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentC1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentA1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB1" )[1]:Fire("Enable")
	elseif left==1 then
		ents.FindByName( "Timer_#1_SegmentE1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentF1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentD1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentC1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentA1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentB1" )[1]:Fire("Enable")
	elseif left==2 then
		ents.FindByName( "Timer_#1_SegmentE1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentG1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentF1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentD1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentC1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentA1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB1" )[1]:Fire("Enable")
	elseif left==3 then
		ents.FindByName( "Timer_#1_SegmentE1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentF1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentD1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentC1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentA1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB1" )[1]:Fire("Enable")
	elseif left==4 then
		ents.FindByName( "Timer_#1_SegmentE1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentF1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentD1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentC1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentA1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentB1" )[1]:Fire("Enable")
	elseif left==5 then
		ents.FindByName( "Timer_#1_SegmentE1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentF1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentD1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentC1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentA1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB1" )[1]:Fire("Disable")
	elseif left==6 then
		ents.FindByName( "Timer_#1_SegmentE1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentF1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentD1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentC1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentA1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB1" )[1]:Fire("Disable")
	elseif left==7 then
		ents.FindByName( "Timer_#1_SegmentE1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentF1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentD1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentC1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentA1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB1" )[1]:Fire("Enable")
	elseif left==8 then
		ents.FindByName( "Timer_#1_SegmentE1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentF1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentD1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentC1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentA1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB1" )[1]:Fire("Enable")
	elseif left==9 then
		ents.FindByName( "Timer_#1_SegmentE1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentF1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentD1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentC1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentA1" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB1" )[1]:Fire("Enable")
	else
		ents.FindByName( "Timer_#1_SegmentE1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentG1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentF1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentD1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentC1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentA1" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentB1" )[1]:Fire("Disable")
	end
	if right==0 and n!=0 then
		ents.FindByName( "Timer_#1_SegmentE" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentF" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentD" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentC" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentA" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB" )[1]:Fire("Enable")
	elseif right==1 then
		ents.FindByName( "Timer_#1_SegmentE" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentF" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentD" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentC" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentA" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentB" )[1]:Fire("Enable")
	elseif right==2 then
		ents.FindByName( "Timer_#1_SegmentE" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentG" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentF" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentD" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentC" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentA" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB" )[1]:Fire("Enable")
	elseif right==3 then
		ents.FindByName( "Timer_#1_SegmentE" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentF" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentD" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentC" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentA" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB" )[1]:Fire("Enable")
	elseif right==4 then
		ents.FindByName( "Timer_#1_SegmentE" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentF" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentD" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentC" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentA" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentB" )[1]:Fire("Enable")
	elseif right==5 then
		ents.FindByName( "Timer_#1_SegmentE" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentF" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentD" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentC" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentA" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB" )[1]:Fire("Disable")
	elseif right==6 then
		ents.FindByName( "Timer_#1_SegmentE" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentF" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentD" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentC" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentA" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB" )[1]:Fire("Disable")
	elseif right==7 then
		ents.FindByName( "Timer_#1_SegmentE" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentF" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentD" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentC" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentA" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB" )[1]:Fire("Enable")
	elseif right==8 then
		ents.FindByName( "Timer_#1_SegmentE" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentF" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentD" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentC" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentA" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB" )[1]:Fire("Enable")
	elseif right==9 then
		ents.FindByName( "Timer_#1_SegmentE" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentG" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentF" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentD" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentC" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentA" )[1]:Fire("Enable")
		ents.FindByName( "Timer_#1_SegmentB" )[1]:Fire("Enable")
	else
		ents.FindByName( "Timer_#1_SegmentE" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentG" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentF" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentD" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentC" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentA" )[1]:Fire("Disable")
		ents.FindByName( "Timer_#1_SegmentB" )[1]:Fire("Disable")
	end
end


util.AddNetworkString( "fnafgmPowerUpdate" )
function fnafgmPowerUpdate()
	
	net.Start( "fnafgmPowerUpdate" )
		net.WriteInt( power, 20 )
		net.WriteInt( powerusage, 6 )
		net.WriteBit( poweroff )
		net.WriteInt( powertot, 16 )
	net.Broadcast()
	
end

util.AddNetworkString( "fnafgmTabUsed" )
net.Receive( "fnafgmTabUsed", function( len, ply )
	
	tabused[ply] = tobool(net.ReadBit())
	
end)

util.AddNetworkString( "fnafgmfnafViewActive" )
net.Receive( "fnafgmfnafViewActive", function( len, ply )
	
	ply.fnafviewactive = tobool(net.ReadBit())
	
end)


function GM:PlayerShouldTaunt( ply, actid )

	if fnafgmPlayerCanByPass(ply,"act") then
		return true
	end
	
	ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! :)")
	return false

end


concommand.Add( "autoteam", function( ply )
	if team.NumPlayers(2)>=4 then
		hook.Call( "PlayerRequestTeam", GAMEMODE, ply, 1 )
	end
	local ID = math.random( 1, 2 )
	if ply:Team() == 1 then
		hook.Call( "PlayerRequestTeam", GAMEMODE, ply, 2 )
	elseif ply:Team() == 2 then
		hook.Call( "PlayerRequestTeam", GAMEMODE, ply, 1 )
	else
		hook.Call( "PlayerRequestTeam", GAMEMODE, ply, math.random( 1, 2 ) )
	end
end )


function GM:PlayerCanHearPlayersVoice( pListener, pTalker )

	if pListener:Team()==TEAM_SPECTATOR then
		return true, false
	elseif pListener:Team()==2 and pTalker:Team()==2 then
		return true, false
	elseif pListener:Team() == pTalker:Team() and pTalker:Alive() then
		return true, false
	elseif pListener:Team() == pTalker:Team() and !pListener:Alive() and !pTalker:Alive() then
		return true, false
	elseif pListener:Team()==2 and pTalker:Team()!=TEAM_SPECTATOR then
		return true, true
	end

	return false, false

end


function GM:ShowHelp( ply )

	ply:SendLua("fnafgmMenu()")
	
end


function GM:ShowSpare1( ply )
	
	if !ply:Alive() or !startday then return end
	
	if !ply.TauntCooldown then
		ply.TauntCooldown = 0
	end
	
	if ply.TauntCooldown<=CurTime() then
	
		if player_manager.GetPlayerClass(ply)=="player_fnafgmfoxy" then
			sound.Play( GAMEMODE.Sound_Foxy, ply:GetPos() )
		elseif player_manager.GetPlayerClass(ply)=="player_fnafgmfreddy" then
			sound.Play( table.Random(GAMEMODE.Sound_Freddy), ply:GetPos() )
		elseif player_manager.GetPlayerClass(ply)=="player_fnafgmchica" then
			sound.Play( table.Random(GAMEMODE.Sound_ChicaBonnie), ply:GetPos() )
		elseif player_manager.GetPlayerClass(ply)=="player_fnafgmbonnie" then
			sound.Play( table.Random(GAMEMODE.Sound_ChicaBonnie), ply:GetPos() )
		elseif player_manager.GetPlayerClass(ply)=="player_fnafgmgoldenfreddy" then
			sound.Play( GAMEMODE.Sound_GoldenFoxy, ply:GetPos() )
		end
		
		ply.TauntCooldown = CurTime() + 20
	
	end
	
end


function GM:ShutDown()
	for k, v in pairs(player.GetAll()) do
		if v:GetViewEntity()!=v then
			v:SetViewEntity(v)
		end
	end
end
