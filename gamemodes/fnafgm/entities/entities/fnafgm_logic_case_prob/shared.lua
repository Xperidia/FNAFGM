AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "point"
ENT.PrintName = "FNAFGM Logic Case Prob"
ENT.Author = "Xperidia"

function ENT:AcceptInput( name, activator, caller, data )
	
	print( name, activator, caller, data )
	
	if name=="PickRandom" then
		
		local caselol = "OnCase"..string.format("%02d", math.random( 1, #self.Cases ))
		
		for k, v in SortedPairsByValue(self.CasesProb) do
			local prob = math.Rand(0, 1)
			print(k,v,prob)
			if prob<tonumber(v) then
				caselol=k
			end
		end
		
		self:TriggerOutput(caselol, activator)
		
	end
	
	return true
	
end


function ENT:KeyValue(k, v)
	
	print(k, v)
	
	if string.Left(k, 6) == "OnCase" then
		
		self:StoreOutput(k, v)
		if !self.Cases then self.Cases = {} end
		table.insert( self.Cases, k )
		
	elseif string.Left(k, 8) == "ProbCase" then
		
		if !self.CasesProb then self.CasesProb = {} end
		self.CasesProb["On"..string.sub(k, 5)] = v
		PrintTable(self.CasesProb)
		
	end
	
end