--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

AccessorFunc(panel, "Header", "Header", FORCE_STRING);
AccessorFunc(panel, "Description", "Description", FORCE_STRING);
AccessorFunc(panel, "UseDecline", "UseDecline", FORCE_BOOL);
AccessorFunc(panel, "AcceptText", "AcceptText", FORCE_STRING);
AccessorFunc(panel, "DeclineText", "DeclineText", FORCE_STRING);
AccessorFunc(panel, "TextEntry", "TextEntry", FORCE_BOOL);

---
--- DoAcceptClick
---
function panel:DoAcceptClick()
    return true;
end

---
--- DoDeclineClick
---
function panel:DoDeclineClick()
    return true;
end

---
--- Init
---
function panel:Init()
    self.BlurTime = SysTime();
    self.Approach = math.Approach;

    self.Accept = self:Add("DButton")
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

        if (s:IsHovered() or self.SelectedChild == s) then
            s.Alpha = self.Approach(s.Alpha, 100, 8);
        else
            s.Alpha = self.Approach(s.Alpha, 0, 2);
        end

        self.AcceptText = self.AcceptText or gQuest.L("uiContinue");
        gQuest.DrawTextOutlined(self.AcceptText, "gQuest.16", w / 2, 7, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end

    self.Accept.DoClick = function()
        surface.PlaySound("gquest/button.mp3");

        if (IsValid(self)) then
            self:Remove()

            local value = self.DeleteNPCEntry:IsVisible() and self.DeleteNPCEntry:GetValue() or false;
            if (not value) then
                self:DoAcceptClick();
            else
                self:DoAcceptClick(value);
            end
        end
    end

    self.Accept.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    self.Decline = self:Add("DButton")
    self.Decline:SetText("");
    self.Decline:SetCursor("arrow");

    self.Decline.Alpha = 0;

    self.Decline.Paint = function(s, w, h)
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

        self.DeclineText = self.DeclineText or gQuest.L("uiDecline");
        gQuest.DrawTextOutlined(self.DeclineText, "gQuest.16", w / 2, 7, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end

    self.Decline.DoClick = function()
        surface.PlaySound("gquest/button.mp3");

        if (IsValid(self)) then
            self:Remove()

            self:DoDeclineClick();
        end
    end

    self.Decline.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    self.DeleteNPCEntry = self:Add("DTextEntry");
    self.DeleteNPCEntry:SetText("");
    self.DeleteNPCEntry:SetFont("gQuest.16");
    self.DeleteNPCEntry:SetDrawLanguageID(false);
    self.DeleteNPCEntry:SetUpdateOnType(true);
    self.DeleteNPCEntry.Paint = function(s, w, h)
        surface.SetDrawColor(gQuest.Black);
        surface.DrawRect(0, 0, w, h);

        surface.SetDrawColor(gQuest.RoyalBlue);
        surface.DrawOutlinedRect(0, 0, w, h);

        s:DrawTextEntryText(gQuest.White, Color(30, 130, 255), gQuest.White);
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
    if (self.UseDecline == false and self.Decline:IsVisible()) then
        self.Decline:SetVisible(false);

        self.Accept:SetPos(self:GetWide() / 4, self:GetTall() - 30);
        self.Accept:SetSize(self:GetWide() / 2, 25)
    end

    if ((self.TextEntry == false or self.TextEntry == nil) and self.DeleteNPCEntry:IsVisible()) then
        self.DeleteNPCEntry:SetVisible(false);
    end
end

---
--- PerformLayout
---
function panel:PerformLayout(w, h)
    if (self.UseDecline ~= false) then
        self.Accept:SetPos(7, h - 37);
        self.Accept:SetSize((w / 2) - 14, 30);
    end

    if (self.TextEntry) then
        local _, y = surface.GetTextSize(gQuest.textWrap(self.Description, "gQuest.16", w - 10));

        self.DeleteNPCEntry:SetPos(w / 4, (y + 30) + 25);
        self.DeleteNPCEntry:SetSize(w / 2, 30);
    end

    self.Decline:SetPos((w / 2) + 7, h - 37);
    self.Decline:SetSize((w / 2) - 14, 30);

    self.Exit:SetPos(w - 22, 11);
    self.Exit:SetSize(12, 12);
end

---
--- Paint
---
function panel:Paint(w, h)
    Derma_DrawBackgroundBlur(self, self.BlurTime);

    surface.SetDrawColor(255, 255, 255, 255);
    surface.SetMaterial(gQuest.Materials["Background"]);
    surface.DrawTexturedRect(0, 0, w, h);
    surface.DrawTexturedRect(2, 2, w - 4, 30);

    surface.SetDrawColor(0, 0, 0, 255);
    surface.DrawOutlinedRect(0, 0, w, h);

    surface.SetDrawColor(gQuest.Outline);
    surface.DrawOutlinedRect(1, 1, w - 2, h - 2)
    surface.DrawRect(2, 32, w - 4, 1)

    gQuest.DrawTextOutlined(self.Header, "gQuest.16", 6, 9, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
    gQuest.DrawTextOutlined(gQuest.textWrap(self.Description, "gQuest.16", w - 100), "gQuest.16", w / 2, 40, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
end
vgui.Register("gQuest.NotificationMain", panel, "EditablePanel");