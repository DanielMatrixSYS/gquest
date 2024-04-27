--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

AccessorFunc(panel, "PanelHolder", "PanelHolder");
AccessorFunc(panel, "Quest", "Quest");
AccessorFunc(panel, "Description", "Description", FORCE_STRING);
AccessorFunc(panel, "QuestTitle", "QuestTitle", FORCE_STRING);
AccessorFunc(panel, "PredictedSize", "PredictedSize", FORCE_NUMBER);
AccessorFunc(panel, "AvailableAnswers", "AvailableAnswers");
AccessorFunc(panel, "QuestConversations", "QuestConversations");

---
--- MakeAnswerButton
---
function panel:MakeAnswerButton(answer, next)
    local nextAnswer = #self.Answers + 1;

    self.Answers[nextAnswer] = self:Add("DButton");
    self.Answers[nextAnswer]:SetText("");

    self.Answers[nextAnswer].Alpha = 0;

    self.Answers[nextAnswer].Paint = function(s, w, h)
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
        
        gQuest.DrawTextOutlined(answer, "gQuest.16", w / 2, 7, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end

    self.Answers[nextAnswer].OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    self.Answers[nextAnswer].DoClick = function()
        local main = self.PanelHolder;

        if (type(next) == "number") then
            if (next == gQuest.GOTO_QUEST) then
                main:MakeQuest(self.Quest, "gQuest.QuestOverview");
            else
                self:DoClosingAnimation(508, .25);
            end
        else
            main:MakeNewConversation(self.Quest, next);
        end
    end
end

---
--- Init
---
function panel:Init()
    self.Answers = {};
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

    timer.Simple(0, function()
        for k, v in pairs(self.AvailableAnswers) do
            self:MakeAnswerButton(k, v);
        end
    end);
end

---
--- PerformLayout
---
function panel:PerformLayout(w, h)
    self.Exit:SetPos(w - 22, 10);
    self.Exit:SetSize(12, 12);

    for i = 1, #self.Answers do
        local b = self.Answers[i];

        if (IsValid(b)) then
            b:SetPos(5, h - 35 * i);
            b:SetSize(w - 10, 30);
        end
    end
end

---
--- Think
---
function panel:Think()
    if (not IsValid(self.PanelHolder)) then
        self:Remove();
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

    gQuest.DrawTextOutlined(self.QuestTitle, "gQuest.16", 7, 9, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);

    self.TextPos = 39;
    local title = gQuest.textWrap(self.QuestTitle, "gQuest.20", self.PredictedSize - 10);
    gQuest.DrawTextOutlined(title, "gQuest.20", 7, self.TextPos, gQuest.RoyalBlueText, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);

    local _, questHeight = surface.GetTextSize(title);
    self.TextPos = (self.TextPos + questHeight) + 5;

    local desc = gQuest.textWrap(self.Description, "gQuest.16", self.PredictedSize - 10);
    desc = gQuest.FormatQuestDescription(desc, "{name}", LocalPlayer():Nick());
    gQuest.DrawTextOutlined(desc, "gQuest.16", 7, self.TextPos, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
end
vgui.Register("gQuest.QuestConversation", panel, "EditablePanel");