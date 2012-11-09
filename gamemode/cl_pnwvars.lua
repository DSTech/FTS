local VARTYPE_NEW = 0;//New networked variable declaration
local VARTYPE_NIL = 1;
local VARTYPE_ANG = 2;
local VARTYPE_VEC = 3;
local VARTYPE_BOL = 4;
local VARTYPE_NUM = 5;
local VARTYPE_STR = 6;
local VARTYPE_ENT = 7;


pnwv = pnwv or {}
pnwv.PNWVars = pnwv.PNWVars or {};
pnwv.PNWVarKeys = pnwv.PNWVarKeys or {};
pnwv.PNWVarHooks = pnwv.PNWVarHooks or {};

local vtypeHandlers = {
	[VARTYPE_ANG]=function() return net.ReadAngle() end,
	[VARTYPE_VEC]=function() return Vector(net.ReadFloat(),net.ReadFloat(),net.ReadFloat()) end,
	[VARTYPE_BOL]=function() return net.ReadBit()~=0 end,
	[VARTYPE_NUM]=function() return net.ReadFloat() end,
	[VARTYPE_STR]=function() return net.ReadString() end,
	[VARTYPE_ENT]=function() return net.ReadEntity() end,
	[VARTYPE_NIL]=function() end,
	nil
}

net.Receive('pnw', function(length)
	local vtype = net.ReadUInt(4)
	if(vtype == VARTYPE_NEW)then
		local ind, nam = net.ReadUInt(8), net.ReadString();
		pnwv.PNWVarKeys[ind] = nam
		print("PNV "..nam.." set as "..ind)
		return
	end
	local id = net.ReadUInt(8)
	local name = pnwv.PNWVarKeys[id]
	if not name then
		return ErrorNoHalt("Private Network Variable '"..tostring(id).."' of vtype '"..tostring(vtype).."' not registered!\n")
	end

	if(vtypeHandlers[vtype])then
		pnwv.PNWVars[name] = vtypeHandlers[vtype]()
		for k,v in pairs(pnwv.PNWVarHooks[name])do
			local success, err = pcall(v, name, pnwv.PNWVars[name])
			if(not success)then
				ErrorNoHalt(err)
			end
		end
	end
end)

function pnwv.GetVar(name, default)
	return pnwv.PNWVars && pnwv.PNWVars[name] || default;
end

function pnwv.HookVar(name, hookID, func, default)
	if not pnwv.PNWVarHooks[name] then
		pnwv.PNWVarHooks[name] = {}
	end
	pnwv.PNWVarHooks[name][hookID] = func
	
	for k,v in pairs(pnwv.PNWVarHooks[name])do
		v(name, pnwv.PNWVars[name] or default)
	end
end

function pnwv.RemoveVarHook(name, hookID)
	if not pnwv.PNWVarHooks[name] then
		return
	end
	pnwv.PNWVarHooks[name][hookID] = nil
end
