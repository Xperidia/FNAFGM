AddCSLuaFile()

SWEP.PrintName			= GAMEMODE.Strings.base.animatronic			
SWEP.Author			= "Xperidia"
SWEP.Instructions		= "Click to toggle visibility"
SWEP.Purpose = "Respect the Freddy Fazbear's Pizza rules"
SWEP.Category = "FNAFGM"

SWEP.Spawnable = false

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
SWEP.DrawCrosshair		= false
SWEP.BounceWeaponIcon = false
if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID(GAMEMODE.Materials_animatronic) end

SWEP.ViewModel			= "models/weapons/c_arms.mdl"
SWEP.WorldModel			= ""

function SWEP:Initialize()
	
	self:SetHoldType( "normal" )
	if SERVER then
		util.AddNetworkString( "fnafgmAVisible" )
		if IsValid(self.Owner) then
			avisible[self.Owner] = true
			net.Start( "fnafgmAVisible" )
			net.WriteBit( avisible[self.Owner] )
			net.Send( self.Owner )
		end
		
	end
	
end

function SWEP:PrimaryAttack()
	self:SecondaryAttack()
end
 
function SWEP:SecondaryAttack()
	
	if SERVER then
	
		if avisible[self.Owner] then
			
			self.Owner:SetRenderMode(RENDERMODE_NONE)
			self.Owner:SetWalkSpeed(400)
			self.Owner:SetRunSpeed(400)
			avisible[self.Owner] = false
			
		elseif !avisible[self.Owner] and !CheckPlayerSecurityRoom(self.Owner) then
			
			self.Owner:SetRenderMode(RENDERMODE_NORMAL)
			self.Owner:SetWalkSpeed(0.1)
			self.Owner:SetRunSpeed(0.1)
			avisible[self.Owner] = true
			
		end
		
		net.Start( "fnafgmAVisible" )
		net.WriteBit( avisible[self.Owner] )
		net.Send( self.Owner )
		
	end
	
end

function SWEP:OnRemove()
	
	if SERVER and IsValid(self.Owner) then
		self.Owner:SetRenderMode(RENDERMODE_NORMAL)
		avisible[self.Owner] = true
		net.Start( "fnafgmAVisible" )
		net.WriteBit( avisible[self.Owner] )
		net.Send( self.Owner )
	end
	
end

function SWEP:ShouldDropOnDie()
	return false
end

function SWEP:Think()
	
	if tobool(startday) and SERVER and avisible[self.Owner] then
		
		for k, v in pairs (ents.FindInSphere (self.Owner:GetPos(), 19)) do
			if IsValid(v) and v:IsPlayer() and v:Alive() and v:Health() > 0 and v:Team()==1 then
		
				local attacker = self.Owner
				local anima = "Unknown"
				local sound = GAMEMODE.Sound_xscream
				
				if ( !IsValid( attacker ) ) then attacker = self end
				if player_manager.GetPlayerClass(self.Owner)=="player_fnafgmfreddy" then
					v:ConCommand( "pp_mat_overlay freddys/fazbear_deathscreen" )
					anima = GAMEMODE.Strings.base.freddy
				elseif player_manager.GetPlayerClass(self.Owner)=="player_fnafgmchica" then
					v:ConCommand( "pp_mat_overlay freddys/chicadeath" )
					anima = GAMEMODE.Strings.base.chica
				elseif player_manager.GetPlayerClass(self.Owner)=="player_fnafgmbonnie" then
					v:ConCommand( "pp_mat_overlay freddys/bonniedeath" )
					anima = GAMEMODE.Strings.base.bonnie
				elseif player_manager.GetPlayerClass(self.Owner)=="player_fnafgmgoldenfreddy" then
					v:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_goldenfreddy )
					anima = GAMEMODE.Strings.base.goldenfreddy
					sound = GAMEMODE.Sound_xscream2
				end
				
				self.Owner:PrintMessage(HUD_PRINTTALK, "You hit "..v:GetName())
				v:ConCommand("play "..sound)
				v:TakeDamage(100, attacker, self )
				v:PrintMessage(HUD_PRINTTALK, anima.." ("..self.Owner:GetName()..") killed you!")
				
			end
		end
		
	end
	
end

