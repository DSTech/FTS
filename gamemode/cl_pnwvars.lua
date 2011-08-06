local VARTYPE_NIL = 0;
local VARTYPE_ANG = 1;
local VARTYPE_VEC = 2;
local VARTYPE_BOL = 3;
local VARTYPE_INT = 4;
local VARTYPE_STR = 5;
local VARTYPE_ENT = 6;
local VARTYPE_NEW = 7;//New networked variable declaration

pnwv = pnwv or {}
pnwv.PNWVars = pnwv.PNWVars or {};
pnwv.PNWVarKeys = pnwv.PNWVarKeys or {};
pnwv.PNWVarHooks = pnwv.PNWVarHooks or {};

local vtypeHandlers = {
	[VARTYPE_ANG]=function(um) return um:ReadAngle() end,
	[VARTYPE_VEC]=function(um) return um:ReadVector() end,
	[VARTYPE_BOL]=function(um) return um:ReadBool() end,
	[VARTYPE_INT]=function(um) return um:ReadLong() end,
	[VARTYPE_STR]=function(um) return um:ReadString() end,
	[VARTYPE_ENT]=function(um) return um:ReadEntity() end,
	[VARTYPE_NIL]=function() end,
	nil
}

usermessage.Hook('pnw', function(um)
	local vtype = um:ReadChar();
	if(vtype == VARTYPE_NEW)then
		local ind, nam = um:ReadChar(),um:ReadString();
		pnwv.PNWVarKeys[ind] = nam
		print("PNV "..nam.." set as "..ind)
		return
	end
	local name = pnwv.PNWVarKeys[um:ReadChar()] or error("Private Network Variable not registered!")

	pnwv.PNWVars[name] = (vtypeHandlers[vtype] and vtypeHandlers[vtype](um))
	if(pnwv.PNWVarHooks[name])then
		pnwv.PNWVarHooks[name](pnwv.PNWVars[name])
	end
end);

function pnwv.GetVar(name, default)
	return pnwv.PNWVars && pnwv.PNWVars[name] || default;
end

function pnwv.HookVar(name, func, default)
	pnwv.PNWVarHooks[name] = func
	pnwv.PNWVarHooks[name](pnwv.PNWVars[name] or default)
end
