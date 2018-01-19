--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]


local COMMAND = Clockwork.command:New("VideoCameraAdd");
COMMAND.tip = "Spawn video camera at your target position.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

function COMMAND:OnRun(player, arguments)
	Clockwork.datastream:Start(player,"cwVideoCameraAdd", true);
end;

COMMAND:Register();