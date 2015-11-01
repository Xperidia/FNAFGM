function fnafgmSecret()
	
	if !IsValid(fnafgmSecretD) and !engine.IsPlayingDemo() then
		
		local password=""
		
		fnafgmSecretD = vgui.Create( "DFrame" )
		fnafgmSecretD:SetPos( ScrW()/2-52, ScrH()/2-68 )
		fnafgmSecretD:SetSize( 104, 136 )
		fnafgmSecretD:SetTitle("")
		fnafgmSecretD:SetVisible(true)
		fnafgmSecretD:ShowCloseButton(false)
		fnafgmSecretD:SetScreenLock(true)
		fnafgmSecretD.Paint = function( self, w, h )
			draw.RoundedBox( 4, 0, 0, w, h, Color( 64, 64, 64, 255 ) )
		end
		fnafgmSecretD.Think = function(self)
			
			if secrete_anim:Active() then secrete_anim:Run() end
			
		end
		fnafgmSecretD:MakePopup()
		
		local NUM1 = vgui.Create( "DButton", fnafgmSecretD )
		NUM1:SetSize( 32, 32 )
		NUM1:SetPos( 0+4, 4 )
		NUM1:SetText("1")
		NUM1:SetTextColor( Color( 255, 255, 255, 255 ) )
		NUM1.DoClick = function( button )
			password=password.."1"
		end
		NUM1.Paint = function( self, w, h )
			if self:IsDown() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		local NUM2 = vgui.Create( "DButton", fnafgmSecretD )
		NUM2:SetSize( 32, 32 )
		NUM2:SetPos( 32+4, 4 )
		NUM2:SetText("2")
		NUM2:SetTextColor( Color( 255, 255, 255, 255 ) )
		NUM2.DoClick = function( button )
			password=password.."2"
		end
		NUM2.Paint = function( self, w, h )
			if self:IsDown() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		local NUM3 = vgui.Create( "DButton", fnafgmSecretD )
		NUM3:SetSize( 32, 32 )
		NUM3:SetPos( 64+4, 4 )
		NUM3:SetText("3")
		NUM3:SetTextColor( Color( 255, 255, 255, 255 ) )
		NUM3.DoClick = function( button )
			password=password.."3"
		end
		NUM3.Paint = function( self, w, h )
			if self:IsDown() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		local NUM4 = vgui.Create( "DButton", fnafgmSecretD )
		NUM4:SetSize( 32, 32 )
		NUM4:SetPos( 0+4, 36 )
		NUM4:SetText("4")
		NUM4:SetTextColor( Color( 255, 255, 255, 255 ) )
		NUM4.DoClick = function( button )
			password=password.."4"
		end
		NUM4.Paint = function( self, w, h )
			if self:IsDown() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		local NUM5 = vgui.Create( "DButton", fnafgmSecretD )
		NUM5:SetSize( 32, 32 )
		NUM5:SetPos( 32+4, 36 )
		NUM5:SetText("5")
		NUM5:SetTextColor( Color( 255, 255, 255, 255 ) )
		NUM5.DoClick = function( button )
			password=password.."5"
		end
		NUM5.Paint = function( self, w, h )
			if self:IsDown() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		local NUM6 = vgui.Create( "DButton", fnafgmSecretD )
		NUM6:SetSize( 32, 32 )
		NUM6:SetPos( 64+4, 36 )
		NUM6:SetText("6")
		NUM6:SetTextColor( Color( 255, 255, 255, 255 ) )
		NUM6.DoClick = function( button )
			password=password.."6"
		end
		NUM6.Paint = function( self, w, h )
			if self:IsDown() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		local NUM7 = vgui.Create( "DButton", fnafgmSecretD )
		NUM7:SetSize( 32, 32 )
		NUM7:SetPos( 0+4, 68 )
		NUM7:SetText("7")
		NUM7:SetTextColor( Color( 255, 255, 255, 255 ) )
		NUM7.DoClick = function( button )
			password=password.."7"
		end
		NUM7.Paint = function( self, w, h )
			if self:IsDown() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		local NUM8 = vgui.Create( "DButton", fnafgmSecretD )
		NUM8:SetSize( 32, 32 )
		NUM8:SetPos( 32+4, 68 )
		NUM8:SetText("8")
		NUM8:SetTextColor( Color( 255, 255, 255, 255 ) )
		NUM8.DoClick = function( button )
			password=password.."8"
		end
		NUM8.Paint = function( self, w, h )
			if self:IsDown() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		local NUM9 = vgui.Create( "DButton", fnafgmSecretD )
		NUM9:SetSize( 32, 32 )
		NUM9:SetPos( 64+4, 68 )
		NUM9:SetText("9")
		NUM9:SetTextColor( Color( 255, 255, 255, 255 ) )
		NUM9.DoClick = function( button )
			password=password.."9"
		end
		NUM9.Paint = function( self, w, h )
			if self:IsDown() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		local NUMS = vgui.Create( "DButton", fnafgmSecretD )
		NUMS:SetSize( 32, 32 )
		NUMS:SetPos( 0+4, 100 )
		NUMS:SetText("X")
		NUMS:SetTextColor( Color( 170, 0, 0, 255 ) )
		NUMS.DoClick = function( button )
			fnafgmSecretD:Close()
		end
		NUMS.Paint = function( self, w, h )
			if self:IsDown() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		local NUM0 = vgui.Create( "DButton", fnafgmSecretD )
		NUM0:SetSize( 32, 32 )
		NUM0:SetPos( 32+4, 100 )
		NUM0:SetText("0")
		NUM0:SetTextColor( Color( 255, 255, 255, 255 ) )
		NUM0.DoClick = function( button )
			password=password.."0"
		end
		NUM0.Paint = function( self, w, h )
			if self:IsDown() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		local NUMD = vgui.Create( "DButton", fnafgmSecretD )
		NUMD:SetSize( 32, 32 )
		NUMD:SetPos( 64+4, 100 )
		NUMD:SetText("OK")
		NUMD:SetTextColor( Color( 0, 170, 0, 255 ) )
		NUMD.DoClick = function( button )
			if password=="2015" then
				NUM1:Remove()
				NUM2:Remove()
				NUM3:Remove()
				NUM4:Remove()
				NUM5:Remove()
				NUM6:Remove()
				NUM7:Remove()
				NUM8:Remove()
				NUM9:Remove()
				NUM0:Remove()
				secrete_anim:Start(0.25)
				NUMD:Remove()
				NUMS:SetPos( 352, 0 )
				NUMS:SetZPos(1000)
				local Zed = vgui.Create( "DHTML" )
				Zed:SetParent(fnafgmSecretD)
				Zed:SetPos( 0, 0 )
				Zed:SetSize( 384, 384 )
				Zed:SetAllowLua(true)
				Zed:OpenURL( "www.Xperidia.com/DAT_FACE.html" )
				Zed:SetScrollbars(false)
			else
				password=""
			end
		end
		NUMD.Paint = function( self, w, h )
			if self:IsDown() then
				draw.RoundedBox( 16, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
			end
		end
		
		secrete_anim = Derma_Anim( "secrete_anim", fnafgmSecretD, function( pnl, anim, delta, data )
			pnl:SetSize( 280*delta+104, 248*delta+136 )
			pnl:SetPos( (ScrW()/2-52)-140*delta, (ScrH()/2-68)-124*delta )
		end)
		
	end
	
end