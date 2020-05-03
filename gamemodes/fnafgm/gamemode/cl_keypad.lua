--[[---------------------------------------------------------

	Five Nights at Freddy's Gamemode for Garry's Mod
			by VictorienXP@Xperidia (2015-2020)

	"Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]

net.Receive("fnafgm_keypad", function(len)
	GAMEMODE:KeyPad(net.ReadEntity())
end)

local passwords = {

	["2015"] = {
		func = function()
			if GAMEMODE.KeyPadFrame.btn then
				for k, v in pairs(GAMEMODE.KeyPadFrame.btn) do
					if IsValid(v) then
						v:Remove()
					end
				end
			end
			GAMEMODE.KeyPadFrame.Passlbl:Remove()
			GAMEMODE.KeyPadFrame.back:Remove()
			secrete_anim:Start(0.25)
			GAMEMODE.KeyPadFrame.okbtn:Remove()
			GAMEMODE.KeyPadFrame.closebtn:SetPos(352, 0)
			GAMEMODE.KeyPadFrame.closebtn:SetZPos(1000)
			local Zed = vgui.Create("DHTML", GAMEMODE.KeyPadFrame)
			Zed:SetPos(0, 0)
			Zed:SetSize(384, 384)
			Zed:SetAllowLua(true)
			Zed:OpenURL("www.Xperidia.com/DAT_FACE.html")
			Zed:SetScrollbars(false)
			return ""
		end
	},

	["847466"] = {
		func = function()
			GAMEMODE.Vars.Cheat.VISION = !GAMEMODE.Vars.Cheat.VISION
			if GAMEMODE.Vars.Cheat.VISION then
				GAMEMODE.KeyPadFrame.Passlbl:SetText("VISION I")
				return true
			else
				GAMEMODE.KeyPadFrame.Passlbl:SetText("VISION O")
				return false
			end
		end
	},

}

function GM:KeyPad(ent)

	if !IsValid(self.KeyPadFrame) and !engine.IsPlayingDemo() then

		local password = ""
		local nope = false

		local nkeys =	{
							[0] = {KEY_0, KEY_PAD_0},
							[1] = {KEY_1, KEY_PAD_1},
							[2] = {KEY_2, KEY_PAD_2},
							[3] = {KEY_3, KEY_PAD_3},
							[4] = {KEY_4, KEY_PAD_4},
							[5] = {KEY_5, KEY_PAD_5},
							[6] = {KEY_6, KEY_PAD_6},
							[7] = {KEY_7, KEY_PAD_7},
							[8] = {KEY_8, KEY_PAD_8},
							[9] = {KEY_9, KEY_PAD_9},
							["X"] = {KEY_ESCAPE},
							["OK"] = {KEY_ENTER, KEY_PAD_ENTER}
						}

		self.KeyPadFrame = vgui.Create("DFrame")
		self.KeyPadFrame:SetPos(ScrW() / 2 - 52, ScrH() / 2 - 74)
		self.KeyPadFrame:SetSize(104, 148)
		self.KeyPadFrame:SetTitle("")
		self.KeyPadFrame:SetVisible(true)
		self.KeyPadFrame:ShowCloseButton(false)
		self.KeyPadFrame:SetScreenLock(true)
		self.KeyPadFrame.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(64, 64, 64, 255))
		end
		self.KeyPadFrame.Think = function(self)

			if secrete_anim:Active() then secrete_anim:Run() end

			if GAMEMODE.KeyPadFrame.btn then
				for k, v in pairs(GAMEMODE.KeyPadFrame.btn) do
					if IsValid(v) and (nkeys[k] and ((nkeys[k][1] and input.IsKeyDown(nkeys[k][1])) or (nkeys[k][2] and input.IsKeyDown(nkeys[k][2])))) then
						if !nope then v.DoClick() end
						nope = true
						return
					end
				end
			end

			if IsValid(GAMEMODE.KeyPadFrame.okbtn) and (input.IsKeyDown(KEY_ENTER) or input.IsKeyDown(KEY_PAD_ENTER)) then
				if !nope then GAMEMODE.KeyPadFrame.okbtn.DoClick() end
				nope = true
				return
			end

			if input.IsKeyDown(KEY_ESCAPE) then
				GAMEMODE.KeyPadFrame:Close()
			end

			nope = false

		end
		self.KeyPadFrame:MakePopup()
		fnafgmSecretD = self.KeyPadFrame

		self.KeyPadFrame.btn = {}

		self.KeyPadFrame.back = vgui.Create("DPanel", self.KeyPadFrame)
		self.KeyPadFrame.back:SetSize(50, 16)
		self.KeyPadFrame.back:SetPos(27, 0)
		self.KeyPadFrame.back.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 255))
		end

		self.KeyPadFrame.Passlbl = vgui.Create("DLabel", self.KeyPadFrame)
		self.KeyPadFrame.Passlbl:SetText("")
		self.KeyPadFrame.Passlbl:SetPos(2, 0)
		self.KeyPadFrame.Passlbl:SetSize(100, 16)
		self.KeyPadFrame.Passlbl:SetTextColor(Color(255, 255, 255, 255))
		self.KeyPadFrame.Passlbl:SetContentAlignment(5)

		local function CreateNum(n, x, y)

			self.KeyPadFrame.btn[n] = vgui.Create("DButton", self.KeyPadFrame)
			self.KeyPadFrame.btn[n]:SetSize(32, 32)
			self.KeyPadFrame.btn[n]:SetPos(x, y)
			self.KeyPadFrame.btn[n]:SetText(tostring(n))
			self.KeyPadFrame.btn[n]:SetTextColor(Color(255, 255, 255, 255))
			self.KeyPadFrame.btn[n].DoClick = function(button)
				if #password < 6 then
					password = password .. tostring(n)
					GAMEMODE.KeyPadFrame.Passlbl:SetText(password)
					GAMEMODE.KeyPadFrame.Passlbl:SetTextColor(Color(255, 255, 255, 255))
				end
			end
			self.KeyPadFrame.btn[n].Paint = function(self, w, h)
				if self:IsHovered() then
					draw.RoundedBox(16, 0, 0, w, h, Color(96, 96, 96, 255))
				end
				if self:IsDown() or (nkeys[n] and ((nkeys[n][1] and input.IsKeyDown(nkeys[n][1])) or (nkeys[n][2] and input.IsKeyDown(nkeys[n][2])))) then
					draw.RoundedBox(16, 0, 0, w, h, Color(128, 128, 128, 255))
				end
			end
		end

		local i = 1
		local cx, cy = 0, 16
		while i < 10 do
			CreateNum(i, cx + 4, cy)
			if cx >= 64 then
				cx = 0
				cy = cy + 32
			else
				cx = cx + 32
			end
			i = i + 1
		end

		self.KeyPadFrame.closebtn = vgui.Create("DButton", self.KeyPadFrame)
		self.KeyPadFrame.closebtn:SetSize(32, 32)
		self.KeyPadFrame.closebtn:SetPos(0 + 4, 112)
		self.KeyPadFrame.closebtn:SetText("X")
		self.KeyPadFrame.closebtn:SetTextColor(Color(170, 0, 0, 255))
		self.KeyPadFrame.closebtn.DoClick = function(button)
			GAMEMODE.KeyPadFrame:Close()
		end
		self.KeyPadFrame.closebtn.Paint = function(self, w, h)
			if self:IsHovered() then
				draw.RoundedBox(16, 0, 0, w, h, Color(96, 96, 96, 255))
			end
			if self:IsDown() or input.IsKeyDown(KEY_ESCAPE) then
				draw.RoundedBox(16, 0, 0, w, h, Color(128, 128, 128, 255))
			end
		end

		CreateNum(0, 32 + 4, 112)

		self.KeyPadFrame.okbtn = vgui.Create("DButton", self.KeyPadFrame)
		self.KeyPadFrame.okbtn:SetSize(32, 32)
		self.KeyPadFrame.okbtn:SetPos(64 + 4, 112)
		self.KeyPadFrame.okbtn:SetText("OK")
		self.KeyPadFrame.okbtn:SetTextColor(Color(0, 170, 0, 255))
		self.KeyPadFrame.okbtn.DoClick = function(button)

			local res = nil
			local pass = password
			password = ""

			if IsValid(ent) and ent:GetClass() == "fnafgm_keypad"
			and pass == ent:GetPassword()
			then
				net.Start("fnafgm_password_input")
					net.WriteString(pass)
					net.WriteEntity(ent)
				net.SendToServer()
				GAMEMODE.KeyPadFrame.Passlbl:SetText("OK")
				GAMEMODE.KeyPadFrame.Passlbl:SetTextColor(Color(0, 170, 0, 255))
				surface.PlaySound("ui/buttonclickrelease.wav")
				return
			end

			for k, v in pairs(passwords) do
				if pass == k then
					res = v.func()
					break
				end
			end


			if res == true then
				GAMEMODE.KeyPadFrame.Passlbl:SetTextColor(Color(0, 170, 0, 255))
			elseif res == false then
				GAMEMODE.KeyPadFrame.Passlbl:SetTextColor(Color(255, 0, 0, 255))
			elseif res == nil then
				surface.PlaySound("buttons/button10.wav")
				GAMEMODE.KeyPadFrame.Passlbl:SetText("X")
				GAMEMODE.KeyPadFrame.Passlbl:SetTextColor(Color(255, 0, 0, 255))
				if IsValid(ent) and ent:GetClass() == "fnafgm_keypad" then
					net.Start("fnafgm_password_input")
						net.WriteString(pass)
						net.WriteEntity(ent)
					net.SendToServer()
				end
				return
			end

			surface.PlaySound("ambient/water/drip" .. math.random(1, 4) .. ".wav")

		end
		self.KeyPadFrame.okbtn.Paint = function(self, w, h)
			if self:IsHovered() then
				draw.RoundedBox(16, 0, 0, w, h, Color(96, 96, 96, 255))
			end
			if self:IsDown() or input.IsKeyDown(KEY_ENTER) or input.IsKeyDown(KEY_PAD_ENTER) then
				draw.RoundedBox(16, 0, 0, w, h, Color(128, 128, 128, 255))
			end
		end

		secrete_anim = Derma_Anim("secrete_anim", self.KeyPadFrame, function(pnl, anim, delta, data)
			pnl:SetSize(280 * delta + 104, 236 * delta + 148)
			pnl:SetPos((ScrW() / 2 - 52) - 140 * delta, (ScrH() / 2 - 74) - 124 * delta)
		end)

	end

end
