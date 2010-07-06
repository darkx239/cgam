PLUGIN.Name = "UTime"
PLUGIN.Category = "Games 'n Fun"
PLUGIN.Info = "Check long someone has been on!"
PLUGIN.Usage = "NA"

local function FindPlayer( target )

	players = {}

	if not target then
		return;
	end

	for _, v in ipairs( player.GetAll()) do 
		if string.find( string.lower( v:Nick() ), string.lower( target ) ) != nil then
			table.insert( players, v )
		end
	end

	if #players >1 then
		return nil
	elseif #players <1 then
		return nil
	elseif #players == 1 then
		return players[1]
	end
	
end

function PLUGIN.Init()

	local function OnChat( player , command , arguments )
		if !arguments or !arguments[1] then
			local miniutes = player:GetPData("TimeOnServer")
			
			if miniutes == nil then miniutes = 0 end
			
			local terminal = "s"
			
			if miniutes == 1 then terminal = "" end
			
			umsg.Start("CGAM.Plugins.UTIME", player)
			
				umsg.String( player:Nick() .. " Has been on the server for " .. miniutes .. " minute" .. terminal .. ".")
				
			umsg.End()
		else
		
			local pl = FindPlayer( arguments[1] )
			if pl then
				local miniutes = FindPlayer( arguments[1] ):GetPData("TimeOnServer")
				if miniutes == nil then miniutes = 0 end
				local terminal = "s"
				if miniutes == 1 then terminal = "" end
				umsg.Start("CGAM.Plugins.UTIME", pl)
					umsg.String( FindPlayer( arguments[1] ):Nick() .. " Has been on the server for " .. miniutes .. " minute" .. terminal .. "." )
				umsg.End()
			end
		end
	end

	function UpDateTime( pl )
		if pl:GetPData("TimeOnServer") == nil then
			pl:SetPData("TimeOnServer", 0)
			return false
		end
		pl:SetPData("TimeOnServer", pl:GetPData("TimeOnServer") + 1 )
	end
	
	hook.Add("PlayerInitialSpawn", "CGAM.Plugin.UTime", function( pl )
		timer.Create("CGAM.Plugin.UTime." .. pl:Nick(), 60,0, UpDateTime, pl )
	end)
	
	hook.Add( "PlayerSay", "CGAM.Plugin.Utime.Chat", function( pl, txt)
		if txt == "!utime" then
			OnChat(pl, nil, string.Explode( " ",string.gsub( txt, "!utime ", "")) )
		end
	end)
end

function PLUGIN.Shared()

end

function PLUGIN.Cl_init()

	usermessage.Hook("CGAM.Plugins.UTIME", function( um )
		local _Message = um:ReadString()
		if _Message then
			chat.AddText(
				Color(20,255,20), "( UTIME ) ",
				Color( 0,0,255) , "CGAM",
				Color(255,255,255), " : ",
				Color(255,255,255), _Message)
			chat.PlaySound()
		end
	end)

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
	
	local _TEXT = [[This is the UTime module made by Meisno, the creator of CGAM. You can use this 
	tool to administrate all of your players and those that are your friends. You can
	use plugins for almost anything you want.]]

	DLabel1 = vgui.Create('DLabel')
	DLabel1:SetParent(DPanel1)
	DLabel1:SetPos(5, 6)
	DLabel1:SetText(_TEXT)
	DLabel1:SizeToContents()
	DLabel1:SetTextColor(Color(0, 0, 0, 255))
end
