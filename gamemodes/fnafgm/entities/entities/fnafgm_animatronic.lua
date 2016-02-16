AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.PrintName = "Animatronic"
ENT.Author = "Xperidia"

function ENT:Initialize()
	
	self:SetModel( GAMEMODE.Animatronic_Models[self:GetAType()] )
	
	self.OldAPos = self:GetAPos()
	
	self:SetModelScale( 1.16, 0 )
	
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
	
	local me = self:GetAType()
	local apos = self:GetAPos()
	
	if self.OldAPos != apos then
		
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
	
	if SERVER and GAMEMODE.Vars.startday then
		
		for k, v in pairs (ents.FindInSphere (self:GetPos(), 19)) do
			if IsValid(v) and v:IsPlayer() and v:Alive() and v:Team()==1 then
				
				local attacker = self
				local anima = "Unknown"
				local sound = GAMEMODE.Sound_xscream
				
				if ( !IsValid( attacker ) ) then attacker = self end
				if me==GAMEMODE.Animatronic.Freddy then
					v:ConCommand( "pp_mat_overlay freddys/fazbear_deathscreen" )
					anima = tostring(GAMEMODE.TranslatedStrings.freddy or GAMEMODE.Strings.en.freddy)
				elseif me==GAMEMODE.Animatronic.Chica then
					v:ConCommand( "pp_mat_overlay freddys/chicadeath" )
					anima = tostring(GAMEMODE.TranslatedStrings.chica or GAMEMODE.Strings.en.chica)
				elseif me==GAMEMODE.Animatronic.Bonnie then
					v:ConCommand( "pp_mat_overlay freddys/bonniedeath" )
					anima = tostring(GAMEMODE.TranslatedStrings.bonnie or GAMEMODE.Strings.en.bonnie)
				elseif me==GAMEMODE.Animatronic.Foxy then
					anima = tostring(GAMEMODE.TranslatedStrings.foxy or GAMEMODE.Strings.en.foxy)
				elseif me==GAMEMODE.Animatronic.GoldenFreddy then
					v:ConCommand( "pp_mat_overlay "..GAMEMODE.Materials_goldenfreddy )
					anima = tostring(GAMEMODE.TranslatedStrings.goldenfreddy or GAMEMODE.Strings.en.goldenfreddy)
					sound = GAMEMODE.Sound_xscream2
				end
				
				v:ConCommand("play "..sound)
				v:TakeDamage(100, attacker, self )
				
			end
		end
		
	end
	
end

function ENT:Taunt(ply)
	
	if !GAMEMODE.Vars.startday then return end
	
	local me = self:GetAType()
	
	if !GAMEMODE.Vars.Animatronics[me][4] then
		GAMEMODE.Vars.Animatronics[me][4] = 0
	end
	
	if GAMEMODE.Vars.Animatronics[me][4]<=CurTime() and GAMEMODE.Sound_Animatronic[me] then
		
		GAMEMODE.Vars.Animatronics[me][4] = CurTime() + 30
		
		net.Start( "fnafgmAnimatronicsList" )
			net.WriteTable(GAMEMODE.Vars.Animatronics)
		net.Broadcast()
		
		net.Start( "fnafgmAnimatronicTauntSnd" )
			net.WriteInt( me, 5 )
		net.Broadcast()
		
		if IsValid(ply) then
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Taunt "..me.." by "..ply:GetName().."\n" )
		else
			MsgC( Color( 255, 255, 85 ), "FNAFGM: Taunt "..me.." by console/script\n" )
		end
	
	end
	
end

function ENT:GoJumpscare()
	
	local me = self:GetAType()
	
	local timet=2.5
	if GAMEMODE.Vars.night==1 then
		timet=5.5
	elseif GAMEMODE.Vars.night==2 then
		timet=5
	elseif GAMEMODE.Vars.night==3 then
		timet=4.5
	elseif GAMEMODE.Vars.night==4 then
		timet=4
	elseif GAMEMODE.Vars.night==5 then
		timet=3.5
	elseif GAMEMODE.Vars.night==6 then
		timet=3
	end
	
	timer.Create( "fnafgmJumpscare"..me, timet, 1, function()
		
		if me!=GAMEMODE.Animatronic.Foxy then self:Jumpscare() end
		
		timer.Remove( "fnafgmJumpscare"..me )
		
	end)
	
end

function ENT:Jumpscare()
	
	local me = self:GetAType()
	
	if SERVER and GAMEMODE.Vars.startday then
		
		if me==GAMEMODE.Animatronic.Freddy and door2:GetPos()!=Vector(4.000000, -1168.000000, 112.000000) then
			
			for k, v in pairs(player.GetAll()) do
				
				if v:Team()==1 and v:Alive() and GAMEMODE:CheckPlayerSecurityRoom(v) then
					
					v:ConCommand( "pp_mat_overlay freddys/fazbear_deathscreen" )
					v:ConCommand("play "..GAMEMODE.Sound_xscream)
					v:TakeDamage(100, self )
					
				end
				
			end
			
		elseif me==GAMEMODE.Animatronic.Bonnie and door1:GetPos()!=Vector(-164.000000, -1168.000000, 112.000000) then
			
			for k, v in pairs(player.GetAll()) do
				
				if v:Team()==1 and v:Alive() and GAMEMODE:CheckPlayerSecurityRoom(v) then
					
					v:ConCommand( "pp_mat_overlay freddys/bonniedeath" )
					v:ConCommand("play "..GAMEMODE.Sound_xscream)
					v:TakeDamage(100, self )
					
				end
				
			end
			
		elseif me==GAMEMODE.Animatronic.Chica and door2:GetPos()!=Vector(4.000000, -1168.000000, 112.000000) then
			
			for k, v in pairs(player.GetAll()) do
				
				if v:Team()==1 and v:Alive() and GAMEMODE:CheckPlayerSecurityRoom(v) then
					
					v:ConCommand( "pp_mat_overlay freddys/chicadeath" )
					v:ConCommand("play "..GAMEMODE.Sound_xscream)
					v:TakeDamage(100, self )
					
				end
				
			end
			
		elseif me==GAMEMODE.Animatronic.Foxy and door1:GetPos()!=Vector(-164.000000, -1168.000000, 112.000000) then
			
			for k, v in pairs(player.GetAll()) do
				
				if v:Team()==1 and v:Alive() and GAMEMODE:CheckPlayerSecurityRoom(v) then
					
					v:ConCommand("play "..GAMEMODE.Sound_xscream)
					v:TakeDamage(100, self )
					
				end
				
			end
			
		end
		
		if me==GAMEMODE.Animatronic.Foxy then
			GAMEMODE:SetAnimatronicPos(nil,me,GAMEMODE.APos.freddysnoevent.PC)
		else
			GAMEMODE:SetAnimatronicPos(nil,me,GAMEMODE.APos.freddysnoevent.SS)
		end
		
	end
	
end
