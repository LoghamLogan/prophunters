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

function PlayerMeta:GetAutoTauntAdditive()
	return self:GetNWBool("AutoTauntAdditive", false)
end

function PlayerMeta:GetCurrentTauntLength()
	return self:GetNWInt("CurrentTauntLength", 0)
end

function PlayerMeta:GetAutoTauntEnabled(value)
		return self:GetNWBool("AutoTauntEnabled", false)
end

function PlayerMeta:GetAutoTauntMin()
		return self:GetNWInt("AutoTauntTimeMin", 0)
end

function PlayerMeta:GetAutoTauntMax()
		return self:GetNWInt("AutoTauntTimeMax", 0)
end

function PlayerMeta:GetAutoTauntRerolling()
		return self:GetNWBool("AutoTauntRerolling", false)
end

function PlayerMeta:GetAutoTauntShowBar()
	return self:GetNWBool("AutoTauntShowBar", false)
end

function PlayerMeta:GetLastRandomTauntTime()
	return self:GetNWInt("LastRandomTauntTime", 0)
end

function PlayerMeta:GetNextRandomTauntTime()
	return self:GetNWInt("NextRandomTauntTime", 0)
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
