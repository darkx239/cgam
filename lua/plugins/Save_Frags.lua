PLUGIN.Name = "Save Scores"
PLUGIN.Category = "Games n' Fun"
PLUGIN.Info = "Saves Frags"
PLUGIN.Usage = "NA"

local hook = hook
local FindMetaTable = FindMetaTable

PLUGIN.Meta = FindMetaTable( 'Player' )

/*function PLUGIN.Meta:SaveFrags()
	local cur = self:Frags()
	local sav = self:GetPData( 'Frags' )
	self:SetFrags( 0 )
	if sav then
		self:SetPData( 'Frags' , sav + cur )
	else
		self:SetPData( 'Frags', cur )
	end
end*/

function PLUGIN.Meta:AddFrags( N )
	local pl = self
	pl:SetFrags( pl:Frags() + N )
	pl:SetPData( 'Frags' ,pl:Frags() )
end

function PLUGIN.Meta:SaveFrags()
	self:SetPData( 'Frags', self:Frags() )
end
	
function PLUGIN.Meta:LoadFrags()
	local savd = self:GetPData( 'Frags' )
	if savd then
		self:SetFrags( savd )
	end
end

function PLUGIN.Init()
	hook.Add( "PlayerDeath", "Plugin.SaveFrags.1", function( a , _ , b )
		a:AddFrags( -1 )
		b:AddFrags( 1 )
	end)
	
	hook.Add( "PlayerSpawn", "Plugin.LoadFrags.1", function( a )
		a:LoadFrags()
	end)
	
	hook.Add( "PlayerDisconnected", "Plugin.SaveFrags.2", function( a )
		a:SaveFrags()
	end)
	
	timer.Create( "SaveFrags", 5, 0, function()
		for k,v in pairs( player.GetAll() ) do
			v:SaveFrags()
		end
		//print( 'Saved All Frags' )
	end)
end

function PLUGIN.Shared()
end

function PLUGIN.Cl_init()
end
