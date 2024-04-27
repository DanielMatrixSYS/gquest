--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

---
--- CreateNPC
---
function gQuest.CreateNPC(header, sub_header, header_color, sub_header_color, model, int_sound, pos, ang)
    local current   = sql.QueryRow("SELECT Data FROM gQuest_NPCS_New");
    local data      = util.JSONToTable(current["Data"]);
    local dCount    = #data + 1;
    
    table.insert(data, {
        Position = pos,
        Angle = ang,
        Model = model,
        IntSound = int_sound,
        Header = header,
        SubHeader = sub_header,
        HeaderColor = header_color,
        SubHeaderColor = sub_header_color,
        ID = dCount,
        Routes = {},
        Map = game.GetMap()
    })
    
    sql.Query("UPDATE gQuest_NPCS_New SET Data = '" .. util.TableToJSON(data) .. "'");
    gQuest.Debug("Successfully created NPC: " .. header);
    gQuest.SpawnAllNPCS();

    return false;
end

---
--- GetAllNPCS
---
function gQuest.GetAllNPCS()
    local query = sql.QueryRow("SELECT Data FROM gQuest_NPCS_New")["Data"];

    if (query ~= false and query ~= nil) then
        return query;
    end

    return false;
end

---
--- SpawnAllNPCS
---
function gQuest.SpawnAllNPCS(onlyRemove)
    if (not gQuest.SpawnedNPCS) then
        gQuest.Debug("Uhhh, excuse me? gQuest.SpawnedNPCS does not exist, did the table go missing?")

        return;
    end

    if (next(gQuest.SpawnedNPCS)) then
        for i = 1, #gQuest.SpawnedNPCS do
            local NPC = gQuest.SpawnedNPCS[i];

            if (IsValid(NPC)) then
                NPC:Remove();
            end
        end

        table.Empty(gQuest.SpawnedNPCS);
    end

    if (onlyRemove) then
        return true;
    end

    local NPCS = gQuest.GetAllNPCS();

    if (not NPCS) then
        return false;
    end

    local data = util.JSONToTable(NPCS);
    for k, v in ipairs(data or {}) do
        local map = v.Map;

        if (map and map ~= game.GetMap()) then
            continue;
        end

        local NPC = ents.Create("quest");
        NPC:SetPos(Vector(v.Position));
        NPC:SetAngles(Angle(v.Angle));
        NPC:SetID(v.ID);
        NPC:SetHeader(v.Header);
        NPC:SetSubHeader(v.SubHeader);
        NPC:SetInteractionSound(v.IntSound or "vo/npc/male01/hi01.wav");
        NPC:Spawn();
        NPC:Activate();
        NPC:SetModel(v.Model);

        NPC:SetNW2String("gquest_header_color", v.HeaderColor);
        NPC:SetNW2String("gquest_sub_header_color", v.SubHeaderColor);

        NPC.Routes = v.Routes;
        
        timer.Simple(1, function()
            if (IsValid(NPC)) then
                NPC:DropToFloor();

                if (NPC.Routes and next(NPC.Routes)) then
                    NPC.PatrolSystemActivated = not gQuest.PatrolSysDisabled;

                    NPC:SetPatroling(NPC.PatrolSystemActivated);
                end
            end
        end);

        table.insert(gQuest.SpawnedNPCS, NPC);
    end

    return true;
end

---
--- SaveAllNPCS
---
function gQuest.SaveAllNPCS(tbl)
    local NPCS;

    if (not tbl) then
        NPCS = gQuest.SpawnedNPCS;
    end

    local SQL = gQuest.GetSQL();
    local query = sql.QueryRow("SELECT Data FROM gQuest_NPCS_New");

    if (not query) then
        return true;
    end

    local data = util.JSONToTable(query["Data"]);
    for k, v in ipairs(NPCS) do
        if (IsEntity(v) and not IsValid(v)) then
            continue;
        end

        local id = v:GetID();
        for _, npc in ipairs(data) do
            if (id == tonumber(npc.ID)) then
                npc.Position = v:GetPos();
                npc.Angle = v:GetAngles();
                npc.Model = v:GetModel();
                npc.IntSound = v:GetInteractionSound();
                npc.Header = v:GetHeader();
                npc.SubHeader = v:GetSubHeader();
                npc.HeaderColor = v:GetNW2String("gquest_header_color", "255 255 255 255");
                npc.SubHeaderColor = v:GetNW2String("gquest_sub_header_color", "255 255 255 255");
                npc.Routes = v.Routes;
                npc.Map = game.GetMap();

                gQuest.Debug("SUCCESS: Saved the data for Quest Giver[" .. id .. ", " .. npc.Header .. "]");
            end
        end
    end

    local formated = util.TableToJSON(data);
    sql.Query("UPDATE gQuest_NPCS_New SET Data = '" .. formated .. "'");

    return true;
end

---
--- GetAllNPCSCount
---
function gQuest.GetAllNPCSCount()
    local all = gQuest.GetAllNPCS();
    local spawned = gQuest.SpawnedNPCS;

    if (not all) then
        all = 0;
    else
        all = #all;
    end

    local count = 0;
    for k, v in ipairs(spawned) do
        if (IsValid(v)) then
            count = count + 1;
        end
    end

    return all, count;
end

---
--- DeleteNPC
---
function gQuest.DeleteNPC(npc_ids)
    local query = sql.QueryRow("SELECT Data FROM gQuest_NPCS_New");
    local data  = util.JSONToTable(query["Data"]);

    -- Remove NPCS.
    local count = #npc_ids;

    for i = 1, count do
        local id = npc_ids[i];

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
    sql.Query("UPDATE gQuest_NPCS_New SET Data = '" .. util.TableToJSON(data) .. "'");

    gQuest.SpawnAllNPCS();

    return true;
end

---
--- GetNPCQuests
---
function gQuest.GetNPCQuests(npc_id, ply)
    if (not npc_id) then
        return false;
    end

    local completed = {};
    if (IsValid(ply)) then
        local questsCompleted = string.Explode(",", ply:GetPrivateGQString("CompletedQuests", ""));
        local cooldownedQuests = util.JSONToTable(ply:GetPrivateGQString("QuestCooldowns", "[]"))

        if (questsCompleted and next(questsCompleted)) then
            for i = 1, #questsCompleted do
                table.insert(completed, questsCompleted[i]);
            end
        end

        for _, cdQuests in ipairs(cooldownedQuests) do
            for _, cQuests in ipairs(completed) do 
                if (cdQuests == cQuests) then
                    local expiry = cdQuests.endTime - os.time();
                
                    if (expiry > 0) then
                        continue;
                    end

                    table.insert(completed, cdQuests.quest_id);
                end
            end
        end
    end

    local quests = {};
    local npc_id = tonumber(npc_id);
    
    for k, v in ipairs(gQuest.Quests) do
        if (type(v.NPC) == "number" and v.NPC == npc_id or type(v.NPC) == "table" and table.HasValue(v.NPC, npc_id)) then
            local foundCompletedQuest = 0;

            if (v.NeedsToHaveCompleted and v.NeedsToHaveCompleted ~= 0) then
                for _, c in ipairs(completed) do
                    if (istable(v.NeedsToHaveCompleted) and table.HasValue(v.NeedsToHaveCompleted, c)) then
                        foundCompletedQuest = foundCompletedQuest + 1;
                    else
                        if (c == v.NeedsToHaveCompleted) then
                            foundCompletedQuest = foundCompletedQuest + 1;

                            break;
                        end
                    end
                end

                if ((istable(v.NeedsToHaveCompleted) and foundCompletedQuest < #v.NeedsToHaveCompleted) or foundCompletedQuest == 0) then
                    continue;
                end
            end

            table.insert(quests, {
                ID = v.ID,
                NPC = v.NPC,
                Name = v.Name or "",
                Description = v.Description or "",
                Objective = v.Objective or "",
                HUDObjective = v.HUDObjective or "",
                OnCompleteDescription = v.OnCompleteDescriptione or "",
                Rewards = v.Rewards or "",
                LevelRequirement = v.LevelRequirement or 0,
                ObjectiveRequirement = v.ObjectiveRequirement or 1,
                PreQuestConversation = v.PreQuestConversation or {},
                PreQuestConversationEnabled = v.PreQuestConversationEnabled or false,
                NeedsToHaveCompleted = v.NeedsToHaveCompleted or 0,
                ObjectiveClass = v.ObjectiveClass or "",
                JobWhitelist = v.JobWhitelist or {},
                JobBlacklist = v.JobBlacklist or {}
            });
        end
    end

    return quests;
end