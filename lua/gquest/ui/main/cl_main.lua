--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

-- Just to interact with other, other other panels.
gQuest.MainUIPanel = nil;

local panel = {};

---
--- CreateChild
---
function panel:CreateChild(mat, title, func)
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

        surface.SetDrawColor(255, 255, 255);
        surface.SetMaterial(mat)
        surface.DrawTexturedRect(5, (h / 2) - 8, 16, 16);

        gQuest.DrawTextOutlined(title, "gQuest.16", 26, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
    end

    child.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    child.DoClick = function(s)
        surface.PlaySound("gquest/button.mp3");

        if (IsValid(self.SelectedChild)) then
            if (self.SelectedChild == s) then
                if (IsValid(self.CurrentPanel)) then
                    self.CurrentPanel:DoClosingAnimation(508, .25);
                end

                self.SelectedChild = nil;
                return;
            end

            self.SelectedChild = s;
        end

        if (IsValid(self.CurrentPanel)) then
            self.CurrentPanel:DoClosingAnimation(508, .25);
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
            title = gQuest.L("uiNPCS"),
            ui = "gQuest.QuestMainNPCS",
        },

        {
            material = gQuest.Materials["Edit"],
            title = gQuest.L("objQuest"),
            ui = "gQuest.QuestMainObjectives",
        },

        {
            material = gQuest.Materials["Database"],
            title = gQuest.L("dbQuest"),
            ui = "gQuest.QuestMainDB",
        },
    
        {
            material = gQuest.Materials["Info"],
            title = gQuest.L("uiHelp"),
            ui = "gQuest.QuestMainHelp",
        },

        {
            material = gQuest.Materials["Dev Tools"],
            title = gQuest.L("uiVisualAid"),
            ui = "gQuest.QuestMainAid",
        },
    }

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

        gQuest.DrawTextOutlined("Exit", "gQuest.16", w / 2, 7, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end

    self.Back.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    self.Back.DoClick = function()
        self:Remove();
    end

    -- Other
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

    for i = 1, #self.Buttons do
        local data  = self.Buttons[i];
        local title = data.title;
        local mat   = data.material;
        local name  = data.ui;

        self:CreateChild(mat, title, function(s)
            local ui = vgui.Create(name);
            ui:SetPos(self:GetWide() + 100, ((ScrH() / 2) - 508 / 2) - 50);
            ui:SetSize(0, 508);
            ui:SizeTo(349, 508, .25, 0);
            ui:SetPanelHolder(self);

            self.CurrentPanel = ui;
        end);
    end

    gQuest.MainUIPanel = self;
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
        local child = self.Children[i];

        child:SetPos(7, 38 + (35 * (i - 1)));
        child:SetSize(w - 14, 30);
    end
end

function panel:Think()
    if (not IsValid(self.CurrentPanel)) then
        self.SelectedChild = nil;
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

    gQuest.DrawTextOutlined("Main", "gQuest.16", 7, 9, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
end
vgui.Register("gQuest.QuestMain", panel, "EditablePanel");