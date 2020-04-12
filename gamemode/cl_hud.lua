

local function createRoboto(s)
	surface.CreateFont( "RobotoHUD-" .. s , {
		font = "Roboto-Bold",
		size = math.Round(ScrW() / 1000 * s),
		weight = 700,
		antialias = true,
		italic = false
	})
	surface.CreateFont( "RobotoHUD-L" .. s , {
		font = "Roboto",
		size = math.Round(ScrW() / 1000 * s),
		weight = 500,
		antialias = true,
		italic = false
	})
end

for i = 5, 50, 5 do
	createRoboto(i)
end
createRoboto(8)

function draw.ShadowText(n, f, x, y, c, px, py, shadowColor)
	draw.SimpleText(n, f, x + 1, y + 1, shadowColor or color_black, px, py)
	draw.SimpleText(n, f, x, y, c, px, py)
end

function draw.EasyPNG(path, x, y, w, h, col)
	surface.SetMaterial(Material(path, "noclamp"))
	if col then
		surface.SetDrawColor(col.r, col.g, col.b, col.a)
	else
		surface.SetDrawColor(255, 255, 255, 255)
	end
	surface.DrawTexturedRect(x, y, w, h)
end

local function translate(name)
	if name == "weapon_physcannon" then return "Gravity Gun" end
	return language.GetPhrase(name)
end

function GM:HUDPaint()
	if LocalPlayer():Alive() then
		if LocalPlayer():Team() == 2 then
			//DrawSkillAmmo()
		end
	end
	-- self:DrawMoney()
	self:DrawGameHUD()
	-- DebugInfo(1, tostring(LocalPlayer():GetVelocity():Length()))

	self:DrawRoundTimer()
	self:DrawKillFeed()
end

local helpKeysProps = {
	{"attack", "Disguise as prop"},
	{"menu_context", "Lock prop rotation"},
	{"reload", "Freeze in place"},
	{"gm_showspare1", "Taunt"},
	{"gm_showspare2", "Random Taunt"}
}

local function keyName(str)
	str = input.LookupBinding(str)
	return str:upper()
end

function GM:DrawGameHUD()
	if LocalPlayer():Alive() then
	end

	local ply = LocalPlayer()
	if self:IsCSpectating() && IsValid(self:GetCSpectatee()) && self:GetCSpectatee():IsPlayer() then
		ply = self:GetCSpectatee()
	end
	self:DrawHealth(ply)

	// taunt bar
	local showTauntBar = util.tobool(ply:GetAutoTauntEnabled()) && util.tobool(ply:GetAutoTauntShowBar())
	if showTauntBar && ply:Team() == 3 then
		self:DrawTauntBar(ply)
	end

	if ply != LocalPlayer() then
		local col = ply:GetPlayerColor()
		col = Color(col.r * 255, col.y * 255, col.z * 255)
		draw.ShadowText(ply:Nick(), "RobotoHUD-30", ScrW() / 2, ScrH() - 4, col, 1, 4)
	end


	local tr = ply:GetEyeTraceNoCursor()

	local shouldDraw = hook.Run("HUDShouldDraw", "PropHuntersPlayerNames")
	if shouldDraw != false then
		// draw names
		if IsValid(tr.Entity) && tr.Entity:IsPlayer() && tr.HitPos:Distance(tr.StartPos) < 500 then
			// hunters can only see their teams names
			if ply:Team() != 2 || ply:Team() == tr.Entity:Team() then
				self.LastLooked = tr.Entity
				self.LookedFade = CurTime()
			end
		end
		if IsValid(self.LastLooked) && self.LookedFade + 2 > CurTime() then
			local name = self.LastLooked:Nick() or "error"
			local col = self.LastLooked:GetPlayerColor() or Vector()
			col = Color(col.x * 255, col.y * 255, col.z * 255)
			col.a = (1 - (CurTime() - self.LookedFade) / 2) * 255
			draw.ShadowText(name, "RobotoHUD-20", ScrW() / 2, ScrH() / 2 + 80, col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, Color(0, 0, 0, col.a))
		end
	end


	local help
	if LocalPlayer():Alive() then
		if LocalPlayer():Team() == 3 then
			if self:GetGameState() == 1 || (self:GetGameState() == 2 && !LocalPlayer():IsDisguised()) then
				help = helpKeysProps
			end
		end
	end



	if help then
		local fh = draw.GetFontHeight("RobotoHUD-L15")
		local w, h = math.ceil(ScrW() * 0.09), #help * fh
		local x = 20
		local y = ScrH() / 2 - h / 2

		local i = 0
		local tw = 0
		for k, t in pairs(help) do
			surface.SetFont("RobotoHUD-15")
			local name = keyName(t[1])
			local w,h = surface.GetTextSize(name)
			tw = math.max(tw, w)
		end
		for k, t in pairs(help) do
			surface.SetFont("RobotoHUD-15")
			local name = keyName(t[1])
			local w,h = surface.GetTextSize(name)
			draw.ShadowText(name, "RobotoHUD-15", x + tw / 2, y + i * fh, color_white, 1, 0)
			draw.ShadowText(t[2], "RobotoHUD-L15", x + tw + 10, y + i * fh, color_white, 0, 0)
			i = i + 1
		end
	end
end


local tex = surface.GetTextureID("mech/ring")
local ringThin = surface.GetTextureID("mech/ring_thin")
local matWhite = Material( "model_color" )
local rt_Store = render.GetScreenEffectTexture( 0 )
local mat_Copy = Material( "pp/copy" )

local polyTex = surface.GetTextureID("VGUI/white.vmt")

local function drawPoly(x, y, w, h, percent)
	local points = 40

	if percent > 0.5 then
		local vertexes = {}
		local hpoints = points / 2
		local base = math.pi * 1.5
		local mul = 1 / hpoints * math.pi
		for i = (1 - percent) * 2 * hpoints, hpoints do
			table.insert(vertexes, {x = x + w / 2 + math.cos(i * mul + base) * w / 2, y = y + h / 2 + math.sin(i * mul + base) * h / 2})
		end
		table.insert(vertexes, {x = x + w / 2, y = y + h})
		table.insert(vertexes, {x = x + w / 2, y = y + h / 2})

		-- for i = 1, #vertexes do draw.DrawText(i, "Default", vertexes[i].x, vertexes[i].y, color_white, 0) end

		surface.SetTexture(polyTex)
		surface.DrawPoly(vertexes)
	end

	local vertexes = {}
	local hpoints = points / 2
	local base = math.pi * 0.5
	local mul = 1 / hpoints * math.pi
	local p = 0
	if percent < 0.5 then
		p = (1 - percent * 2 )
	end
	for i = p * hpoints, hpoints do
		table.insert(vertexes, {x = x + w / 2 + math.cos(i * mul + base) * w / 2, y = y + h / 2 + math.sin(i * mul + base) * h / 2})
	end
	table.insert(vertexes, {x = x + w / 2, y = y})
	table.insert(vertexes, {x = x + w / 2, y = y + h / 2})

	-- for i = 1, #vertexes do draw.DrawText(i, "Default", vertexes[i].x, vertexes[i].y, color_white, 0) end

	surface.SetTexture(polyTex)
	surface.DrawPoly(vertexes)
end

function GetTauntBarPercentage01(ply)

	local roundTime = GAMEMODE:GetStateRunningTime()
	if roundTime <= 0 then
		return 0
	end
	//local lastTauntTime = ply:GetLastRandomTauntTime()
	//if lastTauntTime <= 0 then
	//	return 1
	//end
	local randTime = ply:GetNextRandomTauntTime()
	if randTime <= 0 then
		return 0
	end

	local maxAutoTauntTime = ply:GetAutoTauntMax()

	local totalTime = maxAutoTauntTime
	local timeUntil = randTime - roundTime
	local percentage = timeUntil / totalTime;

	return math.Clamp(percentage, 0, 1)

end

local lastTauntAmount
local lastTauntLength

function GM:DrawTauntBar(ply)

	local barHeight = 40
	local barWidth = math.ceil(ScrW() * 0.6)

	local xPos = (ScrW() / 2) - (barWidth / 2)
	local yPos = ScrH() - barHeight - (ScrH() * 0.08)

	local rerollingEnabled = util.tobool(ply:GetAutoTauntRerolling())
	local additiveTauntEnabled = util.tobool(ply:GetAutoTauntAdditive())

	if GAMEMODE.GameState == 2 then

		local isTaunting = ply:GetLastRandomTauntTime() > GAMEMODE:GetStateRunningTime()
		local timeUntilTaunt = ply:GetNextRandomTauntTime() - GAMEMODE:GetStateRunningTime()
		local minAutoTauntTime = ply:GetAutoTauntMin()
		local maxAutoTauntTime = ply:GetAutoTauntMax()
		local diff = maxAutoTauntTime - minAutoTauntTime

		local xFillEndPercentage01 = GetTauntBarPercentage01(ply)
		local fillWidth = math.max(barWidth * xFillEndPercentage01, 1)

		if !isTaunting then
			lastTauntAmount = fillWidth
		else
			lastTauntAmount = lastTauntAmount or 0
			local currentTauntLength = ply:GetCurrentTauntLength()
			local startOfTauntTime   = ply:GetLastRandomTauntTime() - currentTauntLength
			local endOfTauntTime     = ply:GetLastRandomTauntTime()

			local deltaTime = ((GAMEMODE:GetStateRunningTime() - startOfTauntTime)) / (endOfTauntTime - startOfTauntTime)
			local newFill   = (deltaTime * (fillWidth - lastTauntAmount)) + lastTauntAmount

			fillWidth = newFill
		end

		if xFillEndPercentage01 > 0 then

			// Draw min line
			local pixelsPerSecond = barWidth / maxAutoTauntTime
			local minLineXPos     = xPos + (minAutoTauntTime * pixelsPerSecond)
			local mediumLineXPos  = xPos + (minAutoTauntTime * pixelsPerSecond) + ((diff * 0.20) * pixelsPerSecond)
			local maxLineXPos     = xPos + (maxAutoTauntTime * pixelsPerSecond)

			local minLineWidth = minLineXPos - xPos
			local medLineWidth = mediumLineXPos - xPos

			surface.SetDrawColor(255, 255, 100, 255)
			surface.DrawRect(minLineXPos - 5, yPos - 8, 9, 8)
			surface.DrawRect(minLineXPos - 5, yPos + barHeight, 9, 8)

			surface.SetDrawColor(255, 0, 0, 255)
			surface.DrawRect(minLineXPos-3, yPos - 5, 5, barHeight + 10)
			//draw.SimpleText("MIN", "RobotoHUD-10", minLineXPos, yPos + (barHeight / 2), color_white, 1, 1)

			// Draw inner bar
			if fillWidth < minLineWidth then
				surface.SetDrawColor(220, 0, 0, 180)
			elseif fillWidth < medLineWidth then
				surface.SetDrawColor(220, 220, 0, 180)
			else
				surface.SetDrawColor(0, 120, 0, 180)
			end
			surface.DrawRect(xPos, yPos, fillWidth, barHeight)

			//surface.SetDrawColor(0, 200, 0, 180)
			//surface.DrawRect(maxLineXPos, yPos, 10, barHeight)
			//draw.SimpleText("MAX", "RobotoHUD-10", maxLineXPos, yPos + (barHeight / 2), color_white, 1, 1)

		end

		DrawAutoTauntBG(xPos, yPos, fillWidth, barWidth, barHeight, timeUntilTaunt)

		local barText = string.format("auto taunt in %s seconds", math.Round(timeUntilTaunt))
		if isTaunting then
			barText = "currently taunting"
		end
		DrawAutoTauntBarText(barText, yPos, barHeight)
		DrawAutoTauntBarInfoText(yPos, barHeight, rerollingEnabled, additiveTauntEnabled, minAutoTauntTime)
		DrawAutoTauntBarScale(xPos, yPos, barWidth, barHeight, minAutoTauntTime, maxAutoTauntTime)

	else // not gamestate 2

		local minAutoTauntTime = ply:GetAutoTauntMin()
		DrawAutoTauntBG(xPos, yPos, 0, barWidth, barHeight, 0)
		DrawAutoTauntBarText("waiting...", yPos, barHeight)
		DrawAutoTauntBarInfoText(yPos, barHeight, rerollingEnabled, additiveTauntEnabled, minAutoTauntTime)

	end

end

function DrawAutoTauntBarScale(xPos, yPos, barWidth, barHeight, minAutoTauntTime, maxAutoTauntTime)

	local pixelsPerSecond = barWidth / maxAutoTauntTime
	local minLineXPos     = xPos + (minAutoTauntTime * pixelsPerSecond)
	local maxLineXPos     = xPos + (maxAutoTauntTime * pixelsPerSecond)
	// Draw seconds text
	draw.ShadowText("0", "RobotoHUD-5", xPos, yPos + barHeight, color_white, 1, 1)
	draw.ShadowText(minAutoTauntTime, "RobotoHUD-5", minLineXPos, yPos + barHeight + 12, color_white, 1, 1)
	draw.ShadowText(maxAutoTauntTime, "RobotoHUD-5", maxLineXPos, yPos + barHeight, color_white, 1, 1)

end

function DrawAutoTauntBarText(barText, yPos, barHeight)

	// Draw seconds text
	local centerBarXPos = (ScrW() / 2)
	local centerBarYPos = yPos + (barHeight / 2)
	draw.ShadowText(barText, "RobotoHUD-15", centerBarXPos, centerBarYPos, color_white, 1, 1)

end

function DrawAutoTauntBG(xPos, yPos, fillWidth, barWidth, barHeight)

	// Draw BG bar
	local bgBarXPos  = xPos + fillWidth
	local bgBarWidth = barWidth - fillWidth
	surface.SetDrawColor(50, 50, 50, 180)
	surface.DrawRect(bgBarXPos, yPos, bgBarWidth, barHeight)
end


function DrawAutoTauntBarInfoText(yPos, barHeight, rerollingEnabled, additiveTauntEnabled, minAutoTauntTime)

	local centerBarXPos = (ScrW() / 2)
	local centerBarYPos = yPos + (barHeight / 2)
	if rerollingEnabled then
		local tauntKey1 = input.LookupBinding("gm_showspare1")
		local tauntKey2 = input.LookupBinding("gm_showspare2")
		if additiveTauntEnabled then
			draw.ShadowText("(".. tauntKey1 ..") taunts increase auto-taunt bar by their duration.", "RobotoHUD-10", centerBarXPos, centerBarYPos + 50, color_white, 1, 1)
		end
		draw.ShadowText("(".. tauntKey2 ..") random taunts set the auto-taunt bar to a random position (above "..minAutoTauntTime.." seconds).", "RobotoHUD-10", centerBarXPos, centerBarYPos + 80, color_white, 1, 1)
	end

end

function GM:DrawHealth(ply)

	local client = LocalPlayer()

	local x = 20
	local w,h = math.ceil(ScrW() * 0.09), 80
	h = w
	local y = ScrH() - 20 - h

	local ps = 0.05

	surface.SetDrawColor(50, 50, 50, 180)
	drawPoly(x, y, w, h, 1)

	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilZFailOperation( STENCILOPERATION_KEEP )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_ALWAYS )
	render.SetStencilWriteMask( 1 )
	render.SetStencilTestMask( 1 )
	render.SetStencilReferenceValue( 1 )

	render.SetBlend( 0 )

	render.OverrideDepthEnable( true, false )
	-- render.SetMaterial(matWhite)
	-- render.DrawScreenQuadEx(tx, ty, tw, th)

	surface.SetDrawColor(26, 120, 245, 1)
	drawPoly(x + w * ps, y + h * ps, w * (1 - 2 * ps), h * (1 - 2 * ps), 1)

	render.SetStencilEnable( true );
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )
	render.SetStencilPassOperation( STENCILOPERATION_REPLACE )
	render.SetStencilReferenceValue( 1 )

	local health = ply:Health()
	local maxhealth = math.max(health, ply:GetHMaxHealth())

	local nh = math.Round((h - ps * 2) * math.Clamp(health / maxhealth, 0, 1))
	local tcol = table.Copy(team.GetColor(ply:Team()))
	tcol.a = 150
	surface.SetDrawColor(tcol)
	surface.DrawRect(x, y + h - ps - nh, w, nh)

	draw.ShadowText(math.Round(health) .. "", "RobotoHUD-25", x + w / 2, y + h / 2, color_white, 1, 1)


	render.SetStencilEnable( false )

	render.SetStencilWriteMask( 0 );
		render.SetStencilReferenceValue( 0 );
		render.SetStencilTestMask( 0 );
		render.SetStencilEnable( false )
		render.OverrideDepthEnable( false )
		render.SetBlend( 1 )

		cam.IgnoreZ( false )

	local fg = draw.GetFontHeight("RobotoHUD-15")
	if ply:IsDisguised() && ply:DisguiseRotationLocked() then
		draw.ShadowText("ROTATION", "RobotoHUD-15", x + w + 20, y + h / 2 - fg / 2, color_white, 0, 1)
		draw.ShadowText("LOCKED", "RobotoHUD-15", x + w + 20, y + h / 2 + fg / 2, color_white, 0, 1)
	end

	if ply:Team() == 2 then
		local skillAmt = ply:GetForceTauntSkillCount()
		local key = input.LookupBinding("gm_showspare2");
		draw.ShadowText(string.format("(%s) Force Prop Taunt: %s left", key, skillAmt), "RobotoHUD-15", x + w + 20, y + h / 2 - fg / 2, color_white, 0, 1)
	end

end

function GM:DrawMoney()

	local x = 20 + 8
	local w, h = 0, draw.GetFontHeight("RobotoHUD-25")
	local y = ScrH() - 20 - math.ceil(ScrW() * 0.09) - 20 - h

	surface.SetFont("RobotoHUD-20")
	local tw, th = surface.GetTextSize("000000")

	surface.SetFont("RobotoHUD-25")
	local dw, dh = surface.GetTextSize("$")
	local gap = 4

	w = dw + gap + tw

	local dull = 220
	local dulla = 90

	surface.SetFont("RobotoHUD-25")
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(x, y + h / 2 - dh / 2 - 3)
	surface.DrawText("$")

	local mone = self:GetMoney()
	if GAMEMODE.MoneyNotifTime && GAMEMODE.MoneyNotifTime + 3 > CurTime() then
		local add = "+" .. GAMEMODE.MoneyNotif
		mone = mone - GAMEMODE.MoneyNotif
		draw.ShadowText(add, "RobotoHUD-20", x + w + gap + 16, y + h / 2 - th / 2)
	end

	surface.SetFont("RobotoHUD-20")
	local money = tostring(mone):sub(1,6)
	if self:GetMoney() <= 0 then money = "" end
	if #money < 6 then
		surface.SetTextColor(dull, dull, dull, dulla)
		surface.SetTextPos(x + dw + gap, y + h / 2 - th / 2)
		surface.DrawText(("0"):rep(6 - #money))
	end

	local aw, ah = surface.GetTextSize(money)
	surface.SetTextColor(255, 255, 255, 255)
	surface.SetTextPos(x + dw + gap + (tw - aw), y + h / 2 - th / 2)
	surface.DrawText(money)

end

function GM:HUDShouldDraw(name)
	if name == "CHudHealth" then return false end
	if name == "CHudVoiceStatus" then return false end
	if name == "CHudVoiceSelfStatus" then return false end
	-- if name == "CHudAmmo" then return false end
	if name == "CHudChat" then
		if IsValid(self.EndRoundPanel) && self.EndRoundPanel:IsVisible() then
			return false
		end
	end
	return true
end

function GM:GetRoundHideTime()
	local ply = LocalPlayer()
	return ply:GetNWInt("RoundHidetime", 10)
end

function GM:DrawRoundTimer()

	if self:GetGameState() == 1 then
		local time = math.ceil(self:GetRoundHideTime() - self:GetStateRunningTime())
		if time > 0 then
			draw.ShadowText("Hunters will be released in", "RobotoHUD-15", ScrW() / 2, ScrH() / 3 - draw.GetFontHeight("RobotoHUD-40") / 2, color_white, 1, 4)
			draw.ShadowText(time, "RobotoHUD-40", ScrW() / 2, ScrH() / 3, color_white, 1, 1)
		end
	elseif self:GetGameState() == 2 then
		if self:GetStateRunningTime() < 2 then
			draw.ShadowText("GO!", "RobotoHUD-50", ScrW() / 2, ScrH() / 3, color_white, 1, 1)
		end
		local settings = self:GetRoundSettings()
		local roundTime = settings.RoundTime or 5 * 60
		local time = math.max(0, roundTime - self:GetStateRunningTime())
		local m = math.floor(time / 60)
		local s = math.floor(time % 60)
		m = tostring(m)
		s = s < 10 and "0" .. s or tostring(s)
		local fh = draw.GetFontHeight("RobotoHUD-L15") * 1
		draw.ShadowText("Props win in", "RobotoHUD-L15", ScrW() / 2, 20, color_white, 1, 3)
		draw.ShadowText(m .. ":" .. s, "RobotoHUD-20", ScrW() / 2, fh + 20, color_white, 1, 3)
	end
end

local polyMat = Material("VGUI/white.vmt")
function GM:RenderScreenspaceEffects()
end
function GM:PreDrawHUD()
	local client = LocalPlayer()
	if !client:Alive() then
	end

	if self:GetGameState() == 1 then
		if client:Team() == 2 then
			surface.SetDrawColor(25, 25, 25, 255)
			surface.DrawRect(-10, -10, ScrW() + 20, ScrH() + 20)
		end
	end
end
