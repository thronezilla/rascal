AddCSLuaFile()
DEFINE_BASECLASS('player_default')

local PLAYER = {}

PLAYER.WalkSpeed          = 200    -- How fast to move when not running
PLAYER.RunSpeed           = 300    -- How fast to move when running
PLAYER.CrouchedWalkSpeed  = 0.3    -- Multiply move speed by this when crouching
PLAYER.DuckSpeed          = 0.3    -- How fast to go from not ducking, to ducking
PLAYER.UnDuckSpeed        = 0.3    -- How fast to go from ducking, to not ducking
PLAYER.JumpPower          = 200    -- How powerful our jump should be
PLAYER.CanUseFlashlight   = true   -- Can we use the flashlight
PLAYER.MaxHealth          = 100    -- Max health we can have
PLAYER.MaxArmor           = 100    -- Max armor we can have
PLAYER.StartHealth        = 100    -- How much health we start with
PLAYER.StartArmor         = 0      -- How much armour we start with
PLAYER.DropWeaponOnDie    = false  -- Do we drop our weapon when we die
PLAYER.TeammateNoCollide  = true   -- Do we collide with teammates or run straight through them
PLAYER.AvoidPlayers       = true   -- Automatically swerves around other players
PLAYER.UseVMHands         = false   -- Uses viewmodel hands

function PLAYER:Init()
  if SERVER then 
    self.Player:CrosshairDisable() 
  end
end

function PLAYER:Loadout()
  self.Player:RemoveAllAmmo()
  self.Player:Give('weapon_crowbar')
  self.Player:SwitchToDefaultWeapon()
end

function PLAYER:CalcView(view)
  view.origin = self.Player:EyePos() - view.angles:Forward() * 100
  view.drawviewer = true

  return view
end

function PLAYER:ShouldDrawLocalPlayer()
  return true
end

function PLAYER:StartMove(move, cmd)
  cmd:ClearMovement()
	cmd:ClearButtons()
end

player_manager.RegisterClass('player_rascal', PLAYER, 'player_default')