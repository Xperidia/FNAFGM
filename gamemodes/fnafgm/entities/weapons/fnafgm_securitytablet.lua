--[[---------------------------------------------------------

	Five Nights at Freddy's Gamemode for Garry's Mod
			by VickyFrenzy@Xperidia (2015-2025)

	"Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]

AddCSLuaFile()

SWEP.PrintName				= GAMEMODE.Strings.en.monitor
SWEP.Author					= "Xperidia"
SWEP.Instructions			= GAMEMODE.Strings.en.monitor_inst
SWEP.Purpose				= GAMEMODE.Strings.en.monitor_purp
SWEP.Category				= "FNAFGM"

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"

SWEP.Weight					= 5
SWEP.AutoSwitchTo			= false
SWEP.AutoSwitchFrom			= false

SWEP.ViewModelFOV			= 52
SWEP.Slot					= 0
SWEP.SlotPos				= 0
SWEP.DrawAmmo				= false
SWEP.DrawCrosshair			= true
SWEP.BounceWeaponIcon		= false

SWEP.ViewModel				= "models/weapons/c_arms.mdl"
SWEP.WorldModel				= ""

SWEP.Spawnable = true

if CLIENT then
	SWEP.WepSelectIcon		= surface.GetTextureID("fnafgm/weapons/securitytablet")
end

local laststate

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
	if SERVER then return end
	self.PrintName = tostring(GAMEMODE.TranslatedStrings.monitor or GAMEMODE.Strings.en.monitor)
	self.Instructions = tostring(GAMEMODE.TranslatedStrings.monitor_inst or GAMEMODE.Strings.en.monitor_inst)
	self.Purpose = tostring(GAMEMODE.TranslatedStrings.monitor_purp or GAMEMODE.Strings.en.monitor_purp)
end

function SWEP:PrimaryAttack()
	if CLIENT then return end
	if GAMEMODE.Vars.poweroff and GAMEMODE.FT ~= 2 then return end
	local tr = util.GetPlayerTrace(self:GetOwner())
	tr.filter = function(ent)
		if ent:GetClass() == "func_button" or ent:GetClass() == "fnafgm_keypad" then
			return true
		end
	end
	local trace = util.TraceLine(tr)
	if not trace.Hit then return end
	if not trace.HitNonWorld then return end
	if IsValid(trace.Entity) and trace.Entity:GetPos():Distance(trace.StartPos) < 200 then
		fnafgmUse(self:GetOwner(), trace.Entity, false, true)
	end
end

function SWEP:SecondaryAttack()
	if CLIENT then return end
	if table.Count(ents.FindByClass("fnafgm_camera")) == 0 then return end
	if self:GetOwner().fnafviewactive then return end
	if GAMEMODE.Vars.poweroff and GAMEMODE.FT ~= 2 then return end
	if GAMEMODE.Vars.tempostart then return end
	if (self:GetOwner().IsOnSecurityRoom and GAMEMODE.Vars.startday) or fnafgmPlayerCanByPass(self:GetOwner(), "tab") then
		net.Start("fnafgmSecurityTablet")
		net.Send(self:GetOwner())
		if fnafgm_smart_power_management:GetBool() then fnafgmShutLights() end
	end
end

function SWEP:Reload()
	if CLIENT then return end
	local pOwner = self:GetOwner()
	if pOwner.fnafviewactive then return end
	if not pOwner.IsOnSecurityRoom then return end
	if not GAMEMODE.Vars.startday then return end
	if GAMEMODE.Vars.tempostart then return end
	GAMEMODE:GoFNaFView(pOwner)
end

function SWEP:Think()
	if SERVER and not self:GetOwner().IsOnSecurityRoom and not fnafgmPlayerCanByPass(self:GetOwner(), "tab") then
		net.Start("fnafgmCloseTablet")
		net.Send(self:GetOwner())
	end

	if CLIENT then
		if IsValid(GAMEMODE.Vars.Monitor) and laststate ~= 1 then
			self:SetHoldType("camera")
			laststate = 1
		elseif not IsValid(GAMEMODE.Vars.Monitor) and laststate ~= 0 then
			self:SetHoldType("normal")
			laststate = 0
		end
	end
end
