function fnafgmSecret()
	
	if !IsValid(fnafgmSecretD) and !engine.IsPlayingDemo() then
		
		fnafgmSecretD = vgui.Create( "DFrame" )
		fnafgmSecretD:SetPos( ScrW()/2-52, ScrH()/2-78 )
		fnafgmSecretD:SetSize( 104, 156 )
		fnafgmSecretD:SetTitle("")
		fnafgmSecretD:SetVisible(true)
		fnafgmSecretD:SetDraggable(true)
		fnafgmSecretD:ShowCloseButton(true)
		fnafgmSecretD:SetScreenLock(true)
		fnafgmSecretD.Paint = function( self, w, h )
			draw.RoundedBox( 4, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
		end
		fnafgmSecretD:MakePopup()
		
		local NUM1 = vgui.Create( "DButton", fnafgmSecretD )
		NUM1:SetSize( 32, 32 )
		NUM1:SetPos( 0+4, 24 )
		NUM1:SetText("1")
		NUM1.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
		end
		
		local NUM2 = vgui.Create( "DButton", fnafgmSecretD )
		NUM2:SetSize( 32, 32 )
		NUM2:SetPos( 32+4, 24 )
		NUM2:SetText("2")
		NUM2.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
		end
		
		local NUM3 = vgui.Create( "DButton", fnafgmSecretD )
		NUM3:SetSize( 32, 32 )
		NUM3:SetPos( 64+4, 24 )
		NUM3:SetText("3")
		NUM3.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
		end
		
		local NUM4 = vgui.Create( "DButton", fnafgmSecretD )
		NUM4:SetSize( 32, 32 )
		NUM4:SetPos( 0+4, 56 )
		NUM4:SetText("4")
		NUM4.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
		end
		
		local NUM5 = vgui.Create( "DButton", fnafgmSecretD )
		NUM5:SetSize( 32, 32 )
		NUM5:SetPos( 32+4, 56 )
		NUM5:SetText("5")
		NUM5.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
		end
		
		local NUM6 = vgui.Create( "DButton", fnafgmSecretD )
		NUM6:SetSize( 32, 32 )
		NUM6:SetPos( 64+4, 56 )
		NUM6:SetText("6")
		NUM6.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
		end
		
		local NUM7 = vgui.Create( "DButton", fnafgmSecretD )
		NUM7:SetSize( 32, 32 )
		NUM7:SetPos( 0+4, 88 )
		NUM7:SetText("7")
		NUM7.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
		end
		
		local NUM8 = vgui.Create( "DButton", fnafgmSecretD )
		NUM8:SetSize( 32, 32 )
		NUM8:SetPos( 32+4, 88 )
		NUM8:SetText("8")
		NUM8.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
		end
		
		local NUM9 = vgui.Create( "DButton", fnafgmSecretD )
		NUM9:SetSize( 32, 32 )
		NUM9:SetPos( 64+4, 88 )
		NUM9:SetText("9")
		NUM9.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
		end
		
		local NUMS = vgui.Create( "DButton", fnafgmSecretD )
		NUMS:SetSize( 32, 32 )
		NUMS:SetPos( 0+4, 120 )
		NUMS:SetText("*")
		NUMS.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
		end
		
		local NUM0 = vgui.Create( "DButton", fnafgmSecretD )
		NUM0:SetSize( 32, 32 )
		NUM0:SetPos( 32+4, 120 )
		NUM0:SetText("0")
		NUM0.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
		end
		
		local NUMD = vgui.Create( "DButton", fnafgmSecretD )
		NUMD:SetSize( 32, 32 )
		NUMD:SetPos( 64+4, 120 )
		NUMD:SetText("#")
		NUMD.Paint = function( self, w, h )
			draw.RoundedBox( 0, 0, 0, w, h, Color( 128, 128, 128, 255 ) )
		end
		
	end
	
end