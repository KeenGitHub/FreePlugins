--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]

if (CLIENT) then
	Clockwork.newCamera = Clockwork.kernel:NewLibrary("New Camera");

	function Clockwork.newCamera:GetPanel()
		return self.panel;
	end;

	function Clockwork.newCamera:IsOpen()
		local panel = self:GetPanel();
		
		if (IsValid(panel) and panel:IsVisible()) then
			return true;
		end;
	end;

	function Clockwork.newCamera:GetID()
		return self.id;
	end;

	Clockwork.datastream:Hook("cwVideoCameraAdd", function(data)
		Clockwork.newCamera.enabled = false;
		Clockwork.newCamera.name = false;
		Clockwork.newCamera.id = false;

		Clockwork.newCamera.panel = vgui.Create("cwNewCamera");
		Clockwork.newCamera.panel:Rebuild();
		Clockwork.newCamera.panel:MakePopup();
	end);

	Clockwork.datastream:Hook("cwVideoCameraEdit", function(data)
		Clockwork.newCamera.name = data.name;
		Clockwork.newCamera.id = data.id;
		Clockwork.newCamera.enabled = data.enabled;

		Clockwork.newCamera.panel = vgui.Create("cwNewCamera");
		Clockwork.newCamera.panel:Rebuild();
		Clockwork.newCamera.panel:MakePopup();
	end);
else
	Clockwork.datastream:Hook("cwVideoCameraAdd", function(player, data)
		if (Clockwork.player:HasFlags(player, "s")) then

			local camera = Clockwork.camera:GetCamera(data.id);

			if (camera) then
				camera.name = data.name;
				camera.enabled = data.enabled;
			else
				local trace = player:GetEyeTraceNoCursor();
				local entity = ents.Create("npc_combine_camera");

				entity:SetPos(trace.HitPos);
				entity:Spawn();

				if (IsValid(entity)) then
					entity:SetAngles( Angle(0, player:EyeAngles().yaw + 180,0) );

					if (!data.enabled) then entity:Fire("Disable", "", 0); end;
			
					entity.camera = ents.Create( "cw_videocamera" );
					entity.camera:SetCameraParent(entity);
					entity.camera:Spawn();

					Clockwork.camera:AddCamera(data.id, data.name, entity, data.enabled);
				end;
			end;

			Clockwork.camera:UpdateCameraData(data.id);
			cwVideoterminal:SaveCameras();
		end;
	end);
end;