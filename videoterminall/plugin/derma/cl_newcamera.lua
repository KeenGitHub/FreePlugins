--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]



local PANEL = {};

function PANEL:Init()
	self:SetSize(math.min(ScrW() * 0.5, 500), ScrH() * 0.75);
	self:SetTitle("Camera");
	self.panelList = vgui.Create("cwPanelList", self);
 	self.panelList:SetPadding(2);
 	self.panelList:SetSpacing(3);
 	self.panelList:SizeToContents();
	self.panelList:EnableVerticalScrollbar();

	if (Clockwork.newCamera.name) then
		self:SetTitle("Camera: "..Clockwork.newCamera.name);
	end;
	
	function self.btnClose.DoClick(button)
		CloseDermaMenus();
		self:Close(); self:Remove();
		
		gui.EnableScreenClicker(false);
	end;

	self.cameraForm = vgui.Create("DForm", self);
	self.cameraForm:SetPadding(4);
	self.cameraForm:SetName("Camera");
	self.panelList:AddItem(self.cameraForm);
	
	if (!Clockwork.newCamera:GetID()) then
		self.cameraID = self.cameraForm:TextEntry("ID:");
	end;
	self.cameraName = self.cameraForm:TextEntry("Name:");
	self.cameraEnabled = self.cameraForm:CheckBox("Turned On?");

	self.cameraName:SetValue(Clockwork.newCamera.name or "New Camera")
	self.cameraEnabled:SetValue(Clockwork.newCamera.enabled == true);

	local addButton = vgui.Create("DButton", self);
	addButton:SetText("Add");
	if (Clockwork.newCamera:GetID()) then
		addButton:SetText("Edit");
	end;

	addButton:SetWide(self:GetParent():GetWide());
	function addButton.DoClick(button)
		local id = Clockwork.newCamera:GetID();
		if (!Clockwork.newCamera:GetID() and self.cameraID:GetValue() == "") then
			Clockwork.kernel:AddCinematicText("ID field is clear!", Color(255, 255, 255, 255), 32, 6, Clockwork.option:GetFont("menu_text_tiny"), true);
			
			return;
		elseif(!Clockwork.newCamera:GetID()) then
			if (Clockwork.camera:GetCamera(self.cameraID:GetValue())) then
				Clockwork.kernel:AddCinematicText("Camera already exist!", Color(255, 255, 255, 255), 32, 6, Clockwork.option:GetFont("menu_text_tiny"), true);

				return;
			end;

			id = Clockwork.newCamera.panel.cameraID:GetValue()
		end;

		Clockwork.datastream:Start("cwVideoCameraAdd", {
			id = id,
			name = Clockwork.newCamera.panel.cameraName:GetValue(),
			enabled = Clockwork.newCamera.panel.cameraEnabled:GetChecked()
		});

		CloseDermaMenus();
		Clockwork.newCamera:GetPanel():Close();
		Clockwork.newCamera:GetPanel():Remove();
		gui.EnableScreenClicker(false);
	end;
	
	self.cameraForm:AddItem(addButton);
end;

function PANEL:Rebuild()

end;

function PANEL:Think()
	self:SetSize( self:GetWide(), math.min(self.panelList.pnlCanvas:GetTall() + 32, ScrH() * 0.75) );
	self:SetPos((ScrW() / 2) - (self:GetWide() / 2), (ScrH() / 2) - (self:GetTall() / 2));
end;

function PANEL:PerformLayout(w, h)
	DFrame.PerformLayout(self);
	self.panelList:StretchToParent(4, 28, 4, 4);
	
	derma.SkinHook("Layout", "Frame", self);
end;

vgui.Register("cwNewCamera", PANEL, "DFrame");