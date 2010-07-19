// SH_PluginsUI

require("datastream")

PLUGIN.Name = "Plugin UI"
PLUGIN.Category = "Administration"
PLUGIN.Info = "Use to Administrate Plugins"
PLUGIN.Usage = "NA"



function PLUGIN.Init()

	AddCSLuaFile("autorun/SH_PluginsUI.lua")

	concommand.Add("CGAM_Plugins_UI", function( pl, cmd, args)
		umsg.Start("CGAM_Plugins_UI", pl )
		umsg.End()
		for k,v in pairs( CGAM.Plugins ) do
			datastream.StreamToClients( pl, "CGAM_Plugins_UI_DATASTREAM", { k , v["Name"],v["Category"], v["Info"] , v["Usage"] } );
		end
	end)
	
end

function PLUGIN.Cl_init()

	usermessage.Hook( "CGAM_Plugins_UI" , function( um )
	
		local TableOfPlugins = { }
		
		local DermaPanel = vgui.Create( "DFrame" )
		DermaPanel:SetSize( 1000, 700 )
		DermaPanel:SetTitle( "CGAM : Plugins UI" )
		DermaPanel:SetVisible( true )
		DermaPanel:SetDraggable( false )
		DermaPanel:ShowCloseButton( true )
		DermaPanel:MakePopup()
		DermaPanel:Center()
		 
		local DermaListView = vgui.Create("DListView")
		DermaListView:SetParent(DermaPanel)
		DermaListView:SetPos(5, 27)
		DermaListView:SetSize(990, 625)
		DermaListView:SetMultiSelect(false)
		DermaListView:AddColumn("Name")
		DermaListView:AddColumn("Category")
		DermaListView:AddColumn("Information")
		DermaListView:AddColumn("Usage")
		DermaListView.OnClickLine = function( parent, line )
			local Menu = DermaMenu()
			local name = line:GetValue(1)
			local PlugTab = CGAM.Plugins[name]
			if PlugTab["OnInfo"] then
				Menu:AddOption( "Info", function()
					PlugTab["OnInfo"]()
				end)
			end
			if PlugTab["BuildMenu"] then
				for k,v in pairs( PlugTab["BuildMenu"] ) do
					Menu:AddOption( k , v )
				end
			end
			Menu:AddOption( "Reload", RunConsoleCommand( "CGAM_ReloadSinglePlugin" , PlugTab["File"] ) )
			Menu:AddOption( "Close", Menu:Hide() )
			Menu:Open()
		end
		
		local button = vgui.Create( "DButton", DermaPanel )
		button:SetSize( 100, 30 )
		button:SetPos( 450, 700 - 15 - (45 / 2)  )
		button:SetText( "Reload Plugins" )
		button.DoClick = function()
			if LocalPlayer():IsAdmin() then
				LocalPlayer():ConCommand("CGAM_ReloadPlugins")
			end
		end

		
		datastream.Hook( "CGAM_Plugins_UI_DATASTREAM", function( handler, id, encoded, decoded )
			
			DermaListView:AddLine(decoded[2],decoded[3],decoded[4],decoded[5])
			
		end)
		
	end)

end

function PLUGIN.Shared()

end

function PLUGIN.BuildMenu.Print()
	print( "Oh Lol, the print button worked" )
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
	
	local _TEXT = [[This is the Plugin UI made by Meisno, the creator of CGAM. You can use this tool
	to administrate all of your plugins and those that others have made. You can
	use plugins for almost anything you want.]]

	DLabel1 = vgui.Create('DLabel')
	DLabel1:SetParent(DPanel1)
	DLabel1:SetPos(5, 6)
	DLabel1:SetText(_TEXT)
	DLabel1:SizeToContents()
	DLabel1:SetTextColor(Color(0, 0, 0, 255))
end
