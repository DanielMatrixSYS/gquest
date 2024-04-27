--[[------------------------------------------------------------------------------
 *  Copyright (C) Fluffy(76561197976769128 - STEAM_0:0:8251700) - All Rights Reserved
 *  Unauthorized copying of this file, via any medium is strictly prohibited
 *  Proprietary and confidential
--]]------------------------------------------------------------------------------

util.AddNetworkString("gQuest.QuestUI");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

include("shared.lua");

local ROUTE_NORMAL    = 0x1;
local ROUTE_BACKWARDS = 0x2;

---
--- Initialize
---
function ENT:Initialize()
    self:SetModel("models/combine_soldier.mdl");
	self:SetHullType(HULL_HUMAN);
    self:SetUseType(SIMPLE_USE);
    self:SetSolid(SOLID_BBOX);
    self:CapabilitiesAdd(bit.bor(CAP_ANIMATEDFACE, CAP_TURN_HEAD));
    self.VoiceCooldown = CurTime();

    if (gQuest.NPCNoCollided) then
        self:SetCustomCollisionCheck(true);
    end

    -- These variables are all just for our patrol system.
    self.CanWalk = false;
    self.WasCalled = false;
    self.TurnTarget = nil;
    self.CurrentRoute = 1;
    self.RouteType = ROUTE_NORMAL;
    self.NextThinkWalk = CurTime() + 5;
    self.LastObjective = nil;
    self.Attempts = 0;
    self.Routes = {};
    self.PatrolSystemActivated = false;
    self.DefaultWalkAnimation = 15;
    self.HasSelectedWalkAnimation = false;

    if (gQuest.AnimationFix) then
        timer.Simple(1, function()
            self:SetPlaybackRate(gQuest.AnimationFixRate);
        end);
    end
end

---
--- Stop
---
function ENT:Stop(callback)
    self:CapabilitiesRemove(CAP_MOVE_GROUND);
    self:SetLastPosition(self:GetPos());
    self:SetSchedule(SCHED_FORCED_GO);

    timer.Simple(0, function()
        callback();
    end);
end

---
--- LookAtPlayer
---
function ENT:LookAtPlayer(player)
    self:Stop(function()
         self:SetTurnTarget(player);
    end);

    self.BeginToMoveAgain = CurTime() + 10;
    self.WasCalled = true;
end

---
--- SetTurnTarget
---
function ENT:SetTurnTarget(target)
    self.TurnTarget = target;

    return true;
end

---
--- ResetToWalkSequence
---
function ENT:ResetToWalkSequence()
    if (not self.HasSelectedWalkAnimation) then
        for k, v in ipairs(self:GetSequenceList()) do
            if (k ~= self.DefaultWalkAnimation and v:lower() == "walk_all") then
                self.DefaultWalkAnimation = k;
            end
        end

        self.HasSelectedWalkAnimation = true;
    end

    return self:ResetSequence(self.DefaultWalkAnimation);
end

---
--- NextAttempt
---
function ENT:NextAttempt()
    if (self.Attempts >= 5) then
        gQuest.Broadcast("Warning: The NPC[" .. self:GetHeader() .. ", " .. self:GetID() .. "] is on his " .. self.Attempts .. " attempt to try to reach route[" .. self.CurrentRoute .. "] It seems to be stuck, can it get some help?", true);
    end

    return math.Clamp(60 - (10 * self.Attempts), 10, 60);
end

---
--- CheckForward
---
function ENT:CheckForward()
    if (self.RouteType ~= ROUTE_NORMAL) then
        return false;
    end
    
    local lastPoint = #self.Routes;
    local nextRoute = self.CurrentRoute + 1;
    for i = 1, #self.Routes do
        local route = self.Routes[i];

        if (nextRoute == i) then
            if (self:GetPos():DistToSqr(util.StringToType(self.Routes[self.CurrentRoute], "Vector")) <= 30 ^ 2) then
                self:SetLastPosition(self.Routes[nextRoute]);
                self:SetSchedule(SCHED_FORCED_GO);

                self:ResetToWalkSequence();
                self.LastObjective = CurTime() + self:NextAttempt();
                self.CurrentRoute = nextRoute;
                self.Attempts = 0
            else
                local lastRegisteredPos = self:GetSaveTable().m_vecLastPosition;

                if (lastRegisteredPos == self.Routes[self.CurrentRoute]) then
                    if (self.LastObjective and self.LastObjective <= CurTime()) then
                        self:SetLastPosition(lastRegisteredPos);
                        self:SetSchedule(SCHED_FORCED_GO);
                        self:ResetToWalkSequence();

                        self.LastObjective = CurTime() + self:NextAttempt();
                        self.Attempts = self.Attempts + 1;
                    end

                    continue;
                end

                self:SetLastPosition(util.StringToType(self.Routes[self.CurrentRoute], "Vector"));
                self:SetSchedule(SCHED_FORCED_GO);
                self:ResetToWalkSequence();
            end
        end
    end

    return true;
end

---
--- CheckBackwards
---
function ENT:CheckBackwards()
    if (self.RouteType ~= ROUTE_BACKWARDS) then
        return false;
    end

    local nextRoute = self.CurrentRoute - 1;
    for i = 1, #self.Routes do
        local route = self.Routes[i];

        if (nextRoute == i) then
            if (self:GetPos():DistToSqr(util.StringToType(self.Routes[self.CurrentRoute], "Vector")) <= 30 ^ 2) then
                self:SetLastPosition(self.Routes[nextRoute]);
                self:SetSchedule(SCHED_FORCED_GO);

                self:ResetToWalkSequence();
                self.LastObjective = CurTime() + self:NextAttempt();
                self.CurrentRoute = nextRoute;
                self.Attempts = 0
            else
                local lastRegisteredPos = self:GetSaveTable().m_vecLastPosition;

                if (lastRegisteredPos == self.Routes[self.CurrentRoute]) then
                    if (self.LastObjective and self.LastObjective <= CurTime()) then
                        self:SetLastPosition(lastRegisteredPos);
                        self:SetSchedule(SCHED_FORCED_GO);
                        self:ResetToWalkSequence();

                        self.LastObjective = CurTime() + self:NextAttempt();
                        self.Attempts = self.Attempts + 1;
                    end

                    continue;
                end

                self:SetLastPosition(util.StringToType(self.Routes[self.CurrentRoute], "Vector"));
                self:SetSchedule(SCHED_FORCED_GO);
                self:ResetToWalkSequence();
            end
        end
    end

    return true;
end

---
--- CheckRoute
---
function ENT:CheckRoute()
    if (self.RouteType == ROUTE_NORMAL) then
        local nextRoute = self.Routes[self.CurrentRoute + 1];

        if (not nextRoute) then
            self.RouteType = ROUTE_BACKWARDS;
            self:CheckBackwards();
        else
            self:CheckForward();
        end
    else
        local nextRoute = self.Routes[self.CurrentRoute - 1];

        if (not nextRoute) then
            self.RouteType = ROUTE_NORMAL;
            self:CheckForward();
        else
            self:CheckBackwards();
        end
    end
end

---
--- Think
---
function ENT:Think()
    if (self.BeginToMoveAgain and self.BeginToMoveAgain <= CurTime() and self.WasCalled) then
        self.CanWalk = true;
        self.WasCalled = false;
    end

    if (self.CanWalk) then
        self:CapabilitiesAdd(CAP_MOVE_GROUND);

        self.CanWalk = false;
    end

    if (IsValid(self.TurnTarget)) then
        local ang = (self.TurnTarget:GetPos() - self:GetPos()):Angle().y;
        
        --Current Y Angle
        local cyAng = self:GetAngles();

        -- Lerped Y Angle
        local lyAng = Lerp(0.6, cyAng.y, ang);

        self:SetAngles(Angle(cyAng.x, lyAng, cyAng.z));
        if (math.floor(lyAng) == math.floor(ang)) then
            self.TurnTarget = nil;
        end
    end

    if (self.PatrolSystemActivated) then
        if (not self.WasCalled and self.NextThinkWalk <= CurTime()) then
            if (bit.band(self:CapabilitiesGet(), CAP_MOVE_GROUND) ~= CAP_MOVE_GROUND) then
                self:CapabilitiesAdd(CAP_MOVE_GROUND);
            end

            self:CheckRoute();
            self.NextThinkWalk = CurTime() + 1;
        end
    end
end

---
--- AcceptInput
---
function ENT:AcceptInput(Type, _, Caller)
    if (Type == "Use" and Caller:IsPlayer()) then
        local npc_quests = gQuest.GetNPCQuests(self:GetID(), Caller);

        if (self.VoiceCooldown < CurTime()) then
            self:EmitSound(self:GetInteractionSound());
            self.VoiceCooldown = CurTime() + 2;
        end

        if (not npc_quests) then
            gQuest.Debug("ERROR: NPC[" .. self:GetID() .. ", " .. self:GetHeader() .. "] does not have any quests.");

            return;
        end

        if (self.PatrolSystemActivated) then
            self:LookAtPlayer(Caller);
        end

        net.Start("gQuest.QuestUI")
            net.WriteEntity(self);
        net.Send(Caller)
    end
end

function ENT:OnTakeDamage()
    return 0;
end
