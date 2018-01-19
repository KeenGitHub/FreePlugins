--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]

local COMMAND = Clockwork.command:New("TerminalDispenseRequestDevice");
COMMAND.tip = "Print a Requesr Device from a nearby terminal.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.text = "<none>";

-- Called when the command has been run.
function COMMAND:OnRun(player)
	for k, v in ipairs( ents.FindInSphere(player:GetPos(),350) ) do
		if v:IsValid() && v:GetClass() == "cw_terminal" then
			if not player:HasItemByID("request_device") then 
				player:GiveItem(Clockwork.item:CreateInstance("request_device"));
			end;
		end;
	end;
end;

COMMAND:Register();