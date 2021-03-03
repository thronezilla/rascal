AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true
ENT.AttackRange = 50
ENT.XP = 1
ENT.ATKINFO = {type='atk_phys', dmg=5}

function ENT:Initialize()

	self:SetModel( "models/antlion.mdl" )
	self:SetModelScale(0.5)
	self.LoseTargetDist	= 2000
	self.SearchRadius 	= 1000
	
end

function ENT:SetEnemy(ent)
	self.Enemy = ent
end
function ENT:GetEnemy()
	return self.Enemy
end

function ENT:GetXP()
  return self.XP
end

function ENT:HaveEnemy()
	if ( self:GetEnemy() and IsValid(self:GetEnemy()) ) then
		if ( self:GetRangeTo(self:GetEnemy():GetPos()) > self.LoseTargetDist ) then
			return self:FindEnemy()
		elseif ( self:GetEnemy():IsPlayer() and !self:GetEnemy():Alive() ) then
			return self:FindEnemy()
		end	
		return true
	else
		return self:FindEnemy()
	end
end

function ENT:FindEnemy()
	local _ents = ents.FindInSphere( self:GetPos(), self.SearchRadius )
	for k,v in ipairs( _ents ) do
		if ( v:IsPlayer() ) then
			self:SetEnemy(v)
			return true
		end
	end	
	self:SetEnemy(nil)
	return false
end

function ENT:RunBehaviour()
	while ( true ) do
		if ( self:HaveEnemy() ) then
      self.loco:FaceTowards(self:GetEnemy():GetPos())

      local d = self:GetPos():Distance(self:GetEnemy():GetPos())

      if d < self.AttackRange then --TODO: make this more dark soulsy (?)
        local dmg = DamageInfo()
        dmg:SetDamage( self.ATKINFO.dmg )
        dmg:SetAttacker( self )
        dmg:SetDamageType( DMG_SLASH ) 
      
        timer.Create('rascal_ant_attack', 0.5, 1, function() self:GetEnemy():TakeDamageInfo( dmg ) end)

        self:StartActivity( ACT_MELEE_ATTACK1 )
        self:PlaySequenceAndWait( "attack1")
      else
			  self:StartActivity( ACT_RUN )
			  self.loco:SetDesiredSpeed( 450 )
			  self.loco:SetAcceleration(900)
			  self:ChaseEnemy( )
			  self.loco:SetAcceleration(400)
			  self:StartActivity( ACT_IDLE )
      end
		else
			self:StartActivity( ACT_WALK )
			self.loco:SetDesiredSpeed( 200 )
			self:MoveToPos( self:GetPos() + Vector( math.Rand( -1, 1 ), math.Rand( -1, 1 ), 0 ) * 400 )
			self:StartActivity( ACT_IDLE )
		end
	end

end	

function ENT:LootXP(atkr)
  if SERVER then 
			print(atkr:SteamID())
			rascal.player_data[atkr:SteamID()].xp = rascal.player_data[atkr:SteamID()].xp + self.XP 
	end
end

function ENT:OnKilled(dmginfo)
  hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )

  local atkr = dmginfo:GetAttacker()

  if SERVER and atkr and atkr:IsValid() and atkr:IsPlayer() then
    self:LootXP(atkr)
  end

  self:BecomeRagdoll(dmginfo)

	net.Start('rascal_setup')
	net.WriteTable(rascal.player_data[atkr:SteamID()])
	net.Send(atkr)

	rascal.TryLevel(atkr:SteamID())
end

function ENT:ChaseEnemy( options )

	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 300 )
	path:SetGoalTolerance( options.tolerance or 20 )
	path:Compute( self, self:GetEnemy():GetPos() )

	if ( !path:IsValid() ) then return "failed" end

	while ( path:IsValid() and self:HaveEnemy() and self:GetPos():Distance(self:GetEnemy():GetPos()) > self.AttackRange ) do
	
		if ( path:GetAge() > 0.1 ) then
			path:Compute(self, self:GetEnemy():GetPos())
		end
		path:Update( self )
		
		if ( options.draw ) then path:Draw() end

		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()

	end

	return "ok"

end