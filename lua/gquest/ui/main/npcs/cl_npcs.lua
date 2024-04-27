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
function panel:CreateChild(force, title, func)
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

        gQuest.DrawTextOutlined(title, "gQuest.16", 7, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
    end

    child.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    child.DoClick = function(s)
        surface.PlaySound("gquest/button.mp3");

        local pSysDisabled = tobool(LocalPlayer():GetPrivateGQString("patrol_system_disabled", true));
        if (not pSysDisabled and not force) then
            local noti = vgui.Create("gQuest.NotificationMain");
            noti:SetSize(500, 200);
            noti:Center();
            noti:MakePopup();
            noti:SetHeader(gQuest.L("npcEditBeforeHeader"))
            noti:SetDescription(gQuest.L("npcEditBeforeDesc"));
            noti:SetUseDecline(false);
            noti:SetAcceptText(gQuest.L("npcEditRouteNAVOk"));

            return;
        end

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

    return true;
end

---
--- Init
---
function panel:Init()
    self.Children       = {};
    self.CurrentPanel   = nil;
    self.SelectedChild  = nil;
    self.Approach       = math.Approach;

    -- The buttons we're making.
    self.Buttons = {
        {
            material = gQuest.Materials["NPCS"],
            title = gQuest.L("uiCreateNewNPC"),
            ui = "gQuest.QuestMainNPCSCreate",
        },

        {
            material = gQuest.Materials["NPCS"],
            title = gQuest.L("uiEditNPCS"),
            ui = "gQuest.QuestMainNPCSEdit",
        },

        {
            material = gQuest.Materials["NPCS"],
            title = gQuest.L("uiDeleteNPC"),
            ui = "gQuest.QuestMainNPCSDelete",
        },
    }

    for i = 1, #self.Buttons do
        local data  = self.Buttons[i];
        local title = data.title;
        local mat   = data.material;
        local name  = data.ui;

        self:CreateChild(mat, title, function(s)
            local ui = vgui.Create(name);
            ui:SetPos(self:GetWide() + 113, ((ScrH() / 2) - 508 / 2) - 50);
            ui:SetSize(0, 508);
            ui:SizeTo(349, 508, .25, 0);
            ui:MakePopup();
            ui:SetPanelHolder(self);

            self.CurrentPanel = ui;
        end);
    end

    -- Some of the buttons have their own function to check for certain things.
    -- To make things simple, I'm just gonna manually add the children instead of inserting them into the table above.

    self:CreateChild(false, gQuest.L("npcEditRoutes"), function()
        local svHasNav = tobool(LocalPlayer():GetPrivateGQString("server_has_nav_file", false));

        if (svHasNav) then
            local ui = vgui.Create("gQuest.QuestMainNPCSRoutes");
            ui:SetPos(self:GetWide() + 113, ((ScrH() / 2) - 508 / 2) - 50);
            ui:SetSize(0, 508);
            ui:SizeTo(349, 508, .25, 0);
            ui:SetPanelHolder(self);
            ui:MakePopup();

            self.CurrentPanel = ui;
        else
            local ui = vgui.Create("gQuest.NotificationMain");
            ui:SetSize(500, 200);
            ui:Center();
            ui:MakePopup();
            ui:SetHeader(gQuest.L("npcEditRouteNAVHeader"))
            ui:SetDescription(gQuest.L("npcEditRouteNAVDesc"));
            ui:SetAcceptText(gQuest.L("npcEditRouteNAVOk"));
            ui:SetUseDecline(false);
        end
    end);

    self:CreateChild(false, gQuest.L("uiSaveAllNPCS"), function()
        local ui = vgui.Create("gQuest.NotificationMain");
        ui:SetSize(500, 200);
        ui:Center();
        ui:MakePopup();
        ui:SetHeader(gQuest.L("uiSaveAllHeader"))
        ui:SetDescription(gQuest.L("uiSaveAllHeaderDesc"));
        ui:SetAcceptText(gQuest.L("uiSaveAllAccept"));
        ui.DoAcceptClick = function()
            net.Start("gQuest.SaveAllNPCS") net.SendToServer()
        end

        if (IsValid(self.PanelHolder)) then
            self.PanelHolder:Remove();
        end
    end);

    self:CreateChild(false, gQuest.L("uiRespawnAllNPCS"), function()
        local ui = vgui.Create("gQuest.NotificationMain");
        ui:SetSize(500, 200);
        ui:Center();
        ui:MakePopup();
        ui:SetHeader(gQuest.L("uiRespawnNPCSHeader"))
        ui:SetDescription(gQuest.L("uiRespawnNPCSHeaderDesc"));
        ui.DoAcceptClick = function()
            net.Start("gQuest.RespawnNPCS") 
                net.WriteBool(false)
            net.SendToServer()
        end

        ui.DoDeclineClick = function()
            if (not IsValid(self)) then
                return;
            end
        end

        if (IsValid(self.PanelHolder)) then
            self.PanelHolder:Remove();
        end
    end);

    self:CreateChild(false,gQuest.L("uiDespawnNPCS"), function()
        local ui = vgui.Create("gQuest.NotificationMain");
        ui:SetSize(500, 200);
        ui:Center();
        ui:MakePopup();
        ui:SetHeader(gQuest.L("uiDespawnNPCS"))
        ui:SetDescription(gQuest.L("uiDespawnNPCSHeaderDesc"));
        ui.DoAcceptClick = function()
            net.Start("gQuest.RespawnNPCS") 
                net.WriteBool(true)
            net.SendToServer()
        end

        if (IsValid(self.PanelHolder)) then
            self.PanelHolder:Remove();
        end
    end);

    local pSysDisabled = tobool(LocalPlayer():GetPrivateGQString("patrol_system_disabled", true));
    self:CreateChild(true, pSysDisabled and gQuest.L("npcEnablePatrol") or gQuest.L("npcDisablePatrol"), function()
        local ui = vgui.Create("gQuest.NotificationMain");
        ui:SetSize(500, 200);
        ui:Center();
        ui:MakePopup();
        ui:SetHeader(pSysDisabled and gQuest.L("npcEnablePatrol") or gQuest.L("npcDisablePatrol"))
        ui:SetDescription(pSysDisabled and gQuest.L("npcEnablePatrolDesc") or gQuest.L("npcDisablePatrolDesc"));
        ui.DoAcceptClick = function()
            net.Start("gQuest.ChangePatrolBool");
                net.WriteBool(not pSysDisabled);
            net.SendToServer();
        end

        if (IsValid(self.PanelHolder)) then
            self.PanelHolder:Remove();
        end
    end);

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
    self.Exit:SetPos(w - 22, 11);
    self.Exit:SetSize(12, 12);

    self.Back:SetPos(7, h - 37);
    self.Back:SetSize(w - 14, 30);

    for i = 1, #self.Children do
        local child = self.Children[i];

        child:SetPos(7, 38 + (35 * (i - 1)));
        child:SetSize(w - 14, 30);
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

    gQuest.DrawTextOutlined("Main/Quest NPC Editor", "gQuest.16", 7, 8, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
end
vgui.Register("gQuest.QuestMainNPCS", panel, "EditablePanel");