include( 'shared.lua' )

DEFINE_BASECLASS( "gamemode_base" )

if !sfont and game.GetMap()=="fnaf2" then
	
	if file.Exists( "resource/fonts/OCR_A_Std.ttf", "GAME" ) then
		
		sfont = "OCR A Std"
		sfont2 = "Graph 35+ pix"
		sfont3 = sfont
		sfont4 = sfont2
		fontloaded = true
		
	elseif file.Exists( "resource/fonts/graph-35-pix.ttf", "GAME" ) then
		
		sfont = "Graph 35+ pix"
		sfont2 = sfont
		sfont3 = sfont
		sfont4 = sfont2
		fontloaded = false
		
	else
		
		sfont = "Courier"
		sfont2 = sfont
		sfont3 = sfont
		sfont4 = sfont2
		fontloaded = false
		
	end
	
elseif !sfont and game.GetMap()=="fnaf3" then
	
	if file.Exists( "resource/fonts/5Computers-In-Love.ttf", "GAME" ) then
		
		sfont = "5Computers In Love"
		sfont2 = "Graph 35+ pix"
		sfont3 = sfont
		sfont4 = sfont2
		fontloaded = true
		
	elseif file.Exists( "resource/fonts/graph-35-pix.ttf", "GAME" ) then
		
		sfont = "Graph 35+ pix"
		sfont2 = sfont
		sfont3 = sfont
		sfont4 = sfont2
		fontloaded = false
		
	else
		
		sfont = "Courier"
		sfont2 = sfont
		sfont3 = sfont
		sfont4 = sfont2
		fontloaded = false
		
	end
	
elseif !sfont and ( game.GetMap()=="fnaf4house" or game.GetMap()=="fnaf4noclips" or game.GetMap()=="fnaf4versus" ) then
	
	fontloaded = true
	if file.Exists( "resource/fonts/graph-35-pix.ttf", "GAME" ) then sfont = "Graph 35+ pix" else sfont = "Courier" fontloaded = false end
	sfont2 = sfont
	if file.Exists( "resource/fonts/Precious.ttf", "GAME" ) then sfont3 = "Precious" else sfont3 = sfont fontloaded = false end
	if file.Exists( "resource/fonts/DJB-Get-Digital.ttf", "GAME" ) then sfont4 = "DJB Get Digital" else sfont4 = sfont2 fontloaded = false end
	
elseif !sfont then
	
	fontloaded = true
	if file.Exists( "resource/fonts/graph-35-pix.ttf", "GAME" ) then sfont = "Graph 35+ pix" else sfont = "Courier" fontloaded = false end
	sfont2 = sfont
	sfont3 = sfont
	sfont4 = sfont2
	
end

for _, addon in pairs(engine.GetAddons()) do
	
	if addon.wsid == "104575630" and addon.mounted then
		CreateClientConVar( "ragdollmover_rotatebutton", 109, false, false ) // Ragdoll Mover "fix" http://steamcommunity.com/sharedfiles/filedetails/?id=104575630
	end
	
end

concommand.Add("fnafgm_menu", function(ply)
	
	fnafgmMenu()
	
end)

willviewcheck = false

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

include( 'cl_scoreboard.lua' )
include( 'cl_voice.lua' )
include( 'cl_fnafview.lua' )
include( 'cl_menu.lua' )
include( 'cl_secret.lua' )

avisible=true


function fnafgmWarn()

	if !fontloaded and fnafgm_cl_warn:GetBool() then
		
		LocalPlayer():PrintMessage(HUD_PRINTTALK, tostring(GAMEMODE.TranslatedStrings.warn_font or GAMEMODE.Strings.en.warn_font))
		notification.AddLegacy(tostring(GAMEMODE.TranslatedStrings.warn_font or GAMEMODE.Strings.en.warn_font), NOTIFY_ERROR, 10)
		surface.PlaySound( "buttons/button10.wav" )
		
	end
	
	if !IsMounted( 'cstrike' ) and (game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent" or game.GetMap()=="fnaf2" or game.GetMap()=="fnaf3" or game.GetMap()=="fnaf4house" or game.GetMap()=="fnaf4noclips" or game.GetMap()=="fnaf4versus") and fnafgm_cl_warn:GetBool() then
		
		LocalPlayer():PrintMessage(HUD_PRINTTALK, tostring(GAMEMODE.TranslatedStrings.warn_css or GAMEMODE.Strings.en.warn_css))
		notification.AddLegacy(tostring(GAMEMODE.TranslatedStrings.warn_css or GAMEMODE.Strings.en.warn_css), NOTIFY_ERROR, 10)
		surface.PlaySound( "buttons/button10.wav" )
		
	end
	
end


function GM:DrawDeathNotice( x, y )

end


function GM:HUDWeaponPickedUp() return false end
function GM:HUDItemPickedUp() return false end
function GM:HUDAmmoPickedUp() return false end


function GM:HUDDrawTargetID()
	
	local tr = util.GetPlayerTrace( LocalPlayer() )
	local trace = util.TraceLine( tr )
	if (!trace.Hit) then return end
	if (!trace.HitNonWorld) then return end
	
	local text = "ERROR"
	local font = "FNAFGMID"
	
	if !fnafviewactive and (trace.Entity:IsPlayer() and ( LocalPlayer():Team()==trace.Entity:Team() or LocalPlayer():Team()==2 or LocalPlayer():Team()==TEAM_SPECTATOR )) then
		text = trace.Entity:Nick()
	elseif debugmode then
		text = trace.Entity:GetClass()
	else
		return
	end
	
	surface.SetFont( font )
	local w, h = surface.GetTextSize( text )
	
	local MouseX, MouseY = gui.MousePos()
	
	if ( MouseX == 0 && MouseY == 0 ) then
	
		MouseX = ScrW() / 2
		MouseY = ScrH() / 2
	
	end
	
	local x = MouseX
	local y = MouseY
	
	x = x - w / 2
	y = y + 30
	
	-- The fonts internal drop shadow looks lousy with AA on
	draw.SimpleText( text, font, x+1, y+1, Color(0,0,0,120) )
	draw.SimpleText( text, font, x+2, y+2, Color(0,0,0,50) )
	draw.SimpleText( text, font, x, y, self:GetTeamColor( trace.Entity ) )
	
end


fnafgmHUDhide = {
	CHudHealth = true, 
	CHudBattery = true,
	CHudDamageIndicator = true,
	CHudDeathNotice = true,
	CHudZoom = true,
	CHudChat = b87
}

hook.Add("HUDShouldDraw", "HideHUD", function( name )
	if ( fnafgmHUDhide[ name ] ) then
		return false
	elseif name=="CHudCrosshair" and GetConVarNumber( "cl_drawhud" )==0 then
		return false
	elseif name=="CHudCrosshair" and LocalPlayer():Team()==TEAM_UNASSIGNED then
		return false
	elseif name=="CHudCrosshair" and fnafviewactive then
		return false
	elseif name=="CHudCrosshair" and engine.IsPlayingDemo() then
		return false
	elseif name=="CHudCrosshair" and (tobool(tempostart) or tobool(gameend) or tobool(nightpassed)) then
		return false
	end
end)


net.Receive( "fnafgmVarsUpdate", function( len )

	startday = net.ReadBit()
	gameend = net.ReadBit()
	iniok = net.ReadBit()
	time = net.ReadInt( 5 )
	AMPM = net.ReadString()
	night = net.ReadInt( 32 )
	nightpassed = net.ReadBit()
	tempostart = net.ReadBit()
	mute = net.ReadBit()
	overfive = net.ReadBit()
	
end)

net.Receive( "fnafgmShowCheck", function( len )

	willviewcheck = net.ReadBit()
	
end)

net.Receive( "fnafgmAVisible", function( len )

	avisible = net.ReadBit()
	
end)

net.Receive( "fnafgmPowerUpdate", function( len )

	power = net.ReadInt( 20 )
	powerusage = net.ReadInt( 6 )
	poweroff = tobool(net.ReadBit())
	powertot = net.ReadInt( 16 )
	
end)

net.Receive( "fnafgmDS", function( len )

	DS = net.ReadBit()
	
end)


function GM:HUDPaint()
	
	if ( GetConVarNumber( "cl_drawhud" ) == 0 ) then return end
	
	hook.Run( "HUDDrawTargetID" )
	
	local client = LocalPlayer()
	
	if (b87) then return end
	
	local H = 46
	if tobool(iniok) then
		if tobool(nightpassed) or tobool(gameend) then
			
			draw.DrawText(time.." "..AMPM, "FNAFGMCH", ScrW() * 0.515, ScrH() * 0.410, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)
			
		elseif !tobool(startday) then
			
			draw.DrawText(tostring(GAMEMODE.TranslatedStrings.tonight or GAMEMODE.Strings.en.tonight).." "..night+1, "FNAFGMNIGHT", ScrW()-64, H+64, GAMEMODE.Colors_default, TEXT_ALIGN_RIGHT)
			
			if client:Team()==1 and (GAMEMODE.TranslatedStrings[game.GetMap()] or GAMEMODE.Strings.en[game.GetMap()]) then
				draw.DrawText(string.upper(string.format(GAMEMODE.TranslatedStrings[game.GetMap()] or GAMEMODE.Strings.en[game.GetMap()], GAMEMODE.TranslatedStrings.animatronics or GAMEMODE.Strings.en.animatronics)), "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.2, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)
			elseif client:Team()==2 then
				draw.DrawText(string.upper(tostring(GAMEMODE.TranslatedStrings.startanimatronics or GAMEMODE.Strings.en.startanimatronics)), "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.48, Color(170, 0, 0, 255), TEXT_ALIGN_CENTER)
			end
			
			if game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent" then
				if client:Team()==1 then
					cam.Start3D(EyePos(), EyeAngles())
						render.SetMaterial( Material( "fnafgm/xpnbc" ) )
						local varpos = math.random(16, 30)
						render.DrawSprite( Vector(-470, -224, 122), varpos, varpos, GAMEMODE.Colors_surl)
					cam.End3D()
				end
			elseif game.GetMap()=="fnaf2" and client:Team()==1 then
				cam.Start3D(EyePos(), EyeAngles())
					render.SetMaterial( Material( "fnafgm/xpnbc" ) )
					local varpos = math.random(64, 100)
					render.DrawSprite( Vector(-345, 1323, 70), varpos, varpos, GAMEMODE.Colors_surl)
				cam.End3D()
			end
		
		elseif !tobool(tempostart) then
				
			if game.GetMap()=="fnaf4house" or game.GetMap()=="fnaf4noclips" or game.GetMap()=="fnaf4versus" then
				
				if (Halloween or (GetConVar("fnafgm_forceseasonalevent")~=nil and GetConVar("fnafgm_forceseasonalevent"):GetInt()==3)) then
					time=math.random( 1, 12 )
					if math.random( 0, 10000 )<5000 then
						AMPM="PM"
					elseif math.random( 0, 10000 )>5000 then
						AMPM="AM"
					else
						time=666
						AMPM=""
					end
				end
				
				draw.DrawText(time.." "..AMPM, "FNAFGM4TIME", ScrW()-52, H, Color(100, 100, 100, 255), TEXT_ALIGN_RIGHT)
				
			elseif game.GetMap()=="fnaf2" and !usingsafezone then
				
				draw.DrawText(time.." "..AMPM, "FNAFGMNIGHT", ScrW()-64, H+32, GAMEMODE.Colors_default, TEXT_ALIGN_RIGHT)
				draw.DrawText(tostring(GAMEMODE.TranslatedStrings.night or GAMEMODE.Strings.en.night).." "..night, "FNAFGMNIGHT", ScrW()-64, H, GAMEMODE.Colors_default, TEXT_ALIGN_RIGHT)
				
				if power!=0 then
					
					draw.DrawText(tostring(GAMEMODE.TranslatedStrings.flashlight or GAMEMODE.Strings.en.flashlight), "FNAFGMTXT", 128, 64+12, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)
					
					local idsb = 5
					
					local powersb = powertot/5
					if powersb/2>=power then
						idsb = 1
					elseif powersb>=power then
						idsb = 1
					elseif powersb*2>=power then
						idsb = 2
					elseif powersb*3>=power then
						idsb = 3
					elseif powersb*4>=power then
						idsb = 4
					end
					
					if powersb/2<=power or math.fmod( math.Round( CurTime() ), 2 ) == 0 then
						
						local usagetexture = {
							texture = surface.GetTextureID( GAMEMODE.Materials_battery..idsb ),
							color	= Color( 255, 255, 255, 255 ),
							x 	= 64,
							y 	= H+54,
							w 	= 128,
							h 	= 64
						}
							
						draw.TexturedQuad( usagetexture )
					
					end
					
				end
			
			elseif game.GetMap()!="fnaf2" and ( client:Team()!=1 or ( !poweroff and client:Alive() ) or ( !game.SinglePlayer() and !client:Alive() and !poweroff ) ) then
				
				if (AprilFool or (GetConVar("fnafgm_forceseasonalevent")~=nil and GetConVar("fnafgm_forceseasonalevent"):GetInt()==2)) then
					powerusage=math.Rand( 1, 7 )
				end
				
				if (Halloween or (GetConVar("fnafgm_forceseasonalevent")~=nil and GetConVar("fnafgm_forceseasonalevent"):GetInt()==3)) then
					power=math.random( 1, 100 )
					powerusage=math.Rand( 1, 100 )
					time=math.random( 1, 12 )
					night=666
					if math.random( 0, 10000 )<5000 then
						AMPM="PM"
						GAMEMODE.TranslatedStrings.night="Day"
					elseif math.random( 0, 10000 )>5000 then
						AMPM="AM"
						GAMEMODE.TranslatedStrings.night="Night"
					else
						time=666
						AMPM=""
						GAMEMODE.TranslatedStrings.night=""
						night="IT'S ME"
						power=666
						powerusage=666
					end
				end
				
				draw.DrawText(time.." "..AMPM, "FNAFGMTIME", ScrW()-52, H, GAMEMODE.Colors_default, TEXT_ALIGN_RIGHT)
				draw.DrawText(tostring(GAMEMODE.TranslatedStrings.night or GAMEMODE.Strings.en.night).." "..night, "FNAFGMNIGHT", ScrW()-64, H+64, GAMEMODE.Colors_default, TEXT_ALIGN_RIGHT)
				
				if power!=0 then draw.DrawText(tostring(GAMEMODE.TranslatedStrings.powerleft or GAMEMODE.Strings.en.powerleft)..power.."%", "FNAFGMNIGHT", 64, ScrH()-H-64, GAMEMODE.Colors_default, TEXT_ALIGN_LEFT) end
				
				if powerusage==0 or power==0 then
					
				elseif powerusage>0 and powerusage<7 then
					
					draw.DrawText(tostring(GAMEMODE.TranslatedStrings.usage or GAMEMODE.Strings.en.usage), "FNAFGMNIGHT", 64, ScrH()-H-24, GAMEMODE.Colors_default, TEXT_ALIGN_LEFT)
					
					local usagetexture = {
						texture = surface.GetTextureID( GAMEMODE.Materials_usage..powerusage ),
						color	= Color( 255, 255, 255, 255 ),
						x 	= 180,
						y 	= ScrH()-H-30,
						w 	= 128,
						h 	= 64
					}
				
					draw.TexturedQuad( usagetexture )
					
				elseif powerusage<0 then
				
					draw.DrawText(tostring(GAMEMODE.TranslatedStrings.usage or GAMEMODE.Strings.en.usage).." ?", "FNAFGMNIGHT", 64, ScrH()-H-24, GAMEMODE.Colors_default, TEXT_ALIGN_LEFT)
					
				else
				
					draw.DrawText(tostring(GAMEMODE.TranslatedStrings.usage or GAMEMODE.Strings.en.usage).." "..powerusage, "FNAFGMNIGHT", 64, ScrH()-H-24, GAMEMODE.Colors_default, TEXT_ALIGN_LEFT)
					
				end
			
			end
			
			if client:Team()~=1 or !client:Alive() and !game.SinglePlayer() then
				local alivec = 0
				for k, v in pairs(player.GetAll()) do
					if v:Alive() and v:Team()==1 then
						alivec = alivec+1
					end
				end
				draw.DrawText(team.GetName(1)..": "..alivec.."/"..team.NumPlayers(1), "FNAFGMID", 46, H, GAMEMODE.Colors_default, TEXT_ALIGN_LEFT)
			end
		
		elseif game.GetMap()=="fnaf4house" or game.GetMap()=="fnaf4noclips" or game.GetMap()=="fnaf4versus" then
			
			draw.DrawText(tostring(GAMEMODE.TranslatedStrings.night or GAMEMODE.Strings.en.night).." "..night, "FNAFGMA4TIME", 32, 32, GAMEMODE.Colors_default, TEXT_ALIGN_LEFT)

		else
			
			draw.DrawText(time..":00 "..AMPM, "FNAFGMATIME", ScrW() * 0.5, ScrH() * 0.44, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)
			
			local suff = "th"
			
			if night==1 then
				suff = "st"
			elseif night==2 then
				suff = "nd"
			elseif night==3 then
				suff = "rd"
			end
			
			draw.DrawText(night..suff.." "..tostring(GAMEMODE.TranslatedStrings.night or GAMEMODE.Strings.en.night), "FNAFGMATIME", ScrW() * 0.5, ScrH() * 0.50, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)
			
		end
		
	elseif client:Team()!=TEAM_UNASSIGNED then
		
		draw.DrawText(tostring(GAMEMODE.TranslatedStrings.tonight or GAMEMODE.Strings.en.tonight).." "..night+1, "FNAFGMNIGHT", ScrW()-64, H+64, GAMEMODE.Colors_default, TEXT_ALIGN_RIGHT)
		
		if client:Team()==1 and (GAMEMODE.TranslatedStrings[game.GetMap()] or GAMEMODE.Strings.en[game.GetMap()]) then
			draw.DrawText(string.upper(string.format(GAMEMODE.TranslatedStrings[game.GetMap()] or GAMEMODE.Strings.en[game.GetMap()], GAMEMODE.TranslatedStrings.animatronics or GAMEMODE.Strings.en.animatronics)), "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.2, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)
		elseif client:Team()==2 then
			draw.DrawText(string.upper(GAMEMODE.TranslatedStrings.startanimatronics or GAMEMODE.Strings.en.startanimatronics), "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.48, Color(170, 0, 0, 255), TEXT_ALIGN_CENTER)
		end
		
		if client:Team()==1 then
			if game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent" then
				cam.Start3D(EyePos(), EyeAngles())
					render.SetMaterial( Material( "fnafgm/xpnbc" ) )
					local varpos = math.random(16, 30)
					render.DrawSprite( Vector(-470, -224, 122), varpos, varpos, GAMEMODE.Colors_surl)
				cam.End3D()
			elseif game.GetMap()=="fnaf2" and client:Team()==1 then
				cam.Start3D(EyePos(), EyeAngles())
					render.SetMaterial( Material( "fnafgm/xpnbc" ) )
					local varpos = math.random(64, 100)
					render.DrawSprite( Vector(-345, 1323, 70), varpos, varpos, GAMEMODE.Colors_surl)
				cam.End3D()
			end
		end
			
	end
	
	if client:Team()==2 and client:Alive() then
		if player_manager.GetPlayerClass(client)=="player_fnafgmfoxy" then
			draw.DrawText(string.upper(GAMEMODE.TranslatedStrings.foxy or GAMEMODE.Strings.en.foxy), "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.95, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)
		elseif player_manager.GetPlayerClass(client)=="player_fnafgmfreddy" then
			draw.DrawText(string.upper(GAMEMODE.TranslatedStrings.freddy or GAMEMODE.Strings.en.freddy), "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.95, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)
		elseif player_manager.GetPlayerClass(client)=="player_fnafgmchica" then
			draw.DrawText(string.upper(GAMEMODE.TranslatedStrings.chica or GAMEMODE.Strings.en.chica), "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.95, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)
		elseif player_manager.GetPlayerClass(client)=="player_fnafgmbonnie" then
			draw.DrawText(string.upper(GAMEMODE.TranslatedStrings.bonnie or GAMEMODE.Strings.en.bonnie), "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.95, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)
		elseif player_manager.GetPlayerClass(client)=="player_fnafgmgoldenfreddy" then
			draw.DrawText(string.upper(GAMEMODE.TranslatedStrings.goldenfreddy or GAMEMODE.Strings.en.goldenfreddy), "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.95, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)
		end
		if IsValid(client:GetActiveWeapon()) and client:GetActiveWeapon():GetClass()=="fnafgm_animatronic" then
			if tobool(avisible) then
				draw.DrawText("VISIBLE - LOCKED", "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.90, Color(255, 85, 85, 255), TEXT_ALIGN_CENTER)
			elseif !tobool(avisible) then
				draw.DrawText("INVISIBLE - MOVEMENT FREE", "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.90, Color(85, 255, 85, 255), TEXT_ALIGN_CENTER)
			end
		end
		
	end
	
	if SGvsA and client:Team()==TEAM_UNASSIGNED and !poweroff then
		draw.DrawText(string.upper(GAMEMODE.TranslatedStrings.unassigned_SGvsA or GAMEMODE.Strings.en.unassigned_SGvsA), "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.8, GAMEMODE.Colors_default, TEXT_ALIGN_CENTER)
	elseif client:Team()==TEAM_UNASSIGNED and poweroff and game.GetMap()!="fnaf2" then
		draw.DrawText(string.upper(GAMEMODE.TranslatedStrings.unassigned_powerdown or GAMEMODE.Strings.en.unassigned_powerdown), "FNAFGMNIGHT", ScrW() * 0.5, ScrH() * 0.48, Color(170, 0, 0, 255), TEXT_ALIGN_CENTER)
	end
	
	if tobool(willviewcheck) and client:Team()==TEAM_UNASSIGNED then
		
		if game.GetMap()=="freddys" then
			
			draw.DrawText(client:GetName(), "FNAFGMCHECK", ScrW()/2-50, ScrH()/2-4, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
			
		elseif game.GetMap()=="fnaf2" and !tobool(overfive) then
			
			draw.DrawText(client:GetName(), "FNAFGMCHECK", ScrW()/2-50, ScrH()/2-50, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
		
		elseif game.GetMap()=="fnaf2" then
			
			draw.DrawText(client:GetName(), "FNAFGMCHECK", 128, ScrH()-370, Color(0, 0, 0, 255), TEXT_ALIGN_LEFT)
			
		elseif game.GetMap()=="fnap_scc" then
			
			draw.DrawText(client:GetName(), "FNAFGMCHECK", ScrW()/2-50, ScrH()/2-45, Color(0, 0, 0, 255), TEXT_ALIGN_CENTER)
			
		end
		
	end
	
end

hook.Add( "PreDrawHalos", "fnafgmHalos", function()
	
	local client = LocalPlayer()
	local tab = {}
	local tab2 = {}
	
	if game.GetMap()=="fnap_scc" and client:Team()==1 and !tobool(startday) and !tobool(nightpassed) and !tobool(gameend) then
		
		local BoxCorner = Vector(-313,-408,0)
		local OppositeCorner = Vector(-374,-371,-70)
		
		for k,v in pairs(ents.FindInBox(BoxCorner,OppositeCorner)) do
			if v:GetClass()=="prop_dynamic" then
				table.insert(tab, v)
			end
		end
		
		halo.Add( tab, GAMEMODE.Colors_surl, 1, 1, 1, true, true )
		
	end
	
	if client:Team()==2 then
	
		for k,v in pairs(player.GetAll()) do
			if client:Team()==2 and v:Team()==1 and client:Alive() and v:Alive() then
				table.insert(tab, v)
			end
		end
		
		for k,v in pairs(player.GetAll()) do
			if client:Team()==2 and client:Team()==v:Team() and client:Alive() and v:Alive() then
				table.insert(tab2, v)
			end
		end
		
		halo.Add( tab, Color( 170, 0, 0 ), 1, 1, 1, true, true )
		halo.Add( tab2, Color( 0, 170, 0 ), 1, 1, 1, true, true )
		
	end
	
	if client:Team()==TEAM_SPECTATOR then
		
		for k,v in pairs(player.GetAll()) do
			if client:Team()==TEAM_SPECTATOR and v:Team()==1 and v:Alive() then
				table.insert(tab, v)
			end
		end
		
		for k,v in pairs(player.GetAll()) do
			if client:Team()==TEAM_SPECTATOR and v:Team()==2 and v:Alive() then
				table.insert(tab2, v)
			end
		end
	
		halo.Add( tab, team.GetColor(1), 1, 1, 1, true, true )
		halo.Add( tab2, team.GetColor(2), 1, 1, 1, true, true )
	
	end
	
end )


net.Receive( "fnafgmCheckUpdate", function( len )

	updateavailable = net.ReadBit()
	lastversion = net.ReadString()
	
	if tobool(updateavailable) then
		notification.AddLegacy("FNAFGM update available! V"..lastversion, NOTIFY_GENERIC, 10)
		chat.PlaySound()
	end
	
end)


net.Receive( "fnafgmCheckUpdateD", function( len )

	derivupdateavailable = net.ReadBit()
	lastderivversion = net.ReadString()
	
	if tobool(derivupdateavailable) then
		notification.AddLegacy(tostring(GAMEMODE.ShortName or "?").." update available! V"..lastderivversion, NOTIFY_GENERIC, 10)
		chat.PlaySound()
	end
	
end)


hook.Add("HUDPaint", "fnafgmInfo", function() 
	
	if ( GetConVarNumber( "cl_drawhud" ) == 0 ) then return end
	
	if SGvsA then
		draw.DrawText("Sorry but SGvsA is not a finished product.\nYou can play anyway, but it's not something stable or balanced.", "DermaLarge", ScrW() * 0.5, ScrH()-64, Color(128, 128, 128, 128), TEXT_ALIGN_CENTER)
	end
	
	if !fnafgm_cl_hideversion:GetBool() then
	
		if GetConVar("fnafgm_forceseasonalevent")~=nil and GetConVar("fnafgm_forceseasonalevent"):GetInt()==2 then
			seasonaltext = " - April Fool"
		elseif GetConVar("fnafgm_forceseasonalevent")~=nil and GetConVar("fnafgm_forceseasonalevent"):GetInt()==3 then
			seasonaltext = " - Halloween"
		elseif !AprilFool and !Halloween and GetConVar("fnafgm_forceseasonalevent")~=nil and GetConVar("fnafgm_forceseasonalevent"):GetInt()==0 then
			seasonaltext = ""
		end
		
		local updatearem = 0
		local monitorspace = 0
		
		if tobool(updateavailable) then
			if IsValid(Monitor) then monitorspace = 30 end
			draw.DrawText("FNAFGM update available! V"..lastversion, "Trebuchet24", ScrW() - 8 - monitorspace, ScrH() - 28 - monitorspace, Color(100, 100, 100, 255), TEXT_ALIGN_RIGHT)
			updatearem = updatearem+30
		end
		if tobool(derivupdateavailable) then
			if IsValid(Monitor) then monitorspace = 30 end
			draw.DrawText(tostring(GAMEMODE.ShortName or "?").." update available! V"..lastderivversion, "Trebuchet24", ScrW() - 8 - monitorspace, ScrH() - 28 - updatearem - monitorspace, Color(100, 100, 100, 255), TEXT_ALIGN_RIGHT)
			updatearem = updatearem+30
		end
		
		draw.DrawText(tostring(GAMEMODE.ShortName or "?").." V"..tostring(GAMEMODE.Version or "?")..modetext..seasonaltext, "Trebuchet24", ScrW() - 8 - monitorspace, ScrH() - 28 - updatearem - monitorspace, Color(100, 100, 100, 255), TEXT_ALIGN_RIGHT)
		
		
	end
	
	if (AprilFool or (GetConVar("fnafgm_forceseasonalevent")~=nil and GetConVar("fnafgm_forceseasonalevent"):GetInt()==2)) and (game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent") then
		cam.Start3D(EyePos(), EyeAngles())
			render.SetMaterial( Material( "fnafgm/troll" ) )
			render.DrawSprite( Vector(-78, -1052, 145), 50, 50, GAMEMODE.Colors_default)
		cam.End3D()
	end
	
end)


function GM:OnPlayerChat( player, strText, bTeamOnly, bPlayerIsDead )
	
	local tab = {}

 
	if bPlayerIsDead then
		table.insert( tab, Color( 255, 30, 40 ) )
		table.insert( tab, "*DEAD* " )
	end
	
	if bTeamOnly then
		table.insert( tab, Color( 30, 160, 40 ) )
		table.insert( tab, "(TEAM) " )
	end
 
	if IsValid( player ) then
		if (player:IsAdmin() and fnafgmcheckcreator(player)) then
			table.insert( tab, Color( 85, 255, 255 ) )
			table.insert( tab, "[Admin|FNAFGM Creator] " )
		elseif (player:IsAdmin() and GAMEMODE:CheckDerivCreator(player)) then
			table.insert( tab, Color( 255, 170, 0 ) )
			table.insert( tab, "[Admin|"..GAMEMODE.ShortName.." Creator] " )
		elseif player:IsAdmin() then
			table.insert( tab, Color( 170, 0, 0 ) )
			table.insert( tab, "[Admin] " )
		elseif fnafgmcheckcreator(player) then
			table.insert( tab, Color( 85, 255, 255 ) )
			table.insert( tab, "{FNAFGM Creator} " )
		elseif GAMEMODE:CheckDerivCreator(player) then
			table.insert( tab, Color( 255, 170, 0 ) )
			table.insert( tab, "{"..GAMEMODE.ShortName.." Creator} " )
		elseif player:SteamID()=="STEAM_0:1:49648853" then
			table.insert( tab, Color( 170, 0, 170 ) )
			table.insert( tab, "[FNAF4 map creator] " )
		elseif player:GetUserGroup()=="premium" then
			table.insert( tab, Color( 255, 170, 0 ) )
			table.insert( tab, "[Premium] " )
		elseif player:GetUserGroup()=="vip" then
			table.insert( tab, Color( 170, 0, 170 ) )
			table.insert( tab, "[VIP] " )
		elseif player:GetUserGroup()~="user" then
			table.insert( tab, GAMEMODE.Colors_defaultchat )
			table.insert( tab, "[".. string.upper( string.sub(player:GetUserGroup(), 1, 1) )..string.sub(player:GetUserGroup(), 2).."] " )
		end
		table.insert( tab, player )
	else
		table.insert( tab, "Console" )
	end
	
	table.insert( tab, GAMEMODE.Colors_defaultchat )
	table.insert( tab, ": "..strText )
	
	chat.AddText( unpack(tab) )
	
	if fnafgm_cl_chatsound:GetBool() then chat.PlaySound() end
	if fnafgm_cl_flashwindow:GetBool() then system.FlashWindow() end
	
	return true
	
end


hook.Add("RenderScreenspaceEffects", "fnafgm_NV", function()
    local client = LocalPlayer()
	if tobool(startday) and client:Team()==2 and game.GetMap()=="freddysnoevent" and client:Alive() then
		local colormod = {
			[ "$pp_colour_addr" ] = 0.02,
			[ "$pp_colour_addg" ] = 0.02,
			[ "$pp_colour_addb" ] = 0.02,
			[ "$pp_colour_brightness" ] = 0.01,
			[ "$pp_colour_contrast" ] = 4,
			[ "$pp_colour_colour" ] = 0.6,
			[ "$pp_colour_mulr" ] = 0.02,
			[ "$pp_colour_mulg" ] = 0.02,
			[ "$pp_colour_mulb" ] = 0.02
		}
        DrawColorModify(colormod)
	elseif client:Team()==2 and !client:Alive() then
		local colormod = {
			[ "$pp_colour_addr" ] = 0,
			[ "$pp_colour_addg" ] = 0,
			[ "$pp_colour_addb" ] = 0,
			[ "$pp_colour_brightness" ] = 0,
			[ "$pp_colour_contrast" ] = 0.6,
			[ "$pp_colour_colour" ] = 0,
			[ "$pp_colour_mulr" ] = 0,
			[ "$pp_colour_mulg" ] = 0,
			[ "$pp_colour_mulb" ] = 0
		}
        DrawColorModify(colormod)
    end
end)


local undomodelblend = false
local matWhite = Material("models/debug/debugwhite")

function GM:PrePlayerDraw( ply )
	if ply:Team()!=1 or ply==LocalPlayer() then return end
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

function GM:PostPlayerDraw( ply )
	if undomodelblend then
		render.SetBlend(1)
		render.ModelMaterialOverride()
		render.SetColorModulation(1, 1, 1)
		undomodelblend = false
	end
end


function GM:ShowTeam()

	if !IsValid( self.TeamSelectFrame ) then
		
		-- Simple team selection box
		self.TeamSelectFrame = vgui.Create( "DFrame" )
		self.TeamSelectFrame:SetTitle( "Pick Team" )
		
		local AllTeams = team.GetAllTeams()
		local x = 4
		local y = 284
		for ID, TeamInfo in pairs ( AllTeams ) do
		
			if ( ID != TEAM_CONNECTING && ID != TEAM_UNASSIGNED ) then
		
				local Team = vgui.Create( "DButton", self.TeamSelectFrame )
				function Team.DoClick() self:HideTeam() RunConsoleCommand( "changeteam", ID ) end
				Team:SetPos( x, 24 )
				Team:SetSize( 256, 256 )
				Team:SetText( TeamInfo.Name )
				Team:SetTextColor( TeamInfo.Color )
				Team:SetFont("FNAFGMID")
				
				if ( IsValid( LocalPlayer() ) && LocalPlayer():Team() == ID ) then
					Team:SetDisabled( true )
					Team:SetTextColor( Color(40, 40, 40) )
					Team.Paint = function( self, w, h )
						draw.RoundedBox( 4, 4, 4, w-8, h-8, Color( 0, 0, 0, 150 ) )
					end
				else
					Team:SetTextColor( TeamInfo.Color )
					Team.Paint = function( self, w, h )
						draw.RoundedBox( 4, 4, 4, w-8, h-8, Color( 255, 255, 255, 150 ) )
					end
				end
				
				x = x + 256
			
			end
			
		end
	
		if ( GAMEMODE.AllowAutoTeam ) then
		
			local Team = vgui.Create( "DButton", self.TeamSelectFrame )
			function Team.DoClick() self:HideTeam() RunConsoleCommand( "autoteam" ) end
			Team:SetPos( 4+x/3, 280 )
			Team:SetSize( x/3-4, 32 )
			Team:SetText( "Auto" )
			Team:SetTextColor( GAMEMODE.Colors_default )
			Team:SetFont("FNAFGMTXT")
			Team.Paint = function( self, w, h )
				draw.RoundedBox( 4, 4, 4, w-8, h-8, Color( 255, 255, 255, 150 ) )
			end
			
			y = y + 32
		
		end
		
		self.TeamSelectFrame:SetSize( x+4, y )
		self.TeamSelectFrame:SetDraggable( true )
		self.TeamSelectFrame:SetScreenLock(true)
		self.TeamSelectFrame:SetPaintShadow(true)
		self.TeamSelectFrame:Center()
		self.TeamSelectFrame:MakePopup()
		self.TeamSelectFrame:SetKeyboardInputEnabled( false )
		self.TeamSelectFrame.Paint = function( self, w, h )
			draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 128 ) )
		end
		
	else
		self.TeamSelectFrame:Close()
	end
	
end


net.Receive( "fnafgmMapSelect", function( len )
	fnafgmMapSelect(net.ReadTable())
end)

function fnafgmMapSelect(AvMaps)
	
	if ( IsValid( MapSelectF ) ) then return end
	
	MapSelectF = vgui.Create( "DFrame" )
	MapSelectF:SetTitle( "Map select" )
	
	local AllMaps = GAMEMODE.MapList
	local x = 4
	local y = 156
	for ID, Map in SortedPairsByValue( AllMaps ) do
		
		local MapI = vgui.Create( "DButton", MapSelectF )
		MapI:SetPos( x, 24 )
		MapI:SetSize( 128, 128 )
		MapI:SetText( Map )
		MapI:SetFont("FNAFGMID")
		MapI:SetTextColor( Color(255, 255, 255, 0) )
		
		local png
		local path = "maps/" .. ID .. ".png"
		if file.Exists(path, "GAME") then
			png = Material(path, "noclamp")
			MapI.OnCursorEntered = function()
				MapI:SetTextColor( Color( 255, 255, 255, 255 ) )
			end
			MapI.OnCursorExited = function()
				MapI:SetTextColor( Color( 255, 255, 255, 0 ) )
			end
		else
			local path = "maps/thumb/" .. ID .. ".png"
			if file.Exists(path, "GAME") then
				png = Material(path, "noclamp")
				MapI.OnCursorEntered = function()
					MapI:SetTextColor( Color( 255, 255, 255, 255 ) )
				end
				MapI.OnCursorExited = function()
					MapI:SetTextColor( Color( 255, 255, 255, 0 ) )
				end
			else
				png = Material("maps/thumb/noicon.png", "noclamp")
				MapI:SetTextColor( Color(255, 255, 255) )
			end
		end
		
		if game.GetMap()==ID then
			MapI.Paint = function( self, w, h )
				surface.SetMaterial(png)
				surface.SetDrawColor(85, 85, 85, 255)
				surface.DrawTexturedRect(0, 0, 128, 128)
			end
		elseif !AvMaps[ID] then
			MapI:SetTextColor( Color(255, 0, 0) )
			MapI.Paint = function( self, w, h )
				surface.SetMaterial(png)
				surface.SetDrawColor(128, 64, 64, 255)
				surface.DrawTexturedRect(0, 0, 128, 128)
			end
			if GAMEMODE.MapListLinks[ID] then
				function MapI.DoClick()
					gui.OpenURL( GAMEMODE.MapListLinks[ID] )
				end
			end
		else
			MapI.Paint = function( self, w, h )
				surface.SetMaterial(png)
				surface.SetDrawColor(255, 255, 255, 255)
				surface.DrawTexturedRect(0, 0, 128, 128)
			end
			function MapI.DoClick()
				fnafgmChangeMap(ID)
			end
		end
		
		x = x + 128
		
	end
	
	MapSelectF:SetSize( x+4, y )
	MapSelectF:SetDraggable( true )
	MapSelectF:SetScreenLock(true)
	MapSelectF:SetPaintShadow(true)
	MapSelectF:Center()
	MapSelectF:MakePopup()
	MapSelectF:SetKeyboardInputEnabled( false )
	MapSelectF.Paint = function( self, w, h )
		Derma_DrawBackgroundBlur( self )
		draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 128 ) )
	end

end


function fnafgmSetView( id )
	net.Start( "fnafgmSetView" )
		net.WriteFloat(id)
	net.SendToServer()
end

function fnafgmMuteCall()
	net.Start( "fnafgmMuteCall" )
	net.SendToServer()
end

function fnafgmSafeZone()
	net.Start( "fnafgmSafeZone" )
	net.SendToServer()
end

function fnafgmShutLights()
	net.Start( "fnafgmShutLights" )
	net.SendToServer()
end

function fnafgmUseLight(id)
	net.Start( "fnafgmUseLight" )
		net.WriteFloat(id)
	net.SendToServer()
end

function fnafgmChangeMap(map)
	net.Start( "fnafgmChangeMap" )
		net.WriteString(map)
	net.SendToServer()
end

net.Receive( "fnafgmNotif", function( len )
	
	local str = net.ReadString() or ""
	local ne = net.ReadInt(3) or 0
	local dur = net.ReadFloat() or 5
	local sound = net.ReadBit() or false
	
	fnafgmNotif(str,ne,dur,sound)
	
end)
function fnafgmNotif(str,ne,dur,sound)
	notification.AddLegacy(str,ne,dur,sound)
	if !tobool(sound) then return end
	if ne==NOTIFY_HINT then
		surface.PlaySound( "ambient/water/drip"..math.random(1, 4)..".wav" )
	elseif ne==NOTIFY_ERROR then
		surface.PlaySound( "buttons/button10.wav" )
	else
		chat.PlaySound()
	end
	
	if fnafgm_cl_flashwindow:GetBool() then system.FlashWindow() end
end