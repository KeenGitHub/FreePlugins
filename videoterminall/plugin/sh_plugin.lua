--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]

PLUGIN:SetGlobalAlias("cwVideoterminal");

GROUP_FALSE = "none";
CAMERA_FALSE = "none";

ACCESS_BY_NONE = 0;
ACCESS_BY_PASS = 1;
ACCESS_BY_CLASS = 2;

Clockwork.kernel:IncludePrefixed("sv_plugin.lua");
Clockwork.kernel:IncludePrefixed("sv_hooks.lua");
Clockwork.kernel:IncludePrefixed("cl_plugin.lua");
Clockwork.kernel:IncludePrefixed("cl_hooks.lua");