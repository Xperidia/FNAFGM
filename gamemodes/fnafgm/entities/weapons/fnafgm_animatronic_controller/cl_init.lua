include( 'shared.lua' )

SWEP.BounceWeaponIcon = false
SWEP.WepSelectIcon = surface.GetTextureID(GAMEMODE.Materials_animatronic)


function fnafgmAnimatronicsController() 
	
	if !IsValid(AnimatronicsControllerGUI) then
		
		if game.GetMap()=="freddysnoevent" then
			if !lastcam then
				lastcam = 7
			end
		else
			if !lastcam then
				lastcam = 1
			end
		end
		
		if game.GetMap()=="freddysnoevent" then
			if !LastA then
				LastA = math.random( 0, 3 )
			end
		else
			if !LastA then
				LastA = math.random( 0, 3 )
			end
		end
		
		fnafgmSetView(lastcam)
		
		AnimatronicsControllerGUI = vgui.Create( "DFrame" )
		AnimatronicsControllerGUI:ParentToHUD()
		AnimatronicsControllerGUI:SetPos(0, 0)
		AnimatronicsControllerGUI:SetSize( ScrW(), ScrH() )
		AnimatronicsControllerGUI:SetTitle("")
		AnimatronicsControllerGUI:SetVisible(true)
		AnimatronicsControllerGUI:SetDraggable(false)
		AnimatronicsControllerGUI:ShowCloseButton(true)
		AnimatronicsControllerGUI:SetScreenLock(false)
		AnimatronicsControllerGUI:SetWorldClicker(true)
		AnimatronicsControllerGUI:MakePopup()
		AnimatronicsControllerGUI:SetKeyboardInputEnabled(false)
		AnimatronicsControllerGUI.Paint = function( self, w, h )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawOutlinedRect( 35, 30, w-70, h-60 )
		end
		AnimatronicsControllerGUI.OnClose = function()
			fnafgmSetView(0)
		end
		AnimatronicsControllerGUI.Think = function()
			if (!LocalPlayer():Alive() or tobool(tempostart)) then
				AnimatronicsControllerGUI:Close()
			end
			if AnimatronicsControllerGUI.Map2_Anim:Active() then AnimatronicsControllerGUI.Map2_Anim:Run() else AnimatronicsControllerGUI.Map2_Anim:Start(2) end
		end
		
		if game.GetMap()=="freddysnoevent" then
			
			local CamsNames = vgui.Create( "DLabel" )
			CamsNames:SetParent(AnimatronicsControllerGUI)
			CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
			CamsNames:SetTextColor( Color( 255, 255, 255, 255 ) )
			CamsNames:SetFont("FNAFGMTIME")
			CamsNames:SetPos( ScrW()-64-512, ScrH()-64-512-64 )
			CamsNames:SetSize( 512, 64 )
			
			AnimatronicsControllerGUI.Map = vgui.Create( "DImage" )
			AnimatronicsControllerGUI.Map:SetParent(AnimatronicsControllerGUI)
			AnimatronicsControllerGUI.Map:SetImage( "fnafgm/maps/freddys2" )
			AnimatronicsControllerGUI.Map:SetPos( ScrW()-64-512, ScrH()-64-512 )
			AnimatronicsControllerGUI.Map:SetSize( 512, 512 )
			
			AnimatronicsControllerGUI.Map2 = vgui.Create( "DImage" )
			AnimatronicsControllerGUI.Map2:SetParent(AnimatronicsControllerGUI.Map)
			AnimatronicsControllerGUI.Map2:SetImage( "fnafgm/maps/freddys2_s" )
			AnimatronicsControllerGUI.Map2:SetPos( 0, 0 )
			AnimatronicsControllerGUI.Map2:SetSize( 512, 512 )
			AnimatronicsControllerGUI.Map2:SetImageColor( GAMEMODE.Colors_animatronics )
			
			AnimatronicsControllerGUI.Map2_Anim = Derma_Anim( "map2_anim", AnimatronicsControllerGUI.Map2, function( pnl, anim, delta, data )
				pnl:SetImageColor( Color(255,0,0,255*math.abs(delta*2-1)) )
			end)
			
			AnimatronicsControllerGUI.Map2_Anim:Start(2)
			
			local CAM2B = vgui.Create( "DButton" )
			CAM2B:SetParent(AnimatronicsControllerGUI.Map)
			CAM2B:SetSize( 76, 50 )
			CAM2B:SetPos( 161, 408 )
			CAM2B:SetText("")
			CAM2B.OnMousePressed = function( button, key )
				if key==MOUSE_LEFT then
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView(1)
					lastcam = 1
					CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				elseif key==MOUSE_RIGHT then
					AnimatronicsControllerGUI:MoveMenu(1)
				end
			end
			CAM2B.Paint = function( self, w, h )
				if lastcam==1 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM2A = vgui.Create( "DButton" )
			CAM2A:SetParent(AnimatronicsControllerGUI.Map)
			CAM2A:SetSize( 76, 50 )
			CAM2A:SetPos( 161, 357 )
			CAM2A:SetText("")
			CAM2A.OnMousePressed = function( button, key )
				if key==MOUSE_LEFT then
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView(2)
					lastcam = 2
					CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				elseif key==MOUSE_RIGHT then
					AnimatronicsControllerGUI:MoveMenu(2)
				end
			end
			CAM2A.Paint = function( self, w, h )
				if lastcam==2 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM3 = vgui.Create( "DButton" )
			CAM3:SetParent(AnimatronicsControllerGUI.Map)
			CAM3:SetSize( 75, 49 )
			CAM3:SetPos( 54, 334 )
			CAM3:SetText("")
			CAM3.OnMousePressed = function( button, key )
				if key==MOUSE_LEFT then
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView(3)
					lastcam = 3
					CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				elseif key==MOUSE_RIGHT then
					AnimatronicsControllerGUI:MoveMenu(3)
				end
			end
			CAM3.Paint = function( self, w, h )
				if lastcam==3 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM4A = vgui.Create( "DButton" )
			CAM4A:SetParent(AnimatronicsControllerGUI.Map)
			CAM4A:SetSize( 75, 49 )
			CAM4A:SetPos( 297, 358 )
			CAM4A:SetText("")
			CAM4A.OnMousePressed = function( button, key )
				if key==MOUSE_LEFT then
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView(4)
					lastcam = 4
					CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				elseif key==MOUSE_RIGHT then
					AnimatronicsControllerGUI:MoveMenu(4)
				end
			end
			CAM4A.Paint = function( self, w, h )
				if lastcam==4 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM4B = vgui.Create( "DButton" )
			CAM4B:SetParent(AnimatronicsControllerGUI.Map)
			CAM4B:SetSize( 75, 48 )
			CAM4B:SetPos( 297, 410 )
			CAM4B:SetText("")
			CAM4B.OnMousePressed = function( button, key )
				if key==MOUSE_LEFT then
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView(5)
					lastcam = 5
					CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				elseif key==MOUSE_RIGHT then
					AnimatronicsControllerGUI:MoveMenu(5)
				end
			end
			CAM4B.Paint = function( self, w, h )
				if lastcam==5 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM5 = vgui.Create( "DButton" )
			CAM5:SetParent(AnimatronicsControllerGUI.Map)
			CAM5:SetSize( 76, 49 )
			CAM5:SetPos( 0, 143 )
			CAM5:SetText("")
			CAM5.OnMousePressed = function( button, key )
				if key==MOUSE_LEFT then
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView(6)
					lastcam = 6
					CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				elseif key==MOUSE_RIGHT then
					AnimatronicsControllerGUI:MoveMenu(6)
				end
			end
			CAM5.Paint = function( self, w, h )
				if lastcam==6 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM1A = vgui.Create( "DButton" )
			CAM1A:SetParent(AnimatronicsControllerGUI.Map)
			CAM1A:SetSize( 76, 49 )
			CAM1A:SetPos( 161, 37 )
			CAM1A:SetText("")
			CAM1A.OnMousePressed = function( button, key )
				if key==MOUSE_LEFT then
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView(7)
					lastcam = 7
					CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				elseif key==MOUSE_RIGHT then
					AnimatronicsControllerGUI:MoveMenu(7)
				end
			end
			CAM1A.Paint = function( self, w, h )
				if lastcam==7 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM7 = vgui.Create( "DButton" )
			CAM7:SetParent(AnimatronicsControllerGUI.Map)
			CAM7:SetSize( 76, 50 )
			CAM7:SetPos( 431, 143 )
			CAM7:SetText("")
			CAM7.OnMousePressed = function( button, key )
				if key==MOUSE_LEFT then
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView(8)
					lastcam = 8
					CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				elseif key==MOUSE_RIGHT then
					AnimatronicsControllerGUI:MoveMenu(8)
				end
			end
			CAM7.Paint = function( self, w, h )
				if lastcam==8 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM1C = vgui.Create( "DButton" )
			CAM1C:SetParent(AnimatronicsControllerGUI.Map)
			CAM1C:SetSize( 75, 49 )
			CAM1C:SetPos( 95, 208 )
			CAM1C:SetText("")
			CAM1C.OnMousePressed = function( button, key )
				if key==MOUSE_LEFT then
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView(9)
					lastcam = 9
					CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				elseif key==MOUSE_RIGHT then
					
				end
			end
			CAM1C.Paint = function( self, w, h )
				if lastcam==9 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM1B = vgui.Create( "DButton" )
			CAM1B:SetParent(AnimatronicsControllerGUI.Map)
			CAM1B:SetSize( 75, 48 )
			CAM1B:SetPos( 136, 109 )
			CAM1B:SetText("")
			CAM1B.OnMousePressed = function( button, key )
				if key==MOUSE_LEFT then
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView(10)
					lastcam = 10
					CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				elseif key==MOUSE_RIGHT then
					AnimatronicsControllerGUI:MoveMenu(10)
				end
			end
			CAM1B.Paint = function( self, w, h )
				if lastcam==10 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM6 = vgui.Create( "DButton" )
			CAM6:SetParent(AnimatronicsControllerGUI.Map)
			CAM6:SetSize( 76, 49 )
			CAM6:SetPos( 421, 312 )
			CAM6:SetText("")
			CAM6.OnMousePressed = function( button, key )
				if key==MOUSE_LEFT then
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView(11)
					lastcam = 11
					CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				elseif key==MOUSE_RIGHT then
					AnimatronicsControllerGUI:MoveMenu(11)
				end
			end
			CAM6.Paint = function( self, w, h )
				if lastcam==11 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local OFFICE = vgui.Create( "DButton" )
			OFFICE:SetParent(AnimatronicsControllerGUI.Map)
			OFFICE:SetSize( 51, 78 )
			OFFICE:SetPos( 228, 397 )
			OFFICE:SetText("")
			OFFICE.OnMousePressed = function( button, key )
				if key==MOUSE_LEFT then
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView(12)
					lastcam = 12
					CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				elseif key==MOUSE_RIGHT then
					AnimatronicsControllerGUI:MoveMenu(12)
				end
			end
			OFFICE.Paint = function( self, w, h )
				if lastcam==12 then
					draw.RoundedBox( 0, 2, 2, w-4, h-4, Color( 136, 168, 0, 128 ) )
				end
			end
			
		end
		
	end
	
	function AnimatronicsControllerGUI:MoveMenu(apos)
		
		local Menu = vgui.Create( "DMenu" )
		
		for k, v in pairs ( GAMEMODE.Vars.Animatronics ) do
			
			if GAMEMODE.Vars.Animatronics[k][2]!=apos and GAMEMODE.Vars.Animatronics[k][2]!=12 and GAMEMODE.AnimatronicAPos[k] and GAMEMODE.AnimatronicAPos[k][game.GetMap()] and GAMEMODE.AnimatronicAPos[k][game.GetMap()][apos] then
				local btn = Menu:AddOption( GAMEMODE.AnimatronicName[k] )
				btn:SetIcon( "fnafgm/icon16/"..k..".png" )
				btn.OnMousePressed = function( button, key )
					LastA = k
					GAMEMODE:SetAnimatronicPos(LastA,apos)
					Menu:Remove()
				end
			end
			
		end
		
		Menu:Open()
		
	end
	
end



net.Receive( "fnafgmAnimatronicsController", function( len )
	fnafgmAnimatronicsController() 
end)
