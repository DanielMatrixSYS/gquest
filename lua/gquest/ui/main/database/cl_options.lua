--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

AccessorFunc(panel, "PanelHolder", "PanelHolder");
AccessorFunc(panel, "QuestID", "QuestID");
AccessorFunc(panel, "SteamID", "SteamID");

---
--- CreateChild
---
function panel:CreateChild(name, id, func)
    local nextChild = #self.Children + 1;

    self.Children[nextChild] = self:Add("DButton");

    -- Keep a refrence to the button with a neat short name instead of a long one.
    local child = self.Children[nextChild];
    
    child:SetText("");
    child:SetCursor("arrow");

    child.Alpha = 0;

    child.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, s.Alpha);
        surface.DrawRect(2, 2, w - 4, h - 4);

        surface.SetDrawColor(0, 0, 0);
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(gQuest.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

        if (s:IsHovered() or self.SelectedChild == s) then
            s.Alpha = self.Approach(s.Alpha, 100, 8);
        else
            s.Alpha = self.Approach(s.Alpha, 0, 2);
        end

         gQuest.DrawTextOutlined(name, "gQuest.16", 7, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
    end

    child.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    child.DoClick = function(s)
        surface.PlaySound("gquest/button.mp3");

        func(s);
    end

    return true;
end

---
--- Init
---
function panel:Init()
    self.Children   = {};
    self.Approach   = math.Approach;

    self.PanelData = {
        {
            name = "Force complete this quest",
            cType = QUEST_COMPLETE;
        },

        {
            name = "Force remove this quest",
            cType = QUEST_REMOVE;
        },

        {
            name = "Force remove quest cooldown",
            cType = QUEST_REMOVE_CD;
        },

        {
            name = "Force reset objective count",
            cType = QUEST_RESET_OBJ;
        }
    }

    for i = 1, #self.PanelData do
        local data  = self.PanelData[i];
        local name  = data.name;
        local cType = data.cType;

        self:CreateChild(name, id, function()
            net.Start("gQuest.RequestQuestChange");
                net.WriteUInt(cType, 4);
                net.WriteUInt(tonumber(self.QuestID), 32);
                net.WriteString(self.SteamID);
            net.SendToServer();
        end);
    end

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

        if (s:IsHovered() or self.SelectedChild == s) then
            s.Alpha = self.Approach(s.Alpha, 100, 8);
        else
            s.Alpha = self.Approach(s.Alpha, 0, 2);
        end

        gQuest.DrawTextOutlined(gQuest.L("Go Back"), "gQuest.16", w / 2, 7, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
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
--- Think
---
function panel:Think()
    if (not IsValid(self.PanelHolder)) then
        self:Remove();
    end
end

---
--- PerformLayout
---
function panel:PerformLayout(w, h)
    self.Back:SetPos(7, h - 37);
    self.Back:SetSize(w - 14, 30);

    self.Exit:SetPos(w - 22, 11);
    self.Exit:SetSize(12, 12);

    for i = 1, #self.Children do
        local panel = self.Children[i];

        panel:SetPos(7, 38 + 35 * (i - 1));
        panel:SetSize(w - 14, 30);
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

    gQuest.DrawTextOutlined("Quest Options", "gQuest.16", 7, 9, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
end
vgui.Register("gQuest.QuestMainDBPlayerQuestOptions", panel, "EditablePanel");