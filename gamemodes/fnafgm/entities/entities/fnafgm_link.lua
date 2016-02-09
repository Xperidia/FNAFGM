AddCSLuaFile()

ENT.Base = "base_entity"
ENT.Type = "point"
ENT.PrintName = "FNAFGM Link"
ENT.Author = "Xperidia"

function ENT:AcceptInput( name, activator, caller, data )
	
	if debugmode and IsValid(activator) and IsValid(caller) then print( self:GetName(), name, activator:GetName(), caller:GetName(), data )
	elseif debugmode and IsValid(activator) then print( self:GetName(), name, activator:GetName(), caller, data )
	elseif debugmode and IsValid(caller) then print( self:GetName(), name, activator, caller:GetName(), data )
	elseif debugmode then print( self:GetName(), name, activator, caller, data ) end
	
	if name=="FoxyKnockDoor" then
		
		GAMEMODE.Vars.power = GAMEMODE.Vars.power - foxyknockdoorpena
		MsgC( Color( 255, 255, 85 ), "FNAFGM: Foxy removed "..foxyknockdoorpena.."% of the power\n" )
		fnafgmPowerUpdate()
		if foxyknockdoorpena<=12 then foxyknockdoorpena = foxyknockdoorpena + addfoxyknockdoorpena end
		if addfoxyknockdoorpena==4 then
			addfoxyknockdoorpena = 6
		elseif addfoxyknockdoorpena==6 then
			addfoxyknockdoorpena = 4
		end
		
		
	elseif name=="MuteCall" then
		
		GAMEMODE.Vars.mute = true
		fnafgmVarsUpdate()
		timer.Remove( "fnafgmEndCall" )
		
	
	elseif name=="Freddy" then
		
		if GAMEMODE.Vars.poweroff or GAMEMODE.Vars.gameend or GAMEMODE.Vars.nightpassed then return true end
		
		local deathdelay = 4
			
		if GAMEMODE.Vars.night==1 then
			deathdelay = 9
		elseif GAMEMODE.Vars.night==2 then
			deathdelay = 8
		elseif GAMEMODE.Vars.night==3 then
			deathdelay = 7
		elseif GAMEMODE.Vars.night==4 then
			deathdelay = 6
		elseif GAMEMODE.Vars.night==5 then
			deathdelay = 5
		end
		
		ents.FindByName( "FreddyOffice" )[1]:Fire("Enable")
		ents.FindByName( "FreddyOffice" )[1]:Fire("EnableCollision")
		if door2:GetPos()!=Vector(4.000000, -1168.000000, 112.000000) then ents.FindByName( "FreddyDeath" )[1]:Fire("Enable") end
		ents.FindByName( "FreddyDeath" )[1]:Fire("Trigger", "none", deathdelay)
		ents.FindByName( "freddytest" )[1]:Fire("Enable")
		ents.FindByName( "freddytest" )[1]:Fire("Trigger", "none", deathdelay)
		
	
	elseif name=="Bonnie" then
		
		if GAMEMODE.Vars.poweroff or GAMEMODE.Vars.gameend or GAMEMODE.Vars.nightpassed then return true end
		
		local deathdelay = 4
			
		if GAMEMODE.Vars.night==1 then
			deathdelay = 9
		elseif GAMEMODE.Vars.night==2 then
			deathdelay = 8
		elseif GAMEMODE.Vars.night==3 then
			deathdelay = 7
		elseif GAMEMODE.Vars.night==4 then
			deathdelay = 6
		elseif GAMEMODE.Vars.night==5 then
			deathdelay = 5
		end
		
		ents.FindByName( "BonnieOffice" )[1]:Fire("Enable")
		ents.FindByName( "BonnieOffice" )[1]:Fire("EnableCollision")
		if door1:GetPos()!=Vector(-164.000000, -1168.000000, 112.000000) then ents.FindByName( "BonnieDeath" )[1]:Fire("Enable") end
		ents.FindByName( "BonnieDeath" )[1]:Fire("Trigger", "none", deathdelay)
		ents.FindByName( "bonnietest" )[1]:Fire("Enable")
		ents.FindByName( "bonnietest" )[1]:Fire("Trigger", "none", deathdelay)
		
		
	elseif name=="Chica" then
		
		if GAMEMODE.Vars.poweroff or GAMEMODE.Vars.gameend or GAMEMODE.Vars.nightpassed then return true end
		
		local deathdelay = 4
			
		if GAMEMODE.Vars.night==1 then
			deathdelay = 9
		elseif GAMEMODE.Vars.night==2 then
			deathdelay = 8
		elseif GAMEMODE.Vars.night==3 then
			deathdelay = 7
		elseif GAMEMODE.Vars.night==4 then
			deathdelay = 6
		elseif GAMEMODE.Vars.night==5 then
			deathdelay = 5
		end
		
		ents.FindByName( "ChicaOffice" )[1]:Fire("Enable")
		ents.FindByName( "ChicaOffice" )[1]:Fire("EnableCollision")
		if door2:GetPos()!=Vector(4.000000, -1168.000000, 112.000000) then ents.FindByName( "ChicaDeath" )[1]:Fire("Enable") end
		ents.FindByName( "ChicaDeath" )[1]:Fire("Trigger", "none", deathdelay)
		ents.FindByName( "chicatest" )[1]:Fire("Enable")
		ents.FindByName( "chicatest" )[1]:Fire("Trigger", "none", deathdelay)
		
	
	elseif name=="StartNight" then
		
		fnafgmUse(activator, nil, true)
		
	
	elseif name=="LightOn" then
		
		id = tonumber(data) or nil
		
		if id==nil then Error( "FNAFGM Link: NaN\n" ) return true end
		
		LightUse[id] = true
		
	
	elseif name=="LightOff" then
		
		id = tonumber(data) or nil
		
		if id==nil then Error( "FNAFGM Link: NaN\n" ) return true end
		
		LightUse[id] = false
		
	
	elseif name=="DoorClosing" then
		
		id = tonumber(data) or nil
		
		if id==nil then Error( "FNAFGM Link: NaN\n" ) return true end
		
		DoorClosed[id] = true
		
		
	elseif name=="DoorOpen" then
		
		id = tonumber(data) or nil
		
		if id==nil then Error( "FNAFGM Link: NaN\n" ) return true end
		
		DoorClosed[id] = false
		
		
	elseif name=="PlushTrapWin" then
		
		PlushTrapWin=true
	
	elseif name=="Jumpscared" then
		
		MsgC( Color( 255, 255, 85 ), "FNAFGM: Jumpscared by "..tostring(data).."\n" )
		
	end
	
	
	return true
	
end