--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

---
--- CreateChild
---
function panel:CreateChild(name, quest_id, func)
    func = func or function() return; end

    -- Objectives
    local str;
    if (self.Objectives and next(self.Objectives)) then
        for k, v in ipairs(self.Objectives) do
            if (v.quest_id == quest_id) then
                str = v.quest_progress .. "/" .. v.quest_progress_max;
            end
        end
    end

    local nextButton = #self.QuestButtons + 1;
    self.QuestButtons[nextButton] = self:Add("DButton");
    self.QuestButtons[nextButton]:SetText("");
    self.QuestButtons[nextButton]:SetCursor("arrow");
    self.QuestButtons[nextButton].Progress = str;
    self.QuestButtons[nextButton].Alpha = 0;
    self.QuestButtons[nextButton].Paint = function(s, w, h)
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

        gQuest.DrawTextOutlined(name or "", "gQuest.16", 7, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);

        local timeLeft = tonumber(LocalPlayer():GetPrivateGQString("quest_" .. quest_id .. "_timeleft", 0));
        if (timeLeft > 0) then
            local col = (timeLeft <= timeLeft / 20 and gQuest.Red or gQuest.RoyalBlueText);

            gQuest.DrawTextOutlined((s.Progress or "") .. " - " .. ("Time left: " .. string.NiceTime(timeLeft - os.time())), "gQuest.16", w - 5, (h / 2) - 8, col, gQuest.Black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
        else
            gQuest.DrawTextOutlined(s.Progress or "", "gQuest.16", w - 5, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
        end
    end

    self.QuestButtons[nextButton].OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    self.QuestButtons[nextButton].DoClick = function(s)
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
    local ply = LocalPlayer();
    self.Approach = math.Approach;

    self.AcceptedQuests = string.Explode(",", ply:GetPrivateGQString("CurrentQuests", ""));
    self.Objectives = util.JSONToTable(ply:GetPrivateGQString("QuestObjectives", "[]"));
    self.Word = "";
    self.W = ScrW()
    self.Size = 349;

    -- Variables
    self.QuestButtons = {};
    self.CurrentPanel = nil;
    self.SelectedChild = nil;
    
    local greyAlpha = 200;
    self.Exit = self:Add("DButton");
    self.Exit:SetText("");
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

    if (not self.AcceptedQuests or not next(self.AcceptedQuests) or self.AcceptedQuests[1] == "") then
        self.Word = gQuest.L("logNoQuests");

        return;
    end

    for k, v in ipairs(self.AcceptedQuests) do
        local v = tonumber(v);
        local questTable = gQuest.GetQuestTable(v);

        if (not questTable) then
            continue;
        end

        self:CreateChild(questTable.Name, v, function()
            if (IsValid(self.CurrentPanel)) then
                self.CurrentPanel:DoClosingAnimation(508, .25);
            end

            local ui = vgui.Create("gQuest.QuestLogQuest");
            ui:SetPos((self.W - self.Size) - 75, ((ScrH() / 2) - 508 / 2) - 50);
            ui:SetSize(self.Size, 508);
            ui:MoveTo(((self.W - self.Size) - 75) - self:GetWide() - 25, ((ScrH() / 2) - 508 / 2) - 50, .25);
            ui:SetPanelHolder(self);
            ui:SetQuestName(questTable.Name);
            ui:SetQuestID(questTable.ID);
            ui:SetDescription(questTable.Description);
            ui:SetObjective(questTable.Objective);
            ui:SetRewards(questTable.Rewards);
            ui:SetPredictedSize(self.Size);
            
            self.CurrentPanel = ui;
        end);
    end
end

---
--- PerformLayout
---
function panel:PerformLayout(w, h)
    self.Exit:SetPos(w - 22, 10);
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
--- OnKeyCodePressed
---
function panel:OnKeyCodePressed(key)
    if (IsValid(self) and key == gQuest.QuestLogButton) then
        self:Remove();
    end
end

---
--- OnRemove
---
function panel:OnRemove()
    timer.Simple(0, function()
        gQuest.CanOpenQuestLog = true;
    end);
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

    gQuest.DrawTextOutlined(string.upper(self.Word), "gQuest.20", w / 2, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER);
end
vgui.Register("gQuest.QuestLog", panel, "EditablePanel");