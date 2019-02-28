--[[---------------------------------------------------------

	Five Nights at Freddy's Gamemode for Garry's Mod
			by VictorienXP@Xperidia (2015)

	"Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]

AddCSLuaFile()
DEFINE_BASECLASS("player_fnafgmsecurityguard")

local PLAYER = {}

PLAYER.DisplayName			= "Animatronic Controller"

PLAYER.WalkSpeed 			= 200		-- How fast to move when not running
PLAYER.RunSpeed				= 400		-- How fast to move when running
PLAYER.CrouchedWalkSpeed 	= 0.3		-- Multiply move speed by this when crouching
PLAYER.DuckSpeed			= 0.3		-- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed			= 0.3		-- How fast to go from ducking, to not ducking
PLAYER.JumpPower			= 100		-- How powerful our jump should be
PLAYER.CanUseFlashlight     = false		-- Can we use the flashlight
PLAYER.MaxHealth			= 100		-- Max health we can have
PLAYER.StartHealth			= 100		-- How much health we start with
PLAYER.StartArmor			= 0			-- How much armour we start with
PLAYER.DropWeaponOnDie		= false		-- Do we drop our weapon when we die
PLAYER.TeammateNoCollide 	= true		-- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers			= false		-- Automatically swerves around other players
PLAYER.UseVMHands			= false		-- Uses viewmodel hands

--
-- Creates a Taunt Camera
--
PLAYER.TauntCam = TauntCamera()

--
-- Set up the network table accessors
--
function PLAYER:SetupDataTables()

	BaseClass.SetupDataTables(self)

end


function PLAYER:Loadout()

	self.Player:RemoveAllAmmo()
	self.Player:Give("fnafgm_animatronic_controller")

end



player_manager.RegisterClass("player_fnafgm_animatronic_controller", PLAYER, "player_fnafgmsecurityguard")
