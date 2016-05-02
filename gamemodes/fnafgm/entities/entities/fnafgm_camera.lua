AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "point"
ENT.PrintName = "FNAFGM Camera"
ENT.Author = "Xperidia"

function ENT:Initialize()
	
	if SERVER and self:GetCamID()==0 then
		local name = self:GetName()
		local id = tonumber(string.Right( name, #name-10 ))
		if id then
			self:SetCamID(id)
			if GAMEMODE.CamsNames[game.GetMap().."_"..id] then
				GAMEMODE:Log( "Camera init: "..GAMEMODE.CamsNames[game.GetMap().."_"..id].." ("..id..")" )
			else
				GAMEMODE:Log( "Camera init: "..id )
			end
		else
			GAMEMODE:Log( "Camera init: "..name.." (No ID)" )
		end
	end
	
end

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "CamID" )

end