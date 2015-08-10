
AddCSLuaFile()
DEFINE_BASECLASS( "player_fnafgmfreddy" )

local PLAYER = {}

PLAYER.DisplayName			= "Bonnie"

function PLAYER:SetModel()

	BaseClass.SetModel( self )
	
	self.Player:SetModel( GAMEMODE.Models_bonnie )

end


player_manager.RegisterClass( "player_fnafgmbonnie", PLAYER, "player_fnafgmfreddy" )
