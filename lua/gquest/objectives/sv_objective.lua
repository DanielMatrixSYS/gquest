--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

---
--- CreateObjective
---
function gQuest.CreateObjective(name, entity, quests, pos, ang)
    local current   = sql.QueryRow("SELECT Data FROM gQuest_Objectives_New");
    local data      = util.JSONToTable(current["Data"]);
    local dCount    = #data + 1;

    table.insert(data, {
        Name = name,
        Entity = entity,
        Quests = quests,
        Position = pos,
        Angle = ang,
        ID = dCount,
        Map = game.GetMap()
    });

    sql.Query("UPDATE gQuest_Objectives_New SET Data = '" .. util.TableToJSON(data) .. "'");
    gQuest.Debug("Successfully created NPC: " .. name);

    return false;
end

---
--- DeleteNPC
---
function gQuest.DeleteObjective(objectives)
    local query = sql.QueryRow("SELECT Data FROM gQuest_Objectives_New");
    local data  = util.JSONToTable(query["Data"]);

    -- Remove NPCS.
    local count = #objectives;

    for i = 1, count do
        local id = objectives[i];

        for j = 1, #data do
            local sql_data  = data[j];

            -- We are removing the data as we are searching through them
            -- which can lead to errors, the error doesn't really do anything
            -- but no one likes error, or support tickets so. :D

            if (not sql_data) then
                continue;
            end

            local sql_id = sql_data.ID;
            
            if (tonumber(sql_id) == tonumber(id)) then
                table.remove(data, j);
            end
        end
    end

    -- Update our JSON String
    sql.Query("UPDATE gQuest_Objectives_New SET Data = '" .. util.TableToJSON(data) .. "'");

    return true;
end

---
--- ShouldSpawnForQuest
---
function gQuest.ShouldSpawnForQuest(quest_id)
    local acceptedQuests = gQuest.GetAcceptedQuests();

    if (not acceptedQuests or not next(acceptedQuests)) then
        return false;
    end

    if (type(quest_id) == "table") then
        for _, v in ipairs(acceptedQuests) do
            for _, q in ipairs(quest_id) do
                if (tonumber(v) == tonumber(q)) then
                    return true;
                end
            end
        end

        return false;
    end

    for k, v in ipairs(acceptedQuests) do
        if (tonumber(v) == quest_id) then
            return true;
        end
    end

    return false;
end

---
--- GetObjectives
---
function gQuest.GetObjectives(quest_id)
    local current   = sql.QueryRow("SELECT Data FROM gQuest_Objectives_New");
    local data      = util.JSONToTable(current["Data"]);
    local spawn     = {};
    local objQuests = {};

    for k, v in ipairs(data) do
        local map = v.Map;

        if (map and k == 1) then
            map = map .. math.random(1, 1515105)
        end

        if (map and map ~= game.GetMap()) then
            continue;
        end

        local quests = string.Explode(",", v.Quests);

        for _, q in ipairs(quests) do
            local q = tonumber(q);

            if (q == quest_id) then
                table.insert(spawn, {name = v.Name, ent = v.Entity, pos = v.Position, ang = v.Angle});
                table.Merge(objQuests, quests);
            end
        end
    end

    return spawn, objQuests;
end

---
--- ObjectiveRespawn
---
function gQuest.ObjectiveRespawn(obj)
    obj.RespawnTimer = CurTime() + gQuest.ObjectiveRespawnTimer;

    table.insert(gQuest.RespawnObjectives, obj);
end

---
--- CheckObjectives
---
function gQuest.CheckObjectives()
    if (not gQuest.RespawnObjectives or not next(gQuest.RespawnObjectives)) then
        return false;
    end

    for k, v in ipairs(gQuest.RespawnObjectives) do
        if (v.RespawnTimer < CurTime()) then
            if (not gQuest.ShouldSpawnForQuest(v.quests)) then
                table.remove(gQuest.RespawnObjectives, k);

                continue;
            end

            local questTable = gQuest.GetQuestTable(v.id);
            local obj = ents.Create(v.ent);
            obj:SetPos(Vector(v.pos));
            obj:SetAngles(Angle(v.ang));
            obj:Spawn();
            obj:Activate();
            
            local phys = obj:GetPhysicsObject();
            if (IsValid(phys)) then
                phys:Wake();
            end

            -- Do this the next tick, the entity needs to fully spawn before we can manipulate it the way i want to maniuplate it.
            timer.Simple(0, function()
                if (IsValid(obj)) then
                    obj.GQInfo = {ent = v.ent, pos = v.pos, ang = v.ang, quests = v.quests, id = v.id};

                    questTable:OnObjectiveSpawned(obj);
                end
            end);

            table.insert(gQuest.Objectives, {obj = obj, quests = v.quests});
            table.remove(gQuest.RespawnObjectives, k);
        end
    end
end

---
--- RemoveNPCS
---
function gQuest.RemoveNPCS(tbl)
    for k, v in ipairs(tbl) do
        if (IsValid(v.obj)) then
            v.obj.PermanentRemoved = true;
            v.obj:Remove();
        end
    end

    return true;
end

---
--- DoAbandonedCheck
---
function gQuest.DoAbandonedCheck(quest_id)
    local npcs = {};

    for k, v in ipairs(gQuest.Objectives) do
        for _, q in ipairs(v.quests) do
            if (tonumber(q) == quest_id and IsValid(v.obj)) then
                table.insert(npcs, {obj = v.obj, quest = v.quests});
            end
        end
    end

    if (not npcs or not next(npcs)) then
        return true;
    end

    local acceptedQuests = gQuest.GetAcceptedQuests();
    if (not acceptedQuests or not next(acceptedQuests)) then
        gQuest.RemoveNPCS(npcs);

        return true;
    end

    local hasQuest = false;
    for k, v in ipairs(acceptedQuests) do
        for _, n in ipairs(npcs) do
            for _, q in ipairs(n.quest) do
                if (tonumber(q) == quest_id) then
                    hasQuest = true;
                end
            end
        end
    end

    if (not hasQuest) then
        gQuest.RemoveNPCS(npcs);
    end

    return true;
end

---
--- GetAllObjectives
---
function gQuest.GetAllObjectives()
    local current   = sql.QueryRow("SELECT Data FROM gQuest_Objectives_New");
    local data      = util.JSONToTable(current["Data"]);

    if (current ~= false) then
        return data;
    end

    return false;
end

---
--- SpawnQuestObjectives
---
function gQuest.SpawnQuestObjectives(quest_id)
    if (not gQuest.ShouldSpawnForQuest(quest_id)) then
        return false;
    end

    if (gQuest.GetAcceptedQuestCount(quest_id) >= 2) then
        return false;
    end

    local objectives, quests = gQuest.GetObjectives(quest_id);
    if (not objectives or type(objectives) ~= "table") then
        return false;
    end

    local questTable = gQuest.GetQuestTable(quest_id);
    for k, v in ipairs(objectives) do
        local map = v.Map;

        local obj = ents.Create(v.ent);
        if (not IsValid(obj)) then
            continue;
        end

        obj:SetPos(Vector(v.pos) + Vector(0, 0, 20));
        obj:SetAngles(Angle(v.ang));
        obj:Spawn();
        obj:Activate();

        local phys = obj:GetPhysicsObject();
        if (IsValid(phys)) then
            phys:Wake();
        end

        -- Do this the next tick, the entity needs to fully spawn before we can manipulate it the way i want to maniuplate it.
        timer.Simple(0, function()
            if (IsValid(obj)) then
                obj.GQInfo = {ent = v.ent, pos = v.pos, ang = v.ang, quests = quests, id = quest_id};
            end
        end);

        table.insert(gQuest.Objectives, {obj = obj, quests = quests});

        questTable:OnObjectiveSpawned(obj);
    end

    return true;
end