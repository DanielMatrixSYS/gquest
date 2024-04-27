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

    self.Accept = self:Add("DButton");
    self.Accept:SetText("");
    self.Accept:SetCursor("arrow");

    self.Accept.Alpha = 0;

    self.Accept.Paint = function(s, w, h)
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

        if (self.EndTime) then
            local expires = self.EndTime - os.time();

            if (expires > 0) then
                gQuest.DrawTextOutlined(gQuest.L("npcCooldown", string.NiceTime(expires)), "gQuest.16", w / 2, 7, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
            else
                gQuest.DrawTextOutlined(gQuest.L("npcAccept"), "gQuest.16", w / 2, 7, gQuest.Green, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
            end
        else
            gQuest.DrawTextOutlined(gQuest.L("npcAccept"), "gQuest.16", w / 2, 7, gQuest.Green, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
        end
    end

    self.Accept.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    self.Accept.DoClick = function()
        if (self.EndTime and self.EndTime - os.time() > 0) then
            return;
        end

        local main = self.PanelHolder;
        if (IsValid(main)) then
            main:Remove();
        end

        net.Start("gQuest.AcceptQuest");
            net.WriteUInt(self.QuestID, 32);
            net.WriteString(self.QuestName);
        net.SendToServer();
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

        gQuest.DrawTextOutlined("Nevermind", "gQuest.16", w / 2, 7, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end

    self.Back.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    self.Back.DoClick = function()
        if (IsValid(self)) then
            self:SizeTo(0, 508, .25, 0, -1, function(tbl, panel)
                if (IsValid(panel)) then
                    panel:Remove();
                end
            end);
        end
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

    self.Accept:SetPos(7, h - 72);
    self.Accept:SetSize(w - 14, 30);
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
vgui.Register("gQuest.QuestOverview", panel, "EditablePanel");