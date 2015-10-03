AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "point"
ENT.PrintName = "FNAFGM Logic Case Prob"
ENT.Author = "Xperidia"

function ENT:AcceptInput( name, activator, caller, data )
	
	if debugmode then print( self:GetName(), name, activator, caller, data ) end
	
	if name=="PickRandom" then
		
		local caselol = nil
		
		while caselol==nil do
		
			for k, v in SortedPairsByValue(self.CasesProb) do
				
				local prob = math.Rand(0, 1)
				if debugmode then print(k,v,prob) end
				if prob<tonumber(v) and lastcase!=k then
					caselol=k
				end
				
			end
		
		end
		
		lastcase = caselol
		
		if debugmode then print(caselol) end
		
		self:TriggerOutput(caselol, activator)
		
	end
	
	return true
	
end


function ENT:KeyValue(k, v)
	
	if debugmode then print(k, v) end
	
	if string.Left(k, 6) == "OnCase" then
		
		self:StoreOutput(k, v)
		if !self.Cases then self.Cases = {} end
		table.insert( self.Cases, k )
		
	elseif string.Left(k, 8) == "ProbCase" then
		
		if !self.CasesProb then self.CasesProb = {} end
		self.CasesProb["On"..string.sub(k, 5)] = v
		
	end
	
end