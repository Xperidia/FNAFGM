function fnafgmSecret()
	
	if !IsValid(fnafgmSecretD) and !engine.IsPlayingDemo() then
		
		local password=""
		local nope = false
		
		fnafgmSecretD = vgui.Create( "DFrame" )
		fnafgmSecretD:SetPos( ScrW()/2-52, ScrH()/2-74 )
		fnafgmSecretD:SetSize( 104, 148 )
		fnafgmSecretD:SetTitle("")
		fnafgmSecretD:SetVisible(true)
		fnafgmSecretD:ShowCloseButton(false)
		fnafgmSecretD:SetScreenLock(true)
		fnafgmSecretD.Paint = function( self, w, h )
			draw.RoundedBox( 4, 0, 0, w, h, Color( 64, 64, 64, 255 ) )
		end
		fnafgmSecretD.Think = function(self)
			
			if secrete_anim:Active() then secrete_anim:Run() end
			
			if IsValid(fnafgmNUMD) and ( input.IsKeyDown(KEY_ENTER) or input.IsKeyDown(KEY_PAD_ENTER) ) then
				if !nope then fnafgmNUMD.DoClick() end
				nope=true
				return
			end
			
			if IsValid(fnafgmNUM1) and ( input.IsKeyDown(KEY_1) or input.IsKeyDown(KEY_PAD_1) ) then
				if !nope then fnafgmNUM1.DoClick() end
				nope=true
				return
			end
			
			if IsValid(fnafgmNUM2) and ( input.IsKeyDown(KEY_2) or input.IsKeyDown(KEY_PAD_2) ) then
				if !nope then fnafgmNUM2.DoClick() end
				nope=true
				return
			end
			
			if IsValid(fnafgmNUM3) and ( input.IsKeyDown(KEY_3) or input.IsKeyDown(KEY_PAD_3) ) then
				if !nope then fnafgmNUM3.DoClick() end
				nope=true
				return
			end
			
			if IsValid(fnafgmNUM4) and ( input.IsKeyDown(KEY_4) or input.IsKeyDown(KEY_PAD_4) ) then
				if !nope then fnafgmNUM4.DoClick() end
				nope=true
				return
			end
			
			if IsValid(fnafgmNUM5) and ( input.IsKeyDown(KEY_5) or input.IsKeyDown(KEY_PAD_5) ) then
				if !nope then fnafgmNUM5.DoClick() end
				nope=true
				return
			end
			
			if IsValid(fnafgmNUM6) and ( input.IsKeyDown(KEY_6) or input.IsKeyDown(KEY_PAD_6) ) then
				if !nope then fnafgmNUM6.DoClick() end
				nope=true
				return
			end
			
			if IsValid(fnafgmNUM7) and ( input.IsKeyDown(KEY_7) or input.IsKeyDown(KEY_PAD_7) ) then
				if !nope then fnafgmNUM7.DoClick() end
				nope=true
				return
			end
			
			if IsValid(fnafgmNUM8) and ( input.IsKeyDown(KEY_8) or input.IsKeyDown(KEY_PAD_8) ) then
				if !nope then fnafgmNUM8.DoClick() end
				nope=true
				return
			end
			
			if IsValid(fnafgmNUM9) and ( input.IsKeyDown(KEY_9) or input.IsKeyDown(KEY_PAD_9) ) then
				if !nope then fnafgmNUM9.DoClick() end
				nope=true
				return
			end
			
			if IsValid(fnafgmNUM0) and ( input.IsKeyDown(KEY_0) or input.IsKeyDown(KEY_PAD_0) ) then
				if !nope then fnafgmNUM0.DoClick() end
				nope=true
				return
			end
			
			if input.IsKeyDown( KEY_ESCAPE ) then
				fnafgmSecretD:Close()
			end
			
			nope=false
			
		end
		fnafgmSecretD:MakePopup()
		
		fnafgmSecretPasswordlbl = vgui.Create( "DLabel" )
		fnafgmSecretPasswordlbl:SetParent(fnafgmSecretD)
		fnafgmSecretPasswordlbl:SetText( "PASSWORD" )
		fnafgmSecretPasswordlbl:SetPos( 0, 0 )
		fnafgmSecretPasswordlbl:SetSize(104,16)
		fnafgmSecretPasswordlbl:SetTextColor( Color( 255, 255, 255, 255 ) )
		fnafgmSecretPasswordlbl:SetContentAlignment(5)
		
		fnafgmNUM1 = vgui.Create( "DButton", fnafgmSecretD )
		fnafgmNUM1:SetSize( 32, 32 )
		fnafgmNUM1:SetPos( 0+4, 16 )
		fnafgmNUM1:SetText("1")
		fnafgmNUM1:SetTextColor( Color( 255, 255, 255, 255 ) )
		fnafgmNUM1.DoClick = function( button )
			password=password.."1"
			fnafgmSecretPasswordlbl:SetText( password )
			fnafgmSecretPasswordlbl:SetTextColor( Color( 255, 255, 255, 255 ) )
		end
		fnafgmNUM1.Paint = function( self, w, h )
			if self:IsHovered() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 96, 96, 96, 255 ) )
			end
			if self:IsDown() or input.IsKeyDown(KEY_1) or input.IsKeyDown(KEY_PAD_1) then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		fnafgmNUM2 = vgui.Create( "DButton", fnafgmSecretD )
		fnafgmNUM2:SetSize( 32, 32 )
		fnafgmNUM2:SetPos( 32+4, 16 )
		fnafgmNUM2:SetText("2")
		fnafgmNUM2:SetTextColor( Color( 255, 255, 255, 255 ) )
		fnafgmNUM2.DoClick = function( button )
			password=password.."2"
			fnafgmSecretPasswordlbl:SetText( password )
			fnafgmSecretPasswordlbl:SetTextColor( Color( 255, 255, 255, 255 ) )
		end
		fnafgmNUM2.Paint = function( self, w, h )
			if self:IsHovered() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 96, 96, 96, 255 ) )
			end
			if self:IsDown() or input.IsKeyDown(KEY_2) or input.IsKeyDown(KEY_PAD_2) then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		fnafgmNUM3 = vgui.Create( "DButton", fnafgmSecretD )
		fnafgmNUM3:SetSize( 32, 32 )
		fnafgmNUM3:SetPos( 64+4, 16 )
		fnafgmNUM3:SetText("3")
		fnafgmNUM3:SetTextColor( Color( 255, 255, 255, 255 ) )
		fnafgmNUM3.DoClick = function( button )
			password=password.."3"
			fnafgmSecretPasswordlbl:SetText( password )
			fnafgmSecretPasswordlbl:SetTextColor( Color( 255, 255, 255, 255 ) )
		end
		fnafgmNUM3.Paint = function( self, w, h )
			if self:IsHovered() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 96, 96, 96, 255 ) )
			end
			if self:IsDown() or input.IsKeyDown(KEY_3) or input.IsKeyDown(KEY_PAD_3) then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		fnafgmNUM4 = vgui.Create( "DButton", fnafgmSecretD )
		fnafgmNUM4:SetSize( 32, 32 )
		fnafgmNUM4:SetPos( 0+4, 48 )
		fnafgmNUM4:SetText("4")
		fnafgmNUM4:SetTextColor( Color( 255, 255, 255, 255 ) )
		fnafgmNUM4.DoClick = function( button )
			password=password.."4"
			fnafgmSecretPasswordlbl:SetText( password )
			fnafgmSecretPasswordlbl:SetTextColor( Color( 255, 255, 255, 255 ) )
		end
		fnafgmNUM4.Paint = function( self, w, h )
			if self:IsHovered() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 96, 96, 96, 255 ) )
			end
			if self:IsDown() or input.IsKeyDown(KEY_4) or input.IsKeyDown(KEY_PAD_4) then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		fnafgmNUM5 = vgui.Create( "DButton", fnafgmSecretD )
		fnafgmNUM5:SetSize( 32, 32 )
		fnafgmNUM5:SetPos( 32+4, 48 )
		fnafgmNUM5:SetText("5")
		fnafgmNUM5:SetTextColor( Color( 255, 255, 255, 255 ) )
		fnafgmNUM5.DoClick = function( button )
			password=password.."5"
			fnafgmSecretPasswordlbl:SetText( password )
			fnafgmSecretPasswordlbl:SetTextColor( Color( 255, 255, 255, 255 ) )
		end
		fnafgmNUM5.Paint = function( self, w, h )
			if self:IsHovered() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 96, 96, 96, 255 ) )
			end
			if self:IsDown() or input.IsKeyDown(KEY_5) or input.IsKeyDown(KEY_PAD_5) then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		fnafgmNUM6 = vgui.Create( "DButton", fnafgmSecretD )
		fnafgmNUM6:SetSize( 32, 32 )
		fnafgmNUM6:SetPos( 64+4, 48 )
		fnafgmNUM6:SetText("6")
		fnafgmNUM6:SetTextColor( Color( 255, 255, 255, 255 ) )
		fnafgmNUM6.DoClick = function( button )
			password=password.."6"
			fnafgmSecretPasswordlbl:SetText( password )
			fnafgmSecretPasswordlbl:SetTextColor( Color( 255, 255, 255, 255 ) )
		end
		fnafgmNUM6.Paint = function( self, w, h )
			if self:IsHovered() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 96, 96, 96, 255 ) )
			end
			if self:IsDown() or input.IsKeyDown(KEY_6) or input.IsKeyDown(KEY_PAD_6) then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		fnafgmNUM7 = vgui.Create( "DButton", fnafgmSecretD )
		fnafgmNUM7:SetSize( 32, 32 )
		fnafgmNUM7:SetPos( 0+4, 80 )
		fnafgmNUM7:SetText("7")
		fnafgmNUM7:SetTextColor( Color( 255, 255, 255, 255 ) )
		fnafgmNUM7.DoClick = function( button )
			password=password.."7"
			fnafgmSecretPasswordlbl:SetText( password )
			fnafgmSecretPasswordlbl:SetTextColor( Color( 255, 255, 255, 255 ) )
		end
		fnafgmNUM7.Paint = function( self, w, h )
			if self:IsHovered() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 96, 96, 96, 255 ) )
			end
			if self:IsDown() or input.IsKeyDown(KEY_7) or input.IsKeyDown(KEY_PAD_7) then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		fnafgmNUM8 = vgui.Create( "DButton", fnafgmSecretD )
		fnafgmNUM8:SetSize( 32, 32 )
		fnafgmNUM8:SetPos( 32+4, 80 )
		fnafgmNUM8:SetText("8")
		fnafgmNUM8:SetTextColor( Color( 255, 255, 255, 255 ) )
		fnafgmNUM8.DoClick = function( button )
			password=password.."8"
			fnafgmSecretPasswordlbl:SetText( password )
			fnafgmSecretPasswordlbl:SetTextColor( Color( 255, 255, 255, 255 ) )
		end
		fnafgmNUM8.Paint = function( self, w, h )
			if self:IsHovered() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 96, 96, 96, 255 ) )
			end
			if self:IsDown() or input.IsKeyDown(KEY_8) or input.IsKeyDown(KEY_PAD_8) then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		fnafgmNUM9 = vgui.Create( "DButton", fnafgmSecretD )
		fnafgmNUM9:SetSize( 32, 32 )
		fnafgmNUM9:SetPos( 64+4, 80 )
		fnafgmNUM9:SetText("9")
		fnafgmNUM9:SetTextColor( Color( 255, 255, 255, 255 ) )
		fnafgmNUM9.DoClick = function( button )
			password=password.."9"
			fnafgmSecretPasswordlbl:SetText( password )
			fnafgmSecretPasswordlbl:SetTextColor( Color( 255, 255, 255, 255 ) )
		end
		fnafgmNUM9.Paint = function( self, w, h )
			if self:IsHovered() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 96, 96, 96, 255 ) )
			end
			if self:IsDown() or input.IsKeyDown(KEY_9) or input.IsKeyDown(KEY_PAD_9) then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		fnafgmNUMS = vgui.Create( "DButton", fnafgmSecretD )
		fnafgmNUMS:SetSize( 32, 32 )
		fnafgmNUMS:SetPos( 0+4, 112 )
		fnafgmNUMS:SetText("X")
		fnafgmNUMS:SetTextColor( Color( 170, 0, 0, 255 ) )
		fnafgmNUMS.DoClick = function( button )
			fnafgmSecretD:Close()
		end
		fnafgmNUMS.Paint = function( self, w, h )
			if self:IsHovered() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 96, 96, 96, 255 ) )
			end
			if self:IsDown() or input.IsKeyDown( KEY_ESCAPE ) then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		fnafgmNUM0 = vgui.Create( "DButton", fnafgmSecretD )
		fnafgmNUM0:SetSize( 32, 32 )
		fnafgmNUM0:SetPos( 32+4, 112 )
		fnafgmNUM0:SetText("0")
		fnafgmNUM0:SetTextColor( Color( 255, 255, 255, 255 ) )
		fnafgmNUM0.DoClick = function( button )
			password=password.."0"
			fnafgmSecretPasswordlbl:SetText( password )
			fnafgmSecretPasswordlbl:SetTextColor( Color( 255, 255, 255, 255 ) )
		end
		fnafgmNUM0.Paint = function( self, w, h )
			if self:IsHovered() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 96, 96, 96, 255 ) )
			end
			if self:IsDown() or input.IsKeyDown(KEY_0) or input.IsKeyDown(KEY_PAD_0) then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		fnafgmNUMD = vgui.Create( "DButton", fnafgmSecretD )
		fnafgmNUMD:SetSize( 32, 32 )
		fnafgmNUMD:SetPos( 64+4, 112 )
		fnafgmNUMD:SetText("OK")
		fnafgmNUMD:SetTextColor( Color( 0, 170, 0, 255 ) )
		fnafgmNUMD.DoClick = function( button )
			if password=="2015" then
				fnafgmNUM1:Remove()
				fnafgmNUM2:Remove()
				fnafgmNUM3:Remove()
				fnafgmNUM4:Remove()
				fnafgmNUM5:Remove()
				fnafgmNUM6:Remove()
				fnafgmNUM7:Remove()
				fnafgmNUM8:Remove()
				fnafgmNUM9:Remove()
				fnafgmNUM0:Remove()
				fnafgmSecretPasswordlbl:Remove()
				secrete_anim:Start(0.25)
				fnafgmNUMD:Remove()
				fnafgmNUMS:SetPos( 352, 0 )
				fnafgmNUMS:SetZPos(1000)
				local Zed = vgui.Create( "DHTML" )
				Zed:SetParent(fnafgmSecretD)
				Zed:SetPos( 0, 0 )
				Zed:SetSize( 384, 384 )
				Zed:SetAllowLua(true)
				Zed:OpenURL( "www.Xperidia.com/DAT_FACE.html" )
				Zed:SetScrollbars(false)
			elseif password=="666" then
				password=""
				fnafgmSecretPasswordlbl:SetText( "HALLOWEEN" )
				fnafgmSecretPasswordlbl:SetTextColor( Color( 0, 255, 0, 255 ) )
				Halloween=true
			else
				password=""
				fnafgmSecretPasswordlbl:SetText( "NOPE" )
				fnafgmSecretPasswordlbl:SetTextColor( Color( 255, 0, 0, 255 ) )
			end
		end
		fnafgmNUMD.Paint = function( self, w, h )
			if self:IsHovered() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 96, 96, 96, 255 ) )
			end
			if self:IsDown() or input.IsKeyDown(KEY_ENTER) or input.IsKeyDown(KEY_PAD_ENTER) then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		secrete_anim = Derma_Anim( "secrete_anim", fnafgmSecretD, function( pnl, anim, delta, data )
			pnl:SetSize( 280*delta+104, 236*delta+148 )
			pnl:SetPos( (ScrW()/2-52)-140*delta, (ScrH()/2-74)-124*delta )
		end)
		
	end
	
end