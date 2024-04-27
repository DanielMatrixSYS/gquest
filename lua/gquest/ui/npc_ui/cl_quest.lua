--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel     = {};
local tocolor   = string.ToColor;

AccessorFunc(panel, "QuestGiver", "QuestGiver");

---
--- MakeNewConversation
---
function panel:MakeNewConversation(quest, con)
    if (IsValid(self.CurrentPanel)) then
        self.CurrentPanel:DoClosingAnimation(508, .25);
    end

    local ui = vgui.Create("gQuest.QuestConversation");
    ui:SetPos(self:GetWide() + 100, ((ScrH() / 2) - 508 / 2) - 50);
    ui:SetSize(0, 508);
    ui:SizeTo(349, 508, .25, 0);
    ui:SetPanelHolder(self);
    ui:SetQuest(quest);
    ui:SetDescription(con.desc);
    ui:SetQuestTitle(con.title);
    ui:SetAvailableAnswers(con.answers);
    ui:SetQuestConversations(con);
    ui:SetPredictedSize(349);

    self.CurrentPanel = ui;
end

---
--- MakeQuest
---
function panel:MakeQuest(quest, typ)
    if (IsValid(self.CurrentPanel)) then
        self.CurrentPanel:DoClosingAnimation(508, .25);
    end

    local ui = vgui.Create(typ);

    if (typ == "gQuest.QuestCompleted") then
        ui:SetDescription(quest.OnCompleteDescription);
    else
        ui:SetDescription(quest.Description);
    end

    if (quest.Cooldown and typ == "gQuest.QuestOverview") then
        ui:SetEndTime(quest.Cooldown);
    end

    ui:SetObjective(quest.Objective);
    ui:SetRewards(quest.Rewards);
    ui:SetPos(self:GetWide() + 100, ((ScrH() / 2) - 508 / 2) - 50);
    ui:SetSize(0, 508);
    ui:SizeTo(349, 508, .25, 0);
    ui:SetPanelHolder(self);
    ui:SetQuestName(quest.Name);
    ui:SetQuestID(quest.ID);
    ui:SetPredictedSize(349);
    
    self.CurrentPanel = ui;
end

---
--- CreateQuest
---
function panel:CreateQuest(name, status, met, func)
    local nextButton = #self.QuestButtons + 1;

    self.QuestButtons[nextButton] = self:Add("DButton");

    local button = self.QuestButtons[nextButton];
    
    button:SetText("");
    button:SetCursor("arrow");

    button.Alpha = 0;

    button.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, s.Alpha);
        surface.DrawRect(2, 2, w - 4, h - 4);

        surface.SetDrawColor(0, 0, 0);
        surface.DrawOutlinedRect(0, 0, w, h)

        -- 1 = neither.
        -- 2 = taken.
        -- 3 = completed.
        
        local outlineColor = gQuest.Outline;
        if (status == 3) then
            outlineColor = gQuest.Green;
        elseif(status == 2) then
            outlineColor = gQuest.RoyalBlue;
        end
        
        -- We don't want to adjust the opacity of the outline unless it has been changed,
        -- to a non outline color, such as, blue or green.
        if (status ~= 1) then
            outlineColor = self.ColorAlpha(outlineColor, 75);
        end
        
        surface.SetDrawColor(outlineColor);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

        if (s:IsHovered() or self.SelectedChild == s) then
            s.Alpha = self.Approach(s.Alpha, 100, 8);
        else
            s.Alpha = self.Approach(s.Alpha, 0, 2);
        end

        if (met ~= nil) then
            if (not met[1]) then
                gQuest.DrawTextOutlined("Level: " .. met[2], "gQuest.16", w - 7, 7, gQuest.Red, gQuest.Black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
            else
                gQuest.DrawTextOutlined("Level: " .. met[2], "gQuest.16", w - 7, 7, gQuest.Green, gQuest.Black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
            end
        end

        gQuest.DrawTextOutlined(name, "gQuest.16", 7, 7, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
    end

    button.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    button.DoClick = function(s)
        surface.PlaySound("gquest/button.mp3");

        if (IsValid(self.SelectedChild)) then
            if (self.SelectedChild == s) then
                if (IsValid(self.CurrentPanel)) then
                    self.CurrentPanel:DoClosingAnimation(508, .25);
                end

                self.SelectedChild = nil;
                return;
            end

            if (IsValid(self.CurrentPanel)) then
                self.CurrentPanel:DoClosingAnimation(508, .25);
            end
        end

        self.SelectedChild = s;
        func(s);
    end
end

---
--- Init
---
function panel:Init()
    self.Approach       = math.Approach;
    self.ColorAlpha     = ColorAlpha;
    self.QuestButtons   = {};
    self.CurrentPanel   = nil;
    self.SelectedChild  = nil;
    self.Showing        = 0;

    -- Other
    local greyAlpha = 200;
    self.Exit = self:Add("DButton");
    self.Exit:SetText("");
    self.Exit:SetCursor("arrow");
    self.Exit.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 0);
        surface.DrawRect(0, 0, w, h);

        surface.SetDrawColor(ColorAlpha(gQuest.Grey, greyAlpha));
        surface.SetMaterial(gQuest.Materials["Exit"]);
        surface.DrawTexturedRect(0, 0, 12, 12);

        if (s:IsHovered()) then
            greyAlpha = self.Approach(greyAlpha, 150, 2)
        else
            greyAlpha = self.Approach(greyAlpha, 200, 2);
        end
    end

    self.Exit.DoClick = function()
        if (IsValid(self)) then
            self:Remove();
        end
    end

    for k, v in ipairs(gQuest.Quests) do
        if (not v.Show) then
            continue;
        end

        self.Showing = self.Showing + 1;

        local status = 1;
        local levelTable = nil;

        if (v.Taken) then
            status = 2;
        end

        if (v.Completed) then
            status = 3;
        end

        if (v.LevelRequirement and v.LevelRequirementMet ~= nil) then
            levelTable = {v.LevelRequirementMet, v.LevelRequirement};
        end

        self:CreateQuest(v.Name, status, levelTable, function(button)
            if (levelTable ~= nil) then
                if (not levelTable[1]) then
                    return;
                end
            end

            if (v.Taken) then
                self:MakeQuest(v, "gQuest.QuestAbandon")
            end

            if (v.Completed) then
                self:MakeQuest(v, "gQuest.QuestCompleted")
            end

            if (not v.Taken and not v.Completed) then
                if (v.PreQuestConversation) then
                    self:MakeNewConversation(v, v.PreQuestConversation);
                else
                    self:MakeQuest(v, "gQuest.QuestOverview");
                end
            end
        end);
    end

    self.Back = self:Add("DButton")
    self.Back:SetText("");
    self.Back:SetCursor("arrow");

    self.Back.Alpha = 0;

    self.Back.Paint = function(s, w, h)
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

        gQuest.DrawTextOutlined("Exit", "gQuest.16", w / 2, 7, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end

    self.Back.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    self.Back.DoClick = function()
        if (IsValid(self)) then
            self:Remove();
        end
    end
end

function panel:Think()
    if (not IsValid(self.CurrentPanel)) then
        self.SelectedChild = nil;
    end

    if (IsValid(self.QuestGiver) and self.QuestGiver:GetPos():DistToSqr(LocalPlayer():GetPos()) >= 250 ^ 2) then
        if (IsValid(self)) then
            self:Remove();
        end
    end
end

---
--- PerformLayout
---
function panel:PerformLayout(w, h)
    self.Exit:SetPos(w - 22, 11);
    self.Exit:SetSize(12, 12);

    self.Back:SetPos(7, h - 37);
    self.Back:SetSize(w - 14, 30);

    for i = 1, #self.QuestButtons do
        local b = self.QuestButtons[i];

        if (IsValid(b)) then
            b:SetPos(7, 38 + (35 * (i - 1)));
            b:SetSize(w - 14, 30);
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
    
    local header = self.QuestGiver:GetHeader();
    local hColor = tocolor(self.QuestGiver:GetNW2String("gquest_header_color", "255 255 255 255"));

    header = header:Replace("{name}", LocalPlayer():Nick());

    gQuest.DrawTextOutlined(header, "gQuest.16", 7, 8, hColor, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);

    if (self.Showing < 1) then
        gQuest.DrawTextOutlined("There are no available quests for you at this time.", "gQuest.16", w / 2, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end
end
vgui.Register("gQuest.QuestUI", panel, "EditablePanel");