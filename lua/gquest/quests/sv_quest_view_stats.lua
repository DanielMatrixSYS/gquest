--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("gQuest.RequestPlayerStats");
util.AddNetworkString("gQuest.PlayerStatsAccepted");
util.AddNetworkString("gQuest.RequestQuestChange");

function retrieveData(ply)
    local questData = {
        ["CurrentQuests"]       = "[]",
        ["QuestObjectives"]     = "[]",
        ["QuestCooldowns"]      = "[]",
        ["CompletedQuests"]     = "[]",
        ["DeliverableQuests"]   = "[]"
    };

    questData["CurrentQuests"]      = ply:GetPrivateGQString("CurrentQuests", "[]");
    questData["QuestObjectives"]    = ply:GetPrivateGQString("QuestObjectives", "[]");
    questData["QuestCooldowns"]     = ply:GetPrivateGQString("QuestCooldowns", "[]");
    questData["CompletedQuests"]    = ply:GetPrivateGQString("CompletedQuests", "[]");
    questData["DeliverableQuests"]  = ply:GetPrivateGQString("QuestsAvailableForDeliver", "[]");

    return questData;
end

net.Receive("gQuest.RequestPlayerStats", function(_, ply)
    local selectedPlayer = net.ReadEntity();

    if (IsValid(selectedPlayer)) then
        if (not ply:HasAccessToGQMenu()) then
            return;
        end

        ply:GQ_GiveAllQuests();

        local data = retrieveData(selectedPlayer);

        net.Start("gQuest.PlayerStatsAccepted")
            net.WriteString(selectedPlayer:Nick());
            net.WriteString(selectedPlayer:SteamID64());

            net.WriteString(data["CompletedQuests"]);
            net.WriteString(data["CurrentQuests"]);
            net.WriteString(data["DeliverableQuests"]);
            net.WriteString(data["QuestCooldowns"]);
            net.WriteString(data["QuestObjectives"]);
            
        net.Send(ply);
    end
end);

local questChangeFuncs = {
    [QUEST_COMPLETE] = {
        func = function(quest_id, steamid)
            local player = player.GetBySteamID64(steamid);

            if (not IsValid(player)) then
                -- Notification error.
            else
                player:GQ_CompleteQuest(quest_id, true, "uiNotificationForcedComplete");
            end
        end
    },

    [QUEST_REMOVE] = {
        func = function(quest_id, steamid)
            local player = player.GetBySteamID64(steamid);

            if (not IsValid(player)) then
                -- Notification error.
            else
                if (player:GQ_HasCompletedQuest(quest_id)) then
                    player:GQ_RemoveFromCompletionList(quest_id);
                else
                    player:GQ_RemoveFromTakenList(quest_id);
                end
            end
        end
    },

    [QUEST_REMOVE_CD] = {
        func = function(quest_id, steamid)
            local player = player.GetBySteamID64(steamid);

            if (not IsValid(player)) then

            else
                player:GQ_RemoveCooldownedQuest(quest_id);

                local questTable = gQuest.GetQuestTable(quest_id);
                player:SendGQTextNotification(true, "uiNotificationForcedRemovedCD", questTable.Name, gQuest.Red, 15);
            end
        end
    },

    [QUEST_RESET_OBJ] = {
        func = function(quest_id, steamid)
        
        end
    }
}

net.Receive("gQuest.RequestQuestChange", function(_, ply)
    if (not ply:HasAccessToGQMenu()) then
        return;
    end

    local cType     = net.ReadUInt(4);
    local quest_id  = net.ReadUInt(32);
    local steamid   = net.ReadString();

    questChangeFuncs[cType].func(quest_id, steamid);
end);