--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]

function cwVideoterminal:PlayerInCamera()
	local inCamera = Clockwork.Client:GetSharedVar("inCamera");

	if (inCamera != CAMERA_FALSE) then
		return inCamera;
	end;
	return false;
end;

function cwVideoterminal:GetCameraID()
	if (self:PlayerInCamera()) then
		for k, v in pairs(self.camData) do
			if (v.id == self:PlayerInCamera()) then
				return k;
			end;
		end;
	end;
end;

function cwVideoterminal:GetCameraData()
	if (self:PlayerInCamera()) then
		for k, v in pairs(self.camData) do
			if (v.id == self:PlayerInCamera()) then
				return v;
			end;
		end;
	end;
end;

Clockwork.chatBox:RegisterClass("cam_ic", "ic", function(info)
	local color = Color(255, 255, 150, 255);
	local camColor = Color(150, 255, 255, 255);

	Clockwork.chatBox:Add(info.filtered, nil, camColor,"Camera: " ,color, info.name.." says \""..info.text.."\"");
end);

Clockwork.chatBox:RegisterClass("cam_yell", "ic", function(info)
	local color = Color(255, 255, 150, 255);
	local camColor = Color(150, 255, 255, 255);

	Clockwork.chatBox:Add(info.filtered, nil, camColor,"Camera: " ,color, info.name.." yells \""..info.text.."\"");
end);

Clockwork.chatBox:RegisterClass("cam_me", "ic", function(info)
	local color = Color(255, 255, 150, 255);
	local camColor = Color(150, 255, 255, 255);

	Clockwork.chatBox:Add(info.filtered, nil, camColor,"Camera: " ,color, "** "..info.name..info.text);
end);

Clockwork.chatBox:RegisterClass("cam_radio", "ic", function(info)
	local color = Color(75, 150, 50, 255);
	local camColor = Color(150, 255, 255, 255);

	Clockwork.chatBox:Add(info.filtered, nil, camColor,"Camera: " ,color, info.name.." radios in \""..info.text.."\"");
end);