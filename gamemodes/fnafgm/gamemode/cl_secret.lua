--[[---------------------------------------------------------

	Five Nights at Freddy's Gamemode for Garry's Mod
			by VictorienXP@Xperidia (2015)

	"Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]

function fnafgmSecret()

	if !IsValid(fnafgmSecretD) and !engine.IsPlayingDemo() then

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

		fnafgmSecretD = vgui.Create("DFrame")
		fnafgmSecretD:SetPos(ScrW() / 2 - 52, ScrH() / 2 - 74)
		fnafgmSecretD:SetSize(104, 148)
		fnafgmSecretD:SetTitle("")
		fnafgmSecretD:SetVisible(true)
		fnafgmSecretD:ShowCloseButton(false)
		fnafgmSecretD:SetScreenLock(true)
		fnafgmSecretD.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(64, 64, 64, 255))
		end
		fnafgmSecretD.Think = function(self)

			if secrete_anim:Active() then secrete_anim:Run() end

			if fnafgmSecretD.btn then
				for k, v in pairs(fnafgmSecretD.btn) do
					if IsValid(v) and (nkeys[k] and ((nkeys[k][1] and input.IsKeyDown(nkeys[k][1])) or (nkeys[k][2] and input.IsKeyDown(nkeys[k][2])))) then
						if !nope then v.DoClick() end
						nope = true
						return
					end
				end
			end

			if IsValid(fnafgmNUMD) and (input.IsKeyDown(KEY_ENTER) or input.IsKeyDown(KEY_PAD_ENTER)) then
				if !nope then fnafgmNUMD.DoClick() end
				nope = true
				return
			end

			if input.IsKeyDown(KEY_ESCAPE) then
				fnafgmSecretD:Close()
			end

			nope = false

		end
		fnafgmSecretD:MakePopup()
		fnafgmSecretD.btn = {}

		fnafgmSecretPasswordback = vgui.Create("DPanel")
		fnafgmSecretPasswordback:SetParent(fnafgmSecretD)
		fnafgmSecretPasswordback:SetSize(50, 16)
		fnafgmSecretPasswordback:SetPos(27, 0)
		fnafgmSecretPasswordback.Paint = function(self, w, h)
			draw.RoundedBox(4, 0, 0, w, h, Color(0, 0, 0, 255))
		end

		fnafgmSecretPasswordlbl = vgui.Create( "DLabel" )
		fnafgmSecretPasswordlbl:SetParent(fnafgmSecretD)
		fnafgmSecretPasswordlbl:SetText("")
		fnafgmSecretPasswordlbl:SetPos(2, 0)
		fnafgmSecretPasswordlbl:SetSize(100, 16)
		fnafgmSecretPasswordlbl:SetTextColor(Color(255, 255, 255, 255))
		fnafgmSecretPasswordlbl:SetContentAlignment(5)

		local function CreateNum(n, x, y)

			fnafgmSecretD.btn[n] = vgui.Create("DButton", fnafgmSecretD)
			fnafgmSecretD.btn[n]:SetSize(32, 32)
			fnafgmSecretD.btn[n]:SetPos(x, y)
			fnafgmSecretD.btn[n]:SetText(tostring(n))
			fnafgmSecretD.btn[n]:SetTextColor(Color(255, 255, 255, 255))
			fnafgmSecretD.btn[n].DoClick = function(button)
				if #password < 6 then
					password = password .. tostring(n)
					fnafgmSecretPasswordlbl:SetText(password)
					fnafgmSecretPasswordlbl:SetTextColor(Color(255, 255, 255, 255))
				end
			end
			fnafgmSecretD.btn[n].Paint = function(self, w, h)
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

		fnafgmNUMS = vgui.Create("DButton", fnafgmSecretD)
		fnafgmNUMS:SetSize(32, 32)
		fnafgmNUMS:SetPos(0 + 4, 112)
		fnafgmNUMS:SetText("X")
		fnafgmNUMS:SetTextColor(Color(170, 0, 0, 255))
		fnafgmNUMS.DoClick = function(button)
			fnafgmSecretD:Close()
		end
		fnafgmNUMS.Paint = function(self, w, h)
			if self:IsHovered() then
				draw.RoundedBox(16, 0, 0, w, h, Color(96, 96, 96, 255))
			end
			if self:IsDown() or input.IsKeyDown(KEY_ESCAPE) then
				draw.RoundedBox(16, 0, 0, w, h, Color(128, 128, 128, 255))
			end
		end

		CreateNum(0, 32 + 4, 112)

		fnafgmNUMD = vgui.Create("DButton", fnafgmSecretD)
		fnafgmNUMD:SetSize(32, 32)
		fnafgmNUMD:SetPos(64 + 4, 112)
		fnafgmNUMD:SetText("OK")
		fnafgmNUMD:SetTextColor(Color(0, 170, 0, 255))
		fnafgmNUMD.DoClick = function(button)
			if password == "2015" then
				surface.PlaySound("ambient/water/drip" .. math.random(1, 4) .. ".wav")
				if fnafgmSecretD.btn then
					for k, v in pairs(fnafgmSecretD.btn) do
						if IsValid(v) then
							v:Remove()
						end
					end
				end
				fnafgmSecretPasswordlbl:Remove()
				fnafgmSecretPasswordback:Remove()
				secrete_anim:Start(0.25)
				fnafgmNUMD:Remove()
				fnafgmNUMS:SetPos(352, 0)
				fnafgmNUMS:SetZPos(1000)
				local Zed = vgui.Create("DHTML", fnafgmSecretD)
				Zed:SetPos(0, 0)
				Zed:SetSize(384, 384)
				Zed:SetAllowLua(true)
				Zed:OpenURL("www.Xperidia.com/DAT_FACE.html")
				Zed:SetScrollbars(false)
			elseif password == "847466" then --VISION
				surface.PlaySound("ambient/water/drip" .. math.random(1, 4) .. ".wav")
				password = ""
				if GAMEMODE.Vars.Cheat.VISION == nil then GAMEMODE.Vars.Cheat.VISION = false end
				GAMEMODE.Vars.Cheat.VISION = !GAMEMODE.Vars.Cheat.VISION
				if GAMEMODE.Vars.Cheat.VISION then
					fnafgmSecretPasswordlbl:SetText("VISION I")
					fnafgmSecretPasswordlbl:SetTextColor(Color(0, 170, 0, 255))
				else
					fnafgmSecretPasswordlbl:SetText("VISION O")
					fnafgmSecretPasswordlbl:SetTextColor(Color(255, 0, 0, 255))
				end
			--[[elseif password == "362346" then --FNAFGM
				surface.PlaySound("ambient/water/drip" .. math.random(1, 4) .. ".wav")
				password = ""
				fnafgmSecretPasswordlbl:SetText("")
				fnafgmSecretPasswordlbl:SetTextColor(Color(0, 170, 0, 255))
			elseif password == "76937" then --POWER
				surface.PlaySound("ambient/water/drip" .. math.random(1, 4) .. ".wav")
				password = ""
				fnafgmSecretPasswordlbl:SetText("POWER")
				fnafgmSecretPasswordlbl:SetTextColor(Color(0, 170, 0, 255))]]
			else
				surface.PlaySound("buttons/button10.wav")
				password = ""
				fnafgmSecretPasswordlbl:SetText("NOPE")
				fnafgmSecretPasswordlbl:SetTextColor(Color(255, 0, 0, 255))
			end
		end
		fnafgmNUMD.Paint = function(self, w, h)
			if self:IsHovered() then
				draw.RoundedBox(16, 0, 0, w, h, Color(96, 96, 96, 255))
			end
			if self:IsDown() or input.IsKeyDown(KEY_ENTER) or input.IsKeyDown(KEY_PAD_ENTER) then
				draw.RoundedBox(16, 0, 0, w, h, Color(128, 128, 128, 255))
			end
		end

		secrete_anim = Derma_Anim("secrete_anim", fnafgmSecretD, function(pnl, anim, delta, data)
			pnl:SetSize(280 * delta + 104, 236 * delta + 148)
			pnl:SetPos((ScrW() / 2 - 52) - 140 * delta, (ScrH() / 2 - 74) - 124 * delta)
		end)

	end

end
