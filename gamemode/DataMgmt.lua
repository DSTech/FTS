
function idToPlayer(id)
	for _,v in pairs(player.GetAll()) do
		if(v:SteamID() == id)then
			return v
		end
	end
	return nil
end

function playerToID(ply)
	return ply:SteamID()
end

function GetPData(ply, key, default)
	local t = type(ply)
	if(t == "string")then
		t = idToPlayer(ply)
	else
		t = ply
	end
	return t:GetPData(key) or default
end

function SetPData(ply, key, val)
	local t = type(ply)
	if(t == "string")then
		t = idToPlayer(t)
	else
		t = ply
	end
	t:SetPData(key, val)
end
