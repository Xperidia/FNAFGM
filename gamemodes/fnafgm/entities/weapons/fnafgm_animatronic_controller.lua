--[[---------------------------------------------------------

	Five Nights at Freddy's Gamemode for Garry's Mod
			by VickyFrenzy@Xperidia (2015-2025)

	"Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]

AddCSLuaFile()

SWEP.PrintName = "Animatronic controller"
SWEP.Author = "Xperidia"
SWEP.Category = "FNAFGM"

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
SWEP.AdminOnly = true

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID(GAMEMODE.Materials_animatronic) end
function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

function SWEP:PrimaryAttack()
	self:SecondaryAttack()
end

function SWEP:SecondaryAttack()
	if table.Count(ents.FindByClass("fnafgm_camera")) == 0 then return end
	if CLIENT then return end
	net.Start("fnafgmAnimatronicsController")
	net.Send(self:GetOwner())
end
