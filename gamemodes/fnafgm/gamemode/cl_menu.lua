function fnafgmMenu()
	
	if !IsValid(fnafgmMenuF) then
				
		fnafgmMenuF = vgui.Create( "DFrame" )
		fnafgmMenuF:SetPos( ScrW()/2-120, ScrH()/2-75 )
		fnafgmMenuF:SetSize( 240, 150 )
		fnafgmMenuF:SetTitle(GAMEMODE.ShortName.." Menu")
		fnafgmMenuF:SetVisible(true)
		fnafgmMenuF:SetDraggable(true)
		fnafgmMenuF:ShowCloseButton(true)
		fnafgmMenuF:SetScreenLock(true)
		fnafgmMenuF:MakePopup()
		
		hideversion = vgui.Create( "DCheckBoxLabel" )
		hideversion:SetParent(fnafgmMenuF)
		hideversion:SetText("Hide version")
		hideversion:SetPos( 25, 40 )
		hideversion:SetConVar( "fnafgm_cl_hideversion" )
		hideversion:SetValue( GetConVar("fnafgm_cl_hideversion"):GetBool() )
		hideversion:SizeToContents()
		
		warn = vgui.Create( "DCheckBoxLabel" )
		warn:SetParent(fnafgmMenuF)
		warn:SetText("Warn")
		warn:SetPos( 25, 60 )
		warn:SetConVar( "fnafgm_cl_warn" )
		warn:SetValue( GetConVar("fnafgm_cl_warn"):GetBool() )
		warn:SizeToContents()
		
		mapselectb = vgui.Create( "DButton" )
		mapselectb:SetParent(fnafgmMenuF)
		mapselectb:SetText("Select Map (Admin only)")
		mapselectb:SetPos( 25, 85 )
		mapselectb:SetSize( 190, 20 )
		mapselectb.DoClick = function()
			RunConsoleCommand( "fnafgm_mapselect" )
			fnafgmMenuF:Close()
		end
		
		debugbtn = vgui.Create( "DButton" )
		debugbtn:SetParent(fnafgmMenuF)
		debugbtn:SetText("Debug Menu (Debug only)")
		debugbtn:SetPos( 25, 110 )
		debugbtn:SetSize( 190, 20 )
		debugbtn.DoClick = function()
			fnafgmDebugMenu()
			fnafgmMenuF:Close()
		end
		
	end
	
end


function fnafgmDebugMenu()
	
	if !IsValid(debugmenu) then

		debugmenu = vgui.Create( "DFrame" )
		debugmenu:SetPos( ScrW()/2-120, ScrH()/2-80 )
		debugmenu:SetSize( 240, 160 )
		debugmenu:SetTitle("Debug Menu")
		debugmenu:SetVisible(true)
		debugmenu:SetDraggable(true)
		debugmenu:ShowCloseButton(true)
		debugmenu:SetScreenLock(true)
		debugmenu:MakePopup()
		
		startbtn = vgui.Create( "DButton" )
		startbtn:SetParent(debugmenu)
		startbtn:SetText("Start")
		startbtn:SetPos( 25, 40 )
		startbtn:SetSize( 190, 20 )
		startbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_start" )
		end
		
		restartbtn = vgui.Create( "DButton" )
		restartbtn:SetParent(debugmenu)
		restartbtn:SetText("Stop/Restart")
		restartbtn:SetPos( 25, 60 )
		restartbtn:SetSize( 190, 20 )
		restartbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_restart" )
		end
		
		resetbtn = vgui.Create( "DButton" )
		resetbtn:SetParent(debugmenu)
		resetbtn:SetText("Reset")
		resetbtn:SetPos( 25, 80 )
		resetbtn:SetSize( 190, 20 )
		resetbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_reset" )
		end
		
		refreshbtn = vgui.Create( "DButton" )
		refreshbtn:SetParent(debugmenu)
		refreshbtn:SetText("Refresh Bypass")
		refreshbtn:SetPos( 25, 100 )
		refreshbtn:SetSize( 190, 20 )
		refreshbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_refreshbypass" )
		end
		
		infobtn = vgui.Create( "DButton" )
		infobtn:SetParent(debugmenu)
		infobtn:SetText("Info (Console)")
		infobtn:SetPos( 25, 120 )
		infobtn:SetSize( 190, 20 )
		infobtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_info" )
		end
		
	end
	
end