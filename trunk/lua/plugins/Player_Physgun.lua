PLUGIN.Name = "Player Pickup"
PLUGIN.Category = "Administration"
PLUGIN.Info = "Pickup players with your physgun."
PLUGIN.Usage = "Click on a player with your physgun."

function PLUGIN.Init()
	hook.Add("PhysgunPickup", "PPickup.Aim", function( ply, pl )
		if ( ply:IsAdmin() && pl:IsPlayer() ) then
			pl.IsPickedUp = true
			pl:SetMoveType( MOVETYPE_NOCLIP )
			return true
		end
	end)
	
	hook.Add("PhysgunDrop", "PPickup.Drop", function( ply, pl )
		if ( ply:IsAdmin() && pl:IsPlayer() ) then
			pl.IsPickedUp = false
			pl:SetMoveType( MOVETYPE_WALK )
			return true
		end
	end)
	
	hook.Add("PlayerNoclip", "PPickup.AntiHax", function( ply )
		if ( pl.IsPickedUp ) then return false end
	end)

end

function PLUGIN.Shared()
end

function PLUGIN.Cl_init()
end