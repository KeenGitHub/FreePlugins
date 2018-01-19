--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]

local COMMAND = Clockwork.command:New("VideoTerminalAdd");
COMMAND.tip = "Spawn video terminal at your target position.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

function COMMAND:OnRun(player, arguments)
	Clockwork.datastream:Start(player,"cwVideoTerminalAdd", true);
end;

COMMAND:Register();