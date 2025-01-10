--[[---------------------------------------------------------

	Five Nights at Freddy's Gamemode for Garry's Mod
			by VickyFrenzy@Xperidia (2015-2025)

	"Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]

AddCSLuaFile()

ENT.Base		= "base_entity"
ENT.Type		= "point"
ENT.PrintName	= "FNAFGM Link"
ENT.Author		= "Xperidia"
ENT.DisableDuplicator = true
ENT.DoNotDuplicate = true
ENT.PhysgunDisabled = true

function ENT:AcceptInput(name, activator, caller, data)
	if name == "FoxyKnockDoor" then
		if fnafgm_disablepower:GetBool() then return end
		GAMEMODE.Vars.power = GAMEMODE.Vars.power - GAMEMODE.Vars.foxyknockdoorpena
		GAMEMODE:Log("Foxy removed " .. GAMEMODE.Vars.foxyknockdoorpena .. "% of the power")
		fnafgmPowerUpdate()
		if GAMEMODE.Vars.foxyknockdoorpena <= 12 then
			GAMEMODE.Vars.foxyknockdoorpena = GAMEMODE.Vars.foxyknockdoorpena + GAMEMODE.Vars.addfoxyknockdoorpena
		end
		if GAMEMODE.Vars.addfoxyknockdoorpena == 4 then
			GAMEMODE.Vars.addfoxyknockdoorpena = 6
		elseif GAMEMODE.Vars.addfoxyknockdoorpena == 6 then
			GAMEMODE.Vars.addfoxyknockdoorpena = 4
		end
	elseif name == "MuteCall" then
		GAMEMODE.Vars.mute = true
		fnafgmVarsUpdate()
		timer.Remove("fnafgmEndCall")
	elseif name == "StartNight" then
		GAMEMODE:StartNight(activator)
	elseif name == "LightOn" then
		local id = tonumber(data) or nil
		if id == nil then Error("FNAFGM Link: NaN\n") return true end

		GAMEMODE.Vars.LightUse[id] = true
	elseif name == "LightOff" then
		local id = tonumber(data) or nil
		if id == nil then Error("FNAFGM Link: NaN\n") return true end

		GAMEMODE.Vars.LightUse[id] = false
	elseif name == "DoorClosing" then
		local id = tonumber(data) or nil
		if id == nil then Error("FNAFGM Link: NaN\n") return true end

		GAMEMODE.Vars.DoorClosed[id] = true
		GAMEMODE:Log("Door " .. id .. " closing")
	elseif name == "DoorOpen" then
		local id = tonumber(data) or nil
		if id == nil then Error("FNAFGM Link: NaN\n") return true end

		GAMEMODE.Vars.DoorClosed[id] = false
		GAMEMODE:Log("Door " .. id .. " opened")
	elseif name == "Jumpscared" then
		GAMEMODE:Log("Jumpscared by " .. tostring(data))
	elseif name == "ChangeLastCam" then
		for k, v in pairs(player.GetAll()) do
			if v:Team() ~= TEAM_CONNECTING and v:Team() ~= TEAM_UNASSIGNED and v:Alive() then
				net.Start("fnafgmCloseTablet")
				net.Send(v)
				v:SendLua("GAMEMODE.Vars.lastcam=" .. tonumber(data))
			end
		end
	end
	return true
end

function ENT:KeyValue(k, v)
	if string.Left(k, 2) == "On" then self:StoreOutput(k, v) end
end

function ENT:CanTool(ply, trace, mode)
	return not GAMEMODE.IsFNAFGMDerived
end

function ENT:CanProperty(ply, property)
	return not GAMEMODE.IsFNAFGMDerived
end
