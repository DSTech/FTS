local VARTYPE_NONE   = 0;
local VARTYPE_ANGLE  = 1;
local VARTYPE_VECTOR = 2;
local VARTYPE_BOOL   = 3;
local VARTYPE_INT    = 4;
local VARTYPE_STRING = 5;
local VARTYPE_ENTITY = 6;

local vtypeHandlers = {
	[VARTYPE_ANGLE]=function(um) return um:ReadAngle() end,
	[VARTYPE_VECTOR]=function(um) return um:ReadVector() end,
	[VARTYPE_BOOL]=function(um) return um:ReadBool() end,
	[VARTYPE_INT]=function(um) return um:ReadLong() end,
	[VARTYPE_STRING]=function(um) return um:ReadString() end,
	[VARTYPE_ENTITY]=function(um) return um:ReadEntity() end,
	[VARTYPE_NONE]=function() end,
	nil
}

pnwv = pnwv or {}
pnwv.PNWVars = pnwv.PNWVars or {};
pnwv.PNWVarHooks = pnwv.PNWVarHooks or {};
usermessage.Hook('pnw', function(um)
	local vtype = um:ReadChar();
	local name = um:ReadString();

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
