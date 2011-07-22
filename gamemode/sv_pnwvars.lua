local VARTYPE_NONE   = 0;
local VARTYPE_ANGLE  = 1;
local VARTYPE_VECTOR = 2;
local VARTYPE_BOOL   = 3;
local VARTYPE_INT    = 4;
local VARTYPE_STRING = 5;
local VARTYPE_ENTITY = 6;

local typeHandlers = {
	['Angle'] = function() return VARTYPE_ANGLE, umsg.Angle; end,
	['Vector'] = function() return VARTYPE_VECTOR, umsg.Vector; end,
	['boolean'] = function() return VARTYPE_BOOL, umsg.Bool; end,
	['number'] = function() return VARTYPE_INT, umsg.Long; end,
	['string'] = function() return VARTYPE_STRING, umsg.String; end,
	['NPC'] = function() return VARTYPE_ENTITY, umsg.Entity; end,
	['Entity'] = function() return VARTYPE_ENTITY, umsg.Entity; end,
	['Player'] = function() return VARTYPE_ENTITY, umsg.Entity; end,
	nil
}

local function PNWType(val)
	local th = typeHandlers[type(val)]
	if (th) then
		return th()
	else
		return VARTYPE_NONE
	end
end

function _R.Player:SetPNWVar(name, val)
	if(!name || !val) then
		Error(':SetPNWVar(name, val) - invalid arguments passed!');
		return;
	end

	local vtype, umfunc = PNWType(val);
	if(vtype == VARTYPE_NONE || !umfunc) then
		Error(':SetPNWVar(name, val) - Val is an invalid type! Type was '..type(val)..", VType was "..vtype..", Val was "..tostring(val)..", Name was "..tostring(name));
		return;
	end

	self.PNWVars = self.PNWVars || {};

	self.PNWVars[name] = val;

	umsg.Start('pnw', self);
	umsg.Char(vtype);
	umsg.String(name);
	umfunc(val)
	umsg.End();
end

function _R.Player:GetPNWVar(name, default)
	return self.PNWVars && self.PNWVars[name] || default;
end
