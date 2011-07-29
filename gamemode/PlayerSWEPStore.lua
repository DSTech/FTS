pcall(hook.Remove, "PlayerLoadout", "FTS_Loadout")
function FTS_Loadout(plr)
	plr:Give("weapon_crowbar")
	plr:Give("weapon_pistol")
	plr:Give("gmod_tool")
	plr:Give("weapon_physcannon")
	plr:Give("weapon_physgun")
	//plr:GiveAmmo(15,"pistol",true)
	return true
end
hook.Add("PlayerLoadout", "FTS_Loadout", FTS_Loadout)

local FTS_PlayerBuySelection = {}
local FTS_BuyableWeaponsData = {
	{["FancyName"]="Five Seven",["name"]="weapon_mad_57",["Cost"]=500,["AmmoType"]="AlyxGun",["AmmoCount"]=25,["AmmoOnlyCount"]=50,["AmmoOnlyCost"]=250},
	{["name"]="weapon_mad_357",["Cost"]=1500,["AmmoType"]="357",["AmmoCount"]=12,["AmmoOnlyCount"]=24,["AmmoOnlyCost"]=500},
	nil
}
local FTS_BuyableWeapons = {}
for k,v in pairs(FTS_BuyableWeaponsData) do
	FTS_BuyableWeapons[v["name"]]=v
end

pcall(hook.Remove, "PlayerGiveSwep", "FTS_GiveSwep")
function FTS_GiveSwep(plr,class,wep)
	print("PlayerGiveSwep Ran")
	if not(plr:IsValid() and plr:IsPlayer() and plr:Alive())then return end
	if(plr:HasWeapon(class))then
		plr:ChatPrint("You already have this weapon! Use Right click to buy ammo for it.")
		FTS_PlayerBuySelection[plr] = nil
		return false
	end
	local cls = FTS_BuyableWeapons[class]
	if not(cls)then
		plr:ChatPrint("Weapon '"..tostring(class).."' does not exist or is incompatible with FTS!")
		FTS_PlayerBuySelection[plr] = nil
		return false
	end
	plr:ChatPrint("Weapon set as "..tostring(FTS_BuyableWeapons[class]["FancyName"] or class))
	plr:ChatPrint("This weapon costs "..tostring(FTS_BuyableWeapons[class]["Cost"]))
	plr:ChatPrint("Type '/buy' to purchase it.")
	FTS_PlayerBuySelection[plr] = class
	return false
end
hook.Add("PlayerGiveSWEP","FTS_GiveSwep",FTS_GiveSwep)

pcall(hook.Remove, "PlayerSpawnSWEP", "FTS_SpawnSwep")
function FTS_SpawnSwep(plr,class,wep)
	print("PlayerSpawnSwep Ran")
	if not(plr:IsValid() and plr:IsPlayer() and plr:Alive())then return end
	local cls = FTS_BuyableWeapons[class]
	if not(cls)then
		plr:ChatPrint("Weapon '"..tostring(class).."' does not exist or is incompatible with FTS!")
		FTS_PlayerBuySelection[plr] = nil
		return false
	end
	plr:ChatPrint("Ammo set for weapon "..tostring(FTS_BuyableWeapons[class]["FancyName"] or class))
	plr:ChatPrint("This ammunition costs "..tostring(FTS_BuyableWeapons[class]["AmmoOnlyCost"]))
	plr:ChatPrint("Type '/buy' to purchase it.")
	FTS_PlayerBuySelection[plr] = FTS_BuyableWeapons[class] or Error("Ammotype was invalid.")
	return false
end
hook.Add("PlayerSpawnSWEP","FTS_SpawnSwep",FTS_SpawnSwep)

pcall(hook.Remove, "PlayerSay", "FTS_PlayerSay")
function FTS_PlayerSay(plr, txt, global)
	if(txt == "/buy")then
		local cls = FTS_PlayerBuySelection[plr]
		if(cls)then
			if(FTS_BuyableWeapons[cls])then
				if(tonumber(FTS_BuyableWeapons[cls]["Cost"]) < tonumber(GetMoney(plr)))then
					plr:Give(cls)
					plr:GiveAmmo(FTS_BuyableWeapons[cls]["AmmoCount"], FTS_BuyableWeapons[cls]["AmmoType"])
					TakeMoney(plr, FTS_BuyableWeapons[cls]["Cost"])
					FTS_PlayerBuySelection[plr]=nil
				else
					plr:ChatPrint("You do not have enough money to buy this weapon!")
				end
			else
				if(tonumber(cls["AmmoOnlyCost"]) < tonumber(GetMoney(plr)))then
					plr:GiveAmmo(cls["AmmoOnlyCount"], cls["AmmoType"])
					TakeMoney(plr, cls["AmmoOnlyCost"])
				else
					plr:ChatPrint("You do not have enough money to buy this ammunition!")
				end
			end
		end
		return false
	end
end
hook.Add("PlayerSay", "FTS_PlayerSay", FTS_PlayerSay)
