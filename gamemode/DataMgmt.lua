if not (RUNONCE_DATAMGMT) then
	require("mysqloo")

	local DB_HOST = "98.243.98.199"
	local DB_PORT = 3306
	local DB_NAME = "FTS"
	local DB_USERNAME = "GMOD"
	local DB_PASSWORD = "monkey666"

	local dbC

	function idToPlayer(id)
		for _,v in player.GetAll() do
			if(v.SteamID() == id)then
				return v
			end
		end
		return nil
	end

	function playerToID(ply)
		return ply.SteamID()
	end

	function printQuery(qr)
		PrintTable(qr:getData())
	end
	
	function getDBC()
		return dbC
	end
	
	function postConnect(db)
		dbC = db;
		print("MySQL Connection successful.")
		MsgAll("Server: MySQL Connection Successful.\n")
		--[[
		local qry = db:query("SELECT ID, Name, Cost FROM test WHERE Cost > 0.50")
		qry.onData = function(Q,D) print("Q1") PrintTable(D) end
		qry.onSuccess = printQuery
		qry.onError = function(Q,E) print("Q1") print(E) end
		qry:start()]]
	end

	function failedConnect(db)
		ErrorNoHalt("Failed to connect to MySQL server\n")
		game.ConsoleCommand( "changelevel " .. game.GetMap() .. "\n" )
	end

	function ConnectDB()
		local db = mysqloo.connect(DB_HOST, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_PORT)
		db.onConnected = postConnect
		db.onConnectionFailed = failedConnect
		db:connect()
	end

	function GetPData(plyID, key, default)
		local dQry = dbC:query("SELECT \""..key.."\" FROM \'PlayerData\' WHERE \'steamid\' = "..dbC:escape(plyID))
		dQry:start()
		dQry:wait()
		print("Start Of Data")
		PrintTable(dQry:getData())
		print("End Of Data")
		return dQry
	end
	
	function SetPData(ply, key, val)
		
	end
	
	hook.Add("InitPostEntity", "Init MySQL Connection", ConnectDB)
	
	RUNONCE_DATAMGMT = true
end
