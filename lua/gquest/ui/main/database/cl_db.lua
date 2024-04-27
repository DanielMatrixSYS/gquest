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
function panel:CreateChild(title, func)
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

        if (s:IsHovered()) then
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
    self.Approach       = math.Approach;

    -- The buttons we're making.
    self.Buttons = {
        {
            title = gQuest.L("dbViewQuests"),
            ui = "gQuest.QuestMainDBViewPlayers",
        },
    }

    for i = 1, #self.Buttons do
        local data  = self.Buttons[i];
        local title = data.title;
        local name  = data.ui;

        self:CreateChild(title, function(s)
            local ui = vgui.Create(name);
            ui:SetPos(self:GetWide() + 113, ((ScrH() / 2) - 508 / 2) - 50);
            ui:SetSize(0, 508);
            ui:SizeTo(349, 508, .25, 0);
            ui:MakePopup();
            ui:SetPanelHolder(self);

            self.CurrentPanel = ui;
        end);
    end

    self:CreateChild(gQuest.L("dbRefreshQuests"), function()
        local ui = vgui.Create("gQuest.NotificationMain");
        ui:SetSize(500, 200);
        ui:Center();
        ui:MakePopup();
        ui:SetHeader(gQuest.L("dbRefreshQuests"))
        ui:SetDescription(gQuest.L("dbRefreshQuestsDescExtra"));
        ui:SetAcceptText("Continue");
        ui.DoAcceptClick = function(s)
            net.Start("gQuest.QuestRefresh") net.SendToServer();

            self.PanelHolder:Remove();
        end
    end);

    self:CreateChild(gQuest.L("dbClear"), function()
        local ui = vgui.Create("gQuest.NotificationMain");
        ui:SetSize(500, 200);
        ui:Center();
        ui:MakePopup();
        ui:SetHeader(gQuest.L("dbClearNotify"))
        ui:SetDescription(gQuest.L("dbClearNotifyDesc"));
        ui:SetAcceptText(gQuest.L("uiQuestDelete"));
        ui.DoAcceptClick = function(s)
            net.Start("gQuest.DeleteQuestData") net.SendToServer();

            self.CurrentPanel = ui;
        end
    end);

    self:CreateChild(gQuest.L("dbClearNPCS"), function()
        local ui = vgui.Create("gQuest.NotificationMain");
        ui:SetSize(500, 200);
        ui:Center();
        ui:MakePopup();
        ui:SetHeader(gQuest.L("dbClearNotify"))
        ui:SetDescription(gQuest.L("dbClearNPCSHeaderDsec"));
        ui:SetAcceptText(gQuest.L("uiQuestDelete"));
        ui.DoAcceptClick = function(s)
            net.Start("gQuest.DeleteNPCData") net.SendToServer();

            self.CurrentPanel = ui;
        end
    end);

    self:CreateChild(gQuest.L("dbClearObj"), function()
        local ui = vgui.Create("gQuest.NotificationMain");
        ui:SetSize(500, 200);
        ui:Center();
        ui:MakePopup();
        ui:SetHeader(gQuest.L("dbClearNotify"))
        ui:SetDescription(gQuest.L("dbClearObjNotifyDesc"));
        ui:SetAcceptText(gQuest.L("uiQuestDelete"));
        ui.DoAcceptClick = function(s)
            net.Start("gQuest.DeleteObjData") net.SendToServer();

            self.CurrentPanel = ui;
        end
    end);

    self:CreateChild(gQuest.L("dbClearAll"), function()
        local ui = vgui.Create("gQuest.NotificationMain");
        ui:SetSize(500, 200);
        ui:Center();
        ui:MakePopup();
        ui:SetHeader(gQuest.L("dbClearNotify"))
        ui:SetDescription(gQuest.L("dbClearAllNotifyDesc"));
        ui:SetAcceptText(gQuest.L("uiQuestDelete"));
        ui.DoAcceptClick = function(s)
            net.Start("gQuest.DeleteAllData") net.SendToServer();

            self.CurrentPanel = ui;
        end
    end);

    self:CreateChild(gQuest.L("dbImportExport"), function()
        local ui = vgui.Create("gQuest.NotificationMain");
        ui:SetSize(500, 200);
        ui:Center();
        ui:MakePopup();
        ui:SetHeader(gQuest.L("dbImportExportNotificationHeader"))
        ui:SetDescription(gQuest.L("dbImportExportNotificationDesc"));
        ui:SetAcceptText(gQuest.L("dbImportExportNotificationImport"));
        ui:SetDeclineText(gQuest.L("dbImportExportNotificationExport"))
        ui.DoAcceptClick = function(s)
            local ui = vgui.Create("gQuest.NotificationMain");
            ui:SetSize(500, 200);
            ui:Center();
            ui:MakePopup();
            ui:SetHeader(gQuest.L("dbImportHeader"))
            ui:SetDescription(gQuest.L("dbImportDesc"));
            ui:SetUseDecline(false);
            ui:SetAcceptText(gQuest.L("dbSearchOk"));
            ui.DoAcceptClick = function(s)
                net.Start("gQuest.ImportData") net.SendToServer();

                self.CurrentPanel = ui;
            end

            self.CurrentPanel = ui;
        end
        
        ui.DoDeclineClick = function(s)
            local ui = vgui.Create("gQuest.NotificationMain");
            ui:SetSize(500, 200);
            ui:Center();
            ui:MakePopup();
            ui:SetHeader(gQuest.L("dbExportNotificationHeader"))
            ui:SetDescription(gQuest.L("dbExportNotificationDesc"));
            ui:SetUseDecline(false);
            ui:SetAcceptText(gQuest.L("dbSearchOk"));
            ui.DoAcceptClick = function(s)
                net.Start("gQuest.ExportData") net.SendToServer();

                self.CurrentPanel = ui;
            end

            self.CurrentPanel = ui;
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

        if (s:IsHovered()) then
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

gQuest.DrawTextOutlined("Main/Quest Database", "gQuest.16", 7, 8, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
end
vgui.Register("gQuest.QuestMainDB", panel, "EditablePanel");