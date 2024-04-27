--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local QUEST = {};

QUEST.ID = 1;
QUEST.NPC = 1;
QUEST.Name = "Virus Threat";
QUEST.PreQuestConversationEnabled = true;
QUEST.PreQuestConversation = {
    title = "City Virus - Introduction.", 
    desc = "Ah, {name}! I'm glad you ran into me.\n\nI was studying a new virus which Dr. James and his apprentices cooked up in his laboratory.\n\nI was unable to finish the study because Dr. James had a breakthrough and needed the virus moved to the other side of town.\n\n30 minutes after they left however, it seemed they've gone off the radar.\n\nI need you to go and look for them. I would also carry a gun if I were you.. You know, just incase.", 
    answers = {
        ["What would happen if the virus broke loose?"] = {
            title = "City Virus - Catastrophic.",
            desc = "The result of it being broken could lead to some very catastrophic things.\n\nThe virus is highly infectious and if they've been exposed to it then I'm afraid the chances of their survival is... Extremely low, to say the least.",
            answers = {
                ["Why can't you go?"] = {
                    title = "City Virus - Professional",
                    desc = "Look, I'm a scientist and I have no experiences with weapons and I'm going to assume you do so, what do you say?\n\nWill you look for Dr. James and his crew?",
                    answers = {
                        ["This seems too much for me, I can't."] = gQuest.GOTO_EXIT,
                        ["*sigh* I'll do it, but I need some more details."] = gQuest.GOTO_QUEST,
                    }
                },

                ["What's in it for me?"] = {
                    title = "City Virus - Rewards",
                    desc = "You'll receive something for your hard work, of course.",
                    answers = {
                        ["Alright, let me see the quest."] = gQuest.GOTO_QUEST;
                    }
                },

                ["I can't, sorry."] = gQuest.GOTO_EXIT,
            }
        },

        ["Where do you think they are?"] = {
            title = "City Virus - Position.",
            desc = "They shouldn't be too far from here, use your quest tracker to find them.",
            answers = {
                ["Ok, Let me see the quest."] = gQuest.GOTO_QUEST,
                ["Yeah let me just.. <Leave>"] = gQuest.GOTO_EXIT
            }    
        },
        
        ["Why don't you call the police?"] = {
            title = "City Virus - Police.",
            desc = "The police? How do you think they will react when I say theres a deadly virus missing?",
            answers = {
                ["Fine, I'll look for them."] = gQuest.GOTO_QUEST,
                ["I don't think I'll be able to do it."] = gQuest.GOTO_EXIT
            }
        }
    }
};

QUEST.Description = "Look for Dr. James and his crew, they should not be far from here.\n\nResults of the virus being loose could could lead to some mysterious things, afterall its heavily mutated rabies virus.";
QUEST.Objective = "Look for Dr. James and his crew and be ready for anything.";
QUEST.HUDObjective = "Locate Dr. James and his crew and take care of the situation. {current}/{need}";
QUEST.OnCompleteDescription = "Oh my god, {name}! I'm so glad you are OK.\n\nI heard what happened and I'm so sorry, I did not know this would happen, however, I am also extremely thrilled that you managed to pull this off.\n\nHere, your reward.. As promised.";
QUEST.Rewards = "$10,000 and you unlock Quest: Zombie Threat";
QUEST.LevelRequirement = 5;
QUEST.ObjectiveRequirement = 5;
QUEST.ObjectiveClass = "npc_zombie";
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
function QUEST:OnObjectiveUpdated(ply, obj_count)
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
    hook.Add("OnNPCKilled", "gQuest.DefaultQuest_1", function(npc, ent)
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