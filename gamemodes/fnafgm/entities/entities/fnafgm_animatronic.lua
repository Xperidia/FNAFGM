AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.PrintName = "Animatronic"
ENT.Author = "Xperidia"

function ENT:Initialize()
	
	self:SetModel( GAMEMODE.Models_freddy )
	
end

--[[function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "AType" )

end]]

--[[function ENT:RunBehaviour()

	while true do
		
		self:StartActivity( ACT_HL2MP_IDLE )
		coroutine.wait( 2 )

		coroutine.yield()
		
	end

end]]
