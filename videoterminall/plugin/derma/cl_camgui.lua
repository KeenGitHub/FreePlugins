--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]


local PANEL = {};

function PANEL:Init()
	local smallTextFont = Clockwork.option:GetFont("menu_text_small");
	local tinyTextFont = Clockwork.option:GetFont("menu_text_tiny");
	local hugeTextFont = Clockwork.option:GetFont("menu_text_huge");
	local scrH = ScrH();
	local scrW = ScrW();

	self:SetPos(0, 0);
	self:SetSize(scrW, scrH);
	self:SetDrawOnTop(false);
	self:SetPaintBackground(false);
	self:SetBackgroundColor(Clockwork.option:GetColor("background"));
	self:SetMouseInputEnabled(true);
	
	self.disconnectButton = vgui.Create("cwLabelButton", self);
	self.disconnectButton:SetFont(smallTextFont);
	self.disconnectButton:SetText("DISCONNECT");
	self.disconnectButton:SetCallback(function(panel)
		Clockwork.datastream:Start("cwCameraLeave",  true);
		Clockwork.camGUI.cameraID = false;
		Clockwork.camGUI.groupID = false;
		Clockwork.camGUI.panel:SetVisible(false)
		Clockwork.camGUI.panel = nil;
		gui.EnableScreenClicker(false);
	end);
	self.disconnectButton:SizeToContents();
	self.disconnectButton:SetPos((scrW * 0.4) - (self.disconnectButton:GetWide() / 2), scrH * 0.9);
	self.disconnectButton:SetMouseInputEnabled(true);

	self.disableButton = vgui.Create("cwLabelButton", self);
	self.disableButton:SetFont(smallTextFont);
	self.disableButton:SetText("TURN OFF");
	self.disableButton:SetCallback(function(panel)
		if (!self.lastClick or self.lastClick < CurTime()) then
			Clockwork.datastream:Start("cwCameraTurn",  true);
			self.lastClick = CurTime() + 2;
		end;
	end);
	self.disableButton:SizeToContents();
	self.disableButton:SetPos((scrW * 0.6) - (self.disableButton:GetWide() / 2), scrH * 0.9);
	self.disableButton:SetMouseInputEnabled(true);

	self.previousButton = vgui.Create("cwLabelButton", self);
	self.previousButton:SetFont(tinyTextFont);
	self.previousButton:SetText("< PREVIOUS");
	self.previousButton:SizeToContents();
	self.previousButton:SetMouseInputEnabled(true);
	self.previousButton:SetPos((scrW * 0.2) - (self.previousButton:GetWide() / 2), scrH * 0.9);
	self.previousButton:SetCallback(function(panel)
		Clockwork.datastream:Start("cwPreviousCamera", true);
	end);

	self.nextButton = vgui.Create("cwLabelButton", self);
	self.nextButton:SetFont(tinyTextFont);
	self.nextButton:SetText("NEXT >");
	self.nextButton:SizeToContents();
	self.nextButton:SetMouseInputEnabled(true);
	self.nextButton:SetPos((scrW * 0.8) - (self.nextButton:GetWide() / 2), scrH * 0.9);
	self.nextButton:SetCallback(function(panel)
		Clockwork.datastream:Start("cwNextCamera", true);
	end);
end;

function PANEL:Think()
	local scrH = ScrH();
	local scrW = ScrW();
	local data = Clockwork.camera:GetCamera(Clockwork.camGUI:GetCameraID());

	if (data and !data.enabled) then
		self:SetPaintBackground(true);
		self.disableButton:SetText("TURN ON");
	else
		self:SetPaintBackground(false);
		self.disableButton:SetText("TURN OFF");
	end;

	self.disableButton:SetPos((scrW * 0.6) - (self.disableButton:GetWide() / 2), scrH * 0.9);
end;

vgui.Register("cwCamGUI", PANEL, "DPanel");