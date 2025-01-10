--[[---------------------------------------------------------

	Five Nights at Freddy's Gamemode for Garry's Mod
			by VickyFrenzy@Xperidia (2015-2025)

	"Five Nights at Freddy's" is a game by Scott Cawthon.

-----------------------------------------------------------]]

function GM:FNaFViewHUD()
	if not GAMEMODE.Vars.fnafviewactive and not engine.IsPlayingDemo() then
		GAMEMODE.Vars.fnafviewactive = true

		net.Start("fnafgmfnafViewActive")
		net.WriteBit(true)
		net.SendToServer()

		if GAMEMODE.FNaFView[game.GetMap()][2] then
			LocalPlayer():SetEyeAngles(GAMEMODE.FNaFView[game.GetMap()][2])
		end

		FNaFView = vgui.Create("DFrame")
		FNaFView:ParentToHUD()
		FNaFView:SetPos(0, 0)
		FNaFView:SetSize(ScrW(), ScrH())
		FNaFView:SetTitle("")
		FNaFView:SetVisible(true)
		FNaFView:SetDraggable(false)
		FNaFView:ShowCloseButton(false)
		FNaFView:SetScreenLock(false)
		FNaFView:SetPaintShadow(false)
		FNaFView:SetBackgroundBlur(false)
		FNaFView:SetWorldClicker(true)
		FNaFView:SetZPos(-32768)
		FNaFView:SetMouseInputEnabled(false)
		FNaFView:MakePopup()
		FNaFView:SetKeyboardInputEnabled(false)
		FNaFView.Paint = function(self, w, h) end
		FNaFView.OnClose = function()
			if GAMEMODE.Vars.usingsafezone then
				GAMEMODE.Vars.usingsafezone = false
				fnafgmSafeZone()
			end
			GAMEMODE.Vars.fnafviewactive = false
			net.Start("fnafgmfnafViewActive")
			net.WriteBit(false)
			net.SendToServer()
			GAMEMODE.Vars.FNaFViewLastTime = SysTime()
		end
		FNaFView.Think = function()
			if IsValid(MUTE) and GAMEMODE.Vars.mute then
				MUTE:Remove()
				MUTEb:Remove()
			end

			if not LocalPlayer():Alive() or (GAMEMODE.Vars.power == 0 and GAMEMODE.FT ~= 2) then
				OpenT:Remove()
				if IsValid(lightroom) then lightroom:Remove() end
			end

			if not LocalPlayer():Alive() and IsValid(FNaFView) then FNaFView:Close() end
			if not GAMEMODE.Vars.startday then FNaFView:Close() end
			local fps = 1 / FrameTime()
			local speed = 2
			if fps >= 75 then
				speed = 2
			elseif fps >= 30 then
				speed = 4
			elseif fps < 30 then
				speed = 5
			end

			if LocalPlayer():Alive() and IsValid(LeftZone) and (vgui.GetHoveredPanel() == LeftZone or LocalPlayer():KeyDown(IN_MOVELEFT)) and GAMEMODE.FNaFView[game.GetMap()][3] and LocalPlayer():EyeAngles()[2] <= GAMEMODE.FNaFView[game.GetMap()][3][2] then
				LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles() + Angle(0, speed, 0))
			end
			if LocalPlayer():Alive() and IsValid(RightZone) and (vgui.GetHoveredPanel() == RightZone or LocalPlayer():KeyDown(IN_MOVERIGHT)) and GAMEMODE.FNaFView[game.GetMap()][4] and LocalPlayer():EyeAngles()[2] >= GAMEMODE.FNaFView[game.GetMap()][4][2] then
				LocalPlayer():SetEyeAngles(LocalPlayer():EyeAngles() + Angle(0, -speed, 0))
			end
			if (FNaFView.m_fCreateTime + 0.5) < SysTime() and LocalPlayer():KeyDown(IN_RELOAD) then
				FNaFView:Close()
			end
		end
		FNaFView.OnMousePressed = function(p, code)
			hook.Run("GUIMousePressed", code, gui.ScreenToVector(gui.MousePos()))
		end

		LeftZone = vgui.Create("DLabel")
		LeftZone:SetParent(FNaFView)
		LeftZone:SetText("")
		LeftZone:SetWorldClicker(true)
		LeftZone:SetPos(0, 32)
		LeftZone:SetSize(ScrW() / 3, ScrH() - 32)

		RightZone = vgui.Create("DLabel")
		RightZone:SetParent(FNaFView)
		RightZone:SetText("")
		RightZone:SetWorldClicker(true)
		RightZone:SetPos(ScrW() - ScrW() / 3, 32)
		RightZone:SetSize(ScrW() / 3, ScrH() - 32)

		ExitZone = vgui.Create("DButton")
		ExitZone:SetParent(FNaFView)
		ExitZone:SetText("")
		ExitZone:SetTextColor(Color(255, 255, 255, 255))
		ExitZone:SetFont("FNAFGMNIGHT")
		ExitZone:SetPos(0, 0)
		ExitZone:SetSize(ScrW(), 40)
		ExitZone.DoClick = function(button) FNaFView:Close() end
		ExitZone.Paint = function(self, w, h) end
		ExitZone.OnCursorEntered = function()
			ExitZone:SetText(tostring(GAMEMODE.TranslatedStrings.exitfnafview or GAMEMODE.Strings.en.exitfnafview))
		end
		ExitZone.OnCursorExited = function() ExitZone:SetText("") end

		if not GAMEMODE.Vars.mute then
			MUTE = vgui.Create("DImage")
			MUTE:SetParent(FNaFView)
			MUTE:SetImage("fnafgm/mute")
			MUTE:SetSize(128, 32)
			MUTE:SetPos(64, 64)
			MUTEb = vgui.Create("DButton")
			MUTEb:SetParent(MUTE)
			MUTEb:SetSize(121, 31)
			MUTEb:SetPos(0, 0)
			MUTEb:SetText("")
			MUTEb.DoClick = function(button)
				fnafgmMuteCall()
				MUTE:Remove()
				MUTEb:Remove()
			end
			MUTEb.Paint = function(self, w, h) end
		end

		local nope = hook.Call("fnafgmFNaFViewCustom") or false
		if not nope then
			if game.GetMap() == "freddysnoevent" then
				local closebtnsizew = (512 * (ScrH() / 480)) / 2
				local closebtnsizeh = (60 * (ScrH() / 480)) / 2
				local closebtnsizec = (128 * (ScrH() / 480)) / 2
				OpenT = vgui.Create("DButton")
				OpenT:SetParent(FNaFView)
				OpenT:SetSize(ScrW() / 2 - closebtnsizec, closebtnsizeh)
				OpenT:SetPos(closebtnsizew - closebtnsizec, ScrH() - closebtnsizeh - 50)
				OpenT:SetText("")
				OpenT.DoClick = function(button)
					waitt = CurTime() + 1
					GAMEMODE:Monitor()
					fnafgmShutLights()
					OpenT:Hide()
				end
				OpenT.OnCursorEntered = function()
					if not waitt then waitt = 0 end
					if waitt < CurTime() then
						waitt = CurTime() + 0.5
						GAMEMODE:Monitor()
						fnafgmShutLights()
						OpenT:Hide()
					end
				end
				OpenT.Paint = function(self, w, h)
					GAMEMODE:DrawFnafButton(w, h, Color(255, 255, 255))
				end
			elseif game.GetMap() == "fnaf2noevents" then
				OpenT = vgui.Create("DButton")
				OpenT:SetParent(FNaFView)
				OpenT:SetSize(ScrW() / 2 - 128, 64)
				OpenT:SetPos(ScrW() / 2 + 32, ScrH() - 130)
				OpenT:SetText("")
				OpenT.DoClick = function(button)
					waitt = CurTime() + 1
					GAMEMODE:Monitor()
					OpenT:Hide()
					SafeE:Hide()
				end
				OpenT.OnCursorEntered = function()
					if not waitt then waitt = 0 end
					if waitt < CurTime() then
						waitt = CurTime() + 0.5
						GAMEMODE:Monitor()
						OpenT:Hide()
						SafeE:Hide()
					end
				end
				OpenT.Paint = function(self, w, h)
					GAMEMODE:DrawFnafButton(w, h, Color(255, 255, 255))
				end

				SafeE = vgui.Create("DButton")
				SafeE:SetParent(FNaFView)
				SafeE:SetSize(ScrW() / 2 - 128, 64)
				SafeE:SetPos(ScrW() / 2 - ScrW() / 2 + 128 - 32, ScrH() - 130)
				SafeE:SetText("")
				SafeE:SetTextColor(Color(255, 255, 255, 255))
				SafeE:SetFont("FNAFGMNIGHT")
				SafeE.DoClick = function(button)
					if not waits then waits = 0 end
					if waits < CurTime() then
						waits = CurTime() + 1
						if GAMEMODE.Vars.usingsafezone then
							OpenT:Show()
							LocalPlayer():StopSound("fnafgm_maskon")
							LocalPlayer():EmitSound("fnafgm_maskoff")
							GAMEMODE.Vars.usingsafezone = false
						elseif not GAMEMODE.Vars.usingsafezone then
							OpenT:Hide()
							LocalPlayer():StopSound("fnafgm_maskoff")
							LocalPlayer():EmitSound("fnafgm_maskon")
							GAMEMODE.Vars.usingsafezone = true
						end
						fnafgmSafeZone()
					end
				end
				SafeE.OnCursorEntered = function()
					if not waits then waits = 0 end
					if waits < CurTime() then
						waits = CurTime() + 0.5
						if GAMEMODE.Vars.usingsafezone then
							OpenT:Show()
							LocalPlayer():StopSound("fnafgm_maskon")
							LocalPlayer():EmitSound("fnafgm_maskoff")
							GAMEMODE.Vars.usingsafezone = false
						elseif not GAMEMODE.Vars.usingsafezone then
							OpenT:Hide()
							LocalPlayer():StopSound("fnafgm_maskoff")
							LocalPlayer():EmitSound("fnafgm_maskon")
							GAMEMODE.Vars.usingsafezone = true
						end
						fnafgmSafeZone()
					end
				end
				SafeE.Paint = function(self, w, h)
					GAMEMODE:DrawFnafButton(w, h, Color(255, 85, 85))
				end
			else
				local closebtnsizew = (512 * (ScrH() / 480)) / 2
				local closebtnsizeh = (60 * (ScrH() / 480)) / 2
				OpenT = vgui.Create("DButton")
				OpenT:SetParent(FNaFView)
				OpenT:SetSize(closebtnsizew, closebtnsizeh)
				OpenT:SetPos(ScrW() / 2 - closebtnsizew / 2, ScrH() - closebtnsizeh - 50)
				OpenT:SetText("")
				OpenT.DoClick = function(button)
					waitt = CurTime() + 1
					GAMEMODE:Monitor()
					OpenT:Hide()
				end
				OpenT.OnCursorEntered = function()
					if not waitt then waitt = 0 end
					if waitt < CurTime() then
						waitt = CurTime() + 0.5
						GAMEMODE:Monitor()
						OpenT:Hide()
					end
				end
				OpenT.Paint = function(self, w, h)
					GAMEMODE:DrawFnafButton(w, h, Color(255, 255, 255))
				end
			end
		end
	end
end
