PLUGIN.Name = "NameTags"
PLUGIN.Category = "Visual Impact"
PLUGIN.Info = "Places nametags above peoples heads."
PLUGIN.Usage = "Look at the stranger"

-- Initially made by Overv
-- And transformed into a nice
-- Plugin for CGAM by meisno.

function PLUGIN.Init()
end

function PLUGIN.Shared()
end

function PLUGIN.Cl_init()

	local function HUDPaint()

		for _, pl in ipairs( player.GetAll() ) do
		
			if ( pl != LocalPlayer() ) then
			
				local td = {}
					td.start = LocalPlayer():GetShootPos()
					td.endpos = pl:GetShootPos()
				local trace = util.TraceLine( td )

				if ( !trace.HitWorld ) then				
					surface.SetFont( "ScoreboardText" )

					local w = surface.GetTextSize( pl:Nick() ) + 8 + 20
					local h = 24

					local vec = pl:GetShootPos() + Vector(0,0,7)
					local drawPos = vec:ToScreen()
					local distance = LocalPlayer():GetShootPos():Distance( pl:GetShootPos() )

					drawPos.x = drawPos.x - w / 2
					drawPos.y = drawPos.y - h - 12

					local alpha = 128

					if ( distance > 128 ) then

						alpha = 128 - math.Clamp( ( distance - 128 ) / ( 2048 - 512 ) * 128, 0, 128 )

					end
					
					draw.RoundedBoxEx( 6, drawPos.x, drawPos.y, w, h, Color( 0, 0, 0, alpha ), true, true, false, false )
					
					local icons = { }
					//icons["chatting"] = "gui/silkicons/comments"
					icons["chatting"] = "gui/silkicons/page_white_wrench"
					icons["user"] = "gui/silkicons/user"
					icons["super_admin"] = "gui/silkicons/shield"
					icons["admin"] = "gui/silkicons/star"
					
					if ( pl:GetNWBool( "IsInChat", false ) ) then
						surface.SetTexture( surface.GetTextureID( icons["chatting"] ) )
					else
						if ( pl:IsAdmin() ) then
							surface.SetTexture( surface.GetTextureID( icons["admin"] ) )
						elseif ( pl:IsSuperAdmin() ) then
							surface.SetTexture( surface.GetTextureID( icons["super_admin"] ) )
						else
							surface.SetTexture( surface.GetTextureID( icons["user"] ) )
						end
					end

					surface.SetDrawColor( 255, 255, 255, math.Clamp( alpha * 2, 0, 255 ) )
					surface.DrawTexturedRect( drawPos.x + 4, drawPos.y + 4, 16, 16 )

					local teamColor = team.GetColor( pl:Team() )
					teamColor.a = math.Clamp( alpha * 2, 0, 255 )
					draw.DrawText( pl:Nick(), "ScoreboardText", drawPos.x + 24, drawPos.y + 4, teamColor, 0 )
				end
			end
		end
	end

	hook.Add("HUDPaint", "DrawUsers", HUDPaint )
	
	local function StartChat()
		LocalPlayer():SetNWBool("IsInChat", true)
	end
	hook.Add("StartChat", "Tags.SetInChat", StartChat)
	
	local function EndChat()
		LocalPlayer():SetNWBool("IsInChat", false)
	end
	hook.Add("FinishChat", "Tags.SetInChat", EndChat)
end