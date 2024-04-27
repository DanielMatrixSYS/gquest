--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

gQuest.CanOpenQuestLog      = true;
gQuest.CurrentTrackedQuest  = nil;

net.Receive("gQuest.UI", function()
    local ply   = LocalPlayer();
    local x, y  = 362, 508
    
    ply.gQuest_NPC_Table        = net.ReadTable();
    ply.gQuest_Objective_Table  = net.ReadTable();

    local ui = vgui.Create("gQuest.QuestMain");
    ui:SetSize(x, y);
    ui:SetPos(75, ((ScrH() / 2) - y / 2) - 50);
    ui:MakePopup();
end);

net.Receive("gQuest.UpdatePrivateString", function()
    LocalPlayer()[net.ReadString()] = net.ReadString();
end);

net.Receive("gQuest.QuestUI", function()
    local ply = LocalPlayer();
    local ent = net.ReadEntity();

    local currentQuests             = string.Explode(",", ply:GetPrivateGQString("CurrentQuests", ""));
    local questsAvailableForDeliver = string.Explode(",", ply:GetPrivateGQString("QuestsAvailableForDeliver", ""));
    local questsCompleted           = string.Explode(",", ply:GetPrivateGQString("CompletedQuests", ""));
    local questsOnCooldown          = util.JSONToTable(ply:GetPrivateGQString("QuestCooldowns", "[]"));

    for k, v in ipairs(gQuest.Quests) do
        gQuest.Quests[k].Taken      = false;
        gQuest.Quests[k].Completed  = false;

        for _, q in ipairs(currentQuests) do
            if (v.ID == tonumber(q)) then
                gQuest.Quests[k].Taken = true;
            end
        end

        for _, d in ipairs(questsAvailableForDeliver) do
            if (v.ID == tonumber(d)) then
                gQuest.Quests[k].Completed = true;
            end
        end

        for _, c in ipairs(questsOnCooldown) do
            if (v.ID == tonumber(c.quest_id)) then
                gQuest.Quests[k].Cooldown = c.endTime;
            end
        end

        if (v.LevelRequirement and v.LevelRequirement > 0 and gQuest.UseLevelingRestrictions) then

            -- Checks for the usual leveling systems, such as vrondakis.
            if (ply.getDarkRPVar) then
                if (ply:getDarkRPVar("level") and ply:getDarkRPVar("level") >= v.LevelRequirement) then
                    gQuest.Quests[k].LevelRequirementMet = true;
                else
                    gQuest.Quests[k].LevelRequirementMet = false; 
                end
            end

            -- Checks for Sublime Levels leveling system.
            if (ply.SL_GetLevel) then
                if (ply:SL_GetLevel() >= v.LevelRequirement) then
                    gQuest.Quests[k].LevelRequirementMet = true;
                else
                    gQuest.Quests[k].LevelRequirementMet = false;
                end
            end

            -- Checks for starwars leveling system, don't remember what its called.
            if (ply.GetSkillLevel) then
                if (ply:GetSkillLevel() >= v.LevelRequirement) then
                    gQuest.Quests[k].LevelRequirementMet = true;
                else
                    gQuest.Quests[k].LevelRequirementMet = false;
                end
            end
        end

        --- Show all of the quests unless we shouldn't.
        gQuest.Quests[k].Show = true;

        if (not istable(v.NPC)) then
            v.NPC = {v.NPC};
        end

        if (table.HasValue(v.NPC, ent:GetID())) then
            for _, c in ipairs(questsCompleted) do
                if (v.ID == tonumber(c)) then
                    gQuest.Quests[k].Show = false;

                    continue;
                end
            end

            local nCompleted = gQuest.Quests[k].NeedsToHaveCompleted;
            if (nCompleted and nCompleted ~= 0) then
                if (istable(nCompleted)) then
                    local cQuests = 0;

                    for _, v in ipairs(questsCompleted) do
                        local v = tonumber(v);

                        for _, n in ipairs(nCompleted) do
                            if (v == n) then
                                cQuests = cQuests + 1;
                            end
                        end
                    end

                    for _, v in ipairs(questsOnCooldown) do
                        for _, n in ipairs(nCompleted) do
                            if (v.quest_id == n) then
                                cQuests = cQuests + 1;
                            end
                        end
                    end

                    if (cQuests < #nCompleted and gQuest.HideUnavailableQuests) then
                        gQuest.Quests[k].Show = false;
                    end
                else
                    if (not table.HasValue(questsCompleted, tostring(nCompleted)) and gQuest.HideUnavailableQuests) then
                        gQuest.Quests[k].Show = false;
                    end
                end
            end

            if (gQuest.Quests[k].LevelRequirementMet == false and gQuest.HideUnavailableQuests) then
                gQuest.Quests[k].Show = false;
            end

            if (gQuest.Quests[k].JobWhitelist and DarkRP) then
                if (not gQuest.Quests[k].JobWhitelist[team.GetName(ply:Team())]) then
                    gQuest.Quests[k].Show = false;
                end
            end

            if (gQuest.Quests[k].JobBlacklist and DarkRP) then
                if (gQuest.Quests[k].JobBlacklist[team.GetName(ply:Team())] and gQuest.HideUnavailableQuests) then
                    gQuest.Quests[k].Show = false;
                end
            end

            if (gQuest.Quests[k].UsergroupsAllowed) then
                if (not gQuest.Quests[k].UsergroupsAllowed[ply:GetUserGroup()] and gQuest.HideUnavailableQuests) then
                    gQuest.Quests[k].Show = false;
                end
            end
        else
            gQuest.Quests[k].Show = false;
        end
    end

    local x, y = 362, 508
    local ui = vgui.Create("gQuest.QuestUI");
    ui:SetSize(x, y);
    ui:SetPos(75, ((ScrH() / 2) - y / 2) - 50);
    ui:MakePopup();
    ui:SetQuestGiver(ent);
end);

net.Receive("gQuest.Notification", function()
    local ui = vgui.Create("gQuest.NotificationMain");
    ui:SetSize(500, 200);
    ui:Center();
    ui:MakePopup();
    ui:SetHeader(net.ReadString())
    ui:SetDescription(net.ReadString());
    ui:SetAcceptText(net.ReadString());
    ui:SetUseDecline(net.ReadBool());
end);

net.Receive("gQuest.TextNotification", function()
    local useHeader     = net.ReadBool();
    local header        = net.ReadString();
    local description   = net.ReadType();
    local color         = net.ReadColor();
    local endTime       = net.ReadUInt(8);

    if (not useHeader) then
        gQuest.AddTexts(useHeader, gQuest.L(header), gQuest.L(description), color);
    else
        gQuest.AddTexts(useHeader, gQuest.L(header), gQuest.L(description), color, endTime);
    end
end);

net.Receive("gQuest.GiveAllQuests", function()
    table.Empty(gQuest.Quests);
    
    gQuest.Quests = net.ReadTable();
end);

hook.Add("PlayerButtonDown", "gQuest.QuestLog", function(ply, key)
    if (ply == LocalPlayer() and key == gQuest.QuestLogButton and gQuest.CanOpenQuestLog) then
        if (not IsFirstTimePredicted()) then
            return;
        end
        
        local w, h = ScrW(), ScrH()
        local x, y = 362, 508
        local ui = vgui.Create("gQuest.QuestLog");
        ui:SetSize(x, y);
        ui:SetPos((w - x) - 75, ((ScrH() / 2) - y / 2) - 50);
        ui:MakePopup();

        gQuest.CanOpenQuestLog = false;
    end
end);

if (gQuest.ChatTip) then
    timer.Create("gQuest.QuestLogNotification", 1200, 0, function()
        chat.AddText(gQuest.Red, "[", gQuest.Black, "gQuest", gQuest.Red, "]", gQuest.White, ": " .. gQuest.L("otherText"));
        chat.PlaySound();
    end);
end

net.Receive("gQuest.Broadcast", function()
    chat.AddText(gQuest.Red, "[", gQuest.Black, "gQuest", gQuest.Red, "] ", gQuest.Red, net.ReadString());
    chat.PlaySound();
end);