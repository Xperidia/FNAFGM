
AddCSLuaFile()
DEFINE_BASECLASS( "player_fnafgmfreddy" )

local PLAYER = {}

PLAYER.DisplayName			= "Chica"

function PLAYER:SetModel()

	BaseClass.SetModel( self )
	
	if game.GetMap()=="fnaf4versus" and player_manager.AllValidModels()["FNAF4 - Nightmare Chica"] then
		GAMEMODE.Models_chica = Model("models/nightmare/nightmare_chica_playermodel.mdl")
	end
	
	self.Player:SetModel( GAMEMODE.Models_chica )

end


player_manager.RegisterClass( "player_fnafgmchica", PLAYER, "player_fnafgmfreddy" )
