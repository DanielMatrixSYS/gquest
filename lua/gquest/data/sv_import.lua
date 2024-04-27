--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("gQuest.ImportData");
util.AddNetworkString("gQuest.ImportFinished");

net.Receive("gQuest.ImportData", function(_, ply)
    if (not IsValid(ply) or not ply:HasAccessToGQMenu()) then
        return;
    end

    local files, folders = file.Find("gquest_import/*", "DATA");
    local filesFound = #files;
    local npc_data = "";
    local obj_data = "";

    for k, v in ipairs(files) do
        if (v == "gquest_npcs_new.txt") then
            npc_data = file.Read("gquest_import/" .. v, "DATA");
        else
            obj_data = file.Read("gquest_import/" .. v, "DATA");
        end
    end

    if (npc_data ~= "") then
        sql.Query("UPDATE gQuest_NPCS_New SET Data = '" .. npc_data .. "'")

        gQuest.Debug("Successfully imported NPC data.")
    end

    if (obj_data ~= "") then
        local data = util.JSONToTable(obj_data);

        for k, v in ipairs(data) do
            gQuest.CreateObjective(v.Entity, v.Quests, v.Position, v.Angle)
        end

        gQuest.Debug("Successfully imported OBJECTIVE data.")
    end

    if (npc_data ~= "" or obj_data ~= "") then
        net.Start("gQuest.ImportFinished") net.Send(ply);
    end
end);