--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]

if (CLIENT) then
	Clockwork.terminalAdd = Clockwork.kernel:NewLibrary("Camera List");
	Clockwork.terminalAdd.typeList = {};

	function Clockwork.terminalAdd:GetPanel()
		return self.panel;
	end;

	function Clockwork.terminalAdd:IsOpen()
		local panel = self:GetPanel();
		
		if (IsValid(panel) and panel:IsVisible()) then
			return true;
		end;
	end;

	Clockwork.datastream:Hook("cwVideoTerminalAdd", function(data)
		Clockwork.terminalAdd.groups = {};
		Clockwork.terminalAdd.panel = vgui.Create("cwTerminalAdd");
		Clockwork.terminalAdd.panel:Rebuild();
		Clockwork.terminalAdd.panel:MakePopup();
	end);
else
	Clockwork.datastream:Hook("cwVideoTerminalAdd", function(player,data)
		if (Clockwork.player:HasFlags(player, "s")) then

			local trace = player:GetEyeTraceNoCursor();
			local entity = ents.Create("cw_videoterminal");
			entity:SetPos(trace.HitPos + Vector(0,0,1));
			entity:SetAngles( Angle(0, player:EyeAngles().yaw + 180,0) );
			entity:Spawn();
			entity.cwGroups = data;
		
			Clockwork.entity:MakeSafe(entity, true, true);
			Clockwork.player:Notify(player, "You have spawned a video terminal.");
			cwVideoterminal:SaveVideoTerminals();
		end;
	end);
end;