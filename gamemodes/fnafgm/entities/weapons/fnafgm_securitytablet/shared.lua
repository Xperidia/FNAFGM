AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

SWEP.PrintName = GAMEMODE.Strings.base.monitor
SWEP.Slot = 0
SWEP.SlotPos = 0
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false

SWEP.Author = "Xperidia"
SWEP.Instructions = GAMEMODE.Strings.base.monitor_inst
SWEP.Purpose = GAMEMODE.Strings.base.monitor_purp
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
	if CLIENT then
		self.PrintName = GAMEMODE.Strings.base.monitor
		self.Instructions = GAMEMODE.Strings.base.monitor_inst
		self.Purpose = GAMEMODE.Strings.base.monitor_purp
	end
end

function SWEP:PrimaryAttack()
	
	if SERVER and (!poweroff or game.GetMap()=="fnaf2") then
		
		local tr = util.GetPlayerTrace( self.Owner )
		tr.filter = function(ent) if ent:GetClass()=="func_button" then return true end end
		local trace = util.TraceLine( tr )
		
		if (!trace.Hit) then return end
		
		if (!trace.HitNonWorld) then return end
		
		if (IsValid(trace.Entity) and trace.Entity:GetPos():Distance( trace.StartPos )<200) then
			
			fnafgmUse(self.Owner, trace.Entity, false, true)
			
		end
		
	end
	
end

function SWEP:SecondaryAttack()
	
	if table.Count(ents.FindByClass( "fnafgm_camera" ))==0 then return end
	
	if SERVER and !self.Owner.fnafviewactive and ( ( CheckPlayerSecurityRoom(self.Owner) and startday ) or fnafgmPlayerCanByPass(self.Owner,"tab") ) and (!poweroff or game.GetMap()=="fnaf2") and !tempostart then
		
		umsg.Start( "fnafgmSecurityTablet", self.Owner ) 
		umsg.End()
		
		fnafgmShutLights()
	
	end
	
end

function SWEP:Reload()
	
	if SERVER and !self.Owner.fnafviewactive and CheckPlayerSecurityRoom(self.Owner) and startday and !tempostart then
		fnafgmFNaFView(self.Owner)
	end
	
end

function SWEP:Think()
	
	if SERVER and !CheckPlayerSecurityRoom(self.Owner) and !fnafgmPlayerCanByPass(self.Owner,"tab") then
		umsg.Start( "fnafgmCloseTablet", self.Owner ) 
		umsg.End()
	end
	
end
