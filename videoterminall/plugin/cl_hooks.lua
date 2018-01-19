--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]

Clockwork.config:AddToSystem("(Teriyaki) Video Terminals - Camera health", "videocamera_health", "Set camera max health.", 0, 200);
Clockwork.config:AddToSystem("(Teriyaki) Video Terminals - Camera respawn delay", "videocamera_respawn_delay", "The time that a camera has to wait before they can enabled again (seconds).", 0, 3600);

function cwVideoterminal:GetProgressBarInfo()
	local action, percentage = Clockwork.player:GetAction(Clockwork.Client, true);

	if (!Clockwork.Client:IsRagdolled()) then
		if (action == "cwVideoCameraConnecting") then
			return {text = "Connecting.", percentage = percentage, flash = percentage < 10};
		end;
	end;
end;

function cwVideoterminal:PlayerCanSeeBars( class )
	if (class == "top") then
		if (Clockwork.camGUI.cameraID) then
			return false;
		end;
	end;
end;

Clockwork.datastream:Hook("cwCamerasHide", function(data)
	for k,v in pairs( ents.GetAll() ) do
		if v:IsNPC() then
			local class = v:GetClass();
			
			if (class == "npc_combine_camera") then
				v:SetNoDraw(data);
			end;
		end;
	end;
end);
