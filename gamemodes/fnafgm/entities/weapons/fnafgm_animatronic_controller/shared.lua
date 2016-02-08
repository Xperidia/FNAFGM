SWEP.PrintName = "Animatronic controller"
SWEP.Author = "Xperidia"
--SWEP.Instructions = GAMEMODE.Strings.en.
--SWEP.Purpose = GAMEMODE.Strings.en.

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false

SWEP.ViewModelFOV	= 52
SWEP.Slot			= 0
SWEP.SlotPos			= 0
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.BounceWeaponIcon = false

SWEP.ViewModel			= "models/weapons/c_arms.mdl"
SWEP.WorldModel			= ""

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
	if CLIENT then
		--self.PrintName = tostring(GAMEMODE.TranslatedStrings. or GAMEMODE.Strings.en.)
		--self.Instructions = tostring(GAMEMODE.TranslatedStrings. or GAMEMODE.Strings.en.)
		--self.Purpose = tostring(GAMEMODE.TranslatedStrings. or GAMEMODE.Strings.en.)
	end
end

function SWEP:PrimaryAttack()
	
	self:SecondaryAttack()
	
end

function SWEP:SecondaryAttack()
	
	if table.Count(ents.FindByClass( "fnafgm_camera" ))==0 then return end
	
	if SERVER then
		
		net.Start( "fnafgmAnimatronicsController" )
		net.Send(self.Owner)
	
	end
	
end

