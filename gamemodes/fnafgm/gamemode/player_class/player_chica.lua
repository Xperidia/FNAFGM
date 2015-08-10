
AddCSLuaFile()
DEFINE_BASECLASS( "player_fnafgmfreddy" )

local PLAYER = {}

PLAYER.DisplayName			= "Chica"

function PLAYER:SetModel()

	BaseClass.SetModel( self )
	
	self.Player:SetModel( GAMEMODE.Models_chica )

end


player_manager.RegisterClass( "player_fnafgmchica", PLAYER, "player_fnafgmfreddy" )
