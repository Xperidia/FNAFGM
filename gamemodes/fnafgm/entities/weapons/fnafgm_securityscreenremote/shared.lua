AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

SWEP.PrintName = "Monitor Remote"
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Author = "Xperidia"
SWEP.Instructions = "Right click to open the Monitor Remote. Only in the security room!"
SWEP.Purpose = "Remote control the security screen."
SWEP.Category = "FNAFGM"

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "none"
SWEP.ViewModel = "models/weapons/c_arms.mdl"
SWEP.WorldModel = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

function SWEP:Initialize()
	self:SetWeaponHoldType("normal")
end

function SWEP:PrimaryAttack()
	
end

function SWEP:SecondaryAttack()
	if SERVER and (game.GetMap()=="fnaf_freddypizzaevents") and CheckPlayerSecurityRoom(self.Owner) then
		umsg.Start( "fnafcam", self.Owner ) 
		umsg.End()
	end
end

if SERVER then
	util.AddNetworkString( "fnafgmCamControl" )
	util.AddNetworkString( "fnafgmMusicBox" )
end

net.Receive( "fnafgmCamControl",function(bits,ply)
	local id = net.ReadFloat()
	if (!id) then return end
	fnafgmSetCamera(id)
	
end )


net.Receive( "fnafgmMusicBox",function(bits,ply)
	fnafgmMusicBox()
end )

if CLIENT then
	
	function fnafgmSetCamera( id )
		net.Start( "fnafgmCamControl" )
			net.WriteFloat(id)
		net.SendToServer()
	end

	function fnafgmMusicBox()
		net.Start( "fnafgmMusicBox" )
		net.SendToServer()
	end
	
end
