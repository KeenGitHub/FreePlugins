--[[
	© Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]


local COMMAND = Clockwork.command:FindByID("request")

-- Called when the command is run by the player.
function COMMAND:OnRun(player, arguments)
	local isCityAdmin = (player:GetFaction() == FACTION_ADMIN);
	local isCombine = Schema:PlayerIsCombine(player);
	local text = table.concat(arguments, " ");
	local ciD

	if player:GetSharedVar("citizenID") == "" then 
	ciD = " N/A" 
else ciD = player:GetSharedVar("citizenID") 
	end
	
	if (text == "") then
		Clockwork.player:Notify(player, "You did not specify enough text!");
		
		return;
	end;
	
	if (player:HasItemByID("request_device") or isCombine or isCityAdmin) then
		local curTime = CurTime();
		
		if (!player.nextRequestTime or isCityAdmin or isCombine or curTime >= player.nextRequestTime) then
			Schema:AddCombineDisplayLine( "Citizen: "..player:Name()..", #"..ciD..", requests protection team assistance to their location.  Reason: "..text, Color(218, 165, 32, 255) );
			BroadcastLua("LocalPlayer():ConCommand('reportplease')")
			player:EmitSound("HL1/fvox/beep.wav")
			Clockwork.chatBox:SendColored(player, Color(218, 165, 32, 255), "<:: Your request has been delivered, please wait for assistance to arrive.")
			
			if (!isCityAdmin and !isCombine) then
				player.nextRequestTime = curTime + 30;
			end;
		else
			Clockwork.player:Notify(player, "You cannot send another request for "..math.ceil(player.nextRequestTime - curTime).." more second(s)!");
		end;
	else
		Clockwork.player:Notify(player, "You do not currently own a request device!");
	end;
end;
