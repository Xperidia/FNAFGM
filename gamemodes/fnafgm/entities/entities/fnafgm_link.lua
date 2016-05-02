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
		
		GAMEMODE.Vars.power = GAMEMODE.Vars.power - GAMEMODE.Vars.foxyknockdoorpena
		GAMEMODE:Log("Foxy removed "..GAMEMODE.Vars.foxyknockdoorpena.."% of the power")
		fnafgmPowerUpdate()
		if GAMEMODE.Vars.foxyknockdoorpena<=12 then GAMEMODE.Vars.foxyknockdoorpena = GAMEMODE.Vars.foxyknockdoorpena + GAMEMODE.Vars.addfoxyknockdoorpena end
		if GAMEMODE.Vars.addfoxyknockdoorpena==4 then
			GAMEMODE.Vars.addfoxyknockdoorpena = 6
		elseif GAMEMODE.Vars.addfoxyknockdoorpena==6 then
			GAMEMODE.Vars.addfoxyknockdoorpena = 4
		end
		
	elseif name=="MuteCall" then
		
		GAMEMODE.Vars.mute = true
		fnafgmVarsUpdate()
		timer.Remove( "fnafgmEndCall" )
		
	elseif name=="StartNight" then
		
		GAMEMODE:StartNight(activator)
		
	elseif name=="LightOn" then
		
		local id = tonumber(data) or nil
		
		if id==nil then Error( "FNAFGM Link: NaN\n" ) return true end
		
		GAMEMODE.Vars.LightUse[id] = true
		
	elseif name=="LightOff" then
		
		local id = tonumber(data) or nil
		
		if id==nil then Error( "FNAFGM Link: NaN\n" ) return true end
		
		GAMEMODE.Vars.LightUse[id] = false
		
	elseif name=="DoorClosing" then
		
		local id = tonumber(data) or nil
		
		if id==nil then Error( "FNAFGM Link: NaN\n" ) return true end
		
		GAMEMODE.Vars.DoorClosed[id] = true
		
		GAMEMODE:Log("Door "..id.." closing")
		
	elseif name=="DoorOpen" then
		
		local id = tonumber(data) or nil
		
		if id==nil then Error( "FNAFGM Link: NaN\n" ) return true end
		
		GAMEMODE.Vars.DoorClosed[id] = false
		
		GAMEMODE:Log("Door "..id.." opened")
		
	elseif name=="Jumpscared" then
		
		GAMEMODE:Log("Jumpscared by "..tostring(data))
		
	end
	
	return true
	
end