--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]


local COMMAND = Clockwork.command:New("VideoCameraEdit");
COMMAND.tip = "Edit a camera at your target position.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;

	if (IsValid(target)) then
		local data = Clockwork.camera:CameraGetByEntity(target);

		if (data) then
			Clockwork.datastream:Start(player,"cwVideoCameraEdit", {
				id = data.id,
				name = data.data.name,
				enabled = data.data.enabled,
			});	
		else
			Clockwork.player:Notify(player, "You must look at a valid entity!");
		end;
	else
		Clockwork.player:Notify(player, "You must look at a valid entity!");
	end;
end;

COMMAND:Register();