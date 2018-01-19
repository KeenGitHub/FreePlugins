--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]

function cwVideoterminal:ClockworkInitPostEntity()
	self:LoadCameras();
	self:LoadCamerasGroups();
	self:LoadVideoTerminals();
end;

function cwVideoterminal:PostSaveData()
	self:SaveCameras();
	self:SaveCamerasGroups();
	self:SaveVideoTerminals();
end;

function cwVideoterminal:PlayerCharacterLoaded(player)
	player.cwVideoCamera = false;
	player.cwVideoGroup = false;
	Clockwork.camera:UpdateGroupData(player);
	Clockwork.camera:SendCamerasData();
end;

function cwVideoterminal:PlayerCanUseVideoTerminal(player, terminal)
	if (!player:Alive() or player:IsRagdolled() or player:GetSharedVar("tied") != 0) then
		return false;
	end;

	return true;
end;

function cwVideoterminal:PlayerUseVideoTerminal(player, terminal)
	local groups = {};
	local available = {};

	if (table.Count(terminal.cwGroups) != 0) then
		for k, v in pairs(terminal.cwGroups) do
			if (Clockwork.camera:PlayerHasGroupPreAccess(player, k)) then
				table.insert(available,k);
			end;
			table.insert(groups,k);
		end;
	else
		for k, v in pairs(Clockwork.camera:GetGroupList()) do
			if (Clockwork.camera:PlayerHasGroupPreAccess(player, k)) then
				table.insert(available,k);
			end;
			table.insert(groups,k);
		end;
	end;

	Clockwork.datastream:Start( player, "cwVideoTerminalShow", available);
	player.cwBufferTerminal = terminal;
end;

function cwVideoterminal:PlayerCanSwitchCharacter(player, character)
	if (Clockwork.camera:PlayerGetCameraID(player)) then
		return false;
	end;
end;

function cwVideoterminal:PlayerTakeDamage(player, inflictor, attacker, hitGroup, damageInfo)
	Clockwork.camera:PlayerLeaveCamera(player);
end;

function cwVideoterminal:ChatBoxMessageAdded(info)
	if (info.class == "ic" or info.class == "me" or info.class == "radio" or info.class == "yell") then
		local talkRadius = Clockwork.config:Get("talk_radius"):Get();
		local listeners = {};
		local players = _player.GetAll();
		local data = {};

		if (info.class == "yell") then
			talkRadius = talkRadius * 2;
		end;

		for k, v in pairs(Clockwork.camera:GetCamerasList()) do
			if (info.speaker:GetPos():Distance( v.entity:GetPos() ) <= talkRadius) then
				data.id = k;
				data.position = v.entity:GetPos();
				data.entity = v.entity;
				break;
			end;
		end;

		if (IsValid(data.entity)) then
			for k, v in ipairs(players) do
				if (v:HasInitialized() and v:Alive() and !v:IsRagdolled(RAGDOLL_FALLENOVER)) then
					if (Clockwork.camera:PlayerGetCameraID(v) and Clockwork.camera:PlayerGetCameraID(v) == data.id and v != info.speaker
						and Clockwork.camera:GetCamera(Clockwork.camera:PlayerGetCameraID(v)).enabled) then
						listeners[v] = v;
					end;
				end;
			end;

			if (table.Count(listeners) > 0) then
				Clockwork.chatBox:Add(listeners, info.speaker, "cam_"..info.class, info.text);
			end;

			table.Merge(info.listeners, listeners);
		end;
	end;
end;

function cwVideoterminal:EntityTakeDamage(entity, damageInfo)
	local attacker = damageInfo:GetAttacker();
	local inflictor = damageInfo:GetInflictor();
	local damage = damageInfo:GetDamage();
	local curTime = CurTime();
	local doDoorDamage = nil;

	if (entity:IsNPC() and entity:GetClass() == "npc_combine_camera") then
		for k, v in pairs(Clockwork.camera:GetCamerasList()) do
			if (v.entity == entity) then
				if (!v.destroyed and v.enabled) then
					entity.fakeHealth = (entity.fakeHealth or Clockwork.config:Get("videocamera_health"):Get()) - damageInfo:GetDamage();

					if (entity.fakeHealth <= 0) then
						v.destroyed = true;
						v.enabled = false;
						entity:Fire("Disable", "", 0);

						Clockwork.camera:SendCamerasData();
					end;
					
					Clockwork.kernel:CreateTimer("reset_camera_health_"..entity:EntIndex(), Clockwork.config:Get("videocamera_respawn_delay"):Get(), 1, function()
						if (IsValid(entity)) then
							entity.fakeHealth = Clockwork.config:Get("videocamera_health"):Get();

							if (v.destroyed) then
								entity:Fire("Enable", "", 0);
								v.enabled = true;

								Clockwork.camera:SendCamerasData();
							end;

							v.destroyed = false;
						end;
					end);
				end;

				damageInfo:SetDamage(0);
			end;
		end;
	end;
end;