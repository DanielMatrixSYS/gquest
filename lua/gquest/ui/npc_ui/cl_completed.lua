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

    self.Deliver = self:Add("DButton");
    self.Deliver:SetText("");
    self.Deliver:SetCursor("arrow");

    self.Deliver.Alpha = 0;

    self.Deliver.Paint = function(s, w, h)
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

        gQuest.DrawTextOutlined(gQuest.L("npcDeliver"), "gQuest.16", w / 2, 7, gQuest.Green, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end

    self.Deliver.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    self.Deliver.DoClick = function()
        local main = self.PanelHolder;
        local oldQuestID = self.QuestID;

        if (IsValid(main)) then
            main:Remove();
        end

        net.Start("gQuest.Deliver")
            net.WriteUInt(oldQuestID, 32);
        net.SendToServer();
    end
end

---
--- PerformLayout
---
function panel:PerformLayout(w, h)
    self.Exit:SetPos(w - 22, 10);
    self.Exit:SetSize(12, 12);

    self.Deliver:SetPos(7, h - 37);
    self.Deliver:SetSize(w - 14, 30);
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

    gQuest.DrawTextOutlined(self.QuestName, "gQuest.16", 7, 9, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);

    self.TextPos = 39;
    gQuest.DrawTextOutlined("Quest Completed", "gQuest.20", 7, self.TextPos, gQuest.RoyalBlueText, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);

    local _, questHeight = surface.GetTextSize("Quest Completed");
    self.TextPos = self.TextPos + questHeight;

    local desc = gQuest.FormatQuestDescription(self.Description, "{name}", LocalPlayer():Nick());
    desc = gQuest.textWrap(desc, "gQuest.16", self.PredictedSize - 10);
    gQuest.DrawTextOutlined(desc, "gQuest.16", 7, self.TextPos, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT);

    local _, descriptionHeight = surface.GetTextSize(desc);
    self.TextPos = (self.TextPos + descriptionHeight) + 10;

    gQuest.DrawTextOutlined(gQuest.L("npcRewards"), "gQuest.20", 7, self.TextPos, gQuest.RoyalBlueText, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
    local _, rewardsHeight = surface.GetTextSize(gQuest.L("npcRewards"));
    self.TextPos = self.TextPos + rewardsHeight;

    local reward = gQuest.textWrap(self.Rewards, "gQuest.16", self.PredictedSize - 5);
    gQuest.DrawTextOutlined(reward, "gQuest.16", 7, self.TextPos, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT);
end
vgui.Register("gQuest.QuestCompleted", panel, "EditablePanel");