--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local QUEST = {};

QUEST.ID = 5;
QUEST.NPC = 1;
QUEST.Name = "Spoken Matters";
QUEST.Description = "Hi {name}, it seems you've stumbled upon me. I have an issue if you're willing to listen.\n\nYou see, there was a monk that was suppose to come visit me, in fact, he was suppose to help me with, you know, monk thinks.\n\nHowever, it seems the monk has gone missing, would you be able to find him?";
QUEST.Objective = "Seek and speak to Alvin, the forgotten monk.";
QUEST.HUDObjective = "Speak with Alvin.";
QUEST.OnCompleteDescription = "You found Alvin? Nice! I think he needs stuff done so if you need quests again then I'd see him.";
QUEST.Rewards = "$10,000";
QUEST.LevelRequirement = 5;
QUEST.ObjectiveRequirement = 1;
QUEST.OneTimeQuest = true;
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
    hook.Add("PlayerUse", "gQuest.DefaultQuest_5", function(ply, ent)
        if (IsValid(ply) and IsValid(ent)) then
            if (ent:GetClass() == "quest" and ent:GetID() == 2) then
                if (ply:GQ_HasAcceptedQuest(self.ID)) then
                    ply:GQ_AddQuestProgress(self.ID, 1);
                end
            end
        end
    end);

    return true;
end

gQuest.RegisterQuest(QUEST);