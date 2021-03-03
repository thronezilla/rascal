include('shared.lua')

print("client");

rascal = {}
rascal.hud = {}

function GM:HUDPaint() --TODO: clean this up, maybe make an actual hud
  surface.SetDrawColor(55, 55, 50) 
  surface.DrawRect(0, surface.ScreenHeight() - 15, surface.ScreenWidth(), 15)
  if rascal.sv then
    surface.SetDrawColor(55, 55, 130) 
    surface.DrawRect(0, surface.ScreenHeight() - 15, rascal.sv.xp / rascal.sv.xptolvl * surface.ScreenWidth(), 15)
  end

  surface.SetFont( "Default" )
	surface.SetTextColor( 255, 255, 255 )
	surface.SetTextPos( 15, surface.ScreenHeight() - 17 ) 
	surface.DrawText( "xp" )
end

net.Receive('rascal_setup', function(len)
  rascal.sv = net.ReadTable()
end)