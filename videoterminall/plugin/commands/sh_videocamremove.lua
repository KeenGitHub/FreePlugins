--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]


local COMMAND = Clockwork.command:New("VideoCameraRemove");
COMMAND.tip = "Remove video camera at your current position.";
COMMAND.flags = CMD_DEFAULT;
COMMAND.access = "s";

function COMMAND:OnRun(player, arguments)
	local target = player:GetEyeTraceNoCursor().Entity;

	if (IsValid(target)) then
		local data = Clockwork.camera:CameraGetByEntity(target);

		if (data) then
			Clockwork.camera.cameras[data.id].entity.camera:Remove();
			Clockwork.camera.cameras[data.id].entity:Remove();
			Clockwork.camera.cameras[data.id] = nil;

			for k,v in pairs(Clockwork.camera:GetGroupList()) do
				for k2,v2 in pairs(v.cameras) do
					if (v2.id == data.id) then
						v.cameras[k2] = nil;
					end;
				end;
			end;

			Clockwork.camera:SendCamerasData();
			Clockwork.camera:UpdateGroupData();
			Clockwork.player:Notify(player, "Camera was deleted.");
		else
			Clockwork.player:Notify(player, "You must look at a valid entity!");
		end;
	else
		Clockwork.player:Notify(player, "You must look at a valid entity!");
	end;
end;

COMMAND:Register();