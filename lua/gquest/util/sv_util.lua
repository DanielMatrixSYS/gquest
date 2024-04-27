--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("gQuest.UpdatePrivateString");
util.AddNetworkString("gQuest.Notification");
util.AddNetworkString("gQuest.TextNotification");

---
--- SetPrivateGQString
---
function gQuest.PLAYER:SetPrivateGQString(nType, nValue)
    if (not IsValid(self)) then
        return false;
    end

    net.Start("gQuest.UpdatePrivateString");
        net.WriteString(nType);
        net.WriteString(nValue);
    net.Send(self);

    self[tostring(nType)] = tostring(nValue);
end

---
--- SendGQNotification
---
function gQuest.PLAYER:SendGQNotification(header, desc, acceptText, useHeader)
    if (not IsValid(self)) then
        return false;
    end

    net.Start("gQuest.Notification")
        net.WriteString(header);
        net.WriteString(desc);
        net.WriteString(acceptText);
        net.WriteBool(useHeader);
    net.Send(self)

    return true;
end

---
--- SendGQTextNotification
---
function gQuest.PLAYER:SendGQTextNotification(useHeader, header, description, headerColor, endTime)
    if (not IsValid(self)) then
        return false;
    end

    net.Start("gQuest.TextNotification");
        net.WriteBool(useHeader);
        net.WriteString(header);
        net.WriteType(description);
        net.WriteColor(headerColor);

        if (useHeader) then
            net.WriteUInt(endTime, 8);
        end
    net.Send(self);

    return true;
end

CreateConVar("gquest_installed", 1, {
	FCVAR_ARCHIVE,
	FCVAR_NOTIFY,
	FCVAR_REPLICATED,
	FCVAR_SERVER_CAN_EXECUTE
}, "");