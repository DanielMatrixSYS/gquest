--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("gQuest.UI");
util.AddNetworkString("gQuest.AcceptQuest");
util.AddNetworkString("gQuest.AbandonQuest");
util.AddNetworkString("gQuest.Deliver");
util.AddNetworkString("gQuest.GiveAllQuests");
util.AddNetworkString("gQuest.TrackQuest");
util.AddNetworkString("gQuest.RemoveQuests");
util.AddNetworkString("gQuest.DeleteQuestData");
util.AddNetworkString("gQuest.DeleteNPCData");
util.AddNetworkString("gQuest.DeleteObjData");
util.AddNetworkString("gQuest.QuestRefresh");
util.AddNetworkString("gQuest.DeleteAllData");

---
--- giveUserUI
---
local function giveUserUI(ply)
    local npcs = gQuest.GetAllNPCS();
    local objs = gQuest.GetAllObjectives();

    if (not objs) then
        objs = {};
    end

    local npc_data = util.JSONToTable(npcs);
    net.Start("gQuest.UI");
        net.WriteTable(npc_data);
        net.WriteTable(objs);
    net.Send(ply);
end

hook.Add("PlayerSay", "gQuest.OpenMenu", function(ply, text)
    if (not IsValid(ply)) then
        return;
    end

    if (text:lower():sub(1, 7) == "!gquest" or text:lower():sub(1, 7) == "/gquest") then
        if (not ply:HasAccessToGQMenu()) then
            ply:SendGQTextNotification(true, "uiUIDenied", ply:Nick(), gQuest.Red, 10);

            return "";
        end

        giveUserUI(ply);

        return "";
    end
end);

net.Receive("gQuest.AcceptQuest", function(_, ply)
    local quest     = net.ReadUInt(32);
    local questName = net.ReadString();
    
    ply:GQ_AcceptQuest(quest, questName);
end);

net.Receive("gQuest.AbandonQuest", function(_, ply)
    local quest = net.ReadUInt(32);

    ply:GQ_AbandonQuest(quest);
end);

net.Receive("gQuest.Deliver", function(_, ply)
    local quest = net.ReadUInt(32);

    ply:GQ_CompleteQuest(quest);
end);

net.Receive("gQuest.RemoveQuests", function(_, ply)
    if (not IsValid(ply) or not ply:HasAccessToGQMenu()) then
        return;
    end

    local quests = string.Explode(",", net.ReadString());
    if (not quests or not next(quests) or quests[1] == "") then
        return;
    end

    local p = net.ReadEntity();
    if (not IsValid(p)) then
        return;
    end

    for k, v in ipairs(quests) do
        local v = tonumber(v);
        local questTable = gQuest.GetQuestTable(v);
        local name;

        if (not questTable or not next(questTable)) then
            name = "<Quest No Longer Exists>";
        else
            name = questTable.Name;
        end
        
        if (not p:GQ_HasAcceptedQuest(v)) then
            ply:SendGQTextNotification(true, "dbNotAccepted", name, gQuest.Red, 5);

            continue;
        end

        p:GQ_AbandonQuest(v, false);
        p:SendGQTextNotification(true, "dbRemoveNotifyHeader", name, gQuest.Red, 7);
        ply:SendGQTextNotification(true, "dbRemoved", name, gQuest.Green, 5);

        gQuest.Debug("SUCCESS: Administrator[" .. ply:Nick() .. "," .. ply:SteamID64() .. "] has removed quest[" .. v .. ", " .. name .. "] from player[" .. p:Nick() .. ", " .. p:SteamID64() .. "]");
    end
end);

net.Receive("gQuest.DeleteQuestData", function(_, ply)
    if (not IsValid(ply) or not ply:HasAccessToGQMenu()) then
        return;
    end

    sql.Query("DROP TABLE gQuest_Quests");
    RunConsoleCommand("changelevel", game.GetMap());
end);

net.Receive("gQuest.DeleteNPCData", function(_, ply)
    if (not IsValid(ply) or not ply:HasAccessToGQMenu()) then
        return;
    end

    sql.Query("DROP TABLE gQuest_NPCS_New");
    RunConsoleCommand("changelevel", game.GetMap());
end);

net.Receive("gQuest.DeleteObjData", function(_, ply)
    if (not IsValid(ply) or not ply:HasAccessToGQMenu()) then
        return;
    end

    sql.Query("DROP TABLE gQuest_Objectives_New");
    RunConsoleCommand("changelevel", game.GetMap());
end);

net.Receive("gQuest.DeleteAllData", function(_, ply)
    if (not IsValid(ply) or not ply:HasAccessToGQMenu()) then
        return;
    end

    sql.Query("DROP TABLE gQuest_Objectives_New");
    sql.Query("DROP TABLE gQuest_NPCS_New");
    sql.Query("DROP TABLE gQuest_Quests");

    RunConsoleCommand("changelevel", game.GetMap());
end);

net.Receive("gQuest.QuestRefresh", function(_, ply)
    if (not ply:IsSuperAdmin()) then
        return;
    end

    local players   = player.GetAll();
    local count     = player.GetCount();

    for i = 1, count do
        local player = players[i];

        if (player:IsBot()) then
            continue;
        end

        player:GQ_GiveAllQuests();
    end
end);

---
--- DoQuestCheck
---
local function DoQuestCheck(ply)
    if (DarkRP) then
        local acceptedQuests = string.Explode(",", ply:GetPrivateGQString("CurrentQuests", ""));
        
        if (not acceptedQuests or not next(acceptedQuests) or acceptedQuests[1] == "") then
            return;
        end

        for k, v in ipairs(acceptedQuests) do
            local v = tonumber(v);

            local shouldHaveQuest   = ply:GQ_CheckForList(v);
            local questTable        = gQuest.GetQuestTable(v);

            if (not shouldHaveQuest) then
                ply:GQ_AbandonQuest(v, false);
                ply:SendGQTextNotification(true, "uiNotificationAbandonedDueToJob", questTable.Name, gQuest.Red, 8);
            end
        end
    end
end

hook.Add("PlayerInitialSpawn", "gQuest.GiveAllQuests", function(ply)
    timer.Simple(2, function()
        if (not IsValid(ply) or ply:IsBot()) then
            return;
        end

        ply:GQ_GiveAllQuests();
        DoQuestCheck(ply);
        ply:GQ_UpdateQuests();
    end);
end);

hook.Add("OnPlayerChangedTeam", "gQuest.RemoveQuestOnChange", function(ply, before, after)
    DoQuestCheck(ply);
end);

hook.Add("PlayerDisconnected", "gQuest.RemoveQuestsOnServerLeave", function(ply)
    if (gQuest.RemoveQuestsOnServerLeave) then
        local currentQuests = string.Explode(",", ply:GetPrivateGQString("CurrentQuests", ""));

        for _, v in ipairs(currentQuests) do
            local v = tonumber(v);

            if (ply:GQ_IsDeliverable(v)) then
                if (gQuest.RemoveCompletedQuestsOnServerLeave) then
                    ply:GQ_AbandonQuest(v);
                else
                    continue;
                end
            else
                ply:GQ_AbandonQuest(v);
            end
        end
    end
end);

---
--- openUserInterfaceConCommand
---
local function openUserInterfaceConCommand(ply)
    if (not ply:HasAccessToGQMenu()) then
        return;
    end

    giveUserUI(ply);
end
concommand.Add("gquest_admin_menu", openUserInterfaceConCommand, _, _, FCVAR_CLIENTCMD_CAN_EXECUTE);