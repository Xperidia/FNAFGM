AddCSLuaFile()

ENT.Base = "base_entity"
ENT.PrintName = "FNAFGM KeyPad"
ENT.Author = "Xperidia"
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Initialize()
	
	self:SetModel("models/props_lab/keypad.mdl")
	
	self:SetSolid( SOLID_BBOX )
	
end

function ENT:Use( activator, caller, useType, value )
	
	if IsValid(activator) and activator:IsPlayer() then
		activator:SendLua([[fnafgmSecret()]])
	elseif IsValid(caller) and caller:IsPlayer() then
		caller:SendLua([[fnafgmSecret()]])
	end
	
end

function ENT:Draw()
	
	self:DrawModel()
	
end
