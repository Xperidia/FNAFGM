--FNAFGM settings module for ULX GUI -- by Xperidia!
--Defines FNAFGM cvar limits and FNAFGM specific settings.

xgui.prepareDataType( "fnafgmlimits" )
local fnafgm_settings = xlib.makepanel{ parent=xgui.null }

xlib.makecheckbox{ x=10, y=10, label="Auto respawn", repconvar="rep_fnafgm_autorespawn", parent=fnafgm_settings }
xlib.makecheckbox{ x=10, y=30, label="Allow Flashlight", repconvar="rep_fnafgm_allowflashlight", parent=fnafgm_settings }
xlib.makecheckbox{ x=10, y=50, label="Enable respawn", repconvar="rep_fnafgm_respawnenabled", parent=fnafgm_settings }
xlib.makecheckbox{ x=10, y=70, label="Enable the death screen fade", repconvar="rep_fnafgm_deathscreenfade", parent=fnafgm_settings }
xlib.makecheckbox{ x=10, y=90, label="Enable the death screen overlay", repconvar="rep_fnafgm_deathscreenoverlay", parent=fnafgm_settings }
xlib.makecheckbox{ x=10, y=110, label="Instant remove dead bodies", repconvar="rep_fnafgm_ragdollinstantremove", parent=fnafgm_settings }
xlib.makecheckbox{ x=10, y=130, label="Change the dead bodies", repconvar="rep_fnafgm_ragdolloverride", parent=fnafgm_settings }
xlib.makecheckbox{ x=10, y=150, label="Auto CleanUp", repconvar="rep_fnafgm_autocleanupmap", parent=fnafgm_settings }
xlib.makecheckbox{ x=10, y=170, label="Prevent door damage", repconvar="rep_fnafgm_preventdoorkill", parent=fnafgm_settings }
xlib.makecheckbox{ x=10, y=190, label="Infinite nights", repconvar="rep_fnafgm_timethink_infinitenights", parent=fnafgm_settings }
xlib.makecheckbox{ x=10, y=210, label="Kill outside players", repconvar="rep_fnafgm_killextsrplayers", parent=fnafgm_settings }
xlib.makecheckbox{ x=10, y=230, label="Enable bypass", repconvar="rep_fnafgm_enablebypass", parent=fnafgm_settings }
xlib.makecheckbox{ x=10, y=250, label="Start the night automatically", repconvar="rep_fnafgm_timethink_autostart", parent=fnafgm_settings }
xlib.makecheckbox{ x=10, y=270, label="Disable the map's monitors", repconvar="rep_fnafgm_disablemapsmonitors", parent=fnafgm_settings }
xlib.makecheckbox{ x=10, y=290, label="Disable the power", repconvar="rep_fnafgm_disablepower", parent=fnafgm_settings }
xlib.makecheckbox{ x=10, y=310, label="Force save and load (DS)", repconvar="rep_fnafgm_forcesavingloading", parent=fnafgm_settings }

xlib.makelabel{ x=247, y=247, w=140, wordwrap=true, label="NOTE: The non-ulx cvars configurable in XGUI are provided for easy access only and DO NOT SAVE when the server is shut down or crashes.", parent=fnafgm_settings }
fnafgm_settings.plist = xlib.makelistlayout{ x=200, y=5, h=322, w=380, spacing=1, padding=2, parent=fnafgm_settings }

function fnafgm_settings.processLimits()
	fnafgm_settings.plist:Clear()
	for g, limits in ipairs( xgui.data.fnafgmlimits ) do
		if #limits > 0 then
			local panel = xlib.makepanel{ h=5+math.ceil( #limits/2 )*25 }
			local i=0
			for _, cvar in ipairs( limits ) do
				local cvardata = string.Explode( " ", cvar ) --Split the cvarname and max slider value number
				xgui.queueFunctionCall( xlib.makeslider, "fnafgmlimits", { x=5+(i%2*190), y=5+math.floor(i/2)*25, w=180, label=cvardata[1]:sub(8), min=0, max=cvardata[2], repconvar="rep_"..cvardata[1], parent=panel, fixclip=true } )
				i = i + 1
			end
			fnafgm_settings.plist:Add( xlib.makecat{ label=limits.title .. " (" .. #limits .. ")", contents=panel, expanded=1 } )
		end
	end
end
fnafgm_settings.processLimits()

xgui.hookEvent( "fnafgmlimits", "process", fnafgm_settings.processLimits, "fnafgmProcessLimits" )
xgui.addSettingModule( "FNAFGM", fnafgm_settings, "icon16/cog.png", "xgui_gmsettings" )
