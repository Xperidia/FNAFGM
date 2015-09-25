include( 'shared.lua' )

SWEP.BounceWeaponIcon = false
SWEP.WepSelectIcon = surface.GetTextureID( "fnafgm/securitytablet" )

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

if !opened then
	
	opened = true
	
	net.Start( "fnafgmTabUsed" )
		net.WriteBit( true )
	net.SendToServer()

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
	elseif game.GetMap()=="fnap_scc" then
		if !lastcam then
			lastcam = 2
		end
		LocalPlayer():ConCommand("play "..GAMEMODE.Sound_securitycampop)
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
	
	fnafgmSetView( lastcam )
	
	LocalPlayer():ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_camstatic )

	Monitor = vgui.Create( "DFrame" )
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
		if (game.GetMap()=="freddys" or game.GetMap()=="freddysnoevent" or game.GetMap()=="fnap_scc") and math.fmod( math.Round( CurTime() ), 2 ) == 0 then
			draw.Circle( 160, 160, 45, 64 )
		end
	end
	Monitor.OnClose = function()
		fnafgmSetView( 0 )
		opened = false
		LocalPlayer():ConCommand( "pp_mat_overlay ''" )
		net.Start( "fnafgmTabUsed" )
			net.WriteBit( false )
		net.SendToServer()
	end
	
	
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
		
		local CAM6 = vgui.Create( "DButton" )
		CAM6:SetParent(map)
		CAM6:SetSize( 76, 49 )
		CAM6:SetPos( 0, 143 )
		CAM6:SetText( "" )
		CAM6:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM6:SetFont("FNAFGMTXT")
		CAM6.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 6 )
			lastcam = 6
			CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
			KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
			KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
		end
		CAM6.Paint = function( self, w, h )
			if lastcam==6 then
				draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
			end
		end

		local CAM8 = vgui.Create( "DButton" )
		CAM8:SetParent(map)
		CAM8:SetSize( 76, 50 )
		CAM8:SetPos( 431, 143 )
		CAM8:SetText( "" )
		CAM8:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM8:SetFont("FNAFGMTXT")
		CAM8.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 8 )
			lastcam = 8
			CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
			KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
			KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
		end
		CAM8.Paint = function( self, w, h )
			if lastcam==8 then
				draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
			end
		end

		local CAM9 = vgui.Create( "DButton" )
		CAM9:SetParent(map)
		CAM9:SetSize( 75, 49 )
		CAM9:SetPos( 95, 208 )
		CAM9:SetText( "" )
		CAM9:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM9:SetFont("FNAFGMTXT")
		CAM9.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 9 )
			lastcam = 9
			CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
			KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
			KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
		end
		CAM9.Paint = function( self, w, h )
			if lastcam==9 then
				draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
			end
		end
		
		local CAM11 = vgui.Create( "DButton" )
		CAM11:SetParent(map)
		CAM11:SetSize( 76, 49 )
		CAM11:SetPos( 421, 312 )
		CAM11:SetText( "" )
		CAM11:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM11:SetFont("FNAFGMTXT")
		CAM11.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 11 )
			lastcam = 11
			CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
			KitchenText:SetTextColor( Color( 255, 255, 255, 255 ) )
			KitchenText2:SetTextColor( Color( 255, 255, 255, 255 ) )
		end
		CAM11.Paint = function( self, w, h )
			if lastcam==11 then
				draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
			end
		end

		local CAM4 = vgui.Create( "DButton" )
		CAM4:SetParent(map)
		CAM4:SetSize( 75, 49 )
		CAM4:SetPos( 297, 358 )
		CAM4:SetText( "" )
		CAM4:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM4:SetFont("FNAFGMTXT")
		CAM4.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 4 )
			lastcam = 4
			CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
			KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
			KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
		end
		CAM4.Paint = function( self, w, h )
			if lastcam==4 then
				draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
			end
		end

		local CAM5 = vgui.Create( "DButton" )
		CAM5:SetParent(map)
		CAM5:SetSize( 75, 48 )
		CAM5:SetPos( 297, 410 )
		CAM5:SetText( "" )
		CAM5:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM5:SetFont("FNAFGMTXT")
		CAM5.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 5 )
			lastcam = 5
			CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
			KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
			KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
		end
		CAM5.Paint = function( self, w, h )
			if lastcam==5 then
				draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
			end
		end

		local CAM7 = vgui.Create( "DButton" )
		CAM7:SetParent(map)
		CAM7:SetSize( 76, 49 )
		CAM7:SetPos( 161, 37 )
		CAM7:SetText( "" )
		CAM7:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM7:SetFont("FNAFGMTXT")
		CAM7.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 7 )
			lastcam = 7
			CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
			KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
			KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
		end
		CAM7.Paint = function( self, w, h )
			if lastcam==7 then
				draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
			end
		end

		local CAM10 = vgui.Create( "DButton" )
		CAM10:SetParent(map)
		CAM10:SetSize( 75, 48 )
		CAM10:SetPos( 136, 109 )
		CAM10:SetText( "" )
		CAM10:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM10:SetFont("FNAFGMTXT")
		CAM10.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 10 )
			lastcam = 10
			CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
			KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
			KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
		end
		CAM10.Paint = function( self, w, h )
			if lastcam==10 then
				draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
			end
		end

		local CAM3 = vgui.Create( "DButton" )
		CAM3:SetParent(map)
		CAM3:SetSize( 75, 49 )
		CAM3:SetPos( 54, 334 )
		CAM3:SetText( "" )
		CAM3:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM3:SetFont("FNAFGMTXT")
		CAM3.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 3 )
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

		local CAM2 = vgui.Create( "DButton" )
		CAM2:SetParent(map)
		CAM2:SetSize( 76, 50 )
		CAM2:SetPos( 161, 357 )
		CAM2:SetText( "" )
		CAM2:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM2:SetFont("FNAFGMTXT")
		CAM2.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 2 )
			lastcam = 2
			CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
			KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
			KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
		end
		CAM2.Paint = function( self, w, h )
			if lastcam==2 then
				draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
			end
		end

		local CAM1 = vgui.Create( "DButton" )
		CAM1:SetParent(map)
		CAM1:SetSize( 76, 50 )
		CAM1:SetPos( 161, 408 )
		CAM1:SetText( "" )
		CAM1:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM1:SetFont("FNAFGMTXT")
		CAM1.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 1 )
			lastcam = 1
			CamsNames:SetText( GAMEMODE.CamsNames["freddys_"..lastcam] or "" )
			KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
			KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
		end
		CAM1.Paint = function( self, w, h )
			if lastcam==1 then
				draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
			end
		end
		
		
		CloseT = vgui.Create( "DButton" )
		CloseT:SetParent(Monitor)
		CloseT:SetSize( ScrW()/2-128, 80 )
		CloseT:SetPos( 512-128, ScrH()-80-50 )
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
		CAM12:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM12:SetFont("FNAFGMTXT")
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
		CAM10:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM10:SetFont("FNAFGMTXT")
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
		CAM7:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM7:SetFont("FNAFGMTXT")
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
		CAM4:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM4:SetFont("FNAFGMTXT")
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
		CAM2:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM2:SetFont("FNAFGMTXT")
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
		CAM6:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM6:SetFont("FNAFGMTXT")
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
		CAM11:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM11:SetFont("FNAFGMTXT")
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
		CAM9:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM9:SetFont("FNAFGMTXT")
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
		CAM8:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM8:SetFont("FNAFGMTXT")
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
		CAM3:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM3:SetFont("FNAFGMTXT")
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
		CAM1:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM1:SetFont("FNAFGMTXT")
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
		CAM5:SetTextColor( Color( 255, 255, 255, 255 ) )
		CAM5:SetFont("FNAFGMTXT")
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
		CloseT:SetTextColor( Color( 255, 255, 255, 255 ) )
		CloseT:SetFont("FNAFGMID")
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
		
		
	elseif game.GetMap()=="fnap_scc" then
		
		local CamsNames = vgui.Create( "DLabel" )
		CamsNames:SetParent(Monitor)
		CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		CamsNames:SetTextColor( Color( 255, 255, 255, 255 ) )
		CamsNames:SetFont("FNAFGMTIME")
		CamsNames:SetPos( ScrW()-64-512, ScrH()-64-512 )
		CamsNames:SetSize( 512, 64 )
		
		local map = vgui.Create( "DImage" )
		map:SetParent(Monitor)
		map:SetImage( "fnapgm/map_fnap_scc_1" )
		map:SetPos( ScrW()-64-512, ScrH()-64-512 )
		map:SetSize( 512, 512 )
		
		local map2 = vgui.Create( "DImage" )
		map2:SetParent(Monitor)
		map2:SetImage( "fnapgm/map_fnap_scc_2" )
		map2:SetPos( 64, ScrH()-64-512 )
		map2:SetSize( 512, 512 )
		
		local Kitchen = vgui.Create( "DButton" )
		Kitchen:SetParent(map)
		Kitchen:SetSize( 78.5, 48.5 )
		Kitchen:SetPos( 91, 224 )
		Kitchen:SetText( "" )
		Kitchen:SetTextColor( Color( 255, 255, 255, 255 ) )
		Kitchen:SetFont("FNAFGMTXT")
		Kitchen.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 1 )
			lastcam = 1
			CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		end
		Kitchen.Paint = function( self, w, h )
			if lastcam==1 then
				draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 136, 168, 0, 128 ) )
			end
		end
		
		local Stage = vgui.Create( "DButton" )
		Stage:SetParent(map)
		Stage:SetSize( 78.5, 48.5 )
		Stage:SetPos( 206, 229.5 )
		Stage:SetText( "" )
		Stage:SetTextColor( Color( 255, 255, 255, 255 ) )
		Stage:SetFont("FNAFGMTXT")
		Stage.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 2 )
			lastcam = 2
			CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		end
		Stage.Paint = function( self, w, h )
			if lastcam==2 then
				draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 136, 168, 0, 128 ) )
			end
		end

		local Dining_Area = vgui.Create( "DButton" )
		Dining_Area:SetParent(map)
		Dining_Area:SetSize( 78.5, 48.5 )
		Dining_Area:SetPos( 206, 334 )
		Dining_Area:SetText( "" )
		Dining_Area:SetTextColor( Color( 255, 255, 255, 255 ) )
		Dining_Area:SetFont("FNAFGMTXT")
		Dining_Area.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 3 )
			lastcam = 3
			CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		end
		Dining_Area.Paint = function( self, w, h )
			if lastcam==3 then
				draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 136, 168, 0, 128 ) )
			end
		end
		
		local Entrance = vgui.Create( "DButton" )
		Entrance:SetParent(map)
		Entrance:SetSize( 78.5, 48.5 )
		Entrance:SetPos( 312, 387 )
		Entrance:SetText( "" )
		Entrance:SetTextColor( Color( 255, 255, 255, 255 ) )
		Entrance:SetFont("FNAFGMTXT")
		Entrance.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 4 )
			lastcam = 4
			CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		end
		Entrance.Paint = function( self, w, h )
			if lastcam==4 then
				draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 136, 168, 0, 128 ) )
			end
		end

		local North_Hall_B = vgui.Create( "DButton" )
		North_Hall_B:SetParent(map)
		North_Hall_B:SetSize( 78.5, 48.5 )
		North_Hall_B:SetPos( 354, 281.5 )
		North_Hall_B:SetText( "" )
		North_Hall_B:SetTextColor( Color( 255, 255, 255, 255 ) )
		North_Hall_B:SetFont("FNAFGMTXT")
		North_Hall_B.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 5 )
			lastcam = 5
			CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		end
		North_Hall_B.Paint = function( self, w, h )
			if lastcam==5 then
				draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 136, 168, 0, 128 ) )
			end
		end
		
		local Bathroom = vgui.Create( "DButton" )
		Bathroom:SetParent(map)
		Bathroom:SetSize( 78.5, 48.5 )
		Bathroom:SetPos( 354, 151 )
		Bathroom:SetText( "" )
		Bathroom:SetTextColor( Color( 255, 255, 255, 255 ) )
		Bathroom:SetFont("FNAFGMTXT")
		Bathroom.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 6 )
			lastcam = 6
			CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		end
		Bathroom.Paint = function( self, w, h )
			if lastcam==6 then
				draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 136, 168, 0, 128 ) )
			end
		end
		
		local North_Hall_A = vgui.Create( "DButton" )
		North_Hall_A:SetParent(map)
		North_Hall_A:SetSize( 78.5, 48.5 )
		North_Hall_A:SetPos( 20.5, 162.5 )
		North_Hall_A:SetText( "" )
		North_Hall_A:SetTextColor( Color( 255, 255, 255, 255 ) )
		North_Hall_A:SetFont("FNAFGMTXT")
		North_Hall_A.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 7 )
			lastcam = 7
			CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		end
		North_Hall_A.Paint = function( self, w, h )
			if lastcam==7 then
				draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 136, 168, 0, 128 ) )
			end
		end
		
		local Pinkie_Bedroom = vgui.Create( "DButton" )
		Pinkie_Bedroom:SetParent(map)
		Pinkie_Bedroom:SetSize( 78.5, 48.5 )
		Pinkie_Bedroom:SetPos( 91, 92.5 )
		Pinkie_Bedroom:SetText( "" )
		Pinkie_Bedroom:SetTextColor( Color( 255, 255, 255, 255 ) )
		Pinkie_Bedroom:SetFont("FNAFGMTXT")
		Pinkie_Bedroom.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 8 )
			lastcam = 8
			CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		end
		Pinkie_Bedroom.Paint = function( self, w, h )
			if lastcam==8 then
				draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 136, 168, 0, 128 ) )
			end
		end
		
		local Storage = vgui.Create( "DButton" )
		Storage:SetParent(map)
		Storage:SetSize( 78.5, 48.5 )
		Storage:SetPos( 192.5, 92.5 )
		Storage:SetText( "" )
		Storage:SetTextColor( Color( 255, 255, 255, 255 ) )
		Storage:SetFont("FNAFGMTXT")
		Storage.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 9 )
			lastcam = 9
			CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		end
		Storage.Paint = function( self, w, h )
			if lastcam==9 then
				draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 136, 168, 0, 128 ) )
			end
		end
		
		local Supply_Room = vgui.Create( "DButton" )
		Supply_Room:SetParent(map)
		Supply_Room:SetSize( 78.5, 48.5 )
		Supply_Room:SetPos( 293, 92 )
		Supply_Room:SetText( "" )
		Supply_Room:SetTextColor( Color( 255, 255, 255, 255 ) )
		Supply_Room:SetFont("FNAFGMTXT")
		Supply_Room.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 10 )
			lastcam = 10
			CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		end
		Supply_Room.Paint = function( self, w, h )
			if lastcam==10 then
				draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 136, 168, 0, 128 ) )
			end
		end
		
		local Trash = vgui.Create( "DButton" )
		Trash:SetParent(map2)
		Trash:SetSize( 78.5, 48.5 )
		Trash:SetPos( 380, 325.5 )
		Trash:SetText( "" )
		Trash:SetTextColor( Color( 255, 255, 255, 255 ) )
		Trash:SetFont("FNAFGMTXT")
		Trash.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 11 )
			lastcam = 11
			CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		end
		Trash.Paint = function( self, w, h )
			if lastcam==11 then
				draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 136, 168, 0, 128 ) )
			end
		end
		
		local Cave = vgui.Create( "DButton" )
		Cave:SetParent(map2)
		Cave:SetSize( 78.5, 48.5 )
		Cave:SetPos( 315.5, 268.5 )
		Cave:SetText( "" )
		Cave:SetTextColor( Color( 255, 255, 255, 255 ) )
		Cave:SetFont("FNAFGMTXT")
		Cave.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 12 )
			lastcam = 12
			CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		end
		Cave.Paint = function( self, w, h )
			if lastcam==12 then
				draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 136, 168, 0, 128 ) )
			end
		end
		
		local Storage = vgui.Create( "DButton" )
		Storage:SetParent(map2)
		Storage:SetSize( 78.5, 48.5 )
		Storage:SetPos( 222, 140 )
		Storage:SetText( "" )
		Storage:SetTextColor( Color( 255, 255, 255, 255 ) )
		Storage:SetFont("FNAFGMTXT")
		Storage.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 13 )
			lastcam = 13
			CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		end
		Storage.Paint = function( self, w, h )
			if lastcam==13 then
				draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 136, 168, 0, 128 ) )
			end
		end
		
		local Generator = vgui.Create( "DButton" )
		Generator:SetParent(map2)
		Generator:SetSize( 78.5, 48.5 )
		Generator:SetPos( 57, 225.5 )
		Generator:SetText( "" )
		Generator:SetTextColor( Color( 255, 255, 255, 255 ) )
		Generator:SetFont("FNAFGMTXT")
		Generator.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 14 )
			lastcam = 14
			CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		end
		Generator.Paint = function( self, w, h )
			if lastcam==14 then
				draw.RoundedBox( 0, 2.5, 2.5, w-5, h-5, Color( 136, 168, 0, 128 ) )
			end
		end
		
		local Unknown = vgui.Create( "DButton" )
		Unknown:SetParent(map2)
		Unknown:SetSize( 4, 4 )
		Unknown:SetPos( 237, 298 )
		Unknown:SetText( "" )
		Unknown:SetTextColor( Color( 255, 255, 255, 255 ) )
		Unknown:SetFont("FNAFGMTXT")
		Unknown.DoClick = function( button )
			LocalPlayer():ConCommand("play "..GAMEMODE.Sound_camselect)
			fnafgmSetView( 15 )
			lastcam = 15
			CamsNames:SetText( GAMEMODE.CamsNames["fnap_scc_"..lastcam] or "" )
		end
		Unknown.Paint = function( self, w, h )
			
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

function fnafgmCloseTablet()
	
	if IsValid(Monitor) then
		Monitor:Close()
	end
	
end



function SWEP:Think()
	
	if IsValid(Monitor) and (!LocalPlayer():Alive() or tobool(tempostart) or (power==0 and game.GetMap()!="fnaf2")) then
		Monitor:Close()
	end
			
	if IsValid(Monitor) and input.IsKeyDown( KEY_ESCAPE ) then
		Monitor:Close()
	end
	
end

usermessage.Hook("fnafgmSecurityTablet", fnafgmSecurityTablet)
usermessage.Hook("fnafgmCloseTablet", fnafgmCloseTablet)

