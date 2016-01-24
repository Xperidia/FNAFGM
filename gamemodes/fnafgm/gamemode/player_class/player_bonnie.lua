
AddCSLuaFile()
DEFINE_BASECLASS( "player_fnafgmfreddy" )

local PLAYER = {}

PLAYER.DisplayName			= "Bonnie"

function PLAYER:SetModel()

	BaseClass.SetModel( self )
	
	if game.GetMap()=="fnaf4versus" and player_manager.AllValidModels()["FNAF4 - Nightmare Bonnie"] then
		GAMEMODE.Models_bonnie = Model("models/nightmare/nightmare_bonnie_playermodel.mdl")
	end
	
	self.Player:SetModel( GAMEMODE.Models_bonnie )

end


player_manager.RegisterClass( "player_fnafgmbonnie", PLAYER, "player_fnafgmfreddy" )
