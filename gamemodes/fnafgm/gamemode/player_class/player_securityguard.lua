
AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )

if ( CLIENT ) then

	CreateConVar( "cl_playercolor", "0.24 0.34 0.41", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The value is a Vector - so between 0-1 - not between 0-255" )
	CreateConVar( "cl_playerskin", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The skin to use, if the model has any" )
	CreateConVar( "cl_playerbodygroups", "0", { FCVAR_ARCHIVE, FCVAR_USERINFO, FCVAR_DONTRECORD }, "The bodygroups to use, if the model has any" )

end

local PLAYER = {}

PLAYER.DisplayName			= "Security guard"

PLAYER.WalkSpeed 			= 200		-- How fast to move when not running
PLAYER.RunSpeed				= 200		-- How fast to move when running
PLAYER.CrouchedWalkSpeed 	= 0.1		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed			= 0.1		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.1		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 0		-- How powerful our jump should be
PLAYER.CanUseFlashlight     = true		-- Can we use the flashlight
PLAYER.MaxHealth			= 10		-- Max health we can have
PLAYER.StartHealth			= 10		-- How much health we start with
PLAYER.StartArmor			= 0			-- How much armour we start with
PLAYER.DropWeaponOnDie		= false		-- Do we drop our weapon when we die
PLAYER.TeammateNoCollide 	= true		-- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers			= false		-- Automatically swerves around other players
PLAYER.UseVMHands			= true		-- Uses viewmodel hands

--
-- Creates a Taunt Camera
--
PLAYER.TauntCam = TauntCamera()

--
-- Set up the network table accessors
--
function PLAYER:SetupDataTables()

	BaseClass.SetupDataTables( self )

end


function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()
	self.Player:Give( "fnafgm_securitytablet" )
	if game.GetMap()=="fnaf_freddypizzaevents" then
		self.Player:Give( "fnafgm_securityscreenremote" )
	end
	
end

function PLAYER:SetModel()

	BaseClass.SetModel( self )
	
	if GetConVarString("fnafgm_playermodel")=="none" then
		
		local models = player_manager.AllValidModels()
		
		if self.Player:GetInfo( "cl_playermodel" )=="none" or !models[self.Player:GetInfo( "cl_playermodel" )] or ( ( self.Player:GetInfo( "cl_playermodel" )=="Splinks_Bonnie" or self.Player:GetInfo( "cl_playermodel" )=="Splinks_Chica" or self.Player:GetInfo( "cl_playermodel" )=="Splinks_Foxy" or self.Player:GetInfo( "cl_playermodel" )=="Splinks_Freddy" or self.Player:GetInfo( "cl_playermodel" )=="Splinks_Golden_Freddy" ) and (!fnafgmcheckcreator(self.Player) or !self.Player:IsAdmin() ) ) then
			
			local playermodels = GAMEMODE.Models_defaultplayermodels
			
			if models["Guard_01"] then -- Use http://steamcommunity.com/sharedfiles/filedetails/?id=169011381 if available
				playermodels = {"Guard_01", "Guard_02", "Guard_03", "Guard_04", "Guard_05", "Guard_06", "Guard_07", "Guard_08", "Guard_09"}
			end
			
			self.Player:SetModel( player_manager.TranslatePlayerModel(table.Random(playermodels)) )
		end
		
		local skin = self.Player:GetInfoNum( "cl_playerskin", 0 )
		self.Player:SetSkin( skin )

		local groups = self.Player:GetInfo( "cl_playerbodygroups" )
		if ( groups == nil ) then groups = "" end
		local groups = string.Explode( " ", groups )
		for k = 0, self.Player:GetNumBodyGroups() - 1 do
			self.Player:SetBodygroup( k, tonumber( groups[ k + 1 ] ) or 0 )
		end
		
	else
		
		local playermodels = {}
		
		playermodels = string.Explode( "|", GetConVarString("fnafgm_playermodel") )
		
		self.Player:SetModel( player_manager.TranslatePlayerModel(table.Random(playermodels)) )
		
		self.Player:SetSkin( GetConVarString("fnafgm_playerskin") )
			
		local groups = self.Player:GetInfo( GetConVarString("fnafgm_playerbodygroups") )
		if ( groups == nil ) then groups = "" end
		local groups = string.Explode( " ", groups )
		for k = 0, self.Player:GetNumBodyGroups() - 1 do
			self.Player:SetBodygroup( k, tonumber( groups[ k + 1 ] ) or 0 )
		end
		
	end

end

--
-- Called when the player spawns
--
function PLAYER:Spawn()

	BaseClass.Spawn( self )
	
	if GetConVarString("fnafgm_playercolor")=="0.24 0.34 0.41" then
		local col = self.Player:GetInfo( "cl_playercolor" )
		self.Player:SetPlayerColor( Vector( col ) )
	else
		self.Player:SetPlayerColor( Vector( GetConVarString("fnafgm_playercolor") ) )
	end
	self.Player:SetModelScale( 1, 0 )
	
	
end

--
-- Return true to draw local (thirdperson) camera - false to prevent - nothing to use default behaviour
--
function PLAYER:ShouldDrawLocal() 

	if ( self.TauntCam:ShouldDrawLocalPlayer( self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow player class to create move
--
function PLAYER:CreateMove( cmd )

	if ( self.TauntCam:CreateMove( cmd, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

end

--
-- Allow changing the player's view
--
function PLAYER:CalcView( view )

	if ( self.TauntCam:CalcView( view, self.Player, self.Player:IsPlayingTaunt() ) ) then return true end

	-- Your stuff here

end

function PLAYER:GetHandsModel()

	-- return { model = "models/weapons/c_arms_cstrike.mdl", skin = 1, body = "0100000" }

	if GetConVarString("fnafgm_playermodel")=="none" then
		local cl_playermodel = self.Player:GetInfo( "cl_playermodel" )
		return player_manager.TranslatePlayerHands( cl_playermodel )
	else
		return player_manager.TranslatePlayerHands( GetConVarString("fnafgm_playermodel") )
	end

end

player_manager.RegisterClass( "player_fnafgmsecurityguard", PLAYER, "player_default" )
