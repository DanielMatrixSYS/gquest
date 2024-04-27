--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

net.Receive("gQuest.PlayerStatsAccepted", function()
    local nick      = net.ReadString();
    local steamid   = net.ReadString();
    
    local completedQuests   = net.ReadString();
    local currentQuests     = net.ReadString();
    local deliverableQuests = net.ReadString();
    local questCooldowns    = net.ReadString();
    local questObjectives   = net.ReadString();

    local questData = {
        ["CurrentQuests"]       = "[]",
        ["QuestObjectives"]     = "[]",
        ["QuestCooldowns"]      = "[]",
        ["CompletedQuests"]     = "[]",
        ["DeliverableQuests"]   = "[]"
    };

    questData["CurrentQuests"]      = currentQuests;
    questData["QuestObjectives"]    = questObjectives;
    questData["QuestCooldowns"]     = questCooldowns;
    questData["CompletedQuests"]    = completedQuests;
    questData["DeliverableQuests"]  = deliverableQuests;

    LocalPlayer().gQuest_QuestDatabase_Data = questData;
end);