--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local QUEST = {};

QUEST.ID = 2;
QUEST.NPC = 1;
QUEST.Name = "Zombie Threat";
QUEST.Description = "The virus that were released with Dr. James's death has caused multiple people to become infected as well, unfortunately.\n\nThe city needs a cleaner and I am nominating you for that role, {name}.";
QUEST.Objective = "Find and kill 10 infected humans then return to me for your reward, {name}. I'm looking forward to seeing you in action again.";
QUEST.HUDObjective = "Eliminate 10 infected humans. {current}/{need}";
QUEST.OnCompleteDescription = "I'm impressed, {name}.\n\nThe city is yet again safe due to your heroic actions.\n\nHere, your reward as promised.";
QUEST.Rewards = "$12,500";
QUEST.NeedsToHaveCompleted = 1;
QUEST.ObjectiveRequirement = 10;
QUEST.ObjectiveClass = "npc_zombie";
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
    hook.Add("OnNPCKilled", "gQuest.DefaultQuest_2", function(npc, ent)
        if (IsValid(npc) and IsValid(ent) and ent:IsPlayer()) then
            if (type(self.ObjectiveClass) == "table" and table.HasValue(self.ObjectiveClass, npc:GetClass()) or type(self.ObjectiveClass) == "string" and self.ObjectiveClass == npc:GetClass()) then
                if (ent:GQ_HasAcceptedQuest(self.ID)) then
                    ent:GQ_AddQuestProgress(self.ID, 1);
                end
            end
        end
    end);

    return true;
end

gQuest.RegisterQuest(QUEST);