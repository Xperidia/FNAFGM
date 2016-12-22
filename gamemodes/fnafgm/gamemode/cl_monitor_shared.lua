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

function GM:Monitor(control)
	
	if !IsValid(GAMEMODE.Vars.Monitor) then
		
		if !control then
			
			net.Start( "fnafgmTabUsed" )
				net.WriteBit( true )
			net.SendToServer()
			
		end
		
		local nopeinit = hook.Call("fnafgmSecurityTabletCustomInit",nil,control) or false
		
		if !nopeinit then
			if game.GetMap()=="freddysnoevent" then
				if !GAMEMODE.Vars.lastcam then
					GAMEMODE.Vars.lastcam = 7
				end
				if !control then LocalPlayer():EmitSound("fnafgm_campop") end
			elseif game.GetMap()=="fnaf2noevents" then
				if !GAMEMODE.Vars.lastcam then
					GAMEMODE.Vars.lastcam = 12
				end
				if !control then LocalPlayer():EmitSound("fnafgm_campop2") end
			elseif game.GetMap()=="fnaf3" then
				if !GAMEMODE.Vars.lastcam then
					GAMEMODE.Vars.lastcam = 2
				end
				if !control then LocalPlayer():EmitSound("fnafgm_campop3") end
			else
				if !GAMEMODE.Vars.lastcam then
					GAMEMODE.Vars.lastcam = 1
				end
				if !control then LocalPlayer():EmitSound("fnafgm_campop") end
			end
		end
		
		fnafgmSetView(GAMEMODE.Vars.lastcam)
		
		local lastlstate = {false,GAMEMODE.Vars.lastcam}
		
		GAMEMODE.Vars.Monitor = vgui.Create( "DFrame" )
		GAMEMODE.Vars.Monitor:ParentToHUD()
		GAMEMODE.Vars.Monitor:SetPos( 0, 0 )
		GAMEMODE.Vars.Monitor:SetSize( ScrW(), ScrH() )
		GAMEMODE.Vars.Monitor:SetTitle( "" )
		GAMEMODE.Vars.Monitor:SetVisible( true )
		GAMEMODE.Vars.Monitor:SetDraggable( false )
		GAMEMODE.Vars.Monitor:ShowCloseButton( control )
		GAMEMODE.Vars.Monitor:SetScreenLock(false)
		GAMEMODE.Vars.Monitor:SetWorldClicker(control)
		GAMEMODE.Vars.Monitor:SetPaintShadow(true)
		GAMEMODE.Vars.Monitor:SetBackgroundBlur(true)
		GAMEMODE.Vars.Monitor:MakePopup()
		GAMEMODE.Vars.Monitor:SetKeyboardInputEnabled(!control)
		GAMEMODE.Vars.Monitor.Paint = function( self, w, h )
			if !control then
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.DrawOutlinedRect( 35, 30, w-70, h-60 )
				surface.SetDrawColor( 255, 0, 0, 255 )
				draw.NoTexture()
				if GAMEMODE.FT==1 and math.fmod( math.Round( CurTime() ), 2 ) == 0 then
					draw.Circle( (160 * ( ScrH() / 480 ))/2, (160 * ( ScrH() / 480 ))/2, (45 * ( ScrH() / 480 ))/2, 64 )
				end
			end
		end
		GAMEMODE.Vars.Monitor.OnClose = function()
			fnafgmSetView(0)
			if lastlstate[1]==true then fnafgmCamLight( GAMEMODE.Vars.lastcam, false ) end
			if !control then
				LocalPlayer():StopSound( "fnafgm_campop" )
				LocalPlayer():StopSound( "fnafgm_campop2" )
				LocalPlayer():StopSound( "fnafgm_campop3" )
				net.Start( "fnafgmTabUsed" )
					net.WriteBit( false )
				net.SendToServer()
			end
		end
		GAMEMODE.Vars.Monitor.Think = function()
			
			if !control then
				
				if (!LocalPlayer():Alive() or GAMEMODE.Vars.tempostart or (GAMEMODE.Vars.poweroff and GAMEMODE.FT!=2)) then
					GAMEMODE.Vars.Monitor:Close()
				end
				
				if system.HasFocus()==false then
					if IsValid(FNaFView) then waitt = CurTime()+1 end
					GAMEMODE.Vars.Monitor:Close()
					LocalPlayer():EmitSound("fnafgm_camdown")
					if IsValid(OpenT) then OpenT:Show() end
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
				
			else
				
				if !LocalPlayer():Alive() or LocalPlayer():Team()!=2 or GAMEMODE.Vars.gameend then
					GAMEMODE.Vars.Monitor:Close()
				end
				
				if GAMEMODE.Vars.Monitor.MapS_Anim and GAMEMODE.Vars.Monitor.MapS_Anim:Active() then GAMEMODE.Vars.Monitor.MapS_Anim:Run() elseif GAMEMODE.Vars.Monitor.MapS_Anim then GAMEMODE.Vars.Monitor.MapS_Anim:Start(2) end
				
			end
			
			
		end
		
		local mapsize = math.Clamp( (512 * ( ScrH() / 480 ))/2, 128, 512 )
		local mapdecal = (64 * ( ScrH() / 480 ))/2
		
		if control then
			
			GAMEMODE.Vars.Monitor.Animatronics = {}
			
			local positron = 0
			local animsize = math.Clamp( (128 * ( ScrH() / 480 ))/2, 16, 128 )
			
			for k, v in pairs ( GAMEMODE.Vars.Animatronics ) do
				
				GAMEMODE.Vars.Monitor.Animatronics[k] = vgui.Create( "DImage" )
				GAMEMODE.Vars.Monitor.Animatronics[k]:SetParent(GAMEMODE.Vars.Monitor)
				GAMEMODE.Vars.Monitor.Animatronics[k]:SetImage( ( string.lower(GAMEMODE.ShortName) or "fnafgm" ).."/animatronicsico/"..k..".png" )
				GAMEMODE.Vars.Monitor.Animatronics[k]:SetPos( (42 * ( ScrH() / 480 ))/2+positron, mapdecal )
				GAMEMODE.Vars.Monitor.Animatronics[k]:SetSize( animsize, animsize )
				GAMEMODE.Vars.Monitor.Animatronics[k]:SetImageColor( Color( 85, 85, 85, 255 ) )
				GAMEMODE.Vars.Monitor.Animatronics[k].Paint = function( self, w, h )
					self:PaintAt( 0, 0, self:GetWide(), self:GetTall() )
					surface.SetDrawColor( 255, 255, 255, 255 )
					surface.DrawOutlinedRect( 0, 0, w, h )
				end
				
				GAMEMODE.Vars.Monitor.Animatronics[k].Txt = vgui.Create( "DLabel" )
				GAMEMODE.Vars.Monitor.Animatronics[k].Txt:SetParent(GAMEMODE.Vars.Monitor.Animatronics[k])
				GAMEMODE.Vars.Monitor.Animatronics[k].Txt:SetText( "" )
				GAMEMODE.Vars.Monitor.Animatronics[k].Txt:SetTextColor( Color( 255, 255, 255, 255 ) )
				GAMEMODE.Vars.Monitor.Animatronics[k].Txt:SetFont("FNAFGMTIME")
				GAMEMODE.Vars.Monitor.Animatronics[k].Txt:SetPos( 0, 0 )
				GAMEMODE.Vars.Monitor.Animatronics[k].Txt:SetSize( animsize, animsize )
				GAMEMODE.Vars.Monitor.Animatronics[k].Txt:SetContentAlignment( 2 )
				
				if GAMEMODE.Sound_Animatronic[k] then
					
					GAMEMODE.Vars.Monitor.Animatronics[k].Btn = vgui.Create( "DButton" )
					GAMEMODE.Vars.Monitor.Animatronics[k].Btn:SetParent(GAMEMODE.Vars.Monitor.Animatronics[k])
					GAMEMODE.Vars.Monitor.Animatronics[k].Btn:SetPos( 0, 0 )
					GAMEMODE.Vars.Monitor.Animatronics[k].Btn:SetSize( animsize, (32 * ( ScrH() / 480 ))/2 )
					GAMEMODE.Vars.Monitor.Animatronics[k].Btn:SetText("TAUNT")
					GAMEMODE.Vars.Monitor.Animatronics[k].Btn:SetFont("FNAFGMNIGHT")
					GAMEMODE.Vars.Monitor.Animatronics[k].Btn:SetTextColor( Color( 255, 255, 255, 255 ) )
					GAMEMODE.Vars.Monitor.Animatronics[k].Btn.DoClick = function( button )
						GAMEMODE:AnimatronicTaunt(k)
					end
					GAMEMODE.Vars.Monitor.Animatronics[k].Btn.Paint = function( self, w, h )
						draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 220 ) )
						surface.SetDrawColor( 255, 255, 255, 255 )
						surface.DrawOutlinedRect( 0, 0, w, h )
					end
					
				end
				
				positron = positron + animsize
				
			end
			
		end
		
		GAMEMODE.Vars.Monitor.Map = vgui.Create( "DImage" )
		GAMEMODE.Vars.Monitor.Map:SetParent(GAMEMODE.Vars.Monitor)
		GAMEMODE.Vars.Monitor.Map:SetPos( ScrW()-mapdecal-mapsize, ScrH()-mapdecal-mapsize )
		GAMEMODE.Vars.Monitor.Map:SetSize( mapsize, mapsize )
		
		if game.GetMap()=="freddysnoevent" and !control then
			GAMEMODE.Vars.Monitor.Map:SetImage( GAMEMODE.Materials_mapfreddys )
		elseif game.GetMap()=="freddysnoevent" then
			GAMEMODE.Vars.Monitor.Map:SetImage( "fnafgm/maps/freddys2" )
		elseif game.GetMap()=="fnaf2noevents" then
			GAMEMODE.Vars.Monitor.Map:SetImage( GAMEMODE.Materials_mapfnaf2 )
		end
		
		GAMEMODE.Vars.Monitor.Map2 = vgui.Create( "DImage" )
		GAMEMODE.Vars.Monitor.Map2:SetParent(GAMEMODE.Vars.Monitor)
		GAMEMODE.Vars.Monitor.Map2:SetPos( mapdecal, ScrH()-mapdecal-mapsize )
		GAMEMODE.Vars.Monitor.Map2:SetSize( mapsize, mapsize )
		
		GAMEMODE.Vars.Monitor.CamsNames = vgui.Create( "DLabel" )
		GAMEMODE.Vars.Monitor.CamsNames:SetParent(GAMEMODE.Vars.Monitor)
		GAMEMODE.Vars.Monitor.CamsNames:SetText( GAMEMODE.CamsNames[game.GetMap().."_"..GAMEMODE.Vars.lastcam] or "")
		GAMEMODE.Vars.Monitor.CamsNames:SetTextColor( Color( 255, 255, 255, 255 ) )
		GAMEMODE.Vars.Monitor.CamsNames:SetFont("FNAFGMCAMNAME")
		GAMEMODE.Vars.Monitor.CamsNames:SetPos( ScrW()-64-mapsize, ScrH()-mapdecal-mapsize-mapdecal )
		GAMEMODE.Vars.Monitor.CamsNames:SetSize( 512, 64 )
		
		GAMEMODE.Vars.Monitor.Buttons = {}
		
		function GAMEMODE.Vars.Monitor:CreateButton(camid,map,x,y,w,h,b)
			
			local addi = 0
			if control or GAMEMODE.Vars.Cheat.VISION then addi = math.Clamp( (16 * ( ScrH() / 480 ))/2, 0, 16 ) end
			
			GAMEMODE.Vars.Monitor.Buttons[camid] = vgui.Create( "DButton" )
			GAMEMODE.Vars.Monitor.Buttons[camid]:SetParent(map or GAMEMODE.Vars.Monitor.Map)
			GAMEMODE.Vars.Monitor.Buttons[camid]:SetSize( math.Clamp( (w * ( ScrH() / 480 ))/2, 0, w ), math.Clamp( (h * ( ScrH() / 480 ))/2, 0, h )+addi )
			GAMEMODE.Vars.Monitor.Buttons[camid]:SetPos( math.Clamp( (x * ( ScrH() / 480 ))/2, 0, x ), math.Clamp( (y * ( ScrH() / 480 ))/2, 0, y ) )
			GAMEMODE.Vars.Monitor.Buttons[camid]:SetText("")
			GAMEMODE.Vars.Monitor.Buttons[camid].OnMousePressed = function( button, key )
				if key==MOUSE_LEFT then
					LocalPlayer():EmitSound("fnafgm_camselect")
					GAMEMODE.Vars.lastcam = camid
					fnafgmSetView(GAMEMODE.Vars.lastcam)
					GAMEMODE.Vars.Monitor.CamsNames:SetText( GAMEMODE.TranslatedCamNames[game.GetMap().."_"..GAMEMODE.Vars.lastcam] or "" )
					if IsValid(GAMEMODE.Vars.Monitor.KitchenText) and IsValid(GAMEMODE.Vars.Monitor.KitchenText2) then
						if camid!=11 then
							GAMEMODE.Vars.Monitor.KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
							GAMEMODE.Vars.Monitor.KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
						else
							GAMEMODE.Vars.Monitor.KitchenText:SetTextColor( Color( 255, 255, 255, 255 ) )
							GAMEMODE.Vars.Monitor.KitchenText2:SetTextColor( Color( 255, 255, 255, 255 ) )
						end
					end
				elseif control and key==MOUSE_RIGHT then
					GAMEMODE.Vars.Monitor:MoveMenu(camid)
				end
			end
			GAMEMODE.Vars.Monitor.Buttons[camid].Paint = function( self, w, h )
				if GAMEMODE.Vars.lastcam==camid and ( GAMEMODE.FT!=1 or math.fmod( math.Round( CurTime()*2 ), 2 ) == 0 ) then
					local bt = math.Clamp( (b * ( ScrH() / 480 ))/2, 0, b )
					draw.RoundedBox( 0, bt, bt, w-bt*2, h-bt*2-addi, Color( 136, 168, 0, 128 ) )
				end
				if control or GAMEMODE.Vars.Cheat.VISION then
					local positron = 0
					for k, v in pairs ( GAMEMODE.Vars.Animatronics ) do
						if GAMEMODE.Vars.Animatronics[k][2]==camid then
							local png
							if file.Exists( "materials/"..string.lower(GAMEMODE.ShortName).."/icon16/"..k..".png", "GAME" ) then
								png = Material( string.lower(GAMEMODE.ShortName).."/icon16/"..k..".png", "noclamp smooth" )
							elseif file.Exists( "materials/fnafgm/icon16/"..k..".png", "GAME" ) then
								png = Material( "fnafgm/icon16/"..k..".png", "noclamp smooth" )
							end
							if png!=nil then surface.SetMaterial(png) end
							surface.SetDrawColor(255, 255, 255, 255)
							surface.DrawTexturedRect(positron, h-addi, addi, addi)
							positron = positron + addi
						end
					end
				end
			end
			
		end
		
		local nope = hook.Call("fnafgmSecurityTabletCustom",nil,control) or false
		
		if !nope then
			
			if game.GetMap()=="freddysnoevent" then
				
				if !control then
					
					local closebtnsizew = (512 * ( ScrH() / 480 ))/2
					local closebtnsizeh = (60 * ( ScrH() / 480 ))/2
					local closebtnsizec = (128 * ( ScrH() / 480 ))/2
					
					CloseT = vgui.Create( "DButton" )
					CloseT:SetParent(GAMEMODE.Vars.Monitor)
					CloseT:SetSize( ScrW()/2-closebtnsizec, closebtnsizeh )
					CloseT:SetPos( closebtnsizew-closebtnsizec, ScrH()-closebtnsizeh-50 )
					CloseT:SetText("")
					CloseT.DoClick = function( button )
						if IsValid(FNaFView) then waitt = CurTime()+1 end
						GAMEMODE.Vars.Monitor:Close()
						LocalPlayer():EmitSound("fnafgm_camdown")
						if IsValid(OpenT) then OpenT:Show() end
					end
					CloseT.OnCursorEntered = function()
						if IsValid(FNaFView) then
							if !waitt then waitt=0 end
							if waitt<CurTime() then
								waitt = CurTime()+0.5
								GAMEMODE.Vars.Monitor:Close()
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
					
					if !GAMEMODE.Vars.mute then
						local MUTET = vgui.Create( "DImage" )
						MUTET:SetParent(GAMEMODE.Vars.Monitor)
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
					
					GAMEMODE.Vars.Monitor.KitchenText = vgui.Create( "DLabel" )
					GAMEMODE.Vars.Monitor.KitchenText:SetParent(GAMEMODE.Vars.Monitor)
					GAMEMODE.Vars.Monitor.KitchenText:SetText( "-CAMERA DISABLED-" )
					GAMEMODE.Vars.Monitor.KitchenText:SetTextColor( Color( 255, 255, 255, 0 ) )
					GAMEMODE.Vars.Monitor.KitchenText:SetFont("FNAFGMTIME")
					GAMEMODE.Vars.Monitor.KitchenText:SetPos( ScrW()/2-256, 80 )
					GAMEMODE.Vars.Monitor.KitchenText:SetContentAlignment( 8 )
					GAMEMODE.Vars.Monitor.KitchenText:SizeToContents()
					
					GAMEMODE.Vars.Monitor.KitchenText2 = vgui.Create( "DLabel" )
					GAMEMODE.Vars.Monitor.KitchenText2:SetParent(GAMEMODE.Vars.Monitor)
					GAMEMODE.Vars.Monitor.KitchenText2:SetText( "AUDIO ONLY" )
					GAMEMODE.Vars.Monitor.KitchenText2:SetTextColor( Color( 255, 255, 255, 0 ) )
					GAMEMODE.Vars.Monitor.KitchenText2:SetFont("FNAFGMTIME")
					GAMEMODE.Vars.Monitor.KitchenText2:SetPos( ScrW()/2-150, 80+60 )
					GAMEMODE.Vars.Monitor.KitchenText2:SetContentAlignment( 8 )
					GAMEMODE.Vars.Monitor.KitchenText2:SizeToContents()
					
					if GAMEMODE.Vars.lastcam==11 then
						GAMEMODE.Vars.Monitor.KitchenText:SetTextColor( Color( 255, 255, 255, 255 ) )
						GAMEMODE.Vars.Monitor.KitchenText2:SetTextColor( Color( 255, 255, 255, 255 ) )
					end
					
				else
					
					GAMEMODE.Vars.Monitor.MapS = vgui.Create( "DImage" )
					GAMEMODE.Vars.Monitor.MapS:SetParent(GAMEMODE.Vars.Monitor.Map)
					GAMEMODE.Vars.Monitor.MapS:SetImage( "fnafgm/maps/freddys2_s" )
					GAMEMODE.Vars.Monitor.MapS:SetPos( 0, 0 )
					GAMEMODE.Vars.Monitor.MapS:SetSize( mapsize, mapsize )
					GAMEMODE.Vars.Monitor.MapS:SetImageColor( GAMEMODE.Colors_animatronics )
					
					GAMEMODE.Vars.Monitor.MapS_Anim = Derma_Anim( "maps_anim", GAMEMODE.Vars.Monitor.MapS, function( pnl, anim, delta, data )
						pnl:SetImageColor( Color(255,0,0,255*math.abs(delta*2-1)) )
					end)
					
					GAMEMODE.Vars.Monitor.MapS_Anim:Start(2)
					
				end
				
				GAMEMODE.Vars.Monitor:CreateButton(1,GAMEMODE.Vars.Monitor.Map,161,408,76,50,4)
				GAMEMODE.Vars.Monitor:CreateButton(2,GAMEMODE.Vars.Monitor.Map,161,357,76,50,4)
				GAMEMODE.Vars.Monitor:CreateButton(3,GAMEMODE.Vars.Monitor.Map,54,334,76,50,4)
				GAMEMODE.Vars.Monitor:CreateButton(4,GAMEMODE.Vars.Monitor.Map,297,358,76,50,4)
				GAMEMODE.Vars.Monitor:CreateButton(5,GAMEMODE.Vars.Monitor.Map,297,410,76,50,4)
				GAMEMODE.Vars.Monitor:CreateButton(6,GAMEMODE.Vars.Monitor.Map,0,143,76,50,4)
				GAMEMODE.Vars.Monitor:CreateButton(7,GAMEMODE.Vars.Monitor.Map,161,37,76,50,4)
				GAMEMODE.Vars.Monitor:CreateButton(8,GAMEMODE.Vars.Monitor.Map,431,143,76,50,4)
				GAMEMODE.Vars.Monitor:CreateButton(9,GAMEMODE.Vars.Monitor.Map,95,208,76,50,4)
				GAMEMODE.Vars.Monitor:CreateButton(10,GAMEMODE.Vars.Monitor.Map,136,109,76,50,4)
				GAMEMODE.Vars.Monitor:CreateButton(11,GAMEMODE.Vars.Monitor.Map,421,312,76,50,4)
				if control then GAMEMODE.Vars.Monitor:CreateButton(12,GAMEMODE.Vars.Monitor.Map,228,397,51,78,2) end
		
		
			elseif game.GetMap()=="fnaf2noevents" then
				
				if !control then
					
					CloseT = vgui.Create( "DButton" )
					CloseT:SetParent(GAMEMODE.Vars.Monitor)
					CloseT:SetSize( ScrW()/2 - 128, 64 )
					CloseT:SetPos( ScrW()/2 + 32, ScrH()-80-50 )
					CloseT:SetText( "" )
					CloseT.DoClick = function( button )
						if IsValid(FNaFView) then waitt = CurTime()+1 end
						GAMEMODE.Vars.Monitor:Close()
						LocalPlayer():EmitSound("fnafgm_camdown2")
						if IsValid(OpenT) then OpenT:Show() end
						if IsValid(SafeE) then SafeE:Show() end
					end
					CloseT.OnCursorEntered = function()
						if IsValid(FNaFView) then
							if !waitt then waitt=0 end
							if waitt<CurTime() then
								waitt = CurTime()+0.5
								GAMEMODE.Vars.Monitor:Close()
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
					
				end
				
				GAMEMODE.Vars.Monitor:CreateButton(1,GAMEMODE.Vars.Monitor.Map,32,290,70,46,4)
				GAMEMODE.Vars.Monitor:CreateButton(2,GAMEMODE.Vars.Monitor.Map,188,291,70,46,4)
				GAMEMODE.Vars.Monitor:CreateButton(3,GAMEMODE.Vars.Monitor.Map,32,213,70,46,4)
				GAMEMODE.Vars.Monitor:CreateButton(4,GAMEMODE.Vars.Monitor.Map,191,213,70,46,4)
				GAMEMODE.Vars.Monitor:CreateButton(5,GAMEMODE.Vars.Monitor.Map,175,401,70,46,4)
				GAMEMODE.Vars.Monitor:CreateButton(6,GAMEMODE.Vars.Monitor.Map,40,401,70,46,4)
				GAMEMODE.Vars.Monitor:CreateButton(7,GAMEMODE.Vars.Monitor.Map,216,142,70,46,4)
				GAMEMODE.Vars.Monitor:CreateButton(8,GAMEMODE.Vars.Monitor.Map,34,129,70,46,4)
				GAMEMODE.Vars.Monitor:CreateButton(9,GAMEMODE.Vars.Monitor.Map,422,291,70,46,4)
				GAMEMODE.Vars.Monitor:CreateButton(10,GAMEMODE.Vars.Monitor.Map,442,182,70,46,4)
				GAMEMODE.Vars.Monitor:CreateButton(11,GAMEMODE.Vars.Monitor.Map,321,234,70,46,4)
				GAMEMODE.Vars.Monitor:CreateButton(12,GAMEMODE.Vars.Monitor.Map,401,94,70,46,4)
				
				
			elseif game.GetMap()=="fnaf3" then
				
				local CAM = vgui.Create( "DNumberWang" )
				CAM:SetParent(GAMEMODE.Vars.Monitor)
				CAM:SetPos( ScrW()/2-16, ScrH()-80-50-80 )
				CAM:SetMinMax(1,15)
				CAM:SetSize( 34, 28 )
				CAM:SetValue(GAMEMODE.Vars.lastcam)
				CAM.OnValueChanged = function( val )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( math.Round( val:GetValue() ) )
					GAMEMODE.Vars.lastcam = val:GetValue()
					GAMEMODE.Vars.Monitor.CamsNames:SetText( "CAM"..val:GetValue() )
				end
				
				local closebtnsizew = (512 * ( ScrH() / 480 ))/2
				local closebtnsizeh = (60 * ( ScrH() / 480 ))/2
				
				CloseT = vgui.Create( "DButton" )
				CloseT:SetParent(GAMEMODE.Vars.Monitor)
				CloseT:SetSize( closebtnsizew, closebtnsizeh )
				CloseT:SetPos( ScrW()/2-closebtnsizew/2, ScrH()-closebtnsizeh-50 )
				CloseT:SetText( "" )
				CloseT:SetTextColor( Color( 255, 255, 255, 255 ) )
				CloseT:SetFont("FNAFGMID")
				CloseT.DoClick = function( button )
					if IsValid(FNaFView) then waitt = CurTime()+1 end
					GAMEMODE.Vars.Monitor:Close()
					LocalPlayer():EmitSound("fnafgm_camdown3")
					if IsValid(OpenT) then OpenT:Show() end
				end
				CloseT.OnCursorEntered = function()
					if IsValid(FNaFView) then
						if !waitt then waitt=0 end
						if waitt<CurTime() then
							waitt = CurTime()+0.5
							GAMEMODE.Vars.Monitor:Close()
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
				
				
				local CAM = vgui.Create( "DNumberWang" )
				CAM:SetParent(GAMEMODE.Vars.Monitor)
				CAM:SetPos( ScrW()/2-16, ScrH()-80-50-80 )
				CAM:SetMinMax(1,table.Count(ents.FindByClass( "fnafgm_camera" )))
				CAM:SetSize( 34, 28 )
				CAM:SetValue(GAMEMODE.Vars.lastcam)
				CAM.OnValueChanged = function( val )
					LocalPlayer():EmitSound("fnafgm_camselect")
					fnafgmSetView( math.Round( val:GetValue() ) )
					GAMEMODE.Vars.lastcam = val:GetValue()
					GAMEMODE.Vars.Monitor.CamsNames:SetText( "CAM"..val:GetValue() )
				end
				
				local closebtnsizew = (512 * ( ScrH() / 480 ))/2
				local closebtnsizeh = (60 * ( ScrH() / 480 ))/2
				
				CloseT = vgui.Create( "DButton" )
				CloseT:SetParent(GAMEMODE.Vars.Monitor)
				CloseT:SetSize( closebtnsizew, closebtnsizeh )
				CloseT:SetPos( ScrW()/2-closebtnsizew/2, ScrH()-closebtnsizeh-50 )
				CloseT:SetText( "" )
				CloseT:SetTextColor( Color( 255, 255, 255, 255 ) )
				CloseT:SetFont("FNAFGMID")
				CloseT.DoClick = function( button )
					if IsValid(FNaFView) then waitt = CurTime()+1 end
					GAMEMODE.Vars.Monitor:Close()
					LocalPlayer():EmitSound("fnafgm_camdown")
					if IsValid(OpenT) then OpenT:Show() end
				end
				CloseT.OnCursorEntered = function()
					if IsValid(FNaFView) then
						if !waitt then waitt=0 end
						if waitt<CurTime() then
							waitt = CurTime()+0.5
							GAMEMODE.Vars.Monitor:Close()
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
		
		function GAMEMODE.Vars.Monitor:MoveMenu(apos)
			
			local Menu = vgui.Create( "DMenu" )
			
			for k, v in pairs ( GAMEMODE.Vars.Animatronics ) do
				
				if GAMEMODE.Vars.Animatronics[k][2]!=apos and GAMEMODE.Vars.Animatronics[k][2]!=GAMEMODE.APos[game.GetMap()].Office and GAMEMODE.AnimatronicAPos[k] and GAMEMODE.AnimatronicAPos[k][game.GetMap()] and GAMEMODE.AnimatronicAPos[k][game.GetMap()][apos] and GAMEMODE.Vars.Animatronics[k][3]!=-1 and SysTime()+GAMEMODE.Vars.Animatronics[k][3]<=SysTime() then
					
					if apos==GAMEMODE.APos[game.GetMap()].SS then break end
					
					nope = hook.Call("fnafgmPreventAnimatronicMove", nil, k,apos)
					
					if !nope then 
						
						local btn = Menu:AddOption( GAMEMODE.AnimatronicName[k] )
						
						if file.Exists( "materials/"..string.lower(GAMEMODE.ShortName).."/icon16/"..k..".png", "GAME" ) then
							btn:SetIcon( string.lower(GAMEMODE.ShortName).."/icon16/"..k..".png" )
						elseif file.Exists( "materials/fnafgm/icon16/"..k..".png", "GAME" ) then
							btn:SetIcon( "fnafgm/icon16/"..k..".png" )
						end
						
						btn.OnMousePressed = function( button, key )
							GAMEMODE:SetAnimatronicPos(k,apos)
							Menu:Remove()
						end
						
					end
					
				end
				
			end
			
			Menu:Open()
			
		end
		
		
	end
	
	
end

function GM:CloseMonitor()
	if IsValid(GAMEMODE.Vars.Monitor) then
		GAMEMODE.Vars.Monitor:Close()
	end
end

net.Receive( "fnafgmCloseTablet", function( len )
	GAMEMODE:CloseMonitor()
end)

net.Receive( "fnafgmSecurityTablet", function( len )
	GAMEMODE:Monitor()
end)