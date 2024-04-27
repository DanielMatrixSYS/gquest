--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("gQuest.Broadcast");

resource.AddWorkshop("1796924687")

if (not file.IsDir("gquest_import", "DATA")) then
    file.CreateDir("gquest_import");
end

---
--- RegisterQuest
---
function gQuest.RegisterQuest(quest)
    if (not quest or not istable(quest)) then
        gQuest.Debug("ERROR: Unable to insert type [" .. type(quest) .. "] into our quest table due it not being a type [table].");

        return false;
    end

    if (not quest["Enabled"]) then
        for k, v in ipairs(gQuest.Quests) do
            if (v.ID == quest["ID"]) then
                table.remove(gQuest.Quests, k);

                break;
            end
        end
        
        gQuest.Debug("WARNING: Quest[" .. quest["ID"] .. ", " .. quest["Name"] .. "] was not registered due to it being disabled.");
        return false;
    end

    for k, v in ipairs(gQuest.Quests) do
        if (v.ID == quest["ID"]) then
            if (gQuest.DebugEnabled) then
                table.remove(gQuest.Quests, k);
                table.insert(gQuest.Quests, quest);

                gQuest.Debug("WARNING: Replaced [" .. quest["ID"] .. ", " .. quest["Name"] .. "] with [" .. v.ID .. ", " .. v.Name .. "] because debug mode was enabled.");
                return true;
            end

            gQuest.Debug("ERROR: Unable to insert [" .. quest["ID"] .. ", " .. quest["Name"] .. "] because the same id exists for [" .. v.ID .. ", " .. v.Name .. "]");
            return false;
        end
    end
    
    if (istable(quest["NPC"])) then
        local npcs = "";

        for _, v in ipairs(quest["NPC"]) do
            npcs = npcs .. v .. ",";
        end

        npcs = npcs:sub(1, #npcs - 1);

        gQuest.Debug("SUCCESS: Registered quest[" .. quest["ID"] .. ", " .. quest["Name"] .. "] for npc[" .. npcs .. "]");
    else
        gQuest.Debug("SUCCESS: Registered quest[" .. quest["ID"] .. ", " .. quest["Name"] .. "] for npc[" .. quest["NPC"] .. "]");
    end

    table.insert(gQuest.Quests, quest);
    quest:OnQuestInitialized();

    return true;
end

---
--- GQ_Notify
---
function gQuest.Broadcast(str, adminOnly)
    net.Start("gQuest.Broadcast")
        net.WriteString(str);

    if (adminOnly) then
        for k, v in ipairs(player.GetHumans()) do
            if (v:HasAccessToGQMenu()) then
                net.Send(v);
            end
        end
    else
        net.Broadcast();
    end
end

hook.Add("Initialize", "gQuest.CheckForNAV", function()
    local map = game.GetMap():lower();

    if (file.Exists("maps/" .. map .. ".nav", "MOD")) then
        gQuest.ServerHasNAV = true;
    end

    if (gQuest.ServerHasNAV) then
        gQuest.Debug("This server has the NAV file for this map. We can successfully use our patrol system.");
    else
        gQuest.Debug("This server does NOT have the nav file for this map. We will be unable to use our patrol system.");
    end
end);

hook.Add("PlayerInitialSpawn", "gQuest.SendNAVCheck", function(ply)
    timer.Simple(2, function()
        if (IsValid(ply) and ply:HasAccessToGQMenu()) then
            ply:SetPrivateGQString("server_has_nav_file", tostring(gQuest.ServerHasNAV));
        end
    end);
end);