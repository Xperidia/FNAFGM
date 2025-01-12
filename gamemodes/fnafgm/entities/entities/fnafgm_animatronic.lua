--[[---------------------------------------------------------

	Five Nights at Freddy's Gamemode for Garry's Mod
			by VickyFrenzy@Xperidia (2015-2025)

	"Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]

AddCSLuaFile()

ENT.Base = "base_nextbot"
ENT.PrintName = "Animatronic"
ENT.Author = "Xperidia"
ENT.DisableDuplicator = true
ENT.DoNotDuplicate = true
ENT.PhysgunDisabled = true

function ENT:ApplyName(me)
	if GAMEMODE.AnimatronicName[me] then return end
	local sName = self:GetAName()
	if not sName or sName == "" then return end
	GAMEMODE.AnimatronicName[me] = sName
end

function ENT:ApplyCD(me)
	if not SERVER then return end
	local sMap = game.GetMap()
	if not GAMEMODE.AnimatronicsCD[me] then GAMEMODE.AnimatronicsCD[me] = {} end
	if not GAMEMODE.AnimatronicsMaxCD[me] then GAMEMODE.AnimatronicsMaxCD[me] = {} end
	if GAMEMODE.AnimatronicsCD[me][sMap] then return end
	if GAMEMODE.AnimatronicsMaxCD[me][sMap] then return end
	GAMEMODE.AnimatronicsCD[me][sMap] = {}
	GAMEMODE.AnimatronicsMaxCD[me][sMap] = {}
	for night, nCD in pairs(self._tCD) do
		GAMEMODE.AnimatronicsCD[me][sMap][night] = nCD
	end
	for night, nCD in pairs(self._tCD) do
		GAMEMODE.AnimatronicsMaxCD[me][sMap][night] = nCD
	end
end

function ENT:Initialize()
	local me = self:GetAType()
	local apos = self:GetAPos()

	self:ApplyName(me)
	if GAMEMODE.Animatronic_Models and GAMEMODE.Animatronic_Models[me]
	and GAMEMODE.Animatronic_Models[me][game.GetMap()] then
		self:SetModel(GAMEMODE.Animatronic_Models[me][game.GetMap()])
	elseif self:GetModel() == "models/error.mdl" then
		GAMEMODE:ErrorLog("Couln't get model for animatronic " .. me)
	end

	self.OldAPos = apos
	if me <= 10 then self:SetModelScale(1.16, 0) end
	self:SetCollisionGroup(COLLISION_GROUP_DEBRIS)
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetHealth(2147483647)
	if apos ~= nil and GAMEMODE.APos and GAMEMODE.APos[game.GetMap()] and apos ~= GAMEMODE.APos[game.GetMap()].Office and apos ~= GAMEMODE.APos[game.GetMap()].SS then
		local camera = ents.FindByName("fnafgm_Cam" .. apos)[1]
		if IsValid(camera) then self:SetEyeTarget(camera:EyePos()) end
	elseif apos ~= nil and GAMEMODE.APos and GAMEMODE.APos[game.GetMap()] and apos == GAMEMODE.APos[game.GetMap()].SS and GAMEMODE.ASSEye[game.GetMap()] then
		self:SetEyeTarget(GAMEMODE.ASSEye[game.GetMap()])
	end

	if SERVER then
		self:SetBloodColor(BLOOD_COLOR_MECH)
		local cd = 0
		local night = GAMEMODE.Vars.night or 0
		self:ApplyCD(me)
		if not GAMEMODE.Vars.startday and GAMEMODE.AnimatronicsCD[me] and GAMEMODE.AnimatronicsCD[me][game.GetMap()] and GAMEMODE.AnimatronicsCD[me][game.GetMap()][night + 1] then
			cd = GAMEMODE.AnimatronicsCD[me][game.GetMap()][night + 1]
		elseif GAMEMODE.AnimatronicsCD[me] and GAMEMODE.AnimatronicsCD[me][game.GetMap()] and GAMEMODE.AnimatronicsCD[me][game.GetMap()][night] then
			cd = GAMEMODE.AnimatronicsCD[me][game.GetMap()][night]
		elseif GAMEMODE.AnimatronicsCD[me] and GAMEMODE.AnimatronicsCD[me][game.GetMap()] and GAMEMODE.AnimatronicsCD[me][game.GetMap()][0] then
			cd = GAMEMODE.AnimatronicsCD[me][game.GetMap()][0]
		else
			GAMEMODE:Log("Missing or incomplete cooldown info for animatronic " .. (((GAMEMODE.AnimatronicName[me] or "undefined") .. " (" .. (me or 0) .. ")") or me or 0) .. "!")
		end

		if GAMEMODE.AnimatronicsSkins[me] and GAMEMODE.AnimatronicsSkins[me][game.GetMap()] and GAMEMODE.AnimatronicsSkins[me][game.GetMap()][apos] then self:SetSkin(GAMEMODE.AnimatronicsSkins[me][game.GetMap()][apos]) end
		if GAMEMODE.AnimatronicsFlex[me] and GAMEMODE.AnimatronicsFlex[me][game.GetMap()] and GAMEMODE.AnimatronicsFlex[me][game.GetMap()][apos] then
			for _, v in pairs(GAMEMODE.AnimatronicsFlex[me][game.GetMap()][apos]) do
				self:SetFlexWeight(v[1], v[2])
			end
		end

		if GAMEMODE.AnimatronicsAnim[me] and GAMEMODE.AnimatronicsAnim[me][game.GetMap()] and GAMEMODE.AnimatronicsAnim[me][game.GetMap()][apos] then
			self:SetSequence(self:LookupSequence(GAMEMODE.AnimatronicsAnim[me][game.GetMap()][apos]))
			self:ResetSequenceInfo()
			self:SetCycle(0)
			self:SetPlaybackRate(1)
		else
			self:SetSequence(self:LookupSequence("Idle_Unarmed"))
			self:ResetSequenceInfo()
			self:SetPlaybackRate(0)
		end

		if not GAMEMODE.Vars.Animatronics then GAMEMODE.Vars.Animatronics = {} end
		GAMEMODE.Vars.Animatronics[me] = {self, apos, cd, 0}
		net.Start("fnafgmAnimatronicsList")
		net.WriteTable(GAMEMODE.Vars.Animatronics)
		net.Broadcast()
	end
end

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "AType")
	self:NetworkVar("Int", 1, "APos")
	self:NetworkVar("String", 1, "AName")
end

local sCD = "cooldown"
local sMCD = "maxcooldown"

function ENT:KeyValue(k, v)
	if debugmode then print(k, v) end
	if k == "AType" then
		self:SetAType(tonumber(v))
	elseif k == "APos" then
		self:SetAPos(tonumber(v))
	elseif k == "model" then
		self:SetModel(v)
	elseif k == "targetname" then
		self:SetAName(v)
	elseif string.Left(k, #sCD) == sCD then
		local night = tonumber(string.Right(k, 1))
		if not self._tCD then self._tCD = {} end
		self._tCD[night] = v
	elseif string.Left(k, #sMCD) == sMCD then
		local night = tonumber(string.Right(k, 1))
		if not self._tMCD then self._tMCD = {} end
		self._tMCD[night] = v
	end
end

function ENT:RunBehaviour()
	self.loco:SetDesiredSpeed(0)
	while true do
		local nope = hook.Call("fnafgmCustomFoxy", nil, self) or false
		if not nope then
			if self:GetAType() == GAMEMODE.Animatronic.Foxy then
				if self.FoxyMove then
					self.FoxyMove = false
					self:SetSequence(self:LookupSequence("sprint_all"))
					self:ResetSequenceInfo()
					self:SetCycle(0)
					self:SetPlaybackRate(1)
					for _, v in pairs(player.GetAll()) do
						if v:Team() ~= TEAM_CONNECTING and v:Team() ~= TEAM_UNASSIGNED then
							v:SendLua([[LocalPlayer():EmitSound("fnafgm_foxystep")]])
						end
					end

					self.loco:SetDesiredSpeed(600)
					self.FoxyMoveState = self:MoveToPos(Vector(-140, -1164, 64), {maxage = 3.5})

					self:Jumpscare()
				end

				if not self.FoxyWillMove and not self.FoxyMove then
					self:SetSequence(self:LookupSequence("Idle_Unarmed"))
					self:ResetSequenceInfo()
					self:SetCycle(0)
					self:SetPlaybackRate(0)
				elseif self.FoxyWillMove then
					self:SetSequence(self:LookupSequence("idle_angry_melee"))
					self:ResetSequenceInfo()
					self:SetCycle(0)
					self:SetPlaybackRate(0)
				end

				if self.FoxyWillMove or self.FoxyMove then
					coroutine.wait(0.1)
				else
					coroutine.wait(1)
				end
			else
				coroutine.wait(120)
			end
		end
	end
end

function ENT:Think()
	local me = self:GetAType()
	local apos = self:GetAPos()
	local nope = hook.Call("fnafgmAnimatronicMove", nil, self, me, apos) or false
	if not nope and apos ~= nil and self.OldAPos ~= apos then
		self:SetColor(Color(255, 255, 255, 0))
		self.OldAPos = apos
		if GAMEMODE.AnimatronicAPos and GAMEMODE.AnimatronicAPos[me] and GAMEMODE.AnimatronicAPos[me][game.GetMap()] and GAMEMODE.AnimatronicAPos[me][game.GetMap()][apos] then
			self:SetPos(GAMEMODE.AnimatronicAPos[me][game.GetMap()][apos][1])
			self:SetAngles(GAMEMODE.AnimatronicAPos[me][game.GetMap()][apos][2])
		end

		self:SetColor(Color(255, 255, 255, 255))
	end

	if SERVER then
		local nope = hook.Call("fnafgmWindowScare", nil, self, me, apos) or false
		if not nope then
			if game.GetMap() == "freddysnoevent" then
				if me == GAMEMODE.Animatronic.Freddy then
					if apos == GAMEMODE.APos.freddysnoevent.Office and GAMEMODE.Vars.LightUse[2] and not self.wsip then
						self:EmitSound("fnafgm_windowscare")
						self.wsip = true
					elseif apos == GAMEMODE.APos.freddysnoevent.Office and not GAMEMODE.Vars.LightUse[2] and self.wsip then
						self.wsip = false
					elseif apos ~= GAMEMODE.APos.freddysnoevent.Office and self.wsip then
						self.wsip = false
					end
				elseif me == GAMEMODE.Animatronic.Bonnie then
					if apos == GAMEMODE.APos.freddysnoevent.Office and GAMEMODE.Vars.LightUse[1] and not self.wsip then
						self:EmitSound("fnafgm_windowscare")
						self.wsip = true
					elseif apos == GAMEMODE.APos.freddysnoevent.Office and not GAMEMODE.Vars.LightUse[1] and self.wsip then
						self.wsip = false
					elseif apos ~= GAMEMODE.APos.freddysnoevent.Office and self.wsip then
						self.wsip = false
					end
				elseif me == GAMEMODE.Animatronic.Chica then
					if apos == GAMEMODE.APos.freddysnoevent.Office and GAMEMODE.Vars.LightUse[2] and not self.wsip then
						self:EmitSound("fnafgm_windowscare")
						self.wsip = true
					elseif apos == GAMEMODE.APos.freddysnoevent.Office and not GAMEMODE.Vars.LightUse[2] and self.wsip then
						self.wsip = false
					elseif apos ~= GAMEMODE.APos.freddysnoevent.Office and self.wsip then
						self.wsip = false
					end
				end
			else
				--Other map stuff here
			end
		end

		local nope = hook.Call("fnafgmFixPos", nil, self, me, apos) or false
		if not nope and me ~= GAMEMODE.Animatronic.Foxy and GAMEMODE.AnimatronicAPos[me]
		and GAMEMODE.AnimatronicAPos[me][game.GetMap()] and GAMEMODE.AnimatronicAPos[me][game.GetMap()][apos]
		and (not GAMEMODE.Vars.poweroff and me ~= GAMEMODE.Animatronic.Freddy) then
			self:SetPos(GAMEMODE.AnimatronicAPos[me][game.GetMap()][apos][1])
		end
	end

	if apos ~= nil and GAMEMODE.APos and GAMEMODE.APos[game.GetMap()] and apos == GAMEMODE.APos[game.GetMap()].Office then
		for _, ply in pairs(player.GetAll()) do
			if (ply:EyePos():Distance(self:EyePos()) <= 300) and ply:Team() == 1 then
				self:SetEyeTarget(ply:EyePos())
				break
			end
		end
	end

	if SERVER and GAMEMODE.Vars and GAMEMODE.Vars.startday then
		for _, v in pairs(ents.FindInSphere(self:GetPos(), 24)) do
			if IsValid(v) and v:IsPlayer() and v:Alive() and v:Team() == 1 then
				local attacker = self
				if not IsValid(attacker) then attacker = self end
				v:SendLua([[GAMEMODE:JumpscareOverlay("]] .. (string.lower(GAMEMODE.ShortName) or "fnafgm") .. "/screamers/" .. game.GetMap() .. "_" .. me .. [[")]])
				v:SendLua([[LocalPlayer():EmitSound("fnafgm_scream")]])
				v:TakeDamage(2147483647, attacker, self)
			end
		end
	end
end

function ENT:Taunt(ply)
	if not GAMEMODE.Vars.startday then return end
	local me = self:GetAType()
	if not GAMEMODE.Vars.Animatronics[me][4] then GAMEMODE.Vars.Animatronics[me][4] = 0 end
	if GAMEMODE.Vars.Animatronics[me][4] <= CurTime() and GAMEMODE.Sound_Animatronic[me] then
		GAMEMODE.Vars.Animatronics[me][4] = CurTime() + 30
		net.Start("fnafgmAnimatronicsList")
		net.WriteTable(GAMEMODE.Vars.Animatronics)
		net.Broadcast()
		net.Start("fnafgmAnimatronicTauntSnd")
		net.WriteInt(me, 5)
		net.Broadcast()
		if IsValid(ply) then
			GAMEMODE:Log(((GAMEMODE.AnimatronicName[me] .. " (" .. (me or 0) .. ")") or me or 0) .. " Taunt by " .. ply:GetName())
		else
			GAMEMODE:Log(((GAMEMODE.AnimatronicName[me] .. " (" .. (me or 0) .. ")") or me or 0) .. " Taunt by console/script", nil, true)
		end
	end
end

function ENT:GoJumpscare()
	local me = self:GetAType()
	local night = GAMEMODE.Vars.night or 0
	local timet = 2.5
	if night == 1 then
		timet = 5.5
	elseif night == 2 then
		timet = 5
	elseif night == 3 then
		timet = 4.5
	elseif night == 4 then
		timet = 4
	elseif night == 5 then
		timet = 3.5
	elseif night == 6 then
		timet = 3
	end

	local nope = hook.Call("fnafgmCustomGoJumpscare", nil, me, self, timet) or false
	if not nope then
		if me == GAMEMODE.Animatronic.Foxy then self.FoxyWillMove = true end
		timer.Create("fnafgmJumpscare" .. me, timet, 1, function()
			local sgdead = true
			for _, v in pairs(player.GetAll()) do
				if v:Alive() and v:Team() == 1 then
					sgdead = false
					break
				end
			end

			if sgdead then
				timer.Remove("fnafgmJumpscare" .. me)
				return
			end

			if GAMEMODE.Vars.startday and me ~= GAMEMODE.Animatronic.Foxy then
				self:Jumpscare()
			elseif GAMEMODE.Vars.startday then
				self:SetPos(Vector(-365, -358, 64))
				self.FoxyWillMove = false
				self.FoxyMove = true
			end

			timer.Remove("fnafgmJumpscare" .. me)
		end)
	end
end

function ENT:Jumpscare()
	local me = self:GetAType()
	if SERVER and GAMEMODE.Vars.startday then
		local nope = hook.Call("fnafgmCustomJumpscare", nil, me, self) or false
		if not nope then
			if me == GAMEMODE.Animatronic.Freddy and not GAMEMODE.Vars.DoorClosed[2] then
				for _, v in pairs(player.GetAll()) do
					if v:Team() == 1 and v:Alive() and v.IsOnSecurityRoom then
						v:SendLua([[GAMEMODE:JumpscareOverlay("fnafgm/screamers/freddysnoevent_0")]])
						v:SendLua([[LocalPlayer():EmitSound("fnafgm_scream")]])
						v:TakeDamage(2147483647, self)
					end
				end

				GAMEMODE:Log("Jumpscared by " .. GAMEMODE.AnimatronicName[me])
			elseif me == GAMEMODE.Animatronic.Bonnie and not GAMEMODE.Vars.DoorClosed[1] then
				for _, v in pairs(player.GetAll()) do
					if v:Team() == 1 and v:Alive() and v.IsOnSecurityRoom then
						v:SendLua([[GAMEMODE:JumpscareOverlay("fnafgm/screamers/freddysnoevent_1")]])
						v:SendLua([[LocalPlayer():EmitSound("fnafgm_scream")]])
						v:TakeDamage(2147483647, self)
					end
				end

				GAMEMODE:Log("Jumpscared by " .. GAMEMODE.AnimatronicName[me])
			elseif me == GAMEMODE.Animatronic.Chica and not GAMEMODE.Vars.DoorClosed[2] then
				for _, v in pairs(player.GetAll()) do
					if v:Team() == 1 and v:Alive() and v.IsOnSecurityRoom then
						v:SendLua([[GAMEMODE:JumpscareOverlay("fnafgm/screamers/freddysnoevent_2")]])
						v:SendLua([[LocalPlayer():EmitSound("fnafgm_scream")]])
						v:TakeDamage(2147483647, self)
					end
				end

				GAMEMODE:Log("Jumpscared by " .. GAMEMODE.AnimatronicName[me])
			elseif me == GAMEMODE.Animatronic.Foxy and (self.FoxyMoveState == "ok" or GAMEMODE:CheckPlayerSecurityRoom(self)) then
				for _, v in pairs(player.GetAll()) do
					if v:Team() == 1 and v:Alive() and v.IsOnSecurityRoom then
						v:SendLua([[LocalPlayer():EmitSound("fnafgm_scream")]])
						v:TakeDamage(2147483647, self)
					end
				end

				GAMEMODE:Log("Jumpscared by " .. GAMEMODE.AnimatronicName[me])
			elseif me == GAMEMODE.Animatronic.Foxy then
				for _, v in pairs(player.GetAll()) do
					if v:Team() ~= TEAM_CONNECTING and v:Team() ~= TEAM_UNASSIGNED then
						v:SendLua([[LocalPlayer():EmitSound("fnafgm_foxyknock")]])
					end
				end

				if not fnafgm_disablepower:GetBool() then
					local foxyknockdoorpena = GAMEMODE.Vars.foxyknockdoorpena or 2
					local addfoxyknockdoorpena = GAMEMODE.Vars.addfoxyknockdoorpena or 4
					GAMEMODE.Vars.power = GAMEMODE.Vars.power - foxyknockdoorpena
					GAMEMODE:Log("Foxy removed " .. foxyknockdoorpena .. "% of the power")
					fnafgmPowerUpdate()
					if foxyknockdoorpena <= 10 then GAMEMODE.Vars.foxyknockdoorpena = foxyknockdoorpena + addfoxyknockdoorpena end
				end
			end

			if me == GAMEMODE.Animatronic.Foxy then
				self:SetColor(Color(255, 255, 255, 0))
				timer.Create("fnafgmFoxyReset", 1, 1, function()
					self:SetPos(GAMEMODE.AnimatronicAPos[me][game.GetMap()][GAMEMODE.APos[game.GetMap()].PC][1])
					self:SetAngles(GAMEMODE.AnimatronicAPos[me][game.GetMap()][GAMEMODE.APos[game.GetMap()].PC][2])
					GAMEMODE:SetAnimatronicPos(nil, me, GAMEMODE.APos[game.GetMap()].PC)
					self:SetColor(Color(255, 255, 255, 255))
					timer.Remove("fnafgmFoxyReset")
				end)
			else
				GAMEMODE:SetAnimatronicPos(nil, me, GAMEMODE.APos[game.GetMap()].SS)
			end
		end
	end
end

function ENT:OnInjured(info)
	info:SetDamage(0)
end

function ENT:CanTool(ply, trace, mode)
	return not GAMEMODE.IsFNAFGMDerived
end

function ENT:CanProperty(ply, property)
	return not GAMEMODE.IsFNAFGMDerived
end
