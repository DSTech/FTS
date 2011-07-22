VARTYPE_NONE   = 0;
VARTYPE_ANGLE  = 1;
VARTYPE_VECTOR = 2;
VARTYPE_BOOL   = 3;
VARTYPE_INT    = 4;
VARTYPE_STRING = 5;
VARTYPE_ENTITY = 6;

typeHandlers = {
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

function PNWType(val)
	return (typeHandlers[type(val)] and typeHandlers[type(val)]()) or VARTYPE_NONE;
end

if(SERVER) then
    function _R.Player:SetPNWVar(name, val)
        if(!name || !val) then
            Error(':SetPNWVar(name, val) - invalid arguments passed!');
            return;
        end

        local vtype, umfunc = PNWType(val);
        if(vtype == VARTYPE_NONE || !umfunc) then
            Error(':SetPNWVar(name, val) - Val is an invalid type!');
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

    function _R.Player:GetPNWVar(name)
        return self.PNWVars && self.PNWVars[name] || nil;
    end
elseif(CLIENT) then
	vtypeHandlers = {
		[VARTYPE_ANGLE]=function(um) return um:ReadAngle() end,
		[VARTYPE_VECTOR]=function(um) return um:ReadVector() end,
		[VARTYPE_BOOL]=function(um) return um:ReadBool() end,
		[VARTYPE_INT]=function(um) return um:ReadLong() end,
		[VARTYPE_STRING]=function(um) return um:ReadString() end,
		[VARTYPE_ENTITY]=function(um) return um:ReadEntity() end,
		[VARTYPE_NONE]=function() end,
		nil
	}
    usermessage.Hook('pnw', function(um)
		local lp = LocalPlayer()
        lp.PNWVars = lp.PNWVars || {};
        lp.PNWVarHooks = lp.PNWVarHooks || {};

        local vtype = um:ReadChar();
        local name = um:ReadString();

		lp.PNWVars[name] = (vtypeHandler[vtype] and vtypeHandler[vtype](um))
		if(lp.PNWVarHooks[name])then
			lp.PNWVarHooks[name](lp.PNWVars[name])
		end
    end);

    function _R.Player:GetPNWVar(name)
        return self.PNWVars && self.PNWVars[name] || nil;
    end
	
	function _R.Player:HookPNWVar(name, func)
		self.PNWVarHooks[name] = func
		self.PNWVarHooks[name](self.PNWVars[name])
	end
end
