--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]

Clockwork.camera = Clockwork.kernel:NewLibrary("Cameras");
Clockwork.camera.groups = {};
Clockwork.camera.cameras = {};

function Clockwork.camera:GetGroup(id)
	return self.groups[id];
end;

function Clockwork.camera:GetCamera(id)
	return self.cameras[id];
end;

function Clockwork.camera:GetGroupList()
	return self.groups;
end;

function Clockwork.camera:GetCamerasList()
	return self.cameras;
end;

function Clockwork.camera:GetPlayerCameraGroup(player)
	return player:GetSharedVar("inCamera");
end;

function Clockwork.camera:GetGroupCameras(id)
	local group = self:GetGroup(id);

	if (group) then
		return group.cameras;
	end;
end;

if (CLIENT) then
	Clockwork.camera.camera = CAMERA_FALSE;
	Clockwork.camera.group = GROUP_FALSE;

	Clockwork.datastream:Hook("cwUpdateGroupData", function(data)
		Clockwork.camera.groups = data;
	end);

	Clockwork.datastream:Hook("cwSendCamerasData", function(data)
		Clockwork.camera.cameras = data;
	end);
else
	function Clockwork.camera:AddGroup(id, name, access, accessData)
		self.groups[id] = {
			name = name,
			access = access,
			accessData = accessData,
			cameras = {}
		};
	end;

	function Clockwork.camera:RemoveGroup(id)
		self.groups[id] = nil;
	end;

	function Clockwork.camera:CameraGetByEntity(entity)
		if (IsValid(entity)) then
			for k,v in pairs(self:GetCamerasList()) do
				if (v.entity == entity) then
					return {id = k, data = v};
				end;
			end;
		end;
	end;

	function Clockwork.camera:AddCamera(id, name, entity, enabled)
		self.cameras[id] = {
			name = name,
			class = entity:GetClass(),
			entity = entity,
			enabled = enabled,
			destroyed = false
		};
	end;

	function Clockwork.camera:UpdateGroupData(player)
		local groups = {};

		for k, v in pairs(self.groups) do
			groups[k] = {
				name = v.name,
				access = v.access,
				cameras = v.cameras
			};
		end;

		if (player) then
			Clockwork.datastream:Start(player, "cwUpdateGroupData", groups);
		else
			Clockwork.datastream:Start(_player.GetAll(), "cwUpdateGroupData", groups);
		end;
	end;

	function Clockwork.camera:SendCamerasData()
		local cameras = {};

		for k, v in pairs(self.cameras) do
			cameras[k] = {
				name = v.name,
				enabled = v.enabled,
			};
		end;

		Clockwork.datastream:Start(_player.GetAll(), "cwSendCamerasData", cameras);
	end;

	function Clockwork.camera:UpdateCameraData(id)
		for k,v in pairs(self:GetGroupList()) do
			for k2,v2 in pairs(v.cameras) do
				if (v2.id == id) then
					v2.name = self:GetCamera(id).name;
				end;
			end;
		end;

		self:SendCamerasData();
		self:UpdateGroupData();
	end;

	function Clockwork.camera:AddCameraInGroup(groupID, cameraID)
		local group = self:GetGroup(groupID);

		if (group) then
			local camera = self:GetCamera(cameraID)

			if (camera) then
				group.cameras[#group.cameras + 1] = {
					id = cameraID,
					name = camera.name
				};
			end;
		end;
	end;

	function Clockwork.camera:PlayerSetCamera(player, groupID, cameraID)
		local group = self:GetGroup(groupID);

		if (group) then
			local camera = self:GetCamera(cameraID);

			if (camera) then
				player.cwVideoCamera = cameraID;
				player.cwVideoGroup = groupID;
				player:SetViewEntity(camera.entity.camera);
				player:SetMoveType(MOVETYPE_NONE);
				Clockwork.datastream:Start( player, "cwCamerasHide",  true );
				Clockwork.datastream:Start( player, "cwOpenCamGUI", {name = camera.name, cameraID = cameraID, groupID = groupID} );
			end;
		end;
	end;

	function Clockwork.camera:PlayerLeaveCamera(player)
		player.cwVideoCamera = false;
		player.cwVideoGroup = false;
		player:SetViewEntity(player);
		player:SetMoveType(MOVETYPE_WALK);
		Clockwork.datastream:Start(player, "cwCamerasHide", false);
	end;

	function Clockwork.camera:PlayerGetCameraID(player)
		return player.cwVideoCamera;
	end;

	function Clockwork.camera:PlayerGetGroupID(player)
		return player.cwVideoGroup;
	end;

	function Clockwork.camera:PlayerNextCamera(player)
		local group = self:GetGroup(self:PlayerGetGroupID(player));
		local listPos = false;
		if (group) then
			for k,v in pairs(group.cameras) do
				if (v.id == self:PlayerGetCameraID(player)) then
					listPos = k;

					break;
				end;
			end;

			if (listPos < table.Count(group.cameras)) then
				local camera = self:GetCamera(group.cameras[listPos + 1].id);

				if (camera) then
					local cameraID = group.cameras[listPos + 1].id;

					self:PlayerSetCamera(player, self:PlayerGetGroupID(player), cameraID);
				end;
			end;

		end;
	end;

	function Clockwork.camera:PlayerPreviousCamera(player)
		local group = self:GetGroup(self:PlayerGetGroupID(player));
		local listPos = false;
		if (group) then
			for k,v in pairs(group.cameras) do
				if (v.id == self:PlayerGetCameraID(player)) then
					listPos = k;

					break;
				end;
			end;

			if (listPos > 1) then
				local camera = self:GetCamera(group.cameras[listPos - 1].id);

				if (camera) then
					local cameraID = group.cameras[listPos - 1].id;

					self:PlayerSetCamera(player, self:PlayerGetGroupID(player), cameraID);
				end;
			end;

		end;
	end;

	function Clockwork.camera:PlayerHasGroupPreAccess(player, groupID)
		local group = self:GetGroup(groupID);

		if (group) then
			if (group.access == ACCESS_BY_CLASS) then
				local numFactions = table.Count(group.accessData.factions);
				local numClasses = table.Count(group.accessData.classes);
				local bDisallowed = nil;

				if (numFactions > 0) then
					if (!group.accessData.factions[player:GetFaction()]) then
						bDisallowed = true;
					end;
				end;
				
				if (numClasses > 0) then
					if (!group.accessData.classes[_team.GetName(player:Team())]) then
						bDisallowed = true;
					end;
				end;

				if (bDisallowed) then
					return false;
				end;
			end;

			return true;
		end;
	end;

	Clockwork.datastream:Hook("cwCameraFastConnect", function(player, data)
		Clockwork.camera:PlayerSetCamera(player, data.groupID, data.cameraID);
	end);

	Clockwork.datastream:Hook("cwCameraConnect", function(player, data)
		if (IsValid(player.cwBufferTerminal)) then
			local groupID = data.groupID;
			local cameraID = data.cameraID;
			local password = data.password;
			local group = Clockwork.camera:GetGroup(groupID);

			if (group) then
				if (group.access == ACCESS_BY_PASS) then
					if (group.accessData != password) then
						Clockwork.player:Notify(player, "Wrong password!");

						return;
					end;
				end;

				Clockwork.player:SetAction(player, "cwVideoCameraConnecting", 1);

				Clockwork.player:EntityConditionTimer(player, player:GetEyeTraceNoCursor().Entity, player:GetEyeTraceNoCursor().Entity, 1, 192, function()
					return player:Alive() and !player:IsRagdolled() and (player:GetSharedVar("tied") == 0);
				end, function(success)
					if (success) then
						Clockwork.camera:PlayerSetCamera(player, data.groupID, data.cameraID);
						player.cwBufferTerminal = false;
					end;
					
					Clockwork.player:SetAction(player, "cwVideoCameraConnecting", false);
				end);
			end;
		else
			Clockwork.player:Notify(player, "You have not used the terminal!");
		end;
	end);
end;