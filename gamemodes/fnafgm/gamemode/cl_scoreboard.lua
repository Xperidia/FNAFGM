
surface.CreateFont( "ScoreboardDefault", {
	font	= sfont,
	size	= 20,
	weight	= 800,
	blursize = 0, 
	scanlines = 0, 
	antialias = false, 
	underline = false, 
	italic = false, 
	strikeout = false, 
	symbol = false, 
	rotary = false, 
	shadow = true, 
	additive = false, 
	outline = false
} )

surface.CreateFont( "ScoreboardDefaultTitle", {
	font	= "Helvetica",
	size	= 32,
	weight	= 800
} )

--
-- This defines a new panel type for the player row. The player row is given a player
-- and then from that point on it pretty much looks after itself. It updates player info
-- in the think function, and removes itself when the player leaves the server.
--
local PLAYER_LINE = {
	Init = function( self )

		self.AvatarButton = self:Add( "DButton" )
		self.AvatarButton:Dock( LEFT )
		self.AvatarButton:SetSize( 32, 32 )
		self.AvatarButton.DoClick = function() self.Player:ShowProfile() end

		self.Avatar = vgui.Create( "AvatarImage", self.AvatarButton )
		self.Avatar:SetSize( 32, 32 )
		self.Avatar:SetMouseInputEnabled( false )
		
		self.Name = self:Add( "DLabel" )
		self.Name:Dock( FILL )
		self.Name:SetFont( "ScoreboardDefault" )
		self.Name:SetTextColor( Color( 255, 255, 255 ) )
		self.Name:DockMargin( 8, 0, 0, 0 )

		self.Mute = self:Add( "DImageButton" )
		self.Mute:SetSize( 32, 32 )
		self.Mute:Dock( RIGHT )

		self.Ping = self:Add( "DLabel" )
		self.Ping:Dock( RIGHT )
		self.Ping:SetWidth( 50 )
		self.Ping:SetFont( "FNAFGMID" )
		self.Ping:SetTextColor( Color( 255, 255, 255 ) )
		self.Ping:SetContentAlignment( 5 )

		if SGvsA then
			self.Kills = self:Add( "DLabel" )
			self.Kills:Dock( RIGHT )
			self.Kills:SetWidth( 50 )
			self.Kills:SetFont( "FNAFGMID" )
			self.Kills:SetTextColor( Color( 255, 255, 255 ) )
			self.Kills:SetContentAlignment( 5 )
		end

		self:Dock( TOP )
		self:DockPadding( 3, 3, 3, 3 )
		self:SetHeight( 32 + 3 * 2 )
		self:DockMargin( 2, 0, 2, 2 )

	end,

	Setup = function( self, pl )

		self.Player = pl

		self.Avatar:SetPlayer( pl )

		self:Think( self )

		--local friend = self.Player:GetFriendStatus()
		--MsgN( pl, " Friend: ", friend )

	end,

	Think = function( self )

		if ( !IsValid( self.Player ) ) then
			self:SetZPos( 9999 ) -- Causes a rebuild
			self:Remove()
			return
		end
		
		if ( self.PName == nil || self.PName != self.Player:Nick() ) then
			self.PName = self.Player:Nick()
			self.Name:SetText( self.PName )
		end
		
		self.Name:SetTextColor( team.GetColor( self.Player:Team() ) )
		
		if (SGvsA and ( self.NumKills == nil || self.NumKills != self.Player:Frags() ) ) then
			self.NumKills = self.Player:Frags()
			self.Kills:SetText( self.NumKills )
		end

		if ( self.NumPing == nil || self.NumPing != self.Player:Ping() ) then
			if !self.Player:IsBot() then
				self.NumPing = self.Player:Ping()
				self.Ping:SetText( self.NumPing )
			else
				self.NumPing = "BOT"
				self.Ping:SetText( self.NumPing )
			end
		end

		--
		-- Change the icon of the mute button based on state
		--
		if ( self.Muted == nil || self.Muted != self.Player:IsMuted() ) then

			self.Muted = self.Player:IsMuted()
			if ( self.Muted ) then
				self.Mute:SetImage( "icon32/muted.png" )
			else
				self.Mute:SetImage( "icon32/unmuted.png" )
			end

			self.Mute.DoClick = function() self.Player:SetMuted( !self.Muted ) end

		end

		--
		-- Connecting players go at the very bottom
		--
		if ( self.Player:Team() == TEAM_CONNECTING or self.Player:Team() == TEAM_UNASSIGNED ) then
			self:SetZPos( 2000 + self.Player:EntIndex() )
			return
		end
		
		if ( self.Player:IsAdmin() or GAMEMODE:CheckCreator(self.Player) ) then
			self:SetZPos( self.Player:EntIndex() - 2000 )
			return
		end

		--
		-- This is what sorts the list. The panels are docked in the z order,
		-- so if we set the z order according to kills they'll be ordered that way!
		-- Careful though, it's a signed short internally, so needs to range between -32,768k and +32,767
		--
		self:SetZPos( self.Player:EntIndex() )

	end,

	Paint = function( self, w, h )

		if ( !IsValid( self.Player ) ) then
			return
		end

		--
		-- We draw our background a different colour based on the status of the player
		--

		if ( self.Player:Team() == TEAM_CONNECTING or self.Player:Team() == TEAM_UNASSIGNED ) then
			draw.RoundedBox( 4, 0, 0, w, h, Color( 92, 92, 92, 100 ) )
			return
		end

		if ( !self.Player:Alive() ) then
			draw.RoundedBox( 4, 0, 0, w, h, Color( 128, 0, 0, 128 ) )
			return
		end
		
		if ( GAMEMODE:CheckCreator(self.Player) ) then
			draw.RoundedBox( 4, 0, 0, w, h, Color( 85, 255, 255, 255 ) )
			return
		end
		
		if ( GAMEMODE:CheckDerivCreator(self.Player) ) then
			draw.RoundedBox( 4, 0, 0, w, h, Color( 255, 170, 0, 255 ) )
			return
		end

		if ( self.Player:IsAdmin() ) then
			draw.RoundedBox( 4, 0, 0, w, h, Color( 170, 0, 0, 255 ) )
			return
		end

		draw.RoundedBox( 4, 0, 0, w, h, Color( 200, 200, 200, 255 ) )

	end
}

--
-- Convert it from a normal table into a Panel Table based on DPanel
--
PLAYER_LINE = vgui.RegisterTable( PLAYER_LINE, "DPanel" )

--
-- Here we define a new panel table for the scoreboard. It basically consists
-- of a header and a scrollpanel - into which the player lines are placed.
--
local SCORE_BOARD = {
	Init = function( self )

		self.Header = self:Add( "Panel" )
		self.Header:Dock( TOP )
		self.Header:SetHeight( 100 )

		self.Name = self.Header:Add( "DLabel" )
		self.Name:SetFont( "FNAFGMNIGHT" )
		self.Name:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Name:Dock( TOP )
		self.Name:SetHeight( 40 )
		self.Name:SetContentAlignment( 5 )
		self.Name:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )
		
		self.Info = self.Header:Add( "DButton" )
		self.Info:SetFont( "FNAFGMNIGHT" )
		self.Info:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Info:SetPos( 0, 35 )
		self.Info:SetSize( 700, 40 )
		self.Info:SetContentAlignment( 5 )
		self.Info:SetExpensiveShadow( 2, Color( 0, 0, 0, 200 ) )
		self.Info:SetText( GAMEMODE.Name.." GM V"..GAMEMODE.Version )
		self.Info.DoClick = function()
			fnafgmMenu()
		end
		self.Info.Paint = function() end

		self.NumPlayers = self.Header:Add( "DLabel" )
		self.NumPlayers:SetFont( "ScoreboardDefault" )
		self.NumPlayers:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.NumPlayers:SetPos( 0, 70 )
		self.NumPlayers:SetSize( 300, 30 )
		self.NumPlayers:SetContentAlignment( 4 )
		
		self.Map = self.Header:Add( "DButton" )
		self.Map:SetFont( "ScoreboardDefault" )
		self.Map:SetTextColor( Color( 255, 255, 255, 255 ) )
		self.Map:SetPos( 0, 70 )
		self.Map:SetSize( 700, 30 )
		self.Map:SetContentAlignment( 6 )
		self.Map.Paint = function() end

		self.Scores = self:Add( "DScrollPanel" )
		self.Scores:Dock( FILL )

	end,

	PerformLayout = function( self )

		self:SetSize( 700, ScrH() - 200 )
		self:SetPos( ScrW() / 2 - 350, 100 )

	end,

	Paint = function( self, w, h )

		--draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) )

	end,

	Think = function( self, w, h )

		self.Name:SetText( GetHostName() )
		self.NumPlayers:SetText( #player.GetAll().."/"..game.MaxPlayers() )
		self.Map:SetText(game.GetMap())
		if GAMEMODE.MapList[game.GetMap()] then
			self.Map:SetText(GAMEMODE.MapList[game.GetMap()])
			if GAMEMODE.MapListLinks[game.GetMap()] then
				self.Map.DoClick = function()
					gui.OpenURL( GAMEMODE.MapListLinks[game.GetMap()] )
				end
			end
		end

		--
		-- Loop through each player, and if one doesn't have a score entry - create it.
		--
		local plyrs = player.GetAll()
		for id, pl in pairs( plyrs ) do

			if ( IsValid( pl.ScoreEntry ) ) then continue end

			pl.ScoreEntry = vgui.CreateFromTable( PLAYER_LINE, pl.ScoreEntry )
			pl.ScoreEntry:Setup( pl )

			self.Scores:AddItem( pl.ScoreEntry )

		end

	end
}

SCORE_BOARD = vgui.RegisterTable( SCORE_BOARD, "EditablePanel" )

--[[---------------------------------------------------------
	Name: gamemode:ScoreboardShow( )
	Desc: Sets the scoreboard to visible
-----------------------------------------------------------]]
function GM:ScoreboardShow()

	if ( !IsValid( g_Scoreboard ) ) then
		g_Scoreboard = vgui.CreateFromTable( SCORE_BOARD )
	end

	if ( IsValid( g_Scoreboard ) ) then
		g_Scoreboard:Show()
		g_Scoreboard:MakePopup()
		g_Scoreboard:SetKeyboardInputEnabled( false )
	end

end

--[[---------------------------------------------------------
	Name: gamemode:ScoreboardHide( )
	Desc: Hides the scoreboard
-----------------------------------------------------------]]
function GM:ScoreboardHide()

	if ( IsValid( g_Scoreboard ) ) then
		g_Scoreboard:Hide()
	end

end

--[[---------------------------------------------------------
	Name: gamemode:HUDDrawScoreBoard( )
	Desc: If you prefer to draw your scoreboard the stupid way (without vgui)
-----------------------------------------------------------]]
function GM:HUDDrawScoreBoard()
end