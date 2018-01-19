--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]
if (CLIENT) then
	Clockwork.camGUI = Clockwork.kernel:NewLibrary("Camera GUI");

	function Clockwork.camGUI:GetPanel()
		return self.panel;
	end;

	function Clockwork.camGUI:IsOpen()
		local panel = self:GetPanel();
		
		if (IsValid(panel) and panel:IsVisible()) then
			return true;
		end;
	end;

	function Clockwork.camGUI:GetCameraID()
		return self.cameraID;
	end;

	function Clockwork.camGUI:GetGroupID()
		return self.groupID;
	end;

	function Clockwork.camGUI:GetName()
		return self.name;
	end;


	Clockwork.datastream:Hook("cwOpenCamGUI", function(data)
		Clockwork:ScoreboardHide();

		Clockwork.camGUI.cameraID = data.cameraID;
		Clockwork.camGUI.groupID = data.groupID;
		Clockwork.camGUI.name = data.name;

		if (!Clockwork.camGUI:IsOpen()) then
			Clockwork.camGUI.panel = vgui.Create("cwCamGUI");
		end;

		gui.EnableScreenClicker(true);
	end);
else
	Clockwork.datastream:Hook("cwCameraLeave", function(player,data)
		Clockwork.camera:PlayerLeaveCamera(player);
	end);

	Clockwork.datastream:Hook("cwCameraTurn", function(player, data)
		local camera = Clockwork.camera:GetCamera(Clockwork.camera:PlayerGetCameraID(player));

		if (camera) then

			if (!camera.destroyed) then
				if (camera.enabled) then
					camera.enabled = false;
					camera.entity:Fire("Disable", "", 0);
				else
					camera.enabled = true;
					camera.entity:Fire("Enable", "", 0);
				end;
			end;

			Clockwork.camera:SendCamerasData();
		end;
	end);

	Clockwork.datastream:Hook("cwChangeCamera", function(player, data)
		cwVideoterminal:EnterInVideoTerminal(player, data.id);
	end);

	Clockwork.datastream:Hook("cwNextCamera", function(player, data)
		Clockwork.camera:PlayerNextCamera(player);
	end);

	Clockwork.datastream:Hook("cwPreviousCamera", function(player, data)
		Clockwork.camera:PlayerPreviousCamera(player);
	end);
end;