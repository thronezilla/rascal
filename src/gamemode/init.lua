AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')

include('extern/animationsapi/boneanimlib.lua')
include('shared.lua')


DEFINE_BASECLASS('gamemode_base')

function GM:PlayerSpawn(pl, transiton)
  player_manager.SetPlayerClass(pl, 'player_rascal')
  BaseClass.PlayerSpawn(self, pl, transiton)
end
