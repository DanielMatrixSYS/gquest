--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

gQuest.PLAYER = FindMetaTable("Player");
gQuest.ENTITY = FindMetaTable("Entity");
gQuest.PANEL  = FindMetaTable("Panel");

---
--- MenuAccess; Default: {["superadmin"] = true}
---
--- Anyone who has access to this has access to the objective spawning, database wiping, pretty much everything that is related to gQuest
--- Be careful who you allow access.
---
gQuest.MenuAccess = {
    ["superadmin"] = true
}

---
--- UseLevelingRestrictions; Default: true
---
--- If a leveling system that we support is present on the server then the player who is accepting a quest needs to be a specific level.
--- If a leveling system that we support is present and the leveling restrictions are set to false then everyone, at any level can accept said quest.
---
gQuest.UseLevelingRestrictions = true;

---
--- HideUnavailableQuests; Default: true
---
--- Should we hide the unavailable quests from our quest ui?
--- Like, if you're too low level to do a certain quest should we hide that quest from the ui altogether or display it with a red/green text indicator?
---
--- true = hide, false = show, but also gives visuals that you can't do this quest.
--- the visuals might not be super accurate, but it'll warn the client.
---
--- Quests that are completed, etc, will stay hidden.
---
--- Quests that requires some other quest to be completed first will display.
gQuest.HideUnavailableQuests = true;

---
--- ObjectiveRespawnTimer; Default: 120
---
--- How long does it take for the quest objective to respawn once it has been killed or taken?
---
gQuest.ObjectiveRespawnTimer = 120;

---
--- ArrowAboveQuestObjects; Default: true
---
--- Should we display a white arrow that bounces up & down above the quest objectives?
---
gQuest.ArrowAboveQuestObjects = true;

---
--- UseQuestTracker; Default: true
---
--- Should we allow the player to use the quest tracker?
---
gQuest.UseQuestTracker = true;

---
--- QuestLogButton; Default: KEY_L
---
--- What button on our keyboard should we open the quest log with?
---
gQuest.QuestLogButton = KEY_L;

---
--- AnimationFix; Default: false
---
--- If your animations seem sped up in a sense then enable this variable.
--- Server/NPC restart required for changes to be made.
--- AnimationFixRate is what the animation speed should be set to, 1 = 100%, 0.5 = 50%, etc.
---
gQuest.AnimationFix = false;
gQuest.AnimationFixRate = 0.5;

---
--- ChatTip; Default: true
---
--- Should we allow the usual tip that occurs every 15 minutes?
--- The tip is: "Remember, you can press L to keep track of your current quests and its progression."
---
gQuest.ChatTip = true;

---
--- RemoveQuestsOnServerLeave; Default: false;
---
--- Should we remove the users quests upon server leave?
--- Completed quests are not affected by default.
---
gQuest.RemoveQuestsOnServerLeave = false;

---
--- RemoveCompletedQuestsOnServerLeave; Default: false;
---
--- If the variable above is not set to true then this will not work.
--- If the user leaves the server and the quest that we are trying to remove is completed then,
--- by default we won't do anything to the quest but if this variable is set to true then,
--- we will remove it.
---
gQuest.RemoveCompletedQuestsOnServerLeave = false;

---
--- NPCNoCollided; Default: false;
---
--- The NPC's be nocollided? 
--- This means the npc won't collide with anything, even players.
---
gQuest.NPCNoCollided = false;