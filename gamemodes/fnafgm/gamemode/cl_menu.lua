function fnafgmMenu()
	
	if !IsValid(fnafgmMenuF) then
			
			
		fnafgmMenuF = vgui.Create( "DFrame" )
		fnafgmMenuF:SetPos( ScrW()/2-320, ScrH()/2-240 )
		fnafgmMenuF:SetSize( 640, 480 )
		fnafgmMenuF:SetTitle(GAMEMODE.ShortName.." Menu")
		fnafgmMenuF:SetVisible(true)
		fnafgmMenuF:SetDraggable(true)
		fnafgmMenuF:ShowCloseButton(true)
		fnafgmMenuF:SetScreenLock(true)
		fnafgmMenuF.Paint = function( self, w, h )
			draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 128 ) )
		end
		fnafgmMenuF:MakePopup()
		
		
		local links = vgui.Create( "DPanel" )
		links:SetParent(fnafgmMenuF)
		links:SetPos( 10, 30 )
		links:SetSize( 305, 215 )
		
		local linkslbl = vgui.Create( "DLabel" )
		linkslbl:SetParent(links)
		linkslbl:SetText( "Link(s)" )
		linkslbl:SetPos( 10, 5 )
		linkslbl:SetDark( 1 )
		linkslbl:SizeToContents()
		
		websitebtn = vgui.Create( "DButton" )
		websitebtn:SetParent(links)
		websitebtn:SetText( GAMEMODE.ShortName.." Workshop page" )
		websitebtn:SetPos( 20, 60 )
		websitebtn:SetSize( 265, 80 )
		websitebtn.DoClick = function()
			gui.OpenURL( GAMEMODE.Website )
			fnafgmMenuF:Close()
		end
		
		if engine.ActiveGamemode()=="fnafgm" then
			
			questionbtn = vgui.Create( "DButton" )
			questionbtn:SetParent(links)
			questionbtn:SetText( "Questions/Help/FAQ/Tips" )
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
		configlbl:SetText( "Config" )
		configlbl:SetPos( 10, 5 )
		configlbl:SetDark( 1 )
		configlbl:SizeToContents()
		
		hideversion = vgui.Create( "DCheckBoxLabel" )
		hideversion:SetParent(config)
		hideversion:SetText("Hide version")
		hideversion:SetPos( 15, 30 )
		hideversion:SetDark( 1 )
		hideversion:SetConVar( "fnafgm_cl_hideversion" )
		hideversion:SetValue( GetConVar("fnafgm_cl_hideversion"):GetBool() )
		hideversion:SizeToContents()
		
		warn = vgui.Create( "DCheckBoxLabel" )
		warn:SetParent(config)
		warn:SetText("Warn")
		warn:SetPos( 15, 50 )
		warn:SetDark( 1 )
		warn:SetConVar( "fnafgm_cl_warn" )
		warn:SetValue( GetConVar("fnafgm_cl_warn"):GetBool() )
		warn:SizeToContents()
		
		
		
		local info = vgui.Create( "DPanel" )
		info:SetParent(fnafgmMenuF)
		info:SetPos( 10, 255 )
		info:SetSize( 305, 215 )
		
		local infolbl = vgui.Create( "DLabel" )
		infolbl:SetParent(info)
		infolbl:SetText( "Info/Misc" )
		infolbl:SetPos( 10, 5 )
		infolbl:SetDark( 1 )
		infolbl:SizeToContents()
		
		local fontinfo = vgui.Create( "DLabel" )
		fontinfo:SetParent(info)
		fontinfo:SetText( "Font loaded: "..tostring(fontloaded or "false") )
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
		
		if LocalPlayer():IsAdmin() then
			
			mapselectb = vgui.Create( "DButton" )
			mapselectb:SetParent(info)
			mapselectb:SetText("Change Map")
			mapselectb:SetPos( 10, 185 )
			mapselectb:SetSize( 285, 20 )
			mapselectb.DoClick = function()
				RunConsoleCommand( "fnafgm_mapselect" )
				fnafgmMenuF:Close()
			end
			
		end
		
		
		
		local debugmenu = vgui.Create( "DPanel" )
		debugmenu:SetParent(fnafgmMenuF)
		debugmenu:SetPos( 325, 255 )
		debugmenu:SetSize( 305, 215 )
		
		local debugmenulbl = vgui.Create( "DLabel" )
		debugmenulbl:SetParent(debugmenu)
		debugmenulbl:SetText( "Debug Menu (Debug access only)" )
		debugmenulbl:SetPos( 10, 5 )
		debugmenulbl:SetDark( 1 )
		debugmenulbl:SizeToContents()
		
		startbtn = vgui.Create( "DButton" )
		startbtn:SetParent(debugmenu)
		startbtn:SetText("Start")
		startbtn:SetPos( 20, 45 )
		startbtn:SetSize( 265, 20 )
		startbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_start" )
		end
		
		restartbtn = vgui.Create( "DButton" )
		restartbtn:SetParent(debugmenu)
		restartbtn:SetText("Stop/Restart")
		restartbtn:SetPos( 20, 75 )
		restartbtn:SetSize( 265, 20 )
		restartbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_restart" )
		end
		
		resetbtn = vgui.Create( "DButton" )
		resetbtn:SetParent(debugmenu)
		resetbtn:SetText("Reset")
		resetbtn:SetPos( 20, 105 )
		resetbtn:SetSize( 265, 20 )
		resetbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_reset" )
		end
		
		refreshbtn = vgui.Create( "DButton" )
		refreshbtn:SetParent(debugmenu)
		refreshbtn:SetText("Refresh Bypass")
		refreshbtn:SetPos( 20, 135 )
		refreshbtn:SetSize( 265, 20 )
		refreshbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_refreshbypass" )
		end
		
		infobtn = vgui.Create( "DButton" )
		infobtn:SetParent(debugmenu)
		infobtn:SetText("Info (Console)")
		infobtn:SetPos( 20, 165 )
		infobtn:SetSize( 265, 20 )
		infobtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_info" )
		end
		
		
	end
	
end