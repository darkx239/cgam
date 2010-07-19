PLUGIN.Name = "MOTD"
PLUGIN.Category = "Core"
PLUGIN.Info = "Opens an motd on spawn"
PLUGIN.Usage = "N/A"

PLUGIN.url = "http://www.google.com/"

-- Optimise

local hook = hook
local timer = timer
local concommand = concommand
local vgui = vgui
local file = file
local ScrW = ScrW
local ScrH = ScrH

-- End

PLUGIN.BuildMenu = {}

function PLUGIN.Init()
	hook.Add( "PlayerInitialSpawn", "SMOTD.Open" , function( pl )
		timer.Simple( 0.1 , function() pl:ConCommand( "SimpleMOTD_Open" ) end)
	end)
end

function PLUGIN.Shared()
end

function PLUGIN.Cl_init()

	concommand.Add( "SimpleMOTD_Open", function()
		local CloseButton
		local HTML
		local MOTD

		MOTD = vgui.Create('DFrame')
		MOTD:SetSize(ScrW() * 0.961, ScrH() * 0.961)
		MOTD:SetPos(ScrW() * 0.02, ScrH() * 0.014)
		MOTD:SetTitle('Simple MOTD')
		MOTD:ShowCloseButton(false)
		MOTD:SetBackgroundBlur(true)
		function MOTD:Paint()
			draw.RoundedBoxEx( 8, 0, 0, MOTD:GetWide(), 22, Color( 0, 0, 0, 200 ), true, true, false, false )
			draw.RoundedBoxEx( 8, 0, 22, MOTD:GetWide(), MOTD:GetTall() - 22, Color( 0, 0, 0, 150 ), false, false, true, true )
		end
		MOTD:MakePopup()

		HTML = vgui.Create('HTML')
		HTML:SetParent(MOTD)
		HTML:SetSize(ScrW() * 0.937, ScrH() * 0.822)
		HTML:SetPos(ScrW() * 0.01, ScrH() * 0.042)
		HTML:SetHTML( file.Read( 'SMOTD.txt' ) )
		//HTML:OpenURL( PLUGIN.url )
		HTML:StartAnimate( 100 )

		CloseButton = vgui.Create('DButton')
		CloseButton:SetParent(MOTD)
		CloseButton:SetSize(ScrW() * 0.178, ScrH() * 0.07)
		CloseButton:SetPos(ScrW() * 0.385, ScrH() * 0.877)
		CloseButton:SetText('Close')
		CloseButton.DoClick = function()
			MOTD:Close()
		end
		
	end)

end
