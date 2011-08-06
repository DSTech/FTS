local VARTYPE_NIL = 0;
local VARTYPE_ANG = 1;
local VARTYPE_VEC = 2;
local VARTYPE_BOL = 3;
local VARTYPE_INT = 4;
local VARTYPE_STR = 5;
local VARTYPE_ENT = 6;
local VARTYPE_NEW = 7;//New networked variable declaration

local typeHandlers = {
	['Angle'] = function() return VARTYPE_ANG, umsg.Angle; end,
	['Vector'] = function() return VARTYPE_VEC, umsg.Vector; end,
	['boolean'] = function() return VARTYPE_BOL, umsg.Bool; end,
	['number'] = function() return VARTYPE_INT, umsg.Long; end,
	['string'] = function() return VARTYPE_STR, umsg.String; end,
	['NPC'] = function() return VARTYPE_ENT, umsg.Entity; end,
	['Entity'] = function() return VARTYPE_ENT, umsg.Entity; end,
	['Player'] = function() return VARTYPE_ENT, umsg.Entity; end,
	nil
}

local function PNWType(val)
	local th = typeHandlers[type(val)]
	if (th) then
		return th()
	else
		return VARTYPE_NIL
	end
end

function _R.Player:SetPNWVar(name, val)
	if(!name || !val) then
		Error(':SetPNWVar(name, val) - invalid arguments passed!')
		return
	end

	self.PNWVars = self.PNWVars || {}
	self.PNWVarKeys = self.PNWVarKeys || {}

	if not(self.PNWVars[name])then
		self.PNWNextVarKey = (self.PNWNextVarKey or -1) + 1
		umsg.Start('pnw', self)
		umsg.Char(VARTYPE_NEW)
		umsg.Char(self.PNWNextVarKey)
		umsg.String(name)
		self.PNWVarKeys[name] = self.PNWNextVarKey
		umsg.End()
	else
		if((self.PNWVars[name] or {}) == val)then
			return
		end
	end
	
	self.PNWVars[name] = val
	
	local vtype, umfunc = PNWType(val);
	if(vtype == VARTYPE_NIL || !umfunc) then
		Error(':SetPNWVar(name, val) - Val is an invalid type! Type was '..type(val)..", VType was "..vtype..", Val was "..tostring(val)..", Name was "..tostring(name))
		return
	end

	umsg.Start('pnw', self)
	umsg.Char(vtype)
	umsg.Char(self.PNWVarKeys[name])
	umfunc(val)
	umsg.End()
end

function _R.Player:GetPNWVar(name, default)
	return self.PNWVars && self.PNWVars[name] || default;
end
