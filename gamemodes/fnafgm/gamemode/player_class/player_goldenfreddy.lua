
AddCSLuaFile()
DEFINE_BASECLASS( "player_fnafgmfreddy" )

local PLAYER = {}

PLAYER.DisplayName			= "Golden Freddy"

function PLAYER:SetModel()

	BaseClass.SetModel( self )
	
	self.Player:SetModel( GAMEMODE.Models_goldenfreddy )

end


player_manager.RegisterClass( "player_fnafgmgoldenfreddy", PLAYER, "player_fnafgmfreddy" )
