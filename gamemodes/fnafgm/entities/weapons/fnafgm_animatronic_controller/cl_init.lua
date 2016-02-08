include( 'shared.lua' )

SWEP.BounceWeaponIcon = false
SWEP.WepSelectIcon = surface.GetTextureID(GAMEMODE.Materials_animatronic)


function fnafgmAnimatronicsController() 
	
	if !IsValid(AnimatronicsControllerGUI) then
		
		if !nopeinit then
			if game.GetMap()=="freddysnoevent" then
				if !lastcam then
					lastcam = 7
				end
			else
				if !lastcam then
					lastcam = 1
				end
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
		end
		
		if game.GetMap()=="freddysnoevent" then
			
			local CamsNames = vgui.Create( "DLabel" )
			CamsNames:SetParent(AnimatronicsControllerGUI)
			CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
			CamsNames:SetTextColor( Color( 255, 255, 255, 255 ) )
			CamsNames:SetFont("FNAFGMTIME")
			CamsNames:SetPos( ScrW()-64-512, ScrH()-64-512-64 )
			CamsNames:SetSize( 512, 64 )
			
			local KitchenText = vgui.Create( "DLabel" )
			KitchenText:SetParent(AnimatronicsControllerGUI)
			KitchenText:SetText( "-CAMERA DISABLED-" )
			KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
			KitchenText:SetFont("FNAFGMTIME")
			KitchenText:SetPos( ScrW()/2-256, 80 )
			KitchenText:SetContentAlignment( 8 )
			KitchenText:SizeToContents()
			
			local KitchenText2 = vgui.Create( "DLabel" )
			KitchenText2:SetParent(AnimatronicsControllerGUI)
			KitchenText2:SetText( "AUDIO ONLY" )
			KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
			KitchenText2:SetFont("FNAFGMTIME")
			KitchenText2:SetPos( ScrW()/2-150, 80+60 )
			KitchenText2:SetContentAlignment( 8 )
			KitchenText2:SizeToContents()
			
			if lastcam==11 then
				KitchenText:SetTextColor( Color( 255, 255, 255, 255 ) )
				KitchenText2:SetTextColor( Color( 255, 255, 255, 255 ) )
			end
			
			local map = vgui.Create( "DImage" )
			map:SetParent(AnimatronicsControllerGUI)
			map:SetImage( GAMEMODE.Materials_mapfreddys )
			map:SetPos( ScrW()-64-512, ScrH()-64-512 )
			map:SetSize( 512, 512 )
			
			local CAM2B = vgui.Create( "DButton" )
			CAM2B:SetParent(map)
			CAM2B:SetSize( 76, 50 )
			CAM2B:SetPos( 161, 408 )
			CAM2B:SetText("")
			CAM2B.DoClick = function( button )
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
				fnafgmSetView(1)
				lastcam = 1
				CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
				KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
			end
			CAM2B.Paint = function( self, w, h )
				if lastcam==1 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM2A = vgui.Create( "DButton" )
			CAM2A:SetParent(map)
			CAM2A:SetSize( 76, 50 )
			CAM2A:SetPos( 161, 357 )
			CAM2A:SetText("")
			CAM2A.DoClick = function( button )
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
				fnafgmSetView(2)
				lastcam = 2
				CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
				KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
			end
			CAM2A.Paint = function( self, w, h )
				if lastcam==2 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM3 = vgui.Create( "DButton" )
			CAM3:SetParent(map)
			CAM3:SetSize( 75, 49 )
			CAM3:SetPos( 54, 334 )
			CAM3:SetText("")
			CAM3.DoClick = function( button )
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
				fnafgmSetView(3)
				lastcam = 3
				CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
				KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
			end
			CAM3.Paint = function( self, w, h )
				if lastcam==3 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM4A = vgui.Create( "DButton" )
			CAM4A:SetParent(map)
			CAM4A:SetSize( 75, 49 )
			CAM4A:SetPos( 297, 358 )
			CAM4A:SetText("")
			CAM4A.DoClick = function( button )
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
				fnafgmSetView(4)
				lastcam = 4
				CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
				KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
			end
			CAM4A.Paint = function( self, w, h )
				if lastcam==4 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM4B = vgui.Create( "DButton" )
			CAM4B:SetParent(map)
			CAM4B:SetSize( 75, 48 )
			CAM4B:SetPos( 297, 410 )
			CAM4B:SetText("")
			CAM4B.DoClick = function( button )
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
				fnafgmSetView(5)
				lastcam = 5
				CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
				KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
			end
			CAM4B.Paint = function( self, w, h )
				if lastcam==5 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM5 = vgui.Create( "DButton" )
			CAM5:SetParent(map)
			CAM5:SetSize( 76, 49 )
			CAM5:SetPos( 0, 143 )
			CAM5:SetText("")
			CAM5.DoClick = function( button )
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
				fnafgmSetView(6)
				lastcam = 6
				CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
				KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
			end
			CAM5.Paint = function( self, w, h )
				if lastcam==6 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM1A = vgui.Create( "DButton" )
			CAM1A:SetParent(map)
			CAM1A:SetSize( 76, 49 )
			CAM1A:SetPos( 161, 37 )
			CAM1A:SetText("")
			CAM1A.DoClick = function( button )
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
				fnafgmSetView(7)
				lastcam = 7
				CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
				KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
			end
			CAM1A.Paint = function( self, w, h )
				if lastcam==7 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM7 = vgui.Create( "DButton" )
			CAM7:SetParent(map)
			CAM7:SetSize( 76, 50 )
			CAM7:SetPos( 431, 143 )
			CAM7:SetText("")
			CAM7.DoClick = function( button )
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
				fnafgmSetView(8)
				lastcam = 8
				CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
				KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
			end
			CAM7.Paint = function( self, w, h )
				if lastcam==8 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM1C = vgui.Create( "DButton" )
			CAM1C:SetParent(map)
			CAM1C:SetSize( 75, 49 )
			CAM1C:SetPos( 95, 208 )
			CAM1C:SetText("")
			CAM1C.DoClick = function( button )
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
				fnafgmSetView(9)
				lastcam = 9
				CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
				KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
			end
			CAM1C.Paint = function( self, w, h )
				if lastcam==9 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM1B = vgui.Create( "DButton" )
			CAM1B:SetParent(map)
			CAM1B:SetSize( 75, 48 )
			CAM1B:SetPos( 136, 109 )
			CAM1B:SetText("")
			CAM1B.DoClick = function( button )
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
				fnafgmSetView(10)
				lastcam = 10
				CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
				KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
			end
			CAM1B.Paint = function( self, w, h )
				if lastcam==10 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
			local CAM6 = vgui.Create( "DButton" )
			CAM6:SetParent(map)
			CAM6:SetSize( 76, 49 )
			CAM6:SetPos( 421, 312 )
			CAM6:SetText("")
			CAM6.DoClick = function( button )
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
				fnafgmSetView(11)
				lastcam = 11
				CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				KitchenText:SetTextColor( Color( 255, 255, 255, 255 ) )
				KitchenText2:SetTextColor( Color( 255, 255, 255, 255 ) )
			end
			CAM6.Paint = function( self, w, h )
				if lastcam==11 then
					draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
				end
			end
			
		end
		
	end
	
	
end

net.Receive( "fnafgmAnimatronicsController", function( len )
	fnafgmAnimatronicsController() 
end)