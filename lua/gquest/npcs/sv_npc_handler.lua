--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("gQuest.CreateNPC");
util.AddNetworkString("gQuest.RespawnNPCS");
util.AddNetworkString("gQuest.SaveAllNPCS");
util.AddNetworkString("gQuest.SaveChanges");
util.AddNetworkString("gQuest.DeleteQuestNPCS");

net.Receive("gQuest.CreateNPC", function(_, ply)
    if (not IsValid(ply) or not ply:HasAccessToGQMenu()) then
        return;
    end

    local count = net.ReadUInt(8);
    local data  = {};

    for i = 1, count do
        local value = net.ReadString();

        table.insert(data, value);
    end

    local header            = data[1];
    local subHeader         = data[2];
    local model             = data[3];
    local int_sound         = data[4]
    local headerColor       = data[5];
    local subHeaderColor    = data[6];
    local position          = data[7];
    local angle             = data[8];

    gQuest.CreateNPC(header, subHeader, headerColor, subHeaderColor, model, int_sound, position, angle, false);

    local col = string.ToColor(headerColor);
    ply:SendGQTextNotification(true, "uiNotificationCreated", header, col, 5);
end);

net.Receive("gQuest.RespawnNPCS", function(_, ply)
    if (not IsValid(ply) or not ply:HasAccessToGQMenu()) then
        return;
    end

    local bool = net.ReadBool();
    gQuest.SpawnAllNPCS(bool);

    if (not bool) then
        ply:SendGQTextNotification(true, "uiNotificationRespawn", "", gQuest.RoyalBlue, 5);
    else
        ply:SendGQTextNotification(true, "uiNotificationDespawned", "", gQuest.RoyalBlue, 5);
    end
end);

net.Receive("gQuest.SaveAllNPCS", function(_, ply)
    if (not IsValid(ply) or not ply:HasAccessToGQMenu()) then
        return;
    end

    gQuest.SaveAllNPCS();
    ply:SendGQTextNotification(true, "uiNotificationSaveNPCS", "", gQuest.RoyalBlue, 5);
end);

net.Receive("gQuest.SaveChanges", function(_, ply)
    if (not IsValid(ply) or not ply:HasAccessToGQMenu()) then
        return;
    end

    local count = net.ReadUInt(8);
    local data  = {};

    for i = 1, count do
        local value = net.ReadString();

        table.insert(data, value);
    end

    local header            = data[1];
    local subHeader         = data[2];
    local model             = data[3];
    local int_sound         = data[4];
    local headerColor       = data[5];
    local subHeaderColor    = data[6];
    local position          = data[7];
    local angle             = data[8];
    local npc               = data[9];

    local query     = sql.QueryRow("SELECT Data FROM gQuest_NPCS_New");
    local sql_data  = util.JSONToTable(query["Data"]);

    for k, v in ipairs(sql_data) do
        if (tonumber(v.ID) == tonumber(npc)) then
            v.Header            = header;
            v.SubHeader         = subHeader;
            v.HeaderColor       = headerColor;
            v.SubHeaderColor    = subHeaderColor;
            v.Model             = model;
            v.IntSound          = int_sound;
            v.Position          = position;
            v.Angle             = angle;
            v.Map               = game.GetMap();
        end
    end

    sql.Query("UPDATE gQuest_NPCS_New SET Data = '" .. util.TableToJSON(sql_data) .. "'");

    gQuest.SpawnAllNPCS();
    ply:SendGQTextNotification(true, "uiNotificationChangesSaved", "", gQuest.RoyalBlue, 5);
end);

net.Receive("gQuest.DeleteQuestNPCS", function(_, ply)
    if (not IsValid(ply) or not ply:HasAccessToGQMenu()) then
        return;
    end

    local count     = net.ReadUInt(8);
    local npc_ids   = {};

    for i = 1, count do
        local id = net.ReadString();

        table.insert(npc_ids, id);
    end

    gQuest.DeleteNPC(npc_ids);
    ply:SendGQTextNotification(true, "uiNotificationDeleteNPCS", "", gQuest.RoyalBlue, 5);
end);

hook.Add("InitPostEntity", "gQuest.SpawnNPCS", function()
    gQuest.SpawnAllNPCS();
end);

hook.Add("PostCleanupMap", "gQuest.SpawnNPCSAfterCleanup", function()
    gQuest.SpawnAllNPCS();
end);

hook.Add("ShouldCollide", "gQuest.NoCollide", function(ent, collider)
    if (IsValid(ent) and IsValid(collider)) then
        if (ent.GetID and gQuest.NPCNoCollided) then
            return false;
        end
    end
end);