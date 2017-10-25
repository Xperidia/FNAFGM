function fnafgmMenu()
	
	if !IsValid(fnafgmMenuF) and !engine.IsPlayingDemo() then
		
		
		fnafgmMenuF = vgui.Create( "DFrame" )
		fnafgmMenuF:SetPos( ScrW()/2-320, ScrH()/2-240 )
		fnafgmMenuF:SetSize( 640, 480 )
		fnafgmMenuF:SetTitle((GAMEMODE.Name or "?").." Gamemode V"..(GAMEMODE.Version or "?")..(GAMEMODE.Vars.modetext or " - Final version")..(GAMEMODE.Vars.seasonaltext or ""))
		fnafgmMenuF:SetVisible(true)
		fnafgmMenuF:SetDraggable(true)
		fnafgmMenuF:ShowCloseButton(true)
		fnafgmMenuF:SetScreenLock(true)
		fnafgmMenuF.Paint = function( self, w, h )
			draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 128 ) )
		end
		fnafgmMenuF.Think = function(self)
			
			local mousex = math.Clamp( gui.MouseX(), 1, ScrW()-1 )
			local mousey = math.Clamp( gui.MouseY(), 1, ScrH()-1 )
		
			if ( self.Dragging ) then
		
				local x = mousex - self.Dragging[1]
				local y = mousey - self.Dragging[2]
		
				-- Lock to screen bounds if screenlock is enabled
				if ( self:GetScreenLock() ) then
		
					x = math.Clamp( x, 0, ScrW() - self:GetWide() )
					y = math.Clamp( y, 0, ScrH() - self:GetTall() )
		
				end
		
				self:SetPos( x, y )
		
			end
				
			if ( self.Hovered && mousey < ( self.y + 24 ) ) then
				self:SetCursor( "sizeall" )
				return
			end
			
			self:SetCursor( "arrow" )

			if ( self.y < 0 ) then
				self:SetPos( self.x, 0 )
			end
			
		end
		fnafgmMenuF:MakePopup()
		fnafgmMenuF:SetKeyboardInputEnabled(false)
		
		GAMEMODE:LoadProgress()
		
		fnafgmMenuF.links = vgui.Create( "DPanel" )
		fnafgmMenuF.links:SetParent(fnafgmMenuF)
		fnafgmMenuF.links:SetPos( 10, 30 )
		fnafgmMenuF.links:SetSize( 305, 215 )
		
		local linkslbl = vgui.Create( "DLabel" )
		linkslbl:SetParent(fnafgmMenuF.links)
		linkslbl:SetText( tostring(GAMEMODE.TranslatedStrings.links or GAMEMODE.Strings.en.links) )
		linkslbl:SetPos( 10, 5 )
		linkslbl:SetDark( 1 )
		linkslbl:SizeToContents()
		
		local websitebtn = vgui.Create( "DButton" )
		websitebtn:SetParent(fnafgmMenuF.links)
		websitebtn:SetText( GAMEMODE.ShortName.." Workshop page" )
		websitebtn:SetPos( 20, 60 )
		websitebtn:SetSize( 265, 80 )
		websitebtn.DoClick = function()
			local url = ""
			if GAMEMODE.Website:find( "://", 1, true ) then
				url = GAMEMODE.Website
			else
				url = "http://" .. GAMEMODE.Website
			end
			gui.OpenURL( url )
			fnafgmMenuF:Close()
		end
		
		local xpucp = vgui.Create( "DButton" )
		xpucp:SetParent(fnafgmMenuF.links)
		xpucp:SetText( "Xperidia Account" )
		xpucp:SetPos( 20, 30 )
		xpucp:SetSize( 125, 20 )
		xpucp.DoClick = function()
			gui.OpenURL( "https://www.xperidia.com/UCP/" )
			fnafgmMenuF:Close()
		end
		
		local xpsteam = vgui.Create( "DButton" )
		xpsteam:SetParent(fnafgmMenuF.links)
		xpsteam:SetText( "Xperidia's Discord server" )
		xpsteam:SetPos( 160, 30 )
		xpsteam:SetSize( 125, 20 )
		xpsteam.DoClick = function()
			gui.OpenURL( "https://discord.gg/jtUtYDa " )
			fnafgmMenuF:Close()
		end
		
		if engine.ActiveGamemode()=="fnafgm" then
			
			questionbtn = vgui.Create( "DButton" )
			questionbtn:SetParent(fnafgmMenuF.links)
			questionbtn:SetText( tostring(GAMEMODE.TranslatedStrings.faqbtn or GAMEMODE.Strings.en.faqbtn) )
			questionbtn:SetPos( 10, 185 )
			questionbtn:SetSize( 140, 20 )
			questionbtn.DoClick = function()
				gui.OpenURL( "http://steamcommunity.com/workshop/filedetails/discussion/408243366/494632338490289695/" )
				fnafgmMenuF:Close()
			end
			
			bugreportbtn = vgui.Create( "DButton" )
			bugreportbtn:SetParent(fnafgmMenuF.links)
			bugreportbtn:SetText( "Support" )
			bugreportbtn:SetPos( 155, 185 )
			bugreportbtn:SetSize( 140, 20 )
			bugreportbtn.DoClick = function()
				gui.OpenURL( "https://discord.gg/jtUtYDa" )
				fnafgmMenuF:Close()
			end
			
		end
		
		
		
		fnafgmMenuF.config = vgui.Create( "DPanel" )
		fnafgmMenuF.config:SetParent(fnafgmMenuF)
		fnafgmMenuF.config:SetPos( 325, 30 )
		fnafgmMenuF.config:SetSize( 305, 215 )
		
		local configlbl = vgui.Create( "DLabel" )
		configlbl:SetParent(fnafgmMenuF.config)
		configlbl:SetText( tostring(GAMEMODE.TranslatedStrings.config or GAMEMODE.Strings.en.config) )
		configlbl:SetPos( 10, 5 )
		configlbl:SetDark( 1 )
		configlbl:SizeToContents()
		
		local hideversion = vgui.Create( "DCheckBoxLabel" )
		hideversion:SetParent(fnafgmMenuF.config)
		hideversion:SetText(tostring(GAMEMODE.TranslatedStrings.hidever or GAMEMODE.Strings.en.hidever))
		hideversion:SetPos( 15, 30 )
		hideversion:SetDark( 1 )
		hideversion:SetConVar( "fnafgm_cl_hideversion" )
		hideversion:SetValue( GetConVar("fnafgm_cl_hideversion"):GetBool() )
		hideversion:SizeToContents()
		
		local warn = vgui.Create( "DCheckBoxLabel" )
		warn:SetParent(fnafgmMenuF.config)
		warn:SetText("Warn")
		warn:SetPos( 15, 50 )
		warn:SetDark( 1 )
		warn:SetConVar( "fnafgm_cl_warn" )
		warn:SetValue( GetConVar("fnafgm_cl_warn"):GetBool() )
		warn:SizeToContents()
		
		local autofnafview = vgui.Create( "DCheckBoxLabel" )
		autofnafview:SetParent(fnafgmMenuF.config)
		autofnafview:SetText(tostring(GAMEMODE.TranslatedStrings.autofnafview or GAMEMODE.Strings.en.autofnafview))
		autofnafview:SetPos( 15, 70 )
		autofnafview:SetDark( 1 )
		autofnafview:SetConVar( "fnafgm_cl_autofnafview" )
		autofnafview:SetValue( GetConVar("fnafgm_cl_autofnafview"):GetBool() )
		autofnafview:SizeToContents()
		
		local hud = vgui.Create( "DCheckBoxLabel" )
		hud:SetParent(fnafgmMenuF.config)
		hud:SetText(tostring(GAMEMODE.TranslatedStrings.dhud or GAMEMODE.Strings.en.dhud))
		hud:SetPos( 15, 90 )
		hud:SetDark( 1 )
		hud:SetConVar( "cl_drawhud" )
		hud:SetValue( GetConVar("cl_drawhud"):GetBool() )
		hud:SizeToContents()
		
		local chatsound = vgui.Create( "DCheckBoxLabel" )
		chatsound:SetParent(fnafgmMenuF.config)
		chatsound:SetText(tostring(GAMEMODE.TranslatedStrings.chatsound or GAMEMODE.Strings.en.chatsound))
		chatsound:SetPos( 15, 110 )
		chatsound:SetDark( 1 )
		chatsound:SetConVar( "fnafgm_cl_chatsound" )
		chatsound:SetValue( GetConVar("fnafgm_cl_chatsound"):GetBool() )
		chatsound:SizeToContents()
		
		local flashwindow = vgui.Create( "DCheckBoxLabel" )
		flashwindow:SetParent(fnafgmMenuF.config)
		flashwindow:SetText(tostring(GAMEMODE.TranslatedStrings.flashwindow or GAMEMODE.Strings.en.flashwindow))
		flashwindow:SetPos( 15, 130 )
		flashwindow:SetDark( 1 )
		flashwindow:SetConVar( "fnafgm_cl_flashwindow" )
		flashwindow:SetValue( GetConVar("fnafgm_cl_flashwindow"):GetBool() )
		flashwindow:SizeToContents()
		
		local saveserver = vgui.Create( "DCheckBoxLabel" )
		saveserver:SetParent(fnafgmMenuF.config)
		saveserver:SetText(tostring(GAMEMODE.TranslatedStrings.saveserver or GAMEMODE.Strings.en.saveserver))
		saveserver:SetPos( 15, 150 )
		saveserver:SetDark( 1 )
		saveserver:SetConVar( "fnafgm_cl_saveonservers" )
		saveserver:SetValue( GetConVar("fnafgm_cl_saveonservers"):GetBool() )
		saveserver:SizeToContents()
		
		local disablehalo = vgui.Create( "DCheckBoxLabel" )
		disablehalo:SetParent(fnafgmMenuF.config)
		disablehalo:SetText(tostring(GAMEMODE.TranslatedStrings.disablehalo or GAMEMODE.Strings.en.disablehalo))
		disablehalo:SetPos( 15, 170 )
		disablehalo:SetDark( 1 )
		disablehalo:SetConVar( "fnafgm_cl_disablehalos" )
		disablehalo:SetValue( GetConVar("fnafgm_cl_disablehalos"):GetBool() )
		disablehalo:SizeToContents()
		
		
		
		fnafgmMenuF.info = vgui.Create( "DPanel" )
		fnafgmMenuF.info:SetParent(fnafgmMenuF)
		fnafgmMenuF.info:SetPos( 10, 255 )
		fnafgmMenuF.info:SetSize( 305, 215 )
		
		local infolbl = vgui.Create( "DLabel" )
		infolbl:SetParent(fnafgmMenuF.info)
		infolbl:SetText( tostring(GAMEMODE.TranslatedStrings.infoat or GAMEMODE.Strings.en.infoat) )
		infolbl:SetPos( 10, 5 )
		infolbl:SetDark( 1 )
		infolbl:SizeToContents()
		
		local cssinfo = vgui.Create( "DLabel" )
		cssinfo:SetParent(fnafgmMenuF.info)
		cssinfo:SetText( "Counter Strike: Source: "..tostring(IsMounted( 'cstrike' ) or "false") )
		cssinfo:SetPos( 15, 30 )
		cssinfo:SetDark( 1 )
		cssinfo:SizeToContents()
		
		local langinfo = vgui.Create( "DLabel" )
		langinfo:SetParent(fnafgmMenuF.info)
		langinfo:SetText( tostring(GAMEMODE.TranslatedStrings.lang or GAMEMODE.Strings.en.lang)..": "..GetConVarString("gmod_language") )
		langinfo:SetPos( 15, 50 )
		langinfo:SetDark( 1 )
		langinfo:SizeToContents()
		
		local progressinfo = vgui.Create( "DLabel" )
		progressinfo:SetParent(fnafgmMenuF.info)
		progressinfo:SetText( tostring(GAMEMODE.TranslatedStrings.progressinfo or GAMEMODE.Strings.en.progressinfo)..": "..(nightp or "?") )
		progressinfo:SetPos( 15, 70 )
		progressinfo:SetDark( 1 )
		progressinfo:SizeToContents()
		
		local mapselectb = vgui.Create( "DButton" )
		mapselectb:SetParent(fnafgmMenuF.info)
		mapselectb:SetText(tostring(GAMEMODE.TranslatedStrings.changemap or GAMEMODE.Strings.en.changemap))
		mapselectb:SetPos( 10, 185 )
		mapselectb:SetSize( 285, 20 )
		mapselectb:SetEnabled(LocalPlayer():IsAdmin())
		mapselectb.DoClick = function()
			RunConsoleCommand( "fnafgm_mapselect" )
			fnafgmMenuF:Close()
		end
		
		local secretb = vgui.Create( "DButton" )
		secretb:SetParent(fnafgmMenuF.info)
		secretb:SetText(tostring(GAMEMODE.TranslatedStrings.password or GAMEMODE.Strings.en.password))
		secretb:SetPos( 10, 160 )
		secretb:SetSize( 285, 20 )
		secretb.DoClick = function()
			fnafgmSecret()
			fnafgmMenuF:Close()
		end
		
		local resetprogress = vgui.Create( "DButton" )
		resetprogress:SetParent(fnafgmMenuF.info)
		resetprogress:SetText(tostring(GAMEMODE.TranslatedStrings.resetsave or GAMEMODE.Strings.en.resetsave))
		resetprogress:SetPos( 10, 135 )
		resetprogress:SetSize( 285, 20 )
		resetprogress.DoClick = function()
			GAMEMODE:SaveProgress(true)
			fnafgmMenuF:Close()
		end
		
		local add = 0
		
		if !game.SinglePlayer() then
			
			local togglesgvsa = vgui.Create( "DButton" )
			togglesgvsa:SetParent(fnafgmMenuF.info)
			togglesgvsa:SetText(tostring(GAMEMODE.TranslatedStrings.togglesgvsa or GAMEMODE.Strings.en.togglesgvsa))
			togglesgvsa:SetPos( 10, 110 )
			togglesgvsa:SetSize( 285, 20 )
			togglesgvsa:SetEnabled(LocalPlayer():IsAdmin())
			togglesgvsa.DoClick = function()
				RunConsoleCommand( "fnafgm_togglesgvsa" )
				fnafgmMenuF:Close()
			end
			
			add = 25
			
		end
		
		if ConVarExists( "sv_playermodel_selector_gamemodes" ) then
			
			local playermodelselection = vgui.Create( "DButton" )
			playermodelselection:SetParent(fnafgmMenuF.info)
			playermodelselection:SetText(tostring(GAMEMODE.TranslatedStrings.selectplayermodelbtn or GAMEMODE.Strings.en.selectplayermodelbtn))
			playermodelselection:SetPos( 10, 110-add )
			playermodelselection:SetSize( 285, 20 )
			playermodelselection:SetEnabled( GetConVar( "sv_playermodel_selector_gamemodes" ):GetBool() or LocalPlayer():IsAdmin() or LocalPlayer():IsUserGroup( "premium" ) )
			playermodelselection.DoClick = function()
				RunConsoleCommand( "playermodel_selector" )
				fnafgmMenuF:Close()
			end
			
		end
		
		
		
		fnafgmMenuF.debugmenu = vgui.Create( "DPanel" )
		fnafgmMenuF.debugmenu:SetParent(fnafgmMenuF)
		fnafgmMenuF.debugmenu:SetPos( 325, 255 )
		fnafgmMenuF.debugmenu:SetSize( 305, 215 )
		
		local debugmenulbl = vgui.Create( "DLabel" )
		debugmenulbl:SetParent(fnafgmMenuF.debugmenu)
		debugmenulbl:SetText( tostring(GAMEMODE.TranslatedStrings.debugmenu or GAMEMODE.Strings.en.debugmenu) )
		debugmenulbl:SetPos( 10, 5 )
		debugmenulbl:SetDark( 1 )
		debugmenulbl:SizeToContents()
		
		local startbtn = vgui.Create( "DButton" )
		startbtn:SetParent(fnafgmMenuF.debugmenu)
		startbtn:SetText(tostring(GAMEMODE.TranslatedStrings.start or GAMEMODE.Strings.en.start))
		startbtn:SetPos( 20, 45 )
		startbtn:SetSize( 265, 20 )
		startbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_start" )
			fnafgmMenuF:Close()
		end
		
		local restartbtn = vgui.Create( "DButton" )
		restartbtn:SetParent(fnafgmMenuF.debugmenu)
		restartbtn:SetText(tostring(GAMEMODE.TranslatedStrings.stop or GAMEMODE.Strings.en.stop))
		restartbtn:SetPos( 20, 75 )
		restartbtn:SetSize( 265, 20 )
		restartbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_restart" )
			fnafgmMenuF:Close()
		end
		
		local resetbtn = vgui.Create( "DButton" )
		resetbtn:SetParent(fnafgmMenuF.debugmenu)
		resetbtn:SetText(tostring(GAMEMODE.TranslatedStrings.reset or GAMEMODE.Strings.en.reset))
		resetbtn:SetPos( 20, 105 )
		resetbtn:SetSize( 265, 20 )
		resetbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_reset" )
			fnafgmMenuF:Close()
		end
		
		local refreshbtn = vgui.Create( "DButton" )
		refreshbtn:SetParent(fnafgmMenuF.debugmenu)
		refreshbtn:SetText(tostring(GAMEMODE.TranslatedStrings.refreshbypass or GAMEMODE.Strings.en.refreshbypass))
		refreshbtn:SetPos( 20, 135 )
		refreshbtn:SetSize( 265, 20 )
		refreshbtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_refreshbypass" )
			fnafgmMenuF:Close()
		end
		
		local infobtn = vgui.Create( "DButton" )
		infobtn:SetParent(fnafgmMenuF.debugmenu)
		infobtn:SetText("Info (Console)")
		infobtn:SetPos( 20, 165 )
		infobtn:SetSize( 265, 20 )
		infobtn.DoClick = function()
			RunConsoleCommand( "fnafgm_debug_info" )
			fnafgmMenuF:Close()
		end
		
		hook.Call("fnafgmMenuCustom")
		
		
	elseif IsValid(fnafgmMenuF) then
		
		fnafgmMenuF:Close()
		
	end
	
end