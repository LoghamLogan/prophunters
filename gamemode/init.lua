AddCSLuaFile("shared.lua")

local rootFolder = (GM or GAMEMODE).Folder:sub(11) .. "/gamemode/"

// add cs lua all the cl_ or sh_ files
local files, dirs = file.Find(rootFolder .. "*", "LUA")
for k, v in pairs(files) do
	if v:sub(1,3) == "cl_" || v:sub(1,3) == "sh_" then
		AddCSLuaFile(rootFolder .. v)
	end
end


include("shared.lua")
include("sv_ragdoll.lua")
include("sv_chattext.lua")
include("sv_playercolor.lua")
include("sv_player.lua")
include("sv_realism.lua")
include("sv_rounds.lua")
include("sv_spectate.lua")
include("sv_respawn.lua")
include("sv_health.lua")
include("sh_weightedrandom.lua")
include("sv_killfeed.lua")
include("sv_statistics.lua")
include("sv_bot.lua")
include("sv_disguise.lua")
include("sv_teams.lua")
include("sv_taunt.lua")
include("sv_mapvote.lua")
include("sv_bannedmodels.lua")
include("sv_version.lua")


util.AddNetworkString("clientIPE")
util.AddNetworkString("mb_openhelpmenu")
util.AddNetworkString("player_model_sex")

resource.AddFile("materials/melonbomber/skull.png")
resource.AddFile("materials/melonbomber/skull_license.txt")

// Misc Game settings
GM.StartWaitTime             = CreateConVar("ph_mapstartwait", 30, bit.bor(FCVAR_NOTIFY), "Number of seconds to wait for players on map start before starting round" )
GM.DeadSpectateRoam          = CreateConVar("ph_dead_canroam", 0, bit.bor(FCVAR_NOTIFY), "Can dead players use the roam spectate mode" )

// Voices
GM.VoiceHearTeam             = CreateConVar("ph_voice_hearotherteam", 0, bit.bor(FCVAR_NOTIFY), "Can we hear the voices of opposing teams" )
GM.VoiceHearDead             = CreateConVar("ph_voice_heardead", 1, bit.bor(FCVAR_NOTIFY), "Can we hear the voices of dead players and spectators" )

// Round settings
GM.RoundLimit                = CreateConVar("ph_roundlimit", 10, bit.bor(FCVAR_NOTIFY), "Number of rounds before mapvote" )
GM.RoundHideTime             = CreateConVar("ph_hidetime", 30, bit.bor(FCVAR_NOTIFY), "Number of seconds before hunters are released" )

// Hunter settings
GM.HunterDamagePenalty       = CreateConVar("ph_hunter_dmgpenalty", 3, bit.bor(FCVAR_NOTIFY), "Amount of damage a hunter should take for shooting an incorrect prop" )
GM.HunterGrenadeAmount       = CreateConVar("ph_hunter_smggrenades", 1, bit.bor(FCVAR_NOTIFY), "Amount of SMG grenades hunters should spawn with" )
GM.HunterDeafenAtStart	     = CreateConVar("ph_hunter_deafen_start", 1, bit.bor(FCVAR_NOTIFY), "Deafen the hunters while the props are hiding")
GM.HunterSkillForceTauntAmmo = CreateConVar("ph_hunter_forcetauntskill_amount", 1, bit.bor(FCVAR_NOTIFY), "Amount of times a hunter can press F4 to force the closest prop to taunt (0 to disable)")
GM.HunterAllowPickup         = CreateConVar("ph_hunter_pickup_allow", 0, bit.bor(FCVAR_NOTIFY), "Allow hunters to pickup props with the 'use' key" )
GM.HuntersTakeFallDamage     = CreateConVar("ph_hunter_falldamage", 0, bit.bor(FCVAR_NOTIFY), "Are hunters effected by fall damage?" )

// Prop settings
GM.PropsWinStayProps         = CreateConVar("ph_props_onwinstayprops", 0, bit.bor(FCVAR_NOTIFY), "If the props win, they stay on the props team" )
GM.PropsSmallSize            = CreateConVar("ph_props_small_size", 200, bit.bor(FCVAR_NOTIFY), "Size that speed penalty for small size starts to apply (0 to disable)" )
GM.PropsJumpPower            = CreateConVar("ph_props_jumppower", 2, bit.bor(FCVAR_NOTIFY), "Jump power bonus for when props are disguised" )
GM.PropsCamDistance          = CreateConVar("ph_props_camdistance", 1, bit.bor(FCVAR_NOTIFY), "The camera distance multiplier for props when disguised")
GM.PropsAllowPickup          = CreateConVar("ph_props_pickup_allow", 1, bit.bor(FCVAR_NOTIFY), "Allow props to pickup props with the 'use' key" )
GM.PropsTakeFallDamage       = CreateConVar("ph_props_falldamage", 0, bit.bor(FCVAR_NOTIFY), "Are props effected by fall damage?" )

// Auto-taunt related
GM.AutoTauntEnabled          = CreateConVar("ph_autotaunt_enabled", 1, bit.bor(FCVAR_NOTIFY), "Enable random prop taunting (0 to disable)")
GM.AutoTauntTimeMin          = CreateConVar("ph_autotaunt_min", 30, bit.bor(FCVAR_NOTIFY), "Minimum time for random taunt")
GM.AutoTauntTimeMax          = CreateConVar("ph_autotaunt_max", 90, bit.bor(FCVAR_NOTIFY), "Maximum time for random taunt")
GM.AutoTauntRerolling        = CreateConVar("ph_autotaunt_rerolling", 1, bit.bor(FCVAR_NOTIFY), "Does taunting re-roll the auto taunt timer?" )
GM.AutoTauntShowBar          = CreateConVar("ph_autotaunt_showbar", 1, bit.bor(FCVAR_NOTIFY), "Displays the auto taunt progress bar to props" )
GM.AutoTauntAdditive         = CreateConVar("ph_autotaunt_additive", 1, bit.bor(FCVAR_NOTIFY), "Add the duration of a played taunt to the auto taunt timer" )
GM.AutoTauntAdditiveMulti    = CreateConVar("ph_autotaunt_additive_multiplier", 2, bit.bor(FCVAR_NOTIFY), "Multiplier for the taunt duration when adding time to the auto taunt timer" )

// cvar hooks
cvars.AddChangeCallback("ph_autotaunt_additive", function(cvarName, valueOld, valueNew)
	for k, ply in pairs(player.GetAll()) do
		ply:SetAutoTauntAdditive(valueNew)
	end
end)
cvars.AddChangeCallback("ph_autotaunt_enabled", function(cvarName, valueOld, valueNew)
	for k, ply in pairs(player.GetAll()) do
		ply:SetAutoTauntEnabled(valueNew)
	end
end)
cvars.AddChangeCallback("ph_autotaunt_min", function(cvarName, valueOld, valueNew)
	for k, ply in pairs(player.GetAll()) do
		ply:SetAutoTauntTimeMin(valueNew)
	end
end)
cvars.AddChangeCallback("ph_autotaunt_max", function(cvarName, valueOld, valueNew)
	for k, ply in pairs(player.GetAll()) do
		ply:SetAutoTauntTimeMax(valueNew)
	end
end)
cvars.AddChangeCallback("ph_autotaunt_rerolling", function(cvarName, valueOld, valueNew)
	for k, ply in pairs(player.GetAll()) do
		ply:SetAutoTauntRerolling(valueNew)
	end
end)
cvars.AddChangeCallback("ph_autotaunt_showbar", function(cvarName, valueOld, valueNew)
	for k, ply in pairs(player.GetAll()) do
		ply:SetAutoTauntShowBar(valueNew)
	end
end)

function GM:Initialize()
	self.RoundWaitForPlayers = CurTime()

	self.DeathRagdolls = {}
	self:SetupStatisticsTables()
	self:LoadMapList()
	self:LoadBannedModels()
end

function GM:InitPostEntity()
	self:CheckForNewVersion()
	self:InitPostEntityAndMapCleanup()

	RunConsoleCommand("mp_show_voice_icons", "0")
end

function GM:InitPostEntityAndMapCleanup()
	self:RemoveBannedModelProps()
	for k, ent in pairs(ents.GetAll()) do
		if ent:GetClass():find("door") then
			ent:Fire("unlock","",0)
		end
		if ent:IsDisguisableAs() then
			-- ent:DrawShadow(false)
		end
	end
end

function GM:Think()
	self:RoundsThink()
	self:SpectateThink()
end

function GM:ShutDown()
end

function GM:AllowPlayerPickup( ply, ent )
	if ply:Team() == 3 then
		return self.PropsAllowPickup:GetBool()
	end
	return self.HunterAllowPickup:GetBool()
end

function GM:PlayerNoClip( ply )
	timer.Simple(0, function () ply:CalculateSpeed() end)
	return ply:IsSuperAdmin() || ply:GetMoveType() == MOVETYPE_NOCLIP
end

function GM:OnEndRound()

end

function GM:OnStartRound()

end

function GM:EntityTakeDamage( ent, dmginfo )
	if IsValid(ent) then
		if ent:IsPlayer() then
			if IsValid(dmginfo:GetAttacker()) then
				local attacker = dmginfo:GetAttacker()
				if attacker:IsPlayer() then
					if attacker:Team() == ent:Team() then
						return true
					end
				end
			end
		end
		if ent:IsDisguisableAs() then
			local att = dmginfo:GetAttacker()
			if IsValid(att) && att:IsPlayer() && att:Team() == 2 then

				if bit.band(dmginfo:GetDamageType(), DMG_CRUSH) != DMG_CRUSH then
					local tdmg = DamageInfo()
					tdmg:SetDamage(math.min(dmginfo:GetDamage(), math.max(self.HunterDamagePenalty:GetInt(), 1) ))
					tdmg:SetDamageType(DMG_AIRBOAT)

					-- tdmg:SetAttacker(ent)
					-- tdmg:SetInflictor(ent)

					tdmg:SetDamageForce(Vector(0, 0, 0))
					att:TakeDamageInfo(tdmg)

					// increase stat for end of round (Angriest Hunter)
					att.PropDmgPenalty = (att.PropDmgPenalty or 0) + tdmg:GetDamage()
				end
			end
		end
	end
end

function file.ReadDataAndContent(path)
	local f = file.Read(path, "DATA")
	if f then return f end
	f = file.Read(GAMEMODE.Folder .. "/content/data/" .. path, "GAME")
	return f
end

function GM:OnReloaded()
end

function GM:CleanupMap()
	game.CleanUpMap()
	hook.Call("InitPostEntityAndMapCleanup", self)
	hook.Call("MapCleanup", self)
end

function GM:ShowHelp(ply)
	net.Start("mb_openhelpmenu")
	net.Send(ply)
end

function GM:ShowSpare1(ply)
	net.Start("open_taunt_menu")
	net.Send(ply)
end

function GM:ShowSpare2(ply)
	if ply:Team() == 2 then
		ply:UseHunterForcePropTauntSkill()
	end
	if ply:Team() == 3 then
		ply:DoRandomTaunt()
	end
end
