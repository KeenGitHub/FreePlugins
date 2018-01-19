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
	self:SetModel("models/props_combine/combine_interface00"..math.random(1,2)..".mdl");

	self:SetHealth(125);
	self:SetMoveType(MOVETYPE_VPHYSICS);
	self:PhysicsInit(SOLID_VPHYSICS);
	self:SetUseType(SIMPLE_USE);
	self:SetSolid(SOLID_VPHYSICS);
	
	local physicsObject = self:GetPhysicsObject()
	physicsObject:SetMass( 100 )
		
	self:SetCollisionGroup(COLLISION_GROUP_WORLD);
	
	self.timeStep = 8;
	

	if ( IsValid(physicsObject) ) then
		physicsObject:Wake();
		physicsObject:EnableMotion(true);
	end;
	
end;

-- Called when the entity takes damage.
function ENT:OnTakeDamage(damageInfo)
	self:SetHealth( math.max(self:Health() - damageInfo:GetDamage(), 0) );
	
	if (self:Health() <= 0) then
		self:Explode(); self:Remove();
	end;
end;

function ENT:Think()

end;

-- Called when the entity should explode.
function ENT:Explode()
	local effectData = EffectData();
	
	effectData:SetStart( self:GetPos() );
	effectData:SetOrigin( self:GetPos() );
	effectData:SetScale(8);
	
	util.Effect("Explosion", effectData, true, true);
	

	self:EmitSound("ambient/explosions/explode_1.wav");
end;

-- Emit a random sound from the randomSounds table.
function ENT:EmitRandomSound()
	local randomSounds = {
		"ambient/machines/combine_terminal_idle4.wav"
	};
	
	self:EmitSound( randomSounds[ math.random(1, #randomSounds) ] );
end;

-- Called when the entity is used.
function ENT:Use(activator, caller)
	if (activator:IsPlayer()) then
		local curTime = CurTime();
			self:EmitRandomSound();
			activator:ConCommand("terminalshow");
	end;
end;

-- Called when the entity's physics should be updated.
function ENT:PhysicsUpdate(physicsObject)
	if (!self:IsPlayerHolding() and !self:IsConstrained()) then
		physicsObject:SetVelocity( Vector(0, 0, 0) );
		physicsObject:Sleep();
	end;
end;


-- Called when a player attempts to use a tool.
function ENT:CanTool(player, trace, tool)
	return false;
end;

-- Called when the entity's transmit state should be updated.
function ENT:UpdateTransmitState()
	return TRANSMIT_ALWAYS;
end;