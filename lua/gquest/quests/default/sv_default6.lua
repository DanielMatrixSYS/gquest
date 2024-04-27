--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local QUEST = {};

QUEST.ID = 6;
QUEST.NPC = 1;
QUEST.Name = "Master Marksman - Contract";
QUEST.Description = "Hello, {name}.\n\nI have a contract here which says that you need to kill at least 3 citizens from at least 3200 units away.\n\nI trust you and only you with this one, {name}.";
QUEST.Objective = "Kill 3 citizens from at least 3200 units away.";
QUEST.HUDObjective = "Kill 3 citizens from 3,200 units away. {current}/{need}";
QUEST.OnCompleteDescription = "Wow! I'm impressed, {name}.\n\nI didn't think you had it in you!";
QUEST.Rewards = "$20,000";
QUEST.LevelRequirement = 10;
QUEST.ObjectiveRequirement = 3;
QUEST.ObjectiveClass = "npc_citizen";
QUEST.OneTimeQuest = false;
QUEST.Cooldown = 7200;
QUEST.Enabled = true;
QUEST.Sniper = "weapon_crossbow";

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
--- OnDelivered
---
function QUEST:OnDelivered()
    return true;
end

---
--- OnObjectiveSpawned
---
function QUEST:OnObjectiveSpawned(obj)
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
    hook.Add("OnNPCKilled", "gQuest.DefaultQuest_6", function(npc, ent)
        if (IsValid(npc) and IsValid(ent) and ent:IsPlayer()) then
            if (self.ObjectiveClass == npc:GetClass() and ent:GetActiveWeapon():GetClass() == self.Sniper) then
                if (ent:GQ_HasAcceptedQuest(self.ID)) then
                    if (npc:GetPos():DistToSqr(ent:GetPos()) >= 3200 ^ 2) then
                        ent:GQ_AddQuestProgress(self.ID, 1);
                    end
                end
            end
        end
    end);
    
    return true;
end

gQuest.RegisterQuest(QUEST);