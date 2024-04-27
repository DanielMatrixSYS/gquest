--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

AccessorFunc(panel, "PanelHolder", "PanelHolder");

---
--- CreateChild
---
function panel:CreateChild(data)
    local nextChild = #self.Children + 1;

    self.Children[nextChild] = self.ScrollPanel:Add("DButton");

    -- Keep a refrence to the button with a neat short name instead of a long one.
    local child = self.Children[nextChild];

    child:SetText("");
    child:SetCursor("arrow");

    child.Alpha     = 0;
    child.Checked   = false;
    child.ID        = data.ID;

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

        if (s.Checked) then
            surface.SetDrawColor(255, 255, 255);
            surface.SetMaterial(gQuest.Materials["Checkmark"]);
            surface.DrawTexturedRect(w - 23, (h / 2) - 8, 16, 16);
        end

        local pos = s.Checked and 27 or 7;
        gQuest.DrawTextOutlined(data.Name, "gQuest.16", 7, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
        gQuest.DrawTextOutlined("ID: " .. data.ID, "gQuest.16", w - pos, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
    end

    child.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    child.DoClick = function(s)
        surface.PlaySound("gquest/button.mp3");

        s.Checked = !s.Checked;
    end

    return true;
end

---
--- InsertChild
--- Just a helper function towards self:CreateChild();
---
function panel:InsertChild(obj)
    self:CreateChild(obj);
end

---
--- RefillScrollPanel
---
function panel:RefillScrollPanel(newEntries)
    for i = 1, #self.Children do
        local child = self.Children[i];

        if (IsValid(child)) then
            child:Remove();
        end
    end

    table.Empty(self.Children);

    for _, v in ipairs(newEntries) do
        self:InsertChild(v);
    end
end

---
--- CheckedBoxesCount
---
function panel:CheckedBoxesCount()
    local count = 0;

    for i = 1, #self.Children do
        local panel = self.Children[i];

        if (IsValid(panel) and panel.Checked) then
            count = count + 1;
        end
    end

    return count;
end

---
--- Init
---
function panel:Init()
    self.Objectives = LocalPlayer().gQuest_Objective_Table;
    self.Children   = {};
    self.Approach   = math.Approach;

    -- ScrollPanel to hold all of our npcs.
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

    -- Search to help finding the needle in the.. whatever..
    self.Search = self:Add("DTextEntry");
    self.Search:SetDrawLanguageID(false);
    self.Search:SetText(gQuest.L("editSearch"));
    self.Search.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, 0);
        surface.DrawRect(2, 2, w - 4, h - 4);

        surface.SetDrawColor(0, 0, 0);
        surface.DrawOutlinedRect(0, 0, w, h)

        surface.SetDrawColor(gQuest.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

        s:DrawTextEntryText(gQuest.White, gQuest.Grey, gQuest.White)
    end

    self.Search.OnMousePressed = function(s)
        if (s:GetValue() == gQuest.L("editSearch")) then
            s:SetText("");
        end
    end

    self.Search.OnChange = function(s)
        local text      = s:GetValue():lower();
        local foundObj  = {};
        
        for k, v in ipairs(self.Objectives) do
            local name = v.Name:lower();

            if (name:find(text)) then
                table.insert(foundObj, v);

                continue;
            end
        end

        self:RefillScrollPanel(foundObj);
    end

    for k, v in ipairs(self.Objectives) do
        self:InsertChild(v);
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

    self.Delete = self:Add("DButton")
    self.Delete:SetText("");
    self.Delete:SetCursor("arrow");

    self.Delete.Alpha = 0;

    self.Delete.Paint = function(s, w, h)
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

        gQuest.DrawTextOutlined("Delete Selected Objectives", "gQuest.16", w / 2, 7, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end

    self.Delete.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    self.Delete.DoClick = function()
        local checked = self:CheckedBoxesCount();

        if (not checked or checked < 1) then
            return false;
        end

        local count = #self.Children;

        net.Start("gQuest.DeleteObjectives")
            net.WriteUInt(checked, 8);

            for i = 1, count do
                local panel = self.Children[i];
                
                if (panel.Checked) then
                    net.WriteString(panel.ID);
                end
            end

        net.SendToServer()

        if (IsValid(self.PanelHolder) and IsValid(self.PanelHolder.PanelHolder)) then
            self.PanelHolder.PanelHolder:Remove();
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

function panel:Think()
    if (not IsValid(self.PanelHolder)) then
        self:Remove();
    end
end

function panel:OnRemove()
    local PanelHolder = self.PanelHolder;

    if (IsValid(PanelHolder)) then
        PanelHolder.SelectedChild = nil;
    end
end

function panel:PerformLayout(w, h)
    self.Delete:SetPos(5, h - 72);
    self.Delete:SetSize(w - 10, 30);

    self.Back:SetPos(7, h - 37);
    self.Back:SetSize(w - 14, 30);

    self.Exit:SetPos(w - 22, 11);
    self.Exit:SetSize(12, 12);

    self.ScrollPanel:SetPos(7, 40);
    self.ScrollPanel:SetSize(w - 14, h - 83);

    self.Search:SetPos(w - 129, 7);
    self.Search:SetSize(100, 20);

    for i = 1, #self.Children do
        local child = self.Children[i];

        if (IsValid(child)) then
            child:SetPos(0, 35 * (i - 1));
            child:SetSize(w - 14, 30);
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

    gQuest.DrawTextOutlined("Main/Quest Obj Editor/Delete Obj's", "gQuest.16", 7, 9, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
end
vgui.Register("gQuest.QuestMainObjectivesDelete", panel, "EditablePanel");