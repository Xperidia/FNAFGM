--[[---------------------------------------------------------

	Five Nights at Freddy's Gamemode for Garry's Mod
			by VickyFrenzy@Xperidia (2025)

	"Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]

AddCSLuaFile()

ENT.Base		= "base_entity"
ENT.Type		= "point"
ENT.PrintName	= "Animatronic location point"
ENT.Author		= "Xperidia"
ENT.DisableDuplicator = true
ENT.DoNotDuplicate = true
ENT.PhysgunDisabled = true

function ENT:SetupAPos(sMap, nSelf, nApos)
	if not GAMEMODE.AnimatronicAPos[nSelf] then
		GAMEMODE.AnimatronicAPos[nSelf] = {}
	end
	if not GAMEMODE.AnimatronicAPos[nSelf][sMap] then
		GAMEMODE.AnimatronicAPos[nSelf][sMap] = {}
	end
	GAMEMODE.AnimatronicAPos[nSelf][sMap][nApos] = {self:GetPos(), self:GetAngles()}
end

function ENT:SetupSkin(sMap, nSelf, nApos)
	local nSkin = self:GetSkinVal()
	if not nSkin or nSkin == 0 then return end
	if not GAMEMODE.AnimatronicsSkins[nSelf] then
		GAMEMODE.AnimatronicsSkins[nSelf] = {}
	end
	if not GAMEMODE.AnimatronicsSkins[nSelf][sMap] then
		GAMEMODE.AnimatronicsSkins[nSelf][sMap] = {}
	end
	GAMEMODE.AnimatronicsSkins[nSelf][sMap][nApos] = nSkin
end

function ENT:SetupFlexes(sMap, nSelf, nApos)
	local sFlexes = self:GetFlexes()
	if not sFlexes or sFlexes == "" then return end
	if not GAMEMODE.AnimatronicsFlex[nSelf] then
		GAMEMODE.AnimatronicsFlex[nSelf] = {}
	end
	if not GAMEMODE.AnimatronicsFlex[nSelf][sMap] then
		GAMEMODE.AnimatronicsFlex[nSelf][sMap] = {}
	end
	local tFlexes = string.Explode("|", sFlexes)
	if #tFlexes == 0 then return end
	for k, tFlex in pairs(tFlexes) do
		tFlexes[k] = string.Explode(":", tFlex)
	end
	GAMEMODE.AnimatronicsFlex[nSelf][sMap][nApos] = tFlexes
end

function ENT:SetupAnim(sMap, nSelf, nApos)
	local sAnim = self:GetAnimVal()
	if not sAnim or sAnim == "" then return end
	if not GAMEMODE.AnimatronicsAnim[nSelf] then
		GAMEMODE.AnimatronicsAnim[nSelf] = {}
	end
	if not GAMEMODE.AnimatronicsAnim[nSelf][sMap] then
		GAMEMODE.AnimatronicsAnim[nSelf][sMap] = {}
	end
	GAMEMODE.AnimatronicsAnim[nSelf][sMap][nApos] = sAnim
end

function ENT:SetupAllTheData(...)
	self:SetupAPos(...)
	self:SetupSkin(...)
	self:SetupFlexes(...)
	self:SetupAnim(...)
end

function ENT:Initialize()
	local sMap = game.GetMap()
	local nSelf = self:GetAType()
	local nApos = self:GetAPos()

	self:SetupAllTheData(sMap, nSelf, nApos)

	if CLIENT then return end
	hook.Add("fnafgmAnimatronicMoved", tostring(self:MapCreationID()), function(nAType, nNewAPos, nOldAPos)
		if not IsValid(self) then return end
		if nSelf ~= nAType then return end
		if nApos ~= nNewAPos then
			if nApos ~= nOldAPos then return end
			self:TriggerOutput("OnAnimatronicLeft")
			return
		end
		self:TriggerOutput("OnAnimatronicEntered")
	end)
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "AType")
	self:NetworkVar("Int", 1, "APos")
	self:NetworkVar("Int", 2, "SkinVal")
	self:NetworkVar("String", 0, "Flexes")
	self:NetworkVar("String", 1, "AnimVal")
end

function ENT:AcceptInput(name, activator, caller, data)
	if name == "MoveHere" then
		GAMEMODE:SetAnimatronicPos(nil, self:GetAType(), self:GetAPos())
		return true
	end
	return false
end

function ENT:KeyValue(k, v)
	if debugmode then print(k, v) end
	if string.Left(k, 2) == "On" then
		self:StoreOutput(k, v)
	elseif k == "AType" then
		self:SetAType(tonumber(v))
	elseif k == "APos" then
		self:SetAPos(tonumber(v))
	elseif k == "skin" then
		self:SetSkinVal(tonumber(v))
	elseif k == "flexes" then
		self:SetFlexes(v)
	elseif k == "animation" then
		self:SetAnimVal(v)
	end
end

function ENT:OnInjured(info)
	info:SetDamage(0)
end

function ENT:CanTool(ply, trace, mode)
	return not GAMEMODE.IsFNAFGMDerived
end

function ENT:CanProperty(ply, property)
	return not GAMEMODE.IsFNAFGMDerived
end
