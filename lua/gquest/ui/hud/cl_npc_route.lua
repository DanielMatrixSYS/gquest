--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local w, h = ScrW(), ScrH()
local laser = Material("cable/redlaser");
local localplayer;

hook.Add("PostDrawOpaqueRenderables", "gQuest.NPCRouteESP", function()
    if (not gQuest.VisualAid or not gQuest.VisualAid["npc_patrol"]) then
        return;
    end

    localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer();

    if (not IsValid(localplayer)) then
        return;
    end

    local NPCS = localplayer.gQuest_NPC_Table;

    for k, v in ipairs(NPCS) do
        if (v.Routes and next(v.Routes)) then
            for i, pos in ipairs(v.Routes) do
                local toConnect = i + 1;
                
                local start = v.Routes[1];
                local last = v.Routes[#v.Routes];
                local offset = Vector(0, 0, 15);
                local color;

                if (isstring(v.HeaderColor)) then
                    color = string.ToColor(v.HeaderColor);
                else
                    color = Color(v.HeaderColor.r, v.HeaderColor.g, v.HeaderColor.b);
                end

                if (v.Routes[toConnect]) then
                    render.SetMaterial(laser);
                    render.DrawBeam(pos + offset, v.Routes[toConnect] + offset, 10, 1, 1, gQuest.White)
                end
                
                local ang = localplayer:EyeAngles();
                ang:RotateAroundAxis(ang:Forward(), 90);
                ang:RotateAroundAxis(ang:Right(), 90);

                cam.IgnoreZ(false);
                cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.2);
                    if (pos == start) then
                        gQuest.DrawTextOutlined("START", "gQuest.52", 0, -150, color, gQuest.Black, TEXT_ALIGN_CENTER);
                    elseif(pos == last) then
                        gQuest.DrawTextOutlined("END", "gQuest.52", 0, -150, color, gQuest.Black, TEXT_ALIGN_CENTER);
                    else
                        gQuest.DrawTextOutlined(i, "gQuest.52", 0, -150, color, gQuest.Black, TEXT_ALIGN_CENTER);
                    end
                cam.End3D2D();
            end
        end
    end
end);