function FTS_Loadout(plr)
	plr:Give("weapon_crowbar")
	plr:Give("weapon_pistol")
	plr:Give("gmod_tool")
	plr:Give("weapon_physcannon")
	plr:Give("weapon_physgun")
	return true
end
function GM:PlayerLoadout(plr)
	FTS_Loadout(plr)
end

function FTS_GiveSwep(plr,class,wep)
	if not(plr:IsValid() and plr:IsPlayer() and plr:Alive())then return end
	if(plr:HasWeapon(class))then
		plr:ChatPrint("You already have this weapon, ammo purchase selected.")
		return false
	end
	return false
end
function GM:PlayerGiveSWEP(plr, swepClass, swepInfo)
	return FTS_GiveSwep(plr, swepClass, swepInfo)
end

function FTS_SpawnSwep(plr, swepClass, swepInfo)
	if not(plr:IsValid() and plr:IsPlayer() and plr:Alive())then return end
	print("PlayerSpawnSwep Ran")
	return false
end
function GM:PlayerSpawnSWEP(plr, swepClass, swepInfo)
	return FTS_SpawnSwep(plr, swepClass, swepInfo)
end

function FTS_BuyCommand(plr)
	plr:ChatPrint("Choose something to buy first")
end
function GM:PlayerSay(plr, text, teamOnly)
	print(text)
	if(text ~= "/buy")then
		return
	end
	if not(plr:IsValid() and plr:IsPlayer() and plr:Alive())then return end
	FTS_BuyCommand(plr)
	return false
end
