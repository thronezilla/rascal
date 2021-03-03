AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')
print("init")

DEFINE_BASECLASS('gamemode_base') 

rascal = {}

rascal.player_data = {} --contains rascal-related stuff about a player, indexed by Player:SteamID()

rascal.LoadFromDB = (function(id)

end)

rascal.TryLevel = (function(id)
  local lvl = rascal.player_data[id]

  if lvl.xp >= lvl.xptolvl then
    lvl.lvl = lvl.lvl + 1
    lvl.xptolvl = math.Round(lvl.xptolvl * 1.5) --needs fine tuning, obviously..
    lvl.xp = 0
  end
end)

util.AddNetworkString('rascal_setup')

function GM:PlayerSpawn(pl, transiton)
  player_manager.SetPlayerClass(pl, 'player_rascal')
  BaseClass.PlayerSpawn(self, pl, transiton)
  -- local e = ents.Create('rascal_ant') debug stuff
  -- e:SetPos(pl:GetPos() + Vector(50, 50, 0))
  -- e:Spawn()

  net.Start('rascal_setup')
  net.WriteTable(rascal.player_data[pl:SteamID()])
  net.Send(pl)
end

gameevent.Listen('player_connect') --we have this hook because GM:PlayerConnect is called before entity creation, where we cannot get a steamid
hook.Add('player_connect', 'plycnct', function(data)
  --rascal.player_data[data.networkid] = rascal.LoadFromDB(data.networkid); do database stuff later
  rascal.player_data[data.networkid] = {
    xp = 0,
    gp = 0,
    lvl = 1,
    xptolvl = 2,
  }
  
end)