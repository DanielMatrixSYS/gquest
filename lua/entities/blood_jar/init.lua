AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

include("shared.lua");

---
--- Initialize
---
function ENT:Initialize()
	self:SetModel("models/props_junk/glassjug01.mdl");
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:SetSolid(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
end

---
--- OnTakeDamage
---
function ENT:OnTakeDamage(dmg)
	return false;
end

---
--- UpdateTransmitState
---
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end
