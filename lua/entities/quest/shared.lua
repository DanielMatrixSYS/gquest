--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

ENT.Base = "base_ai";
ENT.Type = "ai";
ENT.Spawnable = false;

---
--- SetupDataTables
---
function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "Header");
    self:NetworkVar("String", 1, "SubHeader");
    self:NetworkVar("String", 2, "InteractionSound");
    
    self:NetworkVar("Bool", 0, "Patroling");

    self:NetworkVar("Int", 0, "ID");
end

---
--- SetQuestNPCSequence
---
function ENT:SetQuestNPCSequence()
    local seqList       = self:GetSequenceList();
    local currentSeq    = self:GetSequence();
    local foundSeq;

    for k, v in ipairs(seqList) do
        local v = v:lower();

        if (v:find("idle") and v ~= "idlenoise") then
            foundSeq = k
            break;
        end
    end

    if (foundSeq and foundSeq ~= currentSeq) then
        self:ResetSequence(foundSeq);
    end
end