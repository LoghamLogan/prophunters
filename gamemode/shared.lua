/**
	Original gamemode created by MechanicalMind.
	Updated with new features by Logham.
**/
GM.Name 	  = "PKML Prophunters"
GM.Author 	= "Logham"
GM.Email 	  = "prophunt@sojusoft.dev"
GM.Website 	= "https://twitter.com/_logham"
GM.Version 	= "1.5"

team.SetUp(1, "Spectators", Color(120, 120, 120))
team.SetUp(2, "Hunters", Color(255, 150, 50))
team.SetUp(3, "Props", Color(50, 150, 255))

function GM:ShouldCollide(ent1, ent2)
	if !IsValid(ent1) then return true end
	if !IsValid(ent2) then return true end

	return true
end

function GM:PlayerSetNewHull(ply, s, hullz, duckz)
	self:PlayerSetHull(ply, s, s, hullz, duckz)
end

function GM:PlayerSetHull(ply, hullx, hully, hullz, duckz)
	hullx = hullx or 16
	hully = hully or 16
	hullz = hullz or 72
	duckz = duckz or hullz / 2
	ply:SetHull(Vector(-hullx, -hully, 0), Vector(hullx, hully, hullz))
	ply:SetHullDuck(Vector(-hullx, -hully, 0), Vector(hullx, hully, duckz))

	if SERVER then
		net.Start("hull_set")
		net.WriteEntity(ply)
		net.WriteFloat(hullx)
		net.WriteFloat(hully)
		net.WriteFloat(hullz)
		net.WriteFloat(duckz)
		net.Broadcast()
		// TODO send on player spawn
	end
end
