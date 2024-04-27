--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("gQuest.CreateObjective");
util.AddNetworkString("gQuest.SaveObjectives");
util.AddNetworkString("gQuest.DeleteObjectives");

net.Receive("gQuest.CreateObjective", function(_, ply)
    if (not IsValid(ply) or not ply:HasAccessToGQMenu()) then
        return;
    end

    local count = net.ReadUInt(8);
    local data  = {};

    for i = 1, count do
        local value = net.ReadString();

        table.insert(data, value);
    end

    local name      = data[1];
    local class     = data[2];
    local quests    = data[3];
    local position  = data[4];
    local angle     = data[5];

    gQuest.CreateObjective(name, class, quests, position, angle);
end);

net.Receive("gQuest.SaveObjectives", function(_, ply)
    if (not IsValid(ply) or not ply:HasAccessToGQMenu()) then
        return;
    end

    local count = net.ReadUInt(8);
    local objid = net.ReadUInt(16);
    local data  = {};

    for i = 1, count do
        local value = net.ReadString();

        table.insert(data, value);
    end

    local name      = data[1];
    local entity    = data[2];
    local quests    = data[3];
    local position  = data[4];
    local angle     = data[5];

    local query     = sql.QueryRow("SELECT Data FROM gQuest_Objectives_New");
    local sql_data  = util.JSONToTable(query["Data"]);

    for k, v in ipairs(sql_data) do
        if (tonumber(v.ID) == objid) then
            v.Name      = name;
            v.Entity    = entity;
            v.Quests    = quests;
            v.Position  = position;
            v.Angle     = angle;
        end
    end

    sql.Query("UPDATE gQuest_Objectives_New SET Data = '" .. util.TableToJSON(sql_data) .. "'");
    ply:SendGQTextNotification(true, "uiNotificationChangesSaved", "", gQuest.RoyalBlue, 5);
end);

net.Receive("gQuest.DeleteObjectives", function(_, ply)
    if (not IsValid(ply) or not ply:HasAccessToGQMenu()) then
        return;
    end

    local count     = net.ReadUInt(8);
    local obj_ids   = {};

    for i = 1, count do
        local id = net.ReadString();

        table.insert(obj_ids, id);
    end

    gQuest.DeleteObjective(obj_ids);
end);

hook.Add("gQuest_QuestAccepted", "gQuest.SpawnObjectives", function(ply, quest_id)
    gQuest.SpawnQuestObjectives(quest_id);
end);

hook.Add("gQuest_QuestAbandoned", "gQuest.RemoveNPCS", function(ply, quest_id)
    gQuest.DoAbandonedCheck(quest_id);
end);

hook.Add("gQuest_QuestCompleted", "gQuest.RemoveNPCSOnCompleted", function(ply, quest_id)
    gQuest.DoAbandonedCheck(quest_id);
end);

hook.Add("PlayerInitialSpawn", "gQuest.SpawnNPCSUponJoin", function(ply)
    timer.Simple(3, function()
        if (IsValid(ply)) then
            local quests = string.Explode(",", ply:GetPrivateGQString("CurrentQuests", ""));

            if (not quests or quests[1] == "") then
                return;
            end

            for k, v in ipairs(quests) do
                gQuest.SpawnQuestObjectives(tonumber(v));
            end
        end
    end);
end);

hook.Add("PlayerDisconnect", "gQuest.CheckOnPlayerLeave", function(ply)
    local quests = string.Explode(",", ply:GetPrivateGQString("CurrentQuests", ""));
    if (not quests or quests[1] == "") then
        return;
    end

    for k, v in ipairs(quests) do
        gQuest.DoAbandonedCheck(tonumber(v));
    end
end);

hook.Add("EntityRemoved", "gQuest.RespawnEntity", function(ent)
    if (not IsValid(ent) or not ent.GQInfo or ent.PermanentRemoved) then
        return;
    end

    gQuest.ObjectiveRespawn(ent.GQInfo);
end);

local nextTick = CurTime() + 5;
hook.Add("Tick", "gQuest.CheckObjectiveSpawns", function()
    if (nextTick > CurTime()) then
        return;
    end

    gQuest.CheckObjectives();
    nextTick = CurTime() + 1;
end);