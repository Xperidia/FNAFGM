include( 'shared.lua' )

SWEP.BounceWeaponIcon = false
SWEP.WepSelectIcon = surface.GetTextureID( "fnafgm/weapons/securitytablet" )

function draw.Circle( x, y, radius, seg )
	local cir = {}

	table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
	for i = 0, seg do
		local a = math.rad( ( i / seg ) * -360 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
	end

	local a = math.rad( 0 ) -- This is need for non absolute segment counts
	table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

	surface.DrawPoly( cir )
end


function fnafgmSecurityTablet() 
	
	if !IsValid(Monitor) then
		
		net.Start( "fnafgmTabUsed" )
			net.WriteBit( true )
		net.SendToServer()
		
		local nopeinit = hook.Call("fnafgmSecurityTabletCustomInit") or false
		
		if !nopeinit then
			if game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent" then
				if !lastcam then
					lastcam = 7
				end
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
			elseif game.GetMap()=="fnaf2" then
				if !lastcam then
					lastcam = 12
				end
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop2)
			elseif game.GetMap()=="fnaf3" then
				if !lastcam then
					lastcam = 2
				end
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop3)
			elseif game.GetMap()=="fnaf_freddypizzaevents" then
				if !lastcam then
					lastcam = 7
				end
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
			else
				if !lastcam then
					lastcam = 1
				end
				LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
			end
		end
		
		fnafgmSetView(lastcam)
		
		LocalPlayer():ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_camstatic )
		
		Monitor = vgui.Create( "DFrame" )
		Monitor:ParentToHUD()
		Monitor:SetPos( 0, 0 )
		Monitor:SetSize( ScrW(), ScrH() )
		Monitor:SetTitle( "" )
		Monitor:SetVisible( true )
		Monitor:SetDraggable( false )
		Monitor:ShowCloseButton( false )
		Monitor:SetScreenLock(false)
		Monitor:SetPaintShadow(true)
		Monitor:SetBackgroundBlur(true)
		Monitor:MakePopup()
		Monitor.Paint = function( self, w, h )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawOutlinedRect( 35, 30, w-70, h-60 )
			surface.SetDrawColor( 255, 0, 0, 255 )
			draw.NoTexture()
			if (game.GetMap()!="fnaf2" and game.GetMap()!="fnaf3") and math.fmod( math.Round( CurTime() ), 2 ) == 0 then
				draw.Circle( 160, 160, 45, 64 )
			end
		end
		Monitor.OnClose = function()
			fnafgmSetView(0)
			LocalPlayer():ConCommand( "pp_mat_overlay ''" )
			net.Start( "fnafgmTabUsed" )
				net.WriteBit( false )
			net.SendToServer()
		end
		Monitor.Think = function()
			if (!LocalPlayer():Alive() or tobool(tempostart) or (poweroff and game.GetMap()!="fnaf2")) then
				Monitor:Close()
			end
		end
		
		
		local nope = hook.Call("fnafgmSecurityTabletCustom") or false
		
		if !nope then
			
			if game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent" then
				
				local CamsNames = vgui.Create( "DLabel" )
				CamsNames:SetParent(Monitor)
				CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
				CamsNames:SetTextColor( Color( 255, 255, 255, 255 ) )
				CamsNames:SetFont("FNAFGMTIME")
				CamsNames:SetPos( ScrW()-64-512, ScrH()-64-512-64 )
				CamsNames:SetSize( 512, 64 )
				
				if !tobool(mute) then
					local MUTET = vgui.Create( "DImage" )
					MUTET:SetParent(Monitor)
					MUTET:SetImage( "fnafgm/mute" )
					MUTET:SetSize( 128, 32 )
					MUTET:SetPos( 64, 64 )
					
					local MUTEbT = vgui.Create( "DButton" )
					MUTEbT:SetParent(MUTET)
					MUTEbT:SetSize( 121, 31 )
					MUTEbT:SetPos( 0, 0 )
					MUTEbT:SetText( "" )
					MUTEbT.DoClick = function( button )
						fnafgmMuteCall()
						MUTET:Remove()
						MUTEbT:Remove()
					end
					MUTEbT.Paint = function( self, w, h )
						
					end
				end
				
				local KitchenText = vgui.Create( "DLabel" )
				KitchenText:SetParent(Monitor)
				KitchenText:SetText( "-CAMERA DISABLED-" )
				KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
				KitchenText:SetFont("FNAFGMTIME")
				KitchenText:SetPos( ScrW()/2-256, 80 )
				KitchenText:SetContentAlignment( 8 )
				KitchenText:SizeToContents()
				
				local KitchenText2 = vgui.Create( "DLabel" )
				KitchenText2:SetParent(Monitor)
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
				map:SetParent(Monitor)
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
				
				
				CloseT = vgui.Create( "DButton" )
				CloseT:SetParent(Monitor)
				CloseT:SetSize( ScrW()/2-128, 80 )
				CloseT:SetPos( 512-128, ScrH()-80-50 )
				CloseT:SetText("")
				CloseT.DoClick = function( button )
					if IsValid(FNaFView) then waitt = CurTime()+1 end
					Monitor:Close()
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
					if IsValid(OpenT) then OpenT:Show() end
				end
				CloseT.OnCursorEntered = function()
					if IsValid(FNaFView) then
						if !waitt then waitt=0 end
						if waitt<CurTime() then
							waitt = CurTime()+0.5
							Monitor:Close()
							LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
							if IsValid(OpenT) then OpenT:Show() end
						end
					end
				end
				CloseT.Paint = function( self, w, h )
					
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
		
		
				local CamsNames = vgui.Create( "DLabel" )
				CamsNames:SetParent(Monitor)
				CamsNames:SetText( GAMEMODE.CamsNames["fnaf2_"..lastcam] or "" )
				CamsNames:SetTextColor( Color( 255, 255, 255, 255 ) )
				CamsNames:SetFont("FNAFGMTIME")
				CamsNames:SetPos( ScrW()-64-512, ScrH()-64-512-64 )
				CamsNames:SetSize( 512, 64 )
				
				
				local map = vgui.Create( "DImage" )
				map:SetParent(Monitor)
				map:SetImage( GAMEMODE.Materials_mapfnaf2 )
				map:SetPos( ScrW()-64-512, ScrH()-128-512 )
				map:SetSize( 512, 512 )
				
				
				local lightbtn = vgui.Create( "DButton" )
				lightbtn:SetParent(Monitor)
				lightbtn:SetSize( ScrW()/2+64, ScrH()-400 )
				lightbtn:SetPos( 64, 256 )
				lightbtn:SetText( "" )
				lightbtn.DoClick = function( button )
					if lastcam==6 then
						fnafgmUseLight(1)
					elseif lastcam==5 then
						fnafgmUseLight(3)
					end
				end
				lightbtn.Paint = function( self, w, h )
					if lastcam==6 or lastcam==5 then
						surface.SetDrawColor( 255, 255, 255, 85 )
						surface.DrawOutlinedRect( 0, 0, w, h )
					end
				end
				
				
				local CAM12 = vgui.Create( "DButton" )
				CAM12:SetParent(map)
				CAM12:SetSize( 70, 46 )
				CAM12:SetPos( 422, 291 )
				CAM12:SetText( "" )
				CAM12.DoClick = function( button )
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView( 9 )
					lastcam = 9
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2_"..lastcam] or "" )
				end
				CAM12.Paint = function( self, w, h )
					if lastcam==9 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
				
				local CAM10 = vgui.Create( "DButton" )
				CAM10:SetParent(map)
				CAM10:SetSize( 70, 45 )
				CAM10:SetPos( 321, 234 )
				CAM10:SetText( "" )
				CAM10.DoClick = function( button )
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView( 11 )
					lastcam = 11
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2_"..lastcam] or "" )
				end
				CAM10.Paint = function( self, w, h )
					if lastcam==11 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM7 = vgui.Create( "DButton" )
				CAM7:SetParent(map)
				CAM7:SetSize( 70, 46 )
				CAM7:SetPos( 216, 142 )
				CAM7:SetText( "" )
				CAM7.DoClick = function( button )
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView( 7 )
					lastcam = 7
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2_"..lastcam] or "" )
				end
				CAM7.Paint = function( self, w, h )
					if lastcam==7 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM4 = vgui.Create( "DButton" )
				CAM4:SetParent(map)
				CAM4:SetSize( 71, 45 )
				CAM4:SetPos( 191, 213 )
				CAM4:SetText( "" )
				CAM4.DoClick = function( button )
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView( 4 )
					lastcam = 4
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2_"..lastcam] or "" )
				end
				CAM4.Paint = function( self, w, h )
					if lastcam==4 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM2 = vgui.Create( "DButton" )
				CAM2:SetParent(map)
				CAM2:SetSize( 70, 46 )
				CAM2:SetPos( 188, 291 )
				CAM2:SetText( "" )
				CAM2.DoClick = function( button )
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView( 2 )
					lastcam = 2
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2_"..lastcam] or "" )
				end
				CAM2.Paint = function( self, w, h )
					if lastcam==2 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM6 = vgui.Create( "DButton" )
				CAM6:SetParent(map)
				CAM6:SetSize( 70, 46 )
				CAM6:SetPos( 175, 401 )
				CAM6:SetText( "" )
				CAM6.DoClick = function( button )
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView( 5 )
					lastcam = 5
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2_"..lastcam] or "" )
				end
				CAM6.Paint = function( self, w, h )
					if lastcam==5 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
				
				local CAM11 = vgui.Create( "DButton" )
				CAM11:SetParent(map)
				CAM11:SetSize( 70, 46 )
				CAM11:SetPos( 442, 182 )
				CAM11:SetText( "" )
				CAM11.DoClick = function( button )
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView( 10 )
					lastcam = 10
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2_"..lastcam] or "" )
				end
				CAM11.Paint = function( self, w, h )
					if lastcam==10 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
		
				local CAM9 = vgui.Create( "DButton" )
				CAM9:SetParent(map)
				CAM9:SetSize( 70, 45 )
				CAM9:SetPos( 401, 94 )
				CAM9:SetText( "" )
				CAM9.DoClick = function( button )
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView( 12 )
					lastcam = 12
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2_"..lastcam] or "" )
				end
				CAM9.Paint = function( self, w, h )
					if lastcam==12 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM8 = vgui.Create( "DButton" )
				CAM8:SetParent(map)
				CAM8:SetSize( 70, 46 )
				CAM8:SetPos( 34, 129 )
				CAM8:SetText( "" )
				CAM8.DoClick = function( button )
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView( 8 )
					lastcam = 8
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2_"..lastcam] or "" )
				end
				CAM8.Paint = function( self, w, h )
					if lastcam==8 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM3 = vgui.Create( "DButton" )
				CAM3:SetParent(map)
				CAM3:SetSize( 71, 45 )
				CAM3:SetPos( 32, 213 )
				CAM3:SetText( "" )
				CAM3.DoClick = function( button )
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView( 3 )
					lastcam = 3
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2_"..lastcam] or "" )
				end
				CAM3.Paint = function( self, w, h )
					if lastcam==3 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM1 = vgui.Create( "DButton" )
				CAM1:SetParent(map)
				CAM1:SetSize( 71, 46 )
				CAM1:SetPos( 32, 290 )
				CAM1:SetText( "" )
				CAM1.DoClick = function( button )
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView( 1 )
					lastcam = 1
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2_"..lastcam] or "" )
				end
				CAM1.Paint = function( self, w, h )
					if lastcam==1 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM5 = vgui.Create( "DButton" )
				CAM5:SetParent(map)
				CAM5:SetSize( 70, 46 )
				CAM5:SetPos( 40, 401 )
				CAM5:SetText( "" )
				CAM5.DoClick = function( button )
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView( 6 )
					lastcam = 6
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2_"..lastcam] or "" )
				end
				CAM5.Paint = function( self, w, h )
					if lastcam==6 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
				
				CloseT = vgui.Create( "DButton" )
				CloseT:SetParent(Monitor)
				CloseT:SetSize( ScrW()/2 - 128, 64 )
				CloseT:SetPos( ScrW()/2 + 32, ScrH()-80-50 )
				CloseT:SetText( "" )
				CloseT.DoClick = function( button )
					if IsValid(FNaFView) then waitt = CurTime()+1 end
					Monitor:Close()
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycamdown2)
					if IsValid(OpenT) then OpenT:Show() end
					if IsValid(SafeE) then SafeE:Show() end
				end
				CloseT.OnCursorEntered = function()
					if IsValid(FNaFView) then
						if !waitt then waitt=0 end
						if waitt<CurTime() then
							waitt = CurTime()+0.5
							Monitor:Close()
							LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycamdown2)
							if IsValid(OpenT) then OpenT:Show() end
							if IsValid(SafeE) then SafeE:Show() end
						end
					end
				end
				CloseT.Paint = function( self, w, h )
					
					draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 255, 255, 255, 32 ) )
					
					surface.SetDrawColor( 255, 255, 255, 128 )
					
					draw.NoTexture()
					
					surface.DrawLine( w/2-64, h/2-16, w/2, h/2 )
					surface.DrawLine( w/2, h/2, w/2+64, h/2-16 )
					
					surface.DrawLine( w/2-64, h/2-16+16, w/2, h/2+16 )
					surface.DrawLine( w/2, h/2+16, w/2+64, h/2-16+16 )
					
					surface.DrawOutlinedRect( 0, 0, w, h )
					
				end
				
				
			elseif game.GetMap()=="fnaf3" then
				
				
				local CamsNames = vgui.Create( "DLabel" )
				CamsNames:SetParent(Monitor)
				CamsNames:SetText( "CAM"..lastcam )
				CamsNames:SetTextColor( Color( 255, 255, 255, 255 ) )
				CamsNames:SetFont("FNAFGMTIME")
				CamsNames:SetPos( 70, 60 )
				CamsNames:SetSize( 200, 64 )
				
				local CAM = vgui.Create( "DNumberWang" )
				CAM:SetParent(Monitor)
				CAM:SetPos( ScrW()/2-16, ScrH()-80-50-80 )
				CAM:SetMinMax(1,15)
				CAM:SetSize( 34, 28 )
				CAM:SetValue(lastcam)
				CAM.OnValueChanged = function( val )
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView( math.Round( val:GetValue() ) )
					lastcam = val:GetValue()
					CamsNames:SetText( "CAM"..val:GetValue() )
				end
				
				CloseT = vgui.Create( "DButton" )
				CloseT:SetParent(Monitor)
				CloseT:SetSize( 512, 80 )
				CloseT:SetPos( ScrW()/2-256, ScrH()-80-50 )
				CloseT:SetText( "" )
				CloseT:SetTextColor( Color( 255, 255, 255, 255 ) )
				CloseT:SetFont("FNAFGMID")
				CloseT.DoClick = function( button )
					if IsValid(FNaFView) then waitt = CurTime()+1 end
					Monitor:Close()
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycamdown3)
					if IsValid(OpenT) then OpenT:Show() end
				end
				CloseT.OnCursorEntered = function()
					if IsValid(FNaFView) then
						if !waitt then waitt=0 end
						if waitt<CurTime() then
							waitt = CurTime()+0.5
							Monitor:Close()
							LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycamdown3)
							if IsValid(OpenT) then OpenT:Show() end
						end
					end
				end
				CloseT.Paint = function( self, w, h )
					
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
				
				
				local CamsNames = vgui.Create( "DLabel" )
				CamsNames:SetParent(Monitor)
				CamsNames:SetText( "CAM"..lastcam )
				CamsNames:SetTextColor( Color( 255, 255, 255, 255 ) )
				CamsNames:SetFont("FNAFGMTIME")
				CamsNames:SetPos( 70, 60 )
				CamsNames:SetSize( 200, 64 )
				
				local CAM = vgui.Create( "DNumberWang" )
				CAM:SetParent(Monitor)
				CAM:SetPos( ScrW()/2-16, ScrH()-80-50-80 )
				CAM:SetMinMax(1,table.Count(ents.FindByClass( "fnafgm_camera" )))
				CAM:SetSize( 34, 28 )
				CAM:SetValue(lastcam)
				CAM.OnValueChanged = function( val )
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
					fnafgmSetView( math.Round( val:GetValue() ) )
					lastcam = val:GetValue()
					CamsNames:SetText( "CAM"..val:GetValue() )
				end
				
				CloseT = vgui.Create( "DButton" )
				CloseT:SetParent(Monitor)
				CloseT:SetSize( 512, 80 )
				CloseT:SetPos( ScrW()/2-256, ScrH()-80-50 )
				CloseT:SetText( "" )
				CloseT:SetTextColor( Color( 255, 255, 255, 255 ) )
				CloseT:SetFont("FNAFGMID")
				CloseT.DoClick = function( button )
					if IsValid(FNaFView) then waitt = CurTime()+1 end
					Monitor:Close()
					LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
					if IsValid(OpenT) then OpenT:Show() end
				end
				CloseT.OnCursorEntered = function()
					if IsValid(FNaFView) then
						if !waitt then waitt=0 end
						if waitt<CurTime() then
							waitt = CurTime()+0.5
							Monitor:Close()
							LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
							if IsValid(OpenT) then OpenT:Show() end
						end
					end
				end
				CloseT.Paint = function( self, w, h )
					
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
	
	
end

function fnafgmCloseTablet()
	if IsValid(Monitor) then
		Monitor:Close()
	end
end

net.Receive( "fnafgmCloseTablet", function( len )
	fnafgmCloseTablet()
end)

net.Receive( "fnafgmSecurityTablet", function( len )
	fnafgmSecurityTablet()
end)