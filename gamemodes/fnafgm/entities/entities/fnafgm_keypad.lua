--[[---------------------------------------------------------

	Five Nights at Freddy's Gamemode for Garry's Mod
			by VictorienXP@Xperidia (2015-2020)

	"Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]

AddCSLuaFile()

ENT.Base = "base_entity"
ENT.PrintName = "FNAFGM KeyPad"
ENT.Author = "Xperidia"
ENT.RenderGroup = RENDERGROUP_OPAQUE
ENT.DisableDuplicator = true
ENT.DoNotDuplicate = true
ENT.PhysgunDisabled = true

function ENT:Initialize()

	self:SetModel("models/props_lab/keypad.mdl")

	self:SetSolid(SOLID_BBOX)

end

function ENT:Use(activator, caller, useType, value)

	self:TriggerOutput("OnPressed", activator or caller)

	local ply
	if (IsValid(activator) and activator:IsPlayer()) then
		ply = activator
	elseif (IsValid(caller) and caller:IsPlayer()) then
		ply = caller
	end

	if ply then
		net.Start("fnafgm_keypad")
			net.WriteEntity(self)
		net.Send(ply)
	end

end

function ENT:PasswordInput(password, ply)

	if password == self:GetPassword() then
		self:TriggerOutput("OnCorrectPassword", ply)
		self:SetSkin(1)
		timer.Create("fnafgm_keypad_skin_reset_" .. self:EntIndex(), 1.6, 1, function() self:SetSkin(0) end)
		self:EmitSound("ui/buttonclickrelease.wav", 120)
	else
		self:TriggerOutput("OnBadPassword", ply)
		self:SetSkin(2)
		timer.Create("fnafgm_keypad_skin_reset_" .. self:EntIndex(), 1.6, 1, function() self:SetSkin(0) end)
		self:EmitSound("buttons/button10.wav", 120)
	end

end

function ENT:KeyValue(k, v)

	if string.Left(k, 2) == "On" then

		self:StoreOutput(k, v)

	elseif k == "Password" then

		self:SetPassword(v)

	end

end

function ENT:SetupDataTables()

	self:NetworkVar("String", 0, "Password", {KeyName = "Password"})

	if SERVER then

		self:SetPassword("0451")

	end

end

function ENT:Draw()

	self:DrawModel()

end

function ENT:CanTool(ply, trace, mode)

	return !GAMEMODE.IsFNAFGMDerived

end

function ENT:CanProperty(ply, property)

	return !GAMEMODE.IsFNAFGMDerived

end
