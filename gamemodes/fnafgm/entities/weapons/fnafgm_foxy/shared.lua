AddCSLuaFile()

SWEP.PrintName			= GAMEMODE.Strings.en.foxy
SWEP.Author			= "Xperidia"
SWEP.Instructions		= "Rush the security room"
SWEP.Purpose = "What is happening in the security room?"
SWEP.Category = "FNAFGM"

SWEP.Base = "fnafgm_animatronic"

if CLIENT then SWEP.WepSelectIcon = surface.GetTextureID(GAMEMODE.Materials_foxy) end

SWEP.ViewModel = "models/weapons/c_arms.mdl"

function SWEP:Initialize()
	
	if CLIENT then
		self.PrintName = tostring(GAMEMODE.TranslatedStrings.foxy or GAMEMODE.Strings.en.foxy)
		--self.Instructions = tostring(GAMEMODE.TranslatedStrings.foxy_inst or GAMEMODE.Strings.en.foxy_inst)
		--self.Purpose = tostring(GAMEMODE.TranslatedStrings.foxy_purp or GAMEMODE.Strings.en.foxy_purp)
	end
	
	if tobool(startday) then
		self:SetHoldType( "melee" )
	else
		self:SetHoldType( "normal" )
	end
	
end

function SWEP:PrimaryAttack()
	
end
 
function SWEP:SecondaryAttack()
	
end

function SWEP:Think()
	
	if tobool(startday) then
	
		self:SetHoldType( "melee" )
		
		if SERVER then
		
			for k, v in pairs (ents.FindInSphere (self.Owner:GetPos(), 19)) do
				if IsValid(v) and v:IsPlayer() and v:Alive() and v:Health() > 0 and v:Team()==1 then
		
					local attacker = self.Owner
					if ( !IsValid( attacker ) ) then attacker = self end
					self.Owner:PrintMessage(HUD_PRINTTALK, "You hit "..v:GetName())
					v:ConCommand("play "..GAMEMODE.Sound_xscream)
					v:TakeDamage(100, attacker, self )
					v:PrintMessage(HUD_PRINTTALK, tostring(GAMEMODE.TranslatedStrings.foxy or GAMEMODE.Strings.en.foxy).." ("..self.Owner:GetName()..") killed you!")
				end
			end
		
		end
		
	else
	
		self:SetHoldType( "normal" )
		
	end
	
end

function SWEP:OnRemove()
	
	
end