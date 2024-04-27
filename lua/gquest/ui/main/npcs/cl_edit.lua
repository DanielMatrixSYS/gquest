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
function panel:CreateChild(title, color, id, func)
    local nextChild = #self.Children + 1;
    local color     = color:ToColor();

    self.Children[nextChild] = self.ScrollPanel:Add("DButton");

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

        gQuest.DrawTextOutlined(title, "gQuest.16", 7, (h / 2) - 8, color, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
        gQuest.DrawTextOutlined("ID: " .. id, "gQuest.16", w - 7, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
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
--- InsertChild
--- Just a helper function towards self:CreateChild();
---
function panel:InsertChild(npc)
    self:CreateChild(npc.Header, npc.HeaderColor, npc.ID, function()
        local ui = vgui.Create("gQuest.QuestMainNPCSEditNPC");
        ui:SetPos(self:GetWide() + 113, ((ScrH() / 2) - 508 / 2) - 50);
        ui:SetSize(0, 508);
        ui:SizeTo(349, 508, .25, 0);
        ui:SetNPC(npc.ID);
        ui:SetPanelHolder(self:GetPanelHolder());
        ui:MakePopup();

        self:GetPanelHolder().CurrentPanel = ui;
    end);
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
--- Init
---
function panel:Init()
    self.NPCS       = LocalPlayer().gQuest_NPC_Table;
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
    self.Search:SetFont("gQuest.16");
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
        local text = s:GetValue():lower();
        local foundNPCS = {};
        
        for k, v in ipairs(self.NPCS) do
            local header = v.Header:lower();

            if (header:find(text)) then
                table.insert(foundNPCS, v);

                continue;
            end

            local subHeader = v.SubHeader:lower();
            if (subHeader:find(text)) then
                table.insert(foundNPCS, v);

                continue;
            end
        end

        self:RefillScrollPanel(foundNPCS);
    end

    for k, v in ipairs(self.NPCS) do
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
    self.ScrollPanel:SetPos(7, 40);
    self.ScrollPanel:SetSize(w - 14, h - 83);

    self.Back:SetPos(7, h - 37);
    self.Back:SetSize(w - 14, 30);

    self.Search:SetPos(w - 129, 7);
    self.Search:SetSize(100, 20);

    self.Exit:SetPos(w - 22, 11);
    self.Exit:SetSize(12, 12);

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

    gQuest.DrawTextOutlined("Main/Quest NPC Editor/Edit", "gQuest.16", 7, 9, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
end
vgui.Register("gQuest.QuestMainNPCSEdit", panel, "EditablePanel");