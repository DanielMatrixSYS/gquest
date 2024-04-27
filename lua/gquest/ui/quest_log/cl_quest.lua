--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

AccessorFunc(panel, "PanelHolder", "PanelHolder");
AccessorFunc(panel, "QuestName", "QuestName", FORCE_STRING);
AccessorFunc(panel, "QuestID", "QuestID", FORCE_NUMBER);
AccessorFunc(panel, "Description", "Description", FORCE_STRING);
AccessorFunc(panel, "Objective", "Objective", FORCE_STRING);
AccessorFunc(panel, "Rewards", "Rewards", FORCE_STRING);
AccessorFunc(panel, "PredictedSize", "PredictedSize", FORCE_NUMBER);
AccessorFunc(panel, "EndTime", "EndTime", FORCE_NUMBER);

---
--- PostInit
---
function panel:PostInit()
    
    -- Quests ready to be delivered.
    local rQuests = string.Explode(",", LocalPlayer():GetPrivateGQString("QuestsAvailableForDeliver", ""));

    for k, v in ipairs(rQuests) do
        if (tonumber(v) == self.QuestID) then
            return true;
        end
    end

    self.Abandon = self:Add("DButton");
    self.Abandon:SetText("");
    self.Abandon:SetCursor("arrow");

    self.Abandon.Alpha = 0;

    self.Abandon.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, s.Alpha);
        surface.DrawRect(2, 2, w - 4, h - 4);

        surface.SetDrawColor(0, 0, 0);
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(gQuest.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

        if (s:IsHovered()) then
            s.Alpha = self.Approach(s.Alpha, 100, 8);
        else
            s.Alpha = self.Approach(s.Alpha, 0, 2);
        end

        gQuest.DrawTextOutlined(gQuest.L("npcAbandon"), "gQuest.16", w / 2, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end

    self.Abandon.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    self.Abandon.DoClick = function()
        local main = self.PanelHolder;
        local oldQuestID = self.QuestID;
        local oldQuestName = self.QuestName;

        if (IsValid(main)) then
            main:Remove();
        end

        local ui = vgui.Create("gQuest.NotificationMain");
        ui:SetSize(500, 200);
        ui:Center();
        ui:MakePopup();
        ui:SetHeader(gQuest.L("npcHeaderAbandon"));
        ui:SetDescription(gQuest.L("npcDesc", oldQuestName));
        ui:SetAcceptText(gQuest.L("npcAbandonIt"));
        ui:SetDeclineText(gQuest.L("npcNever"));
        ui.DoAcceptClick = function()
            net.Start("gQuest.AbandonQuest");
                net.WriteUInt(oldQuestID, 32);
            net.SendToServer();
        end
    end
end

---
--- Init
---
function panel:Init()
    self.Approach = math.Approach;

    self.Exit = self:Add("DButton");
    self.Exit:SetText("");
    self.Exit.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 0);
        surface.DrawRect(0, 0, w, h);

        surface.SetDrawColor(s:IsHovered() and gQuest.WhiteIsh or gQuest.LessWhite);
        surface.SetMaterial(gQuest.Materials["Exit"]);
        surface.DrawTexturedRect(0, 0, 12, 12);
    end

    self.Exit.DoClick = function()
        if (IsValid(self)) then
            self:Remove();
        end
    end

    if (not gQuest.UseQuestTracker) then
        return;
    end

    self.Tracking = self:Add("DButton");
    self.Tracking:SetText("");
    self.Tracking:SetCursor("arrow");

    self.Tracking.Alpha = 0;

    self.Tracking.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, s.Alpha);
        surface.DrawRect(2, 2, w - 4, h - 4);

        surface.SetDrawColor(0, 0, 0);
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(gQuest.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

        if (s:IsHovered()) then
            s.Alpha = self.Approach(s.Alpha, 100, 8);
        else
            s.Alpha = self.Approach(s.Alpha, 0, 2);
        end

        if (gQuest.CurrentTrackedQuest == self.QuestID) then
            gQuest.DrawTextOutlined(gQuest.L("logUnTrack"), "gQuest.16", w / 2, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
        else
            gQuest.DrawTextOutlined(gQuest.L("logTrack"), "gQuest.16", w / 2, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
        end
    end

    self.Tracking.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    self.Tracking.DoClick = function()
        if (gQuest.CurrentTrackedQuest == self.QuestID) then
            gQuest.CurrentTrackedQuest = nil;
            gQuest.AddTexts(true, gQuest.L("logNoLonger"), self.QuestName, gQuest.Red, 3);

            return;
        end

        gQuest.CurrentTrackedQuest = self.QuestID;
        gQuest.AddTexts(true, gQuest.L("LogTracking"), self.QuestName, gQuest.Green, 3);
    end
end

---
--- PerformLayout
---
function panel:PerformLayout(w, h)
    self.Exit:SetPos(w - 22, 10);
    self.Exit:SetSize(12, 12);

    if (IsValid(self.Abandon)) then
        self.Abandon:SetPos(5, h - 37);
        self.Abandon:SetSize(w - 10, 30);
    end

    if (not gQuest.UseQuestTracker) then
        return;
    end
    
    if (IsValid(self.Abandon)) then
        self.Tracking:SetPos(5, h - 72);
        self.Tracking:SetSize(w - 10, 30);
    else
        self.Tracking:SetPos(5, h - 37);
        self.Tracking:SetSize(w - 10, 30);
    end
end

---
--- Think
---
function panel:Think()
    if (not IsValid(self.PanelHolder)) then
        self:Remove();
    else
        if (not self.Initialized) then
            self:PostInit();

            self.Initialized = true;
        end
    end
end

---
--- Paint
---
function panel:Paint(w, h)
    surface.SetDrawColor(255, 255, 255, 255);
    surface.SetMaterial(gQuest.Materials["Background"]);
    surface.DrawTexturedRect(0, 0, w, h);
    surface.DrawTexturedRect(2, 2, w - 4, 30);

    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);

    surface.SetDrawColor(gQuest.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 32, w - 4, 1)

    gQuest.DrawTextOutlined(self.QuestName, "gQuest.16", 7, 9, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);

    self.TextPos = 39;
    
    gQuest.DrawTextOutlined(gQuest.L("npcQuest"), "gQuest.20", 7, self.TextPos, gQuest.RoyalBlueText, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
    local _, npcQuestHeight = surface.GetTextSize(gQuest.L("npcQuest"));
    self.TextPos = self.TextPos + npcQuestHeight;

    local ply   = LocalPlayer();
    local desc  = gQuest.FormatQuestDescription(self.Description, "{name}", ply:Nick());

    desc = gQuest.textWrap(desc, "gQuest.16", self.PredictedSize - 5);
    gQuest.DrawTextOutlined(desc, "gQuest.16", 7, self.TextPos, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);

    local _, descriptionHeight = surface.GetTextSize(desc);
    self.TextPos = (self.TextPos + descriptionHeight) + 10;

    gQuest.DrawTextOutlined(gQuest.L("npcObj"), "gQuest.20", 7, self.TextPos, gQuest.RoyalBlueText, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
    local _, objectiveHeight = surface.GetTextSize(gQuest.L("npcObj"));
    self.TextPos = self.TextPos + objectiveHeight;

    local obj = gQuest.FormatQuestDescription(self.Objective, "{name}", ply:Nick());
    obj = gQuest.textWrap(obj, "gQuest.16", self.PredictedSize - 5);
    gQuest.DrawTextOutlined(obj, "gQuest.16", 7, self.TextPos, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT);

    local _, objHeight = surface.GetTextSize(obj);
    self.TextPos = (self.TextPos + objHeight) + 10;

    gQuest.DrawTextOutlined(gQuest.L("npcRewards"), "gQuest.20", 7, self.TextPos, gQuest.RoyalBlueText, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
    local _, rewardsHeight = surface.GetTextSize(gQuest.L("npcRewards"));
    self.TextPos = self.TextPos + rewardsHeight;

    local reward = gQuest.textWrap(self.Rewards, "gQuest.16", self.PredictedSize - 5);
    gQuest.DrawTextOutlined(reward, "gQuest.16", 7, self.TextPos, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT);
end
vgui.Register("gQuest.QuestLogQuest", panel, "EditablePanel");