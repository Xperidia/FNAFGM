function fnafgmFNaFViewHUD()
	
	if !fnafviewactive then
		
		fnafviewactive = true
		
		net.Start( "fnafgmfnafViewActive" )
			net.WriteBit( true )
		net.SendToServer()
		
		if GAMEMODE.FNaFView[game.GetMap()][1] then LocalPlayer():SetPos( GAMEMODE.FNaFView[game.GetMap()][1] ) end
		if GAMEMODE.FNaFView[game.GetMap()][2] then LocalPlayer():SetEyeAngles( GAMEMODE.FNaFView[game.GetMap()][2] ) end
		
		FNaFView = vgui.Create( "DFrame" )
		FNaFView:SetPos( 0, 0 )
		FNaFView:SetSize( ScrW(), ScrH() )
		FNaFView:SetTitle("")
		FNaFView:SetVisible(true)
		FNaFView:SetDraggable(false)
		FNaFView:ShowCloseButton(false)
		FNaFView:SetScreenLock(false)
		FNaFView:SetPaintShadow(false)
		FNaFView:SetBackgroundBlur(false)
		FNaFView:SetWorldClicker(true)
		FNaFView:MakePopup()
		FNaFView:SetKeyboardInputEnabled(false)
		FNaFView.Paint = function( self, w, h )
			
		end
		FNaFView.OnClose = function()
			if usingsafezone then
				usingsafezone = false
				fnafgmSafeZone()
			end
			fnafviewactive = false
			net.Start( "fnafgmfnafViewActive" )
				net.WriteBit( false )
			net.SendToServer()
		end
		FNaFView.Think = function()
			
			if IsValid(MUTE) and tobool(mute) then
				MUTE:Remove()
				MUTEb:Remove()
			end
			
			if !LocalPlayer():Alive() or (power==0 and game.GetMap()!="fnaf2") then
				OpenT:Remove()
			end
			
			if !LocalPlayer():Alive() and IsValid(FNaFView) then
				FNaFView:Close()
			end
			
			if LocalPlayer():Alive() and IsValid(LeftZone) and vgui.GetHoveredPanel()==LeftZone and GAMEMODE.FNaFView[game.GetMap()][3] and LocalPlayer():EyeAngles()!=GAMEMODE.FNaFView[game.GetMap()][3] then
				LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles()+Angle( 0, 2, 0 ))
			end
			
			if LocalPlayer():Alive() and IsValid(RightZone) and vgui.GetHoveredPanel()==RightZone and GAMEMODE.FNaFView[game.GetMap()][4] and LocalPlayer():EyeAngles()!=GAMEMODE.FNaFView[game.GetMap()][4] then
				LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles()+Angle( 0, -2, 0 ))
			end
			
			if input.IsKeyDown( KEY_ESCAPE ) then
				FNaFView:Close()
			end
			
		end
		FNaFView.OnMousePressed = function( p, code )
			hook.Run( "GUIMousePressed", code, gui.ScreenToVector( gui.MousePos() ) )
		end
		
		LeftZone = vgui.Create( "DLabel" )
		LeftZone:SetParent(FNaFView)
		LeftZone:SetText("")
		LeftZone:SetWorldClicker(true)
		LeftZone:SetPos( 0, 32 )
		LeftZone:SetSize( ScrW()/3, ScrH()-32 )
		
		RightZone = vgui.Create( "DLabel" )
		RightZone:SetParent(FNaFView)
		RightZone:SetText("")
		RightZone:SetWorldClicker(true)
		RightZone:SetPos( ScrW()-ScrW()/3, 32 )
		RightZone:SetSize( ScrW()/3, ScrH()-32 )
		
		ExitZone = vgui.Create( "DButton" )
		ExitZone:SetParent(FNaFView)
		ExitZone:SetText("")
		ExitZone:SetTextColor( Color( 255, 255, 255, 255 ) )
		ExitZone:SetFont("FNAFGMNIGHT")
		ExitZone:SetPos( 0, 0 )
		ExitZone:SetSize( ScrW(), 40 )
		ExitZone.DoClick = function( button )
			FNaFView:Close()
		end
		ExitZone.Paint = function( self, w, h )
			
		end
		ExitZone.OnCursorEntered = function()
			ExitZone:SetText("Exit FNaF view")
		end
		ExitZone.OnCursorExited = function()
			ExitZone:SetText("")
		end
		
		if !tobool(mute) then
			MUTE = vgui.Create( "DImage" )
			MUTE:SetParent(FNaFView)
			MUTE:SetImage( "fnafgm/mute" )
			MUTE:SetSize( 128, 32 )
			MUTE:SetPos( 64, 64 )
			
			MUTEb = vgui.Create( "DButton" )
			MUTEb:SetParent(MUTE)
			MUTEb:SetSize( 121, 31 )
			MUTEb:SetPos( 0, 0 )
			MUTEb:SetText( "" )
			MUTEb.DoClick = function( button )
				fnafgmMuteCall()
				MUTE:Remove()
				MUTEb:Remove()
			end
			MUTEb.Paint = function( self, w, h )
				
			end
		end
		
		if game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent" then
			
			OpenT = vgui.Create( "DButton" )
			OpenT:SetParent(FNaFView)
			OpenT:SetSize( ScrW()/2-128, 80 )
			OpenT:SetPos( 512-128, ScrH()-80-50 )
			OpenT:SetText( "" )
			OpenT.DoClick = function( button )
				waitt = CurTime()+1
				fnafgmSecurityTablet()
				fnafgmShutLights()
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
				OpenT:Hide()
			end
			OpenT.OnCursorEntered = function()
				if !waitt then waitt=0 end
				if waitt<CurTime() then
					waitt = CurTime()+0.5
					fnafgmSecurityTablet()
					fnafgmShutLights()
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
					OpenT:Hide()
				end
			end
			OpenT.Paint = function( self, w, h )
				
				draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 255, 255, 255, 32 ) )
				
				surface.SetDrawColor( 255, 255, 255, 128 )
				
				draw.NoTexture()
				
				surface.DrawLine( w/2-64, h/2-16, w/2, h/2 )
				surface.DrawLine( w/2, h/2, w/2+64, h/2-16 )
				
				surface.DrawLine( w/2-64, h/2-16+16, w/2, h/2+16 )
				surface.DrawLine( w/2, h/2+16, w/2+64, h/2-16+16 )
				
				surface.DrawOutlinedRect( 0, 0, w, h )
				
			end
	
	
		elseif game.GetMap()=="fnaf2" then
		
			OpenT = vgui.Create( "DButton" )
			OpenT:SetParent(FNaFView)
			OpenT:SetSize( ScrW()/2 - 128, 64 )
			OpenT:SetPos( ScrW()/2 + 32, ScrH()-80-50 )
			OpenT:SetText( "" )
			OpenT.DoClick = function( button )
				waitt = CurTime()+1
				fnafgmSecurityTablet() 
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
				OpenT:Hide()
				SafeE:Hide()
			end
			OpenT.OnCursorEntered = function()
				if !waitt then waitt=0 end
				if waitt<CurTime() then
					waitt = CurTime()+0.5
					fnafgmSecurityTablet() 
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
					OpenT:Hide()
					SafeE:Hide()
				end
			end
			OpenT.Paint = function( self, w, h )
				
				draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 255, 255, 255, 32 ) )
				
				surface.SetDrawColor( 255, 255, 255, 128 )
				
				draw.NoTexture()
				
				surface.DrawLine( w/2-64, h/2-16, w/2, h/2 )
				surface.DrawLine( w/2, h/2, w/2+64, h/2-16 )
				
				surface.DrawLine( w/2-64, h/2-16+16, w/2, h/2+16 )
				surface.DrawLine( w/2, h/2+16, w/2+64, h/2-16+16 )
				
				surface.DrawOutlinedRect( 0, 0, w, h )
				
			end
			
			SafeE = vgui.Create( "DButton" )
			SafeE:SetParent(FNaFView)
			SafeE:SetSize( ScrW()/2 - 128, 64 )
			SafeE:SetPos( ScrW()/2 - ScrW()/2 + 128 - 32, ScrH()-80-50 )
			SafeE:SetText( "" )
			SafeE:SetTextColor( Color( 255, 255, 255, 255 ) )
			SafeE:SetFont("FNAFGMNIGHT")
			SafeE.DoClick = function( button )
				if !waits then waits=0 end
				if waits<CurTime() then
					waits = CurTime()+1
					if usingsafezone then
						OpenT:Show()
						LocalPlayer():ConCommand("play "..GAMEMODE.Sound_maskoff)
						usingsafezone = false
					elseif !usingsafezone then
						OpenT:Hide()
						LocalPlayer():ConCommand("play "..GAMEMODE.Sound_maskon)
						usingsafezone = true
					end
					fnafgmSafeZone()
				end
			end
			SafeE.OnCursorEntered = function()
				if !waits then waits=0 end
				if waits<CurTime() then
					waits = CurTime()+0.5
					if usingsafezone then
						OpenT:Show()
						LocalPlayer():ConCommand("play "..GAMEMODE.Sound_maskoff)
						usingsafezone = false
					elseif !usingsafezone then
						OpenT:Hide()
						LocalPlayer():ConCommand("play "..GAMEMODE.Sound_maskon)
						usingsafezone = true
					end
					fnafgmSafeZone()
				end
			end
			SafeE.Paint = function( self, w, h )
				
				draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 255, 85, 85, 32 ) )
				
				surface.SetDrawColor( 255, 85, 85, 128 )
				
				draw.NoTexture()
				
				surface.DrawLine( w/2-64, h/2-16, w/2, h/2 )
				surface.DrawLine( w/2, h/2, w/2+64, h/2-16 )
				
				surface.DrawLine( w/2-64, h/2-16+16, w/2, h/2+16 )
				surface.DrawLine( w/2, h/2+16, w/2+64, h/2-16+16 )
				
				surface.DrawOutlinedRect( 0, 0, w, h )
				
			end
			
			
		elseif game.GetMap()=="fnap_scc" then
		
			OpenT = vgui.Create( "DButton" )
			OpenT:SetParent(FNaFView)
			OpenT:SetSize( 512, 80 )
			OpenT:SetPos( ScrW()/2-256, ScrH()-80-50 )
			OpenT:SetText( "" )
			OpenT.DoClick = function( button )
				waitt = CurTime()+1
				fnafgmSecurityTablet() 
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
				OpenT:Hide()
			end
			OpenT.OnCursorEntered = function()
				if !waitt then waitt=0 end
				if waitt<CurTime() then
					waitt = CurTime()+0.5
					fnafgmSecurityTablet() 
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
					OpenT:Hide()
				end
			end
			OpenT.Paint = function( self, w, h )
				
				draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 255, 255, 255, 32 ) )
				
				surface.SetDrawColor( 255, 255, 255, 128 )
				
				draw.NoTexture()
				
				surface.DrawLine( w/2-64, h/2-16, w/2, h/2 )
				surface.DrawLine( w/2, h/2, w/2+64, h/2-16 )
				
				surface.DrawLine( w/2-64, h/2-16+16, w/2, h/2+16 )
				surface.DrawLine( w/2, h/2+16, w/2+64, h/2-16+16 )
				
				surface.DrawOutlinedRect( 0, 0, w, h )
				
			end
			
			
		else
			
			OpenT = vgui.Create( "DButton" )
			OpenT:SetParent(FNaFView)
			OpenT:SetSize( 512, 80 )
			OpenT:SetPos( ScrW()/2-256, ScrH()-80-50 )
			OpenT:SetText( "" )
			OpenT.DoClick = function( button )
				waitt = CurTime()+1
				fnafgmSecurityTablet() 
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
				OpenT:Hide()
			end
			OpenT.OnCursorEntered = function()
				if !waitt then waitt=0 end
				if waitt<CurTime() then
					waitt = CurTime()+0.5
					fnafgmSecurityTablet() 
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
					OpenT:Hide()
				end
			end
			OpenT.Paint = function( self, w, h )
				
				draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 255, 255, 255, 32 ) )
				
				surface.SetDrawColor( 255, 255, 255, 128 )
				
				draw.NoTexture()
				
				surface.DrawLine( w/2-64, h/2-16, w/2, h/2 )
				surface.DrawLine( w/2, h/2, w/2+64, h/2-16 )
				
				surface.DrawLine( w/2-64, h/2-16+16, w/2, h/2+16 )
				surface.DrawLine( w/2, h/2+16, w/2+64, h/2-16+16 )
				
				surface.DrawOutlinedRect( 0, 0, w, h )
				
			end
			
			
		end
		
	end
	
end