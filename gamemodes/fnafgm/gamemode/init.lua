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
AddCSLuaFile( "cl_secret.lua" )

include( 'shared.lua' )

if file.Exists( "models/splinks/fnaf/freddy/player_freddy.mdl", "GAME" ) or GAMEMODE.Vars.SGvsA then
	resource.AddWorkshop( "363563548" )
end
if game.GetMap()=="fnaf2" then resource.AddWorkshop( "382155331" ) end
if game.GetMap()=="fnaf_freddypizzaevents" then
	resource.AddWorkshop( "407563661" )
	resource.AddWorkshop( "423349175" )
	resource.AddWorkshop( "382393981" )
end
if player_manager.AllValidModels()["Guard_01"] then -- Use http://steamcommunity.com/sharedfiles/filedetails/?id=169011381 if available
	resource.AddWorkshop( "169011381" )
end
if game.GetMap()=="fnaf4versus" and player_manager.AllValidModels()["FNAF4 - Nightmare Freddy"] then -- Use http://steamcommunity.com/sharedfiles/filedetails/?id=542539281 if available
	resource.AddWorkshop( "542539281" )
end

--
-- Make BaseClass available
--
DEFINE_BASECLASS( "gamemode_base" )


util.AddNetworkString( "fnafgmVarsUpdate" )
util.AddNetworkString( "fnafgmShowCheck" )
util.AddNetworkString( "fnafgmSetView" )
util.AddNetworkString( "fnafgmMuteCall" )
util.AddNetworkString( "fnafgmSafeZone" )
util.AddNetworkString( "fnafgmShutLights" )
util.AddNetworkString( "fnafgmUseLight" )
util.AddNetworkString( "fnafgmMapSelect" )
util.AddNetworkString( "fnafgmChangeMap" )
util.AddNetworkString( "fnafgmDS" )
util.AddNetworkString( "fnafgmNotif" )
util.AddNetworkString( "fnafgmSecurityTablet" )
util.AddNetworkString( "fnafgmCloseTablet" )
util.AddNetworkString( "fnafgmCallIntro" )
util.AddNetworkString( "fnafgmAnimatronicsController" )
util.AddNetworkString( "fnafgmAnimatronicsList" )
util.AddNetworkString( "fnafgmCheckUpdate" )
util.AddNetworkString( "fnafgmCheckUpdateD" )
util.AddNetworkString( "fnafgmPowerUpdate" )
util.AddNetworkString( "fnafgmTabUsed" )
util.AddNetworkString( "fnafgmfnafViewActive" )
util.AddNetworkString( "fnafgmSetAnimatronicPos" )
util.AddNetworkString( "fnafgmAnimatronicTaunt" )
util.AddNetworkString( "fnafgmAnimatronicTauntSnd" )


concommand.Add("fnafgm_resetprogress", function( ply )
	GAMEMODE:ResetProgress(ply)
end)
function GM:ResetProgress(ply)
	
	if !ply:IsListenServerHost() and !GAMEMODE.Vars.SGvsA then
		
		ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! (Not the host)")
		
		net.Start( "fnafgmNotif" )
			net.WriteString( "Nope, you can't do that! (Not the host)" )
			net.WriteInt(1,3)
			net.WriteFloat(5)
			net.WriteBit(true)
		net.Send(ply)
		
		return
	end
	
	if !file.IsDir("fnafgm/progress", "DATA") then
		file.CreateDir( "fnafgm/progress" )
	end
	
	local tab = {}
	
	tab.Night = 0
	
	file.Write( "fnafgm/progress/" .. game.GetMap() .. ".txt", util.TableToJSON( tab ) )
	
	MsgC( Color( 255, 255, 85 ), "FNAFGM: Progress erased!\n" )
	
	net.Start( "fnafgmNotif" )
		net.WriteString( "Progress erased!" )
		net.WriteInt(4,3)
		net.WriteFloat(5)
		net.WriteBit(true)
	net.Send(ply)
	
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
	
	if pl:Team()==1 or pl:Team()==2 then
		
		player_manager.SetPlayerClass( pl, table.Random(team.GetClass(pl:Team())) )
		
	end
	
	BaseClass.PlayerSpawn( self, pl )
	
	
	if fnafgmPlayerCanByPass(pl,"run") then 
		pl:SetRunSpeed(400)
	end
	
	if fnafgmPlayerCanByPass(pl,"jump") then 
		pl:SetJumpPower(200)
	end
	
	if pl:Team()==2 then
		pl:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_animatronicsvision )
	elseif pl:Team()!=TEAM_UNASSIGNED then
		pl:ConCommand( "pp_mat_overlay ''" )
	end
	
	if pl:Team()!=TEAM_UNASSIGNED then
		if game.GetMap()=="gm_construct" or game.GetMap()=="gm_flatgrass" then
			GAMEMODE:MapSelect(pl)
		else
			pl:SendLua([[fnafgmWarn()]])
		end
	end
	
	if GAMEMODE.Vars.b87 then
		pl:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_goldenfreddy )
		pl:ConCommand("play "..GAMEMODE.Sound_xscream2)
		GAMEMODE.Vars.norespawn = true
		local userid = pl:UserID()
		timer.Create( "fnafgm87"..userid, 20, 1, function()
			if IsValid(pl) and (!pl:IsListenServerHost() and !fnafgmPlayerCanByPass(ply,"debug")) then
				pl:Kick( "'87" )
			end
			timer.Remove("fnafgm87"..userid)
		end)
	end
	
	if ( pl:Team()==1 or pl:Team()==2 ) then
		pl:SetRenderMode(RENDERMODE_NORMAL)
		pl:SetMoveType(MOVETYPE_WALK)
	elseif ( pl:Team()==TEAM_SPECTATOR ) then
		pl:SetMoveType(MOVETYPE_NOCLIP)
	end
	
	if ( game.SinglePlayer() and !GAMEMODE.Vars.nightpassed and !GAMEMODE.Vars.gameend and GAMEMODE.Vars.iniok and GAMEMODE.Vars.startday ) then
		timer.Create( "fnafgmTempoRestart", 0.001, 1, function()
			fnafgmRestartNight()
			timer.Remove( "fnafgmTempoRestart" )
		end)
	end
	
	if fnafgm_timethink_autostart:GetBool() and pl:Team()==1 then
		timer.Create( "fnafgmStart", 0.002, 1, function()
			fnafgmUse(pl, nil, true)
			timer.Remove( "fnafgmStart" )
		end)
	end
	
	local userid = pl:UserID()
	
	if !game.SinglePlayer() and GAMEMODE.Vars.startday and !GAMEMODE.Vars.tempostart and !GAMEMODE.Vars.nightpassed and !GAMEMODE.Vars.gameend and pl:Team()==1 then 
		if GAMEMODE.FNaFView[game.GetMap()] then
			if GAMEMODE.FNaFView[game.GetMap()][1] then pl:SetPos( GAMEMODE.FNaFView[game.GetMap()][1] ) end
			if GAMEMODE.FNaFView[game.GetMap()][2] then pl:SetEyeAngles( GAMEMODE.FNaFView[game.GetMap()][2] ) end
			timer.Create( "fnafgmTempoFNaFView"..userid, 0.1, 1, function()
				if IsValid(pl) and pl:Team()==1 and pl:GetInfoNum("fnafgm_cl_autofnafview", 1)==1 then
					GAMEMODE:GoFNaFView(pl)
					if GAMEMODE.FNaFView[game.GetMap()][1] then pl:SetPos( GAMEMODE.FNaFView[game.GetMap()][1] ) end
					if GAMEMODE.FNaFView[game.GetMap()][2] then pl:SetEyeAngles( GAMEMODE.FNaFView[game.GetMap()][2] ) end
				end
				timer.Remove( "fnafgmTempoFNaFView"..userid )
			end)
		end
	end
	
	if pl:Team()==2 then 
		timer.Create( "fnafgmTempoAC"..userid, 0.1, 1, function()
			if IsValid(pl) and pl:Team()==2 then
				net.Start( "fnafgmAnimatronicsController" )
				net.Send(pl)
			end
			timer.Remove( "fnafgmTempoAC"..userid )
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
	
	fnafgmCheckForNewVersion(ply,false)
	
	if !ply:IsBot() then
		net.Start( "fnafgmCallIntro" )
		net.Send(ply)
		if game.GetMap()=="gm_construct" or game.GetMap()=="gm_flatgrass" then
			GAMEMODE:MapSelect(ply)
		end
	end
	
	if GAMEMODE.Vars.SGvsA and !ply:IsBot() then
		ply:SetTeam( TEAM_UNASSIGNED )
		ply:ConCommand( "gm_showteam" )
	elseif !GAMEMODE.Vars.SGvsA and !ply:IsBot() then
		ply:SetTeam( TEAM_UNASSIGNED )
	elseif ply:IsBot() then
		ply:SetTeam(1)
	end
	
	fnafgmMapOverrides()
	fnafgmCheckUpdate()
	if !GAMEMODE.Official then fnafgmCheckUpdateD() end
	
	GAMEMODE.Vars.active = true
	
	net.Start( "fnafgmDS" )
		net.WriteBit( game.IsDedicated() )
	net.Send(ply)
	
	if GAMEMODE.Vars.Animatronics != {} then
		
		net.Start( "fnafgmAnimatronicsList" )
			net.WriteTable(GAMEMODE.Vars.Animatronics)
		net.Send(ply)
		
	end
	
end


concommand.Add("fnafgm_mapselect", function( ply )
	GAMEMODE:MapSelect(ply)
end)
function GM:MapSelect(ply)
	
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

function GM:ChangeMap(ply,map)
	
	if ply:IsListenServerHost() or ply:IsAdmin() or game.GetMap()=="gm_construct" or game.GetMap()=="gm_flatgrass" then
		
		MsgC( Color( 255, 255, 85 ), "FNAFGM: Map changing to "..map.." because of "..ply:GetName().."\n" )
		RunConsoleCommand( "changelevel", map )
		
	else
		
		ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! (Not admin/host)")
		
		net.Start( "fnafgmNotif" )
			net.WriteString( "Nope, you can't do that! (Not admin/host)" )
			net.WriteInt(1,3)
			net.WriteFloat(5)
			net.WriteBit(true)
		net.Send(ply)
		
	end
	
end
net.Receive( "fnafgmChangeMap",function(bits,ply)
	local map = net.ReadString()
	GAMEMODE:ChangeMap(ply,map)
end )


function GM:PlayerRequestTeam( ply, teamid )

	-- No changing teams if not teambased!
	if ( GAMEMODE.Vars.norespawn and teamid==1 ) then 
		ply:ChatPrint( "You can't do this now!" )
		net.Start( "fnafgmNotif" )
			net.WriteString( "You can't do this now!" )
			net.WriteInt(1,3)
			net.WriteFloat(5)
			net.WriteBit(true)
		net.Send(ply)
		return
	elseif ( !GAMEMODE.Vars.SGvsA and teamid==2 and !fnafgmPlayerCanByPass(ply,"debug") ) then 
		ply:ChatPrint( "You're not in SGvsA mode!" )
		net.Start( "fnafgmNotif" )
			net.WriteString( "You're not in SGvsA mode!" )
			net.WriteInt(1,3)
			net.WriteFloat(5)
			net.WriteBit(true)
		net.Send(ply)
		return
	elseif (!GAMEMODE.Vars.SGvsA and teamid==TEAM_SPECTATOR and !fnafgmPlayerCanByPass(ply,"spectator") ) then
		ply:ChatPrint( "Nope, you can't do that! (Need spectator bypass)" )
		net.Start( "fnafgmNotif" )
			net.WriteString( "Nope, you can't do that! (Need spectator bypass)" )
			net.WriteInt(1,3)
			net.WriteFloat(5)
			net.WriteBit(true)
		net.Send(ply)
		return
	elseif (teamid==TEAM_SPECTATOR and !GetConVar("mp_allowspectators"):GetBool() and !fnafgmPlayerCanByPass(ply,"spectator") ) then
		ply:ChatPrint( "Spectator mode is disabled!" )
		return
	elseif GAMEMODE.Vars.b87 then
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
		net.Start( "fnafgmNotif" )
			net.WriteString( "You're already on that team" )
			net.WriteInt(1,3)
			net.WriteFloat(5)
			net.WriteBit(true)
		net.Send(ply)
		return false
	end
	
	-- Animatronics full!
	if ( teamid==2 and team.NumPlayers(teamid)>=4 and !fnafgmPlayerCanByPass(ply,"goldenfreddy") ) then
		ply:ChatPrint( "Sorry this team is full!" )
		net.Start( "fnafgmNotif" )
			net.WriteString( "Sorry this team is full!" )
			net.WriteInt(1,3)
			net.WriteFloat(5)
			net.WriteBit(true)
		net.Send(ply)
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
	
	if GAMEMODE.Vars.SGvsA and ply:Team()==TEAM_UNASSIGNED and ( ply:KeyPressed( IN_ATTACK ) || ply:KeyPressed( IN_ATTACK2 ) || ply:KeyPressed( IN_JUMP ) ) and !GAMEMODE.Vars.norespawn then
		ply:ConCommand( "gm_showteam" )
	elseif !GAMEMODE.Vars.SGvsA and ply:Team()==TEAM_UNASSIGNED and !ply:KeyPressed( IN_SCORE ) and !GAMEMODE.Vars.b87 and !GAMEMODE.Vars.norespawn then
		GAMEMODE:PlayerRequestTeam( ply, 1 )
	end
	
end


function GM:PostPlayerDeath( ply )
	
	local userid = ply:UserID()
	local oldteam = ply:Team()
	
	if ( !GAMEMODE.Vars.nightpassed and !GAMEMODE.Vars.gameend and ply:Team()==1 and !GAMEMODE.Vars.b87 ) then
		
		if fnafgmPlayerCanByPass(ply,"fastrespawn") then ply.NextSpawnTime = CurTime() + fnafgm_deathscreendelay:GetInt() + 1 else ply.NextSpawnTime = CurTime() + fnafgm_deathscreendelay:GetInt()+fnafgm_deathscreenduration:GetInt()+fnafgm_respawndelay:GetInt() end
	
		local ent = ply:GetRagdollEntity()
	
		if fnafgm_ragdollinstantremove:GetBool() and IsValid(ent) then --Ragdoll zone
			ent:Remove() --Ragdoll remove
		elseif IsValid(ent) then
			if fnafgm_ragdolloverride:GetBool() then --Ragdoll model
				if table.Count(GAMEMODE.Models_dead)!=0 then
					local modele = table.Random(GAMEMODE.Models_dead)
					if file.Exists( modele, "GAME" ) then
						ent:SetModel(modele)
					end
				end
				if GAMEMODE.DeadBodiesTeleport[game.GetMap()] then
					ply:SetPos( table.Random(GAMEMODE.DeadBodiesTeleport[game.GetMap()]) )
				end
			end
		end
	
		if fnafgm_deathscreenfade:GetBool() then ply:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 65536 ) end --Screen fade
		
		timer.Create( "fnafgmStaticStart"..userid, fnafgm_deathscreendelay:GetInt(), 1, function()
			
			if (!GAMEMODE.Vars.nightpassed and IsValid(ply) and !ply:Alive() and ply:Team()==1) then
				
				if ((fnafgm_pinionsupport:GetBool()) and (!fnafgm_respawnenabled:GetBool() or GAMEMODE.Vars.norespawn)) then Pinion:ShowMOTD(ply) end
				
				if game.GetMap()=="freddys" and ents.FindByName( "fnafgm_Cam6" )[1] then
					ply:SetViewEntity( ents.FindByName( "fnafgm_Cam6" )[1] )
				elseif game.GetMap()=="fnaf2" and ents.FindByName( "DeathCam" )[1] then
					ply:SetViewEntity( ents.FindByName( "DeathCam" )[1] )
				end
				
				if game.SinglePlayer() then
					timer.Remove("fnafgmTimeThink")
					if game.GetMap()=="freddys" and !GAMEMODE.Vars.poweroff then
						if IsValid(ents.FindByName( "FoxyTime" )[1]) then ents.FindByName( "FoxyTime" )[1]:Fire("Kill") end
						if IsValid(ents.FindByName( "foxytest" )[1]) then ents.FindByName( "foxytest" )[1]:Fire("Kill") end
						if IsValid(ents.FindByName( "foxytest2" )[1]) then ents.FindByName( "foxytest2" )[1]:Fire("Kill") end
						if IsValid(ents.FindByName( "FoxyKilledYou" )[1]) then ents.FindByName( "FoxyKilledYou" )[1]:Fire("Kill") end
						if IsValid(ents.FindByName( "foxydeath" )[1]) then ents.FindByName( "foxydeath" )[1]:Fire("Kill") end
						if IsValid(ents.FindByName( "EventTimer" )[1]) then ents.FindByName( "EventTimer" )[1]:Fire("Kill") end
						if IsValid(ents.FindByName( "EventTimer2" )[1]) then ents.FindByName( "EventTimer2" )[1]:Fire("Kill") end
						if IsValid(ents.FindByName( "FreddyDeath" )[1]) then ents.FindByName( "FreddyDeath" )[1]:Fire("Kill") end
						if IsValid(ents.FindByName( "FreddyOffice" )[1]) then ents.FindByName( "FreddyOffice" )[1]:Fire("Kill") end
						if IsValid(ents.FindByName( "freddytest" )[1]) then ents.FindByName( "freddytest" )[1]:Fire("Kill") end
						if IsValid(ents.FindByName( "BonnieOffice" )[1]) then ents.FindByName( "BonnieOffice" )[1]:Fire("Kill") end
						if IsValid(ents.FindByName( "BonnieDeath" )[1]) then ents.FindByName( "BonnieDeath" )[1]:Fire("Kill") end
						if IsValid(ents.FindByName( "bonnietest" )[1]) then ents.FindByName( "bonnietest" )[1]:Fire("Kill") end
						if IsValid(ents.FindByName( "ChicaOffice" )[1]) then ents.FindByName( "ChicaOffice" )[1]:Fire("Kill") end
						if IsValid(ents.FindByName( "ChicaDeath" )[1]) then ents.FindByName( "ChicaDeath" )[1]:Fire("Kill") end
						if IsValid(ents.FindByName( "chicatest" )[1]) then ents.FindByName( "chicatest" )[1]:Fire("Kill") end
					end
					hook.Call("fnafgmGeneralDeath")
				end
				
				if fnafgm_deathscreenoverlay:GetBool() then --Static screen
					if ( game.SinglePlayer() ) then ply:ConCommand("stopsound") else ply:SendLua([[RunConsoleCommand("stopsound")]]) end --Stop sound
					ply:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_static )
					ply:ConCommand("play "..GAMEMODE.Sound_static)
				else
					ply:ConCommand( "pp_mat_overlay ''" )
				end
				
				timer.Create( "fnafgmStaticEnd"..userid, fnafgm_deathscreenduration:GetInt(), 1, function()
					
					if (!GAMEMODE.Vars.nightpassed and IsValid(ply) and !ply:Alive()) then
						
						ply:ConCommand( "pp_mat_overlay ''" )
						if game.GetMap()=="fnaf2" then
							ply:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_fnaf2deathcam )
						end
						ply:ScreenFade(16, color_black, 0, 0 )
						
						if fnafgm_respawndelay:GetInt()==0 then
							
							if ((fnafgm_autorespawn:GetBool() and fnafgm_respawnenabled:GetBool()) and !GAMEMODE.Vars.norespawn) then ply:Spawn() elseif fnafgm_respawnenabled:GetBool() and !GAMEMODE.Vars.norespawn then ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn") ply:SendLua([[chat.PlaySound()]]) elseif !GAMEMODE.Vars.norespawn then ply:PrintMessage(HUD_PRINTTALK, "You will respawn after the night or when all the players are dead.") ply:SendLua([[chat.PlaySound()]]) end
						
						else
							
							if (fnafgm_respawnenabled:GetBool() and !GAMEMODE.Vars.norespawn) then ply:PrintMessage(HUD_PRINTCENTER, "You will respawn in "..fnafgm_respawndelay:GetInt().."s") ply:SendLua([[chat.PlaySound()]]) elseif !GAMEMODE.Vars.norespawn then ply:PrintMessage(HUD_PRINTTALK, "You will respawn after the night or when all the players are dead.") ply:SendLua([[chat.PlaySound()]]) end
							
							timer.Create( "fnafgmRespawn"..userid, fnafgm_respawndelay:GetInt(), 1, function()
								
								if (!GAMEMODE.Vars.nightpassed and IsValid(ply) and !ply:Alive()) then
								
									if ((fnafgm_autorespawn:GetBool() and fnafgm_respawnenabled:GetBool()) and !GAMEMODE.Vars.norespawn) then ply:Spawn() elseif fnafgm_respawnenabled:GetBool() and !GAMEMODE.Vars.norespawn then ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn") ply:SendLua([[chat.PlaySound()]]) end
									
								end
								
								timer.Remove("fnafgmRespawn"..userid)
								
							end)
							
						end
						
						
					end
					
					timer.Remove("fnafgmStaticEnd"..userid)
				end)
				
			elseif (!GAMEMODE.Vars.nightpassed and IsValid(ply) and !ply:Alive() and ply:Team()~=1) then
				
				ply:ConCommand( "pp_mat_overlay ''" )
				ply:ScreenFade(16, color_black, 0, 0 )
				
			end
			
			timer.Remove("fnafgmStaticStart"..userid)
			
		end)
		
	elseif GAMEMODE.Vars.nightpassed or GAMEMODE.Vars.gameend then
		
		ply.NextSpawnTime = CurTime() + 11
		
	elseif ( ply:Team()==2 ) then
		
		if fnafgmPlayerCanByPass(ply,"fastrespawn") then ply.NextSpawnTime = CurTime() + 1 else ply.NextSpawnTime = CurTime() + fnafgm_respawndelay:GetInt() end
		
		local ent = ply:GetRagdollEntity()
		if IsValid(ent) then ent:Remove() end --Ragdoll remove
		
		if fnafgm_respawndelay:GetInt()==0 then
							
			timer.Create( "fnafgmRespawn"..userid, 1, 1, function()
				
				if (!GAMEMODE.Vars.nightpassed and IsValid(ply) and !ply:Alive()) then
					
					if (fnafgm_autorespawn:GetBool() and !GAMEMODE.Vars.norespawn) then ply:Spawn() elseif fnafgm_respawnenabled:GetBool() and !GAMEMODE.Vars.norespawn then ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn") ply:SendLua([[chat.PlaySound()]]) end
				
				end
				
				timer.Remove("fnafgmRespawn"..userid)
				
			end)
			
		else
			
			if !GAMEMODE.Vars.norespawn then ply:PrintMessage(HUD_PRINTCENTER, "You will respawn in "..fnafgm_respawndelay:GetInt().."s") ply:SendLua([[chat.PlaySound()]]) end
			
			timer.Create( "fnafgmRespawn"..userid, fnafgm_respawndelay:GetInt(), 1, function()
									
				if (!GAMEMODE.Vars.nightpassed and IsValid(ply) and !ply:Alive()) then
					
					if (fnafgm_autorespawn:GetBool() and !GAMEMODE.Vars.norespawn) then ply:Spawn() elseif !GAMEMODE.Vars.norespawn then ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn") ply:SendLua([[chat.PlaySound()]]) end
					
				end
									
				timer.Remove("fnafgmRespawn"..userid)
			
			end)
		
		end
		
	else
		
		if fnafgmPlayerCanByPass(ply,"fastrespawn") or ply:Team()==TEAM_UNASSIGNED then ply.NextSpawnTime = CurTime() + 0.001 else ply.NextSpawnTime = CurTime() + fnafgm_respawndelay:GetInt() end
		
		if fnafgm_respawndelay:GetInt()==0 or ply:Team()==TEAM_UNASSIGNED then
			
			timer.Create( "fnafgmRespawn"..userid, 0.001, 1, function()
			
				if (!GAMEMODE.Vars.nightpassed and IsValid(ply) and !ply:Alive()) then
					
					if ((fnafgm_autorespawn:GetBool() or oldteam==TEAM_UNASSIGNED) and !GAMEMODE.Vars.norespawn) then ply:Spawn() elseif !GAMEMODE.Vars.norespawn then ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn") ply:SendLua([[chat.PlaySound()]]) end
					
				end
			
				timer.Remove("fnafgmRespawn"..userid)
				
			end)
			
		else
			
			if !GAMEMODE.Vars.norespawn then ply:PrintMessage(HUD_PRINTCENTER, "You will respawn in "..fnafgm_respawndelay:GetInt().."s") ply:SendLua([[chat.PlaySound()]]) end
			
			timer.Create( "fnafgmRespawn"..userid, fnafgm_respawndelay:GetInt(), 1, function()
								
				if (!GAMEMODE.Vars.nightpassed and IsValid(ply) and !ply:Alive()) then
								
					if (fnafgm_autorespawn:GetBool() and !GAMEMODE.Vars.norespawn) then ply:Spawn() elseif !GAMEMODE.Vars.norespawn then ply:PrintMessage(HUD_PRINTCENTER, "Press a key to respawn") ply:SendLua([[chat.PlaySound()]]) end
										
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
	
	if GAMEMODE.Vars.norespawn then return end
	
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
	
	return true
	
end


function GM:PlayerSpray( ply )
	if fnafgmPlayerCanByPass(ply,"spray") then
		return false
	else
		return true
	end
end


function fnafgmUse(ply, ent, test, test2)
	
	if debugmode and IsValid(ent) then print(ent:GetName().." ["..ent:GetClass().."] "..tostring(ent:GetPos())) end
	
	hook.Call("fnafgmUseCustom", nil, ply, ent, test, test2)
	
	if IsValid(ply) and ply:Team()!=1 and !test and !fnafgmPlayerCanByPass(ply,"debug") then
		return false
	end
	
	if (game.GetMap()=="freddys") then
		
		if ( test or ( btn and btn:IsValid() and ent==btn and ply:IsValid() and ply:Alive() ) ) and !GAMEMODE.Vars.startday then
			
			GAMEMODE:SetNightTemplate(true)
			if GAMEMODE.Vars.Halloween or fnafgm_forceseasonalevent:GetInt()==3 then
				sound.Play( "fnafgm/robotvoice.wav", Vector( -80, -1163, 128 ), 150 )
			end
			
			btn:Fire("use")
			
			if GAMEMODE.Vars.Halloween or fnafgm_forceseasonalevent:GetInt()==3 then
				ents.FindByName( "EventTimer" )[1]:Fire("LowerRandomBound", 10)
				ents.FindByName( "EventTimer" )[1]:Fire("UpperRandomBound", 10)
				
				ents.FindByName( "FoxyTime" )[1]:Fire("LowerRandomBound", 60)
				ents.FindByName( "FoxyTime" )[1]:Fire("UpperRandomBound", 170)
				
				ents.FindByName( "EventTimer2" )[1]:Fire("LowerRandomBound", 10)
				ents.FindByName( "EventTimer2" )[1]:Fire("UpperRandomBound", 10)
			elseif GAMEMODE.Vars.night==1 then
				ents.FindByName( "EventTimer" )[1]:Fire("LowerRandomBound", 60)
				ents.FindByName( "EventTimer" )[1]:Fire("UpperRandomBound", 90)
				
				ents.FindByName( "FoxyTime" )[1]:Fire("LowerRandomBound", 1000)
				ents.FindByName( "FoxyTime" )[1]:Fire("UpperRandomBound", 1000)
				
				ents.FindByName( "EventTimer2" )[1]:Fire("LowerRandomBound", 1000)
				ents.FindByName( "EventTimer2" )[1]:Fire("UpperRandomBound", 1000)
			elseif GAMEMODE.Vars.night==2 then
				ents.FindByName( "EventTimer" )[1]:Fire("LowerRandomBound", 40)
				ents.FindByName( "EventTimer" )[1]:Fire("UpperRandomBound", 60)
				
				ents.FindByName( "FoxyTime" )[1]:Fire("LowerRandomBound", 200)
				ents.FindByName( "FoxyTime" )[1]:Fire("UpperRandomBound", 500)
				
				ents.FindByName( "EventTimer2" )[1]:Fire("LowerRandomBound", 1000)
				ents.FindByName( "EventTimer2" )[1]:Fire("UpperRandomBound", 1000)
			elseif GAMEMODE.Vars.night==3 then
				ents.FindByName( "EventTimer" )[1]:Fire("LowerRandomBound", 30)
				ents.FindByName( "EventTimer" )[1]:Fire("UpperRandomBound", 45)
				
				ents.FindByName( "FoxyTime" )[1]:Fire("LowerRandomBound", 120)
				ents.FindByName( "FoxyTime" )[1]:Fire("UpperRandomBound", 400)
				
				ents.FindByName( "EventTimer2" )[1]:Fire("LowerRandomBound", 30)
				ents.FindByName( "EventTimer2" )[1]:Fire("UpperRandomBound", 90)
			elseif GAMEMODE.Vars.night==4 then
				ents.FindByName( "EventTimer" )[1]:Fire("LowerRandomBound", 20)
				ents.FindByName( "EventTimer" )[1]:Fire("UpperRandomBound", 25)
				
				ents.FindByName( "FoxyTime" )[1]:Fire("LowerRandomBound", 120)
				ents.FindByName( "FoxyTime" )[1]:Fire("UpperRandomBound", 300)
				
				ents.FindByName( "EventTimer2" )[1]:Fire("LowerRandomBound", 30)
				ents.FindByName( "EventTimer2" )[1]:Fire("UpperRandomBound", 60)
			elseif GAMEMODE.Vars.night==5 then
				ents.FindByName( "EventTimer" )[1]:Fire("LowerRandomBound", 16)
				ents.FindByName( "EventTimer" )[1]:Fire("UpperRandomBound", 16)
				
				ents.FindByName( "FoxyTime" )[1]:Fire("LowerRandomBound", 120)
				ents.FindByName( "FoxyTime" )[1]:Fire("UpperRandomBound", 170)
				
				ents.FindByName( "EventTimer2" )[1]:Fire("LowerRandomBound", 16)
				ents.FindByName( "EventTimer2" )[1]:Fire("UpperRandomBound", 30)
			elseif GAMEMODE.Vars.night==6 then
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
			
			if GAMEMODE.Vars.night==1 then
				sound = GAMEMODE.Sound_Calls.freddys[1]
				GAMEMODE.Vars.mute = false
				mutetime = 207
			elseif GAMEMODE.Vars.night==2 then
				sound = GAMEMODE.Sound_Calls.freddys[2]
				GAMEMODE.Vars.mute = false
				mutetime = 104
			elseif GAMEMODE.Vars.night==3 then
				sound = GAMEMODE.Sound_Calls.freddys[3]
				GAMEMODE.Vars.mute = false
				mutetime = 75
			elseif GAMEMODE.Vars.night==4 then
				sound = GAMEMODE.Sound_Calls.freddys[4]
				GAMEMODE.Vars.mute = false
				mutetime = 65
			elseif GAMEMODE.Vars.night==5 then
				sound = GAMEMODE.Sound_Calls.freddys[5]
				GAMEMODE.Vars.mute = false
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
			
			if IsValid(ply) then
				MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..GAMEMODE.Vars.night.." started by "..ply:GetName().."\n" )
			else
				MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..GAMEMODE.Vars.night.." started by console/map/other\n" )
			end
			
			timer.Create( "fnafgmTempoStartM", 0.01, 1, function()
				
				for k, v in pairs(team.GetPlayers(1)) do
					if v:Alive() and !GAMEMODE:CheckPlayerSecurityRoom(v) then
						v:SetPos( Vector( -80, -1224, 64 ) )
						v:SetEyeAngles(Angle( 0, 90, 0 ))
					end
				end
				
				
				if GAMEMODE.Vars.AprilFool or fnafgm_forceseasonalevent:GetInt()==2 then
					for k, v in pairs(ents.FindByName("secret")) do
						v:Fire("PlaySound")
					end
				end
				
				timer.Remove( "fnafgmTempoStartM" )
				
			end)
			
			timer.Create( "fnafgmTempoStart", 2.5, 1, function()
				
				GAMEMODE.Vars.tempostart = false
				fnafgmVarsUpdate()
				fnafgmPowerUpdate()
				
				if !GAMEMODE.Vars.mute then
				
					for k, v in pairs(ents.FindByName("Collectcall")) do
						v:Fire("PlaySound")
					end
					
					timer.Create( "fnafgmEndCall", mutetime, 1, function()
						GAMEMODE.Vars.mute = true
						for k, v in pairs(ents.FindByName("Callman")) do
							v:Fire("Use")
						end
					end)
					
				end
				for k, v in pairs(team.GetPlayers(1)) do
					if v:Team()==1 and v:Alive() and v:GetInfoNum("fnafgm_cl_autofnafview", 1)==1 then
						GAMEMODE:GoFNaFView(v)
					end
				end
				
				timer.Create( "fnafgmTimeThink", GAMEMODE.HourTime, 0, fnafgmTimeThink)
				
				timer.Remove( "fnafgmTempoStart" )
				
			end)
			
			return false
		
		elseif !btn then
			
			error( "btn is not defined" )
		
			
		elseif btn and btn:IsValid() and ent==btn then
			
			return false
			
		end
		
	elseif (game.GetMap()=="freddysnoevent") then
		
		if ( test or ( btn and btn:IsValid() and ent==btn and ply:IsValid() and ply:Alive() ) ) and !GAMEMODE.Vars.startday then
			
			GAMEMODE:SetNightTemplate(true)
			if GAMEMODE.Vars.Halloween or fnafgm_forceseasonalevent:GetInt()==3 then
				sound.Play( "fnafgm/robotvoice.wav", Vector( -80, -1163, 128 ), 150 )
			end
			
			btn:Fire("use")
			ents.FindByName( "Powerlvl" )[1]:Fire("Enable")
			
			fnafgmVarsUpdate()
			
			for k, v in pairs(team.GetPlayers(1)) do
				if v:Alive() then
					v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 2.5 )
				end
			end
			
			if IsValid(ply) then
				MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..GAMEMODE.Vars.night.." started by "..ply:GetName().."\n" )
			else
				MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..GAMEMODE.Vars.night.." started by console/map/other\n" )
			end
			
			timer.Create( "fnafgmTempoStartM", 0.01, 1, function()
				
				for k, v in pairs(team.GetPlayers(1)) do
					if v:Alive() and !GAMEMODE:CheckPlayerSecurityRoom(v) then
						v:SetPos( Vector( -80, -1224, 64 ) )
						v:SetEyeAngles(Angle( 0, 90, 0 ))
					end
				end
				
				timer.Remove( "fnafgmTempoStartM" )
				
			end)
			
			timer.Create( "fnafgmTempoStart", 2.5, 1, function()
				
				GAMEMODE.Vars.tempostart = false
				fnafgmVarsUpdate()
				fnafgmPowerUpdate()
				
				for k, v in pairs(team.GetPlayers(1)) do
					if v:Team()==1 and v:Alive() and v:GetInfoNum("fnafgm_cl_autofnafview", 1)==1 then
						GAMEMODE:GoFNaFView(v)
					end
				end
				
				timer.Create( "fnafgmTimeThink", GAMEMODE.HourTime, 0, fnafgmTimeThink)
				
				timer.Remove( "fnafgmTempoStart" )
				
			end)
			
			return false
		
		elseif !btn then
			
			error( "btn is not defined" )
		
		elseif btn and btn:IsValid() and ent==btn then
			
			return false
			
		end
		
	elseif (game.GetMap()=="fnaf2") then
		
		if btn and btn:IsValid() and btnm and btnm:IsValid() and !GAMEMODE.Vars.startday then
			
			if ( test or ( ( ent==btn or ent==btnm ) and ply:IsValid() and ply:Alive() ) ) then
				
				GAMEMODE:SetNightTemplate(false)
				if GAMEMODE.Vars.night==1 then
					GAMEMODE.Vars.power = 115
					GAMEMODE.Vars.powertot = 115
				elseif GAMEMODE.Vars.night==2 then
					GAMEMODE.Vars.power = 100
					GAMEMODE.Vars.powertot = 100
				elseif GAMEMODE.Vars.night==3 then
					GAMEMODE.Vars.power = 85
					GAMEMODE.Vars.powertot = 85
				elseif GAMEMODE.Vars.night==4 then
					GAMEMODE.Vars.power = 67
					GAMEMODE.Vars.powertot = 67
				else
					GAMEMODE.Vars.power = 50
					GAMEMODE.Vars.powertot = 50
				end
				
				btn:Fire("use")
				btnm:Fire("use")
				
				fnafgmVarsUpdate()
			
				for k, v in pairs(team.GetPlayers(1)) do
					if v:Alive() then
						v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 2.5 )
					end
				end
				
				if IsValid(ply) then
					MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..GAMEMODE.Vars.night.." started by "..ply:GetName().."\n" )
				else
					MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..GAMEMODE.Vars.night.." started by console/map/other\n" )
				end
			
				timer.Create( "fnafgmTempoStartM", 0.01, 1, function()
					
					for k, v in pairs(team.GetPlayers(1)) do
						if v:Alive() and !GAMEMODE:CheckPlayerSecurityRoom(v) then
							local spawn = GAMEMODE:PlayerSelectSpawn( v ):GetPos()
							v:SetPos( spawn )
							v:SetEyeAngles(Angle( 0, 90, 0 ))
						end
					end
					
					timer.Remove( "fnafgmTempoStartM" )
					
				end)
			
				timer.Create( "fnafgmTempoStart", 2.5, 1, function()
					
					GAMEMODE.Vars.tempostart = false
					fnafgmVarsUpdate()
					fnafgmPowerUpdate()
					
					for k, v in pairs(team.GetPlayers(1)) do
						if v:Team()==1 and v:Alive() and v:GetInfoNum("fnafgm_cl_autofnafview", 1)==1 then
							GAMEMODE:GoFNaFView(v)
						end
					end
					
					timer.Create( "fnafgmTimeThink", GAMEMODE.HourTime, 0, fnafgmTimeThink)
					
					timer.Remove( "fnafgmTempoStart" )
					
				end)
				
			end
		
		elseif !btn or !btnm then
			
			error( "btn/btnm is not defined" )
		
		end
		
	elseif (game.GetMap()=="fnaf_freddypizzaevents") then
		
		if ( test or ( btn and btn:IsValid() and ent==btn and ply:IsValid() and ply:Alive() ) ) and !GAMEMODE.Vars.startday then
			
			GAMEMODE:SetNightTemplate(false)
			GAMEMODE.Vars.time = 0
			GAMEMODE.Vars.AMPM = ""
			GAMEMODE.Vars.tempostart = false
			
			fnafgmVarsUpdate()
			
			btn:Fire("use")
			
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Map started\n" )
			
		elseif !btn then
			
			error( "btn is not defined" )
		
		elseif btn and btn:IsValid() and ( ( ent==btn and ply:IsValid() and ply:Alive() ) or test ) and GAMEMODE.Vars.startday then
			
			ply:SendLua([[chat.PlaySound()]])
			ply:PrintMessage(HUD_PRINTTALK, "Map already started!")
			
		end
	
	elseif test and ( game.GetMap()=="fnaf4house" or game.GetMap()=="fnaf4noclips" or game.GetMap()=="fnaf4versus" ) then
		
		if !GAMEMODE.Vars.startday then
			
			GAMEMODE:SetNightTemplate(false)
			if PlushTrapWin then GAMEMODE.Vars.time=2 PlushTrapWin=false else GAMEMODE.Vars.time = GAMEMODE.TimeBase end
				
			fnafgmVarsUpdate()
			
			if game.GetMap()!="fnaf4versus" then
				
				for k, v in pairs(ents.FindByClass("info_player_start")) do
					v:Remove()
				end
				
				local spawn = ents.Create( "info_player_start" )
				spawn:SetPos( Vector( -640, -63, 0 ) )
				spawn:SetAngles( Angle( 0, 90, 0 ) )
				spawn:Spawn()
			
			end
			
			for k, v in pairs(team.GetPlayers(1)) do
				if v:Alive() then
					v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 2.5 )
				end
			end
			
			if IsValid(ply) then
				MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..GAMEMODE.Vars.night.." started by "..ply:GetName().."\n" )
			else
				MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..GAMEMODE.Vars.night.." started by console/map/other\n" )
			end
			
			if game.GetMap()!="fnaf4versus" then
		
				timer.Create( "fnafgmTempoStartM", 0.01, 1, function()
					
					for k, v in pairs(team.GetPlayers(1)) do
						if v:Alive() and !GAMEMODE:CheckPlayerSecurityRoom(v) then
							v:SetPos( Vector( -640, -63, 0 ) )
							v:SetEyeAngles(Angle( 0, 90, 0 ))
						end
					end
					
					timer.Remove( "fnafgmTempoStartM" )
					
				end)
				
			end
	
			timer.Create( "fnafgmTempoStart", 2.5, 1, function()
				
				GAMEMODE.Vars.tempostart = false
				fnafgmVarsUpdate()
				fnafgmPowerUpdate()
				
				for k, v in pairs(team.GetPlayers(1)) do
					if v:Team()==1 and v:Alive() and v:GetInfoNum("fnafgm_cl_autofnafview", 1)==1 then
						GAMEMODE:GoFNaFView(v)
					end
				end
				
				timer.Create( "fnafgmTimeThink", GAMEMODE.HourTime, 0, fnafgmTimeThink)
				
				timer.Remove( "fnafgmTempoStart" )
				
			end)
			
		end
		
	elseif test and game.GetMap()!="gm_construct" and game.GetMap()!="gm_flatgrass" then
		
		if !GAMEMODE.Vars.startday then
			
			GAMEMODE:SetNightTemplate(true)
				
			fnafgmVarsUpdate()
			
			for k, v in pairs(team.GetPlayers(1)) do
				if v:Alive() then
					v:ScreenFade(SCREENFADE.OUT, color_black, 0.01, 2.5 )
				end
			end
			
			if IsValid(ply) then
				MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..GAMEMODE.Vars.night.." started by "..ply:GetName().."\n" )
			else
				MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..GAMEMODE.Vars.night.." started by console/map/other\n" )
			end
		
			timer.Create( "fnafgmTempoStartM", 0.01, 1, function()
				
				for k, v in pairs(team.GetPlayers(1)) do
					if v:Alive() and !GAMEMODE:CheckPlayerSecurityRoom(v) then
						local spawn = GAMEMODE:PlayerSelectSpawn( v ):GetPos()
						v:SetPos( spawn )
						v:SetEyeAngles(Angle( 0, 90, 0 ))
					end
				end
				
				timer.Remove( "fnafgmTempoStartM" )
				
			end)
	
			timer.Create( "fnafgmTempoStart", 2.5, 1, function()
				
				GAMEMODE.Vars.tempostart = false
				fnafgmVarsUpdate()
				
				for k, v in pairs(team.GetPlayers(1)) do
					if v:Team()==1 and v:Alive() and v:GetInfoNum("fnafgm_cl_autofnafview", 1)==1 then
						GAMEMODE:GoFNaFView(v)
					end
				end
				
				timer.Create( "fnafgmTimeThink", GAMEMODE.HourTime, 0, fnafgmTimeThink)
				
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
		
		if light1 and IsValid(light1) and ent==light1 then
			
			if !GAMEMODE.Vars.light1usewait and !GAMEMODE.Vars.poweroff then
					
				GAMEMODE.Vars.light1usewait = true
				GAMEMODE.Vars.LightUse[1] = !GAMEMODE.Vars.LightUse[1]
				light1:Fire("use")
				
				if GAMEMODE.Vars.LightUse[2] then
					GAMEMODE.Vars.LightUse[2] = !GAMEMODE.Vars.LightUse[2]
					light2:Fire("use")
				end
				
				timer.Create( "fnafgmlight1usewait", 0.5, 1, function()
					
					GAMEMODE.Vars.light1usewait = false
					
					timer.Remove( "fnafgmlight1usewait" )
					
				end)
				
			end
			
			return false
			
		end
		
		if light2 and IsValid(light2) and ent==light2 then
			
			if !GAMEMODE.Vars.light2usewait and !GAMEMODE.Vars.poweroff then
				
				GAMEMODE.Vars.light2usewait = true
				GAMEMODE.Vars.LightUse[2] = !GAMEMODE.Vars.LightUse[2]
				light2:Fire("use")
				
				if GAMEMODE.Vars.LightUse[1] then
					GAMEMODE.Vars.LightUse[1] = !GAMEMODE.Vars.LightUse[1]
					light1:Fire("use")
				end
				
				timer.Create( "fnafgmlight2usewait", 0.5, 1, function()
					
					GAMEMODE.Vars.light2usewait = false
					
					timer.Remove( "fnafgmlight2usewait" )
					
				end)
			
			end
			
			return false
			
		end
		
	end
		
	
	if game.GetMap()=="fnaf2" then
		
		if light1 and IsValid(light1) and ent==light1 then
			
			if !GAMEMODE.Vars.light1usewait and !GAMEMODE.Vars.poweroff then
					
				GAMEMODE.Vars.light1usewait = true
				GAMEMODE.Vars.LightUse[1] = true
				light1:Fire("use")
				
				timer.Create( "fnafgmlight1usewait", 2.1, 1, function()
					
					GAMEMODE.Vars.light1usewait = false
					GAMEMODE.Vars.LightUse[1] = false
					
					timer.Remove( "fnafgmlight1usewait" )
					
				end)
				
			elseif !GAMEMODE.Vars.light1usewait and GAMEMODE.Vars.poweroff then
			
				ply:ConCommand("play "..GAMEMODE.Sound_lighterror)
				GAMEMODE.Vars.light1usewait = true
				
				timer.Create( "fnafgmlight1usewait", 1, 1, function()
					
					GAMEMODE.Vars.light1usewait = false
					
					timer.Remove( "fnafgmlight1usewait" )
					
				end)
				
			end
			
			return false
			
		end
		
		if light2 and IsValid(light2) and ent==light2 then
			
			if !GAMEMODE.Vars.light2usewait and !GAMEMODE.Vars.poweroff then
				
				GAMEMODE.Vars.light2usewait = true
				GAMEMODE.Vars.LightUse[2] = true
				light2:Fire("use")
				
				timer.Create( "fnafgmlight2usewait", 3.1, 1, function()
					
					GAMEMODE.Vars.light2usewait = false
					GAMEMODE.Vars.LightUse[2] = false
					
					timer.Remove( "fnafgmlight2usewait" )
					
				end)
				
			elseif !GAMEMODE.Vars.light2usewait and GAMEMODE.Vars.poweroff then
			
				ply:ConCommand("play "..GAMEMODE.Sound_lighterror)
				GAMEMODE.Vars.light2usewait = true
				
				timer.Create( "fnafgmlight2usewait", 1, 1, function()
					
					GAMEMODE.Vars.light2usewait = false
					
					timer.Remove( "fnafgmlight2usewait" )
					
				end)
				
			end
			
			return false
			
		end
		
		if light3 and IsValid(light3) and ent==light3 then
			
			if !GAMEMODE.Vars.light3usewait and !GAMEMODE.Vars.poweroff then
				
				GAMEMODE.Vars.light3usewait = true
				GAMEMODE.Vars.LightUse[3] = true
				light3:Fire("use")
				
				timer.Create( "fnafgmlight3usewait", 2.1, 1, function()
					
					GAMEMODE.Vars.light3usewait = false
					GAMEMODE.Vars.LightUse[3] = false
					
					timer.Remove( "fnafgmlight3usewait" )
					
				end)
				
			elseif !GAMEMODE.Vars.light3usewait and GAMEMODE.Vars.poweroff then
			
				ply:ConCommand("play "..GAMEMODE.Sound_lighterror)
				GAMEMODE.Vars.light3usewait = true
				
				timer.Create( "fnafgmlight3usewait", 1, 1, function()
					
					GAMEMODE.Vars.light3usewait = false
					
					timer.Remove( "fnafgmlight3usewait" )
					
				end)
				
			end
			
			return false
			
		end
		
		if safedoor and safedoor:IsValid() and ent==safedoor and !GAMEMODE.Vars.usingsafedoor[ply] then
			
			ply:SetPos( Vector( -46, -450, 0 ) )
			
			GAMEMODE.Vars.usingsafedoor[ply]=true
			
		elseif safedoor and safedoor:IsValid() and ent==safedoor and GAMEMODE.Vars.usingsafedoor[ply] then
			
			ply:SetPos( Vector( -46, -320, 0 ) )
			
			GAMEMODE.Vars.usingsafedoor[ply]=false
			
		end
	
	end
	
	
	if test2 and ent and ent:GetClass()=="func_button" then
		
		ent:Fire("use")
		return false
		
	end
	
	
end
hook.Add( "PlayerUse", "fnafgmUse", fnafgmUse )


function GM:SetNightTemplate(power)
	
	--FNAF2
	if GAMEMODE.Vars.night==1 then
		GAMEMODE.Vars.power = 115
		GAMEMODE.Vars.powertot = 115
	elseif GAMEMODE.Vars.night==2 then
		GAMEMODE.Vars.power = 100
		GAMEMODE.Vars.powertot = 100
	elseif GAMEMODE.Vars.night==3 then
		GAMEMODE.Vars.power = 85
		GAMEMODE.Vars.powertot = 85
	elseif GAMEMODE.Vars.night==4 then
		GAMEMODE.Vars.power = 67
		GAMEMODE.Vars.powertot = 67
	else
		GAMEMODE.Vars.power = 50
		GAMEMODE.Vars.powertot = 50
	end
	
	--BASE
	GAMEMODE.Vars.startday = true
	GAMEMODE.Vars.tempostart = true
	GAMEMODE.Vars.night = GAMEMODE.Vars.night+1
	GAMEMODE.Vars.AMPM = GAMEMODE.AMPM
	GAMEMODE.Vars.time = GAMEMODE.TimeBase
	if power then GAMEMODE.Vars.power = GAMEMODE.Power_Max end
	GAMEMODE.Vars.nightpassed = false
	GAMEMODE.Vars.iniok = true
	
end


function fnafgmAutoCleanUp()
	
	if fnafgm_autocleanupmap:GetBool() and GAMEMODE.Vars.active and !alive then
	
		local online = false
		
		for k, v in pairs(player.GetAll()) do
			online = true
		end

		if !online then
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Auto clean up\n" )
			GAMEMODE.Vars.active = false
			fnafgmResetGame()
			fnafgmMapOverrides()
			GAMEMODE:LoadProgress()
		end
		
	end
	
end

function fnafgmRestartNight()
	
	if (GAMEMODE.Vars.iniok and GAMEMODE.Vars.mapoverrideok and GAMEMODE.Vars.startday and GAMEMODE.Vars.active) then
		
		game.CleanUpMap()
		timer.Remove("fnafgmTimeThink")
		timer.Remove("fnafgmPowerOff1")
		timer.Remove("fnafgmPowerOff2")
		timer.Remove("fnafgmPowerOff3")
		GAMEMODE.Vars.night = GAMEMODE.Vars.night-1
		GAMEMODE.Vars.time = GAMEMODE.TimeBase
		GAMEMODE.Vars.AMPM = GAMEMODE.AMPM
		GAMEMODE.Vars.poweroff = false
		GAMEMODE.Vars.powerchecktime=nil
		GAMEMODE.Vars.oldpowerdrain=nil
		table.Empty(GAMEMODE.Vars.tabused)
		table.Empty(GAMEMODE.Vars.usingsafedoor)
		GAMEMODE.Vars.startday = false
		GAMEMODE.Vars.tempostart = false
		GAMEMODE.Vars.nightpassed = false
		GAMEMODE.Vars.mapoverrideok = false
		table.Empty(GAMEMODE.Vars.LightUse)
		table.Empty(GAMEMODE.Vars.DoorClosed)
		GAMEMODE.Vars.mute = true
		timer.Remove( "fnafgmEndCall" )
		GAMEMODE.Vars.foxyknockdoorpena = 2
		GAMEMODE.Vars.addfoxyknockdoorpena = 4
		fnafgmMapOverrides()
		fnafgmVarsUpdate()
		for k, v in pairs(player.GetAll()) do
			if ( game.SinglePlayer() ) then v:ConCommand("stopsound") else v:SendLua([[RunConsoleCommand("stopsound")]]) end --Stop sound
			if v:Team()==1 or v:Team()==2 then
				v:Spawn()
				v:SetViewEntity(v)
			end
			if (fnafgm_pinionsupport:GetBool()) then Pinion:ShowMOTD(v) end
		end
		
		GAMEMODE.Vars.norespawn=false
		GAMEMODE.Vars.checkRestartNight=false
		
		MsgC( Color( 255, 255, 85 ), "FNAFGM: The night is reset\n" )
		
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
	GAMEMODE.Vars.powerchecktime=nil
	GAMEMODE.Vars.oldpowerdrain=nil
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
	timer.Remove( "fnafgmEndCall" )
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
	
	if !GAMEMODE.Vars.mapoverrideok then
		
		hook.Call("fnafgmMapOverridesCustom")
		
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
			
			for k, v in pairs(ents.FindByName("Callman")) do
				v:Fire("Lock")
			end
			
			if GAMEMODE.Vars.night>4 then
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
			
			GAMEMODE.Vars.mapoverrideok = true
			
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
			spawn:SetPos( Vector( -593, 336, 256 ) )
			spawn:SetAngles( Angle( 0, 135, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -687, 334, 256 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -753, 335, 256 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -832, 321, 256 ) )
			spawn:SetAngles( Angle( 0, 45, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -850, 425, 256 ) )
			spawn:SetAngles( Angle( 0, 0, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -845, 531, 256 ) )
			spawn:SetAngles( Angle( 0, 0, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -854, 601, 256 ) )
			spawn:SetAngles( Angle( 0, -45, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -750, 583, 256 ) )
			spawn:SetAngles( Angle( 0, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -662, 583, 256 ) )
			spawn:SetAngles( Angle( 0, -90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -561, 583, 256 ) )
			spawn:SetAngles( Angle( 0, -135, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -555, 444, 256 ) )
			spawn:SetAngles( Angle( 0, 180, 0 ) )
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
			
			local KitchenCam = ents.Create( "fnafgm_camera" )
			KitchenCam:SetPos( Vector( 235, -1050, 97 ) )
			KitchenCam:SetAngles( Angle( -33, 64, 15 ) )
			KitchenCam:SetName( "fnafgm_Cam11" )
			KitchenCam:Spawn()
			
			local OfficeCam = ents.Create( "fnafgm_camera" )
			OfficeCam:SetPos( Vector( -82, -1254, 170 ) )
			OfficeCam:SetAngles( Angle( 30, 90, 0 ) )
			OfficeCam:SetName( "fnafgm_Cam12" )
			OfficeCam:Spawn()
			
			GAMEMODE:CreateAnimatronic(0, 7)
			GAMEMODE:CreateAnimatronic(1, 7)
			GAMEMODE:CreateAnimatronic(2, 7)
			GAMEMODE:CreateAnimatronic(3, 9)
			--GAMEMODE:CreateAnimatronic(4, 11)
			
			GAMEMODE.Vars.mapoverrideok = true
			
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
			
			if fnafgm_disablemapsmonitors:GetBool() then
			
				for k, v in pairs(ents.FindByClass("func_monitor")) do
					if GAMEMODE:CheckPlayerSecurityRoom(v) then
						v:Fire("Color", "0 0 0")
					end
				end
				
				for k, v in pairs(ents.FindByName("Cambutton")) do
					v:Remove()
				end
				
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
			
			GAMEMODE.Vars.mapoverrideok = true
			
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
			
			GAMEMODE.Vars.mapoverrideok = true
			
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
			
			GAMEMODE.Vars.mapoverrideok = true
			
		elseif game.GetMap()=="fnaf4versus" then
			
			local spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -640, -8, -136 ) )
			spawn:SetAngles( Angle( 0, 180, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -600, 172, -136 ) )
			spawn:SetAngles( Angle( 0, 180, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -738, 71, -136 ) )
			spawn:SetAngles( Angle( 0, 0, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -508, -24, -136 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -416, 56, -136 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -524, 86, -136 ) )
			spawn:SetAngles( Angle( 0, 0, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -728, -150, 0 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -560, -128, 0 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_terrorist" )
			spawn:SetPos( Vector( -640, -58, 0 ) )
			spawn:SetAngles( Angle( 0, 90, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -2519, -770, -68 ) )
			spawn:SetAngles( Angle( 0, 30, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -2450, 1770, -68 ) )
			spawn:SetAngles( Angle( 0, -30, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( 1260, 1955, -68 ) )
			spawn:SetAngles( Angle( 0, -130, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( 1108, -929, -68 ) )
			spawn:SetAngles( Angle( 0, 130, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -2466, -160, -68 ) )
			spawn:SetAngles( Angle( 0, 36, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( -2453, 1168, -68 ) )
			spawn:SetAngles( Angle( 0, -30, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( 990, 937, -68 ) )
			spawn:SetAngles( Angle( 0, -140, 0 ) )
			spawn:Spawn()
			
			spawn = ents.Create( "info_player_counterterrorist" )
			spawn:SetPos( Vector( 1111, 150, -68 ) )
			spawn:SetAngles( Angle( 0, 130, 0 ) )
			spawn:Spawn()
			
			GAMEMODE.Vars.mapoverrideok = true
			
		elseif !GAMEMODE.Vars.mapoverrideok then
			
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
			
			GAMEMODE.Vars.mapoverrideok = true
			MsgC( Color( 255, 255, 85 ), "FNAFGM: There is no map overrides for this map...\n" )
			
		end
		
		MsgC( Color( 255, 255, 85 ), "FNAFGM: Map overrides done\n" )
		
	end
	
end



function fnafgmVarsUpdate()
	
	net.Start( "fnafgmVarsUpdate" )
		net.WriteBit( GAMEMODE.Vars.startday )
		net.WriteBit( GAMEMODE.Vars.gameend )
		net.WriteBit( GAMEMODE.Vars.iniok )
		net.WriteInt( GAMEMODE.Vars.time, 5 )
		net.WriteString( GAMEMODE.Vars.AMPM )
		net.WriteInt( GAMEMODE.Vars.night, 32 )
		net.WriteBit( GAMEMODE.Vars.nightpassed )
		net.WriteBit( GAMEMODE.Vars.tempostart )
		net.WriteBit( GAMEMODE.Vars.mute )
		net.WriteBit( GAMEMODE.Vars.overfive )
	net.Broadcast()
	
end


function fnafgmTimeThink()
	
	if (GAMEMODE.Vars.time == 12 and GAMEMODE.Vars.AMPM == "AM") then
		GAMEMODE.Vars.time = 1
	elseif (GAMEMODE.Vars.time == 11 and GAMEMODE.Vars.AMPM == "AM") then
		GAMEMODE.Vars.time = 12
		GAMEMODE.Vars.AMPM = "PM"
	elseif (GAMEMODE.Vars.time == 11 and GAMEMODE.Vars.AMPM == "PM") then
		GAMEMODE.Vars.time = 12
		GAMEMODE.Vars.AMPM = "AM"
		GAMEMODE.Vars.night = GAMEMODE.Vars.night+1
	elseif (GAMEMODE.Vars.time == 12 and GAMEMODE.Vars.AMPM == "PM") then
		GAMEMODE.Vars.time = 1
	else
		GAMEMODE.Vars.time = GAMEMODE.Vars.time+1
	end
	
	MsgC( Color( 255, 255, 85 ), "FNAFGM: "..GAMEMODE.Vars.time..GAMEMODE.Vars.AMPM.." (Power left: "..GAMEMODE.Vars.power.."%)\n" )
	
	if (GAMEMODE.Vars.time == GAMEMODE.TimeEnd and GAMEMODE.Vars.night >= GAMEMODE.NightEnd and GAMEMODE.Vars.AMPM == GAMEMODE.AMPM_End and !fnafgm_timethink_infinitenights:GetBool()) then
		
		MsgC( Color( 255, 255, 85 ), "FNAFGM: Last night passed ("..GAMEMODE.Vars.night..") (Power left: "..GAMEMODE.Vars.power.."%)\n" )
		GAMEMODE.Vars.startday = false
		GAMEMODE.Vars.gameend = true
		timer.Remove("fnafgmTimeThink")
		timer.Remove("fnafgmPowerOff1")
		timer.Remove("fnafgmPowerOff2")
		timer.Remove("fnafgmPowerOff3")
		GAMEMODE.Vars.poweroff = false
		GAMEMODE.Vars.powerchecktime=nil
		GAMEMODE.Vars.oldpowerdrain=nil
		GAMEMODE.Vars.foxyknockdoorpena = 2
		GAMEMODE.Vars.addfoxyknockdoorpena = 4
		table.Empty(GAMEMODE.Vars.tabused)
		table.Empty(GAMEMODE.Vars.usingsafedoor)
		for k, v in pairs(player.GetAll()) do
			if v:GetViewEntity()!=v then
				v:SetViewEntity(v)
			end
			if v:Team()==1 then v:ConCommand( "pp_mat_overlay ''" ) end
		end
		game.CleanUpMap()
		
		if GAMEMODE.Vars.night > GAMEMODE.NightEnd then
			GAMEMODE.Vars.overfive = true
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
			v:SendLua([[GAMEMODE:SaveProgress()]])
		end
		
		if game.IsDedicated() then GAMEMODE:SaveProgress() end
		
		timer.Create( "fnafgmNightPassed", 11, 1, function()
			
			fnafgmResetGame()
			if !game.IsDedicated() then GAMEMODE.Vars.night = GAMEMODE.NightEnd end
			fnafgmMapOverrides()
			
			if GAMEMODE.Materials_end[game.GetMap()] or file.Exists( "materials/"..string.lower(GAMEMODE.ShortName).."/endscreen/"..game.GetMap().."_en"..".vmt", "GAME" ) or file.Exists( "materials/fnafgm/endscreen/"..game.GetMap().."_en"..".vmt", "GAME" ) then
				
				local plus = false
				if GAMEMODE.Vars.night>GAMEMODE.NightEnd then
					plus = true
				end
				
				net.Start( "fnafgmShowCheck" )
					net.WriteBit(true)
					net.WriteBit(plus)
				net.Broadcast()
				
				for k, v in pairs(player.GetAll()) do
					
					v:ScreenFade(16, color_black, 0, 0 )
					
					if v:Team()==1 or v:Team()==2 then
						
						v:SetTeam(TEAM_UNASSIGNED)
						
						if GAMEMODE.Sound_end[game.GetMap()] then
							v:ConCommand("play "..GAMEMODE.Sound_end[game.GetMap()])
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
			
			GAMEMODE.Vars.gameend = false
			GAMEMODE.Vars.norespawn = false
			fnafgmVarsUpdate()
			if GAMEMODE.Vars.night==GAMEMODE.NightEnd then
				MsgC( Color( 255, 255, 85 ), "FNAFGM: Ready to start the hell!\n" )
			else
				MsgC( Color( 255, 255, 85 ), "FNAFGM: Ready to start a new week!\n" )
			end
			timer.Remove("fnafgmNightPassed")
		
		end)
		
	elseif (GAMEMODE.Vars.time == GAMEMODE.TimeEnd and GAMEMODE.Vars.AMPM == GAMEMODE.AMPM_End and !fnafgm_timethink_endlesstime:GetBool()) then
		
		MsgC( Color( 255, 255, 85 ), "FNAFGM: Night "..GAMEMODE.Vars.night.." passed (Power left: "..GAMEMODE.Vars.power.."%)\n" )
		GAMEMODE.Vars.startday = false
		GAMEMODE.Vars.nightpassed = true
		timer.Remove("fnafgmTimeThink")
		timer.Remove("fnafgmPowerOff1")
		timer.Remove("fnafgmPowerOff2")
		timer.Remove("fnafgmPowerOff3")
		GAMEMODE.Vars.powerchecktime=nil
		GAMEMODE.Vars.oldpowerdrain=nil
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
			v:SendLua([[GAMEMODE:SaveProgress()]])
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
			
			GAMEMODE.Vars.nightpassed = false
			GAMEMODE.Vars.norespawn = false
			fnafgmVarsUpdate()
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Ready to start a new night\n" )
			timer.Remove("fnafgmNightPassed")
			
		end)
	
	end
	
	fnafgmVarsUpdate()
	
end


function GM:FinishMove( ply, mv )
	
	local userid = ply:UserID()
	
	if fnafgm_killextsrplayers:GetBool() and GAMEMODE:CheckPlayerSecurityRoom(ply)!=nil then
	
		if GAMEMODE:CheckPlayerSecurityRoom(ply) or !ply:Alive() then
			
			if timer.Exists( "fnafgmPlayerSecurityRoomNot"..userid ) then
				timer.Remove( "fnafgmPlayerSecurityRoomNot"..userid )
			end
			
		elseif !GAMEMODE:CheckPlayerSecurityRoom(ply) and !timer.Exists( "fnafgmPlayerSecurityRoomNot"..userid ) and ply:Alive() and GAMEMODE.Vars.startday and !GAMEMODE.Vars.tempostart and ply:Team()==1 and !fnafgmPlayerCanByPass(ply,"nokillextsr") then
			
			local PSRTT=5
			if game.GetMap()=="fnaf2" then
				PSRTT=21
			end
			
			timer.Create( "fnafgmPlayerSecurityRoomNot"..userid, PSRTT, 1, function()
				
				if (IsValid(ply)) then
					ply:ConCommand("play "..GAMEMODE.Sound_Animatronic[4][1])
					ply:Kill()
					MsgC(Color( 255, 255, 85 ), "FNAFGM: "..ply:GetName().." is dead by the outside!\n")
				end
				
				timer.Remove( "fnafgmPlayerSecurityRoomNot"..userid )
				
			end)
		end
	
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
		ply:PrintMessage(HUD_PRINTCONSOLE, " FNAFGM is mounted from WorkShop? "..tostring(GAMEMODE.Vars.fnafgmWorkShop))
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
		ply:PrintMessage(HUD_PRINTCONSOLE, "  timethink_autostart "..fnafgm_timethink_autostart:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  disablemapsmonitors "..fnafgm_disablemapsmonitors:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  disablepower "..fnafgm_disablepower:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, "  forcesavingloading "..fnafgm_forcesavingloading:GetString())
		ply:PrintMessage(HUD_PRINTCONSOLE, " ")
		ply:PrintMessage(HUD_PRINTCONSOLE, " [-GAME VARS-]")
		for k, v in pairs( GAMEMODE.Vars ) do
			ply:PrintMessage(HUD_PRINTCONSOLE, "  "..tostring(k)..'="'..tostring(v)..'"')
		end
		ply:PrintMessage(HUD_PRINTCONSOLE, " ")
		ply:PrintMessage(HUD_PRINTCONSOLE, " [-Who use PlayerUse Hook-]")
		for k, v in pairs( hook.GetTable()[ "PlayerUse" ] ) do
			ply:PrintMessage(HUD_PRINTCONSOLE, "  "..tostring(k))
		end
		ply:PrintMessage(HUD_PRINTCONSOLE, " ")
	elseif !IsValid(ply) then
		print(" ")
		print("[-DEBUG INFO-]")
		print(" ")
		print(" "..GAMEMODE.Name.." Gamemode V"..tostring(GAMEMODE.Version or "error").." by "..GAMEMODE.Author)
		if !GAMEMODE.Official then print(" Derived from Five Nights at Freddy's Gamemode V"..tostring(GAMEMODE.OfficialVersion or "error").." by Xperidia") end
		print(" FNAFGM is mounted from WorkShop? "..tostring(GAMEMODE.Vars.fnafgmWorkShop))
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
		print("  timethink_autostart "..fnafgm_timethink_autostart:GetString())
		print("  disablemapsmonitors "..fnafgm_disablemapsmonitors:GetString())
		print("  disablepower "..fnafgm_disablepower:GetString())
		print("  forcesavingloading "..fnafgm_forcesavingloading:GetString())
		print(" ")
		print(" [-GAME VARS-]")
		PrintTable(GAMEMODE.Vars)
		print(" ")
		print(" [-Who use PlayerUse Hook-]")
		PrintTable(hook.GetTable()[ "PlayerUse" ])
		print(" ")
	end
end)


function fnafgmPlayerCanByPass(ply,what)
	
	if !IsValid(ply) then return end
	
	if fnafgm_enablebypass:GetBool() then
		if ply:IsAdmin() then
			return true
		elseif ( GAMEMODE:CheckCreator(ply) or GAMEMODE:CheckDerivCreator(ply) ) and fnafgm_enablecreatorsbypass:GetBool() then
			return true
		elseif GAMEMODE:CustomCheck(ply,what) then
			return true
		else
			return false
		end
	else
		return false
	end
end

function fnafgmCheckUpdate()
	
	net.Start( "fnafgmCheckUpdate" )
		net.WriteBit( GAMEMODE.Vars.updateavailable )
		net.WriteString( GAMEMODE.Vars.lastversion )
	net.Broadcast()
	
end

function fnafgmCheckUpdateD()
	
	net.Start( "fnafgmCheckUpdateD" )
		net.WriteBit( GAMEMODE.Vars.derivupdateavailable )
		net.WriteString( GAMEMODE.Vars.lastderivversion )
	net.Broadcast()
	
end


function fnafgmCheckForNewVersion(ply,util)
	
	if !GAMEMODE.CustomVersion then
		
		http.Fetch( "http://xperidia.com/fnafgmversion.txt",
		function( body, len, headers, code )
			
			GAMEMODE.Vars.lastversion = tonumber(string.Right(body, len-3)) or 0
			
			if GAMEMODE.Vars.lastversion!=0 and GAMEMODE.OfficialVersion == GAMEMODE.Vars.lastversion and code==200 then
				
				if IsValid(ply) and util==true then
					ply:PrintMessage(HUD_PRINTCONSOLE, "FNAFGM: You're on the latest release! V"..GAMEMODE.Vars.lastversion.." = V"..GAMEMODE.OfficialVersion)
				elseif util==true then
					MsgC( Color( 255, 255, 85 ), "FNAFGM: You're on the latest release! V"..GAMEMODE.Vars.lastversion.." = V"..GAMEMODE.OfficialVersion.."\n" )
				end
				GAMEMODE.Vars.updateavailable = false
				
			elseif GAMEMODE.Vars.lastversion!=0 and GAMEMODE.OfficialVersion > GAMEMODE.Vars.lastversion and code==200 then
				
				if IsValid(ply) and util==true then
					ply:PrintMessage(HUD_PRINTCONSOLE, "FNAFGM: You're on a dev build! V"..GAMEMODE.Vars.lastversion.." < V"..GAMEMODE.OfficialVersion)
				elseif util==true then
					MsgC( Color( 255, 255, 85 ), "FNAFGM: You're on a dev build! V"..GAMEMODE.Vars.lastversion.." < V"..GAMEMODE.OfficialVersion.."\n" )
				end
				GAMEMODE.Vars.updateavailable = false
				
			elseif GAMEMODE.Vars.lastversion!=0 and GAMEMODE.OfficialVersion < GAMEMODE.Vars.lastversion and code==200 then
				
				if IsValid(ply) and !ply:IsListenServerHost() then ply:PrintMessage(HUD_PRINTTALK, "FNAFGM: An update is available! V"..GAMEMODE.Vars.lastversion) end
				MsgC( Color( 255, 255, 85 ), "FNAFGM: An update is available! V"..GAMEMODE.Vars.lastversion.."\n" )
				GAMEMODE.Vars.updateavailable = true
				
			elseif GAMEMODE.Vars.lastversion==0 and code==200 then
				
				ErrorNoHalt( "FNAFGM: Failed to check the version (Bad content or version 0)\n" )
				
				if IsValid(ply) then
					ply:PrintMessage(HUD_PRINTCONSOLE, "FNAFGM: Failed to check the version (Bad content or version 0)")
				else
					MsgC( Color( 255, 255, 85 ), "FNAFGM: Failed to check the version (Bad content or version 0)\n" )
				end
				
			else
				
				if IsValid(ply) then
					ply:PrintMessage(HUD_PRINTCONSOLE, "FNAFGM: Failed to check the version (Error "..tostring(code or "?")..")")
				else
					MsgC( Color( 255, 255, 85 ), "FNAFGM: Failed to check the version (Error "..tostring(code or "?")..")\n" )
				end
				
			end
			
			fnafgmCheckUpdate()
			
		end,
		function( error )
			
			ErrorNoHalt( "FNAFGM: Failed to check the version (Bad address/No connection)\n" )
			
			if IsValid(ply) then
				ply:PrintMessage(HUD_PRINTCONSOLE, "FNAFGM: Failed to check the version (Bad address/No connection)")
			else
				MsgC( Color( 255, 255, 85 ), "FNAFGM: Failed to check the version (Bad address/No connection)\n" )
			end
			
		end
	
		);
		
	end
	
	if !GAMEMODE.Official and GAMEMODE.CustomVersionChecker!="" then
		
		http.Fetch( GAMEMODE.CustomVersionChecker,
		function( body, len, headers, code )
			
			GAMEMODE.Vars.lastderivversion = tonumber(string.Right(body, len-3)) or 0
			
			if GAMEMODE.Vars.lastderivversion!=0 and GAMEMODE.Version == GAMEMODE.Vars.lastderivversion and code==200 then
				
				if IsValid(ply) and util==true then
					ply:PrintMessage(HUD_PRINTCONSOLE, GAMEMODE.ShortName..": You're on the latest release! V"..GAMEMODE.Vars.lastderivversion.." = V"..GAMEMODE.Version)
				elseif util==true then
					MsgC( Color( 255, 255, 85 ), GAMEMODE.ShortName..": You're on the latest release! V"..GAMEMODE.Vars.lastderivversion.." = V"..GAMEMODE.Version.."\n" )
				end
				GAMEMODE.Vars.derivupdateavailable = false
				
			elseif GAMEMODE.Vars.lastderivversion!=0 and GAMEMODE.Version > GAMEMODE.Vars.lastderivversion and code==200 then
				
				if IsValid(ply) and util==true then
					ply:PrintMessage(HUD_PRINTCONSOLE, GAMEMODE.ShortName..": You're on a dev build! V"..GAMEMODE.Vars.lastderivversion.." < V"..GAMEMODE.Version)
				elseif util==true then
					MsgC( Color( 255, 255, 85 ), GAMEMODE.ShortName..": You're on a dev build! V"..GAMEMODE.Vars.lastderivversion.." < V"..GAMEMODE.Version.."\n" )
				end
				GAMEMODE.Vars.derivupdateavailable = false
				
			elseif GAMEMODE.Vars.lastderivversion!=0 and GAMEMODE.Version < GAMEMODE.Vars.lastderivversion and code==200 then
				
				if IsValid(ply) and !ply:IsListenServerHost() then ply:PrintMessage(HUD_PRINTTALK, GAMEMODE.ShortName..": An update is available! V"..GAMEMODE.Vars.lastderivversion) end
				MsgC( Color( 255, 255, 85 ), GAMEMODE.ShortName..": An update is available! V"..GAMEMODE.Vars.lastderivversion.."\n" )
				GAMEMODE.Vars.derivupdateavailable = true
				
			elseif GAMEMODE.Vars.lastderivversion==0 and code==200 then
				
				ErrorNoHalt( GAMEMODE.ShortName..": Failed to check the version (Bad content or version 0)\n" )
				
				if IsValid(ply) then
					ply:PrintMessage(HUD_PRINTCONSOLE, GAMEMODE.ShortName..": Failed to check the version (Bad content or version 0)")
				else
					MsgC( Color( 255, 255, 85 ), GAMEMODE.ShortName..": Failed to check the version (Bad content or version 0)\n" )
				end
				
			else
				
				if IsValid(ply) then
					ply:PrintMessage(HUD_PRINTCONSOLE, GAMEMODE.ShortName..": Failed to check the version (Error "..tostring(code or "?")..")")
				else
					MsgC( Color( 255, 255, 85 ), GAMEMODE.ShortName..": Failed to check the version (Error "..tostring(code or "?")..")\n" )
				end
				
			end
			
			fnafgmCheckUpdateD()
			
		end,
		function( error )
			
			ErrorNoHalt( GAMEMODE.ShortName..": Failed to check the version (Bad address?)\n" )
			
			if IsValid(ply) then
				ply:PrintMessage(HUD_PRINTCONSOLE, GAMEMODE.ShortName..": Failed to check the version (Bad address?)")
			else
				MsgC( Color( 255, 255, 85 ), GAMEMODE.ShortName..": Failed to check the version (Bad address?)\n" )
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
	else
		call = ents.FindByName( "fnafgm_CallButton" )[1]
		if ( IsValid(call) ) then
			call:Fire( "use" )
		end
	end
end
net.Receive( "fnafgmMuteCall",function(bits,ply)
	fnafgmMuteCall()
end )


function fnafgmSafeZone(ply)
	
	if !IsValid(ply) then return end
	
	if !GAMEMODE.Vars.usingsafedoor[ply] then
			
		ply:SetPos( Vector( -46, -450, 0 ) )
		
		if IsValid(SafeZoneCam) then
			ply:SetViewEntity( SafeZoneCam )
		end
		
		ply:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_fnaf2deathcam )
		
		GAMEMODE.Vars.usingsafedoor[ply]=true
		
	elseif GAMEMODE.Vars.usingsafedoor[ply] then
		
		ply:SetPos( GAMEMODE.FNaFView[game.GetMap()][1] )
		ply:SetEyeAngles( GAMEMODE.FNaFView[game.GetMap()][2] )
		
		ply:SetViewEntity( ply )
		
		ply:ConCommand( "pp_mat_overlay ''" )
		
		GAMEMODE.Vars.usingsafedoor[ply]=false
		
	end
	
end
net.Receive( "fnafgmSafeZone",function(bits,ply)
	fnafgmSafeZone(ply)
end )


function fnafgmShutLights()
	
	if game.GetMap()=="fnaf2" then return end
	
	if light1 and IsValid(light1) and GAMEMODE.Vars.LightUse[1] then
		if game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent" then GAMEMODE.Vars.LightUse[1] = !GAMEMODE.Vars.LightUse[1] end
		light1:Fire("use")
	end
	
	if light2 and IsValid(light2) and GAMEMODE.Vars.LightUse[2] then
		if game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent" then GAMEMODE.Vars.LightUse[2] = !GAMEMODE.Vars.LightUse[2] end
		light2:Fire("use")
	end
	
end
net.Receive( "fnafgmShutLights",function(bits,ply)
	fnafgmShutLights()
end )

function fnafgmUseLight(id)
	
	if id==1 and light1 and IsValid(light1) and !GAMEMODE.Vars.light1usewait then
		GAMEMODE.Vars.LightUse[1] = !GAMEMODE.Vars.LightUse[1]
		light1:Fire("use")
	elseif id==2 and light2 and IsValid(light2) and !GAMEMODE.Vars.light2usewait then
		GAMEMODE.Vars.LightUse[2] = !GAMEMODE.Vars.LightUse[2]
		light2:Fire("use")
	elseif id==3 and light3 and IsValid(light3) and !GAMEMODE.Vars.light3usewait then
		GAMEMODE.Vars.LightUse[3] = !GAMEMODE.Vars.LightUse[3]
		light3:Fire("use")
	end
	
end
net.Receive( "fnafgmUseLight",function(bits,ply)
	local id = net.ReadFloat()
	if (!id) then return end
	fnafgmUseLight(id)
end)


concommand.Add("fnafgm_debug_start", function(ply)
	
	fnafgmUse(ply, nil, true)
	
end)


concommand.Add("fnafgm_debug_reset", function(ply)
	
	if (IsValid(ply) and fnafgmPlayerCanByPass(ply,"debug")) or !IsValid(ply) then
		fnafgmResetGame()
		fnafgmMapOverrides()
		fnafgmVarsUpdate()
		net.Start( "fnafgmNotif" )
			net.WriteString( "The game has been reset" )
			net.WriteInt(4,3)
			net.WriteFloat(5)
			net.WriteBit(true)
		net.Broadcast()
		if IsValid(ply) then
			MsgC( Color( 255, 255, 85 ), "FNAFGM: The game has been reset by "..ply:GetName().."\n" )
		else
			MsgC( Color( 255, 255, 85 ), "FNAFGM: The game has been reset by console\n" )
		end
	
	elseif IsValid(ply) then
		
		ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! (Need debug access)")
		
		net.Start( "fnafgmNotif" )
			net.WriteString( "Nope, you can't do that! (Need debug access)" )
			net.WriteInt(1,3)
			net.WriteFloat(5)
			net.WriteBit(true)
		net.Send(ply)
		
	end
	
end)


concommand.Add("fnafgm_debug_refreshbypass", function(ply)
	
	if (IsValid(ply) and fnafgmPlayerCanByPass(ply,"debug")) or !IsValid(ply) then
		GAMEMODE:RefreshBypass()
	end
	
end)


concommand.Add("fnafgm_debug_restart", function(ply)
	
	if (IsValid(ply) and fnafgmPlayerCanByPass(ply,"debug")) or !IsValid(ply) then
		
		if (GAMEMODE.Vars.iniok and GAMEMODE.Vars.mapoverrideok and GAMEMODE.Vars.startday and GAMEMODE.Vars.active) then
			
			GAMEMODE.Vars.norespawn=true
			
			for k, v in pairs(player.GetAll()) do
				if (v:Team()==1 or v:Team()==2) and v:Alive() then
					v:KillSilent()
				end
			end
			
			if IsValid(ply) then
				MsgC( Color( 255, 255, 85 ), "FNAFGM: The game will be stoped/restarted by "..ply:GetName().."\n" )
			else
				MsgC( Color( 255, 255, 85 ), "FNAFGM: The game will be stoped/restarted by console\n" )
			end
			
		end
	
	elseif IsValid(ply) then
		
		ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! (Need debug access)")
		
		net.Start( "fnafgmNotif" )
			net.WriteString( "Nope, you can't do that! (Need debug access)" )
			net.WriteInt(1,3)
			net.WriteFloat(5)
			net.WriteBit(true)
		net.Send(ply)
		
	end
	
end)


function GM:PlayerSwitchFlashlight(ply, on)
	
	if !on then
		
		return true
		
	end
	
	if ( ( ply:Team()==1 and fnafgm_allowflashlight:GetBool() ) or fnafgmPlayerCanByPass(ply,"flashlight") ) then
		
		return true
		
	end
	
	if (game.GetMap()=="fnaf2" and !GAMEMODE.Vars.poweroff) then
		
		return true
		
	end
	
	if (game.GetMap()=="fnaf2" and GAMEMODE.Vars.poweroff) then
	
		ply:ConCommand("play "..GAMEMODE.Sound_lighterror)
		
	end
	
	return false
	
end





function GM:PlayerSay( ply, text, teamonly )
	
	comm = string.lower( text )
	
	if ( comm == "!start" ) then
		fnafgmUse(ply, nil, true)
	elseif ( comm == "/start" ) then
		fnafgmUse(ply, nil, true)
		return ""
	elseif ( comm == "!"..string.lower(GAMEMODE.ShortName) ) then
		ply:SendLua([[fnafgmMenu()]])
	elseif ( comm == "/"..string.lower(GAMEMODE.ShortName) ) then
		ply:SendLua([[fnafgmMenu()]])
		return ""
	end
	
	return text

end


function GM:Think()
	
	hook.Call("fnafgmCustomPowerCalc")
	
	if GAMEMODE.Vars.iniok and GAMEMODE.Vars.mapoverrideok and GAMEMODE.Vars.startday and GAMEMODE.Vars.active and (game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent") then
		
		GAMEMODE.Vars.powerusage = GAMEMODE.Power_Usage_Base
		
		if GAMEMODE.Vars.poweroff then
			
			GAMEMODE.Vars.powerusage = 0
			
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
				
				if GAMEMODE.Vars.tabused[v] and GAMEMODE.Vars.tabused[v]==true then
						
					tabactualuse = true
					
				end
				
			end
			
			if tabactualuse then -- Tab use
				
				GAMEMODE.Vars.powerusage = GAMEMODE.Vars.powerusage+1
				
			end
			
			
			if door1:GetPos()==Vector(-164.000000, -1168.000000, 112.000000) then -- Door 1 use
				
				GAMEMODE.Vars.powerusage = GAMEMODE.Vars.powerusage+1
				
			end
			
			
			if door2:GetPos()==Vector(4.000000, -1168.000000, 112.000000) then -- Door 2 use
				
				GAMEMODE.Vars.powerusage = GAMEMODE.Vars.powerusage+1
				
			end
			
			
			if GAMEMODE.Vars.LightUse[1] or GAMEMODE.Vars.LightUse[2] then -- Lights use
				
				GAMEMODE.Vars.powerusage = GAMEMODE.Vars.powerusage+1
				
			end
			
			
			if GAMEMODE.Vars.AprilFool or fnafgm_forceseasonalevent:GetInt()==2 then -- Troll use
				
				GAMEMODE.Vars.powerusage = GAMEMODE.Vars.powerusage+5
				
			end
			
			
		end
		
		if fnafgm_disablepower:GetBool() then
			GAMEMODE.Vars.powerusage = 0
		end
		
		if GAMEMODE.Vars.powerusage==0 then
			
			GAMEMODE.Vars.powerdrain = 0
			
		else
			
			GAMEMODE.Vars.powerdrain = GAMEMODE.Power_Drain_Time
		
			for i=1, GAMEMODE.Vars.powerusage-1 do
				GAMEMODE.Vars.powerdrain = GAMEMODE.Vars.powerdrain/2
			end
			
			if GAMEMODE.Vars.powerchecktime==nil and GAMEMODE.Vars.oldpowerdrain==nil and !GAMEMODE.Vars.poweroff then
				
				GAMEMODE.Vars.powerchecktime = CurTime()+GAMEMODE.Vars.powerdrain
				GAMEMODE.Vars.oldpowerdrain = GAMEMODE.Vars.powerdrain
				
			elseif GAMEMODE.Vars.powerchecktime!=nil and GAMEMODE.Vars.oldpowerdrain!=nil and !GAMEMODE.Vars.poweroff then
				
				local calcchangepower = GAMEMODE.Vars.oldpowerdrain-GAMEMODE.Vars.powerdrain
				
				if GAMEMODE.Vars.powerchecktime<=CurTime()+calcchangepower then
					
					GAMEMODE.Vars.powerchecktime=nil
					GAMEMODE.Vars.oldpowerdrain=nil
					GAMEMODE.Vars.power = GAMEMODE.Vars.power-1
					ents.FindByName( "Powerlvl" )[1]:Fire("SetValue", 100)
				
				end
				
			end
		
		end
		
		if GAMEMODE.Vars.power<=0 and !GAMEMODE.Vars.poweroff then
			
			GAMEMODE.Vars.power=0
			
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
				
				if IsValid(ents.FindByName( "FreddyOfficeRelay" )[1]) then ents.FindByName( "FreddyOfficeRelay" )[1]:Fire("Trigger") end
				if IsValid(ents.FindByName( "ChicaOfficeRelay" )[1]) then ents.FindByName( "ChicaOfficeRelay" )[1]:Fire("Trigger") end
				if IsValid(ents.FindByName( "BonnieOfficeRelay" )[1]) then ents.FindByName( "BonnieOfficeRelay" )[1]:Fire("Trigger") end
				if IsValid(ents.FindByName( "FoxyTime" )[1]) then ents.FindByName( "FoxyTime" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "foxytest" )[1]) then ents.FindByName( "foxytest" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "foxytest2" )[1]) then ents.FindByName( "foxytest2" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "FoxyKilledYou" )[1]) then ents.FindByName( "FoxyKilledYou" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "foxydeath" )[1]) then ents.FindByName( "foxydeath" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "EventTimer" )[1]) then ents.FindByName( "EventTimer" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "EventTimer2" )[1]) then ents.FindByName( "EventTimer2" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "BonnieDeath" )[1]) then ents.FindByName( "BonnieDeath" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "bonnietest" )[1]) then ents.FindByName( "bonnietest" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "ChicaOffice" )[1]) then ents.FindByName( "ChicaOffice" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "ChicaDeath" )[1]) then ents.FindByName( "ChicaDeath" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "chicatest" )[1]) then ents.FindByName( "chicatest" )[1]:Fire("Kill") end
				
				timer.Create( "fnafgmPowerOff1", 5, 1, function()
					if IsValid(ents.FindByName( "FreddyOffice" )[1]) then ents.FindByName( "FreddyOffice" )[1]:SetPos(Vector( -193, -1115, 65 )) end
					if IsValid(ents.FindByName( "FreddyOffice" )[1]) then ents.FindByName( "FreddyOffice" )[1]:SetAngles(Angle( 0, 0, 35 )) end
					if IsValid(ents.FindByName( "FreddyOffice" )[1]) then ents.FindByName( "FreddyOffice" )[1]:Fire("Enable") end
					if IsValid(ents.FindByName( "FreddyOffice" )[1]) then ents.FindByName( "FreddyOffice" )[1]:Fire("EnableCollision") end
					if IsValid(ents.FindByName( "BonnieOffice" )[1]) then ents.FindByName( "BonnieOffice" )[1]:SetPos(Vector( 43, -1171, 65 )) end
					if IsValid(ents.FindByName( "BonnieOffice" )[1]) then ents.FindByName( "BonnieOffice" )[1]:SetAngles(Angle( 0, 180, 0 )) end
					if IsValid(ents.FindByName( "BonnieOffice" )[1]) then ents.FindByName( "BonnieOffice" )[1]:Fire("EnableCollision") end
					for k, v in pairs(team.GetPlayers(1)) do
						v:ConCommand("play ".."freddys/muffledtune.wav")
						if v:Alive() and !GAMEMODE:CheckPlayerSecurityRoom(v) then
							v:SetPos( Vector( -80, -1224, 64 ) )
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
					if IsValid(ents.FindByName( "FreddyDeath" )[1]) then ents.FindByName( "FreddyDeath" )[1]:Fire("Trigger") end
					if IsValid(ents.FindByName( "freddytest" )[1]) then ents.FindByName( "freddytest" )[1]:Fire("Trigger") end
					for k, v in pairs(team.GetPlayers(1)) do
						if v:Alive() then
							v:KillSilent()
						end
					end
					timer.Remove("fnafgmPowerOff3")
				end)
				
			end
			
			GAMEMODE.Vars.poweroff = true
			GAMEMODE.Vars.norespawn = true
			MsgC( Color( 255, 255, 85 ), "FNAFGM: The power is gone :)\n" )
		end
		
		fnafgmPowerUpdate()
		
	elseif GAMEMODE.Vars.iniok and GAMEMODE.Vars.mapoverrideok and GAMEMODE.Vars.startday and GAMEMODE.Vars.active and (game.GetMap()=="fnaf2") then
		
		GAMEMODE.Vars.powerusage = 0
		
		if !GAMEMODE.Vars.poweroff then
			
				
			if GAMEMODE.Vars.LightUse[1] or GAMEMODE.Vars.LightUse[2] or GAMEMODE.Vars.LightUse[3] then -- Lights use
				
				GAMEMODE.Vars.powerusage = GAMEMODE.Vars.powerusage + 1
				
			end
			
			for k, v in pairs(team.GetPlayers(1)) do
				
				if v:FlashlightIsOn() then
						
					GAMEMODE.Vars.powerusage = GAMEMODE.Vars.powerusage + 1
					
				end
				
			end
			
			
		end
		
		if GAMEMODE.Vars.powerusage==0 or !GAMEMODE.Vars.powerchecktime then
			
			GAMEMODE.Vars.powerchecktime = CurTime()+1
			
		else
			
			if GAMEMODE.Vars.powerchecktime<=CurTime() then
				
				GAMEMODE.Vars.powerchecktime = CurTime()+1
				GAMEMODE.Vars.power = GAMEMODE.Vars.power-1
				
			end
		
		end
		
		if GAMEMODE.Vars.power==0 and !GAMEMODE.Vars.poweroff then
			
			GAMEMODE.Vars.poweroff = true
			
			for k, v in pairs(team.GetPlayers(1)) do
				
				if v:FlashlightIsOn() and !fnafgmPlayerCanByPass(v,"flashlight") then
						
					v:Flashlight( false )
					
					v:ConCommand("play "..GAMEMODE.Sound_lighterror)
					
				end
				
			end
			
			MsgC( Color( 255, 255, 85 ), "FNAFGM: The battery is dead\n" )
			
		end
		
		fnafgmPowerUpdate()
		
	end
	
	if !game.SinglePlayer() and !GAMEMODE.Vars.checkRestartNight and GAMEMODE.Vars.iniok and GAMEMODE.Vars.mapoverrideok and GAMEMODE.Vars.startday and GAMEMODE.Vars.active then
		
		GAMEMODE.Vars.checkRestartNight=true
		
		local alive = false
		
		for k, v in pairs(player.GetAll()) do
			if v:Alive() and v:Team()==1 then
				alive = true
			end
		end

		if !alive then
			
			GAMEMODE.Vars.norespawn=true
			
			net.Start( "fnafgmNotif" )
				net.WriteString( "The "..tostring(GAMEMODE.TranslatedStrings.night or GAMEMODE.Strings.en.night).." will be reset in "..fnafgm_deathscreendelay:GetInt()+fnafgm_deathscreenduration:GetInt()+fnafgm_respawndelay:GetInt().."s..." )
				net.WriteInt(0,3)
				net.WriteFloat(5)
				net.WriteBit(true)
			net.Broadcast()
			MsgC( Color( 255, 255, 85 ), "FNAFGM: The security guards are dead, the night will be reset\n" )
			
			if game.GetMap()=="freddys" and !GAMEMODE.Vars.poweroff then
				if IsValid(ents.FindByName( "FoxyTime" )[1]) then ents.FindByName( "FoxyTime" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "foxytest" )[1]) then ents.FindByName( "foxytest" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "foxytest2" )[1]) then ents.FindByName( "foxytest2" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "FoxyKilledYou" )[1]) then ents.FindByName( "FoxyKilledYou" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "foxydeath" )[1]) then ents.FindByName( "foxydeath" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "EventTimer" )[1]) then ents.FindByName( "EventTimer" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "EventTimer2" )[1]) then ents.FindByName( "EventTimer2" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "FreddyDeath" )[1]) then ents.FindByName( "FreddyDeath" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "FreddyOffice" )[1]) then ents.FindByName( "FreddyOffice" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "freddytest" )[1]) then ents.FindByName( "freddytest" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "BonnieOffice" )[1]) then ents.FindByName( "BonnieOffice" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "BonnieDeath" )[1]) then ents.FindByName( "BonnieDeath" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "bonnietest" )[1]) then ents.FindByName( "bonnietest" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "ChicaOffice" )[1]) then ents.FindByName( "ChicaOffice" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "ChicaDeath" )[1]) then ents.FindByName( "ChicaDeath" )[1]:Fire("Kill") end
				if IsValid(ents.FindByName( "chicatest" )[1]) then ents.FindByName( "chicatest" )[1]:Fire("Kill") end
			end
			
			hook.Call("fnafgmGeneralDeath")
			
			timer.Remove("fnafgmTimeThink")
			timer.Remove("fnafgmPowerOff1")
			timer.Remove("fnafgmPowerOff2")
			timer.Remove("fnafgmPowerOff3")
			
			timer.Create( "fnafgmPreRestartNight", fnafgm_deathscreendelay:GetInt()+fnafgm_deathscreenduration:GetInt()+fnafgm_respawndelay:GetInt(), 1, function()
				
				for k, v in pairs(player.GetAll()) do
					if (v:Team()==1 or v:Team()==2) and v:Alive() then
						v:KillSilent()
					end
				end
				
				timer.Remove( "fnafgmPreRestartNight" )
				
			end)
			
			timer.Create( "fnafgmRestartNight", fnafgm_deathscreendelay:GetInt()+fnafgm_deathscreenduration:GetInt()+fnafgm_respawndelay:GetInt()+0.1, 1, function()
				
				fnafgmRestartNight()
				
				timer.Remove( "fnafgmRestartNight" )
				
			end)
			
		else
			GAMEMODE.Vars.checkRestartNight=false
		end
		
	end
	
	
end


function fnafgmPowerUpdate()
	
	net.Start( "fnafgmPowerUpdate" )
		net.WriteInt( GAMEMODE.Vars.power, 20 )
		net.WriteInt( GAMEMODE.Vars.powerusage, 6 )
		net.WriteBit( GAMEMODE.Vars.poweroff )
		net.WriteInt( GAMEMODE.Vars.powertot, 16 )
	net.Broadcast()
	
end


net.Receive( "fnafgmTabUsed", function( len, ply )
	
	GAMEMODE.Vars.tabused[ply] = tobool(net.ReadBit())
	
end)


net.Receive( "fnafgmfnafViewActive", function( len, ply )
	
	ply.fnafviewactive = tobool(net.ReadBit())
	
end)



function GM:PlayerShouldTaunt( ply, actid )

	if fnafgmPlayerCanByPass(ply,"act") then
		return true
	end
	
	ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! (Need act bypass)")
	
	net.Start( "fnafgmNotif" )
		net.WriteString( "Nope, you can't do that! (Need act bypass)" )
		net.WriteInt(1,3)
		net.WriteFloat(5)
		net.WriteBit(true)
	net.Send(ply)
	
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


function GM:ShutDown()
	for k, v in pairs(player.GetAll()) do
		if v:GetViewEntity()!=v then
			v:SetViewEntity(v)
		end
	end
end


concommand.Add( "fnafgm_debug_createcamera", function( ply,str )
	
	if (IsValid(ply) and fnafgmPlayerCanByPass(ply,"debug")) then
		
		GAMEMODE:CreateCamera(nil,nil,nil,nil,nil,nil,ply)
	
	elseif IsValid(ply) then
		
		ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! (Need debug access)")
		
		net.Start( "fnafgmNotif" )
			net.WriteString( "Nope, you can't do that! (Need debug access)" )
			net.WriteInt(1,3)
			net.WriteFloat(5)
			net.WriteBit(true)
		net.Send(ply)
		
	end
	
end)
function GM:CreateCamera(x,y,z,pitch,yaw,roll,ply)
	local num = table.Count(ents.FindByClass( "fnafgm_camera" ))+1
	local pos = Vector(x,y,z)
	local angles = Angle(pitch,yaw,roll)
	if IsValid(ply) then
		pos = ply:GetPos()
		angles = ply:GetAngles()
	end
	local CAM = ents.Create("fnafgm_camera")
	CAM:SetPos(pos)
	CAM:SetAngles(angles)
	CAM:SetName("fnafgm_Cam"..num)
	CAM:Spawn()
	if IsValid(ply) then
		MsgC( Color( 255, 255, 85 ), "FNAFGM: fnafgm_Cam"..num.." created by "..ply:GetName().."\n" )
	else
		MsgC( Color( 255, 255, 85 ), "FNAFGM: fnafgm_Cam"..num.." created by console/script\n" )
	end
end


concommand.Add( "fnafgm_debug_createanimatronic", function(ply,str,tbl,str)
	
	if (IsValid(ply) and fnafgmPlayerCanByPass(ply,"debug")) then
		
		GAMEMODE:CreateAnimatronic(tonumber(tbl[1] or 0), tonumber(tbl[2] or 7), ply)
	
	elseif IsValid(ply) then
		
		ply:PrintMessage(HUD_PRINTCONSOLE, "Nope, you can't do that! (Need debug access)")
		
		net.Start( "fnafgmNotif" )
			net.WriteString( "Nope, you can't do that! (Need debug access)" )
			net.WriteInt(1,3)
			net.WriteFloat(5)
			net.WriteBit(true)
		net.Send(ply)
		
	else
		
		GAMEMODE:CreateAnimatronic(tonumber(tbl[1] or 0), tonumber(tbl[2] or 7))
		
	end
	
end, nil, "Create a new Animatronic. Arguments: AType APos")

function GM:CreateAnimatronic(a,apos,ply)
	
	if GAMEMODE.Vars.Animatronics and GAMEMODE.Vars.Animatronics[a] and GAMEMODE.Vars.Animatronics[a][1] and IsValid(GAMEMODE.Vars.Animatronics[a][1]) then GAMEMODE.Vars.Animatronics[a][1]:Remove() end
	
	local ent = ents.Create("fnafgm_animatronic")
	
	if GAMEMODE.AnimatronicAPos[a] and GAMEMODE.AnimatronicAPos[a][game.GetMap()] and GAMEMODE.AnimatronicAPos[a][game.GetMap()][apos] then
		ent:SetPos(GAMEMODE.AnimatronicAPos[a][game.GetMap()][apos][1])
		ent:SetAngles(GAMEMODE.AnimatronicAPos[a][game.GetMap()][apos][2])
	elseif IsValid(ply) then
		ent:SetPos(ply:GetPos() or Vector(0,0,0))
		ent:SetAngles(ply:GetAngles() or Angle(0,0,0))
	end
	
	ent:SetAType(a or 0)
	ent:SetAPos(apos or 7)
	
	if apos != GAMEMODE.APos.freddysnoevent.Office and apos != GAMEMODE.APos.freddysnoevent.Kitchen  and apos != GAMEMODE.APos.freddysnoevent.SS then
		
		local camera = ents.FindByName( "fnafgm_Cam"..apos )[1]
		
		if IsValid(camera) then
			
			ent:SetEyeTarget( camera:EyePos() )
			
		end
		
	end
	
	ent:Spawn()
	
	local cd = 0
	
	if !GAMEMODE.Vars.startday and GAMEMODE.AnimatronicsCD[a][game.GetMap()][GAMEMODE.Vars.night+1] then
		cd = GAMEMODE.AnimatronicsCD[a][game.GetMap()][GAMEMODE.Vars.night+1]
	elseif GAMEMODE.AnimatronicsCD[a][game.GetMap()][GAMEMODE.Vars.night] then
		cd = GAMEMODE.AnimatronicsCD[a][game.GetMap()][GAMEMODE.Vars.night]
	elseif GAMEMODE.AnimatronicsCD[a][game.GetMap()][0] then
		cd = GAMEMODE.AnimatronicsCD[a][game.GetMap()][0]
	end
	
	GAMEMODE.Vars.Animatronics[a] = { ent, apos, cd, 0 }
	
	net.Start( "fnafgmAnimatronicsList" )
		net.WriteTable(GAMEMODE.Vars.Animatronics)
	net.Broadcast()
	
	if IsValid(ply) then
		MsgC( Color( 255, 255, 85 ), "FNAFGM: Animatronic "..(a or 0).." "..(apos or 7).." created by "..ply:GetName().."\n" )
	else
		MsgC( Color( 255, 255, 85 ), "FNAFGM: Animatronic "..(a or 0).." "..(apos or 7).." created by console/script\n" )
	end
	
end


net.Receive( "fnafgmSetAnimatronicPos", function( len, ply )
	
	local a = net.ReadInt(5)
	local apos = net.ReadInt(5)
	
	GAMEMODE:SetAnimatronicPos(ply,a,apos)
	
end)

function GM:SetAnimatronicPos(ply,a,apos)
	
	ent = GAMEMODE.Vars.Animatronics[a][1]
	
	if GAMEMODE.AnimatronicAPos[a] and GAMEMODE.AnimatronicAPos[a][game.GetMap()] and GAMEMODE.AnimatronicAPos[a][game.GetMap()][apos] and IsValid(ent) then
		
		if GAMEMODE.Vars.Animatronics[a][3]==-1 or !GAMEMODE.Vars.startday then return end
		
		if IsValid(ply) and GAMEMODE.Vars.Animatronics[a][2]==GAMEMODE.APos.freddysnoevent.Office then return end
		
		ent:SetAPos(apos or 7)
		
		if apos != GAMEMODE.APos.freddysnoevent.Office and apos != GAMEMODE.APos.freddysnoevent.Kitchen  and apos != GAMEMODE.APos.freddysnoevent.SS then
			
			local camera = ents.FindByName( "fnafgm_Cam"..apos )[1]
			
			if IsValid(camera) then
				
				ent:SetEyeTarget( camera:EyePos() )
				
			end
			
		end
		
		local cd = 0
		
		if !GAMEMODE.Vars.startday and GAMEMODE.AnimatronicsCD[a][game.GetMap()][GAMEMODE.Vars.night+1] then
			cd = GAMEMODE.AnimatronicsCD[a][game.GetMap()][GAMEMODE.Vars.night+1]
		elseif GAMEMODE.AnimatronicsCD[a][game.GetMap()][GAMEMODE.Vars.night] then
			cd = GAMEMODE.AnimatronicsCD[a][game.GetMap()][GAMEMODE.Vars.night]
		elseif GAMEMODE.AnimatronicsCD[a][game.GetMap()][0] then
			cd = GAMEMODE.AnimatronicsCD[a][game.GetMap()][0]
		end
		
		if apos==GAMEMODE.APos.freddysnoevent.Office then
			ent:GoJumpscare()
		elseif GAMEMODE.Vars.Animatronics[a][2]==GAMEMODE.APos.freddysnoevent.Office then
			cd = GAMEMODE.Vars.Animatronics[a][3]
		end
		
		GAMEMODE.Vars.Animatronics[a] = { ent, apos, cd, GAMEMODE.Vars.Animatronics[a][4] }
	
		net.Start( "fnafgmAnimatronicsList" )
			net.WriteTable(GAMEMODE.Vars.Animatronics)
		net.Broadcast()
		
		if IsValid(ply) then
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Animatronic "..(a or 0).." moved to "..(apos or 7).." by "..ply:GetName().."\n" )
		else
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Animatronic "..(a or 0).." moved to "..(apos or 7).." by console/script\n" )
		end
		
	end
	
end


net.Receive( "fnafgmAnimatronicTaunt", function( len, ply )
	
	local a = net.ReadInt(5)
	
	if IsValid(GAMEMODE.Vars.Animatronics[a][1]) then GAMEMODE.Vars.Animatronics[a][1]:Taunt(ply) end
	
end)

