

PLUGIN.Name = "Enoce"
PLUGIN.Category = "Languages"
PLUGIN.Info = "Made by meisno"
PLUGIN.Usage = "Learn to code in Eno"

function PLUGIN.Init()
end


function PLUGIN.Shared()

	module( "Enoce", package.seeall )

	local _Functions = { }
	local _Hooks = { }

	function AddFunction( name, func )

		for k,v in pairs( _G ) do
			if type( v ) == "function" then
				_Functions[ k ] = v
			end
		end
		
		if !_Functions[ name ] then
			
			_Functions[ name ] = func
			
		end

		
	end

	function CallHooks( name, ... )

		if _Hooks[ name ] then
		
			for HName , func in pairs( _Hooks[ name ] ) do
			
				func( arg )
				
			end
			
		end
		
	end
		
	function AddHook( HName, HName2, func )

		if !_Hooks[ HName ] then _Hooks[ HName ] = { } end
		
		_Hooks[ HName ][ HName2 ] = func
		
	end

	-- Primary interpreter

	local function InterpretateFunc( PreFunc )

	//	local Func = nil
		
	//	if _Functions[ PreFunc ] then Func = _Functions[ PreFunc ] end
		
	//	return Func

		return _G[ PreFunc ];

	end

	function LoadHooks( str )

		-- Gathering all the info we need

		local stri = string.gsub( str, "<%s*Hook%s*=%s*([%w_]+)%s*>%s*([%w_]+)%s*</%s*Hook%s*>", "%1 = %2" );
		
		-- Secondary language transformer

		local pattern = "([%w_]+)%s*=%s*([%w_]+)";
		
		-- Now we split it up into 2 parts ( HookName and Suposed function name )

		for HookName, PreFunc2 in string.gmatch( stri, pattern ) do

			
			-- Random name genorator
			
			local function MakeRandomName()
			
				local str = "_"
				local tab = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "x", "y", "z" }
			
				for i=1 , math.random( 10 , 20 ) do
				
					str = str .. table.Random( tab )
					
				end
				
				return str
			
			end
			
			-- For basic hooks like 'PlayerSay'
			
			for k,v in pairs( string.Explode( ";", PreFunc2 ) ) do
			
				local PreFunc3 = string.Trim( v )
			
				hook.Add( HookName , MakeRandomName(), InterpretateFunc( PreFunc3 ) )
				AddHook( HookName , MakeRandomName(), InterpretateFunc( PreFunc3 ) )
				
			end

		end
		
	end

	function LoadDefines( str )

		local stri = string.gsub( str, "<%s*Define%s+([%w_]+)%s*>%s*([%w%s*_]+)</%s*Define%s*>", "%1 = %2" );
		local pattern = "([%w_]+)%s*=%s*([%w_]+)";

		for GName, GValue in string.gmatch( stri, pattern ) do
		
			local GValue2 = string.gsub( GValue , "_", " " )

			_G[ GName ] = GValue2
		
		end
		
	end

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

	function LoadPlayerModule( str )

		local stri = string.gsub( str, "<%s*Player%s+([%w_]+)%s*>%s*([%w%s*_]+)</%s*Player%s*>", "%1 = %2" );
		local pattern = "([%w_]+)%s*=%s*([%w_]+)";

		for GIndex, GFunc in string.gmatch( stri, pattern ) do
			
			local TPl = FindPlayer( GIndex )
			if TPl then
				if _G[ GFunc ] then
					local func = _G[ GFunc ]
					func(TPl)
				end
			end
		
		end
		
	end

	function LoadTables( str )

		local stri = string.gsub( str, "<%s*Table%s+([%w_]+)%s*>%s*([%w%s*_]+)</%s*Table%s*>", "%1 = %2" );
		local pattern = "([%w_]+)%s*=%s*([%w_]+)";
		
		local TName01 = ""
		
		for TName, TEntries in string.gmatch( stri, pattern ) do

			_G[ TName ] = {}
			
			TName01 = TName
		
		end

		local stri2 = string.gsub( str, "<([%w_]+)%s*>([%w_]+)%s*</([%w_]+)%s*>", "%1 = %2" )

		local pattern2 = "([%w_]+)%s*=%s*([%w_]+)"; -- same pattern as above

		local tbl = { };

		for key, value in string.gmatch( stri2, pattern2 ) do

			_G[ TName01 ][ key ] = value;

		end
		
	end

	function LoadCommands( str )

		local stri = string.gsub( str, "<%s*Command%s+([%w_]+)%s*>%s*([%w%s*_]+)</%s*Command%s*>", "%1 = %2" );
		local pattern = "([%w_]+)%s*=%s*([%w_]+)";

		for CName, Cfunc in string.gmatch( stri, pattern ) do

			concommand.Add( CName , InterpretateFunc( Cfunc ) )
			
			local stri2 = string.gsub( str, "%[Call%s+([%w_]+)%]([%w_]+)%s*%[/Call%]", "%1 = %2" )

			local pattern2 = "([%w_]+)%s*=%s*([%w_]+)"; -- same pattern as above

			local tbl = { };

			for ToCall, Args in string.gmatch( stri, pattern ) do

				//_G[ TName01 ][ key ] = value;
				local args = string.Explode( ",", Args) or nil
				
				CallHooks( ToCall, args )
				concommand.Remove( CName )
				concommand.Add( CName , function() CallHooks( ToCall, args ) end)

			end

		end
	end

	local _Defaults = { }

	function AddDefault( name, func )
		_Defaults[ name ] = func
		if !_G[ name ] then _G[ name ] = func end
	end

	AddDefault( "Print", function( str )
		print( str )
	end)

	AddDefault( "Msg", function( str )
		Msg( str .. "\n" )
	end)

	AddDefault( "Kill", function( str )
		FindPlayer( str ):Kill()
	end)

	function LoadDefaults( str )

		local stri = string.gsub( str, "<%s*Global%s+([%w_]+)%s*>%s*([%w%s*_]+)</%s*Global%s*>", "%1 = %2" );
		local pattern = "([%w_]+)%s*=%s*([%w_]+)";

		for DName, DArgs in string.gmatch( stri, pattern ) do

			if _Defaults[ DName ] then
				_Defaults[ DName ]( string.gsub( DArgs, "_", " " ) )
			end
		
		end
		
	end


	function LoadFunctions( str )

		local stri = string.gsub( str, "<%s*Function%s+name%s*=%s*([%w_]+)%s*>%s*([%w%s*_]+)</%s*Function%s*>", "%1 = %2" );
		local pattern = "([%w_]+)%s*=%s*([%w_]+)";
		
		for FName, FSyu in string.gmatch( stri, pattern ) do

			_G[ FName ] = function()
				LoadDefaults( FSyu )
				LoadHooks( FSyu )
				LoadDefines( FSyu )
				LoadPlayerModule( FSyu )
				LoadTables( FSyu )
				LoadCommands( FSyu )
			end
		
		end
		
	end

	function LoadLanguage( str )
		LoadDefaults( str )
		LoadHooks( str )
		LoadDefines( str )
		LoadPlayerModule( str )
		LoadTables( str )
		LoadCommands( str )
		LoadFunctions( str )
	end

	function Include( str )

		local contents = file.Read( "Enoce/" .. str .. ".txt" )
		
		LoadLanguage( contents )

	end

	function MakeDir()
		if ( not file.IsDir("Enoce") ) then
			file.CreateDir("Enoce")
			file.CreateDir("Enoce/autorun")
			file.CreateDir("Enoce/autorun/server")
			file.CreateDir("Enoce/autorun/client")
		end
	end

	MakeDir()

	function IncludeAutorun()
		local list1 = file.Find("Enoce/autorun/*.txt")
		for _, files in pairs(list1) do
		   Include( "autorun/" .. files )
		end
	end

	function IncludeServerAutorun()
		if SERVER then
			local list1 = file.Find("Enoce/autorun/server/*.txt")
			for _, files in pairs(list1) do
			   Include( "autorun/server/" .. files )
			end
		end
	end

	function IncludeClientAutorun()
		if CLIENT then
			local list1 = file.Find("Enoce/autorun/client/*.txt")
			for _, files in pairs(list1) do
			   Include( "autorun/client/" .. files )
			end
		end
	end


	_G['FailPrint'] = function()
		print( lol132Text )
	end
	AddFunction( 'FailPrint2' ,function()
		print(" jujuj")
		PrintTable( Sam1 )
		print(" jujuj")
	end)
	AddFunction( 'SpeechPrint' , function( pl, txt ) print( "Enoce : " .. pl:Nick() .. " Just Said : \'" .. txt .. "\'" ) end)

	if SERVER then
		LoadLanguage( [[
		<C> ----------------- </C>
		<C> Made By Ningaglio </C>
		<C> ----------------- </C>

		<Hook = PlayerSay>SpeechPrint</Hook>

		<Define lol132Text>_This_Is_A_True_Command_Made_In_Enoce</Define>
		<Command lol132>FailPrint</Command>
		
		<Table Sam1>
			<lol>Hello</lol>
			<lol2>There</lol2>
		</Table>
		<Command lol132222>FailPrint2</Command>
		
		<Define lol132Text>_This_Is_A_True_Command_Made_In_Enoce</Define>
		<Command lol132>FailPrint</Command>

		<Function name = PrintFail>
			<Global Print>_</Global>
			<Global Print>the_Print_Function_Works</Global>
			<Global Msg>the_Msg_Function_Works</Global>
			<Global Print>_</Global>
		</Function>
		
		<Command PrintFailTest>PrintFail</Command>

		<Player meisno>Kill</Player>
		]] )
	end

	IncludeAutorun()
	IncludeServerAutorun()
	IncludeClientAutorun()

	-- End of Enoce, Begining of debuging

	require( "Enoce" )
end


function PLUGIN.Cl_init()
end