AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.PrintName = "Animatronic"
ENT.Author = "Xperidia"

function ENT:Initialize()
	
	self:SetModel( GAMEMODE.Animatronic_Models[self:GetAType()] )
	
	self.OldAPos = self:GetAPos()
	
end

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "AType" )
	self:NetworkVar( "Int", 1, "APos" )

end

function ENT:RunBehaviour()
	
	--while true do
		
		self:StartActivity( ACT_HL2MP_IDLE )
		
	--end

end

function ENT:Think()
	
	local apos = self:GetAPos()
	
	if self.OldAPos != apos  then
		
		local my = self:GetAType()
		
		self.OldAPos = apos
		
		if GAMEMODE.AnimatronicAPos[my] and GAMEMODE.AnimatronicAPos[my][game.GetMap()] and GAMEMODE.AnimatronicAPos[my][game.GetMap()][apos] then
			self:SetPos(GAMEMODE.AnimatronicAPos[my][game.GetMap()][apos][1])
			self:SetAngles(GAMEMODE.AnimatronicAPos[my][game.GetMap()][apos][2])
		end
		
		
	end
	
	if apos == GAMEMODE.APos.freddysnoevent.Office then
		
		for _, ply in pairs( player.GetAll() ) do
			
			if ( ply:EyePos():Distance( self:EyePos() ) <= 300 ) and ply:Team()==1 then
				
				self:SetEyeTarget( ply:EyePos() )
				break
				
			end
			
		end
		
	end
	
end

function ENT:Taunt()
	
	if !GAMEMODE.Vars.startday then return end
	
	local me = self:GetAType()
	
	if !GAMEMODE.Vars.Animatronics[me][4] then
		GAMEMODE.Vars.Animatronics[me][4] = 0
	end
	
	if GAMEMODE.Vars.Animatronics[me][4]<=CurTime() and GAMEMODE.Sound_Animatronic[me] then
		
		GAMEMODE.Vars.Animatronics[me][4] = CurTime() + 20
		
		net.Start( "fnafgmAnimatronicsList" )
			net.WriteTable(GAMEMODE.Vars.Animatronics)
		net.Broadcast()
		
		net.Start( "fnafgmAnimatronicTauntSnd" )
			net.WriteInt( me, 5 )
		net.Broadcast()
	
	end
	
end