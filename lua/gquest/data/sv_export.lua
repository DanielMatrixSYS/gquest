--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("gQuest.ExportData");
util.AddNetworkString("gQuest.ExportFinished");

net.Receive("gQuest.ExportData", function(_, ply)
    if (not IsValid(ply) or not ply:HasAccessToGQMenu()) then
        return;
    end

    if (not file.IsDir("gquest_export", "DATA")) then
        file.CreateDir("gquest_export");
    end

    local npc_data = sql.Query("SELECT * FROM gQuest_NPCS_New");
    local objective_data = sql.Query("SELECT * FROM gQuest_Objectives");
    local completed = 0;

    if (npc_data and next(npc_data)) then
        local data = npc_data[1]["Data"];

        file.Write("gquest_export/gquest_npcs_new.txt", data);
        completed = completed + 1;
    end

    if (objective_data and next(objective_data)) then
        local data = {};
        
        for k, v in ipairs(objective_data) do
            table.insert(data, v);
        end

        file.Write("gquest_export/gquest_objectives.txt", util.TableToJSON(data));
        completed = completed + 1;
    end

    if (completed > 0) then
        net.Start("gQuest.ExportFinished") net.Send(ply);
    end
end);