--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]


local PANEL = {};

function PANEL:Init()
	self:SetSize(math.min(ScrW() * 0.3, 300), ScrH() * 0.75);
	self:SetTitle("Video Terminal");
	self.panelList = vgui.Create("cwPanelList", self);
 	self.panelList:SetPadding(2);
 	self.panelList:SizeToContents();
	self.panelList:EnableVerticalScrollbar();
	
	function self.btnClose.DoClick(button)
		CloseDermaMenus();
		self:Close(); self:Remove();
		
		Clockwork.videoTerminal.available = false;
		gui.EnableScreenClicker(false);
	end;

	self.groupsForm = vgui.Create("DForm", self);
	self.groupsForm:SetPadding(4);
	self.groupsForm:SetName("Video Terminal");
	self.panelList:AddItem(self.groupsForm);
	local inc = 0;
	if (table.Count(Clockwork.videoTerminal.available) != 0) then
		for k,v in pairs(Clockwork.videoTerminal.available) do
			local group = Clockwork.camera:GetGroup(v);

			if (group) then
				inc = inc + 1;

				local groupForm = vgui.Create("DForm", self);
				groupForm:SetPadding(4);
				groupForm:SetName(inc..") "..group.name);

				for k2, v2 in pairs(group.cameras) do
					local cameraButton = vgui.Create("cwInfoText", systemPanel);
					cameraButton:SetButton(true);
					cameraButton:SetText(v2.name);
					cameraButton:SetInfoColor("green");
					cameraButton:SetToolTip("Click here to connect.");
					cameraButton:SetShowIcon(false);
					function cameraButton.DoClick(button)
						if (group.access != ACCESS_BY_PASS) then
							Clockwork.datastream:Start("cwCameraConnect", {
								cameraID = v2.id,
								groupID = v,
								password = false
							});
						else
							Derma_StringRequest(group.name..": "..v2.name, "Enter the password:", "", function(text)
								Clockwork.datastream:Start("cwCameraConnect", {
									cameraID = v2.id,
									groupID = v,
									password = text
								});
							end);
						end;

						CloseDermaMenus();
						Clockwork.videoTerminal:GetPanel():Close();
						Clockwork.videoTerminal:GetPanel():Remove();
						Clockwork.videoTerminal.available = false;
						gui.EnableScreenClicker(false);
					end;
					groupForm:AddItem(cameraButton);
				end;

				self.groupsForm:AddItem(groupForm);
			end;
		end;

	else
		local label = vgui.Create("cwInfoText", self);
		label:SetText("There is no available cameras.");
		label:SetInfoColor("red");
		self.groupsForm:AddItem(label);
	end;
end;

function PANEL:Rebuild() end;

function PANEL:Think()
	self:SetSize( self:GetWide(), math.min(self.panelList.pnlCanvas:GetTall() + 32, ScrH() * 0.75) );
	self:SetPos((ScrW() / 2) - (self:GetWide() / 2), (ScrH() / 2) - (self:GetTall() / 2));
end;

function PANEL:PerformLayout(w, h)
	DFrame.PerformLayout(self);
	self.panelList:StretchToParent(4, 28, 4, 4);
	
	derma.SkinHook("Layout", "Frame", self);
end;

vgui.Register("cwVideoTerminal", PANEL, "DFrame");