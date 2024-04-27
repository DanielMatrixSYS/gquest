--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

gQuest.SpawnedNPCS = {};

---
--- GetPrivateGQString
---
function gQuest.PLAYER:GetPrivateGQString(nType, nDefault)
    if (self[nType] and isstring(self[nType])) then
        return tostring(self[nType]);
    end

    return nDefault;
end

---
--- HasAccessToGQMenu
---
function gQuest.PLAYER:HasAccessToGQMenu()
    return gQuest.MenuAccess[self:GetUserGroup()];
end

---
--- FormatQuestDescription
---
function gQuest.FormatQuestDescription(desc, what, with)
    if (desc:lower():find(what:lower())) then
        desc = string.Replace(desc, what, with);
    end

    return desc;
end

-- Used Colors.

local c = Color;
gQuest.White            = c(255, 255, 255, 255);
gQuest.WhiteTrans       = c(200, 200, 200, 50);
gQuest.WhiteIsh         = c(200, 200, 200, 200);
gQuest.LessWhite        = c(100, 100, 100, 100);
gQuest.DarkBlue         = c(14, 16, 21, 255);
gQuest.RoyalBlueTrans   = c(25, 127, 200, 50);
gQuest.RoyalBlue        = c(25, 127, 200, 150);
gQuest.RoyalBlueText    = c(25, 175, 255, 200);
gQuest.Trans            = c(0, 0, 0, 0);
gQuest.TransGrey        = c(50, 50, 50, 50);
gQuest.Grey             = c(150, 150, 150, 50);
gQuest.Black            = c(0, 0, 0, 255);
gQuest.Red              = c(175, 25, 0, 255);
gQuest.Green            = c(25, 179, 25, 255);
gQuest.LessGreen        = c(25, 140, 25, 255);
gQuest.Yellow           = c(200, 200, 35, 255);
gQuest.Outline          = c(57, 64, 78, 225);
gQuest.Purple           = c(89, 0, 255);