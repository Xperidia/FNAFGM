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
			Zed:OpenURL("https://assets.xperidia.com/fnafgm/dat_face.html")
			Zed:SetScrollbars(false)

			surface.PlaySound("ambient/water/drip" .. math.random(1, 4) .. ".wav")

			return ""

		end
	},

	["847466"] = {
		name = "VISION",
	},

	["666"] = {
		func = function()
			RunConsoleCommand("kill")
			GAMEMODE.KeyPadFrame:Close()
			return ""
		end
	},

	["69"] = {
		msg = "( ͡° ͜ʖ ͡°)",
	},

	["420"] = {
		msg = "( *▽*)y─┛",
	},

	["42"] = {
		msg = "(*^▽^*)",
	},

	["69420"] = {
		msg = "~\\(≧▽≦)/~",
	},

	["1987"] = {
		func = function()
			if not fnafgm_sandbox_enable:GetBool() then
				GAMEMODE.Vars.b87 = true
			end
			GAMEMODE.KeyPadFrame:Close()
			return ""
		end
	},

	["746427"] = {
		func = function()

			if GAMEMODE.KeyPadFrame.btn then
				for k, v in pairs(GAMEMODE.KeyPadFrame.btn) do
					if IsValid(v) then
						v:Remove()
					end
				end
			end

			local x, y = 442, 384

			GAMEMODE.KeyPadFrame.Passlbl:Remove()
			GAMEMODE.KeyPadFrame.back:Remove()

			GAMEMODE.KeyPadFrame.okbtn:Remove()

			GAMEMODE.KeyPadFrame:SetSize(x, y)
			GAMEMODE.KeyPadFrame:SetPos(ScrW() / 2 - x / 2, ScrH() / 2 - y / 2)

			GAMEMODE.KeyPadFrame._do_not_paint = true

			GAMEMODE.KeyPadFrame.closebtn:SetPos(x - 32, 0)
			GAMEMODE.KeyPadFrame.closebtn:SetZPos(1000)

			local Zed = vgui.Create("DHTML", GAMEMODE.KeyPadFrame)
			Zed:SetPos(0, 0)
			Zed:SetSize(x, y)
			Zed:SetAllowLua(true)
			Zed:OpenURL("https://assets.xperidia.com/fnafgm/pingas.html")
			Zed:SetScrollbars(false)

			surface.PlaySound("ambient/water/drip" .. math.random(1, 4) .. ".wav")

			return ""

		end
	},

}

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
	["X"] = {KEY_ESCAPE, KEY_XBUTTON_B, KEY_XBUTTON_START},
	["OK"] = {KEY_ENTER, KEY_PAD_ENTER, KEY_E, KEY_XBUTTON_Y},
	["sel"] = {KEY_ENTER, KEY_PAD_ENTER, KEY_SPACE, KEY_XBUTTON_A},
	["del"] = {KEY_BACKSPACE, KEY_XBUTTON_X},
	["Up"] = {KEY_W, KEY_Z},
	["Left"] = {KEY_A, KEY_Q},
	["Down"] = {KEY_S},
	["Right"] = {KEY_D},
}


local directions = {
	"Up",
	"Left",
	"Down",
	"Right",
}

local function direction_logic(dir, n)
	if dir == "Up" then
		if n == "OK" then
			return 9
		elseif n == "X" then
			return 7
		elseif n == 0 then
			return 8
		elseif n > 3 then
			return n - 3
		end
	elseif dir == "Left" then
		if n == "OK" then
			return 0
		elseif n == "X" then
			return 9
		elseif n == 0 then
			return "X"
		elseif n > 1 then
			return n - 1
		end
	elseif dir == "Down" then
		if n == "OK" or n == "X" or n == 0 then
			return nil
		elseif n == 7 then
			return "X"
		elseif n == 8 then
			return 0
		elseif n == 9 then
			return "OK"
		elseif n < 10 then
			return n + 3
		end
	elseif dir == "Right" then
		if n == "OK" then
			return nil
		elseif n == "X" then
			return 0
		elseif n == 0 then
			return "OK"
		elseif n == 9 then
			return "X"
		elseif n < 9 then
			return n + 1
		end
	end
	return nil
end

local function setup_directions_func(btn)
	btn.GoToDirection = function(self, dir)
		local n = direction_logic(directions[dir], btn.num)
		local frame = self:GetParent()
		if n == "OK" and IsValid(frame.okbtn) then
			frame:switch_btn_sel(self, frame.okbtn)
		elseif n == "X" and IsValid(frame.closebtn) then
			frame:switch_btn_sel(self, frame.closebtn)
		elseif n ~= nil and IsValid(frame.btn[n]) then
			frame:switch_btn_sel(self, frame.btn[n])
		end
	end
end

local function btn_paint(self, w, h)
	if self:IsDown() or self._KeyDown then
		draw.RoundedBox(16, 0, 0, w, h, Color(255, 255, 255, 64))
	elseif self.selected and self:IsHovered() then
		draw.RoundedBox(16, 0, 0, w, h, Color(255, 255, 255, 32))
	elseif self.selected then
		draw.RoundedBox(16, 0, 0, w, h, Color(255, 255, 255, 16))
	elseif self:IsHovered() then
		draw.RoundedBox(16, 0, 0, w, h, Color(255, 255, 255, 8))
	end
end

function GM:KeyPad(ent)

	if !IsValid(self.KeyPadFrame) and !engine.IsPlayingDemo() then

		local password = ""
		local max_digit = 8

		self.KeyPadFrame = vgui.Create("DFrame")
		self.KeyPadFrame:SetPos(ScrW() / 2 - 52, ScrH() / 2 - 74)
		self.KeyPadFrame:SetSize(104, 148)
		self.KeyPadFrame:SetTitle("")
		self.KeyPadFrame:SetVisible(true)
		self.KeyPadFrame:ShowCloseButton(false)
		self.KeyPadFrame:SetScreenLock(true)
		self.KeyPadFrame.Paint = function(self, w, h)
			if not self._do_not_paint then
				draw.RoundedBox(4, 0, 0, w, h, Color(64, 64, 64, 255))
			end
		end
		self.KeyPadFrame.Think = function(self)

			if secrete_anim:Active() then secrete_anim:Run() end

			if input.IsKeyDown(KEY_ESCAPE) then
				self:Close()
			end

		end
		self.KeyPadFrame.OnKeyCodePressed = function(self, keyCode)

			local selectedbtn = self.selectedbtn

			if keyCode > KEY_NONE and keyCode < KEY_A then
				local n = keyCode - KEY_0
				self.btn[n].DoClick()
				self.btn[n]._KeyDown = true
				return
			elseif keyCode > KEY_Z and keyCode < KEY_PAD_DIVIDE then
				local n = keyCode - KEY_PAD_0
				self.btn[n].DoClick()
				self.btn[n]._KeyDown = true
				return
			elseif keyCode > KEY_APP and keyCode < KEY_F1
			and IsValid(selectedbtn) then
				selectedbtn:GoToDirection(keyCode - KEY_APP)
				return
			end

			if IsValid(selectedbtn) then
				for _, key in pairs(nkeys.sel) do
					if keyCode == key then
						selectedbtn._KeyDown = true
						return
					end
				end
			end

			if IsValid(self.okbtn) then
				for _, key in pairs(nkeys.OK) do
					if keyCode == key then
						self.okbtn._KeyDown = true
						return
					end
				end
			end

			for _, key in pairs(nkeys.del) do
				if keyCode == key then
					if #password == 0 then
						self.Passlbl:SetText("")
					else
						password = string.sub(password, 1, #password - 1)
						self.Passlbl:SetText(password)
					end
					return
				end
			end

			if IsValid(selectedbtn) then
				for k, v in pairs(directions) do
					for _, key in pairs(nkeys[v]) do
						if keyCode == key then
							selectedbtn:GoToDirection(k)
							return
						end
					end
				end
			end

		end
		self.KeyPadFrame.OnKeyCodeReleased = function(self, keyCode)

			local selectedbtn = self.selectedbtn

			if keyCode > KEY_NONE and keyCode < KEY_A then
				local n = keyCode - KEY_0
				self.btn[n]._KeyDown = false
				return
			elseif keyCode > KEY_Z and keyCode < KEY_PAD_DIVIDE then
				local n = keyCode - KEY_PAD_0
				self.btn[n]._KeyDown = false
				return
			end

			if IsValid(selectedbtn) then
				for _, key in pairs(nkeys.sel) do
					if keyCode == key then
						selectedbtn._KeyDown = false
						selectedbtn.DoClick()
						return
					end
				end
			end

			if IsValid(self.okbtn) then
				for _, key in pairs(nkeys.OK) do
					if keyCode == key then
						self.okbtn._KeyDown = false
						self.okbtn.DoClick()
						return
					end
				end
			end

			for _, key in pairs(nkeys.X) do
				if keyCode == key then
					self:Close()
					return
				end
			end

		end
		self.KeyPadFrame:MakePopup()
		self.KeyPadFrame.switch_btn_sel = function(self, old, new)
			if old._KeyDown then return end
			old.selected = false
			self.selectedbtn = new
			new.selected = true
		end

		self.KeyPadFrame.btn = {}

		self.KeyPadFrame.back = vgui.Create("DPanel", self.KeyPadFrame)
		self.KeyPadFrame.back:SetSize(78, 16)
		self.KeyPadFrame.back:SetPos(13, 0)
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
			local btn = self.KeyPadFrame.btn[n]
			btn:SetSize(32, 32)
			btn:SetPos(x, y)
			btn:SetText(tostring(n))
			btn:SetTextColor(Color(255, 255, 255, 255))
			btn.DoClick = function(button)
				if #password < max_digit then
					password = password .. tostring(n)
					GAMEMODE.KeyPadFrame.Passlbl:SetText(password)
					GAMEMODE.KeyPadFrame.Passlbl:SetTextColor(Color(255, 255, 255, 255))
				end
			end
			btn.Paint = btn_paint
			btn.num = n
			setup_directions_func(btn)
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
		self.KeyPadFrame.closebtn.Paint = btn_paint
		self.KeyPadFrame.closebtn.num = "X"
		setup_directions_func(self.KeyPadFrame.closebtn)

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
			local valid_keypad_ent = IsValid(ent) and ent:GetClass() == "fnafgm_keypad"

			if valid_keypad_ent and pass == ent:GetPassword() then

				net.Start("fnafgm_password_input")
					net.WriteString(pass)
					net.WriteEntity(ent)
				net.SendToServer()

				GAMEMODE.KeyPadFrame.Passlbl:SetText("OK")
				GAMEMODE.KeyPadFrame.Passlbl:SetTextColor(Color(0, 170, 0, 255))

				GAMEMODE.KeyPadFrame:Close()

				return

			end

			for k, v in pairs(passwords) do
				if pass == k then
					if v.func then
						res = v.func()
					elseif v.name then
						GAMEMODE.Vars.Cheat[v.name] = not GAMEMODE.Vars.Cheat[v.name]
						if GAMEMODE.Vars.Cheat[v.name] then
							GAMEMODE.KeyPadFrame.Passlbl:SetText(v.name .. " I")
							res = true
						else
							GAMEMODE.KeyPadFrame.Passlbl:SetText(v.name .. " O")
							res = false
						end
					elseif v.msg then
						GAMEMODE.KeyPadFrame.Passlbl:SetText(v.msg)
						res = "v.msg"
					end
					break
				end
			end

			if res == true then

				GAMEMODE.KeyPadFrame.Passlbl:SetTextColor(Color(0, 170, 0, 255))
				surface.PlaySound("ambient/water/drip" .. math.random(1, 4) .. ".wav")

			elseif res == false then

				GAMEMODE.KeyPadFrame.Passlbl:SetTextColor(Color(255, 0, 0, 255))
				surface.PlaySound("ambient/water/drip" .. math.random(1, 4) .. ".wav")

			elseif res == nil then

				if not valid_keypad_ent then
					surface.PlaySound("buttons/button10.wav")
				end

				GAMEMODE.KeyPadFrame.Passlbl:SetText("ERROR")
				GAMEMODE.KeyPadFrame.Passlbl:SetTextColor(Color(255, 0, 0, 255))

				if valid_keypad_ent then

					net.Start("fnafgm_password_input")
						net.WriteString(pass)
						net.WriteEntity(ent)
					net.SendToServer()

					GAMEMODE.KeyPadFrame:Close()

				end

			end

		end
		self.KeyPadFrame.okbtn.Paint = btn_paint
		self.KeyPadFrame.okbtn.num = "OK"
		self.KeyPadFrame.okbtn.selected = true
		setup_directions_func(self.KeyPadFrame.okbtn)

		self.KeyPadFrame.selectedbtn = self.KeyPadFrame.okbtn

		secrete_anim = Derma_Anim("secrete_anim", self.KeyPadFrame, function(pnl, anim, delta, data)
			pnl:SetSize(280 * delta + 104, 236 * delta + 148)
			pnl:SetPos((ScrW() / 2 - 52) - 140 * delta, (ScrH() / 2 - 74) - 124 * delta)
		end)

	end

end
