--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local mat = Material("pp/blurscreen");

--[[---------------------------------------------------------------------------
Wrap strings to not become wider than the given amount of pixels
---------------------------------------------------------------------------]]
local function charWrap(text, pxWidth)
    local total = 0

    text = text:gsub(".", function(char)
        total = total + surface.GetTextSize(char)

        -- Wrap around when the max width is reached
        if total >= pxWidth then
            total = 0
            return "\n" .. char
        end

        return char
    end)

    return text, total
end

---
--- textWrap
--- Credits to FPTje.
---
function gQuest.textWrap(text, font, pxWidth)
    local total = 0

    surface.SetFont(font)

    local spaceSize = surface.GetTextSize(' ')
    text = text:gsub("(%s?[%S]+)", function(word)
            local char = string.sub(word, 1, 1)
            if char == "\n" or char == "\t" then
                total = 0
            end

            local wordlen = surface.GetTextSize(word)
            total = total + wordlen

            -- Wrap around when the max width is reached
            if wordlen >= pxWidth then -- Split the word if the word is too big
                local splitWord, splitPoint = charWrap(word, pxWidth - (total - wordlen))
                total = splitPoint
                return splitWord
            elseif total < pxWidth then
                return word
            end

            -- Split before the word
            if char == ' ' then
                total = wordlen - spaceSize
                return '\n' .. string.sub(word, 2)
            end

            total = wordlen
            return '\n' .. word
        end)

    return text
end

---
--- DrawPanelBlur
---
function gQuest:DrawPanelBlur(panel, blur)
    local blur = (blur or 5);
    local sw = ScrW();
    local sh = ScrH();

    local x, y = panel:LocalToScreen(0, 0);
    local w, h = panel:GetSize();

    surface.SetDrawColor(0, 0, 0, 255);
    surface.SetMaterial(mat);

    local perX, perY = x / sw, y / sh;
    local perW, perH = (x + w) / sw, (y + h) / sh;

    for i = 1, blur do
        mat:SetFloat("$blur", i);
        mat:Recompute();

        render.UpdateScreenEffectTexture();
        surface.DrawTexturedRectUV(0, 0, w, h, perX, perY, perW, perH);
    end
end

---
--- DrawBlur
---
function gQuest:DrawBlur(x, y, w, h)
    local sw = ScrW();
    local sh = ScrH();

    surface.SetDrawColor(0, 0, 0, 255);
    surface.SetMaterial(mat);

    local perX, perY = x / sw, y / sh;
    local perW, perH = (x + w) / sw, (y + h) / sh;

    for i = 1, 5 do
        mat:SetFloat("$blur", i);
        mat:Recompute();

        render.UpdateScreenEffectTexture();
        surface.DrawTexturedRectUV(x, y, w, h, perX, perY, perW, perH);
    end
end


---
--- DrawSimpleTextOutlined
---
function gQuest.DrawTextOutlined(str, font, posx, posy, clr, clr2, tpos1)
    draw.DrawText(str, font, posx + 2, posy + 1, clr2, tpos1);
    draw.DrawText(str, font, posx, posy, clr, tpos1);
end

---
--- DoClosingAnimation
---
function gQuest.PANEL:DoClosingAnimation(ySize, time)
    self:SizeTo(0, ySize, time, 0, -1, function(data, s)
        if (IsValid(s)) then
            s:Remove();
        end
    end);
end