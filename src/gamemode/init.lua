AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('shared.lua')
print("init")

DEFINE_BASECLASS('gamemode_base')

function GM:PlayerSpawn(pl, transiton)
  player_manager.SetPlayerClass(pl, 'player_rascal')
  BaseClass.PlayerSpawn(self, pl, transiton)
end