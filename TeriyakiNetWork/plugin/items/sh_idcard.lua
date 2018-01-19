--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]


local ITEM = Clockwork.item:New();
ITEM.name = "Identification Card";
ITEM.model = "models/gibs/metal_gib4.mdl";
ITEM.weight = 0.1;
ITEM.uniqueID = "idcard"
ITEM.useText = "Assign";
ITEM.business = false;
ITEM.description = "Status: Un-Assigned";
ITEM:AddData("description", "Status: Un-Assigned", true);
ITEM:AddQueryProxy("description", "description");
ITEM:AddData("name", "Identification Card", true);
ITEM:AddQueryProxy("name", "name");

-- Called when a player uses the item.
function ITEM:OnUse(player, itemEntity)
	if (self:GetData("description") == "Status: Un-Assigned") then
		local ciD = player:GetSharedVar("citizenID");
		
		if (ciD) then
			self:SetData("name", "Identification Card: "..player:Name()..", #"..ciD);
			self:SetData("description", "Status: Assigned to: "..player:Name()..", #"..ciD..".");
		else
			player:Notify("You don't have a CID number!");
		end;
	else
		player:Notify("This CID card is already registered to another person!");
	end;

	return false;
end;

-- Called when a player drops the item.
function ITEM:OnDrop(player, position) 
	end;

ITEM:Register();