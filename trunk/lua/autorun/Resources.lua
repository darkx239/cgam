// Resource File

if !_G['CGAM'] then _G['CGAM'] = { } end

if SERVER then

	include( "Plugins.lua" )
	AddCSLuaFile( "Plugins.Lua" )

else

	include( "Plugins.lua" )

end