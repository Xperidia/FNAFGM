--sv_fnafgm -- by Xperidia!
--Server-side code related to the FNAFGM menu.

local function init()
	if GAMEMODE.IsFNAFGMDerived then --Only execute the following code if it's a FNAFGM gamemode
		xgui.addDataType( "fnafgmlimits", function() return xgui.fnafgmlimits end, "xgui_gmsettings", 0, -20 )

		ULib.replicatedWritableCvar( "fnafgm_autorespawn", "rep_fnafgm_autorespawn", GetConVarNumber( "fnafgm_autorespawn" ), false, false, "xgui_gmsettings" )
		ULib.replicatedWritableCvar( "fnafgm_allowflashlight", "rep_fnafgm_allowflashlight", GetConVarNumber( "fnafgm_allowflashlight" ), false, false, "xgui_gmsettings" )
		ULib.replicatedWritableCvar( "fnafgm_respawnenabled", "rep_fnafgm_respawnenabled", GetConVarNumber( "fnafgm_respawnenabled" ), false, false, "xgui_gmsettings" )
		ULib.replicatedWritableCvar( "fnafgm_deathscreenfade", "rep_fnafgm_deathscreenfade", GetConVarNumber( "fnafgm_deathscreenfade" ), false, false, "xgui_gmsettings" )
		ULib.replicatedWritableCvar( "fnafgm_deathscreenoverlay", "rep_fnafgm_deathscreenoverlay", GetConVarNumber( "fnafgm_deathscreenoverlay" ), false, false, "xgui_gmsettings" )
		ULib.replicatedWritableCvar( "fnafgm_ragdollinstantremove", "rep_fnafgm_ragdollinstantremove", GetConVarNumber( "fnafgm_ragdollinstantremove" ), false, false, "xgui_gmsettings" )
		ULib.replicatedWritableCvar( "fnafgm_ragdolloverride", "rep_fnafgm_ragdolloverride", GetConVarNumber( "fnafgm_ragdolloverride" ), false, false, "xgui_gmsettings" )
		ULib.replicatedWritableCvar( "fnafgm_autocleanupmap", "rep_fnafgm_autocleanupmap", GetConVarNumber( "fnafgm_autocleanupmap" ), false, false, "xgui_gmsettings" )
		ULib.replicatedWritableCvar( "fnafgm_preventdoorkill", "rep_fnafgm_preventdoorkill", GetConVarNumber( "fnafgm_preventdoorkill" ), false, false, "xgui_gmsettings" )
		ULib.replicatedWritableCvar( "fnafgm_timethink_infinitenights", "rep_fnafgm_timethink_infinitenights", GetConVarNumber( "fnafgm_timethink_infinitenights" ), false, false, "xgui_gmsettings" )
		ULib.replicatedWritableCvar( "fnafgm_killextsrplayers", "rep_fnafgm_killextsrplayers", GetConVarNumber( "fnafgm_killextsrplayers" ), false, false, "xgui_gmsettings" )
		ULib.replicatedWritableCvar( "fnafgm_enablebypass", "rep_fnafgm_enablebypass", GetConVarNumber( "fnafgm_enablebypass" ), false, false, "xgui_gmsettings" )
		ULib.replicatedWritableCvar( "fnafgm_timethink_autostart", "rep_fnafgm_timethink_autostart", GetConVarNumber( "fnafgm_timethink_autostart" ), false, false, "xgui_gmsettings" )
		ULib.replicatedWritableCvar( "fnafgm_disablemapsmonitors", "rep_fnafgm_disablemapsmonitors", GetConVarNumber( "fnafgm_disablemapsmonitors" ), false, false, "xgui_gmsettings" )
		ULib.replicatedWritableCvar( "fnafgm_disablepower", "rep_fnafgm_disablepower", GetConVarNumber( "fnafgm_disablepower" ), false, false, "xgui_gmsettings" )
		ULib.replicatedWritableCvar( "fnafgm_forcesavingloading", "rep_fnafgm_forcesavingloading", GetConVarNumber( "fnafgm_forcesavingloading" ), false, false, "xgui_gmsettings" )

		--Process the list of known FNAFGM Cvar and check if they exist
		xgui.fnafgmlimits = {}
		if GAMEMODE.IsFNAFGMDerived then
			local curgroup
			local f = ULib.fileRead( "data/ulx/fnafgm.txt", "GAME" )
			if f == nil then Msg( "XGUI ERROR: FNAFGM Cvar file was needed but could not be found!\n" ) return end
			local lines = string.Explode( "\n", f )
			for i,v in ipairs( lines ) do
				if v:sub( 1,1 ) ~= ";" then
					if v:sub( 1,1 ) == "|" then
						curgroup = table.insert( xgui.fnafgmlimits, {} )
						xgui.fnafgmlimits[curgroup].title = v:sub( 2 )
					else
						local data = string.Explode( " ", v ) --Split Convar name from max limit
						if ConVarExists( data[1] ) then
							--We need to create a replicated cvar so the clients can manipulate/view them:
							ULib.replicatedWritableCvar( data[1], "rep_" .. data[1], GetConVarNumber( data[1] ), false, false, "xgui_gmsettings" )
							--Add to the list of cvars to send to the client
							table.insert( xgui.fnafgmlimits[curgroup], v )
						end
					end
				end
			end
		end
	end
end
xgui.addSVModule( "fnafgm", init )
