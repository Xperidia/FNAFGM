AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "point"
ENT.PrintName = "FNAFGM Link"
ENT.Author = "Xperidia"

function ENT:AcceptInput( name, activator, caller, data )
	
	--print( name, activator, caller, data )
	
	if name=="FoxyKnockDoor" then
		
		power = power - foxyknockdoorpena
		MsgC( Color( 255, 255, 85 ), "FNAFGM: Foxy removed "..foxyknockdoorpena.."% of the power\n" )
		fnafgmPowerUpdate()
		if foxyknockdoorpena<=12 then foxyknockdoorpena = foxyknockdoorpena + addfoxyknockdoorpena end
		if addfoxyknockdoorpena==4 then
			addfoxyknockdoorpena = 6
		elseif addfoxyknockdoorpena==6 then
			addfoxyknockdoorpena = 4
		end
		
	end
	
	
	if name=="MuteCall" then
		
		mute = true
		fnafgmVarsUpdate()
		timer.Remove( "fnafgmEndCall" )
		
	end
	
	
	if name=="Freddy" then
		
		if poweroff or gameend or nightpassed then return true end
		
		local deathdelay = 4
			
		if night==1 then
			deathdelay = 9
		elseif night==2 then
			deathdelay = 8
		elseif night==3 then
			deathdelay = 7
		elseif night==4 then
			deathdelay = 6
		elseif night==5 then
			deathdelay = 5
		end
		
		ents.FindByName( "FreddyOffice" )[1]:Fire("Enable")
		ents.FindByName( "FreddyOffice" )[1]:Fire("EnableCollision")
		if door2:GetPos()!=Vector(4.000000, -1168.000000, 112.000000) then ents.FindByName( "FreddyDeath" )[1]:Fire("Enable") end
		ents.FindByName( "FreddyDeath" )[1]:Fire("Trigger", "none", deathdelay)
		ents.FindByName( "freddytest" )[1]:Fire("Enable")
		ents.FindByName( "freddytest" )[1]:Fire("Trigger", "none", deathdelay)
		
	end
	
	
	if name=="Bonnie" then
		
		if poweroff or gameend or nightpassed then return true end
		
		local deathdelay = 4
			
		if night==1 then
			deathdelay = 9
		elseif night==2 then
			deathdelay = 8
		elseif night==3 then
			deathdelay = 7
		elseif night==4 then
			deathdelay = 6
		elseif night==5 then
			deathdelay = 5
		end
		
		ents.FindByName( "BonnieOffice" )[1]:Fire("Enable")
		ents.FindByName( "BonnieOffice" )[1]:Fire("EnableCollision")
		if door1:GetPos()!=Vector(-164.000000, -1168.000000, 112.000000) then ents.FindByName( "BonnieDeath" )[1]:Fire("Enable") end
		ents.FindByName( "BonnieDeath" )[1]:Fire("Trigger", "none", deathdelay)
		ents.FindByName( "bonnietest" )[1]:Fire("Enable")
		ents.FindByName( "bonnietest" )[1]:Fire("Trigger", "none", deathdelay)
		
	end
	
	
	if name=="Chica" then
		
		if poweroff or gameend or nightpassed then return true end
		
		local deathdelay = 4
			
		if night==1 then
			deathdelay = 9
		elseif night==2 then
			deathdelay = 8
		elseif night==3 then
			deathdelay = 7
		elseif night==4 then
			deathdelay = 6
		elseif night==5 then
			deathdelay = 5
		end
		
		ents.FindByName( "ChicaOffice" )[1]:Fire("Enable")
		ents.FindByName( "ChicaOffice" )[1]:Fire("EnableCollision")
		if door2:GetPos()!=Vector(4.000000, -1168.000000, 112.000000) then ents.FindByName( "ChicaDeath" )[1]:Fire("Enable") end
		ents.FindByName( "ChicaDeath" )[1]:Fire("Trigger", "none", deathdelay)
		ents.FindByName( "chicatest" )[1]:Fire("Enable")
		ents.FindByName( "chicatest" )[1]:Fire("Trigger", "none", deathdelay)
		
	end
	
	
	if name=="StartNight" then
		
		fnafgmUse(nil, nil, true)
		
	end
	
	
	return true
end