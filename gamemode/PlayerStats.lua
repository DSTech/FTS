function FTS_SetupStats(plr)
	plr:SetPNWVar("money", GetPData(plr, "money", 0))
	plr:SetPNWVar("kills", GetPData(plr, "kills", 0))
end
hook.Add( "PlayerInitialSpawn", "FTS_SetupStats", FTS_SetupStats )
