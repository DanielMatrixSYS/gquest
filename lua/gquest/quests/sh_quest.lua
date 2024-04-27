--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

-- Helper variable for both server and client for the quest stats.
QUEST_COMPLETE      = 0x1;

QUEST_REMOVE        = 0x2;
QUEST_REMOVE_CD     = 0x3;

QUEST_RESET_OBJ     = 0x4;

---
--- GetQuestTable
---
function gQuest.GetQuestTable(quest_id)
    if (not quest_id) then
        return false;
    end
    
    for k, v in ipairs(gQuest.Quests) do
        if (v.ID == quest_id) then
            return v;
        end
    end

    print("NOTE:\nNOTE:\ngQuest attempted to find quest [", quest_id, "] but it doesn't exist.\nThis is not a gQuest internal error.\nPlease update the corresponding quest and its objectives.\nAn error will be thrown to further stop errors.\nNOTE:\nNOTE:");
    return false;
end

---
--- GetQuestName
---
function gQuest.GetQuestName(quest_id)
    quest_id = tonumber(quest_id);

    for k, v in ipairs(gQuest.Quests) do
        if (v.ID == quest_id) then
            return v.Name;
        end
    end

    return "unknown";
end

---
--- GQ_HasCompletedQuest
---
function gQuest.PLAYER:GQ_HasCompletedQuest(quest_id)
    local completedQuests = string.Explode(",", self:GetPrivateGQString("CompletedQuests", ""));

    for k, v in ipairs(completedQuests) do
        if (tonumber(v) == quest_id) then
            return true;
        end
    end

    return false;
end

---
--- GQ_IsDeliverable
---
function gQuest.PLAYER:GQ_IsDeliverable(quest_id)
    local deliverableQuests = string.Explode(",", self:GetPrivateGQString("QuestsAvailableForDeliver", ""));

    for k, v in ipairs(deliverableQuests) do
        if (tonumber(v) == quest_id) then
            return true;
        end
    end

    return false;
end