--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

net.Receive("gQuest.ConvertOldDataNotification", function()
    local ui = vgui.Create("gQuest.NotificationMain");
    ui:SetSize(500, 200);
    ui:Center();
    ui:MakePopup();
    ui:SetHeader(gQuest.L("dbConvertHeader"))
    ui:SetDescription(gQuest.L("dbConvertDesc"));
    ui:SetAcceptText(gQuest.L("dbConvertAccept"));
    ui:SetUseDecline(false);
    ui.DoAcceptClick = function(s, txt)
        net.Start("gQuest.ConvertOldData")
        net.SendToServer();
    end
end);

net.Receive("gQuest.ExportFinished", function()
    local ui = vgui.Create("gQuest.NotificationMain");
    ui:SetSize(500, 200);
    ui:Center();
    ui:MakePopup();
    ui:SetHeader(gQuest.L("dbExportNotificationHeader"))
    ui:SetDescription(gQuest.L("dbExportNotificationFinished"));
    ui:SetAcceptText(gQuest.L("npcEditRouteNAVOk"));
    ui:SetUseDecline(false);
end);

net.Receive("gQuest.ImportFinished", function()
    local ui = vgui.Create("gQuest.NotificationMain");
    ui:SetSize(500, 200);
    ui:Center();
    ui:MakePopup();
    ui:SetHeader(gQuest.L("dbExportNotificationHeader"));
    ui:SetDescription(gQuest.L("dbImportNotificationFinished"));
    ui:SetAcceptText(gQuest.L("npcEditRouteNAVOk"));
    ui:SetUseDecline(false);
end);