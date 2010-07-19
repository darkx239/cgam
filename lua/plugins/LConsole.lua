PLUGIN.Name = "LConsole"
PLUGIN.Category = "Core"
PLUGIN.Info = "Simple console made in lua"
PLUGIN.Usage = "Press F4"

function PLUGIN.Init()
	_G['Console'] = {}
	
		local function AcceptStream( pl, handler, id )
			if handler == "Console.Parse" then
				return true
			end
		end
		hook.Add( "AcceptStream", "Console.AcceptStream", AcceptStream )
		
		local _commands = { }
		
		function Console.AddCommand( name , func )
			if name && func then
				_commands[string.lower(name)] = func
			end
		end
		
		function Console.RemoveCommand( name )
			if name then
				_commands[string.lower(name)] = nil
			end
		end
		
		function Console.CallCommand( ply, name, args )
			local con = _commands[string.lower(name)]
			if con and con != nil and ply then
				if args then
					con( ply, name, args )
					//pcall( com, ply, name, args)
				else
					con( ply, name, { } )
					//pcall( com, ply, name, { })
				end
			end
		end
		
		local function IncomingHook( pl, handler, id, encoded, decoded )
		
			local cmd = table.remove( decoded, 1 )
			local tab = decoded
			table.remove( tab, 1 )
			
			CallCommand( pl, cmd, tab )
		
		end
		datastream.Hook( "Console.Parse", IncomingHook );
		
		local function OpenConsole( ply )
			ply:ConCommand("Open_Console")
		end
		hook.Add("ShowSpare2", "Console.Open", OpenConsole)
		
		Console.AddCommand( "test", function( ply, cmd, args )
			ply:PrintMessage( HUD_PRINTCENTER, "You entered : " .. string.Implode( " , ", args ) )
		end)
		
		Console.AddCommand( "echo", function( ply, cmd, args )
			print( string.Implode( " ", args ) )
		end)
		
		Console.AddCommand( "kill", function( ply, cmd, args )
			if ply:IsValid() then
				ply:KillSilent()
			end
		end)
		
		Console.AddCommand( "disconnect", function( ply, cmd, args )
			if ply:IsValid() then
				ply:Kick("CLua : Disconnected by user")
			end
		end)
		
		Console.AddCommand( "browse", function( ply, cmd, args )
			if ply:IsValid() then
				ply:SendLua("Console.OpenURL(\"" .. args[1] .. "\")")
			end
		end)
		
		Console.AddCommand( "explode", function( ply, cmd, args )
			if ply:IsValid() then
				ply:ConCommand("explode")
			end
		end)

end


function PLUGIN.Shared()
end


function PLUGIN.Cl_init()

	_G['Console'] = {}
		
		// This function was made by lexi ( in a way ), so full
		// credits to him! ( for parsing strings with quotes correctly )
		
		local function ParseStrings( str )
			local stri = string.Trim( str )
			local text = tostring(stri)
			local quote = text:sub(1,1) ~= '"'
			local ret = {}
			for chunk in string.gmatch(text, '[^"]+') do
				quote = not quote
				if quote then
					table.insert(ret,chunk)
				else
					for chunk in string.gmatch(chunk, "%a+") do
						table.insert(ret,chunk)
					end
				end
			end
			return ret
		end
		
		
		function Console.SendCommand( con, tab )
			datastream.StreamToServer( "Console.Parse", { con, unpack(tab) } );
		end
			
		function Console.OpenConsole()
			local DFrame1 = vgui.Create('DFrame')
			DFrame1:SetSize(500, 417)
			DFrame1:Center()
			DFrame1:SetTitle('Console')
			DFrame1:SetSizable(true)
			DFrame1:SetDeleteOnClose(false)
			DFrame1:SetScreenLock( true )
			DFrame1:SetDraggable(false)
			DFrame1:SetBackgroundBlur(true)
			DFrame1:SetSizable(false)
			DFrame1:MakePopup()

			local function OnSend( str )
				for k,v in pairs( string.Explode( ";", str ) ) do
					local parsed = ParseStrings( tostring(v) )
					SendCommand( parsed[1] , parsed )
				end
			end

			local HTMLTest = vgui.Create("HTML", DFrame1)
			HTMLTest:SetPos(5,27)
			HTMLTest:SetSize(490, 350)
			//HTMLTest:SetHTML(file.Read( "lol1.txt" ))
			HTMLTest:OpenURL( "http://www.google.com" )
			
			function OpenURL( url )
				HTMLTest:OpenURL( url )
			end

			local DPanel2 = vgui.Create('DPanel', DFrame1)
			DPanel2:SetPos(5, 380)
			DPanel2:SetSize(490, 32)

			local DTextEntry1 = vgui.Create('DTextEntry',DPanel2)
			DTextEntry1:SetPos(5, 4)
			DTextEntry1:SetSize(390, 25)
			DTextEntry1:SetText('Enter A Command')
			DTextEntry1.OnEnter = function()
				OnSend( DTextEntry1:GetValue() )
			end

			local DButton2 = vgui.Create('DButton',DPanel2)
			DButton2:SetPos(405, 4)
			DButton2:SetSize(70, 25)
			DButton2:SetText('Send.')
			DButton2.DoClick = function()
				OnSend( DTextEntry1:GetValue() )
			end

		end

		concommand.Add("Open_Console", OpenConsole )
end
