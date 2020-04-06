--[[---------------------------------------------------------

	Five Nights at Freddy's Gamemode for Garry's Mod
			by VictorienXP@Xperidia (2015-2020)

	"Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]

AddCSLuaFile()

ENT.Base		= "base_entity"
ENT.Type		= "point"
ENT.PrintName	= "FNAFGM Logic Case Prob"
ENT.Author		= "Xperidia"
ENT.DisableDuplicator = true
ENT.DoNotDuplicate = true
ENT.PhysgunDisabled = true

function ENT:AcceptInput(name, activator, caller, data)

	if name == "PickRandom" then

		if self.Disabled then return true end

		local caselol = nil

		while caselol == nil do

			for k, v in SortedPairsByValue(self.CasesProb) do

				local prob = math.Rand(0, 1)
				if debugmode then print(k, v, prob) end
				if prob < tonumber(v) and lastcase != k then
					caselol = k
				end

			end

		end

		lastcase = caselol

		if debugmode then print(caselol) end

		self:TriggerOutput(caselol, activator)

	elseif name == "Disable" then

		self.Disabled = true

		if debugmode then print(self:GetName() .. " disabled") end

	elseif name == "Enable" then

		self.Disabled = false

		if debugmode then print(self:GetName() .. " enabled") end

	elseif name == "Kill" then

		self:Remove()

		if debugmode then print(self:GetName() .. " removed") end

	elseif name == "Move" then

		local zedata = string.Explode(" ", data)

		local move_ent = ents.FindByName(zedata[1])[1]
		local dummy_ent = ents.FindByName(zedata[2])[1]

		if move_ent:IsValid() and dummy_ent:IsValid() then

			move_ent:SetPos(dummy_ent:GetPos())
			move_ent:SetAngles(dummy_ent:GetAngles())

		end

	end

	return true

end


function ENT:KeyValue(k, v)

	if debugmode then print(k, v) end

	if string.Left(k, 6) == "OnCase" then

		self:StoreOutput(k, v)
		if !self.Cases then self.Cases = {} end
		table.insert(self.Cases, k)

	elseif string.Left(k, 8) == "ProbCase" then

		if !self.CasesProb then self.CasesProb = {} end
		self.CasesProb["On" .. string.sub(k, 5)] = v

	end

end
