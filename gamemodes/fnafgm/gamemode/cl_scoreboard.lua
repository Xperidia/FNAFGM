--[[---------------------------------------------------------

	Five Nights at Freddy's Gamemode for Garry's Mod
			by VickyFrenzy@Xperidia (2015-2025)

	"Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]
surface.CreateFont("ScoreboardDefault", {
	font = sfont,
	size = 20,
	weight = 800,
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
})

surface.CreateFont("ScoreboardDefaultTitle", {
	font = "Helvetica",
	size = 32,
	weight = 800
})

--
-- This defines a new panel type for the player row. The player row is given a player
-- and then from that point on it pretty much looks after itself. It updates player info
-- in the think function, and removes itself when the player leaves the server.
--
local cplayerslist = {}
local PLAYER_LINE = {
	Init = function(self)
		self.AvatarButton = self:Add("DButton")
		self.AvatarButton:Dock(LEFT)
		self.AvatarButton:SetSize(32, 32)
		self.AvatarButton.DoClick = function() self.Player:ShowProfile() end
		self.Avatar = vgui.Create("AvatarImage", self.AvatarButton)
		self.Avatar:SetSize(32, 32)
		self.Avatar:SetMouseInputEnabled(false)
		self.FriendStatusI = vgui.Create("DImage", self)
		self.FriendStatusI:SetSize(16, 16)
		self.FriendStatusI:SetPos(28, 22)
		self.FriendStatusI:SetMouseInputEnabled(false)
		self.Name = self:Add("DLabel")
		self.Name:Dock(FILL)
		self.Name:SetFont("ScoreboardDefault")
		self.Name:SetTextColor(Color(255, 255, 255))
		self.Name:DockMargin(8, 0, 0, 0)
		self.Mute = self:Add("DImageButton")
		self.Mute:SetSize(32, 32)
		self.Mute:Dock(RIGHT)
		self.Ping = self:Add("DLabel")
		self.Ping:Dock(RIGHT)
		self.Ping:SetWidth(50)
		self.Ping:SetFont("FNAFGMID")
		self.Ping:SetTextColor(Color(255, 255, 255))
		self.Ping:SetContentAlignment(5)
		self.Kills = self:Add("DLabel")
		self.Kills:Dock(RIGHT)
		self.Kills:SetWidth(50)
		self.Kills:SetFont("FNAFGMID")
		self.Kills:SetTextColor(Color(255, 255, 255))
		self.Kills:SetContentAlignment(5)
		self:Dock(TOP)
		self:DockPadding(3, 3, 3, 3)
		self:SetHeight(32 + 3 * 2)
		self:DockMargin(2, 0, 2, 2)
	end,
	Setup = function(self, pl)
		self.Player = pl
		if not self.Player.Nick then
			self.Player.Nick = function() return self.Player.name end
			self.Player.Team = function() return TEAM_CONNECTING end
			self.Player.EntIndex = function() return self.Player.userid end
			self.Player.Ping = function() return "" end
			self.Player.Frags = function() return "" end
			local steamid = util.SteamIDTo64(self.Player.networkid)
			self.Avatar:SetSteamID(steamid)
			self.Player.ShowProfile = function() gui.OpenURL("http://steamcommunity.com/profiles/" .. steamid .. "/") end
		else
			self.Avatar:SetPlayer(pl)
		end

		self:Think(self)
	end,
	Think = function(self)
		if not IsValid(self.Player) and not istable(self.Player) then
			self:SetZPos(9999) -- Causes a rebuild
			self:Remove()
			return
		end

		if istable(self.Player) and IsValid(self.Player:GetPlayerEnt()) then
			self:SetZPos(9999) -- Causes a rebuild
			self:Remove()
			cplayerslist[self.Player.userid] = nil
			return
		end

		if istable(self.Player) then
			local nope = true
			for id, pl in pairs(player.GetAny()) do
				if pl.userid == self.Player.userid then nope = false end
			end

			if nope then
				self:SetZPos(9999) -- Causes a rebuild
				self:Remove()
				cplayerslist[self.Player.userid] = nil
				return
			end
		end

		if self.PName == nil or self.PName ~= self.Player:Nick() then
			self.PName = self.Player:Nick()
			self.Name:SetText(self.PName)
		end

		self.Name:SetTextColor(team.GetColor(self.Player:Team()))
		if self.NumKills == nil or self.NumKills ~= self.Player:Frags() then
			self.NumKills = self.Player:Frags()
			self.Kills:SetText(self.NumKills)
		end

		if self.NumPing == nil or (self.NumPing ~= self.Player:Ping() and self.NumPing ~= "BOT" and self.NumPing ~= "HOST" and self.NumPing ~= "...") then
			if not IsValid(self.Player) then
				self.NumPing = "..."
				self.Ping:SetText(self.NumPing)
			elseif self.Player:IsBot() then
				self.NumPing = "BOT"
				self.Ping:SetText(self.NumPing)
			elseif self.Player:GetNWBool("IsListenServerHost", false) then
				self.NumPing = "HOST"
				self.Ping:SetText(self.NumPing)
			else
				self.NumPing = self.Player:Ping()
				self.Ping:SetText(self.NumPing)
			end
		end

		--
		-- Change the icon of the mute button based on state
		--
		if IsValid(self.Player) and (self.Muted == nil or self.Muted ~= self.Player:IsMuted()) then
			self.Muted = self.Player:IsMuted()
			if self.Muted then
				self.Mute:SetImage("icon32/muted.png")
			else
				self.Mute:SetImage("icon32/unmuted.png")
			end

			self.Mute.DoClick = function() self.Player:SetMuted(not self.Muted) end
			self.Mute.OnMouseWheeled = function(s, delta)
				self.Player:SetVoiceVolumeScale(self.Player:GetVoiceVolumeScale() + (delta / 100 * 5))
				s.LastTick = CurTime()
			end

			self.Mute.PaintOver = function(s, w, h)
				if not IsValid(self.Player) then return end
				local a = 255 - math.Clamp(CurTime() - (s.LastTick or 0), 0, 3) * 255
				if a <= 0 then return end
				draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, a * 0.75))
				draw.SimpleText(math.ceil(self.Player:GetVoiceVolumeScale() * 100) .. "%", "DermaDefaultBold", w / 2, h / 2, Color(255, 255, 255, a), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end

		if IsValid(self.Player) and (self.FriendStatus == nil or self.FriendStatus ~= self.Player:GetFriendStatus()) then
			self.FriendStatus = self.Player:GetFriendStatus()
			if self.FriendStatus == "friend" then
				self.FriendStatusI:SetImageColor(Color(255, 255, 255, 255))
				self.FriendStatusI:SetImage("icon16/status_offline.png")
			elseif self.FriendStatus == "blocked" then
				self.FriendStatusI:SetImageColor(Color(255, 255, 255, 255))
				self.FriendStatusI:SetImage("icon16/cancel.png")
			elseif self.FriendStatus == "requested" then
				self.FriendStatusI:SetImageColor(Color(255, 255, 255, 255))
				self.FriendStatusI:SetImage("icon16/add.png")
			else
				self.FriendStatusI:SetImageColor(Color(255, 255, 255, 0))
			end
		end

		--
		-- Connecting players go at the very bottom
		--
		if self.Player:Team() == TEAM_CONNECTING then
			self:SetZPos(4000 + self.Player:EntIndex())
			return
		end

		if self.Player:Team() == TEAM_UNASSIGNED then
			self:SetZPos(2000 + self.Player:EntIndex())
			return
		end

		if self.Player:IsAdmin() or GAMEMODE:CheckCreator(self.Player) then
			self:SetZPos(self.Player:EntIndex() - 2000)
			return
		end

		--
		-- This is what sorts the list. The panels are docked in the z order,
		-- so if we set the z order according to kills they'll be ordered that way!
		-- Careful though, it's a signed short internally, so needs to range between -32,768k and +32,767
		--
		self:SetZPos(self.Player:EntIndex())
	end,
	Paint = function(self, w, h)
		if not IsValid(self.Player) and not istable(self.Player) then return end
		if istable(self.Player) and IsValid(self.Player:GetPlayerEnt()) then return end
		--
		-- We draw our background a different colour based on the status of the player
		--
		if self.Player:Team() == TEAM_CONNECTING or self.Player:Team() == TEAM_UNASSIGNED then
			draw.RoundedBox(4, 0, 0, w, h, Color(92, 92, 92, 100))
			return
		end

		if not self.Player:Alive() then
			draw.RoundedBox(4, 0, 0, w, h, Color(128, 0, 0, 128))
			return
		end

		if self.Player:IsAdmin() then
			draw.RoundedBox(4, 0, 0, w, h, Color(170, 0, 0, 255))
			return
		end

		local rankid = self.Player:GetNWInt("XperidiaRank", 0)
		local rankcolor = self.Player:GetNWString("XperidiaRankColor", "200 200 200 255")
		if rankid > 0 then
			draw.RoundedBox(4, 0, 0, w, h, string.ToColor(rankcolor))
			return
		end

		draw.RoundedBox(4, 0, 0, w, h, Color(200, 200, 200, 255))
	end
}

--
-- Convert it from a normal table into a Panel Table based on DPanel
--
PLAYER_LINE = vgui.RegisterTable(PLAYER_LINE, "DPanel")

--
-- Here we define a new panel table for the scoreboard. It basically consists
-- of a header and a scrollpanel - into which the player lines are placed.
--
local SCORE_BOARD = {
	Init = function(self)
		self.Header = self:Add("Panel")
		self.Header:Dock(TOP)
		self.Header:SetHeight(100)
		self.Name = self.Header:Add("DLabel")
		self.Name:SetFont("FNAFGMNIGHT")
		self.Name:SetTextColor(Color(255, 255, 255, 255))
		self.Name:Dock(TOP)
		self.Name:SetHeight(40)
		self.Name:SetContentAlignment(5)
		self.Name:SetExpensiveShadow(2, Color(0, 0, 0, 200))
		self.Info = self.Header:Add("DButton")
		self.Info:SetFont("FNAFGMNIGHT")
		self.Info:SetTextColor(Color(255, 255, 255, 255))
		self.Info:SetPos(0, 35)
		self.Info:SetSize(700, 40)
		self.Info:SetContentAlignment(5)
		self.Info:SetExpensiveShadow(2, Color(0, 0, 0, 200))
		self.Info:SetText(GAMEMODE.Name .. " GM V" .. GAMEMODE.Version)
		self.Info.DoClick = function() fnafgmMenu() end
		self.Info.Paint = function() end
		self.NumPlayers = self.Header:Add("DLabel")
		self.NumPlayers:SetFont("ScoreboardDefault")
		self.NumPlayers:SetTextColor(Color(255, 255, 255, 255))
		self.NumPlayers:SetPos(0, 70)
		self.NumPlayers:SetSize(300, 30)
		self.NumPlayers:SetContentAlignment(4)
		self.Map = self.Header:Add("DButton")
		self.Map:SetFont("ScoreboardDefault")
		self.Map:SetTextColor(Color(255, 255, 255, 255))
		self.Map:SetPos(0, 70)
		self.Map:SetSize(700, 30)
		self.Map:SetContentAlignment(6)
		self.Map.Paint = function() end
		self.Scores = self:Add("DScrollPanel")
		self.Scores:Dock(FILL)
	end,
	PerformLayout = function(self)
		self:SetSize(700, ScrH() - 200)
		self:SetPos(ScrW() / 2 - 350, 100)
	end,
	Paint = function(self, w, h)
		--draw.RoundedBox( 4, 0, 0, w, h, Color( 0, 0, 0, 200 ) )
	end,
	Think = function(self, w, h)
		self.Name:SetText(GetHostName())
		local numplayers = #player.GetAll()
		if player.GetAny then
			local numplayersany = #player.GetAny()
			if numplayers < numplayersany then numplayers = numplayersany end
		end

		self.NumPlayers:SetText(numplayers .. "/" .. game.MaxPlayers())
		self.Map:SetText(game.GetMap())
		if GAMEMODE.MapList[game.GetMap()] then
			self.Map:SetText(GAMEMODE.MapList[game.GetMap()])
			if GAMEMODE.MapListLinks[game.GetMap()] then
				self.Map.DoClick = function()
					gui.OpenURL(GAMEMODE.MapListLinks[game.GetMap()])
				end
			end
		end

		--
		-- Loop through each player, and if one doesn't have a score entry - create it.
		--
		local plyrs = player.GetAll()
		for id, pl in pairs(plyrs) do
			if IsValid(pl.ScoreEntry) then continue end
			pl.ScoreEntry = vgui.CreateFromTable(PLAYER_LINE, pl.ScoreEntry)
			pl.ScoreEntry:Setup(pl)
			self.Scores:AddItem(pl.ScoreEntry)
		end

		if player.GetAny then
			for id, pl in pairs(player.GetAny()) do
				if IsValid(pl:GetPlayerEnt()) then continue end
				if IsValid(pl.ScoreEntry) then continue end
				if cplayerslist[pl.userid] then continue end
				pl.ScoreEntry = vgui.CreateFromTable(PLAYER_LINE, pl.ScoreEntry)
				pl.ScoreEntry:Setup(pl)
				self.Scores:AddItem(pl.ScoreEntry)
				cplayerslist[pl.userid] = true
			end
		end
	end
}

SCORE_BOARD = vgui.RegisterTable(SCORE_BOARD, "EditablePanel")

--[[---------------------------------------------------------
	Name: gamemode:ScoreboardShow( )
	Desc: Sets the scoreboard to visible
-----------------------------------------------------------]]
function GM:ScoreboardShow()
	if not IsValid(g_Scoreboard) then g_Scoreboard = vgui.CreateFromTable(SCORE_BOARD) end
	if IsValid(g_Scoreboard) then
		g_Scoreboard:Show()
		g_Scoreboard:MakePopup()
		g_Scoreboard:SetKeyboardInputEnabled(false)
	end
end

--[[---------------------------------------------------------
	Name: gamemode:ScoreboardHide( )
	Desc: Hides the scoreboard
-----------------------------------------------------------]]
function GM:ScoreboardHide()
	if IsValid(g_Scoreboard) then g_Scoreboard:Hide() end
end

--[[---------------------------------------------------------
	Name: gamemode:HUDDrawScoreBoard( )
	Desc: If you prefer to draw your scoreboard the stupid way (without vgui)
-----------------------------------------------------------]]
function GM:HUDDrawScoreBoard()
end
