include( 'shared.lua' )

SWEP.BounceWeaponIcon = false
SWEP.WepSelectIcon = surface.GetTextureID( "fnafgm/securityscreenremote" )

function fnafcam() 

if !opened then

	opened = true

	local h = 506
	
	surface.PlaySound(GAMEMODE.Sound_securitycampop)
	
	local SecTabInt = vgui.Create( "DFrame" )
	SecTabInt:SetPos( ScrW()/2-172, ScrH()-h-4 )
	SecTabInt:SetSize( 344, h )
	SecTabInt:SetTitle( "" )
	SecTabInt:SetVisible( true )
	SecTabInt:SetDraggable( true )
	SecTabInt:ShowCloseButton( false )
	SecTabInt:SetScreenLock(true)
	SecTabInt:SetPaintShadow(true)
	SecTabInt:SetBackgroundBlur(false)
	SecTabInt:MakePopup()
	SecTabInt.Paint = function( self, w, h )
		draw.RoundedBox( 4, 0, 22, w, h-22, Color( 0, 0, 0, 240 ) )
		draw.RoundedBox( 0, 2, 24, w-4, h-26, Color( 255, 255, 255, 255 ) )
	end
	SecTabInt.OnClose = function()
		opened = false
	end

	
	local CAM2 = vgui.Create( "DButton" )
	CAM2:SetParent(SecTabInt)
	CAM2:SetSize( 170, 60 )
	CAM2:SetPos( 172, 24 )
	CAM2:SetText( "Cam2" )
	CAM2:SetTextColor( Color( 255, 255, 255, 255 ) )
	CAM2:SetFont("FNAFGMTXT")
	CAM2.DoClick = function( button )
		surface.PlaySound(GAMEMODE.Sound_camselect)
		fnafgmSetCamera( 2 )
	end
	CAM2.Paint = function( self, w, h )
		draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 85, 85, 85, 255 ) )
	end
		
		
	local CAM4 = vgui.Create( "DButton" )
	CAM4:SetParent(SecTabInt)
	CAM4:SetSize( 170, 60 )
	CAM4:SetPos( 172, 84 )
	CAM4:SetText( "Cam4" )
	CAM4:SetTextColor( Color( 255, 255, 255, 255 ) )
	CAM4:SetFont("FNAFGMTXT")
	CAM4.DoClick = function( button )
		surface.PlaySound(GAMEMODE.Sound_camselect)
		fnafgmSetCamera( 4 )
	end
	CAM4.Paint = function( self, w, h )
		draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 85, 85, 85, 255 ) )
	end

	local CAM6 = vgui.Create( "DButton" )
	CAM6:SetParent(SecTabInt)
	CAM6:SetSize( 170, 60 )
	CAM6:SetPos( 172, 144 )
	CAM6:SetText( "Cam6" )
	CAM6:SetTextColor( Color( 255, 255, 255, 255 ) )
	CAM6:SetFont("FNAFGMTXT")
	CAM6.DoClick = function( button )
		surface.PlaySound(GAMEMODE.Sound_camselect)
		fnafgmSetCamera( 6 )
	end
	CAM6.Paint = function( self, w, h )
		draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 85, 85, 85, 255 ) )
	end
	
	local CAM8 = vgui.Create( "DButton" )
	CAM8:SetParent(SecTabInt)
	CAM8:SetSize( 170, 60 )
	CAM8:SetPos( 172, 204 )
	CAM8:SetText( "Cam8" )
	CAM8:SetTextColor( Color( 255, 255, 255, 255 ) )
	CAM8:SetFont("FNAFGMTXT")
	CAM8.DoClick = function( button )
		surface.PlaySound(GAMEMODE.Sound_camselect)
		fnafgmSetCamera( 8 )
	end
	CAM8.Paint = function( self, w, h )
		draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 85, 85, 85, 255 ) )
	end

	local CAM10 = vgui.Create( "DButton" )
	CAM10:SetParent(SecTabInt)
	CAM10:SetSize( 170, 60 )
	CAM10:SetPos( 172, 264 )
	CAM10:SetText( "Cam10" )
	CAM10:SetTextColor( Color( 255, 255, 255, 255 ) )
	CAM10:SetFont("FNAFGMTXT")
	CAM10.DoClick = function( button )
		surface.PlaySound(GAMEMODE.Sound_camselect)
		fnafgmSetCamera( 10 )
	end
	CAM10.Paint = function( self, w, h )
		draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 85, 85, 85, 255 ) )
	end

	local CAM12 = vgui.Create( "DButton" )
	CAM12:SetParent(SecTabInt)
	CAM12:SetSize( 170, 60 )
	CAM12:SetPos( 172, 324 )
	CAM12:SetText( "Cam12" )
	CAM12:SetTextColor( Color( 255, 255, 255, 255 ) )
	CAM12:SetFont("FNAFGMTXT")
	CAM12.DoClick = function( button )
		surface.PlaySound(GAMEMODE.Sound_camselect)
		fnafgmSetCamera( 12 )
	end
	CAM12.Paint = function( self, w, h )
		draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 85, 85, 85, 255 ) )
	end
	
	
	local MB = vgui.Create( "DButton" )
	MB:SetParent(SecTabInt)
	MB:SetSize( 170, 60 )
	MB:SetPos( 172, 384 )
	MB:SetText( "Music Box" )
	MB:SetTextColor( Color( 255, 255, 255, 255 ) )
	MB:SetFont("FNAFGMTXT")
	MB.DoClick = function( button )
		surface.PlaySound(GAMEMODE.Sound_camselect)
		fnafgmMusicBox()
	end
	MB.Paint = function( self, w, h )
		draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 85, 85, 85, 255 ) )
	end
		
		
	local CAM1 = vgui.Create( "DButton" )
	CAM1:SetParent(SecTabInt)
	CAM1:SetSize( 170, 60 )
	CAM1:SetPos( 2, 24 )
	CAM1:SetText( "Cam1" )
	CAM1:SetTextColor( Color( 255, 255, 255, 255 ) )
	CAM1:SetFont("FNAFGMTXT")
	CAM1.DoClick = function( button )
		surface.PlaySound(GAMEMODE.Sound_camselect)
		fnafgmSetCamera( 1 )
	end
	CAM1.Paint = function( self, w, h )
		draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 85, 85, 85, 255 ) )
	end
	
	local CAM3 = vgui.Create( "DButton" )
	CAM3:SetParent(SecTabInt)
	CAM3:SetSize( 170, 60 )
	CAM3:SetPos( 2, 84 )
	CAM3:SetText( "Cam3" )
	CAM3:SetTextColor( Color( 255, 255, 255, 255 ) )
	CAM3:SetFont("FNAFGMTXT")
	CAM3.DoClick = function( button )
		surface.PlaySound(GAMEMODE.Sound_camselect)
		fnafgmSetCamera( 3 )
	end
	CAM3.Paint = function( self, w, h )
		draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 85, 85, 85, 255 ) )
	end

	local CAM5 = vgui.Create( "DButton" )
	CAM5:SetParent(SecTabInt)
	CAM5:SetSize( 170, 60 )
	CAM5:SetPos( 2, 144 )
	CAM5:SetText( "Cam5" )
	CAM5:SetTextColor( Color( 255, 255, 255, 255 ) )
	CAM5:SetFont("FNAFGMTXT")
	CAM5.DoClick = function( button )
		surface.PlaySound(GAMEMODE.Sound_camselect)
		fnafgmSetCamera( 5 )
	end
	CAM5.Paint = function( self, w, h )
		draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 85, 85, 85, 255 ) )
	end

	local CAM7 = vgui.Create( "DButton" )
	CAM7:SetParent(SecTabInt)
	CAM7:SetSize( 170, 60 )
	CAM7:SetPos( 2, 204 )
	CAM7:SetText( "Cam7" )
	CAM7:SetTextColor( Color( 255, 255, 255, 255 ) )
	CAM7:SetFont("FNAFGMTXT")
	CAM7.DoClick = function( button )
		surface.PlaySound(GAMEMODE.Sound_camselect)
		fnafgmSetCamera( 7 )
	end
	CAM7.Paint = function( self, w, h )
		draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 85, 85, 85, 255 ) )
	end
		
	local CAM9 = vgui.Create( "DButton" )
	CAM9:SetParent(SecTabInt)
	CAM9:SetSize( 170, 60 )
	CAM9:SetPos( 2, 264 )
	CAM9:SetText( "Cam9" )
	CAM9:SetTextColor( Color( 255, 255, 255, 255 ) )
	CAM9:SetFont("FNAFGMTXT")
	CAM9.DoClick = function( button )
		surface.PlaySound(GAMEMODE.Sound_camselect)
		fnafgmSetCamera( 9 )
	end
	CAM9.Paint = function( self, w, h )
		draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 85, 85, 85, 255 ) )
	end
	
	local CAM11 = vgui.Create( "DButton" )
	CAM11:SetParent(SecTabInt)
	CAM11:SetSize( 170, 60 )
	CAM11:SetPos( 2, 324 )
	CAM11:SetText( "Cam11" )
	CAM11:SetTextColor( Color( 255, 255, 255, 255 ) )
	CAM11:SetFont("FNAFGMTXT")
	CAM11.DoClick = function( button )
		surface.PlaySound(GAMEMODE.Sound_camselect)
		fnafgmSetCamera( 11 )
	end
	CAM11.Paint = function( self, w, h )
		draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 85, 85, 85, 255 ) )
	end
	
	local CAM13 = vgui.Create( "DButton" )
	CAM13:SetParent(SecTabInt)
	CAM13:SetSize( 170, 60 )
	CAM13:SetPos( 2, 384 )
	CAM13:SetText( "Cam13" )
	CAM13:SetTextColor( Color( 255, 255, 255, 255 ) )
	CAM13:SetFont("FNAFGMTXT")
	CAM13.DoClick = function( button )
		surface.PlaySound(GAMEMODE.Sound_camselect)
		fnafgmSetCamera( 13 )
	end
	CAM13.Paint = function( self, w, h )
		draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 85, 85, 85, 255 ) )
	end


	local Close = vgui.Create( "DButton" )
	Close:SetParent(SecTabInt)
	Close:SetSize( 340, 60 )
	Close:SetPos( 2, h-62 )
	Close:SetText( "CLOSE" )
	Close:SetTextColor( Color( 255, 255, 255, 255 ) )
	Close:SetFont("FNAFGMID")
	Close.DoClick = function( button )
		SecTabInt:Close()
		surface.PlaySound(GAMEMODE.Sound_securitycampop)
	end
	Close.Paint = function( self, w, h )
		draw.RoundedBox( 0, 1, 1, w-2, h-2, Color( 85, 85, 85, 255 ) )
	end


end


end


hook.Add( "Think", "fnafgmCloseRemote", function()
	if IsValid(SecTabInt) and !LocalPlayer():Alive() then
		SecTabInt:Close()
	end
end )

usermessage.Hook("fnafcam", fnafcam)

