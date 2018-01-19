--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]


DEFINE_BASECLASS("base_gmodentity");

ENT.Type = "anim";
ENT.Author = "Teriyaki"
ENT.PrintName = "Camera";
ENT.Spawnable = false;
ENT.AdminSpawnable = false;
ENT.PhysgunDisabled = true;

function ENT:SetupDataTables()
	self:NetworkVar( "Int", 0, "Key" );
	self:NetworkVar( "Bool", 0, "On" );
	self:NetworkVar( "Vector", 0, "vecTrack" );
	self:NetworkVar( "Entity", 0, "entTrack" );
	self:NetworkVar( "Entity", 1, "Player" );
end;