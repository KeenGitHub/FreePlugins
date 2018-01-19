--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]

local PANEL = {};

function PANEL:Init()
	self:SetSize(math.min(ScrW() * 0.5, 500), ScrH() * 0.75);
	self:SetTitle("New Video Terminal");
	self.panelList = vgui.Create("cwPanelList", self);
 	self.panelList:SetPadding(2);
 	self.panelList:SetSpacing(3);
 	self.panelList:SizeToContents();
	self.panelList:EnableVerticalScrollbar();
	
	function self.btnClose.DoClick(button)
		CloseDermaMenus();
		self:Close(); self:Remove();
		
		Clockwork.terminalAdd.groups = false;
		gui.EnableScreenClicker(false);
	end;

	self.terminalForm = vgui.Create("DForm", self);
	self.terminalForm:SetPadding(4);
	self.terminalForm:SetName("Terminal");
	self.panelList:AddItem(self.terminalForm);

	self.terminalForm:Help("Choose available groups. Leave these unchecked to allow all groups.");

	self.groupsBoxes = {};

	for k, v in pairs(Clockwork.camera:GetGroupList()) do
		local access = "Factions or Classes";

		if (v.access == ACCESS_BY_NONE) then
			access = "All";
		elseif (v.access == ACCESS_BY_PASS) then
			access = "Password";
		end;

		self.groupsBoxes[k] = self.terminalForm:CheckBox(k..": "..v.name .." ("..access..")");
		self.groupsBoxes[k].OnChange = function(checkBox)
			if (checkBox:GetChecked()) then
				Clockwork.terminalAdd.groups[k] = true;
			else
				Clockwork.terminalAdd.groups[k] = nil;
			end;
		end;
			
		if (Clockwork.terminalAdd.groups[k]) then
			self.groupsBoxes[k]:SetValue(true);
		end;
	end;

	local addButton = vgui.Create("DButton", self);
	addButton:SetText("Add");
	if (Clockwork.newCamera.isEdit) then
		addButton:SetText("Edit");
	end;
	addButton:SetWide(self:GetParent():GetWide());
	function addButton.DoClick(button)

		Clockwork.datastream:Start("cwVideoTerminalAdd", Clockwork.terminalAdd.groups);
		Clockwork.terminalAdd:GetPanel():Close();
		Clockwork.terminalAdd:GetPanel():Remove();
		gui.EnableScreenClicker(false);
	end;
	
	self.terminalForm:AddItem(addButton);
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

vgui.Register("cwTerminalAdd", PANEL, "DFrame");