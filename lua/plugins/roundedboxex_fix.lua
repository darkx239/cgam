PLUGIN.Name = "draw.RoundedBoxEx Fix"
PLUGIN.Category = "Visual Impact"
PLUGIN.Info = "Fixes draw.RoundedBoxEx , used with nametags"
PLUGIN.Usage = "Learn Lua"

function PLUGIN.Init()
end

function PLUGIN.Shared()
end

function PLUGIN.Cl_init()

	local Tex_Corner8 	= surface.GetTextureID( "gui/corner8" )
	local Tex_Corner16 	= surface.GetTextureID( "gui/corner16" )
	 
	function draw.RoundedBoxEx( bordersize, x, y, w, h, color, a, b, c, d )
		x = math.Round( x )
		y = math.Round( y )
		w = math.Round( w )
		h = math.Round( h )
	 
		surface.SetDrawColor( color.r, color.g, color.b, color.a )
	 
		surface.DrawRect( x+bordersize, y, w-bordersize*2, h )
		surface.DrawRect( x, y+bordersize, bordersize, h-bordersize*2 )
		surface.DrawRect( x+w-bordersize, y+bordersize, bordersize, h-bordersize*2 )
	 
		local tex = Tex_Corner8
		if ( bordersize > 8 ) then tex = Tex_Corner16 end
	 
		surface.SetTexture( tex )
	 
		if ( a ) then
			surface.DrawTexturedRectRotated( x + bordersize/2 , y + bordersize/2, bordersize, bordersize, 0 )
		else
			surface.DrawRect( x, y, bordersize, bordersize )
		end
	 
		if ( b ) then
			surface.DrawTexturedRectRotated( x + w - bordersize/2 , y + bordersize/2, bordersize, bordersize, 270 )
		else
			surface.DrawRect( x + w - bordersize, y, bordersize, bordersize )
		end
	 
		if ( c ) then
			surface.DrawTexturedRectRotated( x + bordersize/2 , y + h -bordersize/2, bordersize, bordersize, 90 )
		else
			surface.DrawRect( x, y + h - bordersize, bordersize, bordersize )
		end
	 
		if ( d ) then
			surface.DrawTexturedRectRotated( x + w - bordersize/2 , y + h - bordersize/2, bordersize, bordersize, 180 )
		else
			surface.DrawRect( x + w - bordersize, y + h - bordersize, bordersize, bordersize )
		end
	end
end
