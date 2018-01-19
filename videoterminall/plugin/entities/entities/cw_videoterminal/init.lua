--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]

include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

function ENT:Initialize()
	self:SetModel("models/props_combine/combine_interface001.mdl");
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
end;

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;

function ENT:PhysicsUpdate(physicsObject)
	if (!self:IsPlayerHolding() and !self:IsConstrained()) then
		physicsObject:SetVelocity( Vector(0, 0, 0) );
		physicsObject:Sleep();
	end;
end;

function ENT:Use(activator, caller)
	if (IsValid(activator) and activator:IsPlayer() and !Clockwork.camera:PlayerGetCameraID(activator)) then
		if (activator:GetEyeTraceNoCursor().HitPos:Distance(self:GetPos()) < 196) then
			if (Clockwork.plugin:Call("PlayerCanUseVideoTerminal", activator, self) != false) then
				Clockwork.plugin:Call("PlayerUseVideoTerminal", activator, self);
			end;
		end;
	end;
end;

function ENT:CanTool(player, trace, tool)
	return false;
end;