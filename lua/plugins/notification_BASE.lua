-- Hints : Made by meisno & garry.

PLUGIN.Name = "Notifications BASE"
PLUGIN.Category = "Core"
PLUGIN.Info = "base for notifications"
PLUGIN.Usage = "Use lua"

PLUGIN.BuildMenu = {}

function PLUGIN.Init()
	_HasLoadedNBase = true
end

function PLUGIN.Shared()
end

function PLUGIN.Cl_init()
	NOTIFY_GENERIC			= 0
	NOTIFY_ERROR			= 1
	NOTIFY_UNDO				= 2
	NOTIFY_HINT				= 3
	NOTIFY_CLEANUP			= 4

	local NoticeMaterial = {}
	NoticeMaterial[ NOTIFY_GENERIC ] 	= surface.GetTextureID( "vgui/notices/generic" )
	NoticeMaterial[ NOTIFY_ERROR ] 		= surface.GetTextureID( "vgui/notices/error" )
	NoticeMaterial[ NOTIFY_UNDO ] 		= surface.GetTextureID( "vgui/notices/undo" )
	NoticeMaterial[ NOTIFY_HINT ] 		= surface.GetTextureID( "vgui/notices/hint" )
	NoticeMaterial[ NOTIFY_CLEANUP ] 	= surface.GetTextureID( "vgui/notices/cleanup" )

	local HUDNote_c = 0
	local HUDNote_i = 1
	local HUDNotes = {}
	
	function CGAM:AddNotify( str, type, length )

		local tab = {}
		tab.text 	= str
		tab.recv 	= SysTime()
		tab.len 	= length
		tab.velx	= -5
		tab.vely	= 0
		tab.x		= ScrW() + 200
		tab.y		= ScrH()
		tab.a		= 255
		tab.type	= type
		
		table.insert( HUDNotes, tab )
		
		HUDNote_c = HUDNote_c + 1
		HUDNote_i = HUDNote_i + 1
		
	end


	local function DrawNotice( self, k, v, i )

		local H = ScrH() / 1024
		local x = v.x - 75 * H
		local y = v.y - 300 * H
		
		if ( !v.w ) then
		
			surface.SetFont( "GModNotify" )
			v.w, v.h = surface.GetTextSize( v.text )
		
		end
		
		local w = v.w
		local h = v.h
		
		w = w + 16
		h = h + 16

		draw.RoundedBox( 4, x - w - h + 8, y - 8, w + h, h, Color( 30, 30, 30, v.a * 0.4 ) )
		
		// Draw Icon
		
		surface.SetDrawColor( 255, 255, 255, v.a )
		surface.SetTexture( NoticeMaterial[ v.type ] )
		surface.DrawTexturedRect( x - w - h + 16, y - 4, h - 8, h - 8 ) 
		
		
		draw.SimpleText( v.text, "GModNotify", x+1, y+1, Color(0,0,0,v.a*0.8), TEXT_ALIGN_RIGHT )
		draw.SimpleText( v.text, "GModNotify", x-1, y-1, Color(0,0,0,v.a*0.5), TEXT_ALIGN_RIGHT )
		draw.SimpleText( v.text, "GModNotify", x+1, y-1, Color(0,0,0,v.a*0.6), TEXT_ALIGN_RIGHT )
		draw.SimpleText( v.text, "GModNotify", x-1, y+1, Color(0,0,0,v.a*0.6), TEXT_ALIGN_RIGHT )
		draw.SimpleText( v.text, "GModNotify", x, y, Color(255,255,255,v.a), TEXT_ALIGN_RIGHT )
		
		local ideal_y = ScrH() - (HUDNote_c - i) * (h + 4)
		local ideal_x = ScrW()
		
		local timeleft = v.len - (SysTime() - v.recv)
		
		// Cartoon style about to go thing
		if ( timeleft < 0.8  ) then
			ideal_x = ScrW() - 50
		end
		 
		// Gone!
		if ( timeleft < 0.5  ) then
		
			ideal_x = ScrW() + w * 2
		
		end
		
		local spd = RealFrameTime() * 15
		
		v.y = v.y + v.vely * spd
		v.x = v.x + v.velx * spd
		
		local dist = ideal_y - v.y
		v.vely = v.vely + dist * spd * 1
		if (math.abs(dist) < 2 && math.abs(v.vely) < 0.1) then v.vely = 0 end
		local dist = ideal_x - v.x
		v.velx = v.velx + dist * spd * 1
		if (math.abs(dist) < 2 && math.abs(v.velx) < 0.1) then v.velx = 0 end
		
		// Friction.. kind of FPS independant.
		v.velx = v.velx * (0.95 - RealFrameTime() * 8 )
		v.vely = v.vely * (0.95 - RealFrameTime() * 8 )

	end


	function PLUGIN:PaintNotes()

		if ( !HUDNotes ) then return end
			
		local i = 0
		for k, v in pairs( HUDNotes ) do
		
			if ( v != 0 ) then
			
				i = i + 1
				DrawNotice( self, k, v, i)		
			
			end
			
		end
		
		for k, v in pairs( HUDNotes ) do
		
			if ( v != 0 && v.recv + v.len < SysTime() ) then
			
				HUDNotes[ k ] = 0
				HUDNote_c = HUDNote_c - 1
				
				if (HUDNote_c == 0) then HUDNotes = {} end
			
			end

		end

	end
end

PLUGIN.BuildMenu["Send Notification"] = function()

	local DButton1
	local DTextEntry1
	local DMultiChoice1
	local DFrame1

	DFrame1 = vgui.Create('DFrame')
	DFrame1:SetSize(600, 64)
	DFrame1:Center()
	DFrame1:SetTitle('CGAM : Notification Base GUI')
	DFrame1:SetSizable(true)
	DFrame1:SetDeleteOnClose(false)
	DFrame1:MakePopup()

	DMultiChoice1 = vgui.Create('DMultiChoice')
	DMultiChoice1:SetParent(DFrame1)
	DMultiChoice1:SetPos(9, 31)
	DMultiChoice1.OnMousePressed = function() end
	function DMultiChoice1:OnSelect(Index, Value, Data) end

	DMultiChoice1:AddChoice('GENERIC')
	DMultiChoice1:AddChoice('ERROR')
	DMultiChoice1:AddChoice('UNDO')
	DMultiChoice1:AddChoice('HINT')
	DMultiChoice1:AddChoice('CLEANUP')
	
	local function SendNot( type, text )
		RunConsoleCommand( 'CGAM_Notification' , type, text )
	end


	DTextEntry1 = vgui.Create('DTextEntry')
	DTextEntry1:SetParent(DFrame1)
	DTextEntry1:SetSize(393, 24)
	DTextEntry1:SetPos(96, 31)
	DTextEntry1:SetText('')
	DTextEntry1.OnEnter = function()
		SendNot( DMultiChoice1:GetOptionText( 1 ) , DTextEntry1:GetValue() )
	end

	DButton1 = vgui.Create('DButton')
	DButton1:SetParent(DFrame1)
	DButton1:SetSize(97, 25)
	DButton1:SetPos(494, 30)
	DButton1:SetText('Send!')
	DButton1.DoClick = function()
		SendNot( DMultiChoice1:GetOptionText( 1 ) , DTextEntry1:GetValue() )
	end
	
end

if SERVER then

	concommand.Add("CGAM_Notification", function( pl, cmd, args )
		if pl:IsAdmin() then
			umsg.Start( 'CGAM_Notification1' )
				umsg.String( args[1] )
				umsg.String( args[2] )
			umsg.End()
		end
	end)
	
end

if CLIENT then

	usermessage.Hook( 'CGAM_Notification1', function( um )
		local type = _G[ 'NOTIFY_' .. um:ReadString() ]
		local text = um:ReadString()
		CGAM:AddNotify( text, type, 5 )
	end)
end