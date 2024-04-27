--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local QUEST = {};

QUEST.ID = 3;
QUEST.NPC = 1;
QUEST.Name = "Urdasium Canisters";
QUEST.Description = "Hello, {name}, as you know I am a scientist and I do.. Scientist things, so, obviously in order for me to do my scientist things I need scientist components.\n\nI am currently running low on Urdasium Gas, would you be able to get some for me?\n\nYou will be rewarded accordingly.";
QUEST.Objective = "Retrieve 5 canisters of Urdasium Gas for this very suspicous scientist.";
QUEST.HUDObjective = "Locate and return {need} canisters of gas. {current}/{need}";
QUEST.OnCompleteDescription = "Be careful, {name}!\n\nThese canisters are full of Urdasium, let me take them away from you..\n\nGoodness gracious that was close. Here, your reward.";
QUEST.Rewards = "$7,500";
QUEST.LevelRequirement = 5;
QUEST.ObjectiveRequirement = 5;
QUEST.ObjectiveClass = "urdasium_canister";
QUEST.OneTimeQuest = false;
QUEST.Cooldown = 3600;
QUEST.Enabled = true;

---
--- OnAccept
---
function QUEST:OnAccept(ply)
    return true;
end

---
--- OnCompleted
---
function QUEST:OnCompleted(ply)
    return true;
end

---
--- OnObjectiveUpdated
---
function QUEST:OnObjectiveUpdated(ply)
    return true;
end

---
--- OnObjectiveSpawned
---
function QUEST:OnObjectiveSpawned(obj)
    return true;
end

---
--- OnDelivered
---
function QUEST:OnDelivered()
    return true;
end

---
--- OnQuestDisbanded
---
function QUEST:OnQuestDisbanded(ply)
    return true;
end

---
--- RewardFunction
---
function QUEST:RewardFunction(ply)
    return true;
end

---
--- OnQuestInitialized
---
function QUEST:OnQuestInitialized()
    hook.Add("PlayerUse", "gQuest.DefaultQuest_3", function(ply, ent)
        if (IsValid(ply) and IsValid(ent)) then
            if (type(self.ObjectiveClass) == "table" and table.HasValue(self.ObjectiveClass, ent:GetClass()) or type(self.ObjectiveClass) == "string" and self.ObjectiveClass == ent:GetClass()) then
                if (ply:GQ_HasAcceptedQuest(self.ID)) then
                    ply:GQ_AddQuestProgress(self.ID, 1);

                    ent:Remove();
                end
            end
        end
    end);

    return true;
end

gQuest.RegisterQuest(QUEST);