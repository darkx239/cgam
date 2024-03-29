
if !_G['CGAM'] then _G['CGAM'] = { } end

CGAM.Plugins = { }

local list1 = file.FindInLua( "Plugins/*.lua")

Msg("\n\n------ Loading Plugins For CGAM ------\n\n\n")

function CGAM.ReloadPlugins()

	for _, file1 in pairs(list1) do
	
		PLUGIN = { }
		PLUGIN.BuildMenu = { }
		
		if SERVER then
		
			include( "plugins/" .. file1 )
			AddCSLuaFile( "plugins/" .. file1 )
			
		else
		
			include( "Plugins/" .. file1 )
			
		end
		
		Msg("Loading \'" .. PLUGIN.Name .. "\' plugin\n" )
		
		if SERVER then
		
			PLUGIN.Init()
			PLUGIN.Shared()
			
		else
		
			PLUGIN.Cl_init()
			PLUGIN.Shared()
			
		end
		
		// Start Indexing!
		
		CGAM.Plugins[PLUGIN.Name] = { }
			
			CGAM.Plugins[PLUGIN.Name]["File"] = file1
			
			-- Information
			
			CGAM.Plugins[PLUGIN.Name]["Name"] = PLUGIN.Name
			CGAM.Plugins[PLUGIN.Name]["Category"] = PLUGIN.Category
			CGAM.Plugins[PLUGIN.Name]["Info"] = PLUGIN.Info
			CGAM.Plugins[PLUGIN.Name]["Usage"] = PLUGIN.Usage
			CGAM.Plugins[PLUGIN.Name]["BuildMenu"] = PLUGIN.BuildMenu
		
			-- Functions
		
			CGAM.Plugins[PLUGIN.Name]["Init"] = PLUGIN.Init
			CGAM.Plugins[PLUGIN.Name]["shared"] = PLUGIN.Shared
			CGAM.Plugins[PLUGIN.Name]["Cl_Init"] = PLUGIN.Cl_init
			if PLUGIN.OnInfo then CGAM.Plugins[PLUGIN.Name]["OnInfo"] = PLUGIN.OnInfo end
		
	end
	
end

function CGAM.ReloadSinlgePlugins( file1 )
	
	PLUGIN = { }
	PLUGIN.BuildMenu = { }
	PLUGIN.Hook = { }
	
	if SERVER then
	
		include( "plugins/" .. file1 )
		AddCSLuaFile( "plugins/" .. file1 )
		
	else
	
		include( "Plugins/" .. file1 )
		
	end
	
	Msg("Reloading \'" .. PLUGIN.Name .. "\' plugin\n" )
	
	if SERVER then
	
		PLUGIN.Init()
		PLUGIN.Shared()
		
	else
	
		PLUGIN.Cl_init()
		PLUGIN.Shared()
		
	end
	
	// Start Indexing!
	
	CGAM.Plugins[PLUGIN.Name] = { }
		
	CGAM.Plugins[PLUGIN.Name]["File"] = file1
	
	-- Information
	
	CGAM.Plugins[PLUGIN.Name]["Name"] = PLUGIN.Name
	CGAM.Plugins[PLUGIN.Name]["Category"] = PLUGIN.Category
	CGAM.Plugins[PLUGIN.Name]["Info"] = PLUGIN.Info
	CGAM.Plugins[PLUGIN.Name]["Usage"] = PLUGIN.Usage
	CGAM.Plugins[PLUGIN.Name]["BuildMenu"] = PLUGIN.BuildMenu
	
	-- Functions
	
	CGAM.Plugins[PLUGIN.Name]["Init"] = PLUGIN.Init
	CGAM.Plugins[PLUGIN.Name]["shared"] = PLUGIN.Shared
	CGAM.Plugins[PLUGIN.Name]["Cl_Init"] = PLUGIN.Cl_init
	if PLUGIN.OnInfo then CGAM.Plugins[PLUGIN.Name]["OnInfo"] = PLUGIN.OnInfo end
	
	-- Hooking System
	
	CGAM.Plugins[PLUGIN.Name]["Hook"] = PLUGIN.Hook
	
	for name,func in pairs( PLUGIN.Hook ) do
		local cname = "CGAM_Plugins." .. PLUGIN.Name
		hook.Add( name, cname , func )
	end
	
end

CGAM.ReloadPlugins()
Msg("\n\n------  Loaded Plugins For CGAM ------\n\n\n")


if SERVER then
	concommand.Add( "CGAM_ReloadPlugins", function( pl )
		if pl:IsAdmin() then
			CGAM.ReloadPlugins()
			for k,v in pairs( player.GetAll() ) do
				v:SendLua( "CGAM.ReloadPlugins()" )
			end
		end
	end)

	concommand.Add( "CGAM_ReloadSinglePlugin", function( pl, cmd, args )
		if pl:IsAdmin() then
			local file1 = args[1]
			CGAM.ReloadSinlgePlugins( file1 )
			for k,v in pairs( player.GetAll() ) do
				v:SendLua( "CGAM.ReloadSinlgePlugins( \'" .. file1 .. "\' )" )
			end
		end
	end)
end