--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

gQuest.Materials = gQuest.Materials or {};

local mat       = Material;
local folder    = "gquest/";
local materials = {
    {
        name = "Background",
        material = mat(folder .. "main_background.png")
    },

    {
        name = "Header",
        material = mat(folder .. "notification_header.png", "noclamp smooth")
    },

    {
        name = "Exit",
        material = mat(folder .. "x.png", "noclamp smooth")
    },

    {
        name = "Arrow Down",
        material = mat(folder .. "arrow_down.png", "noclamp smooth")
    },

    {
        name = "Circle",
        material = mat(folder .. "circle.png", "noclamp smooth")
    },

    {
        name = "Checkmark",
        material = mat(folder .. "checkmark.png", "noclamp smooth")
    },

    {
        name = "Info",
        material = mat(folder .. "info.png", "noclamp smooth")
    },

    {
        name = "NPCS",
        material = mat(folder .. "npcs.png", "noclamp smooth")
    },

    {
        name = "Dev Tools",
        material = mat(folder .. "programming.png", "noclamp smooth")
    },

    {
        name = "Database",
        material = mat(folder .. "database.png", "noclamp smooth")
    },

    {
        name = "Edit",
        material = mat(folder .. "edit.png", "noclamp smooth")
    },
}

for _, v in ipairs(materials) do
    gQuest.Materials[v.name] = v.material;
end