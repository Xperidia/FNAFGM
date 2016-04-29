AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.PrintName = "Animatronic"
ENT.Author = "Xperidia"

function ENT:Initialize()
	
	if GAMEMODE.Animatronic_Models[self:GetAType()] and GAMEMODE.Animatronic_Models[self:GetAType()][game.GetMap()] then self:SetModel( GAMEMODE.Animatronic_Models[self:GetAType()][game.GetMap()] ) end
	
	self.OldAPos = self:GetAPos()
	
	self:SetModelScale( 1.16, 0 )
	
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	
	self:SetRenderMode( RENDERMODE_TRANSALPHA )
	
	self:SetHealth(2147483647)
	
end

function ENT:SetupDataTables()

	self:NetworkVar( "Int", 0, "AType" )
	self:NetworkVar( "Int", 1, "APos" )

end

function ENT:KeyValue(k, v)
	
	if debugmode then print(k, v) end
	
	if string.Left(k, 5) == "AType" then
		
		self:SetAType(tonumber(string.sub(k, 6)))
		
	elseif string.Left(k, 4) == "APos" then
		
		self:SetAPos(tonumber(string.sub(k, 5)))
		
	end
	
end

function ENT:RunBehaviour()
	
	while true do
		
		if self.FoxyMove then
			self.FoxyMove = false
			self:SetSequence( self:LookupSequence( "sprint_all" ) )
			self:ResetSequenceInfo()
			self:SetCycle(0)
			self:SetPlaybackRate(1)
			for k, v in pairs(player.GetAll()) do
				
				if v:Team()!=TEAM_CONNECTING and v:Team()!=TEAM_UNASSIGNED then
					
					v:ConCommand("play "..GAMEMODE.Sound_foxystep)
					
				end
				
			end
			self.loco:SetDesiredSpeed( 600 )
			self.FoxyMoveState = self:MoveToPos(Vector(-140, -1164, 64),{maxage=4})
			self:Jumpscare()
		end
		
		if !self.FoxyWillMove and !self.FoxyMove then
			self:SetSequence( self:LookupSequence( "Idle_Unarmed" ) )
			self:ResetSequenceInfo()
			self:SetPlaybackRate(0)
		elseif self.FoxyWillMove then
			self:SetSequence( self:LookupSequence( "idle_angry_melee" ) )
			self:ResetSequenceInfo()
			self:SetPlaybackRate(0)
		end
		
		if self.FoxyWillMove or self.FoxyMove then coroutine.wait(0.1) else coroutine.wait(1) end
		
	end

end

function ENT:Think()
	
	local me = self:GetAType()
	local apos = self:GetAPos()
	
	if apos!=nil and self.OldAPos != apos then
		
		self:SetColor( Color( 255, 255, 255, 0 ) )
		
		self.OldAPos = apos
		
		if GAMEMODE.AnimatronicAPos[me] and GAMEMODE.AnimatronicAPos[me][game.GetMap()] and GAMEMODE.AnimatronicAPos[me][game.GetMap()][apos] then
			self:SetPos(GAMEMODE.AnimatronicAPos[me][game.GetMap()][apos][1])
			self:SetAngles(GAMEMODE.AnimatronicAPos[me][game.GetMap()][apos][2])
		end
		
		self:SetColor( Color( 255, 255, 255, 255 ) )
		
	end
	
	if apos!=nil and apos == GAMEMODE.APos[game.GetMap()].Office then
		
		for _, ply in pairs( player.GetAll() ) do
			
			if ( ply:EyePos():Distance( self:EyePos() ) <= 300 ) and ply:Team()==1 then
				
				self:SetEyeTarget( ply:EyePos() )
				break
				
			end
			
		end
		
	end
	
	if SERVER and GAMEMODE.Vars.startday then
		
		for k, v in pairs (ents.FindInSphere (self:GetPos(), 24)) do
			if IsValid(v) and v:IsPlayer() and v:Alive() and v:Team()==1 then
				
				local attacker = self
				local sound = GAMEMODE.Sound_xscream
				
				if ( !IsValid( attacker ) ) then attacker = self end
				
				if file.Exists( "materials/"..GAMEMODE.ShortName.."/screamers/"..game.GetMap()..me, "GAME" ) then v:ConCommand( "pp_mat_overlay "..GAMEMODE.ShortName.."/screamers/"..game.GetMap()..me ) end
				
				if me==GAMEMODE.Animatronic.GoldenFreddy then
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
			GAMEMODE:Log(((GAMEMODE.AnimatronicName[me].." ("..(me or 0)..")") or me or 0).." Taunt by "..ply:GetName())
		else
			GAMEMODE:Log(((GAMEMODE.AnimatronicName[me].." ("..(me or 0)..")") or me or 0).." Taunt by console/script")
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
	
	if me==GAMEMODE.Animatronic.Foxy then
		self.FoxyWillMove = true
	end
	
	timer.Create( "fnafgmJumpscare"..me, timet, 1, function()
		if GAMEMODE.Vars.startday and me!=GAMEMODE.Animatronic.Foxy then
			self:Jumpscare()
		elseif GAMEMODE.Vars.startday then
			self:SetPos(Vector(-365,-358,64))
			self.FoxyWillMove = false
			self.FoxyMove = true
		end
		
		timer.Remove( "fnafgmJumpscare"..me )
		
	end)
	
end

function ENT:Jumpscare()
	
	local me = self:GetAType()
	
	if SERVER and GAMEMODE.Vars.startday then
		
		if me==GAMEMODE.Animatronic.Freddy and !GAMEMODE.Vars.DoorClosed[2] then
			
			for k, v in pairs(player.GetAll()) do
				
				if v:Team()==1 and v:Alive() and GAMEMODE:CheckPlayerSecurityRoom(v) then
					
					v:ConCommand( "pp_mat_overlay freddys/fazbear_deathscreen" )
					v:ConCommand("play "..GAMEMODE.Sound_xscream)
					v:TakeDamage(100, self )
					
				end
				
			end
			
			GAMEMODE:Log("Jumpscared by "..GAMEMODE.AnimatronicName[me])
			
		elseif me==GAMEMODE.Animatronic.Bonnie and !GAMEMODE.Vars.DoorClosed[1] then
			
			for k, v in pairs(player.GetAll()) do
				
				if v:Team()==1 and v:Alive() and GAMEMODE:CheckPlayerSecurityRoom(v) then
					
					v:ConCommand( "pp_mat_overlay freddys/bonniedeath" )
					v:ConCommand("play "..GAMEMODE.Sound_xscream)
					v:TakeDamage(100, self )
					
				end
				
			end
			
			GAMEMODE:Log("Jumpscared by "..GAMEMODE.AnimatronicName[me])
			
		elseif me==GAMEMODE.Animatronic.Chica and !GAMEMODE.Vars.DoorClosed[2] then
			
			for k, v in pairs(player.GetAll()) do
				
				if v:Team()==1 and v:Alive() and GAMEMODE:CheckPlayerSecurityRoom(v) then
					
					v:ConCommand( "pp_mat_overlay freddys/chicadeath" )
					v:ConCommand("play "..GAMEMODE.Sound_xscream)
					v:TakeDamage(100, self )
					
				end
				
			end
			
			GAMEMODE:Log("Jumpscared by "..GAMEMODE.AnimatronicName[me])
			
		elseif me==GAMEMODE.Animatronic.Foxy and ( self.FoxyMoveState=="ok" or GAMEMODE:CheckPlayerSecurityRoom(self) ) then
			
			for k, v in pairs(player.GetAll()) do
				
				if v:Team()==1 and v:Alive() and GAMEMODE:CheckPlayerSecurityRoom(v) then
					
					v:ConCommand("play "..GAMEMODE.Sound_xscream)
					v:TakeDamage(100, self )
					
				end
				
			end
			
			GAMEMODE:Log("Jumpscared by "..GAMEMODE.AnimatronicName[me])
			
		elseif me==GAMEMODE.Animatronic.Foxy then
			
			for k, v in pairs(player.GetAll()) do
				
				if v:Team()!=TEAM_CONNECTING and v:Team()!=TEAM_UNASSIGNED then
					
					v:ConCommand("play "..GAMEMODE.Sound_foxyknock)
					
				end
				
			end
			
			GAMEMODE.Vars.power = GAMEMODE.Vars.power - GAMEMODE.Vars.foxyknockdoorpena
			GAMEMODE:Log("Foxy removed "..GAMEMODE.Vars.foxyknockdoorpena.."% of the power")
			fnafgmPowerUpdate()
			if GAMEMODE.Vars.foxyknockdoorpena<=12 then GAMEMODE.Vars.foxyknockdoorpena = GAMEMODE.Vars.foxyknockdoorpena + GAMEMODE.Vars.addfoxyknockdoorpena end
			if GAMEMODE.Vars.addfoxyknockdoorpena==4 then
				GAMEMODE.Vars.addfoxyknockdoorpena = 6
			elseif GAMEMODE.Vars.addfoxyknockdoorpena==6 then
				GAMEMODE.Vars.addfoxyknockdoorpena = 4
			end
			
		end
		
		if me==GAMEMODE.Animatronic.Foxy then
			
			self:SetColor( Color( 255, 255, 255, 0 ) )
			
			timer.Create( "fnafgmFoxyReset", 1, 1, function()
				self:SetPos(GAMEMODE.AnimatronicAPos[me][game.GetMap()][GAMEMODE.APos[game.GetMap()].PC][1])
				self:SetAngles(GAMEMODE.AnimatronicAPos[me][game.GetMap()][GAMEMODE.APos[game.GetMap()].PC][2])
				GAMEMODE:SetAnimatronicPos(nil,me,GAMEMODE.APos[game.GetMap()].PC)
				self:SetColor( Color( 255, 255, 255, 255 ) )
				timer.Remove( "fnafgmFoxyReset" )
			end)
		else
			GAMEMODE:SetAnimatronicPos(nil,me,GAMEMODE.APos[game.GetMap()].SS)
		end
		
	end
	
end

