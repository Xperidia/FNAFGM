AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "anim"
ENT.PrintName = "FNAFGM Animatronic"
ENT.Author = "Xperidia"

function ENT:AcceptInput( name, activator, caller, data )
	
	if debugmode and IsValid(activator) and IsValid(caller) then print( self:GetName(), name, activator:GetName(), caller:GetName(), data )
	elseif debugmode and IsValid(activator) then print( self:GetName(), name, activator:GetName(), caller, data )
	elseif debugmode and IsValid(caller) then print( self:GetName(), name, activator, caller:GetName(), data )
	elseif debugmode then print( self:GetName(), name, activator, caller, data ) end
	
	if name=="TurnOff" then
		
		self.Disabled = true
		
		self:SetRenderMode(RENDERMODE_NONE)
		
		if debugmode then print(self:GetName().." disabled") end
		
	elseif name=="TurnOn" then
		
		self.Disabled = false
		
		self:SetRenderMode(RENDERMODE_NORMAL)
		
		if debugmode then print(self:GetName().." enabled") end
		
	elseif name=="Kill" then
		
		self:Remove()
		
		if debugmode then print(self:GetName().." removed") end
		
	end
	
	return true
	
end


function ENT:KeyValue(k, v)
	
	if debugmode then print(k, v) end
	
	if k == "Model" then
		
		self.Model = v
		
	end
	
end

function ENT:Initialize()
	
	self:SetModel( self.Model )
	
end

function ENT:Touch( entity )
	
	if !self.Disabled and entity:IsPlayer() and entity:Alive() then
		
		entity:Kill()
		
	end
	
end