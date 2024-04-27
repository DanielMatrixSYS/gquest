--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("gQuest.UpdateRoutes");
util.AddNetworkString("gQuest.ChangePatrolBool");
util.AddNetworkString("gQuest.RemoveRoutes");

net.Receive("gQuest.UpdateRoutes", function(_, ply)
    if (not ply:HasAccessToGQMenu()) then
        return;
    end

    local npc       = net.ReadUInt(8);
    local route_id  = net.ReadUInt(8);
    local position  = net.ReadVector();

    local NPCS = gQuest.SpawnedNPCS;
    for k, v in ipairs(NPCS) do
        if (not IsValid(v)) then
            continue;
        end

        local id = v:GetID();
        if (id == npc) then
            table.insert(v.Routes, position);

            break;
        end
    end

    gQuest.SaveAllNPCS();
end);

net.Receive("gQuest.RemoveRoutes", function(_, ply)
    if (not ply:HasAccessToGQMenu()) then
        return;
    end

    -- Handle the net stuff first.
    local count     = net.ReadUInt(8);
    local npc       = net.ReadUInt(32);
    local routes    = {};

    for i = 1, count do
        local waypoint = net.ReadUInt(8);

        table.insert(routes, waypoint);
    end

    -- Find the npc we want to remove the waypoints from.
    local NPCS      = gQuest.SpawnedNPCS;
    local foundNPC  = nil;

    for _, v in ipairs(NPCS) do
        if (IsValid(v) and v:GetID() == npc) then
            foundNPC = v;

            break;
        end
    end

    -- Now to delete.
    local currentRoutes = foundNPC.Routes;

    for i = 1, #routes do
        local index = routes[i];

        for j = 1, #currentRoutes do
            if (j == index) then
                routes[j] = nil;
            end
        end
    end

    -- Refresh the NPC's route data.
    foundNPC.Routes = routes;

    -- Then save it.
    gQuest.SaveAllNPCS();
end);

hook.Add("InitPostEntity", "gQuest.CanPatrol", function()
    local query = sql.QueryRow("SELECT Data FROM gQuest_Data")["Data"];
    local data = util.JSONToTable(query);

    if (data.PatrolSystemDisabled == nil) then
        data.PatrolSystemDisabled = true;

        sql.Query("UPDATE gQuest_Data SET Data = '" .. util.TableToJSON(data) .. "'");
    else
        gQuest.PatrolSysDisabled = data.PatrolSystemDisabled;
    end
end);

hook.Add("PlayerInitialSpawn", "gQuest.GivePatrolBool", function(ply)
    timer.Simple(2, function()
        if (IsValid(ply) and ply:HasAccessToGQMenu()) then
            ply:SetPrivateGQString("patrol_system_disabled", tostring(gQuest.PatrolSysDisabled));
        end
    end);
end);

net.Receive("gQuest.ChangePatrolBool", function(_, ply)
    if (IsValid(ply) and ply:HasAccessToGQMenu()) then
        gQuest.PatrolSysDisabled = net.ReadBool();

        local query = sql.QueryRow("SELECT Data FROM gQuest_Data")["Data"];
        local data = util.JSONToTable(query);

        data.PatrolSystemDisabled = gQuest.PatrolSysDisabled;

        sql.Query("UPDATE gQuest_Data SET Data = '" .. util.TableToJSON(data) .. "'");

        for _, v in ipairs(player.GetHumans()) do
            if (IsValid(v) and v:HasAccessToGQMenu()) then
                v:SetPrivateGQString("patrol_system_disabled", tostring(gQuest.PatrolSysDisabled));
            end
        end

        gQuest.SpawnAllNPCS();
    end
end);