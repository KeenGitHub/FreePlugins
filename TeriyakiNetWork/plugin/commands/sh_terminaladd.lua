--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]

local COMMAND = Clockwork.command:New("TerminalAdd");
COMMAND.tip = "Add a terminal at your target position.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";
COMMAND.text = "<none>";

-- Called when the command has been run.
function COMMAND:OnRun(player)
	local trace = player:GetEyeTraceNoCursor();
	local entity = ents.Create("cw_terminal");
	
	entity:SetPos(trace.HitPos + Vector(0,0,10));
	entity:Spawn();
	player:EmitSound("items/battery_pickup.wav");

	if (IsValid(entity)) then
		--entity:SetAngles( Angle(90, player:EyeAngles().yaw + 180,0) );
		player:EmitSound("items/battery_pickup.wav");
	end;
end;

COMMAND:Register();