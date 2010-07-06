

if !_G['CGAM'] then _G['CGAM'] = { } end

if SERVER then

	AddCSLuaFile( "autorun/sh_AdminMod.lua" )
	AddCSLuaFile( "autorun/Resources.lua" )

	//
	// Set Up Enumerations
	//
	
	CGAM_Warning = 1
	CGAM_Slay = 2
	CGAM_Custom = 3
	CGAM_Advert = 4
	CGAM_News = 5

	local function FindPlayer( target )

		players = {}

		if not target then
			return;
		end

		for _, v in ipairs( player.GetAll()) do
			if string.Trim( v:Nick() ) == string.Trim( target ) then
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

	local function SendOptics( pl, Type, message )
	
		umsg.Start( 'CGAM.ReceiveOptics', pl )
			umsg.String( Type )
			umsg.String( message )
		umsg.End()
	
	end
	
	CGAM.SendOptics = SendOptics
	
	concommand.Add( "CGAM_SendNews", function( pl, cmd, args)
		local Name = args[2]
		local item = args[1]
		local person = FindPlayer( Name )
		if pl:IsAdmin() then
			if person then
				umsg.Start( 'CGAM.ReceiveOptics', person )
					umsg.String( 'News' )
					umsg.String( item )
				umsg.End()
			end
		end
	end)
	
	local function Goding( pl,cmd,args )
		local Name = args[1]
		local person = FindPlayer( Name )
		if person then
			if pl:IsAdmin() then
				if cmd == "CGAM_UnGod" then
					person:GodDisable()
				elseif cmd == "CGAM_God" then
					person:GodEnable()
				end
			end
		end
	end
	
	concommand.Add("CGAM_UnGod", Goding )
	concommand.Add("CGAM_God", Goding )
	
	concommand.Add( "CGAM_Lua", function( pl, cmd, args)
		local lua = args[1]
		if pl:IsAdmin() then
			RunString( lua )
		end
	end)
	
	concommand.Add( "CGAM_Cexec", function( pl, cmd, args)
		local Name = args[1]
		local command = args[2]
		if pl:IsAdmin() then
			local ply = FindPlayer( Name )
			if ply then
				ply:ConCommand( command )
			end
		end
	end)

	local function Warn( ply , message )
	
		local pl = FindPlayer( ply )
	
		if pl then
	
			if not pl.Warns then pl.Warns = 0 end

			pl.Warns = pl.Warns + 1

			SendOptics( pl , 'Warn' , message )
			
			if pl.Warns == 3 then
			
				pl:Kick( "CGAM : You got warned 3 times." )
			
			end
			

		end
		
	end
	
	CGAM.Warn = Warn
	
	concommand.Add("CGAM_Warn", function( pl , cmd, args )
		local Plid = args[1]
		local message = args[2]

		if pl:IsAdmin() then

			Warn( Plid , message )

		end

	end)
	
	local function Slay( ply )
	
		local pl = FindPlayer( ply )
	
		if pl then
	
			pl:Kill()
			SendOptics( pl, 'Slay', "You got slayed by an admin." )
			
		end
		
	end
	
	CGAM.Slay = Slay
	
	concommand.Add("CGAM_Slay", function( pl , cmd, args )
		local Plid = args[1]

		if pl:IsAdmin() then

			Slay( Plid )

		end

	end)
	
	local function Kick( ply, message )
	
		local pl = FindPlayer( ply )
	
		if pl then
		
			if message == '< Optional >' then

				pl:Kick( 'Old and useless' )

			else

				pl:Kick( message )

			end
		
		end

	end
	
	CGAM.Kick = Kick
	
	concommand.Add("CGAM_Kick", function( pl , cmd, args )
		local Plid = args[1]
		local message = args[2]

		if pl:IsAdmin() then

			Kick( Plid , message )

		end

	end)
	
	local function Ban( ply, message, time )
	
		local pl = FindPlayer( ply )
	
		if pl then

			if message == '< Optional >' then

				pl:Ban( time, 'Old and useless' )

			else

				pl:Ban( time, message )

			end
		
		end

	end
	
	CGAM.Ban = Ban
	
	concommand.Add("CGAM_Ban", function( pl , cmd, args )
		local Plid = args[1]
		local message = args[2]
		local time = args[3]

		if pl:IsAdmin() then

			Ban( Plid , message, time )

		end

	end)
	
	hook.Add( "ShowSpare1", "CGAM.ShowMenu", function( pl )
		pl:ConCommand( "CGAM_OpenMenu" )
	end)

end


if CLIENT then

	local function ReceiveOptics( um )
	
		local Type = um:ReadString()
		local Message = um:ReadString()
		
		if Message == "" then Message = "NA" end
		
		if Type == 'Warn' or Type == 1 then
			chat.AddText(
				Color(0,0,255) , 'CGAM' ,
				Color(255,255,255), " : ",
				Color(255,255,255), "You got a warning : \' ",
				Color(255,255,255), Message .. " \'")
			chat.PlaySound()
		elseif Type == 'Slay' or Type == 2 then
			chat.AddText(
				Color(0,0,255) , 'CGAM' ,
				Color(255,255,255), " : ",
				Color(255,255,255), Message)
			chat.PlaySound()
		elseif Type == 'Custom' or Type == 3 then
			chat.AddText(
				Color(0,0,255) , 'CGAM' ,
				Color(255,255,255), " : ",
				Color(255,255,255), Message)
			chat.PlaySound()
		elseif Type == 'Advert' or Type == 4 then
			chat.AddText(
				Color( 100,100,100 ), '(Advert)',
				Color(0,0,255) , 'CGAM' ,
				Color(255,255,255), " : ",
				Color(255,255,255), Message)
			chat.PlaySound()
		elseif Type == 'News' or Type == 5 then
			chat.AddText(
				Color( 255,0,0 ), '(NEWS) ',
				Color(0,0,255) , 'CGAM' ,
				Color(255,255,255), " : ",
				Color(255,255,255), Message)
			chat.PlaySound()
		end
	
	end
	
	usermessage.Hook( 'CGAM.ReceiveOptics', ReceiveOptics )

	function OpenUI()
	
		if LocalPlayer():IsAdmin() then

			local DLabel2
			local DNumSlider1
			local DCheckBox2
			local DCheckBox1
			local DButton9
			local DTextEntry3
			local DButton8
			local DButton7
			local DButton6
			local DButton5FXRG
			local DButton5
			local DButton4
			local DLabel1
			local DButton3
			local DButton2
			local DComboBox1
			local DPanel1
			local DFrame1

			DFrame1 = vgui.Create('DFrame')
			DFrame1:SetSize(418, 250)
			DFrame1:Center()
			DFrame1:SetTitle('CG Admin Mod')
			DFrame1:SetDeleteOnClose(false)
			DFrame1:MakePopup()

			DPanel1 = vgui.Create('DPanel')
			DPanel1:SetParent(DFrame1)
			DPanel1:SetSize(413, 224)
			DPanel1:SetPos(2, 24)

			DComboBox1 = vgui.Create('DComboBox')
			DComboBox1:SetParent(DPanel1)
			DComboBox1:SetSize(117, 217)
			DComboBox1:SetPos(2, 3)
			DComboBox1:EnableHorizontal(false)
			DComboBox1:EnableVerticalScrollbar(true)
			DComboBox1.OnMousePressed = function() end
			DComboBox1:SetMultiple(false)
			
			for k,v in pairs( player.GetAll() ) do
				DComboBox1:AddItem( v:Nick() )
			end

			DTextEntry3 = vgui.Create('DTextEntry')
			DTextEntry3:SetParent(DPanel1)
			DTextEntry3:SetSize(229, 20)
			DTextEntry3:SetPos(178, 42)
			DTextEntry3:SetText('')
			DTextEntry3.OnEnter = function() end

			DNumSlider1 = vgui.Create('DNumSlider')
			DNumSlider1:SetSize(284, 40)
			DNumSlider1:SetParent(DPanel1)
			DNumSlider1:SetPos(125, 68)
			DNumSlider1:SetDecimals(0)
			DNumSlider1.OnMouseReleased = function() end
			DNumSlider1.OnValueChanged = function() end
			DNumSlider1:SetText('Number')
			DNumSlider1:SetValue(0)
			DNumSlider1:SetMinMax( 0, 9999)

			DButton5 = vgui.Create('DButton')
			DButton5:SetParent(DPanel1)
			DButton5:SetSize(70, 25)
			DButton5:SetPos(339, 115)
			DButton5:SetText('Ban')
			DButton5.DoClick = function() end

			DTextEntry3 = vgui.Create('DTextEntry')
			DTextEntry3:SetParent(DPanel1)
			DTextEntry3:SetSize(229, 20)
			DTextEntry3:SetPos(178, 42)
			DTextEntry3:SetText('< Optional >')
			DTextEntry3.OnEnter = function() end

			DLabel2 = vgui.Create('DLabel')
			DLabel2:SetParent(DPanel1)
			DLabel2:SetPos(131, 15)
			DLabel2:SetText('CG Admin Mod made by Ningaglio and the CG Dev Team')
			DLabel2:SizeToContents()

			DLabel1 = vgui.Create('DLabel')
			DLabel1:SetParent(DPanel1)
			DLabel1:SetPos(127, 45)
			DLabel1:SetText('String :')
			DLabel1:SizeToContents()

			DButton2 = vgui.Create('DButton')
			DButton2:SetParent(DPanel1)
			DButton2:SetSize(70, 25)
			DButton2:SetPos(123, 115)
			DButton2:SetText('Warn')
			DButton2.DoClick = function()
				RunConsoleCommand( "CGAM_Warn", DComboBox1:GetSelectedItems()[1]:GetValue() , DTextEntry3:GetValue() )
			end

			DButton3 = vgui.Create('DButton')
			DButton3:SetParent(DPanel1)
			DButton3:SetSize(70, 25)
			DButton3:SetPos(195, 115)
			DButton3:SetText('Slay')
			DButton3.DoClick = function()
				RunConsoleCommand( "CGAM_Slay", DComboBox1:GetSelectedItems()[1]:GetValue() )
			end

			DButton4 = vgui.Create('DButton')
			DButton4:SetParent(DPanel1)
			DButton4:SetSize(70, 25)
			DButton4:SetPos(267, 115)
			DButton4:SetText('Kick')
			DButton4.DoClick = function()
				RunConsoleCommand( "CGAM_Kick", DComboBox1:GetSelected():GetValue() , DTextEntry3:GetValue() )
			end

			DButton5 = vgui.Create('DButton')
			DButton5:SetParent(DPanel1)
			DButton5:SetSize(70, 25)
			DButton5:SetPos(339, 115)
			DButton5:SetText('Ban')
			DButton5.DoClick = function()
				RunConsoleCommand( "CGAM_Ban", DComboBox1:GetSelected():GetValue() , DTextEntry3:GetValue(), DNumSlider1:GetValue() )
			end

			DButton5FXRG = vgui.Create('DButton')
			DButton5FXRG:SetParent(DPanel1)
			DButton5FXRG:SetSize(142, 25)
			DButton5FXRG:SetPos(123, 141)
			DButton5FXRG:SetText('Run Lua')
			DButton5FXRG.DoClick = function()
				RunConsoleCommand( "CGAM_Lua", DTextEntry3:GetValue() )
			end

			DButton6 = vgui.Create('DButton')
			DButton6:SetParent(DPanel1)
			DButton6:SetSize(142, 25)
			DButton6:SetPos(267, 141)
			DButton6:SetText('Cexec')
			DButton6.DoClick = function()
				RunConsoleCommand( "CGAM_Cexec", DComboBox1:GetSelected():GetValue() , DTextEntry3:GetValue() )
			end

			DButton7 = vgui.Create('DButton')
			DButton7:SetParent(DPanel1)
			DButton7:SetSize(70, 25)
			DButton7:SetPos(267, 168)
			DButton7:SetText('God')
			DButton7.DoClick = function()
				RunConsoleCommand( "CGAM_God", DComboBox1:GetSelected():GetValue() )
			end

			DButton8 = vgui.Create('DButton')
			DButton8:SetParent(DPanel1)
			DButton8:SetSize(70, 25)
			DButton8:SetPos(339, 168)
			DButton8:SetText('Ungod')
			DButton8.DoClick = function()
				RunConsoleCommand( "CGAM_UnGod", DComboBox1:GetSelected():GetValue() )
			end

			DButton9 = vgui.Create('DButton')
			DButton9:SetParent(DPanel1)
			DButton9:SetSize(142, 25)
			DButton9:SetPos(267, 195)
			DButton9:SetText('( News )')
			DButton9.DoClick = function()
				RunConsoleCommand( "CGAM_SendNews", DTextEntry3:GetValue(), DComboBox1:GetSelected():GetValue() )
			end

			DCheckBox1 = vgui.Create('DCheckBoxLabel')
			DCheckBox1:SetParent(DPanel1)
			DCheckBox1:SetPos(126, 174)
			DCheckBox1:SetText('Global Godmode')
			DCheckBox1.DoClick = function() end
			DCheckBox1:SetConVar( "sbox_godmode" )
			DCheckBox1:SizeToContents()

			DCheckBox2 = vgui.Create('DCheckBoxLabel')
			DCheckBox2:SetParent(DPanel1)
			DCheckBox2:SetPos(127, 197)
			DCheckBox2:SetText('No PvP dammage')
			DCheckBox2.DoClick = function() end
			DCheckBox2:SetConVar( "sbox_plpldamage" )
			DCheckBox2:SizeToContents()
			
		end
		
	end
	
	concommand.Add( "CGAM_OpenMenu", OpenUI )
	CGAM.OpenUI = OpenUI
	
end

require("CGAM")