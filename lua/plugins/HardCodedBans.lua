//

PLUGIN.Name = "HardCoded Bans"
PLUGIN.Category = "Administration"
PLUGIN.Info = "Free your server from minges"
PLUGIN.Usage = "NA"

function PLUGIN.Init()

	local players = { }
	players[1] = { ID = "STEAM_0:1:28709748" , Reason = "N00B" }

	local function HardBans( ply )
		for i , tab in pairs( players ) do
			if tab["ID"] == ply:SteamID() then
				ply:Ban( 0, "Hard Coded Bans : " .. tab["Reason"] )
			end
		end
	end

	hook.Add( "PlayerInitialSpawn", "hardcodedbans" ,function( ply )
		timer.Create( "hardbans", 1, 1 , HardBans, ply)
	end)

end

function PLUGIN.Shared()

end

function PLUGIN.Cl_init()

end

function PLUGIN.OnInfo()

	local DLabel1
	local DPanel1
	local DFrame1

	DFrame1 = vgui.Create('DFrame')
	DFrame1:SetSize(416, 112)
	DFrame1:Center()
	DFrame1:SetTitle('Info')
	DFrame1:SetSizable(true)
	DFrame1:SetDeleteOnClose(false)
	DFrame1:MakePopup()

	DPanel1 = vgui.Create('DPanel')
	DPanel1:SetParent(DFrame1)
	DPanel1:SetSize(412, 86)
	DPanel1:SetPos(2, 24)
	
	local _TEXT = [[This is the HardCoded Bans made by Meisno, the creator of CGAM. You can use this 
	tool to administrate all of your players and those that are your friends. You can
	use plugins for almost anything you want.]]

	DLabel1 = vgui.Create('DLabel')
	DLabel1:SetParent(DPanel1)
	DLabel1:SetPos(5, 6)
	DLabel1:SetText(_TEXT)
	DLabel1:SizeToContents()
	DLabel1:SetTextColor(Color(0, 0, 0, 255))
end
