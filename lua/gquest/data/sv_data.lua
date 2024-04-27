--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("gQuest.ConvertOldDataNotification");
util.AddNetworkString("gQuest.ConvertOldData");

local SQL = {};

---
--- CreateTables
---
function SQL:CreateTables()
    if (not sql.TableExists("gQuest_Quests")) then
        if (sql.Query([[CREATE TABLE gQuest_Quests (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            SteamID VARCHAR(17),
            CurrentQuests TEXT DEFAULT '',
            CompletedQuests TEXT DEFAULT '',
            QuestObjectives TEXT,
            QuestsAvailableForDeliver TEXT DEFAULT '',
            QuestsOnCooldown TEXT,
            Unique(SteamID)
        );]]) == false) then
            gQuest.Debug("SQL Error: %s", sql.LastError());
        else
            gQuest.Debug("Successfully created sql table: gQuest_Quests");
        end
    end

    if (not sql.TableExists("gQuest_NPCS_New")) then
        if (sql.Query([[CREATE TABLE gQuest_NPCS_New (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            Data TEXT
        );]]) == false) then
            gQuest.Debug("SQL Error: %s", sql.LastError());
        else
            gQuest.Debug("Successfully created sql table: gQuest_NPCS_New");
        end

        sql.Query("INSERT INTO gQuest_NPCS_New (Data) VALUES('[]')");
    end

    if (not sql.TableExists("gQuest_Objectives_New")) then
        if (sql.Query([[CREATE TABLE gQuest_Objectives_New (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            Data TEXT
        );]]) == false) then
            gQuest.Debug("SQL Error: %s", sql.LastError());
        else
            gQuest.Debug("Successfully created sql table: gQuest_Objectives_New");
        end

        sql.Query("INSERT INTO gQuest_Objectives_New (Data) VALUES('[]')");
    end

    if (not sql.TableExists("gQuest_Data")) then
        if (sql.Query([[CREATE TABLE gQuest_Data (
            ID INTEGER PRIMARY KEY AUTOINCREMENT,
            Data TEXT
        );]]) == false) then
            gQuest.Debug("SQL Error: %s", sql.LastError());
        else
            gQuest.Debug("Successfully created sql table: gQuest_Data");

            sql.Query("INSERT INTO gQuest_Data (Data) VALUES('[]')");
        end
    end
end

---
--- FormatSQL
---
function SQL:FormatSQL(formatString, ...)
	local repacked 	= {};
	local args		= {...};
	
	for _, arg in ipairs(args) do 
		table.insert(repacked, sql.SQLStr(arg, true));
	end

	return string.format(formatString, unpack(repacked));
end

---
--- DoSQLQuery
---
function SQL:DoSQLQuery(query)
    local query = sql.Query(query);
    if (query == false) then
        gQuest.Debug("ERROR: SQL Error while performing query[" .. sql.LastError() .. "]");

        return query;
    end

    return query, true;
end

---
--- CanConvertOldNPCS
---
function SQL:CanConvertOldNPCS()
    local query = sql.QueryRow("SELECT Data FROM gQuest_Data")["Data"];

    if (query == nil or query == "[]") then
        return true;
    end

    local formated = util.JSONToTable(query);
    for k, v in ipairs(formated) do
        return not v.HasAlreadyConvertedOldNPCS;
    end

    return true;
end

---
---
--- Update for: 100818
--- Converts old SQL Data to the new one.
---
function SQL:ConvertOldNPCS()
    if (not self:CanConvertOldNPCS()) then
        gQuest.Debug("ERROR: Trying to convert old npc data to the new formatting, but we've already done this.");

        return false;
    end

    local converted = {};
    local query = sql.Query("SELECT * FROM gQuest_NPCS");

    if (not query or not next(query)) then
        gQuest.Debug("ERROR: Can't convert old npcs to our new formatting because there are no npcs in the database.");

        sql.Query("DROP TABLE gQuest_NPCS");
        RunConsoleCommand("changelevel", game.GetMap());
        return true;
    end

    for k, v in ipairs(query) do
        table.insert(converted, {
            Angle = v.Angle;
            ID = v.ID;
            Model = v.Model,
            Position = v.Position;

            -- Header was changed from Name to Header.
            -- To keep it consitent with the other Sub Header we have now.
            Header = v.Name;
            
            -- This is what we brought in to the update of 100818
            SubHeader = "";
            HeaderColor = Vector(255, 255, 255);
            SubHeaderColor = Vector(255, 255, 255);
        });
    end

    -- Select our data from gQuest_Data Table
    local gQuest_Data = sql.QueryRow("SELECT Data FROM gQuest_Data")["Data"];

    -- Update our status for the converter data.
    local data = util.JSONToTable(gQuest_Data);
    table.insert(data, {HasAlreadyConvertedOldNPCS = true});

    data = util.TableToJSON(data);
    sql.Query("UPDATE gQuest_Data SET Data = '" .. data .. "'");

    -- Now we need to update the new gQuest Table with the old and converted information.
    local formated = util.TableToJSON(converted);
    sql.Query("UPDATE gQuest_NPCS_New SET Data = '" .. formated .. "'");
    sql.Query("DROP TABLE gQuest_NPCS");

    gQuest.Debug("SUCCESS: We have successfully converted our old data to the new format & it has been saved to the correct SQL Table.");

    RunConsoleCommand("changelevel", game.GetMap());
    return true;
end

hook.Add("Initialize", "gQuest.CreateSQLTables", function()
    SQL:CreateTables();
end);

hook.Add("PlayerInitialSpawn", "gQuest.AddToSQLTables", function(ply)
    if (not IsValid(ply) or ply:IsBot()) then
        return;
    end

    local query = sql.Query(SQL:FormatSQL([[INSERT OR IGNORE INTO gQuest_Quests (SteamID, QuestObjectives, QuestsOnCooldown) VALUES('%s', '%s', '%s')]], ply:SteamID64(), "[]", "[]"));
    if (query == false) then
        gQuest.Debug("SQL Error at PlayerInitialSpawn: %s", sql.LastError());
    end

    timer.Simple(2, function()
        if (IsValid(ply) and ply:HasAccessToGQMenu()) then
            if (sql.TableExists("gQuest_NPCS")) then
                net.Start("gQuest.ConvertOldDataNotification")
                net.Send(ply);
            end
        end
    end)
end);

net.Receive("gQuest.ConvertOldData", function(_, ply)
    if (not ply:HasAccessToGQMenu()) then
        return;
    end

    local SQL = gQuest.GetSQL();
    SQL:ConvertOldNPCS();
end);

---
--- GetSQL
---
function gQuest.GetSQL()
    return SQL;
end