
--[[
	� Teriyaki
	Free plugins for Clockwork|CatWork|NutScript|Helix
	https://github.com/TeriyakiGitHub
--]]


include("shared.lua");

local glowMaterial = Material("sprites/glow04_noz");

-- Called when the entity should draw.
function ENT:Draw()
	self:DrawModel();

	local r, g, b, a = self:GetColor();
	local position = self:GetPos();
	local forward = self:GetForward() * 5;
	local curTime = CurTime();
	local right = self:GetRight() * -10;
	local up = self:GetUp() * 43
		

		local glowColor = Color(0, 255, 0, a);
		
		cam.Start3D( EyePos(), EyeAngles() );
			render.SetMaterial(glowMaterial);
			render.DrawSprite(position + forward + right + up, 20, 20, glowColor);
		cam.End3D();
			
end;

function ENT:Initialize()
	
end;

function ENT:Think()

end;

-- Basically the entire derma stuff of this plugin in a single function.  gg no re
function TerminalShow(activator)
for k, v in ipairs( ents.FindInSphere(activator:GetPos(),350) ) do
if v:IsValid() && v:GetClass() == "cw_terminal" then
print("[Network] CLIENT: Terminal in-range and activated.")

surface.CreateFont( "terminal", {
	font = "verdana",
	size = 15,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = false,
	additive = false,
	outline = false,
} )

local faction = activator:GetFaction();
local ciD
	
if LocalPlayer():GetSharedVar("citizenID") == "" then 
	ciD = "N/A" 
else ciD = LocalPlayer():GetSharedVar("citizenID") 
	end

	local frame = vgui.Create( "DFrame" )
	local button = vgui.Create( "DColorButton" )
	local pic = vgui.Create( "DModelPanel", frame )
	local fac = vgui.Create( "DLabel", frame )
	local gen = vgui.Create( "DLabel", frame )
	local citid = vgui.Create( "DLabel", frame )
	local buttwo = vgui.Create( "DColorButton", frame )
	local butf = vgui.Create( "DColorButton", frame )
	local butfo = vgui.Create( "DColorButton", frame )
	local assbutt = vgui.Create( "DColorButton", frame )
	frame:SetSize( 1050, 525 )
	frame:Center()
	frame:SetVisible( true )
	frame:SetTitle( "Network Interface" )
	frame:SetDraggable( false )
	frame:ShowCloseButton( false )
	frame:MakePopup()	
	function frame:Paint( w, h )
		local colour = Color( 79, 79, 79, 255)
		draw.RoundedBox( 0, 0, 0, w, h, colour )
		surface.SetDrawColor( 0, 0, 0 )
		surface.DrawOutlinedRect( 1, 1, w-2, h-2 )

		surface.SetFont( "terminal" )
        surface.SetTextColor( 255, 255, 255, 255 )
        surface.SetTextPos( 50, 50 )
        surface.DrawText( "You are logged in as: ".. activator:Name() )
	end

	pic:SetSize( 300, 350 )
	pic:SetPos( 25, 40 )
	pic:SetModel( activator:GetModel() )
	--function pic:LayoutEntity( Entity ) return end  -- Disables the turning animation.  Glitchy as tits.

	assbutt:SetPos( 700, 65 )
	assbutt:SetSize( 400, 65 )
	assbutt:Paint( 100, 30 )
	assbutt:SetText( "Call employee MpF " )
	assbutt:SetColor( Color( 0, 110, 160 ) )
	function assbutt:Paint( w, h )
		local colour = Color( 16, 78, 139, 255)
		draw.RoundedBox( 0, 0, 0, w, h, colour )
		surface.SetDrawColor( 0, 110, 160 )
		surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
	end
	assbutt.DoClick = function()
		Clockwork.datastream:Start("PlayerSay", "/request N/A.");
		activator:EmitSound("ambient/machines/keyboard_fast1_1second.wav") end

	buttwo:SetPos( 700, 145 )
	buttwo:SetSize( 400, 65 )
	buttwo:Paint( 100, 30 )
	buttwo:SetText( "information" )
	buttwo:SetColor( Color( 0, 110, 160 ) )
	function buttwo:Paint( w, h )
		local colour = Color( 16, 78, 139, 255)
		draw.RoundedBox( 0, 0, 0, w, h, colour )
		surface.SetDrawColor( 0, 110, 160 )
		surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
	end
	buttwo.DoClick = function()
		gui.OpenURL("http://hl2rp.wikia.com/wiki/HL2RP_Wiki")
		activator:EmitSound("ambient/machines/keyboard_fast2_1second.wav") end

	butf:SetPos( 700, 225 )
	butf:SetSize( 400, 65 )
	butf:Paint( 100, 30 )
	butf:SetText( "  Get the ID Card" )
	butf:SetColor( Color( 0, 110, 160 ) )
	function butf:Paint( w, h )
		local colour = Color( 16, 78, 139, 255)
		draw.RoundedBox( 0, 0, 0, w, h, colour )
		surface.SetDrawColor( 0, 110, 160 )
		surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
	end
	butf.DoClick = function()
		Clockwork.datastream:Start("PlayerSay", "/TerminalDispenseIDCard");
		activator:EmitSound("ambient/machines/combine_terminal_idle1.wav")
		activator:EmitSound("items/battery_pickup.wav")
	end

	butfo:SetPos( 700, 305 )
	butfo:SetSize( 400, 65 )
	butfo:Paint( 100, 30 )
	butfo:SetText( "  Get the Request Device" )
	butfo:SetColor( Color( 0, 110, 160 ) )
	function butfo:Paint( w, h )
		local colour = Color( 16, 78, 139, 255)
		draw.RoundedBox( 0, 0, 0, w, h, colour )
		surface.SetDrawColor( 0, 110, 160 )
		surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
	end
	butfo.DoClick = function()
		Clockwork.datastream:Start("PlayerSay", "/terminaldispenserequestdevice");
		activator:EmitSound("ambient/machines/combine_terminal_idle1.wav")
		activator:EmitSound("items/battery_pickup.wav") 
	end


	fac:SetPos( 35, 400 )
	fac:SetColor(Color(255,255,255,255))
	fac:SetFont("terminal")
	fac:SetText("Occupation: "..faction)
	fac:SizeToContents()

	gen:SetPos( 35, 420 )
	gen:SetColor(Color(255,255,255,255))
	gen:SetFont("terminal")
	gen:SetText("Gender: "..activator:GetGender())
	gen:SizeToContents()

	citid:SetPos( 35, 440 )
	citid:SetColor(Color(255,255,255,255))
	citid:SetFont("terminal")
	citid:SetText("ID: "..ciD)
	citid:SizeToContents()

	button:SetParent( frame )
	button:SetPos( 700, 405 )
	button:SetSize( 495, 50 )
	button:Paint( 100, 30 )
	button:SetColor( Color( 0, 110, 160 ) )
	button:SetText( "  Закрыть консоль" )
	function button:Paint( w, h )
		local colour = Color( 16, 78, 139, 255)
		draw.RoundedBox( 0, 0, 0, w, h, colour )
		surface.SetDrawColor( 0, 110, 160 )
		surface.DrawOutlinedRect( 1, 1, w-2, h-2 )
	end
	button.DoClick = function()
		frame:Close()
		activator:EmitSound("ambient/machines/combine_terminal_idle2.wav") 
	end


end
	end
end
	concommand.Add("terminalshow", TerminalShow )
