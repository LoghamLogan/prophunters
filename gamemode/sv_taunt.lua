include("sh_taunt.lua")

util.AddNetworkString("open_taunt_menu")
util.AddNetworkString("hunter_force_prop_taunt")

concommand.Add("ph_taunt", function (ply, com, args, full)
	if !IsValid(ply) then
		return
	end
	local snd = args[1] or ""
	ply:Taunt(snd)
end)

concommand.Add("ph_taunt_random", function (ply, com, args, full)
	if !IsValid(self) then
		return
	end
	ply:DoRandomTaunt()
end)

concommand.Add("ph_hunter_force_prop_taunt", function (ply, com, args, full)
	if !IsValid(self) then
		return
	end
	ply:UseHunterForcePropTauntSkill()
end)



////////////////


concommand.Add("ph_bet", function (ply, com, args, full)
	if !IsValid(ply) then
		return
	end

	if args[1] == nil then
		return
	end

	if args[2] == nil then
		return
	end

	local team   = args[1]
	local amount = args[2]
	Bet(ply, team, amount)

end)

function Bet(ply, team, amount)

	PrintMessage(HUD_PRINTTALK, ply:GetName() .. " has bet " .. amount .. " on team " .. team)

end

function starts_with(str, start)
   return str:sub(1, #start) == start
end

function mysplit (inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end

function GM:PlayerSay(ply, text, teamChat)

	if ( starts_with(text, "bet") || starts_with(text, "!bet") || starts_with(text, "/bet") ) then

		local team = "props"
		local amount = "ALL"

		local split = mysplit(text, " ")
		for k, str in ipairs(split) do
			if k == 2 then
				team = str
			end
			if k == 3 then
				amount = str
			end
		end

		Bet(ply, team, amount)

	end

	return text

end
