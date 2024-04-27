--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local arrowDown = Material("gquest/arrow_down.png");
local localplayer;

hook.Add("PostDrawOpaqueRenderables", "gQuest.QuestHUD", function()
    if (not gQuest.ArrowAboveQuestObjects) then
        return;
    end
    
    localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer();

    if (not IsValid(localplayer)) then
        return;
    end

    local objectives = util.JSONToTable(localplayer:GetPrivateGQString("QuestObjectives", "[]"));
    if (not objectives or not next(objectives)) then
        return;
    end
    
    for _, obj in ipairs(objectives) do
        if (not obj.quest_class) then
            continue;
        end

        if (not istable(obj.quest_class)) then
            local oldClass = obj.quest_class;
            obj.quest_class = {oldClass};
        end

        for k, v in ipairs(obj.quest_class) do
            for _, ent in ipairs(ents.FindByClass(v)) do
                if (ent == localplayer) then
                    continue;
                end

                if (IsValid(ent) and localplayer:GetPos():DistToSqr(ent:GetPos()) < 5000 ^ 2) then
                    local offset     = Vector(0, 0, 30);
                    local ang       = localplayer:EyeAngles();
                    local center    = ent:OBBCenter();
                    local t         = RealTime() * (math.pi * 0.3);
                    local y         = math.abs(math.cos(t * 3 / 2) * 4);
                    local pos       = (ent:LocalToWorld(center) + offset + ang:Up() * 10);

                    ang:RotateAroundAxis(ang:Forward(), 90);
                    ang:RotateAroundAxis(ang:Right(), 90);
                    
                    cam.IgnoreZ(false);
                    cam.Start3D2D(pos, Angle(0, ang.y, 90), 0.05);
                        surface.SetDrawColor(0, 0, 0, 255);
                        surface.SetMaterial(arrowDown);
                        surface.DrawTexturedRect(-68, 50 - y * 20, 133, 133);

                        surface.SetDrawColor(255, 255, 255, 255);
                        surface.DrawTexturedRect(-66, 50 - y * 20, 128, 128);
                    cam.End3D2D();
                end
            end
        end
    end
end);