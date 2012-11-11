function FTS_SetupStats(plr)
	plr:SetPNWVar("money", GetPData(plr, "money", 0))
	plr:SetPNWVar("kills", GetPData(plr, "kills", 0))
end
function GM:PlayerInitialSpawn(plr)
	FTS_SetupStats(plr)
end

function GetMoney(plr) return tonumber(GetPData(plr, "money", 0)) end
function GetKills(plr) return tonumber(GetPData(plr, "kills", 0)) end

function GiveMoney(plr, amnt)
	if not (plr:IsValid() and plr:IsPlayer())then return false end
	local newMoney = plr:GetPNWVar("money") + amnt
	plr:SetPNWVar("money", newMoney)
	SetPData(plr, "money", newMoney)
	return newMoney
end

function GiveKills(plr, amnt)
	if not (plr:IsValid() and plr:IsPlayer())then return false end
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


function SaveStats(plr)
	if not (plr:IsValid() and plr:IsPlayer() and plr:GetTable().PNWVars)then return end
	for k,v in pairs(plr:GetTable().PNWVars)do
		SetPData(plr, k, v)
	end
end

function FTS_DeathTracker(victim, attacker, inflictor)
	if(victim == attacker)then return end
	if not(attacker:IsPlayer())then
		victim:ChatPrint("You died of somewhat natural causes")
		return
	end
	victim:ChatPrint("You died to "..attacker:GetName())
	attacker:ChatPrint("You killed "..victim:GetName())
	GiveMoney(attacker, 50)
	GiveKills(attacker, 1)
end
function GM:PlayerDeath(victim, attacker, inflictor)
	FTS_DeathTracker(victim, attacker, inflictor)
end

function FTS_DamageTracker(ent, dmgInfo)
	local inflictor = dmgInfo:GetInflictor()
	local attacker = dmgInfo:GetAttacker()
	local amount = dmgInfo:GetDamage()
	if not(attacker:IsPlayer())then return end
	--Not on same team?
	if(amount <= 0)then return end
	if not(ent:IsPlayer())then return end
	GiveMoney(attacker, math.floor(amount / 15))
end
function GM:EntityTakeDamage(entity, dmgInfo)
	FTS_DamageTracker(entity, dmgInfo)
end

function FTS_NPCTracker(NPC, killer, weapon)
	GiveMoney(killer, 5)
end
function GM:OnNPCKilled(NPC, killer, weapon)
	FTS_NPCTracker(NPC, killer, weapon)
end
