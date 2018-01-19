--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]

if (CLIENT) then
	Clockwork.videoTerminal = Clockwork.kernel:NewLibrary("Video Terminal");
	Clockwork.videoTerminal.typeList = {};

	function Clockwork.videoTerminal:GetPanel()
		return self.panel;
	end;

	function Clockwork.videoTerminal:IsOpen()
		local panel = self:GetPanel();
		
		if (IsValid(panel) and panel:IsVisible()) then
			return true;
		end;
	end;

	Clockwork.datastream:Hook("cwVideoTerminalShow", function(data)
		Clockwork.videoTerminal.available = data;

		Clockwork.videoTerminal.panel = vgui.Create("cwVideoTerminal");
		Clockwork.videoTerminal.panel:Rebuild();
		Clockwork.videoTerminal.panel:MakePopup();
	end);
else

end;