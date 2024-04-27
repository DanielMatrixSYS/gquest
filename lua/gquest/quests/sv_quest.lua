--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

---
--- GetAcceptedQuests
---
function gQuest.GetAcceptedQuests()
    local quests = {};
    
    for k, v in ipairs(player.GetHumans()) do
        local acceptedQuests = string.Explode(",", v:GetPrivateGQString("CurrentQuests", ""));

        if (acceptedQuests[1] == "") then
            continue;
        end

        -- aq = accepted quests
        for _, aq in ipairs(acceptedQuests) do
            if (not table.HasValue(quests, aq)) then
                table.insert(quests, aq);
            end
        end
    end

    return quests;
end

---
--- GetAcceptedQuestCount
---
function gQuest.GetAcceptedQuestCount(quest_id)
    local count = 0;
    
    for k, v in ipairs(player.GetHumans()) do
        local acceptedQuests = string.Explode(",", v:GetPrivateGQString("CurrentQuests", ""));

        if (acceptedQuests[1] == "") then
            continue;
        end

        for _, aq in ipairs(acceptedQuests) do
            if (tonumber(aq) == quest_id) then
                count = count + 1;
            end
        end
    end

    return count;
end

---
--- GQ_TrackQuest
---
function gQuest.PLAYER:GQ_TrackQuest(quest_id, untrack)
    if (not IsValid(self)) then
        return false;
    end

    net.Start("gQuest.TrackQuest");
        net.WriteUInt(quest_id, 32);
        net.WriteBool(untrack);
    net.Send(self);
end

---
--- GQ_AddQuest
---
function gQuest.PLAYER:GQ_AddQuest(quest_id)
    if (not IsValid(self)) then
        return false;
    end

    -- Update our current quests.
    local quests = self:GetPrivateGQString("CurrentQuests", "");
    quests = quests .. "," .. quest_id;

    -- Remove the first comma.
    if (quests:sub(1, 1) == ",") then
        quests = quests:sub(2, #quests);
    end

    -- Now prepare our quest progress data.
    local questTable = gQuest.GetQuestTable(quest_id);
    local progress = util.JSONToTable(self:GetPrivateGQString("QuestObjectives", "[]"));

    local class;
    if (not questTable.ObjectiveClass) then
        class = "";
    else
        class = questTable.ObjectiveClass;
    end

    -- Insert into progress table.
    table.insert(progress, {quest_id = quest_id, quest_progress = 0, quest_progress_max = questTable.ObjectiveRequirement, quest_class = class});

    -- Update our data.
    local SQL = gQuest.GetSQL();
    local formated = util.TableToJSON(progress);
    SQL:DoSQLQuery(SQL:FormatSQL("UPDATE gQuest_Quests SET CurrentQuests = '%s', QuestObjectives = '%s' WHERE SteamID = '%s'", quests, formated, self:SteamID64()));
    
    -- Sync with client.
    self:GQ_UpdateCurrentQuests(quests);
    self:GQ_UpdateQuestObjectives(formated);
    self:GQ_TrackQuest(quest_id, false);

    if (questTable.CompletionTime and questTable.CompletionTime > 0) then
        timer.Create("quest_" .. self:SteamID64() .. "_" .. quest_id, questTable.CompletionTime, 1, function()
            if (IsValid(self)) then
                self:GQ_AbandonQuest(quest_id, false);

                self:SendGQTextNotification(true, questTable.Name, "uiNotificationQuestFailedDueToTime", gQuest.Red, 10);
            end
        end);

        self:SendGQTextNotification(true, questTable.Name, "uiNotificationTimeLimit", gQuest.Red, 10);
        self:SetPrivateGQString("quest_" .. quest_id .. "_timeleft", os.time() + questTable.CompletionTime);
    end

    gQuest.Debug("SUCCESS: Added quest[" .. quest_id .. "] to [" .. self:Nick() .. ", " .. self:SteamID64() .. "]'s collection.");

    -- Run things.
    questTable:OnAccept(self);
    hook.Run("gQuest_QuestAccepted", self, quest_id);
end

---
--- GQ_HasAcceptedQuest
---
function gQuest.PLAYER:GQ_HasAcceptedQuest(quest_id)
    -- Since our data is always synced we don't need to rely on a sql query in order
    -- to get the correct information.
    
    local currentQuests = string.Explode(",", self:GetPrivateGQString("CurrentQuests", ""));
    for k, v in ipairs(currentQuests) do
        if (tonumber(v) == quest_id) then
            return true;
        end
    end

    return false;
end

---
--- GQ_RemoveCooldownedQuest
---
function gQuest.PLAYER:GQ_RemoveCooldownedQuest(quest_id)
    local cooldownedQuests = util.JSONToTable(self:GetPrivateGQString("QuestCooldowns", "[]"))
    for k, v in ipairs(cooldownedQuests) do
        if (v.quest_id == quest_id) then
            table.remove(cooldownedQuests, k);

            break;
        end
    end

    -- Update sql
    local SQL = gQuest.GetSQL();
    local json = util.TableToJSON(cooldownedQuests);
    SQL:DoSQLQuery(SQL:FormatSQL("UPDATE gQuest_Quests SET QuestsOnCooldown = '%s' WHERE SteamID = '%s'", json, self:SteamID64()));

    -- Sync with clients.
    self:GQ_UpdateCooldownedQuests(json);

    -- Debug messages
    gQuest.Debug("SUCCESS: Removed quest cooldown from database for player[" .. self:Nick() .. ", " .. self:SteamID64() .. "]")
end

---
--- GQ_CheckForList
---
function gQuest.PLAYER:GQ_CheckForList(quest_id)
    if (DarkRP) then
        local questTable = gQuest.GetQuestTable(quest_id);
        local jobName = team.GetName(self:Team());

        if (questTable.JobWhitelist) then
            local wList = questTable.JobWhitelist;

            if (type(wList) == "table") then
                return wList[jobName];
            else
                return wList == jobName
            end
        elseif(questTable.JobBlacklist) then
            local bList = questTable.JobBlacklist;

            if (type(bList) == "table") then
                if (bList[jobName]) then
                    return false;
                else
                    return true;
                end
            else
                if (bList == jobName) then
                    return false;
                else
                    return true;
                end
            end
        end

        return true;
    end

    return true;
end

---
--- GQ_CanAcceptQuest
---
function gQuest.PLAYER:GQ_CanAcceptQuest(quest_id)
    if (not IsValid(self)) then
        return false;
    end

    -- If we were unable to retieve the quest table then something bad has happened
    -- To stay away from a faulty database or errors we're just going to refuse the quest.
    local questTable = gQuest.GetQuestTable(quest_id);
    if (not questTable) then
        gQuest.Debug("WARNING: Tried to retrieve quest table from quest id: " .. quest_id .. " it returned [" .. type(quest_id) .. ", " .. tostring(quest_id) .. "]");

        return false;
    end

    -- First of all, check if we have accepted the quest already.
    if (self:GQ_HasAcceptedQuest(quest_id)) then
        gQuest.Debug("WARNING: Unable to accept quest because quest already accepted; quest id: " .. quest_id .. " for player [" .. self:Nick() .. ", " .. self:SteamID64() .. "]");

        return false;
    end

    -- If we have completed the quest already then we're just going to return false, yet again.
    if (self:GQ_HasCompletedQuest(quest_id)) then
        gQuest.Debug("WARNING: Unable to accept quest because quest already completed; quest id: " .. quest_id .. " for player [" .. self:Nick() .. ", " .. self:SteamID64() .. "]");

        return false;
    end

    -- If the quest is on cooldown then we'll refuse.
    local cooldownedQuests = util.JSONToTable(self:GetPrivateGQString("QuestCooldowns", "[]"))
    for k, v in ipairs(cooldownedQuests) do
        if (v.quest_id == quest_id) then
            local expiry = v.endTime - os.time();
            
            if (expiry > 0) then
                return false;
            end

            self:GQ_RemoveCooldownedQuest(quest_id);
        end
    end

    -- Check if we need to complete any prior quests in order for us to be able to accept this.
    local needsToComplete = questTable.NeedsToHaveCompleted;
    if (needsToComplete) then
        if (not istable(needsToComplete)) then
            local old = needsToComplete;
            needsToComplete = {old};
        end

        local hasCompleted = 0;
        local needsToCompleteCount = #needsToComplete;
        local completedQuests = string.Explode(",", self:GetPrivateGQString("CompletedQuests", ""));

        for k, v in ipairs(completedQuests) do
            for _, completed in ipairs(needsToComplete) do
                if (tonumber(v) == completed) then
                    hasCompleted = hasCompleted + 1;
                end
            end
        end

        for k, v in ipairs(cooldownedQuests) do
            for _, completed in ipairs(needsToComplete) do
                if (v.quest_id == completed) then
                    hasCompleted = hasCompleted + 1;
                end
            end
        end

        if (hasCompleted < needsToCompleteCount) then
            gQuest.Debug("WARNING: Unable to accept quest[" .. quest_id .. "]; We have completed " .. hasCompleted .. " quests of out " .. needsToCompleteCount .. " that needs to be completed in order to accept this quest.");
            self:SendGQTextNotification(true, questTable.Name, "You have some unfinished quests you need to do before you can take this!", gQuest.Red, 10);

            return false;
        end
    end

    -- DarkRP Checks
    if (DarkRP) then
        local canQuest = self:GQ_CheckForList(quest_id);
        if (not canQuest) then
            gQuest.Debug("WARNING: Unable to accept quest[" .. quest_id .. "] because we are not the correct job.");
            self:SendGQTextNotification(true, "uiNotificationAbandonedDueToJob", questTable.Name, gQuest.Red, 8);

            return false;
        end
    end

    -- Check if we're the allowed level.
    local levelRequirement = questTable.LevelRequirement;
    if (levelRequirement and levelRequirement > 0 and gQuest.UseLevelingRestrictions) then

        -- vrondakis level system
        if (self.getLevel) then
            return self:getLevel() >= levelRequirement;
        end

        -- sublime levels
        if (self.SL_GetLevel) then
            return self:SL_GetLevel() >= levelRequirement;
        end

        -- wiltos, very generic function name, might collide with other stuff idk.
        if (self.GetSkillLevel) then
            return self:GetSkillLevel() >= levelRequirement;
        end
    end

    -- Now, if this is a <insert usergroup here> quest then we have to check if the user is a <said usergroup>.
    if (questTable.UsergroupsAllowed) then
        if (not questTable.UsergroupsAllowed[self:GetUserGroup()]) then
            return false;
        end
    end

    -- if we've come this far then the user can have the quest.
    return true;
end

---
--- GQ_UpdateCurrentQuests
---
function gQuest.PLAYER:GQ_UpdateCurrentQuests(quests)
    if (not IsValid(self)) then
        return false;
    end

    -- Insert Data.
    self:SetPrivateGQString("CurrentQuests", quests);
end

---
--- GQ_UpdateQuestObjectives
---
function gQuest.PLAYER:GQ_UpdateQuestObjectives(progress)
    if (not IsValid(self)) then
        return false;
    end

    -- Insert Data.
    self:SetPrivateGQString("QuestObjectives", progress);
end

---
--- GQ_UpdateQuestsAvailableForDeliver
---
function gQuest.PLAYER:GQ_UpdateQuestsAvailableForDeliver(quests)
    if (not IsValid(self)) then
        return false;
    end

    -- Insert Data.
    self:SetPrivateGQString("QuestsAvailableForDeliver", quests);
end

---
--- GQ_UpdateCompletedQuests
---
function gQuest.PLAYER:GQ_UpdateCompletedQuests(quests)
    if (not IsValid(self)) then
        return false;
    end

    -- Insert Data.
    self:SetPrivateGQString("CompletedQuests", quests);
end

---
--- GQ_UpdateCooldownedQuests
---
function gQuest.PLAYER:GQ_UpdateCooldownedQuests(quests)
    if (not IsValid(self)) then
        return false;
    end

    -- Insert Data.
    self:SetPrivateGQString("QuestCooldowns", quests);
end

---
--- GQ_UpdateQuests
---
function gQuest.PLAYER:GQ_UpdateQuests()
    if (not IsValid(self)) then
        return false;
    end

    local SQL = gQuest.GetSQL();
    local data = SQL:DoSQLQuery(SQL:FormatSQL("SELECT CurrentQuests, CompletedQuests, QuestObjectives, QuestsAvailableForDeliver, QuestsOnCooldown FROM gQuest_Quests WHERE SteamID = '%s'", self:SteamID64()))[1];

    -- Insert Data.
    self:SetPrivateGQString("CurrentQuests", data["CurrentQuests"]);
    self:SetPrivateGQString("CompletedQuests", data["CompletedQuests"]);
    self:SetPrivateGQString("QuestObjectives", data["QuestObjectives"]);
    self:SetPrivateGQString("QuestsAvailableForDeliver", data["QuestsAvailableForDeliver"]);
    self:SetPrivateGQString("QuestCooldowns", data["QuestsOnCooldown"]);
end

---
--- DoStringFormat
---
local function DoStringFormat(tbl)
    local formated = table.ToString(tbl);
    formated = formated:Replace("{", "");
    formated = formated:Replace("}", "");
    formated = formated:Replace("\"", "");

    if (formated:EndsWith(",")) then
        formated = formated:sub(1, #formated - 1);
    end

    return formated;
end

---
--- GQ_AbandonQuest
---
function gQuest.PLAYER:GQ_AbandonQuest(quest_id, notify)
    if (not IsValid(self)) then
        return false;
    end

    if (not self:GQ_HasAcceptedQuest(quest_id)) then
        gQuest.Debug("WARNING: Tried to abandon a quest that either does not exist or the user does not have; quest[" .. quest_id .. "]")

        return false;
    end

    -- Update our current quests.
    local currentQuests = string.Explode(",", self:GetPrivateGQString("CurrentQuests", ""));
    for k, v in ipairs(currentQuests) do
        if (tonumber(v) == quest_id) then
            table.remove(currentQuests, k);

            break;
        end
    end

    -- After we have upated current quests then we have to
    -- update our progression data.
    local progress = util.JSONToTable(self:GetPrivateGQString("QuestObjectives", "[]"));
    for k, v in ipairs(progress) do
        if (tonumber(v.quest_id) == quest_id) then
            table.remove(progress, k);

            break;
        end
    end

    local deliver = string.Explode(",", self:GetPrivateGQString("QuestsAvailableForDeliver", ""));
    for k, v in ipairs(deliver) do
        if (tonumber(v) == quest_id) then
            table.remove(deliver, k);

            break;
        end
    end

    local completedQuests = string.Explode(",", self:GetPrivateGQString("CompletedQuests", ""));
    for k, v in ipairs(completedQuests) do
        if (tonumber(v) == quest_id) then
            table.remove(completedQuests, k);

            break;
        end
    end

    local json = util.TableToJSON(progress);
    local formated = DoStringFormat(currentQuests);
    local deliverFormated = DoStringFormat(deliver);
    local completedFormat = DoStringFormat(completedQuests);
    local questTable = gQuest.GetQuestTable(quest_id);
    local notify = notify == nil and true or notify;

    self:GQ_UpdateCurrentQuests(formated);
    self:GQ_UpdateQuestObjectives(json);
    self:GQ_UpdateQuestsAvailableForDeliver(deliverFormated);
    self:GQ_UpdateCompletedQuests(completedFormat);
    self:GQ_SaveAllQuestData();
    self:GQ_UpdateQuests();
    self:SetPrivateGQString("quest_" .. quest_id .. "_timeleft", 0);

    if (timer.Exists("quest_" .. self:SteamID64() .. "_" .. quest_id)) then
        timer.Destroy("quest_" .. self:SteamID64() .. "_" .. quest_id);
    end

    if (notify) then
        self:SendGQTextNotification(true, "uiNotificationAbandoned", questTable.Name, gQuest.Red, 5);
    end

    gQuest.Debug("SUCCESS: player[" .. self:Nick() .. ", " .. self:SteamID64() .. "] abanonded quest[" .. quest_id .. ", " .. questTable.Name .. "]");
    
    -- Run hooks.
    questTable:OnQuestDisbanded(self);
    hook.Run("gQuest_QuestAbandoned", self, quest_id);
end

---
--- GQ_AcceptQuest
---
function gQuest.PLAYER:GQ_AcceptQuest(quest_id, quest_name)
    if (not IsValid(self)) then
        return false;
    end

    if (not self:GQ_CanAcceptQuest(quest_id)) then
        return false;
    end

    self:GQ_AddQuest(quest_id);
    self:SendGQTextNotification(true, "uiNotificationAccepted", quest_name, gQuest.RoyalBlue, 5);
end

---
--- GQ_HasReachedObjective
---
function gQuest.PLAYER:GQ_HasReachedObjective(quest_id)
    if (not IsValid(self) or not self:GQ_HasAcceptedQuest(quest_id)) then
        return false;
    end

    local json = util.JSONToTable(self:GetPrivateGQString("QuestObjectives", "[]"));
    for k, v in ipairs(json) do
        if (tonumber(v.quest_id) == quest_id) then
            return v.quest_progress >= v.quest_progress_max;
        end
    end

    return false;
end

---
--- GQ_CheckObjectiveReached
---
function gQuest.PLAYER:GQ_CheckObjectiveReached(quest_id)
    if (not IsValid(self) or not self:GQ_HasAcceptedQuest(quest_id)) then
        return false;
    end

    local reachedMax = self:GQ_HasReachedObjective(quest_id);
    if (not reachedMax) then
        return false;
    end
    
    ---
    --- Edited by floof
    --- 28/01/19
    ---

    local questTable = gQuest.GetQuestTable(quest_id);
    if (questTable.DeliverUponCompletion) then
        self:GQ_CompleteQuest(quest_id, true);
        
        self:SendGQTextNotification(true, "uiNotificationAutoComplete", questTable.Name, gQuest.Green, 15);
    else
        local questsAvailableForDeliver = self:GetPrivateGQString("QuestsAvailableForDeliver", "");
        questsAvailableForDeliver = questsAvailableForDeliver .. "," .. quest_id;

        -- Remove the first comma.
        if (questsAvailableForDeliver:sub(1, 1) == ",") then
            questsAvailableForDeliver = questsAvailableForDeliver:sub(2, #questsAvailableForDeliver);
        end

        -- Update our data.
        local SQL = gQuest.GetSQL();
        SQL:DoSQLQuery(SQL:FormatSQL("UPDATE gQuest_Quests SET QuestsAvailableForDeliver = '%s' WHERE SteamID = '%s'", questsAvailableForDeliver, self:SteamID64()));
        self:GQ_UpdateQuestsAvailableForDeliver(questsAvailableForDeliver);
        self:SetPrivateGQString("quest_" .. quest_id .. "_timeleft", 0);
        self:SendGQTextNotification(true, "uiNotificationCompleted", questTable.Name, gQuest.Green, 10);

        if (timer.Exists("quest_" .. self:SteamID64() .. "_" .. quest_id)) then
            timer.Destroy("quest_" .. self:SteamID64() .. "_" .. quest_id);
        end
        
        questTable:OnCompleted(self);
    end

    return true;
end

---
--- GQ_CanDeliverQuest
---
function gQuest.PLAYER:GQ_CanDeliverQuest(quest_id)
    if (not IsValid(self) or not self:GQ_HasAcceptedQuest(quest_id)) then
        return;
    end

    local deliver = string.Explode(",", self:GetPrivateGQString("QuestsAvailableForDeliver", ""));
    for k, v in ipairs(deliver) do
        if (tonumber(v) == quest_id) then
            return true;
        end
    end

    return false;
end

---
--- GQ_SaveAllQuestData
---
function gQuest.PLAYER:GQ_SaveAllQuestData()
    if (not IsValid(self)) then
        return;
    end

    local currentQuests = self:GetPrivateGQString("CurrentQuests", "");
    local currentDeliverables = self:GetPrivateGQString("QuestsAvailableForDeliver", "");
    local currentCompleted = self:GetPrivateGQString("CompletedQuests", "");
    local currentObjectives = self:GetPrivateGQString("QuestObjectives", "[]");
    local currentCooldowns = self:GetPrivateGQString("QuestCooldowns", "[]");
    local SQL = gQuest.GetSQL();

    SQL:DoSQLQuery(SQL:FormatSQL("UPDATE gQuest_Quests SET CurrentQuests = '%s', QuestObjectives = '%s', CompletedQuests = '%s', QuestsAvailableForDeliver = '%s', QuestsOnCooldown = '%s' WHERE SteamID = '%s'", currentQuests, currentObjectives, currentCompleted, currentDeliverables, currentCooldowns, self:SteamID64()));
end

---
--- GQ_PutQuestOnCooldown
---
function gQuest.PLAYER:GQ_PutQuestOnCooldown(quest_id, save_now)
    local questTable = gQuest.GetQuestTable(quest_id);

    if (questTable.Cooldown) then
        local coolDownedQuests = util.JSONToTable(self:GetPrivateGQString("QuestCooldowns", "[]"));
        table.insert(coolDownedQuests, {quest_id = quest_id, endTime = os.time() + questTable.Cooldown});

        local cdFormated = util.TableToJSON(coolDownedQuests);
        self:GQ_UpdateCooldownedQuests(cdFormated);

        if (save_now) then
            self:GQ_SaveAllQuestData();
        end
    end

    return true;
end

---
--- GQ_CompleteQuest
---
function gQuest.PLAYER:GQ_CompleteQuest(quest_id, forced, str)
    if (not IsValid(self) or not self:GQ_HasAcceptedQuest(quest_id) or not self:GQ_CanDeliverQuest(quest_id) and not forced) then
        return false;
    end

    local currentQuests = string.Explode(",", self:GetPrivateGQString("CurrentQuests", ""));
    local currentDeliverables = string.Explode(",", self:GetPrivateGQString("QuestsAvailableForDeliver", ""));
    local currentCompleted = self:GetPrivateGQString("CompletedQuests", "");
    local currentObjectives = util.JSONToTable(self:GetPrivateGQString("QuestObjectives", "[]"));
    local questTable = gQuest.GetQuestTable(quest_id);

    -- Remove from current quests.
    for k, v in ipairs(currentQuests) do
        if (tonumber(v) == quest_id) then
            table.remove(currentQuests, k);

            break;
        end
    end

    -- Remove Objectives.
    for k, v in ipairs(currentObjectives) do
        if (tonumber(v.quest_id) == quest_id) then
            table.remove(currentObjectives, k);

            break;
        end
    end

    -- Remove from deliver.
    for k, v in ipairs(currentDeliverables) do
        if (tonumber(v) == quest_id) then
            table.remove(currentDeliverables, k);

            break;
        end
    end

    local questTable = gQuest.GetQuestTable(quest_id);
    if (questTable.OneTimeQuest) then
        currentCompleted = currentCompleted .. "," .. quest_id;

        -- Remove the first comma.
        if (currentCompleted:sub(1, 1) == ",") then
            currentCompleted = currentCompleted:sub(2, #currentCompleted);
        end
    else
        self:GQ_PutQuestOnCooldown(quest_id, false);
    end

    local questFormated = DoStringFormat(currentQuests);
    local objectiveFormated = util.TableToJSON(currentObjectives);
    local deliverablesFormated = DoStringFormat(currentDeliverables);

    self:GQ_UpdateCurrentQuests(questFormated);
    self:GQ_UpdateQuestObjectives(objectiveFormated);
    self:GQ_UpdateCompletedQuests(currentCompleted);
    self:GQ_UpdateQuestsAvailableForDeliver(deliverablesFormated);
    self:GQ_SaveAllQuestData();
    self:GQ_TrackQuest(quest_id, true);
    self:SetPrivateGQString("quest_" .. quest_id .. "_timeleft", 0);

    if (timer.Exists("quest_" .. self:SteamID64() .. "_" .. quest_id)) then
        timer.Destroy("quest_" .. self:SteamID64() .. "_" .. quest_id);
    end

    if (not forced) then
        self:SendGQTextNotification(true, "uiNotificationDelivered", questTable.Name, gQuest.Green, 10);
    else
        if (str and str ~= "") then
            self:SendGQTextNotification(true, str, questTable.Name, gQuest.Red, 15);
        end
    end

    questTable:OnDelivered(self);
    questTable:RewardFunction(self);

    hook.Run("gQuest_QuestCompleted", self, quest_id);
end

---
--- GQ_RemoveFromCompletionList
---
function gQuest.PLAYER:GQ_RemoveFromCompletionList(quest_id)
    if (not IsValid(self) or not self:GQ_HasCompletedQuest(quest_id)) then
        return false;
    end

    local completedQuests = string.Explode(",", self:GetPrivateGQString("CompletedQuests", ""));
    for k, v in ipairs(completedQuests) do
        if (tonumber(v) == quest_id) then
            table.remove(completedQuests, k);

            break;
        end
    end

    local questTable = gQuest.GetQuestTable(quest_id);
    local formated = DoStringFormat(completedQuests);

    self:GQ_UpdateCompletedQuests(formated);
    self:GQ_SaveAllQuestData();
    self:GQ_TrackQuest(quest_id, true);
    self:SetPrivateGQString("quest_" .. quest_id .. "_timeleft", 0);

    if (timer.Exists("quest_" .. self:SteamID64() .. "_" .. quest_id)) then
        timer.Destroy("quest_" .. self:SteamID64() .. "_" .. quest_id);
    end

    -- Notify the user about what has happened.
    self:SendGQTextNotification(true, "uiNotificationForcedRemoved", questTable.Name, gQuest.Red, 15);

    hook.Run("gQuest_QuestAbandoned", self, quest_id);
end

---
--- GQ_RemoveFromTakenList
---
function gQuest.PLAYER:GQ_RemoveFromTakenList(quest_id)
    if (not IsValid(self) or not self:GQ_HasAcceptedQuest(quest_id) or self:GQ_HasCompletedQuest(quest_id)) then
        return false;
    end

    local currentQuests = string.Explode(",", self:GetPrivateGQString("CurrentQuests", ""));
    local currentDeliverables = string.Explode(",", self:GetPrivateGQString("QuestsAvailableForDeliver", ""));
    local currentObjectives = util.JSONToTable(self:GetPrivateGQString("QuestObjectives", "[]"));

    for k, v in ipairs(currentQuests) do
        if (tonumber(v) == quest_id) then
            table.remove(currentQuests, k);

            break;
        end
    end

    for k, v in ipairs(currentDeliverables) do
        if (tonumber(v) == quest_id) then
            table.remove(currentDeliverables, k);

            break;
        end
    end

    for k, v in ipairs(currentObjectives) do
        if (tonumber(v.quest_id) == quest_id) then
            table.remove(currentObjectives, k);

            break;
        end
    end

    local questTable = gQuest.GetQuestTable(quest_id);
    local fQuests = DoStringFormat(currentQuests);
    local fDeliverables = DoStringFormat(currentDeliverables);
    local fObjectives = util.TableToJSON(currentObjectives);

    self:GQ_UpdateCurrentQuests(fQuests);
    self:GQ_UpdateQuestsAvailableForDeliver(fDeliverables);
    self:GQ_UpdateQuestObjectives(fObjectives);
    self:GQ_SaveAllQuestData();
    self:GQ_TrackQuest(quest_id, true);
    self:SetPrivateGQString("quest_" .. quest_id .. "_timeleft", 0);

    if (timer.Exists("quest_" .. self:SteamID64() .. "_" .. quest_id)) then
        timer.Destroy("quest_" .. self:SteamID64() .. "_" .. quest_id);
    end

    -- Notify the user about what has happened.
    self:SendGQTextNotification(true, "uiNotificationForcedRemoved", questTable.Name, gQuest.Red, 15);

    hook.Run("gQuest_QuestAbandoned", self, quest_id);
end

---
--- GQ_AddQuestProgress
---
function gQuest.PLAYER:GQ_AddQuestProgress(quest_id, progress)
    if (not IsValid(self) or not self:GQ_HasAcceptedQuest(quest_id) or self:GQ_HasReachedObjective(quest_id)) then
        return false;
    end

    -- Update progress.
    local questProgress = util.JSONToTable(self:GetPrivateGQString("QuestObjectives", "[]"));
    local after = 0;

    for k, v in ipairs(questProgress) do
        if (tonumber(v.quest_id) == quest_id) then
            v.quest_progress = v.quest_progress + progress;
            after = v.quest_progress;

            break;
        end
    end

    -- Sync with client
    local json = util.TableToJSON(questProgress);
    local SQL = gQuest.GetSQL();
    SQL:DoSQLQuery(SQL:FormatSQL("UPDATE gQuest_Quests SET QuestObjectives = '%s' WHERE SteamID = '%s'", json, self:SteamID64()));
    self:GQ_UpdateQuestObjectives(json);

    -- Check for quest completion.
    self:GQ_CheckObjectiveReached(quest_id);

    -- Notify user about progress.
    local questTable = gQuest.GetQuestTable(quest_id);
    self:SendGQTextNotification(false, questTable.Name .. ": " .. after .. "/" .. questTable.ObjectiveRequirement, 3, gQuest.Yellow);

    questTable:OnObjectiveUpdated(self, after);
end

---
--- GQ_GiveAllQuests
--- Helper function.
--- Created: 060818
---
function gQuest.PLAYER:GQ_GiveAllQuests()
    local quests = gQuest.GetAllQuests();
    
    net.Start("gQuest.GiveAllQuests");
        net.WriteTable(quests);
    net.Send(self);
end

---
--- GetAllQuests
---
function gQuest.GetAllQuests()
    local quests = {};

    for k, v in ipairs(gQuest.Quests) do
        table.insert(quests, {
            ID = v.ID,
            NPC = v.NPC,
            Name = v.Name,
            Description = v.Description,
            Objective = v.Objective,
            HUDObjective = v.HUDObjective,
            OnCompleteDescription = v.OnCompleteDescription,
            Rewards = v.Rewards,
            OneTimeQuest = v.OneTimeQuest,
            LevelRequirement = v.LevelRequirement,
            ObjectiveRequirement = v.ObjectiveRequirement,
            PreQuestConversation = v.PreQuestConversation,
            PreQuestConversationEnabled = v.PreQuestConversationEnabled,
            NeedsToHaveCompleted = v.NeedsToHaveCompleted,
            ObjectiveClass = v.ObjectiveClass,
            JobWhitelist = v.JobWhitelist,
            JobBlacklist = v.JobBlacklist,
            UsergroupsAllowed = v.UsergroupsAllowed,
            QuestArrow = v.QuestArrow
        });
    end

    return quests;
end