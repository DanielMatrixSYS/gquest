--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

AccessorFunc(panel, "PanelHolder", "PanelHolder");
AccessorFunc(panel, "Objective", "Objective", FORCE_NUMBER);

---
--- CreateEditablePanel
--- 
function panel:CreateEditablePanel(name, example, editable)
    local nextPanel = #self.Panels + 1;

    -- Add this to our scroll panel instead of main panel.
    self.Panels[nextPanel] = self.ScrollPanel:Add("DPanel");

    local panel = self.Panels[nextPanel];

    panel.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 0);
        surface.DrawRect(2, 2, w - 4, h - 4);

        surface.SetDrawColor(0, 0, 0);
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(gQuest.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

        gQuest.DrawTextOutlined(name, "gQuest.16", 6, 4, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
    end

    panel.PerformLayout = function(s, w, h)
        if (IsValid(s.TextEntry)) then
            s.TextEntry:SetPos(7, 23);
            s.TextEntry:SetSize(w - 14, 30);
        end
    end

    panel.TextEntry = panel:Add("DTextEntry");
    panel.TextEntry:SetFont("gQuest.16");
    panel.TextEntry:SetText(tostring(example));
    panel.TextEntry:SetDrawLanguageID(false);
    panel.TextEntry:SetEditable(editable);

    panel.TextEntry.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 0);
        surface.DrawRect(2, 2, w - 4, h - 4);

        surface.SetDrawColor(0, 0, 0);
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(gQuest.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

        s:DrawTextEntryText(gQuest.White, gQuest.Grey, gQuest.White)
    end
end

---
--- PostInit
---
function panel:PostInit()
    self.Initialized    = true;
    self.FoundObj       = nil;

    for k, v in ipairs(LocalPlayer().gQuest_Objective_Table) do
        if (tonumber(v.ID) == self.Objective) then
            self.FoundObj = v;

            break;
        end
    end

    if (not self.FoundObj) then
        return;
    end

    local npc = self.FoundObj;
    self.PanelData = {
        {
            name = "Objective Name. Something easy you can remember.",
            example = npc.Name,
            editable = true,
        },

        {
            name = "Entity Class",
            example = npc.Entity,
            editable = true,
        },

        {
            name = "Quests this entity belongs to, seperate with commas",
            example = npc.Quests,
            editable = true,
        },

        {
            name = "Entity Position",
            example = npc.Position,
            editable = true,
        },

        {
            name = "Entity Angle",
            example = npc.Angle,
            editable = true,
        },
    }

    for i = 1, #self.PanelData do
        local data      = self.PanelData[i];
        local name      = data.name;
        local example   = data.example;
        local editable  = data.editable;

        self:CreateEditablePanel(name, example, editable);
    end

    self.Save = self:Add("DButton")
    self.Save:SetText("");
    self.Save:SetCursor("arrow");

    self.Save.Alpha = 0;

    self.Save.Paint = function(s, w, h)
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

        gQuest.DrawTextOutlined("Confirm & Save", "gQuest.16", w / 2, 6, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end

    self.Save.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    self.Save.DoClick = function()
        local count = #self.Panels;

        net.Start("gQuest.SaveObjectives")
            net.WriteUInt(count, 8);
            net.WriteUInt(self.Objective, 16);

            for i = 1, count do
                local panels    = self.Panels[i];
                local data      = panels.TextEntry;
                local value     = data:GetValue();

                net.WriteString(value);
            end

        net.SendToServer();

        if (IsValid(self.PanelHolder) and IsValid(self.PanelHolder.PanelHolder)) then
            self.PanelHolder.PanelHolder:Remove();
        end
    end
end

---
--- Init
---
function panel:Init()
    self.Approach   = math.Approach;
    self.Panels     = {};
    self.Player     = LocalPlayer();

    -- There is way too much that needs to be displayed for our tiny little panel,
    -- so we need a scroll panel.
    self.ScrollPanel = self:Add("DScrollPanel");
    local vBar = self.ScrollPanel:GetVBar();

    vBar:SetWidth(0);

    vBar.Paint = function()
        return true;
    end

    vBar.btnUp.Paint = function()
        return true;
    end

    vBar.btnDown.Paint = function()
        return true;
    end

    vBar.btnGrip.Paint = function()
        return true;
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
end

---
--- Think
---
function panel:Think()
    if (not IsValid(self.PanelHolder)) then
        self:Remove();
    end

    if (not self.Initialized and IsValid(self.PanelHolder)) then
        self:PostInit();
    end
end

function panel:OnRemove()
    local PanelHolder = self.PanelHolder;

    if (IsValid(PanelHolder)) then
        PanelHolder.SelectedChild = nil;
    end
end

---
--- PerformLayout
---
function panel:PerformLayout(w, h)
    self.ScrollPanel:SetPos(7, 37);
    self.ScrollPanel:SetSize(w - 14, h - 114);

    self.Save:SetPos(7, h - 72);
    self.Save:SetSize(w - 14, 30);

    self.Exit:SetPos(w - 22, 11);
    self.Exit:SetSize(12, 12);

    self.Back:SetPos(7, h - 37);
    self.Back:SetSize(w - 14, 30);

    for i = 1, #self.Panels do
        local panel = self.Panels[i];

        panel:SetPos(0, 65 * (i - 1));
        panel:SetSize(w - 14, 60);
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

    gQuest.DrawTextOutlined("Main/Quest Obj Editor/Edit/" .. self.Objective, "gQuest.16", 7, 9, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
end
vgui.Register("gQuest.QuestMainObjectivesEdit", panel, "EditablePanel");