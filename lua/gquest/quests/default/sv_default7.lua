--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local QUEST = {};

QUEST.ID = 7
QUEST.NPC = 1;
QUEST.Name = "Terminator - PVP ";
QUEST.Description = "Hello, {name}.\n\nI have a mission for you, however, it is not like the other missions I have given out.\n\nI need you to take out a few people, yes, real humans.\n\nThis mission is not for the weak hearted and it will be difficult as if you die then the quest will fail.\n\nThe reason why I need a few people killed is because I need to test out the bodies, and I'm pretty sure they won't come kill themselevs at my command.";
QUEST.Objective = "Kill 5 people without dying.\n\nDying will cause the quest to fail.";
QUEST.HUDObjective = "Kill 5 players. Dying is not an option. {current}/{need}";
QUEST.OnCompleteDescription = "Holy, {name}. I never thought you would be able to do this, I salute you, soldier.";
QUEST.Rewards = "$30,000";
QUEST.LevelRequirement = 15;
QUEST.ObjectiveRequirement = 5;
QUEST.ObjectiveClass = "player";
QUEST.OneTimeQuest = false;
QUEST.Cooldown = 7200;
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
    hook.Add("PlayerDeath", "gQuest.DefaultQuest_7", function(victim, inflictor, attacker)
        if (IsValid(victim)) then
            if (victim:GQ_HasAcceptedQuest(self.ID)) then
                victim:GQ_AbandonQuest(self.ID, false);
                victim:GQ_PutQuestOnCooldown(self.ID, true);
                victim:SendGQTextNotification(true, "uiNotificationQuestFailed", self.Name, gQuest.Red, 10);
                victim:GQ_TrackQuest(self.ID, true);
            end

            if (IsValid(attacker) and attacker:IsPlayer()) then
                if (attacker:GQ_HasAcceptedQuest(self.ID)) then
                    attacker:GQ_AddQuestProgress(self.ID, 1);
                end
            end
        end
    end);

    return true;
end

gQuest.RegisterQuest(QUEST);