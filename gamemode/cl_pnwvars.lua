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

_G.PNWVarDataTable = _G.PNWVarDataTable or {}
_G.PNWVarDataTable.PNWVars = _G.PNWVarDataTable.PNWVars or {};
_G.PNWVarDataTable.PNWVarHooks = _G.PNWVarDataTable.PNWVarHooks or {};
usermessage.Hook('pnw', function(um)
	_G.PNWVarDataTable.PNWVars = _G.PNWVarDataTable.PNWVars or {};
	_G.PNWVarDataTable.PNWVarHooks = _G.PNWVarDataTable.PNWVarHooks or {};

	local vtype = um:ReadChar();
	local name = um:ReadString();

	_G.PNWVarDataTable.PNWVars[name] = (vtypeHandlers[vtype] and vtypeHandlers[vtype](um))
	if(_G.PNWVarDataTable.PNWVarHooks[name])then
		_G.PNWVarDataTable.PNWVarHooks[name](_G.PNWVarDataTable.PNWVars[name])
	end
end);

function _R.Player:GetPNWVar(name, default)
	return _G.PNWVarDataTable.PNWVars && _G.PNWVarDataTable.PNWVars[name] || default;
end

function _R.Player:HookPNWVar(name, func, default)
	_G.PNWVarDataTable.PNWVars = _G.PNWVarDataTable.PNWVars || {};
	_G.PNWVarDataTable.PNWVarHooks = _G.PNWVarDataTable.PNWVarHooks || {};
	_G.PNWVarDataTable.PNWVarHooks[name] = func
	_G.PNWVarDataTable.PNWVarHooks[name](_G.PNWVarDataTable.PNWVars[name] or default)
end
	