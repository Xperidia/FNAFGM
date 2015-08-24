function fnafgmMenu()
	
	if !IsValid(fnafgmMenuF) then
		
		
		fnafgmMenuF = vgui.Create( "DFrame" )
		fnafgmMenuF:SetPos( ScrW()/2-320, ScrH()/2-240 )
		fnafgmMenuF:SetSize( 640, 480 )
		fnafgmMenuF:SetTitle(tostring(GAMEMODE.ShortName or "?").." V"..tostring(GAMEMODE.Version or "?")..modetext..seasonaltext)
		fnafgmMenuF:SetVisible(true)
		fnafgmMenuF:SetDraggable(true)
		fnafgmMenuF:ShowCloseButton(true)
		fnafgmMenuF:SetScreenLock(true)
		fnafgmMenuF.Paint = function( self, w, h )
			Derma_DrawBackgroundBlur( self )
			draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 128 ) )
		end
		fnafgmMenuF.Think = function()
			
			if input.IsKeyDown( KEY_ESCAPE ) then
				fnafgmMenuF:Close()
			end
			
		end
		fnafgmMenuF:MakePopup()
		fnafgmMenuF:SetKeyboardInputEnabled(false)
		
		
		local links = vgui.Create( "DPanel" )
		links:SetParent(fnafgmMenuF)
		links:SetPos( 10, 30 )
		links:SetSize( 305, 215 )
		
		local linkslbl = vgui.Create( "DLabel" )
		linkslbl:SetParent(links)
		linkslbl:SetText( GAMEMODE.Strings.base.links )
		linkslbl:SetPos( 10, 5 )
		linkslbl:SetDark( 1 )
		linkslbl:SizeToContents()
		
		local websitebtn = vgui.Create( "DButton" )
		websitebtn:SetParent(links)
		websitebtn:SetText( GAMEMODE.ShortName.." Workshop page" )
		websitebtn:SetPos( 20, 60 )
		websitebtn:SetSize( 265, 80 )
		websitebtn.DoClick = function()
			gui.OpenURL( GAMEMODE.Website )
			fnafgmMenuF:Close()
		end
		
		if !fontloaded then
			
			local fontlbl = vgui.Create( "DLabel" )
			fontlbl:SetParent(links)
			fontlbl:SetText( GAMEMODE.Strings.base.fonthint )
			fontlbl:SetPos( 15, 30 )
			fontlbl:SetDark( 1 )
			fontlbl:SizeToContents()
			
		end
		
		if engine.ActiveGamemode()=="fnafgm" then
			
			questionbtn = vgui.Create( "DButton" )
			questionbtn:SetParent(links)
			questionbtn:SetText( GAMEMODE.Strings.base.faqbtn )
			questionbtn:SetPos( 10, 185 )
			questionbtn:SetSize( 140, 20 )
			questionbtn.DoClick = function()
				gui.OpenURL( "http://steamcommunity.com/workshop/filedetails/discussion/408243366/537405286640719064/" )
				fnafgmMenuF:Close()
			end
			
			bugreportbtn = vgui.Create( "DButton" )
			bugreportbtn:SetParent(links)
			bugreportbtn:SetText( "Bug report" )
			bugreportbtn:SetPos( 155, 185 )
			bugreportbtn:SetSize( 140, 20 )
			bugreportbtn.DoClick = function()
				gui.OpenURL( "http://steamcommunity.com/workshop/filedetails/discussion/408243366/537405286650706286/" )
				fnafgmMenuF:Close()
			end
			
		end
		
		
		
		local config = vgui.Create( "DPanel" )
		config:SetParent(fnafgmMenuF)
		config:SetPos( 325, 30 )
		config:SetSize( 305, 215 )
		
		local configlbl = vgui.Create( "DLabel" )
		configlbl:SetParent(config)
		configlbl:SetText( GAMEMODE.Strings.base.config )
		configlbl:SetPos( 10, 5 )
		configlbl:SetDark( 1 )
		configlbl:SizeToContents()
		
		local hideversion = vgui.Create( "DCheckBoxLabel" )
		hideversion:SetParent(config)
		hideversion:SetText(GAMEMODE.Strings.base.hidever)
		hideversion:SetPos( 15, 30 )
		hideversion:SetDark( 1 )
		hideversion:SetConVar( "fnafgm_cl_hideversion" )
		hideversion:SetValue( GetConVar("fnafgm_cl_hideversion"):GetBool() )
		hideversion:SizeToContents()
		
		local warn = vgui.Create( "DCheckBoxLabel" )
		warn:SetParent(config)
		warn:SetText("Warn")
		warn:SetPos( 15, 50 )
		warn:SetDark( 1 )
		warn:SetConVar( "fnafgm_cl_warn" )
		warn:SetValue( GetConVar("fnafgm_cl_warn"):GetBool() )
		warn:SizeToContents()
		
		local autofnafview = vgui.Create( "DCheckBoxLabel" )
		autofnafview:SetParent(config)
		autofnafview:SetText(GAMEMODE.Strings.base.autofnafview)
		autofnafview:SetPos( 15, 70 )
		autofnafview:SetDark( 1 )
		autofnafview:SetConVar( "fnafgm_cl_autofnafview" )
		autofnafview:SetValue( GetConVar("fnafgm_cl_autofnafview"):GetBool() )
		autofnafview:SizeToContents()
		
		local hud = vgui.Create( "DCheckBoxLabel" )
		hud:SetParent(config)
		hud:SetText(GAMEMODE.Strings.base.dhud)
		hud:SetPos( 15, 90 )
		hud:SetDark( 1 )
		hud:SetConVar( "cl_drawhud" )
		hud:SetValue( GetConVar("cl_drawhud"):GetBool() )
		hud:SizeToContents()
		
		
		
		local info = vgui.Create( "DPanel" )
		info:SetParent(fnafgmMenuF)
		info:SetPos( 10, 255 )
		info:SetSize( 305, 215 )
		
		local infolbl = vgui.Create( "DLabel" )
		infolbl:SetParent(info)
		infolbl:SetText( GAMEMODE.Strings.base.infoat )
		infolbl:SetPos( 10, 5 )
		infolbl:SetDark( 1 )
		infolbl:SizeToContents()
		
		local fontinfo = vgui.Create( "DLabel" )
		fontinfo:SetParent(info)
		fontinfo:SetText( GAMEMODE.Strings.base.fontloaded..": "..tostring(fontloaded or "false") )
		fontinfo:SetPos( 15, 30 )
		fontinfo:SetDark( 1 )
		fontinfo:SizeToContents()
		
		local cssinfo = vgui.Create( "DLabel" )
		cssinfo:SetParent(info)
		cssinfo:SetText( "Counter Strike: Source: "..tostring(IsMounted( 'cstrike' ) or "false") )
		cssinfo:SetPos( 15, 50 )
		cssinfo:SetDark( 1 )
		cssinfo:SizeToContents()
		
		local mapinfo = vgui.Create( "DLabel" )
		mapinfo:SetParent(info)
		mapinfo:SetText( "Map: "..game.GetMap() )
		mapinfo:SetPos( 15, 70 )
		mapinfo:SetDark( 1 )
		mapinfo:SizeToContents()
		
		local langinfo = vgui.Create( "DLabel" )
		langinfo:SetParent(info)
		langinfo:SetText( GAMEMODE.Strings.base.lang..": "..GetConVarString("gmod_language") )
		langinfo:SetPos( 15, 90 )
		langinfo:SetDark( 1 )
		langinfo:SizeToContents()
		
		local mapselectb = vgui.Create( "DButton" )
		mapselectb:SetParent(info)
		mapselectb:SetText(GAMEMODE.Strings.base.changemap)
		mapselectb:SetPos( 10, 185 )
		mapselectb:SetSize( 285, 20 )
		mapselectb:SetEnabled(LocalPlayer():IsAdmin())
		mapselectb.DoClick = function()
			RunConsoleCommand( "fnafgm_mapselect" )
			fnafgmMenuF:Close()
		end
		
		
		
		if !game.IsDedicated() and !tobool(DS) then --This doesn't work https://github.com/Facepunch/garrysmod-issues/issues/1495
			
			local resetprogress = vgui.Create( "DButton" )
			resetprogress:SetParent(info)
			resetprogress:SetText(GAMEMODE.Strings.base.resetsave)
			resetprogress:SetPos( 10, 160 )
			resetprogress:SetSize( 285, 20 )
			resetprogress:SetDisabled(SGvsA)
			resetprogress.DoClick = function()
				RunConsoleCommand( "fnafgm_resetprogress" )
				fnafgmMenuF:Close()
			end
		
		end
		
		
		
		local debugmenu = vgui.Create( "DPanel" )
		debugmenu:SetParent(fnafgmMenuF)
		debugmenu:SetPos( 325, 255 )
		debugmenu:SetSize( 305, 215 )
		
		local debugmenulbl = vgui.Create( "DLabel" )
		debugmenulbl:SetParent(debugmenu)
		debugmenulbl:SetText( GAMEMODE.Strings.base.debugmenu )
		debugmenulbl:SetPos( 10, 5 )
		debugmenulbl:SetDark( 1 )
		debugmenulbl:SizeToContents()
		
		local startbtn = vgui.Create( "DButton" )
		startbtn:SetParent(debugmenu)
		startbtn:SetText(GAMEMODE.Strings.base.start)
		startbtn:SetPos( 20, 45 )
		startbtn:SetSize( 265, 20 )
		startbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_start" )
			fnafgmMenuF:Close()
		end
		
		local restartbtn = vgui.Create( "DButton" )
		restartbtn:SetParent(debugmenu)
		restartbtn:SetText(GAMEMODE.Strings.base.stop)
		restartbtn:SetPos( 20, 75 )
		restartbtn:SetSize( 265, 20 )
		restartbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_restart" )
			fnafgmMenuF:Close()
		end
		
		local resetbtn = vgui.Create( "DButton" )
		resetbtn:SetParent(debugmenu)
		resetbtn:SetText(GAMEMODE.Strings.base.reset)
		resetbtn:SetPos( 20, 105 )
		resetbtn:SetSize( 265, 20 )
		resetbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_reset" )
			fnafgmMenuF:Close()
		end
		
		local refreshbtn = vgui.Create( "DButton" )
		refreshbtn:SetParent(debugmenu)
		refreshbtn:SetText("Refresh Bypass")
		refreshbtn:SetPos( 20, 135 )
		refreshbtn:SetSize( 265, 20 )
		refreshbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_refreshbypass" )
			fnafgmMenuF:Close()
		end
		
		local infobtn = vgui.Create( "DButton" )
		infobtn:SetParent(debugmenu)
		infobtn:SetText("Info (Console)")
		infobtn:SetPos( 20, 165 )
		infobtn:SetSize( 265, 20 )
		infobtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_info" )
			fnafgmMenuF:Close()
		end
		
		
		
	else
		
		fnafgmMenuF:Close()
		
	end
	
end