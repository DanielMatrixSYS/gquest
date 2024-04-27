--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

---
--- Debug
---
function gQuest.Debug(s, ...)
    if (not gQuest.DebugEnabled) then
        return;
    end

    MsgC(Color(255, 0, 0, 255), "[");
    MsgC(Color(127, 255, 0, 255), "DEBUG");
    MsgC(Color(255, 0, 0, 255), "] ");
    MsgC(Color(255, 255, 255, 255), string.format(s, ...));
    Msg("\n");
end