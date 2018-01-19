--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]
local PLUGIN = PLUGIN;
local SCHEMA = SCHEMA;
local ciD


function PLUGIN:SaveTerminals()
	local terminals = {};
	
	for k, v in pairs(ents.FindByClass("cw_terminal")) do
		terminals[#terminals + 1] = {
			--type = v:GetSpawnType(),
			angles = v:GetAngles(),
			position = v:GetPos()
		};
	end;
	
	Clockwork.kernel:SaveSchemaData("plugins/Teriyakiterminals/"..game.GetMap(), terminals);
end;

function PLUGIN:LoadTerminals()
	local terminals = Clockwork.kernel:RestoreSchemaData( "plugins/Teriyakiterminals/"..game.GetMap() );
	
	for k, v in pairs(terminals) do
		local entity = ents.Create("cw_terminal");
		
		entity:SetPos(v.position);
		entity:Spawn();
		
		if (IsValid(entity)) then
			entity:SetAngles(v.angles);
			--entity:SetSpawnType(v.type);
		end;
	end;
end;

concommand.Add("reportplease", function(player)
	if (Schema:PlayerIsCombine(player)) then
	player:EmitSound("npc/overwatch/radiovoice/investigateandreport.wav")
end;
end)