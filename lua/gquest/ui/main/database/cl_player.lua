--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local panel = {};

AccessorFunc(panel, "PanelHolder", "PanelHolder");
AccessorFunc(panel, "Table", "Table");
AccessorFunc(panel, "PlayerName", "PlayerName");
AccessorFunc(panel, "SteamID", "SteamID");

---
--- CreateChild
---
function panel:CreateChild(...)
    local nextChild = #self.Children + 1;
    local args      = {...};

    local dataType  = args[1];
    local data      = args[2];
    local id, name  = data[1], data[2];

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

        if (dataType == "QuestCooldowns") then
            gQuest.DrawTextOutlined(name, "gQuest.16", 7, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
            gQuest.DrawTextOutlined(args[3], "gQuest.16", w - 7, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER);
        elseif(dataType == "QuestObjectives") then
            gQuest.DrawTextOutlined(name, "gQuest.16", 7, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
            gQuest.DrawTextOutlined(args[3] .. "/" .. args[4], "gQuest.16", w - 7, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER); 
        else
            gQuest.DrawTextOutlined(name, "gQuest.16", 7, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
        end
    end

    child.OnCursorEntered = function()
        surface.PlaySound("gquest/button.mp3");
    end

    child.DoClick = function(s)
        surface.PlaySound("gquest/button.mp3");
        
        local ui = vgui.Create("gQuest.QuestMainDBPlayerQuestOptions")
        ui:SetPos(self:GetWide() + 113, ((ScrH() / 2) - 508 / 2) - 50);
        ui:SetSize(0, 508);
        ui:SizeTo(349, 508, .25, 0);
        ui:MakePopup();
        ui:SetPanelHolder(self);
        ui:SetSteamID(self.SteamID);
        ui:SetQuestID(id);
    end

    return true;
end

---
--- PostInit
---
function panel:PostInit()
    local data = LocalPlayer().gQuest_QuestDatabase_Data[self.Table];

    local json = false;
    if (data:StartWith("[")) then
        json = true;
    end

    if (json) then
        local converted = util.JSONToTable(data);
        local count = #converted;

        -- Display a message on the panel saying that the player has not done anything
        -- related to that category, instead of just nothing.
        if (count < 1) then
            self.IsEmpty = true;

            return true;
        end
        
        for i = 1, count do
            local data      = converted[i];
            local questID   = data.quest_id;
            local questName = gQuest.GetQuestName(questID);

            if (self.Table == "QuestCooldowns") then
                local endTime   = data.endTime - os.time();
                local endString = string.NiceTime(endTime);

                if (endTime <= 0) then
                    endString = "No longer on CD";
                end

                self:CreateChild("QuestCooldowns", {questID, questName}, endString);
            elseif(self.Table == "QuestObjectives") then
                local progress = data.quest_progress;
                local progressMax = data.quest_progress_max;

                self:CreateChild("QuestObjectives", {questID, questName}, progress, progressMax)
            end
        end
    else
        local converted = string.Explode(",", data);
        local found     = 0;

        -- Just to check if there is actually any data in the table.
        -- cant check with #converted or next or anything
        -- to preserve optimizations we just break it as soon as we find 1 thing.
        for k, v in ipairs(converted) do
            if (v and v ~= "") then
                found = found + 1;

                break;
            end
        end

        if (found < 1) then
            self.IsEmpty = true;

            return true;
        end

        for k, v in ipairs(converted) do
            local questName = gQuest.GetQuestName(v);

            self:CreateChild("", {v, questName});
        end
    end
end

---
--- Init
---
function panel:Init()
    self.Children   = {};
    self.Approach   = math.Approach;
    self.IsEmpty    = false;

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

    if (self.Table and not self.Initialized) then
        self:PostInit();

        self.Initialized = true;
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

    self.ScrollPanel:SetPos(7, 40);
    self.ScrollPanel:SetSize(w - 14, h - 83);

    for i = 1, #self.Children do
        local panel = self.Children[i];

        panel:SetPos(0, 35 * (i - 1));
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

    if (self.IsEmpty) then
        gQuest.DrawTextOutlined("There is no data available for this section.", "gQuest.16", w / 2, (h / 2) - 8, gQuest.White, gQuest.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    end

    gQuest.DrawTextOutlined(self.PlayerName, "gQuest.16", 7, 9, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER);
end
vgui.Register("gQuest.QuestMainDBPlayerInfo", panel, "EditablePanel");