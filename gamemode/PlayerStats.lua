pcall(hook.Remove,"PlayerInitialSpawn","FTS_SetupStats")
function FTS_SetupStats(plr)
	plr:SetPNWVar("money", GetPData(plr, "money", 0))
	plr:SetPNWVar("kills", GetPData(plr, "kills", 0))
end
hook.Add("PlayerInitialSpawn","FTS_SetupStats",FTS_SetupStats)

function GiveMoney(plr, amnt)
	if not (plr:IsValid() and plr:IsPlayer())then return end
	local newMoney = plr:GetPNWVar("money") + amnt
	plr:SetPNWVar("money", newMoney)
	SetPData(plr, "money", newMoney)
end

function GiveKills(plr, amnt)
	if not (plr:IsValid() and plr:IsPlayer())then return end
	local newKills = plr:GetPNWVar("kills") + amnt
	plr:SetPNWVar("kills", newKills)
	SetPData(plr, "kills", newKills)
end

function TakeMoney(plr, amnt)
	return GiveMoney(plr, -tonumber(amnt))
end

function TakeKills(plr, amnt)
	return GiveKills(plr, -tonumber(amnt))
end

function GetMoney(plr) return tonumber(GetPData(plr, "money", 0)) end

function GetKills(plr) return tonumber(GetPData(plr, "kills", 0)) end

function SaveStats(plr)
	if not (plr:IsValid() and plr:IsPlayer() and plr:GetTable().PNWVars)then return end
	for k,v in pairs(plr:GetTable().PNWVars)do
		SetPData(plr, k, v)
	end
end

pcall(hook.Remove,"PlayerDeath","FTS_DeathTracker")
function FTS_DeathTracker(victim, attacker, killer)
	if(victim == killer)then return end
	GiveMoney(killer, 50)
	GiveKills(killer, 1)
end
hook.Add("PlayerDeath","FTS_DeathTracker", FTS_DeathTracker )

pcall(hook.Remove,"EntityTakeDamage","FTS_DamageTracker")
function FTS_DamageTracker(ent, inflictor, attacker, amount)
	if not(attacker:IsPlayer())then return end
	--Not on same team?
	if(amount <= 0)then return end
	if not(ent:IsPlayer())then return end
	GiveMoney(attacker, math.floor(amount / 15))
end
hook.Add("EntityTakeDamage","FTS_DamageTracker", FTS_DamageTracker)

pcall(hook.Remove, "OnNPCKilled", "FTS_NPCTracker")
function FTS_NPCTracker(NPC, killer, weapon)
	GiveMoney(killer, 5)
end
hook.Add("OnNPCKilled", "FTS_NPCTracker", FTS_NPCTracker)

include("PlayerSWEPStore.lua")
