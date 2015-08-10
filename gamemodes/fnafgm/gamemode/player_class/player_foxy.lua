
AddCSLuaFile()
DEFINE_BASECLASS( "player_default" )

local PLAYER = {}

PLAYER.DisplayName			= "Foxy"

PLAYER.WalkSpeed 			= 512		-- How fast to move when not running
PLAYER.RunSpeed				= 512		-- How fast to move when running
PLAYER.CrouchedWalkSpeed 	= 1		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed			= 0.05		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.05		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 0		-- How powerful our jump should be
PLAYER.CanUseFlashlight     = true		-- Can we use the flashlight
PLAYER.MaxHealth			= 255		-- Max health we can have
PLAYER.StartHealth			= 255		-- How much health we start with
PLAYER.StartArmor			= 255			-- How much armour we start with
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
	self.Player:Give( "fnafgm_foxy" )

end

function PLAYER:SetModel()

	BaseClass.SetModel( self )
	
	self.Player:SetModel( GAMEMODE.Models_foxy )

end

--
-- Called when the player spawns
--
function PLAYER:Spawn()

	BaseClass.Spawn( self )
	self.Player:SetModelScale( 1.16, 0 )

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

end


player_manager.RegisterClass( "player_fnafgmfoxy", PLAYER, "player_default" )
