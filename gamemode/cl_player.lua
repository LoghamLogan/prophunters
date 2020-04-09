local PlayerMeta = FindMetaTable("Player")

function GM:GetMoney()
	return self.Money or 0
end

net.Receive("heist_money", function (len)
	local prev = GAMEMODE.Money
	GAMEMODE.Money = net.ReadDouble()
	if prev && prev < GAMEMODE.Money then
		if GAMEMODE.MoneyNotifTime && GAMEMODE.MoneyNotifTime + 3 > CurTime() then
			GAMEMODE.MoneyNotif = GAMEMODE.MoneyNotif + GAMEMODE.Money - prev
			GAMEMODE.MoneyNotifTime = CurTime()
		else
			GAMEMODE.MoneyNotif = GAMEMODE.Money - prev
			GAMEMODE.MoneyNotifTime = CurTime()
		end
	end
end)

function GM:PlayerFootstep(ply, pos, foot, sound, volume, filter )
	if ply:GetHunterSilence() && GAMEMODE.GameState == 1 then
	 	return true
	end
	return false
end

function PlayerMeta:GetForceTauntSkillCount()
	return self:GetNWInt("forcetauntskillcount", 0)
end

function PlayerMeta:GetHunterSilence()
	return self:GetNWBool("deafenhunters", false)
end

function PlayerMeta:SetHunterSilence(value)
	return self:SetNWBool("deafenhunters", value)
end

function GM:FinishMove( ply, mv )

	if ply:GetNWBool("PropIsFrozen") then		
		return true
	end

	-- Don't do the default
	return false

end
