--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

AccessorFunc(panel, "PanelHolder", "PanelHolder");
AccessorFunc(panel, "NPC", "NPC", FORCE_NUMBER);

---
--- CreateChild
---
function panel:CreateChild(index, position)
    local nextChild = #self.Children + 1;

    self.Children[nextChild] = self.ScrollPanel:Add("DButton");

    -- Keep a refrence to the button with a neat short name instead of a long one.
    local child = self.Children[nextChild];

    child:SetText("");
    child:SetCursor("arrow");

    child.Alpha     = 0;
    child.Checked   = false;

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

        gQuest.DrawTextOutlined(index .. " | " .. position, "gQuest.16", 7, (h / 2) - 8, color, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
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

function panel:InsertExistingWaypoints()
    local routes = {};

    for i = 1, #self.NPCS do
        local npc           = self.NPCS[i];
        local npc_id        = npc.ID;
        local npc_routes    = npc.Routes;

        if (npc_id == self.NPC) then
            routes = npc_routes;

            break;
        end
    end

    for i = 1, #routes do
        local pos = routes[i];

        self:CreateChild(i, tostring(pos));
    end

    self.Routes = routes;
end

---
--- Init
---
function panel:Init()
    self.Player     = LocalPlayer();
    self.NPCS       = self.Player.gQuest_NPC_Table;
    self.Routes     = {};
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

    self.Create = self:Add("DButton")
    self.Create:SetText("");
    self.Create:SetCursor("arrow");

    self.Create.Alpha = 0;

    self.Create.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, s.Alpha);
        surface.DrawRect(2, 2, w - 4, h - 4);

        surface.SetDrawColor(0, 0, 0);
        surface.DrawOutlinedRect(0, 0, w, h);

        surface.SetDrawColor(gQuest.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

        if (s:IsHovered() or self.SelectedChild == s) then
            s.Alpha = self.Approach(s.Alpha, 100, 8);
        else
            s.Alpha = self.Approach(s.Alpha, 0, 2);
        end

        gQuest.DrawTextOutlined("Add Waypoint", "gQuest.16", w / 2, 7, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end

    self.Create.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    self.Create.DoClick = function()
        local position = self.Player:GetPos();

        table.insert(self.Routes, position);
        self:CreateChild(#self.Routes, tostring(position));

        net.Start("gQuest.UpdateRoutes");
            net.WriteUInt(self.NPC, 8);
            net.WriteUInt(#self.Routes, 8);
            net.WriteVector(position);
        net.SendToServer();
    end

    self.RemovePoints = self:Add("DButton")
    self.RemovePoints:SetText("");
    self.RemovePoints:SetCursor("arrow");

    self.RemovePoints.Alpha = 0;

    self.RemovePoints.Paint = function(s, w, h)
        surface.SetDrawColor(0, 0, 0, s.Alpha);
        surface.DrawRect(2, 2, w - 4, h - 4);

        surface.SetDrawColor(0, 0, 0);
        surface.DrawOutlinedRect(0, 0, w, h);

        surface.SetDrawColor(gQuest.Outline);
        surface.DrawOutlinedRect(1, 1, w - 2, h - 2);

        if (s:IsHovered() or self.SelectedChild == s) then
            s.Alpha = self.Approach(s.Alpha, 100, 8);
        else
            s.Alpha = self.Approach(s.Alpha, 0, 2);
        end

        gQuest.DrawTextOutlined("Remove NPC Waypoints", "gQuest.16", w / 2, 7, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end

    self.RemovePoints.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    self.RemovePoints.DoClick = function()
        local ui = vgui.Create("gQuest.NotificationMain");
        ui:SetSize(500, 200);
        ui:Center();
        ui:MakePopup();
        ui:SetHeader(gQuest.L("routeNotificationHeader"))
        ui:SetDescription(gQuest.L("routeNotificationDesc"));
        ui:SetAcceptText(gQuest.L("uiContinue"));
        ui.DoAcceptClick = function()
            local checked = self:CheckedBoxesCount();

            if (not checked or checked < 1) then
                return false;
            end

            local count = #self.Children;

            net.Start("gQuest.RemoveRoutes");
                net.WriteUInt(checked, 8);
                net.WriteUInt(self.NPC, 32);

                for i = 1, count do
                    local panel = self.Children[i];

                    if (panel.Checked) then
                        net.WriteUInt(i, 8);
                    end
                end

            net.SendToServer();

            if (IsValid(self.PanelHolder) and IsValid(self.PanelHolder.PanelHolder)) then
                self.PanelHolder.PanelHolder:Remove();
            end
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

    if (self.NPC and not self.HasAddedExistingWaypoints) then
        self:InsertExistingWaypoints();

        self.HasAddedExistingWaypoints = true;
    end
end

function panel:PerformLayout(w, h)
    self.ScrollPanel:SetPos(7, 38);
    self.ScrollPanel:SetSize(w - 14, h - 150);

    self.Create:SetPos(7, h - 107);
    self.Create:SetSize(w - 14, 30);

    self.Exit:SetPos(w - 22, 11);
    self.Exit:SetSize(12, 12);

    self.Back:SetPos(7, h - 37);
    self.Back:SetSize(w - 14, 30);

    self.RemovePoints:SetPos(7, h - 72);
    self.RemovePoints:SetSize(w - 14, 30);

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

    gQuest.DrawTextOutlined("Main/Edit Routes", "gQuest.16", 7, 9, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
end
vgui.Register("gQuest.QuestMainNPCSEditRoute", panel, "EditablePanel");