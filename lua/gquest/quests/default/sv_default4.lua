--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local QUEST = {};

QUEST.ID = 4;
QUEST.NPC = 1;
QUEST.Name = "Bloody Mess";
QUEST.Description = "Ah, {name} I'm glad to see you again, since Dr. James's fall I have accepted a quest myself, you see!\n\nI will be creating a antidote for the virus, but I do require some.. Uh.. Blood. Yes, blood from the zombies is what I need.\n\nCan you get me some.. Blood?";
QUEST.Objective = "Take out and retrieve blood from the corpses of the zombies.";
QUEST.HUDObjective = "Eliminate the zombies then retrieve the blood jars from their corpses. {current}/{need}";
QUEST.OnCompleteDescription = "Nice job, {name}.\n\nThis should help me with the antidote. Here is your reward as promised.";
QUEST.Rewards = "$15,000";
QUEST.LevelRequirement = 10;
QUEST.ObjectiveRequirement = 10;
QUEST.NeedsToHaveCompleted = {1, 2};
QUEST.ObjectiveClass = {"npc_zombie", "blood_jar"};
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
    hook.Add("OnNPCKilled", "gQuest.DefaultQuest_4", function(npc, ent)
        if (IsValid(npc) and IsValid(ent) and ent:IsPlayer()) then
            if (type(self.ObjectiveClass) == "table" and table.HasValue(self.ObjectiveClass, npc:GetClass()) or type(self.ObjectiveClass) == "string" and self.ObjectiveClass == npc:GetClass()) then
                if (ent:GQ_HasAcceptedQuest(self.ID)) then
                    local jar = ents.Create("blood_jar");
                    jar:SetPos(npc:GetPos() + Vector(0, 0, 5));
                    jar:Spawn();
                end
            end
        end
    end);

    hook.Add("PlayerUse", "gQuest.DefaultQuest_4", function(ply, ent)
        if (IsValid(ply) and IsValid(ent)) then
            if (ent:GetClass() == "blood_jar") then
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