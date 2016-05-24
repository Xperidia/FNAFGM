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
			if game.GetMap()=="freddysnoevent" then
				if !GAMEMODE.Vars.lastcam then
					GAMEMODE.Vars.lastcam = 7
				end
				LocalPlayer():EmitSound("fnafgm_campop")
			elseif game.GetMap()=="fnaf2noevents" then
				if !GAMEMODE.Vars.lastcam then
					GAMEMODE.Vars.lastcam = 12
				end
				LocalPlayer():EmitSound("fnafgm_campop2")
			elseif game.GetMap()=="fnaf3" then
				if !GAMEMODE.Vars.lastcam then
					GAMEMODE.Vars.lastcam = 2
				end
				LocalPlayer():EmitSound("fnafgm_campop3")
			else
				if !GAMEMODE.Vars.lastcam then
					GAMEMODE.Vars.lastcam = 1
				end
				LocalPlayer():EmitSound("fnafgm_campop")
			end
		end
		
		fnafgmSetView(GAMEMODE.Vars.lastcam)
		
		local lastlstate = {false,GAMEMODE.Vars.lastcam}
		
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
			if GAMEMODE.FT==1 and math.fmod( math.Round( CurTime() ), 2 ) == 0 then
				draw.Circle( 160, 160, 45, 64 )
			end
		end
		Monitor.OnClose = function()
			fnafgmSetView(0)
			if lastlstate[1]==true then fnafgmCamLight( GAMEMODE.Vars.lastcam, false ) end
			LocalPlayer():ConCommand( "pp_mat_overlay ''" )
			LocalPlayer():StopSound( "fnafgm_campop" )
			LocalPlayer():StopSound( "fnafgm_campop2" )
			LocalPlayer():StopSound( "fnafgm_campop3" )
			net.Start( "fnafgmTabUsed" )
				net.WriteBit( false )
			net.SendToServer()
		end
		Monitor.Think = function()
			
			if (!LocalPlayer():Alive() or GAMEMODE.Vars.tempostart or (GAMEMODE.Vars.poweroff and GAMEMODE.FT!=2)) then
				Monitor:Close()
			end
			
			if input.IsKeyDown(KEY_LCONTROL) and lastlstate[1]!=true then 
				
				fnafgmCamLight( GAMEMODE.Vars.lastcam, true )
				lastlstate = { true, GAMEMODE.Vars.lastcam }
				
			elseif !input.IsKeyDown(KEY_LCONTROL) and lastlstate[1]!=false then 
				
				fnafgmCamLight( GAMEMODE.Vars.lastcam, false )
				lastlstate = { false, GAMEMODE.Vars.lastcam }
				
			elseif lastlstate[1]==true and GAMEMODE.Vars.lastcam!=lastlstate[2] then
				
				fnafgmCamLight( lastlstate[2], false )
				lastlstate[1] = false
				
			end
			
		end
		
		
		local nope = hook.Call("fnafgmSecurityTabletCustom") or false
		
		if !nope then
			
			if game.GetMap()=="freddysnoevent" then
				
				local CamsNames = vgui.Create( "DLabel" )
				CamsNames:SetParent(Monitor)
				CamsNames:SetText( GAMEMODE.CamsNames["freddysnoevent_"..GAMEMODE.Vars.lastcam] or "" )
				CamsNames:SetTextColor( Color( 255, 255, 255, 255 ) )
				CamsNames:SetFont("FNAFGMTIME")
				CamsNames:SetPos( ScrW()-64-512, ScrH()-64-512-64 )
				CamsNames:SetSize( 512, 64 )
				
				if !GAMEMODE.Vars.mute then
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
				
				if GAMEMODE.Vars.lastcam==11 then
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
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView(1)
					GAMEMODE.Vars.lastcam = 1
					CamsNames:SetText( GAMEMODE.CamsNames["freddysnoevent_"..GAMEMODE.Vars.lastcam] or "" )
					KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
					KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
				end
				CAM2B.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==1 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
				local CAM2A = vgui.Create( "DButton" )
				CAM2A:SetParent(map)
				CAM2A:SetSize( 76, 50 )
				CAM2A:SetPos( 161, 357 )
				CAM2A:SetText("")
				CAM2A.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView(2)
					GAMEMODE.Vars.lastcam = 2
					CamsNames:SetText( GAMEMODE.CamsNames["freddysnoevent_"..GAMEMODE.Vars.lastcam] or "" )
					KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
					KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
				end
				CAM2A.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==2 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
				local CAM3 = vgui.Create( "DButton" )
				CAM3:SetParent(map)
				CAM3:SetSize( 75, 49 )
				CAM3:SetPos( 54, 334 )
				CAM3:SetText("")
				CAM3.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView(3)
					GAMEMODE.Vars.lastcam = 3
					CamsNames:SetText( GAMEMODE.CamsNames["freddysnoevent_"..GAMEMODE.Vars.lastcam] or "" )
					KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
					KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
				end
				CAM3.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==3 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
				local CAM4A = vgui.Create( "DButton" )
				CAM4A:SetParent(map)
				CAM4A:SetSize( 75, 49 )
				CAM4A:SetPos( 297, 358 )
				CAM4A:SetText("")
				CAM4A.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView(4)
					GAMEMODE.Vars.lastcam = 4
					CamsNames:SetText( GAMEMODE.CamsNames["freddysnoevent_"..GAMEMODE.Vars.lastcam] or "" )
					KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
					KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
				end
				CAM4A.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==4 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
				local CAM4B = vgui.Create( "DButton" )
				CAM4B:SetParent(map)
				CAM4B:SetSize( 75, 48 )
				CAM4B:SetPos( 297, 410 )
				CAM4B:SetText("")
				CAM4B.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView(5)
					GAMEMODE.Vars.lastcam = 5
					CamsNames:SetText( GAMEMODE.CamsNames["freddysnoevent_"..GAMEMODE.Vars.lastcam] or "" )
					KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
					KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
				end
				CAM4B.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==5 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
				local CAM5 = vgui.Create( "DButton" )
				CAM5:SetParent(map)
				CAM5:SetSize( 76, 49 )
				CAM5:SetPos( 0, 143 )
				CAM5:SetText("")
				CAM5.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView(6)
					GAMEMODE.Vars.lastcam = 6
					CamsNames:SetText( GAMEMODE.CamsNames["freddysnoevent_"..GAMEMODE.Vars.lastcam] or "" )
					KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
					KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
				end
				CAM5.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==6 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
				local CAM1A = vgui.Create( "DButton" )
				CAM1A:SetParent(map)
				CAM1A:SetSize( 76, 49 )
				CAM1A:SetPos( 161, 37 )
				CAM1A:SetText("")
				CAM1A.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView(7)
					GAMEMODE.Vars.lastcam = 7
					CamsNames:SetText( GAMEMODE.CamsNames["freddysnoevent_"..GAMEMODE.Vars.lastcam] or "" )
					KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
					KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
				end
				CAM1A.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==7 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
				local CAM7 = vgui.Create( "DButton" )
				CAM7:SetParent(map)
				CAM7:SetSize( 76, 50 )
				CAM7:SetPos( 431, 143 )
				CAM7:SetText("")
				CAM7.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView(8)
					GAMEMODE.Vars.lastcam = 8
					CamsNames:SetText( GAMEMODE.CamsNames["freddysnoevent_"..GAMEMODE.Vars.lastcam] or "" )
					KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
					KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
				end
				CAM7.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==8 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
				local CAM1C = vgui.Create( "DButton" )
				CAM1C:SetParent(map)
				CAM1C:SetSize( 75, 49 )
				CAM1C:SetPos( 95, 208 )
				CAM1C:SetText("")
				CAM1C.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView(9)
					GAMEMODE.Vars.lastcam = 9
					CamsNames:SetText( GAMEMODE.CamsNames["freddysnoevent_"..GAMEMODE.Vars.lastcam] or "" )
					KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
					KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
				end
				CAM1C.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==9 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
				local CAM1B = vgui.Create( "DButton" )
				CAM1B:SetParent(map)
				CAM1B:SetSize( 75, 48 )
				CAM1B:SetPos( 136, 109 )
				CAM1B:SetText("")
				CAM1B.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView(10)
					GAMEMODE.Vars.lastcam = 10
					CamsNames:SetText( GAMEMODE.CamsNames["freddysnoevent_"..GAMEMODE.Vars.lastcam] or "" )
					KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
					KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
				end
				CAM1B.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==10 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
				local CAM6 = vgui.Create( "DButton" )
				CAM6:SetParent(map)
				CAM6:SetSize( 76, 49 )
				CAM6:SetPos( 421, 312 )
				CAM6:SetText("")
				CAM6.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView(11)
					GAMEMODE.Vars.lastcam = 11
					CamsNames:SetText( GAMEMODE.CamsNames["freddysnoevent_"..GAMEMODE.Vars.lastcam] or "" )
					KitchenText:SetTextColor( Color( 255, 255, 255, 255 ) )
					KitchenText2:SetTextColor( Color( 255, 255, 255, 255 ) )
				end
				CAM6.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==11 then
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
					LocalPlayer():EmitSound("fnafgm_camdown")
					if IsValid(OpenT) then OpenT:Show() end
				end
				CloseT.OnCursorEntered = function()
					if IsValid(FNaFView) then
						if !waitt then waitt=0 end
						if waitt<CurTime() then
							waitt = CurTime()+0.5
							Monitor:Close()
							LocalPlayer():EmitSound("fnafgm_camdown")
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
		
		
			elseif game.GetMap()=="fnaf2noevents" then
		
		
				local CamsNames = vgui.Create( "DLabel" )
				CamsNames:SetParent(Monitor)
				CamsNames:SetText( GAMEMODE.CamsNames["fnaf2noevents_"..GAMEMODE.Vars.lastcam] or "" )
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
				lightbtn.OnMousePressed = function( button, key )
					if key==MOUSE_LEFT then
						if GAMEMODE.Vars.lastcam==6 then
							fnafgmUseLight(1)
						elseif GAMEMODE.Vars.lastcam==5 then
							fnafgmUseLight(3)
						end
					end
				end
				lightbtn.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==6 or GAMEMODE.Vars.lastcam==5 then
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
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( 9 )
					GAMEMODE.Vars.lastcam = 9
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2noevents_"..GAMEMODE.Vars.lastcam] or "" )
				end
				CAM12.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==9 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
				
				local CAM10 = vgui.Create( "DButton" )
				CAM10:SetParent(map)
				CAM10:SetSize( 70, 45 )
				CAM10:SetPos( 321, 234 )
				CAM10:SetText( "" )
				CAM10.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( 11 )
					GAMEMODE.Vars.lastcam = 11
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2noevents_"..GAMEMODE.Vars.lastcam] or "" )
				end
				CAM10.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==11 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM7 = vgui.Create( "DButton" )
				CAM7:SetParent(map)
				CAM7:SetSize( 70, 46 )
				CAM7:SetPos( 216, 142 )
				CAM7:SetText( "" )
				CAM7.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( 7 )
					GAMEMODE.Vars.lastcam = 7
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2noevents_"..GAMEMODE.Vars.lastcam] or "" )
				end
				CAM7.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==7 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM4 = vgui.Create( "DButton" )
				CAM4:SetParent(map)
				CAM4:SetSize( 71, 45 )
				CAM4:SetPos( 191, 213 )
				CAM4:SetText( "" )
				CAM4.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( 4 )
					GAMEMODE.Vars.lastcam = 4
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2noevents_"..GAMEMODE.Vars.lastcam] or "" )
				end
				CAM4.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==4 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM2 = vgui.Create( "DButton" )
				CAM2:SetParent(map)
				CAM2:SetSize( 70, 46 )
				CAM2:SetPos( 188, 291 )
				CAM2:SetText( "" )
				CAM2.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( 2 )
					GAMEMODE.Vars.lastcam = 2
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2noevents_"..GAMEMODE.Vars.lastcam] or "" )
				end
				CAM2.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==2 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM6 = vgui.Create( "DButton" )
				CAM6:SetParent(map)
				CAM6:SetSize( 70, 46 )
				CAM6:SetPos( 175, 401 )
				CAM6:SetText( "" )
				CAM6.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( 5 )
					GAMEMODE.Vars.lastcam = 5
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2noevents_"..GAMEMODE.Vars.lastcam] or "" )
				end
				CAM6.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==5 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
				
				local CAM11 = vgui.Create( "DButton" )
				CAM11:SetParent(map)
				CAM11:SetSize( 70, 46 )
				CAM11:SetPos( 442, 182 )
				CAM11:SetText( "" )
				CAM11.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( 10 )
					GAMEMODE.Vars.lastcam = 10
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2noevents_"..GAMEMODE.Vars.lastcam] or "" )
				end
				CAM11.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==10 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
				
		
				local CAM9 = vgui.Create( "DButton" )
				CAM9:SetParent(map)
				CAM9:SetSize( 70, 45 )
				CAM9:SetPos( 401, 94 )
				CAM9:SetText( "" )
				CAM9.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( 12 )
					GAMEMODE.Vars.lastcam = 12
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2noevents_"..GAMEMODE.Vars.lastcam] or "" )
				end
				CAM9.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==12 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM8 = vgui.Create( "DButton" )
				CAM8:SetParent(map)
				CAM8:SetSize( 70, 46 )
				CAM8:SetPos( 34, 129 )
				CAM8:SetText( "" )
				CAM8.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( 8 )
					GAMEMODE.Vars.lastcam = 8
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2noevents_"..GAMEMODE.Vars.lastcam] or "" )
				end
				CAM8.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==8 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM3 = vgui.Create( "DButton" )
				CAM3:SetParent(map)
				CAM3:SetSize( 71, 45 )
				CAM3:SetPos( 32, 213 )
				CAM3:SetText( "" )
				CAM3.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( 3 )
					GAMEMODE.Vars.lastcam = 3
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2noevents_"..GAMEMODE.Vars.lastcam] or "" )
				end
				CAM3.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==3 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM1 = vgui.Create( "DButton" )
				CAM1:SetParent(map)
				CAM1:SetSize( 71, 46 )
				CAM1:SetPos( 32, 290 )
				CAM1:SetText( "" )
				CAM1.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( 1 )
					GAMEMODE.Vars.lastcam = 1
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2noevents_"..GAMEMODE.Vars.lastcam] or "" )
				end
				CAM1.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==1 then
						draw.RoundedBox( 0, 4, 4, w-8, h-8, Color( 136, 168, 0, 128 ) )
					end
				end
		
				local CAM5 = vgui.Create( "DButton" )
				CAM5:SetParent(map)
				CAM5:SetSize( 70, 46 )
				CAM5:SetPos( 40, 401 )
				CAM5:SetText( "" )
				CAM5.DoClick = function( button )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( 6 )
					GAMEMODE.Vars.lastcam = 6
					CamsNames:SetText( GAMEMODE.CamsNames["fnaf2noevents_"..GAMEMODE.Vars.lastcam] or "" )
				end
				CAM5.Paint = function( self, w, h )
					if GAMEMODE.Vars.lastcam==6 then
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
					LocalPlayer():EmitSound("fnafgm_camdown2")
					if IsValid(OpenT) then OpenT:Show() end
					if IsValid(SafeE) then SafeE:Show() end
				end
				CloseT.OnCursorEntered = function()
					if IsValid(FNaFView) then
						if !waitt then waitt=0 end
						if waitt<CurTime() then
							waitt = CurTime()+0.5
							Monitor:Close()
							LocalPlayer():EmitSound("fnafgm_camdown2")
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
				CamsNames:SetText( "CAM"..GAMEMODE.Vars.lastcam )
				CamsNames:SetTextColor( Color( 255, 255, 255, 255 ) )
				CamsNames:SetFont("FNAFGMTIME")
				CamsNames:SetPos( 70, 60 )
				CamsNames:SetSize( 200, 64 )
				
				local CAM = vgui.Create( "DNumberWang" )
				CAM:SetParent(Monitor)
				CAM:SetPos( ScrW()/2-16, ScrH()-80-50-80 )
				CAM:SetMinMax(1,15)
				CAM:SetSize( 34, 28 )
				CAM:SetValue(GAMEMODE.Vars.lastcam)
				CAM.OnValueChanged = function( val )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( math.Round( val:GetValue() ) )
					GAMEMODE.Vars.lastcam = val:GetValue()
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
					LocalPlayer():EmitSound("fnafgm_camdown3")
					if IsValid(OpenT) then OpenT:Show() end
				end
				CloseT.OnCursorEntered = function()
					if IsValid(FNaFView) then
						if !waitt then waitt=0 end
						if waitt<CurTime() then
							waitt = CurTime()+0.5
							Monitor:Close()
							LocalPlayer():EmitSound("fnafgm_camdown3")
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
				CamsNames:SetText( "CAM"..GAMEMODE.Vars.lastcam )
				CamsNames:SetTextColor( Color( 255, 255, 255, 255 ) )
				CamsNames:SetFont("FNAFGMTIME")
				CamsNames:SetPos( 70, 60 )
				CamsNames:SetSize( 200, 64 )
				
				local CAM = vgui.Create( "DNumberWang" )
				CAM:SetParent(Monitor)
				CAM:SetPos( ScrW()/2-16, ScrH()-80-50-80 )
				CAM:SetMinMax(1,table.Count(ents.FindByClass( "fnafgm_camera" )))
				CAM:SetSize( 34, 28 )
				CAM:SetValue(GAMEMODE.Vars.lastcam)
				CAM.OnValueChanged = function( val )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( math.Round( val:GetValue() ) )
					GAMEMODE.Vars.lastcam = val:GetValue()
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
					LocalPlayer():EmitSound("fnafgm_camdown")
					if IsValid(OpenT) then OpenT:Show() end
				end
				CloseT.OnCursorEntered = function()
					if IsValid(FNaFView) then
						if !waitt then waitt=0 end
						if waitt<CurTime() then
							waitt = CurTime()+0.5
							Monitor:Close()
							LocalPlayer():EmitSound("fnafgm_camdown")
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