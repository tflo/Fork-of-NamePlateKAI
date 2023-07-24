local _TOCVERSION = select(4, GetBuildInfo())
local ADDON_NAME, addon = ...
_G[ADDON_NAME] = addon
addon.version = GetAddOnMetadata(ADDON_NAME, "Version")

addon.events = {}
addon.events.units = {}
addon.db = {}
addon.filter = {}
addon.filter.color = {}
addon.filter.flags = {}
addon.filter.auras = {}
addon.scheduler = {}
addon.affixes = {}

local db = addon.db

addon.defaults = {
	version = 0,
	nameFont = {name = nil, size = 11.5, outline = "OUTLINE"},
	numFont = {name = nil, size = 8.5, outline = "OUTLINE"},
	castFont = {name = nil, size = 9.5, outline = "OUTLINE"},
	nameFontPlayer = {name = nil, size = 11.0, outline = ""},
	dungeonFont = {size = 14},
	frameSize = {W = 94, H = 9},
	healthBarHeight = 7,
	castBarHeight = 6,
	frameMargin = {x = 14, y = 30},
	barTexture = "Interface\\Addons\\NamePlateKAI\\texture\\normTex",
	bgTexture = nil,
	castBarTexture = "Interface\\Addons\\NamePlateKAI\\texture\\normTex",
	targetAlwaysOnTop = true,
	redHostile = false,
	disableFactionIcon = false,
	disableDefaultFilters = false,
	friendlyClassColor = true,
	friendlyClickThrough = false,
	dungeonFriendlyClickThrough = false,
	disableFriendlyBars = true,
	disableOmnicc = false,
	disableObjectiveIcon = false,
	performanceMode = -1,
	powerBarEnemy = false,
	powerBarFriendly = false,
	dynamicOpacity = true,
	showPlayerGuild = true,
	showPlayerRealm = true,
	showPlayerTitle = true,
	alwaysShowUnitName = false,
	trivialScale = 0.7,
	disableTrivialScaleInInstance = false,
	barAnchorOffsetY = 5,
	nobarAnchorOffsetY = 0,
	dungeonFriendlyBarMulti = 1,
	nameplateOverlapH = 0,
	nameplateOverlapV = 0,
	nameplateMaxDistance = 60,
	nameplatePlayerMaxDistance = 60,
	nameplateDungeonDistanceEnabled = false,
	nameplateDungeonDistance = 41,
	nameplateRaidDistanceEnabled = false,
	nameplateRaidDistance = 60,
	barBackdrop = {
		edgeFile = "Interface\\AddOns\\NamePlateKAI\\texture\\glowTex",
		tile = false,
		edgeSize = 4,
		insets = {left = 0, right = 0, top = 0, bottom = 0}
	},
	borderColor = {0, 0, 0, 0.8},
	barColors = {
		friendly = {0.225, 0.415, 0.68},
		npc = {0.45, 0.62, 0.45},
		hostile = {0.27, 0.72, 0.27},
		neutral = {0.55, 0.55, 0.35},
		yellow = {0.8, 0.7, 0},
		orange = {0.9, 0.3, 0},
		red = {0.8, 0, 0},
		tapped = {0.37, 0.45, 0.50},
	},
	spellIcon = {size = 16},
	raidIcon = {
		size = 18,
		anchorPoint = "TOP",
		offsetX = 0,
		offsetY = 11,
	},
	filterColors = {
		[1] = {1, 1, 0.62},
		[2] = {1, 0.68, 1},
		[3] = {0.3, 0.6, 1},
		[4] = {1, 0.1, 1, 1}, -- no threat (purple)
		[5] = {0.4, 0.45, 0.5, 1}, -- trash mob
		[6] = {0.45, 0.85, 0.85, 1}, -- no threat (light blue)
		[7] = {0.5, 0.6, 0.53}, -- normal mob
		[8] = {1, 1, 1}, -- aura shield
		[9] = {1, 0.2, 0, 0}, -- hue rotate
		[10] = {0.9, 1, 0.1}, -- aura magic
	},
	statusTextFormat = {
		players = "|cff88aaff<%s>|r",
		party = "|cff88ffaa<%s>|r",
		guildy = "|cffee77ff<%s>|r",
	},
	target = {
		flash = true,
		shine = true,
		shineAlpha = 0.8,
		animation = true,
		animationAlpha = 0.3,
		animationStyle = "default",
		animationOverlay = false,
	},
	buff = {
		enabledEnemy = true,
		enabledFriendly = true,
		offset = {x = 2, y = 7},
		size = {W = 20, H = 14},
		borderSize = 1,
		bossScale = 1.24,
		countdownNumber = false,
		showEnrage = true,
		showMagic = false,
	},
	healthText = {
		enabled = false,
		displayMax = false,
		percentage = false,
		colorNormal = "ccddee",
		colorExecute = "ff8000",
		executeThreshold = false,
		onlyExecute = false,
	},
	rangeCheckerMode = {
		default = "item40",
	},
}

addon.defaults.barColors[1] = addon.defaults.barColors.hostile
addon.defaults.barColors[2] = addon.defaults.barColors.hostile
addon.defaults.barColors[3] = addon.defaults.barColors.orange
addon.defaults.barColors[4] = addon.defaults.barColors.neutral
addon.defaults.barColors[5] = addon.defaults.barColors.npc
addon.defaults.barColors[6] = addon.defaults.barColors.npc
addon.defaults.barColors[7] = addon.defaults.barColors.npc
addon.defaults.barColors[8] = addon.defaults.barColors.npc
addon.defaults.barColors[9] = addon.defaults.barColors.friendly
addon.defaults.barColors[10] = addon.defaults.barColors.tapped
addon.defaults.barColors[-1] = addon.defaults.filterColors[5]
addon.defaults.castBarOffset = max(floor(addon.defaults.barBackdrop.edgeSize * 0.6), 3)
for i = 1, GetNumClasses() do
	addon.defaults.rangeCheckerMode[i] = addon.defaults.rangeCheckerMode.default
end

addon.defaultFilters = {}

local select, unpack, strfind, strmatch, tinsert, tremove, tonumber, floor, pairs, band, rshift, min, max = select, unpack, string.find, string.match, tinsert, tremove, tonumber, math.floor, pairs, bit.band, bit.rshift, min, max
local tbl = {}

local FontUnitNameNormal = CreateFont(ADDON_NAME.."TextNormal")
local FontUnitNamePlayer = CreateFont(ADDON_NAME.."TextPlayer")
local FontUnitNameSmall = CreateFont(ADDON_NAME.."TextSmall")
local FontNumber = CreateFont(ADDON_NAME.."Number")
local FontSpellName = CreateFont(ADDON_NAME.."SpellName")

addon.frame = addon.frame or CreateFrame("Frame", nil, _G.WorldFrame)

local ParentFrame1 = CreateFrame("Frame", nil, _G.WorldFrame)
ParentFrame1:SetFrameStrata("BACKGROUND")
ParentFrame1:SetFrameLevel(2)

local ParentFrame2 = CreateFrame("Frame", nil, _G.WorldFrame)
ParentFrame2:SetFrameStrata("LOW")

local ParentFrame3 = CreateFrame("Frame", nil, _G.WorldFrame)
ParentFrame3:SetFrameStrata("MEDIUM")

local GetCreatureTitle do
	local FORMAT_TOOLTIP_LEVEL = "^"..TOOLTIP_UNIT_LEVEL:gsub("%%s", ".+")

	function GetCreatureTitle(unitID)
		local tooltipData = C_TooltipInfo.GetUnit(unitID)
		local line = tooltipData and tooltipData.lines[2]
		if line then
			TooltipUtil.SurfaceArgs(line)
			if line.type == 0 and not strfind(line.leftText, FORMAT_TOOLTIP_LEVEL) then
				return line.leftText
			end
		end
	end
end

local ClassColors = setmetatable({default = {0.5, 0.5, 0.55}}, {__index =
	function(self, key)
		local value
		local c = _G.RAID_CLASS_COLORS[key]
		if c then
			value = {c.r, c.g, c.b}
		else
			if type(key) == "number" and GetClassInfo(key) then
				value = self[select(2, GetClassInfo(key))]
			else
				value = self.default
			end
		end
		self[key] = value
		return value
	end
})

local kaiPlates = {} -- plate, kai pairs
local updatePlates = {} -- kai stacks
local npcPlates = {} -- kai stacks
local widgetContainers = {} -- UnitFrame.WidgetContainer, plate pairs

local Kai_UpdateName
local Kai_UpdateStatusText
local Kai_UpdateStatusAlpha
local Kai_UpdateHealth
local Kai_UpdateThreatBorder
local Kai_UpdateHealthMax
local Kai_UpdateAbsorb
local Kai_Restyle
local Kai_OnEvent
local Kai_UpdateRaidIcon
local Kai_UpdateFactionIcon
local Kai_UpdateQuestIcon
local Kai_Refresh
local Kai_AurasUpdate
local Kai_AurasSetup
local Aura_SetStyle
local Kai_PowerBarSetup
local Kai_UnitInRange

local GetCVar, GetCVarBool, GetCVarDefault, SetCVar = C_CVar.GetCVar, C_CVar.GetCVarBool, C_CVar.GetCVarDefault, C_CVar.SetCVar
local UnitExists, UnitIsPlayer, UnitIsUnit, UnitClass, UnitClassification, UnitReaction, UnitName, UnitPVPName, UnitLevel, UnitCanAttack, UnitPlayerControlled, UnitFactionGroup, UnitThreatSituation, UnitShouldDisplayName, UnitIsInMyGuild = UnitExists, UnitIsPlayer, UnitIsUnit, UnitClass, UnitClassification, UnitReaction, UnitName, UnitPVPName, UnitLevel, UnitCanAttack, UnitPlayerControlled, UnitFactionGroup, UnitThreatSituation, UnitShouldDisplayName, UnitIsInMyGuild
local GetNamePlates, GetNamePlateForUnit = C_NamePlate.GetNamePlates, C_NamePlate.GetNamePlateForUnit
local CastingBarFrame_SetUnit, CastingBarFrame_OnShow = CastingBarFrame_SetUnit, CastingBarFrame_OnShow
local UnitPlayerOrPetInGroup = IsInRaid() and UnitPlayerOrPetInRaid or UnitPlayerOrPetInParty

local function UnitShouldShowName(kai)
	-- print(GetTime(), UnitName(kai.unitID), "isMouse:", kai.isMouseOver, "isTarget:", kai.isTarget, "S:", UnitShouldDisplayName(kai.unitID))
	if db.alwaysShowUnitName and kai.unitExists then
		return true
	elseif kai.hideName then
		return kai.isTarget -- show only when targeted
	elseif kai.unitExists then
		return kai.isMouseOver or kai.isBoss or UnitShouldDisplayName(kai.unitID) or kai.isTarget
	end
end

do
	local realmNames = setmetatable({}, {__index =
		function(self, key)
			local value = "|cff777733-"..key:sub(1, 3).."|r"
			self[key] = value
			return value
		end
	})

	local UnitRealmRelationship, UnitIsTapDenied, UnitSelectionColor = UnitRealmRelationship, UnitIsTapDenied, UnitSelectionColor
	local unitID, name, realm
	function Kai_UpdateName(kai)
		unitID = kai.unitID
		if UnitShouldShowName(kai) then
			name, realm = UnitName(unitID)
			if db.showPlayerTitle then
				name = UnitPVPName(unitID) or name
			end
			if not db.showPlayerRealm then
				realm = nil
			end
			if kai.isPvP and realm and addon.inWorld and UnitRealmRelationship(unitID) ~= 3 then -- 3: LE_REALM_RELATION_VIRTUAL
				name = name..realmNames[realm]
			end
			kai.nameText:SetText(name)

			if kai.isPvP then
				if kai.isBarShown or not db.friendlyClassColor then
					kai.nameText:SetVertexColor(UnitSelectionColor(unitID, true))
				else
					kai.nameText:SetVertexColor(unpack(ClassColors[kai.classID]))
				end
			elseif not kai.nameColorIndex then
				if UnitIsTapDenied(unitID) then -- tapped
					kai.nameText:SetVertexColor(0.5, 0.5, 0.5)
				elseif kai.isBoss then -- boss
					kai.nameText:SetVertexColor(0.9, 0.2, 0.8)
				elseif kai.isDungeonBoss then -- dungeon boss
					kai.nameText:SetVertexColor(0.8, 0.3, 1)
				elseif UnitThreatSituation("player", unitID) then
					kai.nameText:SetVertexColor(1, 0, 0)
				else
					kai.nameText:SetVertexColor(UnitSelectionColor(unitID, true))
				end
			end
			kai.nameText:Show()
			kai.nameText:SetAlpha(kai.nameAlpha)

			if kai.isMouseOver then
				if kai.isTarget then
					kai.reactionTexture:SetVertexColor(1, 1, 1)
					kai.reactionTexture:SetAlpha(0.25)
				elseif kai.isBarShown then
					kai.reactionTexture:SetVertexColor(0, 0, 0)
					kai.reactionTexture:SetAlpha(0.4)
				else
					kai.reactionTexture:SetVertexColor(UnitSelectionColor(unitID, true))
					kai.reactionTexture:SetAlpha(kai.isPvP and 0.25 or 0.6)
				end
				kai.reactionTexture:Show()
			elseif kai.isBarShown or kai.isPvP then
				kai.reactionTexture:Hide()
			else
				kai.reactionTexture:SetVertexColor(UnitSelectionColor(unitID, true))
				kai.reactionTexture:SetAlpha(0.3)
				kai.reactionTexture:Show()
			end
		else
			kai.reactionTexture:Hide()
			kai.nameText:SetText(nil)
			kai.nameText:Hide()
		end
		Aura_SetStyle(kai.buffs[1])
	end

end

function Kai_UpdateStatusAlpha(kai)
	if not kai.unitExists then return end
	if kai.isBarShown then
		kai.barTexture:SetAlpha((kai.isTarget or not kai.isFriendlyNPC) and 1 or 0.5)
		kai.bgTexture:SetAlpha((kai.isTarget or kai.isMouseOver or not kai.isFriendlyNPC) and 1 or 0.5)
	end
	kai.statusText:SetWidth((kai.isTarget or kai.isMouseOver) and 0 or addon.statusTextWidth)
end

function Kai_UpdateStatusText(kai, forceTitle)
	kai._status = nil
	if kai.isFriendlyNPC and kai.unitExists then
		local valid = UnitShouldShowName(kai)
		forceTitle = forceTitle or kai.isTarget or kai.isBoss
		local text
		if valid or forceTitle then
			text = forceTitle and GetCreatureTitle(kai.unitID) or kai.isBoss and _G.BOSS or kai.level and _G.UNIT_LEVEL_TEMPLATE:format(kai.level)
		end
		kai.statusText:SetText(text or nil)
		kai.statusText:SetShown(valid)
		return valid
	elseif kai.isPvP and kai.unitExists and not kai.isBarShown and addon.inWorld then
		local text = db.showPlayerGuild and GetGuildInfo(kai.unitID)
		if text then
			kai.statusText:SetFormattedText(db.statusTextFormat[UnitPlayerOrPetInGroup(kai.unitID) and "party" or UnitIsInMyGuild(kai.unitID) and "guildy" or "players"], text)
		else
			kai.statusText:SetText(nil)
		end
		kai.statusText:SetShown(text)
	elseif kai.displayHealthText then
		Kai_UpdateHealth(kai, kai.healthValue)
		if kai.isPvP then
			kai.statusText:SetShown(kai.isHostile or kai.isTarget or kai.isMouseOver)
		else
			kai.statusText:SetShown(UnitShouldShowName(kai))
		end
	else
		kai.statusText:Hide()
	end
end

do
	local UnitHealth, UnitHealthMax, UnitGetTotalAbsorbs, UnitIsDead = UnitHealth, UnitHealthMax, UnitGetTotalAbsorbs, UnitIsDead
	local FORMAT_HELATH = {
		M0 = {"|cff%s%dm / %dm|r", " |cff%s%dm|r"},
		M1 = {"|cff%s%.1fm / %.1fm|r", " |cff%s%.1fm|r"},
		M2 = {"|cff%s%.2fm / %.2fm|r", " |cff%s%.2fm|r"},
		K0 = {"|cff%s%dk / %dk|r", " |cff%s%dk|r"},
		K1 = {"|cff%s%.1fK / %.1fk|r", " |cff%s%.1fK|r"},
		-- K2 = {[true] = , [false] = },
		N0 = {"|cff%s%d / %d|r", " |cff%s%d|r"},
		D = "|cff%s".._G.DEAD.."|r",
		P = " |cff%s".._G.PERCENTAGE_STRING.."|r",
	}

	local totalValue, totalMax, color, execution

	function Kai_UpdateHealthMax(kai)
		kai.healthMax = UnitHealthMax(kai.unitID) or 0
		if kai.displayHealthText then
			if db.healthText.percentage then
				kai.healthFmt = FORMAT_HELATH.P
				kai.healthDiv = nil
			else
				local displayMax = db.healthText.displayMax
				if kai.healthMax > 100000000 then
					kai.healthFmt = FORMAT_HELATH.M0[displayMax]
					kai.healthDiv = 1000000
				elseif kai.healthMax > 10000000 then
					kai.healthFmt = FORMAT_HELATH.M1[displayMax]
					kai.healthDiv = 1000000
				elseif kai.healthMax > 1000000 then
					kai.healthFmt = FORMAT_HELATH.M2[displayMax]
					kai.healthDiv = 1000000
				elseif kai.healthMax > 100000 then
					kai.healthFmt = FORMAT_HELATH.K0[displayMax]
					kai.healthDiv = 1000
				elseif kai.healthMax > 10000 then
					kai.healthFmt = FORMAT_HELATH.K1[displayMax]
					kai.healthDiv = 1000
				else
					kai.healthFmt = FORMAT_HELATH.N0[displayMax]
					kai.healthDiv = 1
				end
			end
		else
			kai.healthFmt = nil
			kai.healthDiv = nil
		end
	end

	function Kai_UpdateAbsorb(kai)
		kai.absorb = UnitGetTotalAbsorbs(kai.unitID) or 0
	end

	function Kai_UpdateHealth(kai, value)
		value = value or UnitHealth(kai.unitID) or 0
		kai.healthValue = value
		totalValue = value + kai.absorb
		if kai.healthMax >= totalValue then
			totalMax = kai.healthMax
			kai.absorbSpark:Hide()
		else
			totalMax = totalValue
			kai.absorbSpark:SetPoint("CENTER", kai, "LEFT", kai.healthMax / totalMax * db.frameSize.W, 0)
			kai.absorbSpark:SetShown(kai.isBarShown)
		end

		if kai.healthMax == 0 then

		elseif value > 0 and totalMax > 0 then
			if value >= kai.healthMax then
				kai.barTexture:SetWidth(kai.healthMax / totalMax * db.frameSize.W)
			else
				kai.barTexture:SetWidth(value / totalMax * db.frameSize.W)
			end
			kai.barTexture:SetTexCoord(0, value / kai.healthMax, 0, 1)
		else
			kai.barTexture:SetWidth(0.01)
		end

		if kai.absorb > 0 and totalMax > 0 then
			kai.absorbTexture:SetWidth(kai.absorb / totalMax * db.frameSize.W)
			kai.absorbTexture:SetShown(kai.isBarShown)
		else
			kai.absorbTexture:Hide()
		end

		if kai.healthFmt then
			if value <= 1 and UnitIsDead(kai.unitID) then
				-- kai.statusText:SetFormattedText(FORMAT_HELATH.D, db.healthText.colorNormal)
				return kai.statusText:SetText(nil)
			elseif kai.healthMax > 0 then
				execution = db.healthText.executeThreshold and totalValue / kai.healthMax < db.healthText.executeThreshold
				if db.healthText.onlyExecute and not execution then
					return kai.statusText:SetText(nil)
				end
				color = execution and db.healthText.colorExecute or db.healthText.colorNormal
				if db.healthText.percentage then
					kai.statusText:SetFormattedText(kai.healthFmt, color, totalValue / kai.healthMax * 100)
				else
					kai.statusText:SetFormattedText(kai.healthFmt, color, totalValue / kai.healthDiv, kai.healthMax / kai.healthDiv)
				end
			end
		end
	end
end

do
	local borderColors = {}
	for i = 1, 4 do
		borderColors[i] = {GetThreatStatusColor(i)}
		borderColors[i][4] = 1
	end
	borderColors[0] = addon.defaults.borderColor
	borderColors[5] = {0.3, 1, 0.4, 1}

	local status
	function Kai_UpdateThreatBorder(kai)
		if not kai.isBarShown or kai.isPlayer or (not kai.isTargetAggro and kai.ignoreThreat) then return end
		borderColors[0] = db.borderColor
		status = 0
		if kai.isTargetAggro and UnitIsUnit("player", kai.unitID.."target") then
			status = 5
		elseif not kai.ignoreThreat then
			status = kai.unitExists and UnitThreatSituation("player", kai.unitID) or 0
		end
		kai:SetBackdropBorderColor(unpack(borderColors[status]))
		Kai_UpdateName(kai)
	end

	function addon:SetBorderDefaultColor(color)
		borderColors[0] = color
	end
end

function Kai_UpdateRaidIcon(kai)
	local index = kai.unitExists and GetRaidTargetIndex(kai.unitID)
	if index and not kai.isPlayer then
		kai.raidIcon:SetTexture(137000 + index)
		kai.raidIcon:Show()
	else
		kai.raidIcon:Hide()
	end
end

local BACKDROP_TEXTURES_NAME = {
	"TopLeftCorner", "TopRightCorner", "BottomLeftCorner", "BottomRightCorner",
	-- "TopEdge", "BottomEdge", "LeftEdge", "RightEdge",
}

local function SetFrameBackdrop(frame, backdrop)
	frame:SetBackdrop(backdrop)
	local offset = frame:GetEdgeSize()
	local v, p, r, rp, x, y
	for i, name in ipairs(BACKDROP_TEXTURES_NAME) do
		v = frame[name]
		for j = 1, v:GetNumPoints() do
			p, r, rp, x, y = v:GetPoint(j)
			if strfind(p, "TOP", 1, true) then y = y + offset end
			if strfind(p, "BOTTOM", 1, true) then y = y - offset end
			if strfind(p, "LEFT", 1, true) then x = x - offset end
			if strfind(p, "RIGHT", 1, true) then x = x + offset end
			v:SetPoint(p, r, rp, x, y)
		end
	end
end

local BACKDROP_LAYOUT = {
	"TopLeftCorner", "TopRightCorner", "BottomLeftCorner", "BottomRightCorner", "TopEdge", "BottomEdge", "LeftEdge", "RightEdge", "Center"
}

local function Kai_HealthBarSetShown(kai, value)
	-- kai.nameText:SetIgnoreParentAlpha(not value and kai.isPvP or false)
	kai.isBarShown = value
	kai.bgTexture:SetShown(value)
	kai.barTexture:SetShown(value)
	kai.barTexture:SetIgnoreParentAlpha(kai.ignoreAlpha or false)
	kai.absorbTexture:SetShown(value)
	kai.absorbSpark:SetShown(value)
	for i = 1, #BACKDROP_LAYOUT do
		kai[BACKDROP_LAYOUT[i]]:SetShown(value)
	end
end

function Kai_Restyle(kai)
	kai:ClearAllPoints()
	kai:SetSize(db.frameSize.W, db.healthBarHeight)
	SetFrameBackdrop(kai, db.barBackdrop)
	kai:SetPoint("CENTER", kai.plate, "BOTTOM", 0, 0)
	kai.barTexture:SetTexture(db.barTexture)
	kai.bgTexture:SetTexture(db.bgTexture or db.barTexture)
	for i = 1, #kai.buffs do
		Aura_SetStyle(kai.buffs[i])
	end
	if addon.unitTemplate then

	else
		kai.absorbSpark:SetSize(7, db.healthBarHeight)
		kai.factionIcon:SetPoint("RIGHT", kai, "LEFT", 1 - db.barBackdrop.edgeSize / 3, 0)
		kai.raidIcon:SetSize(db.raidIcon.size, db.raidIcon.size)
		kai.raidIcon:SetPoint("CENTER", kai, db.raidIcon.anchorPoint, db.raidIcon.offsetX, db.raidIcon.offsetY)
	end
	if addon.castTemplate then

	else
		kai.castBar:ClearAllPoints()
		kai.castBar:SetPoint("TOPLEFT", kai, "BOTTOMLEFT", 0, - db.castBarOffset)
		kai.castBar:SetPoint("TOPRIGHT", kai, "BOTTOMRIGHT", 0, - db.castBarOffset)
		kai.castBar:SetHeight(db.castBarHeight)
		kai.castBar.Icon:SetSize(db.spellIcon.size, db.spellIcon.size)
		kai.castBar.BorderShield:SetSize(10, max(db.castBarHeight, 12))
	end
end

function Kai_OnEvent(kai, event, ...)
	if event == "UNIT_HEALTH" then
		Kai_UpdateHealth(kai)
	elseif event == "UNIT_AURA" then
		Kai_AurasUpdate(kai)
	elseif event == "UNIT_MAXHEALTH" then
		Kai_UpdateHealthMax(kai)
		Kai_UpdateHealth(kai)
	elseif event == "UNIT_ABSORB_AMOUNT_CHANGED" then
		Kai_UpdateAbsorb(kai)
		Kai_UpdateHealth(kai, kai.healthValue)
	elseif event == "UNIT_THREAT_LIST_UPDATE" then
		Kai_UpdateThreatBorder(kai)
	elseif event == "UNIT_POWER_UPDATE" then
		if kai.powerBar then
			kai.powerBar:SetValue()
		end
	elseif event == "UNIT_MAXPOWER" then
		if kai.powerBar then
			kai.powerBar:UpdateMax()
			kai.powerBar:SetValue()
		end
	elseif event == "UNIT_DISPLAYPOWER" then
		if kai.powerBar then
			kai.powerBar:SetPowerType()
			kai.powerBar:UpdateMax()
			kai.powerBar:SetValue()
		end
	end
end

local HUE_COLORS = {
	{1, 0, 0},
	{1, .2, 0},
	{1, .4, 0},
	{1, .6, 0},
	{1, .8, 0},
	{1, .9, 0},
	-- {1, 1, 0},
	{.9, 1, 0},
	{.8, 1, 0},
	{.6, 1, 0},
	{.4, 1, 0},
	{.2, 1, 0},
	{0, 1, 0},
	{0, 1, .2},
	{0, 1, .4},
	{0, 1, .6},
	{0, 1, .8},
	{0, 1, .9},
	-- {0, 1, 1},
	{0, .9, 1},
	{0, .8, 1},
	{0, .6, 1},
	{0, .4, 1},
	{0, .2, 1},
	{0, 0, 1},
	{.2, 0, 1},
	{.4, 0, 1},
	{.6, 0, 1},
	{.8, 0, 1},
	{.9, 0, 1},
	-- {1, 0, 1},
	{1, 0, .9},
	{1, 0, .8},
	{1, 0, .6},
	{1, 0, .4},
	{1, 0, .2},
}
local HUE_COLORS_MAX = #HUE_COLORS

do -- set saturation
	local s = .15
	for i = 1, HUE_COLORS_MAX do
		HUE_COLORS[i][1] = HUE_COLORS[i][1] * (1 - s) + s
		HUE_COLORS[i][2] = HUE_COLORS[i][2] * (1 - s) + s
		HUE_COLORS[i][3] = HUE_COLORS[i][3] * (1 - s) + s
	end
end

local function NamePlate_OnUpdateNameColor(namePlate, elapsed, kai)
	kai = kai or kaiPlates[namePlate]
	elapsed = kai.elapsed + elapsed
	local c = floor(elapsed / 0.0166666)
	if c < 1 then
		kai.elapsed = elapsed
		return
	else
		kai.elapsed = elapsed % 0.0166666
		local index = kai.nameColorIndex + c
		index = index % HUE_COLORS_MAX
		if index == 0 then
			index = HUE_COLORS_MAX
		end
		kai.nameColorIndex = index
		kai.nameText:SetVertexColor(unpack(HUE_COLORS[index]))
	end
end

local function NamePlate_OnUpdateBarAnimation(namePlate, elapsed, kai)
	kai = kai or kaiPlates[namePlate]
	if not kai.barAnimIndex then return end
	elapsed = kai.elapsed + elapsed
	local c = floor(elapsed / 0.0166666)
	if c < 1 then
		kai.elapsed = elapsed
		return
	else
		kai.elapsed = elapsed % 0.0166666
		local index = kai.barAnimIndex + c
		index = index % HUE_COLORS_MAX
		if index == 0 then
			index = HUE_COLORS_MAX
		end
		kai.barAnimIndex = index
		kai.barTexture:SetVertexColor(unpack(HUE_COLORS[index]))
	end
end

local function NamePlate_OnUpdate(namePlate, elapsed)
	local kai = kaiPlates[namePlate]
	NamePlate_OnUpdateBarAnimation(namePlate, elapsed or 1, kai)
	if kai.fadeIn or kai.fadeOut then return end

	local inRanged = not kai.isHostile or (Kai_UnitInRange and Kai_UnitInRange(kai) ~= 0)
	local alpha = namePlate:GetAlpha() < 0.59 and 0.55 or 1

	if inRanged ~= kai.inRanged then
		kai.inRanged = inRanged

		kai.nameAlpha = (kai.isTarget or inRanged) and 1 or 0.55
		kai.nameText:SetAlpha(kai.nameAlpha)

		if kai.isTarget then
			addon:UpdateShineVertexColor()
		end
	end

	if inRanged or kai.isTarget then
		kai:SetAlpha(alpha)
	else
		kai:SetAlpha(alpha / 2)
	end

	if alpha < 1 then
		kai.nameText:SetAlphaGradient(0, 30)
	else
		kai.nameText:SetAlphaGradient(0, 1000)
	end
end

local function NamePlate_OnSizeChanged(namePlate)
	local kai = kaiPlates[namePlate]
	local plateScale = namePlate:GetScale()
	if kai.fadeIn then
		if plateScale > 0.75 then
			kai.fadeIn = nil
		end
	elseif kai.fadeOut then
		if plateScale > 0.75 then
			kai.fadeOut = nil
			kai.questTexture:SetShown(kai.onQuest)
			if db.dynamicOpacity then
				kai:SetAlpha(min(plateScale, 1))
				NamePlate_OnUpdate(namePlate)
			else
				kai:SetAlpha(1)
			end
		else
			kai:SetAlpha(plateScale)
		end
	elseif plateScale < 0.75 then
		kai.fadeOut = true
		kai:SetAlpha(plateScale)
		kai.questTexture:Hide()
	end
end

local function WidgetContainer_SetPoint(container, point, rTo, rPoint)
	-- print(GetTime(), "W_SetPoint", point, rTo, rPoint)
	local kai = kaiPlates[widgetContainers[container]]
	if kai and kai ~= rTo then
		container:SetParent(kai)
		container:ClearAllPoints()
		container:SetPoint("BOTTOM", kai, "TOP", 0, 17)
	end
end

function addon:NamePlateOnCreate(namePlate)
	if kaiPlates[namePlate] then return end

	local kai = CreateFrame("Frame", nil, ParentFrame2, self.unitTemplate or "KaiUnitFrameTemplate")
	kaiPlates[namePlate] = kai

	kai.plate = namePlate
	kai.isNew = true
	kai.unitID = ""
	kai.level = 0
	kai.healthMax = 0
	kai.healthValue = 0
	kai.absorb = 0
	kai.buffs = {}
	kai.nameAlpha = 1.0
	-- kai.nameColorIndex = 1
	kai.elapsed = 0

	kai.bgTexture:SetVertexColor(0.1, 0.1, 0.1, 0.85)
	kai.absorbTexture:SetVertexColor(0.8, 0.8, 0.8)
	kai.absorbSpark:SetVertexColor(0.6, 0.5, 0.4)

	kai.castBar = CreateFrame("StatusBar", nil, kai, self.castTemplate or "KaiCastBarTemplate")
	local mt = getmetatable(kai.castBar)
	setmetatable(addon.KaiCastBarPrototype, mt)
	setmetatable(kai.castBar, {__index = addon.KaiCastBarPrototype})
	kai.castBar:OnLoad(nil, false, true)
	kai.castBar:InitScripts("OnEvent", "OnUpdate", "OnShow")

	Kai_Restyle(kai)

	kai.statusText:SetFontObject(FontUnitNameSmall)
	kai.statusText:SetTextColor(0.9, 0.9, 0.7, 1)

	kai:SetScript("OnEvent", Kai_OnEvent)
	namePlate:SetScript("OnSizeChanged", NamePlate_OnSizeChanged)
	if db.dynamicOpacity then
		namePlate:SetScript("OnUpdate", NamePlate_OnUpdate)
	else
		namePlate:SetScript("OnUpdate", NamePlate_OnUpdateBarAnimation)
	end
end

local UnitNpcID do
	local UnitGUID = UnitGUID
	local FORMAT_GUID_CREATURE = "^%a+%-%d+%-%d+%-%d+%-%d+%-(%d+)"
	local id
	function UnitNpcID(unitID)
		return tonumber(strmatch(UnitGUID(unitID) or "", FORMAT_GUID_CREATURE))
	end
end

do
	local icons = {Horde = 130705, Alliance = 130704, Neutral = 1140616}
	local mobType
	function Kai_UpdateFactionIcon(kai)
		if kai.isPvP or kai.reaction < 0 then -- Player or Player's pet
			if db.disableFactionIcon and addon.inPvP then
				kai.factionIcon:Hide()
			elseif kai.isBarShown and kai.isHostile then
				kai.factionIcon:SetSize(22, 22)
				kai.factionIcon:SetTexture(icons[UnitFactionGroup(kai.unitID) or "Neutral"])
				kai.factionIcon:Show()
			else
				kai.factionIcon:Hide()
			end
		elseif kai.hideName or kai.isFriendlyNPC or not kai.isBarShown then -- exclude Sanctuary Guardian
			kai.factionIcon:Hide()
		else
			kai.factionIcon:SetSize(16, 16)
			kai.factionIcon:SetVertexColor(1, 1, 1)
			if kai.isBoss then
				-- kai.factionIcon:SetTexture(137025)
				kai.factionIcon:SetAtlas("DungeonSkull")
				kai.factionIcon:SetVertexColor(0.9, 0.9, 1)
			else
			  if kai.isElite and kai.isRare then
					-- kai.factionIcon:SetAtlas("UI-HUD-UnitFrame-Target-PortraitOn-Boss-Rare-Star")
					kai.factionIcon:SetAtlas("VignetteKillElite")
					kai.factionIcon:SetSize(17, 17)
				elseif not addon.inRaid and kai.isElite then
					kai.factionIcon:SetAtlas("nameplates-icon-elite-gold")
				elseif kai.isRare then
					-- kai.factionIcon:SetAtlas("UI-HUD-UnitFrame-Target-PortraitOn-Boss-Rare")
					kai.factionIcon:SetAtlas("VignetteKill")
				else
					return kai.factionIcon:Hide()
				end
			end
			kai.factionIcon:Show()
		end
	end
end

function addon:NamePlateOnAdded(namePlate, unitID, refresh)
	local kai = kaiPlates[namePlate]
	local UnitFrame = namePlate.UnitFrame

	kai.unitID = unitID
	kai.unitExists = #unitID > 0
	kai.isPlayer = UnitIsUnit("player", unitID)
	kai.reaction = UnitReaction(unitID, "player") or 10
	-- kai.reaction = UnitReaction("player", unitID) or 10
	kai.classID = 0
	kai.inRanged = nil
	kai.barAnimIndex = nil
	kai.level = UnitLevel(unitID)
	kai.isBoss = kai.level < 0
	kai.isPvP = UnitIsPlayer(unitID) or nil
	kai.isHostile = UnitCanAttack("player", unitID) or nil
	kai.isFriendlyNPC = not kai.isHostile and not kai.isPvP or nil
	kai.npcID = UnitNpcID(unitID)
	local mobType = UnitClassification(kai.unitID)
	kai.isElite = not kai.isPvP and (mobType == "elite" or mobType == "rareelite" or mobType == "worldboss") or nil
	kai.isRare = not kai.isPvP and (mobType == "rare" or mobType == "rareelite") or nil
	local flags = self.filter.flags[kai.npcID] or nil
	if flags then
		kai.hideName = band(flags, 0x0001) ~= 0 or nil
		kai.ignoreAuras = band(flags, 0x0002) ~= 0 or nil
		kai.ignoreThreat = band(flags, 0x0004) ~= 0 or nil
		kai.powerBarColorIndex = band(flags, 0xF000) ~= 0 and rshift(band(flags, 0xF000), 12) or nil
		kai.ignoreAlpha = band(flags, 0x0010) ~= 0 or nil
		kai.isDungeonBoss = band(flags, 0x0020) ~= 0 or nil
		kai.isTargetAggro = band(flags, 0x0040) ~= 0 or nil
		kai.noTrivial = band(flags, 0x0080) ~= 0 or nil
		kai.nameColorIndex = band(flags, 0x0080) ~= 0 and 1 or nil
	else
		kai.hideName,	kai.ignoreAuras, kai.ignoreThreat, kai.powerBarColorIndex, kai.ignoreAlpha, kai.isDungeonBoss, kai.isTargetAggro, kai.nameColorIndex = nil
	end

	local scale = 1
	if (self.inWorld or not db.disableTrivialScaleInInstance) and ( mobType == "minus" or mobType == "trivial") then
		if not kai.noTrivial then
			scale = db.trivialScale
		end
	end
	kai:SetScale(scale)
	kai.nameText:SetScale(scale)

	local barColor = kai.npcID and self.filter.color[kai.npcID] or self.filter.color[UnitName(unitID)]
	if barColor then
		if barColor[4] == 0 then -- Hue rotate
			kai.ignoreAlpha = true
			kai.barAnimIndex = 1
		else
			kai.ignoreThreat = kai.ignoreThreat or barColor[4] == 1
			kai.barTexture:SetVertexColor(unpack(barColor, 1, 3))
		end
	else
		if kai.isPvP then
			kai.classID = select(3, UnitClass(unitID))
			if kai.reaction > 4 then
				kai.reaction = 9
			end
			if kai.isHostile or db.friendlyClassColor then
				kai.barTexture:SetVertexColor(unpack(ClassColors[kai.classID]))
			else
				kai.barTexture:SetVertexColor(unpack(db.barColors[kai.reaction], 1, 3))
			end
		else
			if UnitPlayerControlled(unitID) then
				if kai.isHostile then
					kai.reaction = -1 -- player's pet
				end
			else
				-- kai.isFriendlyNPC = (kai.reaction > 2) and not UnitCanAttack("player", unitID)
				-- kai.isFriendlyNPC = not UnitCanAttack("player", unitID)
			end
			kai.barTexture:SetVertexColor(unpack(db.barColors[kai.reaction], 1, 3))
		end
	end

	if kai.isPlayer then
		kai:Hide()
		if UnitFrame then
			UnitFrame:SetAlpha(1)
			UnitFrame:Show()
			UnitFrame.BuffFrame:Show()
		end
		return
	end

	kai.isMouseOver = UnitIsUnit(unitID, "mouseover") or nil
	kai.isTarget = kai.unitExists and UnitIsUnit(unitID, "target") or nil
	kai.isBarShown = kai.isHostile or not db.disableFriendlyBars or nil
	kai.displayHealthText = db.healthText.enabled and kai.isBarShown and not kai.isFriendlyNPC and (not kai.hideName or kai.isTarget) or nil

	if kai.isTarget then
		self.targetPlate = namePlate
		kai:SetParent(ParentFrame2)
		self:SetTargetGlow()
	else
		kai:SetParent(ParentFrame1)
	end

	if kai.isMouseOver then
		addon.frame.highlight:SetKai(kai)
	end

	Kai_HealthBarSetShown(kai, kai.isBarShown)

	if kai.isPvP and not kai.isBarShown then
		kai.nameText:SetFontObject(FontUnitNamePlayer)
		kai.statusText:SetFontObject(FontUnitNamePlayer)
	else
		kai.nameText:SetFontObject(FontUnitNameNormal)
		kai.statusText:SetFontObject(FontUnitNameSmall)
	end

	kai:SetBackdropBorderColor(unpack(db.borderColor))

	if kai.isBarShown then
		kai:SetPoint("CENTER", kai.plate, "BOTTOM", 0, db.frameMargin.y / 3 + db.barAnchorOffsetY)
		kai:RegisterUnitEvent("UNIT_HEALTH", unitID)
		kai:RegisterUnitEvent("UNIT_MAXHEALTH", unitID)
		kai:RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", unitID)
		kai:RegisterUnitEvent("UNIT_THREAT_LIST_UPDATE", unitID)
		Kai_UpdateHealthMax(kai)
		Kai_UpdateAbsorb(kai)
		Kai_UpdateHealth(kai)
	else
		kai:SetPoint("CENTER", kai.plate, "BOTTOM", 0, -db.healthBarHeight + db.nobarAnchorOffsetY)
		kai:UnregisterEvent("UNIT_HEALTH")
		kai:UnregisterEvent("UNIT_MAXHEALTH")
		kai:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
		kai:UnregisterEvent("UNIT_THREAT_LIST_UPDATE")
	end

	Kai_UpdateStatusAlpha(kai)
	if Kai_UpdateStatusText(kai) and not (kai.isTarget or kai._status) then
		kai._status = true
		tinsert(npcPlates, 1, kai)
	end

	if flags and band(flags, 0x0008) ~= 0 then
		kai.castBar:SetUnit(nil, nil, nil)
	elseif kai.unitExists and kai.isBarShown then
		kai.castBar:SetUnit(unitID, false, true)
	else
		kai.castBar:SetUnit(nil, nil, nil)
	end

	Kai_UpdateName(kai)
	Kai_UpdateThreatBorder(kai)
	Kai_UpdateFactionIcon(kai)
	Kai_UpdateRaidIcon(kai)
	-- Kai_AurasUpdate(kai)
	Kai_AurasSetup(kai)

	if kai.isPvP then
		Kai_PowerBarSetup(kai, kai.isHostile and db.powerBarEnemy or not kai.isHostile and db.powerBarFriendly)
	else
		Kai_PowerBarSetup(kai, flags and band(flags, 0x0800) ~= 0)
	end

	if UnitFrame then
		if not kai.UnitFrameName then
			kai.UnitFrameName = UnitFrame.name
			kai.unitFrameNameShown = UnitFrame.name:IsShown()
			hooksecurefunc(UnitFrame.name, "Show", function(frame, ...)
				kai.unitFrameNameShown = true
			end)
			hooksecurefunc(UnitFrame.name, "Hide", function(frame, ...)
				if kai.unitFrameNameShown then
					Kai_UpdateName(kai)
					Kai_UpdateStatusText(kai)
				end
				kai.unitFrameNameShown = false
			end)
		end

		if UnitFrame.WidgetContainer then
			local container = UnitFrame.WidgetContainer
			if not widgetContainers[container] then
				container:SetIgnoreParentScale(true)
				container:SetIgnoreParentAlpha(true)
				hooksecurefunc(container, "SetPoint", WidgetContainer_SetPoint)
			end
			widgetContainers[container] = namePlate
			WidgetContainer_SetPoint(container)
		end

		UnitFrame:Hide()
		UnitFrame:SetAlpha(0)
		UnitFrame.BuffFrame:Hide()
		UnitFrame.castBar:SetUnit(nil, nil, nil)
		-- CastingBarFrame_SetUnit(UnitFrame.castBar, nil, nil, nil)
		UnitFrame:UnregisterEvent("UNIT_MAXHEALTH")
		UnitFrame:UnregisterEvent("UNIT_HEALTH")
		UnitFrame:UnregisterEvent("UNIT_MAXPOWER")
		UnitFrame:UnregisterEvent("UNIT_POWER_UPDATE")
		UnitFrame:UnregisterEvent("UNIT_DISPLAYPOWER")
		UnitFrame:UnregisterEvent("UNIT_POWER_BAR_SHOW")
		UnitFrame:UnregisterEvent("UNIT_POWER_BAR_HIDE")
		UnitFrame:UnregisterEvent("UNIT_NAME_UPDATE")
		UnitFrame:UnregisterEvent("UNIT_CONNECTION")
		UnitFrame:UnregisterEvent("UNIT_PET")
		UnitFrame:UnregisterEvent("UNIT_AURA")
		UnitFrame:UnregisterEvent("UNIT_THREAT_SITUATION_UPDATE")
		UnitFrame:UnregisterEvent("UNIT_THREAT_LIST_UPDATE")
		UnitFrame:UnregisterEvent("UNIT_HEAL_PREDICTION")
		UnitFrame:UnregisterEvent("PLAYER_FLAGS_CHANGED")
		UnitFrame:UnregisterEvent("UNIT_CLASSIFICATION_CHANGED")
		UnitFrame:UnregisterEvent("UNIT_OTHER_PARTY_CHANGED")
		UnitFrame:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
		UnitFrame:UnregisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED")
		UnitFrame:UnregisterEvent("UNIT_PHASE")
		UnitFrame:UnregisterEvent("UNIT_CTR_OPTIONS")
		UnitFrame:UnregisterEvent("UNIT_FLAGS")
		UnitFrame:UnregisterEvent("PLAYER_GAINS_VEHICLE_DATA")
		UnitFrame:UnregisterEvent("PLAYER_LOSES_VEHICLE_DATA")
	end

	namePlate:SetScript("OnSizeChanged", NamePlate_OnSizeChanged)

	if not (kai.isPvP or db.disableObjectiveIcon or self.inPvP or self.inRaid or self.inChallengeMode) then
		if not kai._quest then
			kai._quest = true
			tinsert(npcPlates, kai)
		end
	end

	if refresh then return end

	kai:SetAlpha(0)
	kai:Show()
	tinsert(updatePlates, kai)
	kai.fadeIn = true
	kai.fadeOut = nil
end

function addon:NamePlateOnRemoved(namePlate, unitID)
	local kai = kaiPlates[namePlate]

	kai.unitID = ""
	kai.unitExists = nil
	kai.isTarget = nil
	kai.isMouseOver = nil
	kai.inRanged = nil
	kai:SetParent(ParentFrame1)
	kai:Hide()
	kai:UnregisterEvent("UNIT_HEALTH")
	kai:UnregisterEvent("UNIT_MAXHEALTH")
	kai:UnregisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")
	kai:UnregisterEvent("UNIT_THREAT_LIST_UPDATE")

	Kai_PowerBarSetup(kai)
	kai.castBar:SetUnit(nil, nil, nil)
	-- CastingBarFrame_SetUnit(kai.castBar, nil, nil, nil)
	Kai_AurasSetup(kai)

	if self.targetPlate == namePlate then
		self.targetPlate = nil
		self:SetTargetGlow()
	end

	if self.frame.highlightFrame == namePlate then
		self.frame.highlight:Hide()
		self.frame.highlightFrame = nil
	end

	kai.onQuest = nil
	kai.questTexture:Hide()
	kai.questTextureGlow:Hide()

	kai._status = nil
	kai._quest = nil
	kai.fadeOut = nil
end

function addon:OnTargetChanged(forceNoTarget)
	local kai = kaiPlates[self.targetPlate]
	if kai then
		kai.isTarget = nil
		if kai.displayHealthText then
			Kai_Refresh(kai)
		else
			Kai_UpdateStatusAlpha(kai)
			Kai_UpdateName(kai)
			if not kai.nameText:IsShown() then
				kai.statusText:Hide()
			end
			if kai.isBarShown then
				Kai_UpdateHealthMax(kai)
				Kai_UpdateAbsorb(kai)
				Kai_UpdateHealth(kai)
			end
		end
		kai:SetParent(ParentFrame1)
	end
	self.targetPlate = not UnitIsUnit("player", "target") and GetNamePlateForUnit("target") or nil
	for namePlate, kai in pairs(kaiPlates) do
		if namePlate == self.targetPlate then
			Kai_Refresh(kai)
		else
			kai.isTarget = nil
		end
	end

	ParentFrame1:SetAlpha(UnitExists("target") and 0.6 or 1)
	ParentFrame3:SetAlpha(UnitExists("target") and 0.85 or 1)
	if not self.loading then
		self:SetTargetGlow()
	end
end

function addon:NamePlateOnEnter(namePlate)
	local kai = kaiPlates[namePlate]
	kai.isMouseOver = true
	if not kai.unitExists then return end
	local unitID = kai.unitID
	Kai_UpdateStatusAlpha(kai)
	Kai_UpdateName(kai)
	if kai.isBarShown then
		Kai_UpdateHealthMax(kai)
		Kai_UpdateAbsorb(kai)
		Kai_UpdateHealth(kai)
	end
	Kai_UpdateStatusText(kai, true)

	if not kai.isTarget then
		kai:SetParent(ParentFrame3)
	end

	self.frame.highlight:SetKai(kai)
end

function addon:NamePlateOnLeave(namePlate)
	local kai = kaiPlates[namePlate]
	kai.isMouseOver = nil
	Kai_UpdateStatusAlpha(kai)
	Kai_UpdateName(kai)
	if kai.displayHealthText then
		Kai_UpdateStatusText(kai)
	elseif not kai.nameText:IsShown() then
		kai.statusText:Hide()
	end
	if not kai.isTarget then
		kai:SetParent(ParentFrame1)
	end
end

function addon:QueueSetCVar(key, value)
	if key and value and type(key) == "string" then
		if not self.cvarList then
			self.cvarList = {}
		end
		self.cvarList[key] = tostring(value)
	end
	if not InCombatLockdown() then
		if self.cvarList then
			for k, v in pairs(self.cvarList) do
				SetCVar(k, v)
				-- print("SetCVar:", k, GetCVar(k))
			end
			wipe(self.cvarList)
		end
	end
end

function addon:GetKai(plate)
	if type(plate) == "string" then
		plate = GetNamePlateForUnit(plate)
	elseif type(plate) == "number" then
		plate = _G["NamePlate"..plate]
	end
	return kaiPlates[plate]
end

function addon:SetNamePlateSize()
	if InCombatLockdown() then
		self._plateSize = true
		return
	end
	self._plateSize = nil
	SetCVar("NamePlateHorizontalScale", "1.0")
	SetCVar("NamePlateVerticalScale", "1.0")
	local height = 3 + floor(db.castBarHeight / 2) + db.healthBarHeight + db.nameFont.size + db.frameMargin.y
	local width = db.frameSize.W + db.frameMargin.x + db.frameMargin.x
	C_NamePlate.SetNamePlateEnemySize(width, height)
	if self.inWorld then
		if db.disableFriendlyBars then
			C_NamePlate.SetNamePlateFriendlySize(NamePlateDriverFrame:GetBaseNamePlateWidth() / 2, db.nameFont.size + 3)
		else
			C_NamePlate.SetNamePlateFriendlySize(width, height)
		end
		C_NamePlate.SetNamePlateFriendlyClickThrough(db.friendlyClickThrough)
	else
		if db.dungeonFriendlyBarMulti < 0.01 then
			db.dungeonFriendlyBarMulti = 0.1
		end
		C_NamePlate.SetNamePlateFriendlySize(width * db.dungeonFriendlyBarMulti, height * db.dungeonFriendlyBarMulti)
		C_NamePlate.SetNamePlateFriendlyClickThrough(db.dungeonFriendlyClickThrough)
	end
end

function addon:RestyleNamePlates()
	self:OnTargetChanged(true)

	self:SetBorderDefaultColor(db.borderColor)
	self:SetNamePlateSize()
	self.statusTextWidth = db.frameSize.W + db.frameMargin.x + db.frameMargin.x + 20
	self.CASTING_BAR_TYPES.applyingcrafting.filling = db.castBarTexture
	self.CASTING_BAR_TYPES.applyingcrafting.full = db.castBarTexture
	self.CASTING_BAR_TYPES.applyingtalents.filling = db.castBarTexture
	self.CASTING_BAR_TYPES.applyingtalents.full = db.castBarTexture
	self.CASTING_BAR_TYPES.standard.filling = db.castBarTexture
	self.CASTING_BAR_TYPES.standard.full = db.castBarTexture
	self.CASTING_BAR_TYPES.channel.filling = db.castBarTexture
	self.CASTING_BAR_TYPES.channel.full = db.castBarTexture
	self.CASTING_BAR_TYPES.interrupted.filling = db.castBarTexture
	self.CASTING_BAR_TYPES.interrupted.full = db.castBarTexture

	wipe(npcPlates)
	for _, kai in pairs(kaiPlates) do
		Kai_Restyle(kai)
		Kai_Refresh(kai)
	end

	ParentFrame2:SetFrameStrata(db.targetAlwaysOnTop and "MEDIUM" or "LOW")
	ParentFrame3:SetFrameStrata(db.targetAlwaysOnTop and "LOW" or "MEDIUM")

	self:OnTargetChanged()
end

function addon:ThreatUpdateAll()
	for _, namePlate in pairs(GetNamePlates()) do
		Kai_UpdateThreatBorder(kaiPlates[namePlate])
	end
end

function addon:UpdateRaidIcons()
	for _, namePlate in pairs(GetNamePlates()) do
		Kai_UpdateRaidIcon(kaiPlates[namePlate])
	end
end

function Kai_Refresh(kai, unitID)
	if not kai then return end
	if unitID and not UnitExists(unitID) then return end
	addon:NamePlateOnAdded(kai.plate, kai.unitID, true)
end

function addon:RefreshAll()
	for plate, kai in pairs(kaiPlates) do
		if plate:IsShown() then
			Kai_Refresh(kai, kai.unitID)
		end
	end
end

function addon:DisableBlizzard(suspend)
	addon.performanceMode = suspend > 0
	if suspend > 0 then
		-- NamePlateDriverFrame:UnregisterAllEvents()
		if GetCVarBool("nameplateShowSelf") then
			if not InCombatLockdown() then
				SetCVar("nameplateShowSelf", 0)
			end
		end

		local classFrames = {
			"NamePlateDriverFrame",
			"ClassNameplateManaBarFrame",
			"DeathKnightResourceOverlayFrame",
			"ClassNameplateBarMageFrame",
			"ClassNameplateBarWindwalkerMonkFrame",
			"ClassNameplateBrewmasterBarFrame",
			"ClassNameplateBarPaladinFrame",
			"ClassNameplateBarRogueDruidFrame",
			"ClassNameplateBarWarlockFrame",
			"ClassNameplateBarDracthyrFrame",
		}
		for _, name in pairs(classFrames) do
			local frame = _G[name]
			if frame then
				frame:UnregisterAllEvents()
				frame:SetScript("OnEvent", nil)
				frame:SetScript("OnUpdate", nil)
			end
		end
		wipe(classFrames)
	else
		NamePlateDriverFrame:UnregisterEvent("UNIT_AURA")
		NamePlateDriverFrame:RegisterUnitEvent("UNIT_AURA", "player")
	end
end

function addon:SetCVarDistance()
	local inDungeon = self.zoneType == "party"
	local inRaid = (self.zoneType == "raid") or (self.zoneType == "scenario")
	if inDungeon and db.nameplateDungeonDistanceEnabled then
		if tonumber(db.nameplateDungeonDistance) then
			self:QueueSetCVar("nameplateMaxDistance", db.nameplateDungeonDistance)
		end
	elseif inRaid and db.nameplateRaidDistanceEnabled then
		if tonumber(db.nameplateRaidDistance) then
			self:QueueSetCVar("nameplateMaxDistance", db.nameplateRaidDistance)
		end
	else
		if tonumber(db.nameplateMaxDistance) then
			self:QueueSetCVar("nameplateMaxDistance", db.nameplateMaxDistance)
		end
	end
end

do -- encounter modules
	addon.engagedEncounters = {}
	local modules = {}

	function addon:EncounterStart(id)
		if not self.engagedEncounters[id] then
			self.engagedEncounters[id] = true
			self:AurasUpdateFilters()
		end
		if modules[id] and not modules[id].enabled then
			if not modules[id].initialized then
				modules[id]:Init(id)
			end
			modules[id].enabled = true
			modules[id]:Enable()
		end
	end

	function addon:EncounterEnd(id)
		if self.engagedEncounters[id] then
			self.engagedEncounters[id] = nil
			self:AurasUpdateFilters()
		end
		if modules[id] and modules[id].enabled then
			modules[id].enabled = nil
			modules[id]:Disable()
		end
	end

	function addon:CheckEncounters()
		if not IsEncounterInProgress() then
			for id, v in pairs(self.engagedEncounters) do
				if v then
					self:EncounterEnd(id)
				end
			end
		end
	end
end

local function Font_UpdateShadow(font)
	local _, _, flags = font:GetFont()
	if flags == "" then
		font:SetShadowColor(0, 0, 0, 1)
		font:SetShadowOffset(1, -1.5)
	else
		font:SetShadowColor(0, 0, 0, 1)
		font:SetShadowOffset(0.5, -0.5)
	end
end

function addon:UpdateFonts()
	local filename = _G.GameFontWhite:GetFont()
	if not FontUnitNameNormal:SetFont(db.nameFont.name or filename, db.nameFont.size, db.nameFont.outline or "") then
		FontUnitNameNormal:SetFont(filename, db.nameFont.size, db.nameFont.outline)
	end
	Font_UpdateShadow(FontUnitNameNormal)
	if not FontUnitNamePlayer:SetFont(db.nameFontPlayer.name or filename, db.nameFontPlayer.size, db.nameFontPlayer.outline or "") then
		FontUnitNamePlayer:SetFont(filename, db.nameFont.size, db.nameFont.outline or "")
	end
	Font_UpdateShadow(FontUnitNamePlayer)
	local filename = _G.GameFontWhiteTiny:GetFont()
	if not FontUnitNameSmall:SetFont(db.castFont.name or filename, db.nameFont.size * 0.9, db.castFont.outline or "") then
		FontUnitNameSmall:SetFont(filename, db.nameFont.size * 0.9, db.castFont.outline or "")
	end
	Font_UpdateShadow(FontUnitNameSmall)
	if not FontSpellName:SetFont(db.castFont.name or filename, db.castFont.size, db.castFont.outline or "") then
		FontSpellName:SetFont(filename, db.castFont.size, db.castFont.outline or "")
	end
	Font_UpdateShadow(FontSpellName)
	local filename = _G.NumberFont_Shadow_Small:GetFont()
	if not FontNumber:SetFont(db.numFont.name or filename, db.numFont.size, db.numFont.outline or "") then
		FontNumber:SetFont(filename, db.numFont.size, db.numFont.outline or "")
	end
	Font_UpdateShadow(FontNumber)

	local dungeonFont = _G["NamePlateKAIFriendlyFont"..db.dungeonFont.size]
	if dungeonFont then
		SystemFont_NamePlateFixed:SetFontObject(dungeonFont)
	end
end

do -- profile
	local empty = {} -- dummy table
	local function tMergeCopy(base, src, dest, exclude)
		src = src or empty
		for k, v in pairs(base) do
			if k == exclude then

			elseif type(v) == "table" then
				if src[k] == nil or type(src[k]) == "table" then
					dest[k] = {}
					tMergeCopy(v, src[k], dest[k])
				else
					dest[k] = src[k]
				end
			else
				dest[k] = src[k]
				if dest[k] == nil then
					dest[k] = v
				end
			end
		end
	end

	local function tShallowCopy(src, dest) for k, v in pairs(src) do dest[k] = v end end

	function addon:LoadProfile(doFilterUpdate)
		local profile = _G.NamePlateKAIDB.profiles.Default
		-- tbl.ReleaseList(db)
		wipe(db)
		tMergeCopy(self.defaults, profile, db, "filters")
		self:ClearFilterCacheAll()

		if db.redHostile then
			db.barColors[1] = db.barColors.red
			db.barColors[2] = db.barColors.red
		end
		db.healthText.displayMax = db.healthText.displayMax and 1 or 2
		if not _G.OmniCC then
			db.disableOmnicc = true
		end
		if not GetCVarBool("countdownForCooldowns") then
			db.buff.countdownNumber = false
		end
		if not profile then
			db.showPlayerGuild = GetCVarBool("UnitNamePlayerGuild")
		end

		if profile then
			db.nameFont.name = profile.nameFont and profile.nameFont.name or nil
			db.nameFontPlayer.name = profile.nameFontPlayer and profile.nameFontPlayer.name or nil
			db.numFont.name = profile.numFont and profile.numFont.name or nil
			db.castFont.name = profile.castFont and profile.castFont.name or nil
			if db.nameFont.outline == "NONE" then db.nameFont.outline = "" end
			if db.nameFontPlayer.outline == "NONE" then db.nameFontPlayer.outline = "" end
			if db.numFont.outline == "NONE" then db.numFont.outline = "" end
			if db.castFont.outline == "NONE" then db.castFont.outline = "" end
			if not tonumber(db.nameFont.size) or tonumber(db.nameFont.size) < 1 then db.nameFont.size = addon.defaults.nameFont.size end
			if not tonumber(db.numFont.size) or tonumber(db.numFont.size) < 1 then db.numFont.size = addon.defaults.numFont.size end
			if not tonumber(db.castFont.size) or tonumber(db.castFont.size) < 1 then db.castFont.size = addon.defaults.castFont.size end
			if not tonumber(db.nameFontPlayer.size) or tonumber(db.nameFontPlayer.size) < 1 then db.nameFontPlayer.size = addon.defaults.nameFontPlayer.size end
		end

		self:UpdateFonts()
		if doFilterUpdate then
			self:UpdateFilter()
			self:AurasUpdateFilters()
			self:SetCVarDistance()
		end
		self:RestyleNamePlates()
		if not self.loading then
			self:UpdateRangeCheckerSpell()
		end
	end

	local function GetJournalLink(instanceID)
		local _, _, _, _, _, _, link, link2 = EJ_GetInstanceInfo(instanceID)
		if type(link2) == "string" then
			link = link2
		end
		if not link then
			return ("[%s %s (%d)]"):format(_G.UNKNOWN, _G.ZONE, instanceID)
		end
		local difficultyID = select(3, GetInstanceInfo())
		if difficultyID == 0 then
			difficultyID = IsInRaid() and GetRaidDifficultyID() or GetDungeonDifficultyID()
		end
		return link:gsub("(Hjournal:%d+:%d+:)(%d+)", "%1"..difficultyID)
	end

	local function GetDiffcultyString()
		local id = select(3, GetInstanceInfo())
		if id == 2 or id == 5 or id == 6 or id == 11 or id == 15 then
			return "Heroic"
		elseif id == 7 or id == 17 then
			return "*" -- LFR
		elseif id == 8 then
			return "Challenge"
		elseif id == 16 or id == 23 then
			return "Mythic"
		elseif id == 24 then
			return "Heroic" -- Timewalker
		end
		return "*" -- Normal
	end

	local diffParents = {
		["Mythic"] = "Heroic",
		["Challenge"] = "Heroic",
		["Heroic"] = "*",
		--["Normal"] = "*",
		--["LFR"] = "*",
		--["Timewalker"] = "Heroic",
	}

	local function CreateEmptyFilter(zone)
		return {zone = zone, color = {}, flags = {}, auras = {}}
	end

	local function ClearFilter(filter)
		-- for k, v in pairs(filter) do
		-- 	if type(v) == "table" then
		-- 		wipe(v)
		-- 	end
		-- end
		wipe(filter.color)
		wipe(filter.flags)
		wipe(filter.auras)
		wipe(filter)
	end

	local function EJ_GetSectionInfo(sectionID)
		local info = C_EncounterJournal.GetSectionInfo(sectionID)
		if info then
			return info.title, info.spellID ~= 0 and info.spellID or nil
		end
	end

	function addon:LoadFilter(zoneFilter, difficulty, dstFilter)
		local recolor, delete, name, color, filter, flags, noInherit
		local result = dstFilter or CreateEmptyFilter(zoneFilter.zone)
		if difficulty and difficulty:sub(1, 1) == "-" then
			difficulty = difficulty:sub(2)
			noInherit = true
		end
		while difficulty do
			filter = zoneFilter[difficulty]
			if not filter and difficulty == "*" then
				filter = zoneFilter
			end
			if filter then
				recolor = filter.recolor
				if type(recolor) == "table" then
					for k, v in pairs(recolor) do
						if type(k) == "number" and k > 0 then
							name = k
						elseif type(k) == "string" then
							if tonumber(k) then
								name = tonumber(k) < 0 and EJ_GetEncounterInfo(- tonumber(k)) or EJ_GetSectionInfo(tonumber(k))
							else
								name = k
							end
						else
							name = nil
						end
						if name then
							color = (type(v) == "string" and ClassColors[v]) or (type(v) == "number" and db.filterColors[v]) or v
							if result.color[name] == nil then
								if type(name) == "number" then
									result.color[name] = type(color) == "table" and color or false
								else
									result.color[name] = type(color) == "table" and color or false
								end
							end
						end
					end
				end
				flags = filter.flags
				if type(flags) == "table" then
					for category, data in pairs(flags) do
						for k, v in pairs(data) do
							result.flags[k] = v
						end
					end
				end
				if type(filter.auras) == "table" then
					for k, v in pairs(filter.auras) do
						tinsert(result.auras, v)
					end
				end
				if filter.noInherit then break end
			end
			if noInherit then break end
			difficulty = diffParents[difficulty]
		end

		for k, v in pairs(result.color) do if type(v) ~= "table" then result.color[k] = nil end end

		return result
	end

	function addon:LoadUserFilter(filterID, baseFilter, rawColor)
		local userFilter = _G.NamePlateKAIFilter and _G.NamePlateKAIFilter[filterID] or nil
		if not userFilter or not userFilter.recolor then return end

		local name, color
		for k, v in pairs(userFilter.recolor) do
			if type(k) == "number" and k > 0 then
				name = k
			elseif type(k) == "string" then
				if tonumber(k) then
					name = tonumber(k) < 0 and EJ_GetEncounterInfo(- tonumber(k)) or EJ_GetSectionInfo(tonumber(k))
				else
					name = k
				end
			else
				name = nil
			end
			if name then
				if rawColor then
					baseFilter.color[name] = v
				else
					color = (type(v) == "string" and ClassColors[v]) or (type(v) == "number" and db.filterColors[v]) or v
					if color == false then
						baseFilter.color[name] = nil
						baseFilter.flags[name] = nil
					elseif type(color) == "table" then
						baseFilter.color[name] = color
					end
				end
			end
		end
	end

	local function GetRepresentFilterID(mapID)
		local groupID = C_Map.GetMapGroupID(mapID)
		if not groupID then return end
		for k, v in pairs(addon.defaultFilters) do
			if type(k) == "string" and type(v) == "table" then
				if v.group == groupID then
					return k
				end
			end
		end
	end

	local cache = {}
	function addon:UpdateFilter()
		local mapID = tonumber(C_Map.GetBestMapForUnit("player")) or -1
		local filterID = "map"..mapID

		if not self.defaultFilters[filterID] then
			filterID = GetRepresentFilterID(mapID)
			if not filterID then
				filterID = addon.MapAreaID[mapID] or -1
			end
		end

		if not self.defaultFilters[filterID] then
			if self.zoneType == "island" then -- island expeditions
				filterID = self.zoneType
			elseif self.zoneType ~= "none" then -- scenario
				filterID = self.zoneType..self.instanceID
			end
		end

		if not filterID then return end
		local filterChanged = self.filterID ~= filterID
		self.filterID = filterID
		wipe(self.filter.color)
		wipe(self.filter.flags)
		wipe(self.filter.auras)
		local difficulty = GetDiffcultyString()
		local zoneFilter = self.defaultFilters[filterID]
		if not zoneFilter then
			filterID = "default"
			zoneFilter = self.defaultFilters.default
		end

		local filter = cache[filterID] and cache[filterID][difficulty] or nil
		if not filter then
			if db.disableDefaultFilters then
				filter = CreateEmptyFilter(zoneFilter.zone)
			else
				filter = self:LoadFilter(zoneFilter, difficulty)
				-- self:LoadInstanceModifiedFilter(zoneFilter, filter)
			end
			self:LoadGlobalFilter(filter, difficulty)
			self:LoadUserFilter(filterID, filter)
			cache[filterID] = cache[filterID] or {}
			cache[filterID][difficulty] = filter
			local zone = type(filter.zone) == "number" and GetJournalLink(filter.zone) or ("["..(filter.zone or filterID).."]")
			if filterChanged then
				DEFAULT_CHAT_FRAME:AddMessage("|cff3399ff[NamePlateKAI "..addon.version.."]:|r filter loaded "..zone)
			end
		end

		tShallowCopy(filter.color, self.filter.color)
		tShallowCopy(filter.flags, self.filter.flags)
		tShallowCopy(filter.auras, self.filter.auras)
		return true
	end

	-- function addon:LoadInstanceModifiedFilter(zonefilter, dstFilter)
	-- 	if not self.instanceModifiedInfo then return end
	--
	-- 	-- Fated Raid
	-- 	self:LoadFilter(zonefilter, "Fated", dstFilter)
	-- end

	function addon:LoadGlobalFilter(dstFilter, difficulty)
		local globalFilter = cache.global and cache.global[difficulty]
		if not globalFilter then
			if db.disableDefaultFilters then
				globalFilter = CreateEmptyFilter(self.defaultFilters.global.zone)
			else
				globalFilter = self:LoadFilter(self.defaultFilters.global, difficulty)
				-- self:LoadInstanceModifiedFilter(self.defaultFilters.global, globalFilter)
			end
			self:LoadUserFilter("global", globalFilter)
			cache.global = cache.global or {}
			cache.global[difficulty] = globalFilter
		end
		for k, v in pairs(globalFilter.color) do
			if not dstFilter.color[k] then
				dstFilter.color[k] = v
			end
		end
		for k, v in pairs(globalFilter.flags) do
			if not dstFilter.flags[k] then
				dstFilter.flags[k] = v
			end
		end
		for k, v in pairs(globalFilter.auras) do
			tinsert(dstFilter.auras, v)
		end
	end

	function addon:ClearFilterCacheAll()
		for filterID, _ in pairs(cache) do
			self:ClearFilterCache(filterID)
		end
		wipe(cache)
	end

	function addon:ClearFilterCache(filterID)
		if not cache[filterID] then return end
		for difficulty, filter in pairs(cache[filterID]) do
			ClearFilter(filter)
		end
		wipe(cache[filterID])
		cache[filterID] = nil
	end
end

do
	addon.frame.highlight = addon.frame:CreateTexture()
	addon.frame.highlight:SetTexture("Interface\\Addons\\NamePlateKAI\\texture\\highlight")
	addon.frame.highlight:SetVertexColor(1, 1, 0.7)
	addon.frame.highlight:SetDrawLayer("OVERLAY")
	addon.frame.highlight:SetAlpha(0.1)
	addon.frame.highlight:SetBlendMode("ADD")

	function addon.frame.highlight:SetKai(kai)
		self:SetParent(kai)
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT", kai, "TOPLEFT", -1, 1)
		self:SetPoint("BOTTOMRIGHT", kai, "BOTTOMRIGHT", 1, -1)
		self:SetShown(kai.isBarShown)
		self:SetAlpha(0.09)
		addon.frame.highlightFrame = kai.plate
	end

	local IsMouseButtonDown = IsMouseButtonDown

	local npcTimer = 0
	local kai
	function addon.frame:OnUpdate(elapsed)
		if self.taskEnabled then
			addon.scheduler:Update(elapsed)
		end
		if self.highlightFrame and not IsMouseButtonDown(1, 2) and not UnitExists("mouseover") then
			addon:NamePlateOnLeave(self.highlightFrame)
			self.highlight:Hide()
			self.highlightFrame = nil
		end
		if npcTimer == 0 then
			if #npcPlates > 0 then
				npcTimer = 1
				kai = tremove(npcPlates)
				if kai._status then
					Kai_UpdateStatusText(kai, true)
				elseif kai._quest then
					Kai_UpdateQuestIcon(kai)
				end
			end
		else
			npcTimer = npcTimer - 1
		end
		if #updatePlates > 0 then
			for i = 1, #updatePlates do
				kai = updatePlates[i]
				if kai.refresh then
					kai.refresh = nil
					Kai_Refresh(kai)
				end
				if db.dynamicOpacity then
					NamePlate_OnUpdate(kai.plate)
				else
					kai:SetAlpha(1)
				end
				kai.fadeIn = nil
				if kai.isNew then
					kai.isNew = nil
				end
			end
			wipe(updatePlates)
		end
	end
end

local events = addon.events

do -- power
	local pool = {}
	local powerBarPrototype = {}
	local powerBarMT = {__index = powerBarPrototype}
	local UnitPower, UnitPowerMax, UnitPowerType = UnitPower, UnitPowerMax, UnitPowerType

	function powerBarPrototype:New()
		local bar = setmetatable({}, powerBarMT)
		bar.powerTexture = addon.frame:CreateTexture(nil, "ARTWORK", nil, 2)
		bar.powerTexture:SetTexture(137014)
		return bar
	end

	function powerBarPrototype:SetValue(value)
		self.value = value or UnitPower(self.unitID, self.powerType or nil)
		if self.max and self.value and self.max > 0 and self.value > 0 then
			self.powerTexture:SetWidth(self.value / self.max * db.frameSize.W)
		else
			self.powerTexture:SetWidth(0.0001)
		end
	end

	function powerBarPrototype:UpdateMax()
		self.max = UnitPowerMax(self.unitID, self.powerType or nil)
	end

	local PowerColors = {
		[0] = {r = 0.15, g = 0.55, b = 1}, -- Mana
		[5] = {r = 0.7, g = 0.7, b = 0.7}, -- Runes
		[7] = {r = 0.9, g = 0.2, b = 0.8}, -- Soul Shards
		[8] = {r = 0.7, g = 0.9, b = 1}, -- Lunar Power
		[11] = {r = 0.7, g = 0.9, b = 1}, -- Maelstrom
		[13] = {r = 0.7, g = 0.3, b = 1}, -- Insanity
		default = {r = 0.7, g = 0.7, b = 0.8},
	}
	setmetatable(PowerColors, {__index =
		function(self, key)
			local value = _G.PowerBarColor[key]
			if type(value) == "table" and value.r and value.g and value.b then

			else
				value = self.default
			end
			self[key] = value
			return value
		end
	})

	function powerBarPrototype:UpdateBarColor()
		local color = PowerColors[self.colorIndex or self.powerType]
		self.powerTexture:SetVertexColor(color.r, color.g, color.b)
	end

	function powerBarPrototype:SetPowerType(powerType)
		powerType = powerType or self.primaryPowerType
		if powerType and UnitPowerMax(self.unitID, powerType) > 0 then
			self.powerType = powerType
		else
			self.powerType = UnitPowerType(self.unitID) or nil
		end
		self:UpdateBarColor()
	end

	function powerBarPrototype:SetKai(kai, powerType)
		self.unitID = kai.unitID
		self.primaryPowerType = powerType
		self.colorIndex = kai.powerBarColorIndex or 0
		self.powerTexture:SetParent(kai)
		self.powerTexture:ClearAllPoints()
		self.powerTexture:SetPoint("BOTTOMLEFT", kai, "TOPLEFT", 0, 0)
		self.powerTexture:SetHeight(4.5)
		self:SetPowerType()
		self:UpdateMax()
		self:SetValue()
		self.powerTexture:Show()
		self.powerTexture:SetShown(self.max and self.max > 0)
	end

	function powerBarPrototype:Hide()
		self.powerTexture:Hide()
		self.unitID = ""
		self.powerType = nil
		self.max = nil
		self.value = nil
	end

	function Kai_PowerBarSetup(kai, showPower, powerType)
		if kai.unitExists and kai.isBarShown and showPower then
			if not kai.powerBar then
				kai.powerBar = tremove(pool) or powerBarPrototype:New()
			end
			kai.powerBar:SetKai(kai, powerType)
			kai:RegisterEvent("UNIT_POWER_UPDATE", kai.unitID)
			kai:RegisterEvent("UNIT_MAXPOWER", kai.unitID)
			kai:RegisterEvent("UNIT_DISPLAYPOWER", kai.unitID)
		else
			if kai.powerBar then
				kai.powerBar:Hide()
				tinsert(pool, kai.powerBar)
				kai.powerBar = nil
				kai:UnregisterEvent("UNIT_POWER_UPDATE")
				kai:UnregisterEvent("UNIT_MAXPOWER")
				kai:UnregisterEvent("UNIT_DISPLAYPOWER")
			end
		end
	end
end

do -- Auras
	function Aura_SetStyle(self)
		if not self then return end
		local kai = self:GetParent()
		local cooldown = self.cooldown
		self:ClearAllPoints()
		-- self.cooldown:SetPoint("BOTTOMLEFT", self.cooldown:GetParent(), "TOPLEFT", db.buff.offset.x + db.buff.borderSize + db.buff.borderSize + (self.index - 1) * (db.buff.size.W + 2), db.nameFont.size + db.buff.offset.y + db.buff.borderSize)
		if self.index == 1 then
			if kai.isBarShown then
				self:SetPoint("BOTTOMLEFT", kai, "TOPLEFT", db.buff.offset.x + db.buff.borderSize, (kai.nameText:IsShown() and db.nameFont.size or -2) + db.buff.offset.y + db.buff.borderSize)
			else
				self:SetPoint("BOTTOMRIGHT", kai, "TOP", db.buff.offset.x - db.buff.borderSize, db.nameFont.size + db.buff.offset.y + db.buff.borderSize - 2)
			end
		else
			self:SetPoint("BOTTOMLEFT", kai.buffs[self.index - 1], "BOTTOMRIGHT", db.buff.borderSize + db.buff.borderSize + 2, 0)
		end
		cooldown:SetHideCountdownNumbers(not db.buff.countdownNumber or not db.disableOmnicc)
		cooldown.noCooldownCount = db.disableOmnicc or nil
		if not self.spellID then
			self:SetSize(db.buff.size.W - db.buff.borderSize, db.buff.size.H - db.buff.borderSize)
		end
		self.bg:SetPoint("TOPLEFT", -db.buff.borderSize, db.buff.borderSize)
		self.bg:SetPoint("BOTTOMRIGHT", db.buff.borderSize, -db.buff.borderSize)

		if db.buff.countdownNumber and db.disableOmnicc then
			if not self.countdown then -- Get Blizz Countdown String
				for k, v in pairs({cooldown:GetRegions()}) do
					if v:GetObjectType() == "FontString" and v ~= self.nums then
						self.countdown = v
						break
					end
				end
			end
			if self.countdown then
				self.countdown:SetFontObject(NumberFontNormalSmall)
				self.countdown:ClearAllPoints()
				self.countdown:SetPoint("CENTER", cooldown, "TOPLEFT", 1, 3)
			end
		end

	end

	local function Buff_Hide(self)
		self:Hide()
		self.spellID = nil
		self.expire = nil
		self.caster = nil
		self.duration = nil
	end

	local function Buff_Show(self)
		self:Show()
	end

	local function CreateBuff(kai)
		local buff = CreateFrame("Frame", nil, kai, addon.auraTemplate or "KaiAuraFrameTemplate")
		buff:SetMouseClickEnabled(false)

		tinsert(kai.buffs, buff)
		buff.index = #kai.buffs
		Aura_SetStyle(buff)
		return buff
	end

	local UnitAura, UnitBuff, UnitDebuff, CooldownFrame_Set = UnitAura, UnitBuff, UnitDebuff, CooldownFrame_Set
	local _, shouldShowFunc, info, unit, index, buff, name, texture, count, auraType, duration, expire, caster, nameplatePersonal, spellID, nameplateAll, isBoss, canApplyAura
	local pool = {}
	local friendlyBuffList = {}
	local friendlyDebuffList = {}
	local enemyBuffList = {}
	local enemyDebuffList = {}

	local function UnitBuffByName(unit, spellName, filters)
		if not spellName then return end
		for i = 1, 50 do
			name, texture, count, auraType, duration, expire, caster, _, nameplatePersonal, spellID, canApplyAura, isBoss, _, nameplateAll = UnitBuff(unit, i, filters)
			if not name then return end
			if name == spellName then
				return name, texture, count, auraType, duration, expire, caster, _, nameplatePersonal, spellID, canApplyAura, isBoss, _, nameplateAll
			end
		end
	end

	local function UnitDebuffByName(unit, spellName, filters)
		if not spellName then return end
		for i = 1, 50 do
			name, texture, count, auraType, duration, expire, caster, _, nameplatePersonal, spellID, canApplyAura, isBoss, _, nameplateAll = UnitDebuff(unit, i, filters)
			if not name then return end
			if name == spellName then
				return name, texture, count, auraType, duration, expire, caster, _, nameplatePersonal, spellID, canApplyAura, isBoss, _, nameplateAll
			end
		end
	end

	function addon.UnitAuraID(unit, spellName, filters)
		if not spellName then return end
		if filters == true then
			return addon.UnitAuraID(unit, spellName) or addon.UnitAuraID(unit, spellName, "HARMFUL")
		end
		for i = 1, 50 do
			name, _, _, _, _, _, _, _, _, spellID = UnitAura(unit, i, filters)
			if not name then return end
			if name == spellName then
				return spellID
			end
		end
	end

	local function ClearList(list)
		for k, v in pairs(list) do
			wipe(v)
		end
		wipe(list)
	end

	local function GetList(filter)
		if filter.friendly then
			return filter.buff and friendlyBuffList or friendlyDebuffList
		else
			return filter.buff and enemyBuffList or enemyDebuffList
		end
	end

	function addon:AurasClearAllFilters()
		ClearList(friendlyBuffList)
		ClearList(friendlyDebuffList)
		ClearList(enemyBuffList)
		ClearList(enemyDebuffList)
	end

	function addon:AurasAddFilter(filter)
		local list = GetList(filter)
		info = list[filter.spellID]
		if not info then
			info = {}
			list[filter.spellID] = info
		end
		info.player = filter.player or nil
		info.show = true
		if filter.show ~= nil then
			info.show = filter.show
		elseif filter.hide ~= nil then
			info.show = not filter.hide
		end
		info.enlarge = filter.enlarge or nil
		info.emphasize = filter.emphasize or nil
		if type(filter.color) == "number" and addon.defaults.filterColors[filter.color] then
			info.colorR, info.colorG, info.colorB = unpack(addon.defaults.filterColors[filter.color], 1, 3)
		elseif type(filter.color) == "string" and addon.defaults.barColors[filter.color] then
			info.colorR, info.colorG, info.colorB = unpack(addon.defaults.barColors[filter.color], 1, 3)
		elseif type(filter.color) == "string" and ClassColors[filter.color] then
			info.colorR, info.colorG, info.colorB = unpack(ClassColors[filter.color], 1, 3)
		elseif type(filter.color) == "table" then
			info.colorR, info.colorG, info.colorB = filter.color[1] or 0, filter.color[2] or 0, filter.color[3] or 0
		elseif filter.r and filter.g and filter.b then
			info.colorR, info.colorG, info.colorB = filter.r, filter.g, filter.b
		end
	end

	function addon:AurasRemoveFilter(filter)
		local list = GetList(filter)
		info = list[filter.spellID]
		if info then
			list[filter.spellID] = nil
			wipe(info)
			return true
		end
	end

	local function AuraFilterIsActive(filter)
		if filter.disabled then return end
		if filter.zoneType == "mythicplus" then
			if not addon.inChallengeMode then return end
		elseif filter.zoneType then
			if filter.zoneType ~= addon.zoneType then return end
		end
		if filter.affixID and not addon.affixes[filter.affixID] then return end
		if filter.filterID and filter.filterID ~= addon.filterID then return end
		if filter.zoneInstanceID and filter.zoneInstanceID ~= addon.instanceID then return end
		if filter.encounterID and not addon.engagedEncounters[filter.encounterID] then return end
		if filter.activateFunc and not filter.activateFunc(filter) then return end
		return true
	end

	local function FilterCompareNum(value1, value2)
		return (tonumber(value1) or -1) < (tonumber(value2) or -1)
	end

	local function FilterCompareString(value1, value2)
		return tostring(value1 or "") < (tostring(value2 or ""))
	end

	local function FilterCompare(filter1, filter2)
		if filter1.spellID ~= filter2.spellID then
			return FilterCompareNum(filter1.spellID, filter2.spellID)
		elseif (filter1.zoneType or filter2.zoneType) and filter1.zoneType ~= filter2.zoneType then
			return FilterCompareString(filter1.zoneType, filter2.zoneType)
		elseif (filter1.filterID or filter2.filterID) and filter1.filterID ~= filter2.filterID then
			return FilterCompareString(filter1.filterID, filter2.filterID)
		elseif (filter1.instanceID or filter2.instanceID) and filter1.instanceID ~= filter2.instanceID then
			return FilterCompareNum(filter1.instanceID, filter2.instanceID)
		elseif (filter1.encounterID or filter2.encounterID) and filter1.encounterID ~= filter2.encounterID then
			return FilterCompareNum(filter1.encounterID, filter2.encounterID)
		else
			return tostring(filter1) < tostring(filter2)
		end
	end

	function addon:GetAuraCompareFunc()
		return FilterCompare
	end

	function addon:AurasUpdateFilters()
		self:AurasClearAllFilters()

		for k, filter in pairs(addon.filter.auras) do
			if type(filter.spellID) == "number" and AuraFilterIsActive(filter) then
				self:AurasAddFilter(filter)
			end
		end

		local filters = _G.NamePlateKAIAura
		if filters then
			sort(filters, FilterCompare)

			local filter
			for i = 1, #filters do
				filter = filters[i]
				if type(filter.spellID) == "number" then
					self:AurasAddFilter(filter)
				end
			end
		end

		for plate, kai in pairs(kaiPlates) do
			if plate:IsShown() then
				for i = 1, #kai.buffs do
					Buff_Hide(kai.buffs[i])
				end
				Kai_AurasSetup(kai)
			end
		end
	end

	local function ShouldShowFriendlyBuffList(kai)
		if friendlyBuffList[spellID] then
			info = friendlyBuffList[spellID]
			if not info.player or caster == "player" then
				return info.show
			end
		end
	end

	local function ShouldShowFriendlyDebuff()
		return isBoss
	end

	local function ShouldShowFriendlyDebuffList(kai)
		if friendlyDebuffList[spellID] then
			info = friendlyDebuffList[spellID]
			if not info.player or caster == "player" then
				return info.show
			end
		end
		return isBoss
	end

	local InfoEnrage = {
		id = "global:ENRAGE", spellID = 0, buff = true, enlarge = false, emphasize = true, colorR = 1, colorG = 0.5, colorB = 0.2,
	}

	local InfoMagic = {
		id = "global:MAGIC", spellID = 0, buff = true, enlarge = false, emphasize = false, color = 10,
	}

	local function ShouldShowEnemyBuff(kai)
		if kai.buffShowMagic and auraType == "Magic" then
			info = InfoMagic
			return true
		elseif kai.buffShowEnrage and auraType == "" then
			info = InfoEnrage
			return true
		end
	end

	local function ShouldShowEnemyBuffList(kai)
		if enemyBuffList[spellID] then
			info = enemyBuffList[spellID]
			if not info.player or caster == "player" then
				return info.show
			end
		else
			return ShouldShowEnemyBuff(kai)
		end
	end

	local function ShouldShowEnemyDebuff()
		return nameplateAll or (nameplatePersonal and (caster == "player" or caster == "pet" or caster == "vehicle"))
	end

	local function ShouldShowEnemyDebuffList(kai)
		if enemyDebuffList[spellID] then
			info = enemyDebuffList[spellID]
			if not info.player or caster == "player" then
				return info.show
			end
		end
		return nameplateAll or (nameplatePersonal and (caster == "player" or caster == "pet" or caster == "vehicle"))
	end

	local function UpdateBuff(kai)
		info = nil
		if canApplyAura then isBoss = false end
		if not shouldShowFunc(kai) then return end
		buff = kai.buffs[index] or CreateBuff(kai)
		if buff.spellID ~= spellID or buff.expire ~= expire or buff.caster ~= caster or buff.count ~= count then
			buff.spellID = spellID
			buff.expire = expire
			buff.caster = caster
			buff.count = count
			buff.icon:SetTexture(texture)
			buff:SetIgnoreParentAlpha(isBoss or info and info.emphasize or false)
			if count > 1 then
				buff.nums:SetText(count)
				buff.nums:Show()
			else
				buff.nums:Hide()
			end
			if duration > 0 then
				CooldownFrame_Set(buff.cooldown, expire - duration, duration, true, true)
			else
				buff.cooldown:SetDrawEdge(false);
				buff.cooldown:SetCooldown(-1, 1)
			end
			if isBoss or info and info.enlarge then
				buff:SetSize(db.buff.size.W * db.buff.bossScale, db.buff.size.H * db.buff.bossScale)
			else
				buff:SetSize(db.buff.size.W - db.buff.borderSize, db.buff.size.H - db.buff.borderSize)
			end
			if isBoss then
				buff.bg:SetVertexColor(1, 0, 0.5)
			elseif info and info.colorR then
				buff.bg:SetVertexColor(info.colorR, info.colorG, info.colorB)
			elseif caster == "player" or caster == "vehicle" or caster == "pet" or caster == nil or UnitIsUnit("player", caster) or UnitIsUnit("pet", caster) then
				buff.bg:SetVertexColor(0, 0, 0)
			elseif UnitPlayerOrPetInGroup(caster) then
				buff.bg:SetVertexColor(0, 0.35, 0.75)
			else
				buff.bg:SetVertexColor(0, 0, 0)
			end
		end
		Buff_Show(buff)
		index = index + 1
		return true
	end

	function Kai_AurasSetup(kai)
		kai.buffFunc = nil
		kai.debuffFunc = nil
		kai.buffShowMagic = nil
		kai.buffShowEnrage = nil
		if kai.unitExists and not kai.ignoreAuras then
			if kai.reaction > 4 then
				if db.buff.enabledFriendly then
					kai.buffFunc = next(friendlyBuffList) and ShouldShowFriendlyBuffList or nil
					kai.debuffFunc = next(friendlyDebuffList) and ShouldShowFriendlyDebuffList or ShouldShowFriendlyDebuff
				end
			else
				if db.buff.enabledEnemy then
					kai.buffShowMagic = db.buff.showMagic
					kai.buffShowEnrage = db.buff.showEnrage
					kai.buffFunc = next(enemyBuffList) and ShouldShowEnemyBuffList
					if not kai.buffFunc and (kai.buffShowMagic or kai.buffShowEnrage) then
						kai.buffFunc = ShouldShowEnemyBuff
					end
					kai.debuffFunc = next(enemyDebuffList) and ShouldShowEnemyDebuffList or ShouldShowEnemyDebuff
				end
			end
		end
		Kai_AurasUpdate(kai)
		if kai.buffFunc or kai.debuffFunc then
			kai:RegisterUnitEvent("UNIT_AURA", kai.unitID)
		else
			kai:UnregisterEvent("UNIT_AURA")
		end
	end

	function Kai_AurasUpdate(kai)
		index = 1
		unit = kai.unitID
		if kai.buffFunc then
			shouldShowFunc = kai.buffFunc
			for i = 1, 30 do
				name, texture, count, auraType, duration, expire, caster, _, nameplatePersonal, spellID, canApplyAura, isBoss, _, nameplateAll = UnitBuff(unit, i)
				if not name then break end
				if UpdateBuff(kai) and index > 5 then break end
			end
		end
		if kai.debuffFunc then
			shouldShowFunc = kai.debuffFunc
			for i = 1, 50 do
				name, texture, count, auraType, duration, expire, caster, _, nameplatePersonal, spellID, canApplyAura, isBoss, _, nameplateAll = UnitDebuff(unit, i)
				if not name then break end
				if UpdateBuff(kai) and index > 5 then break end
			end
		end
		for i = index, #kai.buffs do
			Buff_Hide(kai.buffs[i])
		end
	end
end

do -- Quest Objective
	local quests = {}

	-- local FORMAT_QUESTOBJECTIVE = "^.-%s*%-*%s*(.+)"
	local FORMAT_QUEST_OBJECTS_FOUND = "^(%d+)/(%d+)"
	local FORMAT_QUEST_OBJECTS_PROGRESS = "%((%d+)%%%)$"

	local inProgress, line, objectives, unitName, d1, d2, d3, lineObj, result, questName
	result = {}

	local function IsUnitOnQuest(unitID)
		local tooltipData = C_TooltipInfo.GetUnit(unitID)
		if not tooltipData then return end
		inProgress = nil
		objectives = nil
		unitName = nil
		questName = nil
		wipe(result)
		for i = 2, #tooltipData.lines do
			lineObj = tooltipData.lines[i]
			TooltipUtil.SurfaceArgs(lineObj)
			line = lineObj.leftText
			if line and #line > 1 then
				if quests[line] or (lineObj.type == 0) then -- title
					if lineObj.leftColor.b == 0 and lineObj.leftColor.g < 0.83 then
						if line == addon.playerName then
							unitName = nil
						elseif UnitInParty(line) then
							unitName = line
						else
							objectives = quests[line]
							if objectives then
								questName = line
								unitName = nil
								inProgress = nil
								result[questName] = objectives[2] ~= "*"
							end
						end
					end
				elseif unitName == nil and (lineObj.type == 8) and objectives then -- objective
					if objectives[2] == "*" then -- completed
						result[questName] = false
					else
						if line then -- player's quest
							if inProgress == nil then
								result[questName] = false
							end
							d1 = strmatch(line, FORMAT_QUEST_OBJECTS_PROGRESS)
							if d1 and (tonumber(d1) < 100) then
								inProgress = true
							else
								inProgress = true
								for j = 2, #objectives do
									if line == objectives[j] then
										inProgress = false
										break
									end
									d3, d1 = strmatch(objectives[j], FORMAT_QUEST_OBJECTS_FOUND)
									if d3 and (d3 == d1) then
										d1, d2 = strmatch(line, FORMAT_QUEST_OBJECTS_FOUND)
										if (d1 == d3) and (d2 == d3) then
											inProgress = false
											break
										end
									end
								end
								if inProgress then
									if lineObj.leftColor.r < 0.51 and lineObj.leftColor.g < 0.51 and lineObj.leftColor.b < 0.51 then
										inProgress = false
									end
								end
							end
							if inProgress then
								result[questName] = true
								-- break
							end
						end
					end
				end
			end
		end

		if next(result) then
			inProgress = false
			for k, v in pairs(result) do
				if v then
					inProgress = true
				end
			end

			local frequency = -9999999
			for k, v in pairs(result) do
				objectives = quests[k]
				if objectives then
					if v == inProgress then
						if objectives[1] > frequency then
							frequency = objectives[1]
						end
					end
				end
			end

			return true, inProgress, frequency
		end
	end

	function Kai_UpdateQuestIcon(kai)
		kai._quest = nil
		if not kai.unitExists or kai.fadeOut then return end
		local onQuest, inProgress, questFrequency
		if not db.disableObjectiveIcon then
			onQuest, inProgress, questFrequency = IsUnitOnQuest(kai.unitID)
		end
		kai.questTexture:SetShown(onQuest)
		kai.questTextureGlow:Hide()
		if onQuest then
			if questFrequency == -1 then -- World Quest
				kai.questTexture:SetAtlas("PetJournal-FavoritesIcon")
				kai.questTexture:SetSize(16, 16)
			elseif questFrequency >= 100 then -- Campaign
				kai.questTexture:SetAtlas("Quest-Campaign-Available")
				kai.questTexture:SetSize(13, 13)
				kai.questTextureGlow:SetDesaturated(false)
				kai.questTextureGlow:Show()
			else
				kai.questTexture:SetAtlas("SmallQuestBang")
				kai.questTexture:SetSize(17, 17)
			end
			if inProgress then -- in progress
				if questFrequency >= 1 and questFrequency < 100 then -- Daily
					kai.questTexture:SetDesaturated(true)
					kai.questTexture:SetVertexColor(0.15, 0.55, 1.0)
				elseif questFrequency < -2 then -- Scenario Criteria
					kai.questTexture:SetDesaturated(true)
					kai.questTexture:SetVertexColor(0.15, 1.0, 0.4)
				elseif questFrequency < -1 then -- Bonus Objective
					kai.questTexture:SetDesaturated(true)
					kai.questTexture:SetVertexColor(1, 0.5, 0.0)
				else
					kai.questTexture:SetDesaturated(false)
					kai.questTexture:SetVertexColor(1, 1, 1)
				end
			else
				kai.questTexture:SetDesaturated(true)
				kai.questTexture:SetVertexColor(0.5, 0.55, 0.6)
				if questFrequency >= 100 then
					-- kai.questTextureGlow:SetDesaturated(true)
					kai.questTextureGlow:Hide()
				end
			end
		end
		kai.onQuest = onQuest
		Kai_UpdateName(kai)
	end

	local ignoredScenarioTypes = {
		[LE_SCENARIO_TYPE_CHALLENGE_MODE] = true,
		[LE_SCENARIO_TYPE_PROVING_GROUNDS] = true,
		[LE_SCENARIO_TYPE_USE_DUNGEON_DISPLAY] = true,
		[LE_SCENARIO_TYPE_LEGION_INVASION] = false,
		[LE_SCENARIO_TYPE_BOOST_TUTORIAL] = false,
		[LE_SCENARIO_TYPE_WARFRONT] = false,
	}
	local scenarioObjectives = {}
	local function GetScenarioObjectives()
		wipe(scenarioObjectives)
		local scenarioName, currentStage, numStages, _, _, _, scenarioCompleted, _, _, scenarioType, areaName = C_Scenario.GetInfo()
		if ignoredScenarioTypes[scenarioType or 0] then return end
		if scenarioName then
			scenarioObjectives[0] = 0
			scenarioObjectives[1] = -3
			if scenarioCompleted then
				scenarioObjectives[2] = "*"
			elseif numStages > 0 then
				local name, description, numCriteria, _, _, _, _, _, _, weightedProgress = C_Scenario.GetStepInfo()
				if numCriteria > 0 then
					for i = 1, numCriteria do
						local criteriaString, criteriaType, completed, quantity, totalQuantity, _, _, quantityString, criteriaID, _, _, _, isWeightedProgress = C_Scenario.GetCriteriaInfo(i)
						if criteriaString then
							if isWeightedProgress then
								criteriaString = ("%s %d%%"):format(criteriaString, completed and 100 or quantity)
							else
								criteriaString = ("%d/%d %s"):format(completed and totalQuantity or quantity, totalQuantity, criteriaString)
							end
							tinsert(scenarioObjectives, criteriaString)
						end
					end
					-- DevTools_Dump(scenarioObjectives)
				end
			end
			return scenarioName
		end
	end

	local function IsScenarioObjective(objective)
		return objective[0] == 0 and objective[1] == -3
	end

	local function UpdateActiveScenario()
		for k, v in pairs(quests) do
			if IsScenarioObjective(v) then
				quests[k] = nil
			end
		end
		local scenarioName = GetScenarioObjectives()
		if scenarioName then
			quests[scenarioName] = scenarioObjectives
		end
	end

	local function UpdateActiveQuests()
		for k, v in pairs(quests) do
			if not IsScenarioObjective(v) then
				v.delete = true
			end
		end

		local tasks = GetTasksTable() -- World Quest
		local isInArea, isOnMap, numObjectives, taskName, displayAsObjective
		local questID
		local text, objectiveType, filled, required
		for i = 1, #tasks do
			questID = tasks[i]
			isInArea, isOnMap, numObjectives, taskName, displayAsObjective = GetTaskInfo(questID)
			if isInArea and taskName then
				quests[taskName] = wipe(quests[taskName] or {})
				quests[taskName][0] = questID
				quests[taskName][1] = -1
				if numObjectives then
					for objectiveIndex = 1, numObjectives do
						text, objectiveType, filled, required = GetQuestObjectiveInfo(questID, objectiveIndex, true)
						if text then
							tinsert(quests[taskName], text)
						end
					end
				end
			end
		end

		local empty = {}
		for i = 1, C_QuestLog.GetNumQuestLogEntries() do
			local info = C_QuestLog.GetInfo(i)
			if info and info.questID and not info.isHeader and not info.isBounty then
				local isComplete = C_QuestLog.IsComplete(info.questID)
				local frequency = info.frequency or 0
				local tag = C_QuestLog.GetQuestTagInfo(info.questID) or empty

				-- if info.questID == 63733 then
				-- 	print(info.title, info.questID)
				-- 	print("    ", "campaignID =", info.campaignID, "frequency =", info.frequency, "tagID =", tag.tagID)
				-- 	_G.questInfo = info
				-- 	_G.questTag = tag
				-- end

				if not (tag.worldQuestType or tag.tagID == 102) then
					if info.campaignID and info.campaignID >= 100 and info.frequency == 0 then
						frequency = info.campaignID
					elseif info.isTask then
						frequency = -2 -- Bonus Objective
					elseif tag.tagID then
						if tag.tagID > 200 and quests[info.title] and quests[info.title].delete == nil then -- Assault
							frequency = -tag.tagID
						elseif tag.tagID == 83 then -- Shadowlands Legendary
							frequency = -tag.tagID
						end
					end
					numObjectives = GetNumQuestLeaderBoards(i)
					quests[info.title] = wipe(quests[info.title] or {})
					quests[info.title][0] = info.questID
					quests[info.title][1] = frequency
					if isComplete then
						tinsert(quests[info.title], "*")
					elseif numObjectives then
						for objectiveIndex = 1, numObjectives do
							text, objectiveType, filled, required = GetQuestObjectiveInfo(info.questID, objectiveIndex, true)
							if text then
								tinsert(quests[info.title], text)
							end
						end
					end
				end
			end
		end

		for k, v in pairs(quests) do
			if v.delete then
				quests[k] = nil
				wipe(v)
			end
		end
	end

	function addon:RefreshQuestIcons()
		for _, kai in pairs(kaiPlates) do
			if kai.unitExists then
				kai._quest = true
				tinsert(npcPlates, kai)
			end
		end
	end

	local function QuestLogUpdate_Delay()
		UpdateActiveScenario()
		UpdateActiveQuests()
		if db.disableObjectiveIcon or addon.inPvP or addon.inRaid or addon.inChallengeMode then return end
		addon:RefreshQuestIcons()
	end

	function events:QUEST_LOG_UPDATE(...)
	  if self._questLogs then
			self._questLogs = nil
			self.scheduler:Schedule(0.4, "questLogs", QuestLogUpdate_Delay)
		end
	end

	function events:UNIT_QUEST_LOG_CHANGED(...)
		self._questLogs = true
	end
	events.units.UNIT_QUEST_LOG_CHANGED = "player"

	local function ScenarioUpdate_Delay()
		UpdateActiveScenario()
		addon:RefreshQuestIcons()
	end

	function events:SCENARIO_UPDATE()
		self.scheduler:Schedule(0.01, "scenarioStage", ScenarioUpdate_Delay)
	end

	local function ScenarioCriteriaUpdate_Delay()
		if GetScenarioObjectives() then
			addon:RefreshQuestIcons()
		end
	end

	function events:SCENARIO_CRITERIA_UPDATE()
		self.scheduler:Schedule(0.01, "scenarioCriteria", ScenarioCriteriaUpdate_Delay)
	end
end

do -- range checker
	local IsSpellInRange, IsItemInRange = IsSpellInRange, IsItemInRange

	local ClassSpells = {
		-- [1] = {355}, -- WARRIOR: Taunt
		-- [2] = {62124}, -- PALADIN: Hand of Reckoning
		[3] = {193455, 19434, 193265}, -- HUNTER: Cobra Shot, Aimed Short, Hatchet Toss
		-- [4] = {}, -- ROGUE
		[5] = {585}, -- PRIEST: Smite
		[6] = {47541, 49576}, -- DEATHKNIGHT: Death Coil, Death Grip
		[7] = {188196}, -- SHAMAN: Lightning Bolt
		[8] = {116, 30451, 133}, -- MAGE: Frostbolt, Arcane Blast, Fireball
		[9] = {686}, -- WARLOCK: Shadow Bolt
		-- [10] = {115546}, -- MONK: Provoke
		[11] = {8921}, -- DRUID: Moonfire
		-- [12] = {185123}, -- DEMONHUNTER: Throw Glaive
		[13] = {361469}, -- EVOKER: Living Flame
	}

	local classID = select(3, UnitClass("player"))
	local spells = classID and ClassSpells[classID]
	wipe(ClassSpells)

	local spellName

	local function Kai_UnitInRangeSpell(kai)
		if spellName and kai.unitExists then
			return IsSpellInRange(spellName, kai.unitID)
		end
	end

	local function Kai_UnitInRangeItem40(kai)
		if kai.unitExists then
			return IsItemInRange(28767, kai.unitID) and 1 or 0 -- 40yd: 28767, 30yd: 34191
		end
	end

	local function Kai_UnitInRangeItem30(kai)
		if kai.unitExists then
			return IsItemInRange(34191, kai.unitID) and 1 or 0 -- 40yd: 28767, 30yd: 34191
		end
	end

	function addon:GetRangeCheckerSpells()
		return spells
	end

	function addon:UpdateRangeCheckerSpell()
		Kai_UnitInRange = Kai_UnitInRangeItem40
		local checkMode
		if classID then
			checkMode = db.rangeCheckerMode[classID]
			if checkMode then
				if checkMode == "item30" then
					Kai_UnitInRange = Kai_UnitInRangeItem30
				elseif checkMode == "spell" then
					-- Kai_UnitInRange = Kai_UnitInRangeSpell
				elseif checkMode == "disabled" then
					Kai_UnitInRange = nil
				end
			end
		end

		if checkMode == "spell" and spells then
			for i = 1, #spells do
				spellName = GetSpellInfo(spells[i])
				if spellName and GetSpellInfo(spellName) then -- check with spellbook
					Kai_UnitInRange = Kai_UnitInRangeSpell
				end
			end
		end
	end

end

do -- Target Emphasize
	local EmphasizeFrame = CreateFrame("Frame", nil, addon.frame)
	addon.EmphasizeFrame = EmphasizeFrame
	--EmphasizeFrame:SetFrameStrata("BACKGROUND")
	EmphasizeFrame:Hide()

	local shine = EmphasizeFrame:CreateTexture(nil, "BACKGROUND", nil, -5)
	shine:SetTexture("Interface\\Addons\\NamePlateKAI\\texture\\targetglow")
	shine:SetVertexColor(0.1, 0.55, 1, 1)
	shine:SetTexCoord(0, 1, 0, 0.85)

	local shineShadow = EmphasizeFrame:CreateTexture(nil, "BACKGROUND", nil, -8)
	shineShadow:SetTexture("Interface\\Addons\\NamePlateKAI\\texture\\targetbg2")
	shineShadow:SetVertexColor(0, 0, 0, 1)
	shineShadow:SetTexCoord(0, 1, 0, 0.9)
	shineShadow:SetPoint("TOPLEFT", shine, -1, 10)
	shineShadow:SetPoint("BOTTOMRIGHT", shine, 1, 3)

	local shineOverlay = EmphasizeFrame:CreateTexture(nil, "OVERLAY", nil, 6)
	shineOverlay:SetTexture("Interface\\Addons\\NamePlateKAI\\texture\\targetglow")
	shineOverlay:SetVertexColor(0.5, 0.5, 0.5, 1)
	shineOverlay:SetBlendMode("ADD")
	--shineOverlay:SetParent(addon.frame)
	shineOverlay:SetAllPoints(shine)
	--shineOverlay:SetPoint("TOPLEFT", shine, 0, 0)
	--shineOverlay:SetPoint("BOTTOMRIGHT", shine, "RIGHT", 0, 0)

	local flashHighlight = EmphasizeFrame:CreateTexture(nil, "OVERLAY", nil, 7)
	flashHighlight:SetTexture("Interface\\Addons\\NamePlateKAI\\texture\\targetbg2")
	flashHighlight:SetVertexColor(1, 1, 0.6)
	flashHighlight:SetBlendMode("ADD")
	--flashHighlight:SetAllPoints(shineShadow)
	flashHighlight:Hide()

	local targetAnim = EmphasizeFrame:CreateTexture(nil, "OVERLAY", nil, 5)
	targetAnim:SetTexture("Interface\\Addons\\NamePlateKAI\\texture\\targetanimation")
	targetAnim:SetTexCoord(0, 0, 0, 16, 104, 0, 104, 16)
	targetAnim:SetVertexColor(0.5, 0.5, 0.5)
	targetAnim:SetBlendMode("ADD")
	targetAnim:Hide()

	local FLASH_DUR = 0.325
	local FLASH_ALPHA = 0.85

	local TargetFrame = CreateFrame("Frame", "NamePlateTargetFrame", _G.WorldFrame)
	TargetFrame:SetFrameStrata("TOOLTIP")
	TargetFrame:Hide()
	TargetFrame:SetAllPoints(EmphasizeFrame)
	EmphasizeFrame:SetScript("OnHide", function()
		TargetFrame:Hide()
	end)

	function addon:UpdateShineVertexColor()
		if not EmphasizeFrame.kai.unitExists then return end
		if EmphasizeFrame.kai.inRanged == false then
			shine:SetVertexColor(0.85, 0.4, 0, 1)
		else
			if UnitIsFriend("player", "target") then
				shine:SetVertexColor(0.5, 1, 0.8, 1)
			else
				shine:SetVertexColor(0.6, 0.85, 1, 1)
			end
		end
	end

	local AnimateTexCoords, GetTime = AnimateTexCoords, GetTime
	local t
	local function OnUpdate(self, elapsed)
		if db.target.animation then
			AnimateTexCoords(targetAnim, 256, 256, 104, 16, 32, elapsed, 0.005)
		end
		if EmphasizeFrame.fadeIn then
			EmphasizeFrame.fadeIn = nil
			-- EmphasizeFrame:ClearAllPoints()
			-- EmphasizeFrame:SetParent(EmphasizeFrame.kai:GetParent())
			-- EmphasizeFrame:SetAllPoints(EmphasizeFrame.kai)
			-- EmphasizeFrame:SetAlpha(db.target.shineAlpha)
			shine:SetAlpha(db.target.shineAlpha)
			shineShadow:SetAlpha(db.target.shineAlpha)
			shineOverlay:SetAlpha(db.target.shineAlpha * 0.5 + 0.5)
			flashHighlight:SetAlpha(FLASH_ALPHA)
			targetAnim:SetAlpha(db.target.animationAlpha)
			EmphasizeFrame.startTime = GetTime()
			TargetFrame:Show()
			targetAnim:SetShown(db.target.animation and self.kai and self.kai.isBarShown)
		elseif EmphasizeFrame.startTime then
			t = FLASH_DUR + EmphasizeFrame.startTime - GetTime()
			if t <= 0 then
				EmphasizeFrame.startTime = nil
				flashHighlight:Hide()
				targetAnim:SetShown(db.target.animation and self.kai and self.kai.isBarShown)
			else
				targetAnim:SetAlpha(db.target.animationAlpha)
				if db.target.flash then
					flashHighlight:SetAlpha((t / FLASH_DUR) * FLASH_ALPHA)
				end
			end
		end
	end
	EmphasizeFrame:SetScript("OnUpdate", OnUpdate)

	function addon:SetTargetGlow(namePlate)
		namePlate = namePlate or self.targetPlate
		if not namePlate then
			EmphasizeFrame:SetParent(addon.frame)
			EmphasizeFrame:Hide()
			shine:SetParent(EmphasizeFrame)
			shine:Hide()
			shineShadow:SetParent(EmphasizeFrame)
			shineShadow:Hide()
			shineOverlay:SetParent(EmphasizeFrame)
			shineOverlay:Hide()
			flashHighlight:SetParent(EmphasizeFrame)
			flashHighlight:Hide()
			targetAnim:SetParent(EmphasizeFrame)
			targetAnim:Hide()
			EmphasizeFrame.kai = nil
			EmphasizeFrame.fadeIn = nil
			EmphasizeFrame.startTime = nil
		else
			local kai = kaiPlates[namePlate]
			EmphasizeFrame.kai = kai
			EmphasizeFrame:SetParent(kai:GetParent())
			EmphasizeFrame:ClearAllPoints()
			EmphasizeFrame:SetAllPoints(kai)
			local width = db.frameSize.W
			targetAnim:SetParent(kai)
			if db.target.animationOverlay then
				targetAnim:SetDrawLayer("OVERLAY", 5)
			else
				targetAnim:SetDrawLayer("ARTWORK", 5)
			end
			targetAnim:ClearAllPoints()
			if db.target.animationStyle == "full" then
				targetAnim:SetPoint("TOP", EmphasizeFrame, "TOP", 0, db.nameFont.size + 4)
				targetAnim:SetPoint("BOTTOM", EmphasizeFrame, "BOTTOM", 0, -4)
				targetAnim:SetWidth(width + 16 + 24)
			elseif db.target.animationStyle == "wide" then
				targetAnim:SetPoint("TOP", EmphasizeFrame, "TOP", 0, 3)
				targetAnim:SetPoint("BOTTOM", EmphasizeFrame, "BOTTOM", 0, -3)
				targetAnim:SetWidth(width + 16 + 24)
			elseif db.target.animationStyle == "fit" then
				targetAnim:SetPoint("TOP", EmphasizeFrame, "TOP", 0, 3)
				targetAnim:SetPoint("BOTTOM", EmphasizeFrame, "BOTTOM", 0, -3)
				targetAnim:SetWidth(width - 16 + 24)
			else
				targetAnim:SetPoint("TOP", EmphasizeFrame, "TOP", 0, 0)
				targetAnim:SetPoint("BOTTOM", EmphasizeFrame, "BOTTOM", 0, 0)
				targetAnim:SetWidth(width)
			end
			-- targetAnim:SetShown(db.target.animation and kai.isBarShown)
			targetAnim:SetShown(db.target.animation)
			shine:ClearAllPoints()
			shine:SetPoint("TOP", EmphasizeFrame, "TOP", 0, db.nameFont.size + 4)
			shine:SetWidth(width + 34 + 20)
			self:UpdateShineVertexColor()
			shine:SetParent(kai)
			shine:SetShown(db.target.shine)
			shineShadow:SetParent(kai)
			shineShadow:SetShown(db.target.shine)
			shineOverlay:SetParent(kai)
			shineOverlay:SetShown(db.target.shine)
			flashHighlight:SetParent(kai)
			flashHighlight:ClearAllPoints()
			flashHighlight:SetPoint("TOP", EmphasizeFrame, "TOP", 0, db.nameFont.size + 13)
			flashHighlight:SetSize(width + 40 + 20, 44)
			flashHighlight:SetShown(db.target.flash)
			--EmphasizeFrame.startTime = GetTime()
			EmphasizeFrame:Show()
			EmphasizeFrame:SetAlpha(0)
			shineOverlay:SetAlpha(0)
			flashHighlight:SetAlpha(0)
			targetAnim:SetAlpha(0)
			EmphasizeFrame.fadeIn = true
		end
	end
end

function events:PLAYER_TARGET_CHANGED()
	self:OnTargetChanged()
	events.UPDATE_MOUSEOVER_UNIT(self)
end

function events:NAME_PLATE_CREATED(namePlate)
	self:NamePlateOnCreate(namePlate)
end

function events:NAME_PLATE_UNIT_ADDED(unitID)
	self:NamePlateOnAdded(GetNamePlateForUnit(unitID), unitID)
end

function events:NAME_PLATE_UNIT_REMOVED(unitID)
	self:NamePlateOnRemoved(GetNamePlateForUnit(unitID), unitID)
end

function events:UPDATE_MOUSEOVER_UNIT()
	local namePlate = GetNamePlateForUnit("mouseover")
	if namePlate then
		if self.frame.highlightFrame and self.frame.highlightFrame:IsShown() then
			self:NamePlateOnLeave(self.frame.highlightFrame)
		end
		self:NamePlateOnEnter(namePlate)
		-- self.frame.highlightFrame = namePlate
	end
end

-- function events:UNIT_NAME_UPDATE(unit)
-- 	local kai = kaiPlates[GetNamePlateForUnit(unit) or 0]
-- 	if kai then
-- 		Kai_UpdateName(kai)
-- 	end
-- end

function events:UNIT_FACTION(unit)
	if unit == "player" then
		self.scheduler:Schedule(0.25, "auras", "AurasUpdateFilters")
		self.scheduler:Schedule(0.25, "faction", "RefreshAll")
		self:UpdateRangeCheckerSpell()
	elseif UnitExists(unit) then
		local kai = kaiPlates[GetNamePlateForUnit(unit)]
		if kai and not kai.refresh then
			kai.refresh = true
			tinsert(updatePlates, kai)
		end
	end
end
events.UNIT_NAME_UPDATE = events.UNIT_FACTION

function events:RAID_TARGET_UPDATE()
	self:UpdateRaidIcons()
end

function events:PLAYER_CONTROL_LOST()
	self.scheduler:Schedule(0.25, "playerControl", "RefreshAll")
end
events.PLAYER_CONTROL_GAINED = events.PLAYER_CONTROL_LOST

function events:UNIT_FLAGS(unit)
	if unit == "player" then
		self.scheduler:Schedule(1, "playerControl", "RefreshAll")
	end
end

function events:ADDON_LOADED(arg)
	if arg == ADDON_NAME then
		self.loading = true

		SetCVar("NamePlateHorizontalScale", "1.0")
		SetCVar("NamePlateVerticalScale", "1.0")

		-- SystemFont_LargeNamePlateFixed:SetFontObject(FontUnitNameNormal)
		-- SystemFont_NamePlateFixed:SetFontObject(FontUnitNameNormal)
		-- SystemFont_NamePlateCastBar:SetFontObject(FontSpellName)

		if _G.NamePlateKAIDB == nil then _G.NamePlateKAIDB = {} end
		if _G.NamePlateKAIDB.profiles == nil then _G.NamePlateKAIDB.profiles = {} end
		if _G.NamePlateKAIDB.profiles.Default == nil then _G.NamePlateKAIDB.profiles.Default = {} end

		local profile = _G.NamePlateKAIDB.profiles.Default
		if profile then
			profile.version = profile.version or 0
			if profile.version < 7 then -- WoD
				wipe(profile)
			end
			profile.version = 7
		end

	end
end

function events:SPELLS_CHANGED()
	self:UpdateRangeCheckerSpell()
end

function events:VARIABLES_LOADED(...)
	local profile = _G.NamePlateKAIDB and _G.NamePlateKAIDB.profiles and _G.NamePlateKAIDB.profiles.Default
	self:DisableBlizzard(profile and profile.performanceMode or addon.defaults.performanceMode)
end

function events:PLAYER_LOGIN(...)
	self.playerName = UnitName("player")
	self.playerLevel = UnitLevel("player")

	self:LoadProfile()

	if _G.DBM then
		local function DBM_OnEngage(_, mod)
			if type(mod.encounterId) == "number" then
				self:EncounterStart(mod.encounterId)
			end
		end

		local function DBM_OnDisengage(_, mod)
			if type(mod.encounterId) == "number" then
				self:EncounterEnd(mod.encounterId)
			end
		end

		_G.DBM:RegisterCallback("pull", DBM_OnEngage)
		_G.DBM:RegisterCallback("wipe", DBM_OnDisengage)
		_G.DBM:RegisterCallback("kill", DBM_OnDisengage)
	end

	self._questLogs = true

	self.frame:SetScript("OnUpdate", addon.frame.OnUpdate)
end

function events:PLAYER_ENTERING_WORLD(...)
	if self.loading then
		events.ZONE_CHANGED_NEW_AREA(self)
	end
	self.loading = nil
	self.frame.highlight:Hide()
	self.frame.highlightFrame = nil
	if not UnitExists("target") then
		addon:SetTargetGlow()
	end
	self:SetNamePlateSize()
	self:OnTargetChanged()
	self._questLogs = true

	if db.nameplateOverlapH > 0 then
		addon:QueueSetCVar("nameplateOverlapH", db.nameplateOverlapH)
	end
	if db.nameplateOverlapV > 0 then
		addon:QueueSetCVar("nameplateOverlapV", db.nameplateOverlapV)
	end
end

function events:PLAYER_LEAVING_WORLD(...)
	wipe(npcPlates)
	wipe(updatePlates)
	self:OnTargetChanged(true)
	self.scheduler:UnscheduleAll()
	self.scheduler:Schedule(1, "encounterEnd", "CheckEncounters")
	self._questLogs = true
end

local function GetZoneInfo()
	local instanceName, zoneType, diffID, _, _, _, _, instanceID = GetInstanceInfo()
	local inPvP = false
	if C_Garrison.IsPlayerInGarrison(Enum.GarrisonType.Type_6_0) or C_Garrison.IsPlayerInGarrison(Enum.GarrisonType.Type_7_0) then -- in Garrison
		zoneType = "garrison"
	end
	if zoneType == "arena" or zoneType == "pvp" then
		inPvP = true
	elseif diffID == 38 or diffID == 39 or diffID == 40 then -- Island Expeditions
		zoneType = "island"
	else
		local zonetext = GetRealZoneText()
		if zonetext then
			for i = 1, GetNumWorldPVPAreas() do -- 1:Wintergrasp 2:Tol Barad 3:Ashran
				local pvpID, localizedName, isActive = GetWorldPVPAreaInfo(i)
				if localizedName == zonetext and isActive then
					inPvP = true
				end
			end
		end
	end
	return instanceID, zoneType, inPvP
end

function events:ZONE_CHANGED_NEW_AREA(...)
	if not next(db) then return end
	if not db.disableObjectiveIcon then -- patch 8.2 Blizzard known issues, Article ID:45367
		addon:QueueSetCVar("showQuestTrackingTooltips", 1)
	end
	events.GROUP_ROSTER_UPDATE(self)
	local oldZoneType = self.zoneType
	self.instanceID, self.zoneType, self.inPvP = GetZoneInfo()

	self.inRaid = self.zoneType == "raid" or nil
	self.inWorld = self.zoneType == "none" or self.zoneType == "garrison" or nil
	-- self.inChallengeMode = select(3, GetInstanceInfo()) == 8
	self.inChallengeMode = C_ChallengeMode.IsChallengeModeActive()
	self.instanceModifiedInfo = C_ModifiedInstance.GetModifiedInstanceInfoFromMapID(self.instanceID)
	self:SetCVarDistance()

	wipe(self.affixes)
	if self.inChallengeMode then
		local affixes = C_MythicPlus.GetCurrentAffixes()
		if affixes then
			for k, affix in pairs(affixes) do
				self.affixes[affix.id] = C_ChallengeMode.GetAffixInfo(affix.id)
			end
		end
	end

	if self.zoneType ~= "none" or self.zoneType ~= oldZoneType then
		if self:UpdateFilter() then
			self:AurasUpdateFilters()
			self:RefreshAll()
		end
	end
end
events.CHALLENGE_MODE_START = events.ZONE_CHANGED_NEW_AREA
-- events.START_TIMER = events.ZONE_CHANGED_NEW_AREA

function events:START_TIMER(tType, tRemaining, tTotal)
	if tRemaining and (tRemaining < 10) then
		events.ZONE_CHANGED_NEW_AREA(self)
	end
end

function events:PLAYER_REGEN_ENABLED()
	if self._restyle then
		self:RestyleNamePlates()
	end
	if self._plateSize then
		self:SetNamePlateSize()
	end
	if self.cvarList then
		self:QueueSetCVar()
	end
	self:ThreatUpdateAll()
end

function events:PLAYER_REGEN_DISABLED()
	self:ThreatUpdateAll()
	self:UpdateRangeCheckerSpell()
end

function events:GROUP_ROSTER_UPDATE()
	UnitPlayerOrPetInGroup = IsInRaid() and UnitPlayerOrPetInRaid or UnitPlayerOrPetInParty
end

local function CheckEncounterStart(id)
	if IsEncounterInProgress() then
		addon:EncounterStart(id)
	end
end

function events:ENCOUNTER_START(id, name, ...)
	self.scheduler:Schedule(0.1, "encounterStart", CheckEncounterStart, id)
end

function events:ENCOUNTER_END(id, ...)
	self.scheduler:Schedule(1, "encounterEnd", "CheckEncounters")
end

function events:UNIT_LEVEL(unit)
	if unit == "player" then
		self.playerLevel = UnitLevel("player")
		self.scheduler:Schedule(0.25, "level", "RefreshAll")
	else
		Kai_Refresh(kaiPlates[GetNamePlateForUnit(unit)])
	end
end
-- events.units.UNIT_LEVEL = "player"

-- function events:BATTLEFIELD_MGR_STATE_CHANGE(id, status)
-- 	if status == 0 or status == 3 then
-- 		self.inPvP = false
-- 	end
-- end
--
-- function events:BATTLEFIELD_MGR_ENTERED(...)
-- 	self.inPvP = true
-- end

addon.frame:SetFrameStrata("TOOLTIP")
addon.frame:SetScript("OnEvent", function(self, event, ...) events[event](addon, ...) end)
for event, func in pairs(events) do
	if type(func) == "function" then
		if type(events.units[event]) == "string" then
			addon.frame:RegisterUnitEvent(event, events.units[event])
		else
			addon.frame:RegisterEvent(event)
		end
	end
end

do -- scheduler
	local tasks = {}

	function addon.scheduler:Schedule(duration, id, func, arg1, arg2, arg3)
		local task = id and self:GetTask(id) or nil
		if not task then
			task = {}
			tinsert(tasks, task)
			--lengthTasks = #tasks
			self:UpdateStatus()
		end
		task.r = duration
		task.f = func
		task.id = id
		task.arg1 = arg1
		task.arg2 = arg2
		task.arg3 = arg3
	end

	function addon.scheduler:GetTask(id)
		for i = 1, #tasks do
			if tasks[i].id == id then
				return tasks[i]
			end
		end
	end

	function addon.scheduler:UnscheduleAll()
		for i = 1, #tasks do
			wipe(tasks[i])
		end
		wipe(tasks)
		--lengthTasks = 0
		self:UpdateStatus()
	end

	function addon.scheduler:UpdateStatus()
		addon.frame.taskEnabled = #tasks > 0
	end

	local type = type
	local i, task
	function addon.scheduler:Update(elapsed)
		i = 1
		while i <= #tasks do
			task = tasks[i]
			if task.r <= 0 then
				if type(task.f) == "string" then
					addon[task.f](addon, task.arg1, task.arg2, task.arg3)
				else
					task.f(task.arg1, task.arg2, task.arg3)
				end
				if task.r <= 0 then
					wipe(tremove(tasks, i))
					self:UpdateStatus()
				end
			else
				task.r = task.r - elapsed
				i = i + 1
			end
		end
	end
end

do -- add a panel to blizzard interface options
	local addonName, title, notes, loadable, reason = GetAddOnInfo(ADDON_NAME.."_options")
	if addonName and reason == "DEMAND_LOADED" then
		local panel = CreateFrame("Frame")
		addon.optionsPanel = panel
		panel.name = ADDON_NAME
		panel.title = title or panel.name
		panel:SetScript("OnShow", function()
			if not (LibStub and LibStub("AceGUI-3.0", true)) then
				panel:SetInfoText("AceGUI-3.0 was not found. You must install Ace3.")
			elseif not (LibStub and LibStub("AceDB-3.0", true)) then
				panel:SetInfoText("AceDB-3.0 was not found. You must install Ace3.")
			else
				panel:SetScript("OnShow", nil)
				panel.refresh = nil
				panel:SetInfoText(nil)
				local button = LibStub("AceGUI-3.0"):Create("Button")
				button.frame:SetParent(panel)
				button:SetPoint("TOPLEFT", panel, 12, -12)
				button:SetPoint("TOPRIGHT", panel, -12, -12)
				button:SetText(_G.SHOW.." "..panel.title)
				button:SetCallback("OnClick", function(widget)
					local loaded, reason = LoadAddOn(addonName)
					if loaded then
						widget.frame:SetParent(nil)
						LibStub("AceGUI-3.0"):Release(widget)
					else
						print(YELLOW_FONT_COLOR_CODE.._G.ADDON_LOAD_FAILED:format(panel.title, _G["ADDON_"..reason])..FONT_COLOR_CODE_CLOSE)
					end
				end)
				button.frame:Show()
			end
		end)
		function panel:SetInfoText(text)
			if text and not self.infoText then
				self.infoText = self:CreateFontString(nil, nil, "GameFontNormal")
				self.infoText:SetPoint("TOPLEFT", self, 12, -12)
			end
			if self.infoText then
				self.infoText:SetText(text)
			end
		end
		function panel:cancel()
			addon:SetNamePlateSize()
		end
		panel.okay = panel.cancel
		panel.category = InterfaceOptions_AddCategory(panel)
		panel:Hide()
	end
end
