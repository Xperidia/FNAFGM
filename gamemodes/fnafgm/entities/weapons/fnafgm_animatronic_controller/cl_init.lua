include( 'shared.lua' )

SWEP.BounceWeaponIcon = false
SWEP.WepSelectIcon = surface.GetTextureID(GAMEMODE.Materials_animatronic)

net.Receive( "fnafgmAnimatronicsController", function( len )
	GAMEMODE:Monitor(true) 
end)
