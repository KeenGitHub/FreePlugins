--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]
local PLUGIN = PLUGIN;

function PLUGIN:ClockworkInitPostEntity()
	self:LoadTerminals();
end;

function PLUGIN:PostSaveData()
	self:SaveTerminals();
end;
