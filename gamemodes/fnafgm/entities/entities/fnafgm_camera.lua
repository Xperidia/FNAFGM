--[[---------------------------------------------------------

	Five Nights at Freddy's Gamemode for Garry's Mod
			by VickyFrenzy@Xperidia (2015-2025)

	"Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]

AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "point"
ENT.PrintName = "FNAFGM Camera"
ENT.Author = "Xperidia"
ENT.DisableDuplicator = true
ENT.DoNotDuplicate = true
ENT.PhysgunDisabled = true

function ENT:SetupCamName(sCam)
	if GAMEMODE.CamsNames[sCam] then return end
	local sLocName = self:GetLocName()
	if not sLocName or sLocName == "" then return end
	GAMEMODE.CamsNames[sCam] = sLocName
end

function ENT:SetupPosName()
	local sMap = game.GetMap()
	if not GAMEMODE.APos[sMap] then GAMEMODE.APos[sMap] = {} end
	local sLocName = self:GetLocName()
	if GAMEMODE.APos[sMap][sLocName] then return end
	if not sLocName or sLocName == "" then return end
	GAMEMODE.APos[sMap][sLocName] = self:GetCamID()
end

function ENT:SetupLocName(sCam)
	self:SetupCamName(sCam)
	self:SetupPosName()
end

function ENT:Initialize()
	if CLIENT then return end
	if self:GetCamID() ~= 0 then return end
	local name = self:GetName()
	local id = tonumber(string.Right(name, #name - 10))
	if id then
		self:SetCamID(id)
		local sCam = game.GetMap() .. "_" .. id
		self:SetupLocName(sCam)
		if GAMEMODE.CamsNames[sCam] then
			GAMEMODE:Log("Camera init: " .. GAMEMODE.CamsNames[sCam] .. " (" .. id .. ")", nil, true)
		else
			GAMEMODE:Log("Camera init: " .. id, nil, true)
		end
	else
		GAMEMODE:Log("Camera init: " .. name .. " (No ID)", nil, true)
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "CamID")
	self:NetworkVar("Bool", 0, "LightState")
	self:NetworkVar("String", 0, "LocName")
end

function ENT:KeyValue(k, v)
	if debugmode then print(k, v) end
	if string.Left(k, 2) == "On" then
		self:StoreOutput(k, v)
	elseif k == "locname" then
		self:SetLocName(v)
	end
end

function ENT:Light()
	self:SwitchLight(not self:GetLightState())
end

function ENT:SwitchLight(rstate)
	if rstate == self:GetLightState() then return end

	if not rstate then
		SafeRemoveEntity(self.flashlight)
		SafeRemoveEntity(self.flare)
		self.flashlight = nil
		self.flare = nil
		self:SetLightState(false)
		return
	end

	self:SetLightState(true)
	self.flashlight = ents.Create("env_projectedtexture")
	self.flashlight:SetParent(self.Entity)
	self.flashlight:SetLocalPos(Vector(0, 0, 0))
	self.flashlight:SetLocalAngles(Angle(0, 0, 0))
	self.flashlight:SetKeyValue("enableshadows", 1)
	self.flashlight:SetKeyValue("shadowquality", 1)
	self.flashlight:SetKeyValue("farz", 750)
	self.flashlight:SetKeyValue("nearz", 4)
	self.flashlight:SetKeyValue("lightfov", 75)
	self.flashlight:Spawn()
	self.flashlight:Input("SpotlightTexture", NULL, NULL, "effects/flashlight/soft")
end

function ENT:CanTool(ply, trace, mode)
	return not GAMEMODE.IsFNAFGMDerived
end

function ENT:CanProperty(ply, property)
	return not GAMEMODE.IsFNAFGMDerived
end
