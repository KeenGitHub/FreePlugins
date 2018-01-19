--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]

local Clockwork = Clockwork;

if (CLIENT) then
	local SYSTEM = Clockwork.system:New();
	SYSTEM.name = "Manage Cameras Groups";
	SYSTEM.toolTip = "Cameras Groups options.";
	SYSTEM.doesCreateForm = false;
	SYSTEM.buffer = {};
	SYSTEM.startPage = "main";
	SYSTEM.group = false;

	function SYSTEM:SetBuffer(id, value)
		self.buffer[id] = value;
	end;

	function SYSTEM:GetBuffer(id)
		return self.buffer[id];
	end;

	function SYSTEM:ClearBuffer()
		self.buffer = {};
	end;

	function SYSTEM:SetGroup(value)
		self.group = value;
	end;

	function SYSTEM:GetGroup()
		return self.group;
	end;

	function SYSTEM:SetPage(value)
		self.startPage = value;
	end;

	function SYSTEM:GetPage()
		return self.startPage;
	end;

	function SYSTEM:HasAccess()
		if (Clockwork.player:HasFlags(Clockwork.Client, "s")) then
			return true;
		end;
	end;

	function SYSTEM:OnDisplay(systemPanel, systemForm)
		if (self:GetPage() == "group") then
			local backButton = vgui.Create("DButton", systemPanel);
			backButton:SetText("Back to Group list");
			backButton:SetWide(systemPanel:GetParent():GetWide());
			function backButton.DoClick(button)
				self:ClearBuffer();
				self:SetPage("main");
				self:SetGroup(false);
				self:Rebuild();
			end;
			systemPanel.navigationForm:AddItem(backButton);

			self:DrawGroup(systemPanel, systemForm);	
		elseif (self:GetPage() == "camerasList") then
			local backButton = vgui.Create("DButton", systemPanel);
			backButton:SetText("Back to Group list");
			backButton:SetWide(systemPanel:GetParent():GetWide());
			function backButton.DoClick(button)
				self:ClearBuffer();
				self:SetPage("main");
				self:SetGroup(false);
				self:Rebuild();
			end;
			systemPanel.navigationForm:AddItem(backButton);

			self:DrawCamerasList(systemPanel, systemForm);	
		else
			self:DrawMainPage(systemPanel, systemForm);
		end;
	end;

	function SYSTEM:DrawMainPage(systemPanel, systemForm)
		local createGroupForm = vgui.Create("DForm", self);
			createGroupForm:SetPadding(4);
			createGroupForm:SetName("Manage Group");
		systemPanel.panelList:AddItem(createGroupForm);
		
		local createButton = vgui.Create("cwInfoText", systemPanel);
			createButton:SetButton(true);
			createButton:SetText("Create new group");
			createButton:SetInfoColor("green");
			createButton:SetToolTip("Click here to create new group.");
			createButton:SetShowIcon(false);

			function createButton.DoClick(button)
				self:SetPage("group");
				self:SetBuffer("access", ACCESS_BY_NONE);
				self:Rebuild();
			end;
		createGroupForm:AddItem(createButton);


		local mainGroupList = vgui.Create("DForm", self);
			mainGroupList:SetPadding(4);
			mainGroupList:SetName("Group list");
		systemPanel.panelList:AddItem(mainGroupList);

		mainGroupList:Help("You can control all groups here.");

		if (table.Count(Clockwork.camera:GetGroupList()) > 0) then
			for k,v in pairs(Clockwork.camera:GetGroupList()) do
				local groupCategoryForm = vgui.Create("DForm", self);
				groupCategoryForm:SetPadding(4);
				groupCategoryForm:SetName(k..": "..v.name);
				mainGroupList:AddItem(groupCategoryForm);

				local editButton = vgui.Create("cwInfoText", systemPanel);
				editButton:SetButton(true);
				editButton:SetText("Edit");
				editButton:SetInfoColor("green");
				editButton:SetToolTip("Click here to edit group.");
				editButton:SetShowIcon(false);
				function editButton.DoClick(button)
					Clockwork.datastream:Start("cwCameraGroupGetFullData", {id = k});
				end;
				groupCategoryForm:AddItem(editButton);

				local camerasButton = vgui.Create("cwInfoText", systemPanel);
				camerasButton:SetButton(true);
				camerasButton:SetText("Cameras");
				camerasButton:SetInfoColor("orange");
				camerasButton:SetToolTip("Click here to edit cameras.");
				camerasButton:SetShowIcon(false);
				function camerasButton.DoClick(button)
					self:SetGroup(k);
					self:SetPage("camerasList");
					self:Rebuild();
				end;
				groupCategoryForm:AddItem(camerasButton);

				local deleteButton = vgui.Create("cwInfoText", systemPanel);
				deleteButton:SetButton(true);
				deleteButton:SetText("Delete");
				deleteButton:SetInfoColor("red");
				deleteButton:SetToolTip("Click here to delete the group.");
				deleteButton:SetShowIcon(false);

				function deleteButton.DoClick(button)
					Derma_Query("Are you sure you want to remove this group?", " ", "Yes", function()
						Clockwork.datastream:Start("cwCameraGroupRemove", {
							id = k
						});
					end, "No", function() end);
				end;
				groupCategoryForm:AddItem(deleteButton);

			end;
		else
			local label = vgui.Create("cwInfoText", self);
				label:SetText("There is no groups.");
				label:SetInfoColor("red");
			mainGroupList:AddItem(label);
		end;
	end;

	function SYSTEM:DrawClassAccess(form)
		local accessForm = vgui.Create("DForm", self);
		accessForm:SetPadding(4);
		accessForm:SetName("Access");
		form:AddItem(accessForm);

		local factionsForm = vgui.Create("DForm");
		factionsForm:SetPadding(4);
		factionsForm:SetName("Factions");
		accessForm:AddItem(factionsForm);
		factionsForm:Help("Choose fraction which will have access to this group.");

		local classesForm = vgui.Create("DForm");
		classesForm:SetPadding(4);
		classesForm:SetName("Classes");
		accessForm:AddItem(classesForm);
		classesForm:Help("Choose class which will have access to this group.");

		self.classBoxes = {};
		self.factionBoxes = {};

		if (self:GetBuffer("accessData") and type(self:GetBuffer("accessData")) == "table") then
			self.accessClasses = self:GetBuffer("accessData")["classes"] or {};
			self.accessFactions = self:GetBuffer("accessData")["factions"] or {};
		else
			self.accessClasses = {};
			self.accessFactions = {};
		end;
		
		for k, v in pairs(Clockwork.faction.stored) do
			self.factionBoxes[k] = factionsForm:CheckBox(v.name);
			self.factionBoxes[k].OnChange = function(checkBox)
				if (checkBox:GetChecked()) then
					self.accessFactions[k] = true;
				else
					self.accessFactions[k] = nil;
				end;
			end;
			
			if (self.accessFactions[k]) then
				self.factionBoxes[k]:SetValue(true);
			end;
		end;
		
		for k, v in pairs(Clockwork.class.stored) do
			self.classBoxes[k] = classesForm:CheckBox(v.name);
			self.classBoxes[k].OnChange = function(checkBox)
				if (checkBox:GetChecked()) then
					self.accessClasses[k] = true;
				else
					self.accessClasses[k] = nil;
				end;
			end;
			
			if (self.accessClasses[k]) then
				self.classBoxes[k]:SetValue(true);
			end;
		end;
	end;

	function SYSTEM:DrawPassAccess(form)
		accessForm = vgui.Create("DForm", self);
			accessForm:SetPadding(4);
			accessForm:SetName("Access");
		form:AddItem(accessForm);

		self.passwordEntry = accessForm:TextEntry("Password:");

		if (self:GetBuffer("accessData") and type(self:GetBuffer("accessData")) == "string") then
			self.passwordEntry:SetValue(self:GetBuffer("accessData"));
		end;
	end;

	function SYSTEM:DrawGroup(systemPanel, systemForm)
		local groupEditCategoryForm = vgui.Create("DForm", self);
		groupEditCategoryForm:SetPadding(4);
		groupEditCategoryForm:SetName("Group");
		systemPanel.panelList:AddItem(groupEditCategoryForm);

		if (!self:GetGroup()) then
			self.idEntry = groupEditCategoryForm:TextEntry("ID:");
			self.idEntry:SetValue(self:GetBuffer("id") or "")
		else
			groupEditCategoryForm:SetName("Group. ID: "..self:GetGroup());
		end;

		self.nameEntry = groupEditCategoryForm:TextEntry("Name:");
		self.nameEntry:SetValue(self:GetBuffer("name") or "New Group");

		self.accessBox = groupEditCategoryForm:ComboBox("Select access:");
		self.accessBox:AddChoice("All",ACCESS_BY_NONE);
		self.accessBox:AddChoice("Password",ACCESS_BY_PASS);
		self.accessBox:AddChoice("Factions or Classes",ACCESS_BY_CLASS);
		self.accessBox.OnSelect = function( panel, index, value, data )
			self:SetBuffer("access", data);
			if (self.idEntry) then self:SetBuffer("id",self.idEntry:GetValue()); end;
			self:SetBuffer("name",self.nameEntry:GetValue());
			self:Rebuild();
		end;

		if (self:GetBuffer("access") == ACCESS_BY_NONE) then
			self:SetBuffer("accessValue", "All");
		elseif (self:GetBuffer("access") == ACCESS_BY_PASS) then
			self:SetBuffer("accessValue", "Password");
		else
			self:SetBuffer("accessValue", "Factions or Classes");
		end;

		self.accessBox:SetValue(self:GetBuffer("accessValue"));

		if (self:GetBuffer("access") == ACCESS_BY_PASS) then
			self:DrawPassAccess(groupEditCategoryForm)
		elseif (self:GetBuffer("access") == ACCESS_BY_CLASS) then
			self:DrawClassAccess(groupEditCategoryForm);
		end;

		local closeButton = vgui.Create("DButton", systemPanel);
		closeButton:SetWide(systemPanel:GetParent():GetWide());
		if (self:GetGroup()) then closeButton:SetText("Edit"); else closeButton:SetText("Create"); end;

		function closeButton.DoClick(button)
			local data = {
				name = self.nameEntry:GetValue();
				access = self:GetBuffer("access");
			}
	
			if (!self:GetGroup()) then	
				if (self.idEntry:GetValue() == "") then
					Clockwork.kernel:AddCinematicText("ID field is clear!", Color(255, 255, 255, 255), 32, 6, Clockwork.option:GetFont("menu_text_tiny"), true);

					return;
				end;

				if (Clockwork.camera:GetGroup(self.idEntry:GetValue())) then
					Clockwork.kernel:AddCinematicText("Group already exist!", Color(255, 255, 255, 255), 32, 6, Clockwork.option:GetFont("menu_text_tiny"), true);

					return;
				end;

				data.id = self.idEntry:GetValue();
			else
				data.id = self:GetGroup();
			end;

			if (self:GetBuffer("access") == ACCESS_BY_PASS) then
				if (self.passwordEntry and self.passwordEntry:GetValue() != "") then
					data.accessData = self.passwordEntry:GetValue();
				else
					Clockwork.kernel:AddCinematicText("Password field is clear!", Color(255, 255, 255, 255), 32, 6, Clockwork.option:GetFont("menu_text_tiny"), true);

					return;
				end;
			elseif (self:GetBuffer("access") == ACCESS_BY_CLASS) then
				data.accessData = {
					factions = self.accessFactions,
					classes = self.accessClasses
				};
			else
				data.accessData = false;
			end;

			self:ClearBuffer();
			self:SetPage("main");
			self:SetGroup(false);
			Clockwork.datastream:Start("cwCameraGroupEdit", data);
		end;
		
		groupEditCategoryForm:AddItem(closeButton);
	end;

	function SYSTEM:DrawCamerasList(systemPanel, systemForm)
		local addNewCameraForm = vgui.Create("DForm", self);
		addNewCameraForm:SetPadding(4);
		addNewCameraForm:SetName("Add new camera");
		systemPanel.panelList:AddItem(addNewCameraForm);

		self.cameraSelector = addNewCameraForm:ComboBox("Camera:");
		self.cameraSelector:SetValue("Select");
		self.cameraSelector.OnSelect = function( panel, index, value, data )
			self:SetBuffer("newCamera",data);
		end;

		local backButton = vgui.Create("DButton", systemPanel);
		backButton:SetText("Add");
		backButton:SetWide(systemPanel:GetParent():GetWide());
		function backButton.DoClick(button)
			if (self:GetGroup() and self:GetBuffer("newCamera")) then
				Clockwork.datastream:Start("cwCameraAddInGroup", {
					groupID = self:GetGroup(),
					cameraID =self:GetBuffer("newCamera")
				});
			else
				Clockwork.kernel:AddCinematicText("You haven't chose camera!", Color(255, 255, 255, 255), 32, 6, Clockwork.option:GetFont("menu_text_tiny"), true);

				return;
			end;

			self:SetBuffer("newCamera", false);
		end;
		addNewCameraForm:AddItem(backButton);

		local camerasListForm = vgui.Create("DForm", self);
		camerasListForm:SetPadding(4);
		camerasListForm:SetName(Clockwork.camera:GetGroup(self:GetGroup()).name .. " cameras");
		systemPanel.panelList:AddItem(camerasListForm);

		local group = Clockwork.camera:GetGroup(self:GetGroup());
		local ids = {};

		if (group) then
			if (#group.cameras > 0) then
				for k, v in pairs(group.cameras) do
					local cameraButton = vgui.Create("cwInfoText", systemPanel);
					cameraButton:SetButton(true);
					cameraButton:SetText(v.id..": "..v.name);
					cameraButton:SetInfoColor("green");
					cameraButton:SetToolTip("Click here to open menu.");
					cameraButton:SetShowIcon(false);
					function cameraButton.DoClick(button)
						local options = {};
						
						options["Remove"] = function()
							Derma_Query("Are you sure you want to remove this camera from group?", " ", "Yes", function()
								Clockwork.datastream:Start("cwCameraRemoveFromGroup", { cameraID = v.id, groupID = self:GetGroup()});
							end, "No", function() end);
						end;

						options["Connect"] = function()
							Clockwork.datastream:Start("cwCameraFastConnect", { cameraID = v.id, groupID = self:GetGroup()});
						end;

						Clockwork.kernel:AddMenuFromData(nil, options);
					end;
					camerasListForm:AddItem(cameraButton);

					table.insert(ids,v.id);
				end;
			else
				local label = vgui.Create("cwInfoText", self);
				label:SetText("There is no cams.");
				label:SetInfoColor("red");
				camerasListForm:AddItem(label);
			end;
		end;

		for k,v in pairs(Clockwork.camera:GetCamerasList()) do
			if (!table.HasValue(ids, k)) then
				self.cameraSelector:AddChoice(k..": " ..v.name,k);
			end;
		end;
	end;

	SYSTEM:Register();

	Clockwork.datastream:Hook("cwGroupManageRefresh", function(data)
		local systemTable = Clockwork.system:FindByID("Manage Cameras Groups");
		
		if (systemTable and systemTable:IsActive()) then
			systemTable:Rebuild();
		end;
	end);

	Clockwork.datastream:Hook("cwCameraGroupGetFullData", function(data)
		local systemTable = Clockwork.system:FindByID("Manage Cameras Groups");
		
		if (systemTable and systemTable:IsActive()) then
			systemTable:SetPage("group");
			systemTable:SetGroup(data.id);
			systemTable:SetBuffer("id", data.id);
			systemTable:SetBuffer("name", data.name);
			systemTable:SetBuffer("access", data.access);
			systemTable:SetBuffer("accessData", data.accessData);
			systemTable:Rebuild();
		end;
	end);
else
	Clockwork.datastream:Hook("cwCameraGroupEdit", function(player, data)
		if (Clockwork.player:HasFlags(player, "s")) then
			local group = Clockwork.camera:GetGroup(data.id)

			if (!group) then
				Clockwork.camera:AddGroup(data.id, data.name, data.access, data.accessData);
			else
				group.name = data.name;
				group.access = data.access;
				group.accessData = data.accessData;
			end;

			Clockwork.camera:UpdateGroupData();
			cwVideoterminal:SaveCamerasGroups();
			Clockwork.datastream:Start(player,"cwGroupManageRefresh", true);
		end;
	end);

	Clockwork.datastream:Hook("cwCameraGroupRemove", function(player, data)
		if (Clockwork.player:HasFlags(player, "s")) then
			Clockwork.camera:RemoveGroup(data.id);
			Clockwork.camera:UpdateGroupData();
			cwVideoterminal:SaveCamerasGroups();
			Clockwork.datastream:Start(player,"cwGroupManageRefresh", true);
		end;
	end);

	Clockwork.datastream:Hook("cwCameraAddInGroup", function(player, data)
		if (Clockwork.player:HasFlags(player, "s")) then
			
			Clockwork.camera:AddCameraInGroup(data.groupID, data.cameraID)
			Clockwork.camera:UpdateGroupData();
			cwVideoterminal:SaveCamerasGroups();
			Clockwork.datastream:Start(player,"cwGroupManageRefresh", true);
		end;
	end);

	Clockwork.datastream:Hook("cwCameraRemoveFromGroup", function(player, data)
		if (Clockwork.player:HasFlags(player, "s")) then
			local group = Clockwork.camera:GetGroup(data.groupID);

			if (group) then
				for k,v in pairs(group.cameras) do
					if (v.id == data.cameraID) then
						Clockwork.camera:GetGroup(data.groupID).cameras[k] = nil;
					end;
				end;

				Clockwork.camera:UpdateGroupData();
				cwVideoterminal:SaveCamerasGroups();
			end;

			Clockwork.datastream:Start(player,"cwGroupManageRefresh", true);
		end;
	end);

	Clockwork.datastream:Hook("cwCameraGroupGetFullData", function(player, data)
		if (Clockwork.player:HasFlags(player, "s")) then
			local group = Clockwork.camera:GetGroup(data.id);

			if (group) then
				local fullData = {
					id = data.id,
					name = group.name,
					access = group.access,
					accessData = group.accessData,
				};

				cwVideoterminal:SaveCamerasGroups();
				Clockwork.datastream:Start(player,"cwCameraGroupGetFullData", fullData);
			end;
		end;
	end);
end;