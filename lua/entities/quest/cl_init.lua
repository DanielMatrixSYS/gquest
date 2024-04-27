--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

include("shared.lua");

local localplayer;
local tocolor = string.ToColor;

---
--- Initialize
---
function ENT:Think()
    if (IsValid(self) and not self:GetPatroling()) then
        self:SetQuestNPCSequence();
    end
end

---
--- Draw
---
function ENT:Draw()
    self:DrawModel();

    localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer();

    if (IsValid(self) and IsValid(localplayer)) then
        local sPos = self:GetPos();

        if (localplayer:GetPos():DistToSqr(sPos) < 1000 ^ 2) then
            local offset    = Vector(0, 0, 42);
            local ang       = localplayer:EyeAngles();
            local center    = self:OBBCenter();
            local pos       = (self:LocalToWorld(center) + offset + ang:Up());

            ang:RotateAroundAxis(ang:Forward(), 90);
            ang:RotateAroundAxis(ang:Right(), 90);

            local header    = self:GetHeader();  
            local subHeader = "<" .. self:GetSubHeader() .. ">";

            header    = header:Replace("{name}", localplayer:Nick());
            subHeader = subHeader:Replace("{name}", localplayer:Nick());

            local headerColor    = tocolor(self:GetNW2String("gquest_header_color", "255 255 255 255"));
            local subHeaderColor = tocolor(self:GetNW2String("gquest_sub_header_color", "255 255 255 255"));

            cam.IgnoreZ(false);
            cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.1);
                local yPos = subHeader == "<>" and 10 or -40;

                gQuest.DrawTextOutlined(header, "gQuest.52", 0, yPos, headerColor, gQuest.Black, TEXT_ALIGN_CENTER);

                if (subHeader ~= "<>") then
                    gQuest.DrawTextOutlined(subHeader, "gQuest.42", 0, 20, subHeaderColor, gQuest.Black, TEXT_ALIGN_CENTER);
                end

                if (gQuest.VisualAid["npc_esp"]) then
                    gQuest.DrawTextOutlined(self:GetID(), "gQuest.42", 0, -80, headerColor, gQuest.Black, TEXT_ALIGN_CENTER);
                end
            cam.End3D2D();
        end
    end
end