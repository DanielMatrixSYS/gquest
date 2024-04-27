--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local texts = {};
local w, h = ScrW(), ScrH()
local baseHeaderHeight = 45;
local baseDescriHeight = 85; 
local padding = 10;

hook.Add("HUDPaint", "gQuest.HUDPaintUpdates", function()
    if (not next(texts)) then
        return;
    end

    local heightUsed = 0;
    for i = 1, #texts do
        local text = texts[i];

        if (not text) then
            return;
        end

        if (text.endTime < CurTime()) then
            text.startAlpha = math.Approach(text.startAlpha, 0, 1);

            if (text.startAlpha <= 0) then
                table.remove(texts, i);
            end
        else
            text.startAlpha = math.Approach(text.startAlpha, 255, 2);
        end

        local header = gQuest.textWrap(text.header, "gQuest.40", 840);
        local desc = gQuest.textWrap(text.description, "gQuest.28", 400);
        local _, headerHeight = surface.GetTextSize(header);
        local _, descriHeight = surface.GetTextSize(desc);
        local combined = (headerHeight + descriHeight);
        local headerColor = ColorAlpha(text.headerColor, text.startAlpha);

        if (text.useHeader) then
            gQuest.DrawTextOutlined(header, "gQuest.40", w / 2, (baseHeaderHeight + heightUsed) + padding, headerColor, Color(0, 0, 0, text.startAlpha), TEXT_ALIGN_CENTER);
            gQuest.DrawTextOutlined(desc, "gQuest.28", (w / 2) + 1, (baseDescriHeight + heightUsed) + padding, Color(255, 255, 255, text.startAlpha), Color(0, 0, 0, text.startAlpha), TEXT_ALIGN_CENTER);
            heightUsed = (heightUsed + combined) + padding;
        else
            gQuest.DrawTextOutlined(header, "gQuest.28", w / 2, (baseHeaderHeight + heightUsed) + padding, headerColor, Color(0, 0, 0, text.startAlpha), TEXT_ALIGN_CENTER);
            heightUsed = (heightUsed + headerHeight) + padding;
        end
    end
end);

---
--- AddTexts
---
function gQuest.AddTexts(useHeader, header, description, headerColor, endTime)
    if (not useHeader) then
        endTime = description;
        description = "";
    end

    table.insert(texts, {
        useHeader = useHeader,
        header = header, 
        description = description,
        headerColor = headerColor,
        endTime = CurTime() + endTime, 
        startAlpha = 0
    });
end