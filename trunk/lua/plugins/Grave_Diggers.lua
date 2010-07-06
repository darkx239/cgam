PLUGIN.Name = "GraveStones"
PLUGIN.Category = "Games n' Fun"
PLUGIN.Info = "Makes a grave stone where you die"
PLUGIN.Usage = "Die!"

function PLUGIN.Init()

	function PLUGIN.MakeGraves( pl )
		local pos = pl:GetPos() + Vector( 0,0,26 )
		local mod = "models/props_c17/gravestone002a.mdl"
		local ent = ents.Create("prop_physics")
		ent:SetModel( mod )
		ent:SetPos(pos)
		ent:Spawn()
		pl.Grave = { pl, ent }
	end
	
	hook.Add( "PlayerDeath", "GravePlugin01", PLUGIN.MakeGraves )
	
	function PLUGIN.RemoveGraves( pl )
		local grave = pl.Grave
		if grave && grave[2] then
			if grave[3] != true then
				grave[2]:Remove()
			else
				grave[3] = nil
			end
		end
	end
	
	hook.Add( "PlayerSpawn", "GravePlugin02", PLUGIN.RemoveGraves )
	
	concommand.Add( "CGAM_Graves_RemoveAll", function( pl )
		if pl:IsAdmin() then
			for k,v in pairs( player.GetAll() ) do
				local grave = v.Grave
				if grave && grave[1] && grave[2] then grave[2]:Remove() end
				v.Grave = { grave[1], grave[2], true }
			end
		end
	end)
end

function PLUGIN.Shared()
end

function PLUGIN.Cl_init()
end

PLUGIN.BuildMenu['Remove All Graves'] = function()
	LocalPlayer():ConCommand( "CGAM_Graves_RemoveAll" )
end