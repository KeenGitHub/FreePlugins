--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]

Clockwork.config:Add("videocamera_health", 50);
Clockwork.config:Add("videocamera_respawn_delay", 900);

function cwVideoterminal:SaveCamerasGroups()
	Clockwork.kernel:SaveSchemaData("plugins/videoterminals/groups/"..game.GetMap(), Clockwork.camera.groups);
end;

function cwVideoterminal:LoadCamerasGroups()
	Clockwork.camera.groups = Clockwork.kernel:RestoreSchemaData("plugins/videoterminals/groups/"..game.GetMap());
end;

function cwVideoterminal:SaveVideoTerminals()
	local videoterminals = {};
	
	for k, v in pairs(ents.FindByClass("cw_videoterminal")) do
		videoterminals[#videoterminals + 1] = {
			angles = v:GetAngles(),
			position = v:GetPos(),
			groups = v.cwGroups,
			model = v:GetModel();
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/videoterminals/terminals/"..game.GetMap(), videoterminals);
end;

function cwVideoterminal:LoadVideoTerminals()
	local videoterminals = Clockwork.kernel:RestoreSchemaData("plugins/videoterminals/terminals/"..game.GetMap());
	
	for k, v in pairs(videoterminals) do
		local entity = ents.Create("cw_videoterminal");
		
		entity:SetPos(v.position);
		entity:SetAngles(v.angles);
		entity:SetModel(v.model);
		entity:Spawn();
		entity.cwGroups = v.groups;
		Clockwork.entity:MakeSafe(entity, true, true);
	end;
end;

function cwVideoterminal:SaveCameras()
	local cameras = {};
	
	for k, v in pairs(Clockwork.camera.cameras) do
		cameras[k] = {
			name = v.name,
			class = v.class,
			enabled = v.enabled,
			angles = v.entity:GetAngles(),
			position = v.entity:GetPos()
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/videoterminals/cameras/"..game.GetMap(), cameras);
end;

function cwVideoterminal:LoadCameras()
	local cameras = Clockwork.kernel:RestoreSchemaData("plugins/videoterminals/cameras/"..game.GetMap());
	
	for k, v in pairs(cameras) do
		local entity = ents.Create(v.class);
		
		entity:SetPos(v.position);
		entity:Spawn();

		if (IsValid(entity)) then
			entity:SetAngles(v.angles);
			if (!v.enabled) then entity:Fire("Disable", "", 0); end;
			
			entity.camera = ents.Create( "cw_videocamera" );
			entity.camera:SetCameraParent(entity);
			entity.camera:Spawn();

			Clockwork.camera:AddCamera(k, v.name, entity, v.enabled);
		end;
	end;
end;

Clockwork.datastream:Hook("cwCamConnect", function(player, data)
	Clockwork.player:SetAction(player, "cwVideoCameraConnecting", 1);
	Clockwork.player:EntityConditionTimer(player, player:GetEyeTraceNoCursor().Entity, player:GetEyeTraceNoCursor().Entity, 1, 192, function()
		return player:Alive() and !player:IsRagdolled() and (player:GetSharedVar("tied") == 0);
	end, function(success)
		if (success) then
			Clockwork.plugin:Call("EnterInVideoTerminal", player, data.id);
		end;
		
		Clockwork.player:SetAction(player, "cwVideoCameraConnecting", false);
	end);
end);