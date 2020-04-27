
local PlayerMeta = FindMetaTable("Player")

function PlayerMeta:SetHMaxHealth(amo)
	self.HMaxHealth = amo
	self:SetNWFloat("HMaxHealth", amo)
	self:SetMaxHealth(amo)
end

function PlayerMeta:GetHMaxHealth()
	return self.HMaxHealth or 100
end

hook.Add( "EntityTakeDamage", "NegateFallDamage", function( target, dmginfo )
	if ( target:IsPlayer() and dmginfo:IsFallDamage() ) then
		print(target:Team())
		if ( target:Team() == 2 && GAMEMODE.HuntersTakeFallDamage:GetBool() ) then
			return
		end
		if ( target:Team() == 3 && GAMEMODE.PropsTakeFallDamage:GetBool() ) then
			return
		end
		dmginfo:ScaleDamage(0) // negate fall damage
	end
end )
