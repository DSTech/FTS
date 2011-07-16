require("mysqloo")

local DB_HOST = "98.243.98.199"
local DB_PORT = 3308
local DB_NAME = "FTS"
local DB_USERNAME = ""
local DB_PASSWORD = ""

function postConnect(db)
	local qry = db:query("SELECT ID, Name, Cost FROM test WHERE Cost > 0.50")
	qry.onData = function(Q,D) print("Q1") PrintTable(D) end
	qry.onSuccess = printQuery
	qry.onError = function(Q,E) print("Q1") print(E) end
	qry:start()
end

function ConnectDB()
	local db = mysqloo.connect(DB_HOST, DB_USERNAME, DB_PASSWORD, DB_NAME, DB_PORT)
	db.onConnected = 
end
