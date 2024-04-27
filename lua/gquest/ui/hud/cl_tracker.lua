--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

local localplayer;
local w, h = ScrW(), ScrH();

net.Receive("gQuest.TrackQuest", function()
    local quest = net.ReadUInt(32);
    local untrack = net.ReadBool();

    if (untrack) then
        gQuest.CurrentTrackedQuest = nil;

        return;
    end

    gQuest.CurrentTrackedQuest = quest;
end);

local arrow = Material("gquest/arrow_down.png");
hook.Add("HUDPaint", "gQuest.QuestTracker", function()
    if (not gQuest.UseQuestTracker) then
        return;
    end

    localplayer = localplayer and IsValid(localplayer) and localplayer or LocalPlayer();

    if (not IsValid(localplayer)) then
        return;
    end

    local target = nil;
    local questTable = gQuest.GetQuestTable(gQuest.CurrentTrackedQuest);
    if (not questTable or not next(questTable)) then
        return;
    end

    if (questTable.QuestArrow == false) then
        return;
    end

    local class = questTable.ObjectiveClass;
    if (not class) then
        return;
    end

    if (type(class) == "table") then
        for _, c in ipairs(class) do
            for _, ent in ipairs(ents.FindByClass(c)) do
                if (not IsValid(ent) or ent == localplayer) then
                    continue;
                end

                if (IsValid(target)) then
                    if (target ~= ent) then
                        if (localplayer:GetPos():DistToSqr(ent:GetPos()) < localplayer:GetPos():DistToSqr(target:GetPos())) then
                            target = ent;
                        end
                    end
                else
                    target = ent;
                end
            end
        end
    else
        for _, ent in ipairs(ents.FindByClass(class)) do
            if (not IsValid(ent) or ent == localplayer) then
                continue;
            end

            if (IsValid(target)) then
                if (target ~= ent) then
                    if (localplayer:GetPos():DistToSqr(ent:GetPos()) < localplayer:GetPos():DistToSqr(target:GetPos())) then
                        target = ent;
                    end
                end
            else
                target = ent;
            end
        end
    end

    if (not IsValid(target)) then
        return;
    end

    local myAng = localplayer:EyeAngles();
    local mvAng = (localplayer:GetPos() - target:GetPos()):Angle();
    local diff = mvAng - myAng;
    local x, y = 64, 64;

    surface.SetDrawColor(255, 255, 255, 255);
    surface.SetMaterial(arrow);
    surface.DrawTexturedRectRotated(w / 2, (h - y) - 64, x, y, diff.y);

    local dist = localplayer:GetPos():Distance(target:GetPos());
    draw.DrawText(math.Round(dist / 16) .. "ft\n" .. questTable.Name .. "\n", "gQuest.18", w / 2, ((h - y) - 64) + 42, gQuest.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
end);

---
--- This is the object tracker in the top left.
---
hook.Add("HUDPaint", "gQuest.ObjectTrackerTopLeft", function()
    if (not gQuest.UseQuestTracker) then
        return;
    end

    if (not IsValid(localplayer)) then
        return;
    end

    local questTable = gQuest.GetQuestTable(gQuest.CurrentTrackedQuest);
    if (not questTable or not next(questTable)) then
        return;
    end

    if (not questTable.HUDObjective) then
        return;
    end

    local objectives = util.JSONToTable(localplayer:GetPrivateGQString("QuestObjectives", "[]"));
    if (not objectives or not next(objectives)) then
        return;
    end

    local objInfo;
    for k, v in ipairs(objectives) do
        if (v.quest_id == gQuest.CurrentTrackedQuest) then
            objInfo = v;

            break;
        end
    end

    if (not objInfo or not next(objInfo)) then
        return;
    end

    local str = questTable.HUDObjective;
    str = str:Replace("{name}", localplayer:Nick());
    str = str:Replace("{need}", objInfo.quest_progress_max);
    str = str:Replace("{current}", objInfo.quest_progress);

    local color;
    if (objInfo.quest_progress == objInfo.quest_progress_max) then
        color = gQuest.Green;
    else
        color = gQuest.Red;
    end

    surface.SetDrawColor(color);
    surface.SetMaterial(gQuest.Materials["Circle"]);
    surface.DrawTexturedRect(32, 32, 32, 32);

    gQuest.DrawTextOutlined(questTable.Name, "gQuest.20", 74, 35, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT);

    surface.SetDrawColor(255, 255, 255);
    surface.DrawRect(32 + 15, 69, 2, 10);

    gQuest.DrawTextOutlined(str, "gQuest.16", 46, 82, gQuest.White, gQuest.Black, TEXT_ALIGN_LEFT);
end);