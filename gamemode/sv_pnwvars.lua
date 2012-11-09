local VARTYPE_NEW = 0;--New networked variable declaration
local VARTYPE_NIL = 1;
local VARTYPE_ANG = 2;
local VARTYPE_VEC = 3;
local VARTYPE_BOL = 4;
local VARTYPE_NUM = 5;
local VARTYPE_STR = 6;
local VARTYPE_ENT = 7;
local PMeta = FindMetaTable("Player")

util.AddNetworkString('pnw')

local typeHandlers = {
	['Angle'] = function() return VARTYPE_ANG, net.WriteAngle; end,
	['Vector'] = function() return VARTYPE_VEC, (function(vec)
													net.WriteFloat(tonumber(vec.x))
													net.WriteFloat(tonumber(vec.y))
													net.WriteFloat(tonumber(vec.z))
												end); end,
	['boolean'] = function() return VARTYPE_BOL, net.WriteBit; end,
	['number'] = function() return VARTYPE_NUM, (function(num) net.WriteFloat(tonumber(num)) end); end,
	['string'] = function() return VARTYPE_STR, net.WriteString; end,
	['NPC'] = function() return VARTYPE_ENT, net.WriteEntity; end,
	['Entity'] = function() return VARTYPE_ENT, net.WriteEntity; end,
	['Player'] = function() return VARTYPE_ENT, net.WriteEntity; end,
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

PMeta.SetPNWVar = function(self, name, val)
	if(!name || !val) then
		Error(':SetPNWVar(name, val) - invalid arguments passed!')
	end

	self.PNWVars = self.PNWVars || {}
	self.PNWVarKeys = self.PNWVarKeys || {}

	if not(self.PNWVars[name])then
		self.PNWNextVarKey = (self.PNWNextVarKey or 0) + 1
		
		net.Start('pnw')
		net.WriteUInt(tonumber(VARTYPE_NEW),4)
		net.WriteUInt(tonumber(self.PNWNextVarKey),8)
		net.WriteString(tostring(name))
		net.Send(self)
		
		self.PNWVarKeys[name] = self.PNWNextVarKey
	else
		if((self.PNWVars[name] or {}) == val)then
			return
		end
	end
	
	self.PNWVars[name] = val
	
	local vtype, func = PNWType(val);
	if(vtype == VARTYPE_NIL || !func) then
		Error(':SetPNWVar(name, val) - Val is an invalid type! Type was '..type(val)..", VType was "..vtype..", Val was "..tostring(val)..", Name was "..tostring(name))
	end

	net.Start('pnw')
	net.WriteUInt(tonumber(vtype),4)
	net.WriteUInt(tonumber(self.PNWVarKeys[name]),8)
	func(val)
	net.Send(self)
end

PMeta.GetPNWVar = function(self, name, default)
	return self.PNWVars && self.PNWVars[name] || default;
end
