--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]


include("shared.lua");

AddCSLuaFile("cl_init.lua");
AddCSLuaFile("shared.lua");

-- Called when the entity initializes.
function ENT:Initialize()
	self:SetModel( "models/Items/AR2_Grenade.mdl" );
	
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
	
	self:DrawShadow( false )
	
	self:SetCollisionGroup(COLLISION_GROUP_WORLD);
	
	local phys = self:GetPhysicsObject()

	if ( phys:IsValid() ) then
		phys:Sleep();
	end;
end;

function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;


function ENT:Use(activator, caller)

end;

function ENT:CanTool(player, trace, tool)
	return false;
end;

function ENT:SetCameraParent( entity )
	self:SetParent( entity );
	
	local attachment = entity:GetAttachment( entity:LookupAttachment( "eyes" ) )

	self:SetPos( attachment.Pos + Vector(8,0,5) )
	self:SetAngles( attachment.Ang )
	
	self:Fire( "setparentattachmentmaintainoffset" , "eyes" , 0);
end;