local db = BaseWars.MySQL and BaseWars.MySQL.DbObj or nil
BaseWars.MySQL = {}
BaseWars.MySQL.DbObj = db
-- Do not touch the lines above this info!

-- Put your database info here
BaseWars.MySQL.User = ""
BaseWars.MySQL.Password = ""
BaseWars.MySQL.Database = ""
BaseWars.MySQL.Table = "basewars"

BaseWars.MySQL.Host = ""
BaseWars.MySQL.Port = 3306

-- If you want to enable MySQL, install this module:
-- https://facepunch.com/showthread.php?t=1442438
-- Then create a table using the packaged basewars.sql template
-- If you cannot figure out how to do this, don't use MySQL, and don't complain.

-- Also, please note, there is NO SUPPORT FOR IMPORTING LEGACY DATA OR BACKPORTING SQL
-- If you turn MySQL on or off, you will lose your previous economy data!
BaseWars.MySQL.Enabled = false

-- Do not go below here unless you want to break things
-- if its a mysql issue make sure it's not your own fault before
-- you make a support ticket
if BaseWars.MySQL.Enabled then
	pcall(require, "tmysql4")

	if not tmysql then
		BaseWars.MySQL.Enabled = false
		ErrorNoHalt("BaseWars MySQL requires the tmysql4 module!\nhttps://facepunch.com/showthread.php?t=1442438\n")

		BaseWars.UTIL.Log("Started up using legacy data method! (Failed to load tmysql4)")
	else
		BaseWars.UTIL.Log("Started up using tMySQL4!")
	end
else
	BaseWars.UTIL.Log("Started up using legacy data method!")
end

file.CreateDir("basewars")

local function isPlayer(ply)
	return (IsValid(ply) and ply:IsPlayer())
end

function BaseWars.MySQL.GetDir(ply)
	return isPlayer(ply) and ply:SteamID64() or (isstring(ply) and ply)
end

function BaseWars.MySQL.Connect(callback)
	if not BaseWars.MySQL.Enabled then return end

	if BaseWars.MySQL.DbObj then
		BaseWars.MySQL.Disconnect()
	end

	local err
	BaseWars.MySQL.DbObj, err = tmysql.initialize(BaseWars.MySQL.Host, BaseWars.MySQL.User, BaseWars.MySQL.Password, BaseWars.MySQL.Database, BaseWars.MySQL.Port, nil, CLIENT_MULTI_STATEMENTS)

	if err or not BaseWars.MySQL.DbObj then
		BaseWars.MySQL.Enabled = false
		error("BaseWars-MySQL: Failed to connect database with following reason:\n"..(err or "Database Object was nil!").."\nFalling back to legacy data method!")
	else
		BaseWars.UTIL.Log("Database connection successful!")

		if callback then
			callback()
		end
	end
end

function BaseWars.MySQL.Disconnect()
	if not BaseWars.MySQL.Enabled then return end

	if BaseWars.MySQL.DbObj then
		BaseWars.MySQL.DbObj:Disconnect()
	end
end

-- This looks retarded, I know, it's because the legacy data method makes different bits of the database at different times
-- But MySQL has to generate the entire row at once

function BaseWars.MySQL.FullInitPlayer(ply)
	if not BaseWars.MySQL.Enabled then
		hook.Run("LoadData", ply)
		timer.Simple(0, function() if IsValid(ply) then hook.Run("PostLoadData", ply) end end)

		return
	end

	if not BaseWars.MySQL.DbObj then
		ErrorNoHalt("Database object became invalid during FullInitPlayer, reattempting connection")

		return BaseWars.MySQL.Connect(function()
			if not (isentity(ply) and IsValid(ply) or ply) then return end

			BaseWars.MySQL.FullInitPlayer(ply)
		end)
	end

	local dirName = BaseWars.MySQL.GetDir(ply)
	local defMoney = BaseWars.Config.StartMoney or 5000

	local q
	q = [[INSERT IGNORE INTO ]]..BaseWars.MySQL.Table
	q = q .. [[ (sid64,money)]]
	q = q .. [[ VALUES (']]..dirName..[[',]]..defMoney..[[);]]

	local n = isentity(ply) and ply:Nick() or ply
	local c = function(r)
		if not r[1] then
			error("BaseWars-MySQL: INIT - Empty result object for in database for " .. n)
		end

		if not r[1].status then
			error("BaseWars-MySQL: INIT - Failed to insert new row, error message:" .. (r[1].error or "No error message??!?!"))
		end

		if IsValid(ply) then
			hook.Run("LoadData", ply)
			timer.Simple(2, function() if IsValid(ply) then hook.Run("PostLoadData", ply) end end)
		end
	end
	BaseWars.MySQL.DbObj:Query(q, c)
end

function BaseWars.MySQL.InitPlayer(ply, var, initial, ignorePre122)
	if BaseWars.MySQL.Enabled then
		return
	end

	local dirName = BaseWars.MySQL.GetDir(ply)
	if not dirName then return end

	if not file.IsDir("basewars/" .. dirName, "DATA") then file.CreateDir("basewars/" .. dirName) end
	if not file.Exists("basewars/" .. dirName .. "/" .. var .. ".txt", "DATA") then
		local old_data = BaseWars.UTIL.GetPre122Data(ply)
		local val = (not ignorePre122 and old_data and tonumber(old_data[var] or 0) ~= 0 and old_data[var]) or initial

		file.Write("basewars/" .. dirName .. "/" .. var .. ".txt", val)
	end
end

function BaseWars.MySQL.SaveVar(ply, var, val, callback)
	local dirName = BaseWars.MySQL.GetDir(ply)
	if not dirName then return end

	if BaseWars.MySQL.Enabled then
		if not BaseWars.MySQL.DbObj then
			ErrorNoHalt("Database object became invalid during SaveVar, reattempting connection")

			return BaseWars.MySQL.Connect(function()
				if not (isentity(ply) and IsValid(ply) or ply) then return end

				BaseWars.MySQL.SaveVar(ply, var, val, callback)
			end)
		end

		local n = isentity(ply) and ply:Nick() or ply
		local c = function(r)
			if not r[1] then
				error("a BaseWars-MySQL: Empty result object for  `" .. var .. "` in database for " .. n)
			end

			if not r[1].status then
				error("b BaseWars-MySQL: Failed to save variable `" .. var .. "` in database for " .. n .. ", error message:" .. (r[1].error or "No error message??!?!"))
			end

			if callback then callback(ply, var, val) end
		end

		local q = "UPDATE "..BaseWars.MySQL.Table.." SET "..var.."="..val.." WHERE sid64='"..dirName.."';"
		BaseWars.MySQL.DbObj:Query(q, c)

		return
	end

	file.Write("basewars/" .. dirName .. "/" .. var .. ".txt", val)
	if callback then callback(ply, var, val) end
end

function BaseWars.MySQL.LoadVar(ply, var, callback)
	local dirName = BaseWars.MySQL.GetDir(ply)
	if not dirName then return end

	if BaseWars.MySQL.Enabled then
		if not BaseWars.MySQL.DbObj then
			ErrorNoHalt("Database object became invalid during LoadVar, reattempting connection")

			return BaseWars.MySQL.Connect(function()
				if not (isentity(ply) and IsValid(ply) or ply) then return end

				BaseWars.MySQL.LoadVar(ply, var, callback)
			end)
		end

		local c = function(r)
			local n = isentity(ply) and ply:Nick() or ply
			if not r[1] then
				error("c BaseWars-MySQL: Empty result object for  `" .. var .. "` in database for " .. n)
			end

			if not r[1].status then
				error("d BaseWars-MySQL: Failed to load variable `" .. var .. "` in database for " .. n .. ", error message:" .. (r[1].error or "No error message??!?!"))
			end

			if not r[1].data then
				error("e BaseWars-MySQL: Empty data for  `" .. var .. "` in database for " .. n)
			end

			if not r[1].data[1] then
				error("f BaseWars-MySQL: Empty data[1] object for  `" .. var .. "` in database for " .. n)
			end

			if not r[1].data[1][var] then
				error("g BaseWars-MySQL: Empty data[1].var (what should be the value we wanted) object for  `" .. var .. "` in database for " .. n)
			end

			if callback then callback(ply, var, r[1].data[1][var]) end
		end

		local q = "SELECT "..var.." FROM "..BaseWars.MySQL.Table.." WHERE sid64='"..dirName.."';"
		BaseWars.MySQL.DbObj:Query(q, c)

		return
	end

	local val = file.Read("basewars/" .. dirName .. "/" .. var .. ".txt", val)
	if not val then error("BaseWars-MySQL: Attempting to load non-inited player (missing/empty file)") end

	if callback then callback(ply, var, val) end
end
