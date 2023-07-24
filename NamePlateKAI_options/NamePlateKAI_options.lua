local _TOCVERSION = select(4, GetBuildInfo())
local ADDON_NAME, options = ...

local addon = _G.NamePlateKAI
if not addon then return end

local mainPanel = addon.optionsPanel
if not mainPanel then return end

local filterPanel = CreateFrame("Frame")
filterPanel.name = _G.FILTERS
filterPanel.parent = mainPanel.name

local auraPanel = CreateFrame("Frame")
auraPanel.name = _G.AURAS
auraPanel.parent = mainPanel.name
auraPanel.labelPool = {}

local function print(...)
	_G.print(YELLOW_FONT_COLOR_CODE..mainPanel.title..":"..FONT_COLOR_CODE_CLOSE, ...)
end

local GUI = LibStub and LibStub("AceGUI-3.0", true)
if not GUI then return print("AceGUI-3.0 was not found.") end
if not (LibStub and LibStub("AceDB-3.0", true)) then return print("AceDB-3.0 was not found.") end
local db = LibStub("AceDB-3.0"):New("NamePlateKAIDB", {profile = addon.defaults}, true)
local profile = db.profile

local FRAME_MARGIN = 14
local FRAME_SPACE = 4
local BARTEXTURE_DEFAULT = "NamePlateKAI"
local RELOAD = ORANGE_FONT_COLOR_CODE.."*"..REQUIRES_RELOAD..FONT_COLOR_CODE_CLOSE

local controls = {}
local filterControls = {}
local zoneFilters = {}
local userFilters = {}
local auraControls = {}
local userAuras = {}

local GetCVar, GetCVarBool, GetCVarDefault, SetCVar = C_CVar.GetCVar, C_CVar.GetCVarBool, C_CVar.GetCVarDefault, C_CVar.SetCVar

-- if not _G.DISABLED_FONT_COLOR then -- undefined in 7.1.5
-- 	_G.DISABLED_FONT_COLOR = CreateColor(0.498, 0.498, 0.498)
-- end

local borderTypes = {
	{
		name = "Blur",
		file = "Interface\\AddOns\\NamePlateKAI\\texture\\glowTex",
		alpha = 0.8,
		GetCastBarOffset = function(edgeSize)
			return max(floor(edgeSize * 0.6), 3)
		end,
	},
	{
		name = "Sharp",
		file = "Interface\\AddOns\\NamePlateKAI\\texture\\border_sharp",
		alpha = 0.6,
		GetCastBarOffset = function(edgeSize)
			return max(floor(edgeSize * 0.9 + 0.5), 3)
		end,
	},
}

local motionSpeedValues = {
	VERYSLOW = "0.011",
	SLOW = "0.016",
	DEFAULT = "0.025",
	FAST = "0.09",
	VERYFAST = "0.2",
	SUPERFAST = "0.45",
}

local function EJ_GetSectionInfo(sectionID)
	local info = C_EncounterJournal.GetSectionInfo(sectionID)
	if info then
		return info.title, info.spellID ~= 0 and info.spellID or nil
	end
end

local function Animation_OnValueChanged(widget, event, value)
	local disabled = not controls.animationCheck:GetValue()
	controls.animationAlphaSlider:SetDisabled(disabled)
	controls.animationStyleDropdown:SetDisabled(disabled)
	controls.animationAlphaSlider:SetDisabled(disabled)
	controls.animationOverlayCheck:SetDisabled(disabled)
end

local function Shine_OnValueChanged(widget, event, value)
	local disabled = not controls.shineCheck:GetValue()
	controls.shineAlphaSlider:SetDisabled(disabled)
end

local function ExecuteColorCheck_OnValueChanged(widget, event, value)
	local disabled = not controls.healthTextCheck:GetValue() or controls.disableExecuteCheck:GetValue()
	controls.executeThresholdSlider:SetDisabled(disabled)
	controls.executeColor:SetDisabled(disabled)
end

local function HealthText_OnValueChanged(widget, event, value)
	local disabled = not controls.healthTextCheck:GetValue()
	controls.healthTextPercentageCheck:SetDisabled(disabled)
	controls.disableExecuteCheck:SetDisabled(disabled)
	controls.healthTextMaxCheck:SetDisabled(disabled)
	ExecuteColorCheck_OnValueChanged()
end

local function DynamicOpacity_OnValueChanged(widget, event, value)
	local disabled = not controls.dynamicOpacityCheck:GetValue()
	controls.rangeCheckerModeDropdown:SetDisabled(disabled)
end

local function NormalClampCheck_OnValueChanged(widget, event, value)
	local disabled = not controls.normalClampCheck:GetValue()
	controls.normalTopInsetSlider:SetDisabled(disabled)
	controls.normalBottomInsetSlider:SetDisabled(disabled)
	return not disabled
end

local function BossClampCheck_OnValueChanged(widget, event, value)
	local disabled = not controls.bossClampCheck:GetValue()
	controls.bossTopInsetSlider:SetDisabled(disabled)
	controls.bossBottomInsetSlider:SetDisabled(disabled)
	return not disabled
end

local function DistanceDungeonCheck_OnValueChanged(widget, event, value)
	local disabled = not controls.distanceDungeonCheck:GetValue()
	controls.distanceDungeonSlider:SetDisabled(disabled)
end

local function DistanceRaidCheck_OnValueChanged(widget, event, value)
	local disabled = not controls.distanceRaidCheck:GetValue()
	controls.distanceRaidSlider:SetDisabled(disabled)
end

local function ColorPickerSetHexColor(colorPicker, hexColor)
	local r, g, b = hexColor:match("(%x%x)(%x%x)(%x%x)")
	if not (r and g and b) then return end
	r, g, b = tonumber("0x"..r) or 0xff, tonumber("0x"..g) or 0xff, tonumber("0x"..b) or 0xff
	colorPicker:SetColor(r / 0xff, g / 0xff, b / 0xff)
end

local function ColorPickerGetHexColor(colorPicker)
	return ("%.2x%.2x%.2x"):format(colorPicker.r * 0xff, colorPicker.g * 0xff, colorPicker.b * 0xff)
end

local function DropdownSetValue(dropdown, value, default)
	if value then
		for k, v in pairs(dropdown.list) do
			if v == value then
				dropdown:SetValue(k)
				break
			end
		end
	else
		dropdown:SetValue(default or _G.DEFAULT)
	end
end

function mainPanel:refresh()
	if not next(controls) then
		options:CreateWidget()
		options:CreateFiltersWidget()
		options:CreateAurasWidget()
	end

	mainPanel.defaultButton:SetUserData("confirm", false)
	mainPanel.defaultButton:SetText(_G.DEFAULTS)

	controls.healthWidthSlider:SetValue(profile.frameSize.W)
	--controls.healthHeightSlider:SetValue(profile.frameSize.H)
	--controls.frameScaleHorizontal:SetValue(profile.frameScale.x)
	--controls.frameScaleVertical:SetValue(profile.frameScale.y)

	controls.healthHeightSlider:SetValue(profile.healthBarHeight)
	controls.castHeightSlider:SetValue(profile.castBarHeight)

	controls.frameMarginY:SetValue(profile.frameMargin.y)

	controls.raidIconAnchorDropdown:SetValue(profile.raidIcon.anchorPoint)
	controls.raidIconOffsetXSlider:SetValue(profile.raidIcon.offsetX)
	controls.raidIconOffsetYSlider:SetValue(profile.raidIcon.offsetY)
	controls.raidIconSlider:SetValue(profile.raidIcon.size)
	controls.spellIconSlider:SetValue(profile.spellIcon.size)
	controls.dungeonWidthMultiSlider:SetValue(profile.dungeonFriendlyBarMulti)
	controls.borderWidthSlider:SetValue(profile.barBackdrop.edgeSize)

	controls.barOffsetYSlider:SetValue(profile.barAnchorOffsetY)
	controls.nobarOffsetYSlider:SetValue(profile.nobarAnchorOffsetY)

	local borderType = 1
	for k, v in pairs(borderTypes) do
		if v.file == profile.barBackdrop.edgeFile then
			borderType = k
		end
	end
	controls.borderStyleDropdown:SetValue(borderType)

	controls.trivialScaleSlider:SetValue(profile.trivialScale)

	if controls.unitFontDropdown then
		DropdownSetValue(controls.unitFontDropdown, profile.nameFont.name)
		controls.unitNameSlider:SetValue(profile.nameFont.size)
		controls.unitNameOutlineCheck:SetValue(profile.nameFont.outline == "OUTLINE")
	end

	if controls.unitFontPlayerDropdown then
		DropdownSetValue(controls.unitFontPlayerDropdown, profile.nameFontPlayer.name)
		controls.unitNamePlayerSlider:SetValue(profile.nameFontPlayer.size)
		controls.unitNamePlayerOutlineCheck:SetValue(profile.nameFontPlayer.outline == "OUTLINE")
	end

	if controls.spellFontDropdown then
		DropdownSetValue(controls.spellFontDropdown, profile.castFont.name)
		controls.spellNameSlider:SetValue(profile.castFont.size)
		controls.spellNameOutlineCheck:SetValue(profile.castFont.outline == "OUTLINE")
	end

	controls.dungeonFontDropdown:SetValue(profile.dungeonFont.size)

	if controls.healthTextureDropdown then
		DropdownSetValue(controls.healthTextureDropdown, profile.barTexture, BARTEXTURE_DEFAULT)
	end

	if controls.castTextureDropdown then
		DropdownSetValue(controls.castTextureDropdown, profile.castBarTexture, BARTEXTURE_DEFAULT)
	end

	controls.showDebuffCheck:SetValue(profile.buff.enabledEnemy)
	controls.showDebuffCheck:SetDisabled(IsAddOnLoaded("NameplateAuras"))
	controls.showBuffCheck:SetValue(profile.buff.enabledFriendly)
	controls.showBuffCheck:SetDisabled(IsAddOnLoaded("NameplateAuras"))
	controls.showCountdownCheck:SetValue(profile.buff.countdownNumber)
	controls.showCountdownCheck:SetDisabled(not GetCVarBool("countdownForCooldowns"))
	controls.disableOmniccCheck:SetValue(profile.disableOmnicc)
	controls.disableOmniccCheck:SetDisabled(not _G.OmniCC)
	controls.auraHeightSlider:SetValue(profile.buff.size.H)
	controls.auraBorderSlider:SetValue(profile.buff.borderSize)
	controls.showEnrageCheck:SetValue(profile.buff.showEnrage)
	controls.showMagicCheck:SetValue(profile.buff.showMagic)

	controls.healthTextCheck:SetValue(profile.healthText.enabled)
	controls.healthTextPercentageCheck:SetValue(profile.healthText.percentage)
	controls.healthTextMaxCheck:SetValue(profile.healthText.displayMax)
	controls.executeThresholdSlider:SetValue(profile.healthText.executeThreshold or 0.2)
	controls.disableExecuteCheck:SetValue(not profile.healthText.executeThreshold)
	ColorPickerSetHexColor(controls.executeColor, profile.healthText.colorExecute)
	HealthText_OnValueChanged()

	controls.flashCheck:SetValue(profile.target.flash)
	controls.shineCheck:SetValue(profile.target.shine)
	controls.shineAlphaSlider:SetValue(profile.target.shineAlpha)
	controls.animationCheck:SetValue(profile.target.animation)
	controls.animationAlphaSlider:SetValue(profile.target.animationAlpha)
	controls.animationStyleDropdown:SetValue(profile.target.animationStyle)
	controls.animationOverlayCheck:SetValue(profile.target.animationOverlay)
	Shine_OnValueChanged()
	Animation_OnValueChanged()

	controls.maxDistanceSlider:SetValue(profile.nameplateMaxDistance)
	controls.playerMaxDistanceSlider:SetValue(profile.nameplatePlayerMaxDistance)
	controls.distanceDungeonCheck:SetValue(profile.nameplateDungeonDistanceEnabled)
	controls.distanceDungeonSlider:SetValue(profile.nameplateDungeonDistance)
	DistanceDungeonCheck_OnValueChanged()
	controls.distanceRaidCheck:SetValue(profile.nameplateRaidDistanceEnabled)
	controls.distanceRaidSlider:SetValue(profile.nameplateRaidDistance)
	DistanceRaidCheck_OnValueChanged()

	-- controls.performanceModeCheck:SetValue(profile.performanceMode)
	controls.targetAlwaysOnTop:SetValue(profile.targetAlwaysOnTop)
	controls.redHostileCheck:SetValue(profile.redHostile)
	controls.dynamicOpacityCheck:SetValue(profile.dynamicOpacity)

	local classText, className, classID = UnitClass("player")
	if className and _G.RAID_CLASS_COLORS[className] then
		local infoText = _G.RAID_CLASS_COLORS[className]:WrapTextInColorCode(classText)
		local spells = addon:GetRangeCheckerSpells()
		if type(spells) == "table" then
			infoText = infoText.." spell(s): "..table.concat(spells, ","):gsub("(%d+)", GetSpellInfo)
		else
			infoText = infoText.." No spell mode for this class"
		end
		controls.rangeCheckerModeDropdown:SetItemDisabled("spell", not spells)
		controls.rangeCheckerModePlayerClass:SetUserData("classID", classID)
		controls.rangeCheckerModePlayerClass:SetText(infoText)
	else
		controls.rangeCheckerModePlayerClass:SetUserData("classID", nil)
		controls.rangeCheckerModePlayerClass:SetText(_G.UNKNOWN..": ClassID="..classID)
	end
	controls.rangeCheckerModeDropdown:SetDisabled(not classID)
	if classID then
		controls.rangeCheckerModeDropdown:SetValue(profile.rangeCheckerMode[classID] or profile.rangeCheckerMode.default)
	end
	DynamicOpacity_OnValueChanged()

	controls.showGuildNameCheck:SetValue(profile.showPlayerGuild)
	controls.showRealmNameCheck:SetValue(profile.showPlayerRealm)
	controls.showTitleCheck:SetValue(profile.showPlayerTitle)
	controls.enemyPowerBarCheck:SetValue(profile.powerBarEnemy)
	controls.disableFactionIconCheck:SetValue(profile.disableFactionIcon)
	controls.friendlyClassColorCheck:SetValue(profile.friendlyClassColor)
	controls.alwaysShowNameCheck:SetValue(profile.alwaysShowUnitName)
	controls.friendlyClickThroughCheck:SetValue(profile.friendlyClickThrough)
	controls.dungeonFriendlyClickThroughCheck:SetValue(profile.dungeonFriendlyClickThrough)
	controls.disableFreindlyBarsCheck:SetValue(profile.disableFriendlyBars)
	controls.disableQuestObjectiveIconCheck:SetValue(profile.disableObjectiveIcon)
	controls.disableTrivialScaleInInstanceCheck:SetValue(profile.disableTrivialScaleInInstance)

	controls.performanceModeDropdown:SetValue(profile.performanceMode)

	controls.showFriendlyNpcCheck:SetValue(GetCVar("nameplateShowFriendlyNPCs") ~= "0")
	-- controls.maxDistanceSlider:SetValue(tonumber(GetCVar("nameplateMaxDistance")) or 60)
	-- controls.playerMaxDistanceSlider:SetValue(tonumber(GetCVar("nameplatePlayerMaxDistance")) or 60)
	controls.normalClampCheck:SetValue(GetCVar("nameplateOtherTopInset") ~= "-1")
	if NormalClampCheck_OnValueChanged() then
		controls.normalTopInsetSlider:SetValue(tonumber(GetCVar("nameplateOtherTopInset")))
		controls.normalBottomInsetSlider:SetValue(tonumber(GetCVar("nameplateOtherBottomInset")))
	else
		controls.normalTopInsetSlider:SetValue(tonumber(GetCVarDefault("nameplateOtherTopInset")))
		controls.normalBottomInsetSlider:SetValue(tonumber(GetCVarDefault("nameplateOtherBottomInset")))
	end
	controls.bossClampCheck:SetValue(GetCVar("nameplateLargeTopInset") ~= "-1")
	if BossClampCheck_OnValueChanged() then
		controls.bossTopInsetSlider:SetValue(tonumber(GetCVar("nameplateLargeTopInset")))
		controls.bossBottomInsetSlider:SetValue(tonumber(GetCVar("nameplateLargeBottomInset")))
	else
		controls.bossTopInsetSlider:SetValue(tonumber(GetCVarDefault("nameplateLargeTopInset")))
		controls.bossBottomInsetSlider:SetValue(tonumber(GetCVarDefault("nameplateLargeBottomInset")))
	end
	controls.overlapHSlider:SetValue(tonumber(GetCVar("nameplateOverlapH")))
	controls.overlapVSlider:SetValue(tonumber(GetCVar("nameplateOverlapV")))

	local motionSpeed = GetCVar("nameplateMotionSpeed")
	local value
	for k, v in pairs(motionSpeedValues) do
		if motionSpeed == v then
			value = k
		end
	end
	controls.motionSpeedDropdown:SetValue(value)

	controls.disableDefaultFiltersCheck:SetValue(profile.disableDefaultFilters)

end

function mainPanel:okay()
	profile.frameSize.W = controls.healthWidthSlider:GetValue()
	--profile.frameSize.H = controls.healthHeightSlider:GetValue()
	--profile.frameScale.x = controls.frameScaleHorizontal:GetValue()
	--profile.frameScale.y = controls.frameScaleVertical:GetValue()
	profile.healthBarHeight = controls.healthHeightSlider:GetValue()
	profile.castBarHeight = controls.castHeightSlider:GetValue()

	profile.frameMargin.y = controls.frameMarginY:GetValue()

	profile.raidIcon.anchorPoint = controls.raidIconAnchorDropdown:GetValue() or addon.defaults.raidIcon.anchorPoint
	profile.raidIcon.offsetX = controls.raidIconOffsetXSlider:GetValue()
	profile.raidIcon.offsetY = controls.raidIconOffsetYSlider:GetValue()
	profile.raidIcon.size = controls.raidIconSlider:GetValue()
	profile.spellIcon.size = controls.spellIconSlider:GetValue()
	profile.dungeonFriendlyBarMulti = controls.dungeonWidthMultiSlider:GetValue()

	profile.barBackdrop.edgeSize = controls.borderWidthSlider:GetValue()

	profile.barAnchorOffsetY = controls.barOffsetYSlider:GetValue()
	profile.nobarAnchorOffsetY = controls.nobarOffsetYSlider:GetValue()

	local borderStyle = borderTypes[controls.borderStyleDropdown:GetValue() or 0]
	if borderStyle then
		profile.barBackdrop.edgeFile = borderStyle.file
		profile.borderColor[4] = borderStyle.alpha
		profile.castBarOffset = borderStyle.GetCastBarOffset(profile.barBackdrop.edgeSize)
	end

	profile.trivialScale = controls.trivialScaleSlider:GetValue()

	if controls.unitFontDropdown then
		local fontName = controls.unitFontDropdown:GetValue()
		if fontName then
			profile.nameFont.name = (fontName ~= _G.DEFAULT) and controls.unitFontDropdown.list[fontName] or nil
		end
		profile.nameFont.size = controls.unitNameSlider:GetValue()
		profile.nameFont.outline = controls.unitNameOutlineCheck:GetValue() and "OUTLINE" or ""
	end

	if controls.unitFontPlayerDropdown then
		local fontName = controls.unitFontPlayerDropdown:GetValue()
		if fontName then
			profile.nameFontPlayer.name = (fontName ~= _G.DEFAULT) and controls.unitFontPlayerDropdown.list[fontName] or nil
		end
		profile.nameFontPlayer.size = controls.unitNamePlayerSlider:GetValue()
		profile.nameFontPlayer.outline = controls.unitNamePlayerOutlineCheck:GetValue() and "OUTLINE" or ""
	end

	if controls.spellFontDropdown then
		local fontName = controls.spellFontDropdown:GetValue()
		if fontName then
			profile.castFont.name = (fontName ~= _G.DEFAULT) and controls.spellFontDropdown.list[fontName] or nil
		end
		profile.castFont.size = controls.spellNameSlider:GetValue()
		profile.castFont.outline = controls.spellNameOutlineCheck:GetValue() and "OUTLINE" or ""
	end

	profile.dungeonFont.size = controls.dungeonFontDropdown:GetValue()

	local texture = controls.healthTextureDropdown and controls.healthTextureDropdown:GetValue()
	if texture then
		profile.barTexture = (fontName ~= BARTEXTURE_DEFAULT) and controls.healthTextureDropdown.list[texture] or nil
	end

	local texture = controls.castTextureDropdown and controls.castTextureDropdown:GetValue()
	if texture then
		profile.castBarTexture = (fontName ~= BARTEXTURE_DEFAULT) and controls.castTextureDropdown.list[texture] or nil
	end

	profile.buff.enabledEnemy = controls.showDebuffCheck:GetValue()
	profile.buff.enabledFriendly = controls.showBuffCheck:GetValue()
	profile.buff.countdownNumber = controls.showCountdownCheck:GetValue() and GetCVarBool("countdownForCooldowns")
	profile.disableOmnicc = controls.disableOmniccCheck:GetValue()
	profile.buff.size.H = controls.auraHeightSlider:GetValue()
	if profile.buff.size.H == addon.defaults.buff.size.H then
		profile.buff.size.W = addon.defaults.buff.size.W
	else
		profile.buff.size.W = floor(profile.buff.size.H * addon.defaults.buff.size.W / addon.defaults.buff.size.H)
	end
	profile.buff.borderSize = controls.auraBorderSlider:GetValue()
	profile.buff.showEnrage = controls.showEnrageCheck:GetValue()
	profile.buff.showMagic = controls.showMagicCheck:GetValue()

	profile.healthText.enabled = controls.healthTextCheck:GetValue()
	profile.healthText.percentage = controls.healthTextPercentageCheck:GetValue()
	profile.healthText.displayMax = controls.healthTextMaxCheck:GetValue()
	if controls.disableExecuteCheck:GetValue() then
		profile.healthText.executeThreshold = false
	else
		profile.healthText.executeThreshold = controls.executeThresholdSlider:GetValue()
	end
	profile.healthText.colorExecute = ColorPickerGetHexColor(controls.executeColor)

	profile.target.flash = controls.flashCheck:GetValue()
	profile.target.shine = controls.shineCheck:GetValue()
	profile.target.shineAlpha = controls.shineAlphaSlider:GetValue()
	profile.target.animation = controls.animationCheck:GetValue()
	profile.target.animationAlpha = controls.animationAlphaSlider:GetValue()
	profile.target.animationStyle = controls.animationStyleDropdown:GetValue()
	profile.target.animationOverlay = controls.animationOverlayCheck:GetValue()

	profile.nameplateMaxDistance = controls.maxDistanceSlider:GetValue()
	profile.nameplatePlayerMaxDistance = controls.playerMaxDistanceSlider:GetValue()
	profile.nameplateDungeonDistanceEnabled = controls.distanceDungeonCheck:GetValue()
	profile.nameplateDungeonDistance = controls.distanceDungeonSlider:GetValue()
	profile.nameplateRaidDistanceEnabled = controls.distanceRaidCheck:GetValue()
	profile.nameplateRaidDistance = controls.distanceRaidSlider:GetValue()

	local value
	-- value = controls.maxDistanceSlider:GetValue()
	-- if tonumber(value) and (value > 0) then
	-- 	addon:QueueSetCVar("nameplateMaxDistance", value)
	-- end
	-- value = controls.playerMaxDistanceSlider:GetValue()
	-- if tonumber(value) and (value > 0) then
	-- 	addon:QueueSetCVar("nameplatePlayerMaxDistance", value)
	-- end

	if controls.normalClampCheck:GetValue() then
		value = controls.normalTopInsetSlider:GetValue()
		if tonumber(value) then
			addon:QueueSetCVar("nameplateOtherTopInset", value)
		end
		value = controls.normalBottomInsetSlider:GetValue()
		if tonumber(value) then
			addon:QueueSetCVar("nameplateOtherBottomInset", value)
		end
	else
		addon:QueueSetCVar("nameplateOtherTopInset", -1)
		addon:QueueSetCVar("nameplateOtherBottomInset", -1)
	end

	if controls.bossClampCheck:GetValue() then
		value = controls.bossTopInsetSlider:GetValue()
		if tonumber(value) then
			addon:QueueSetCVar("nameplateLargeTopInset", value)
		end
		value = controls.bossBottomInsetSlider:GetValue()
		if tonumber(value) then
			addon:QueueSetCVar("nameplateLargeBottomInset", value)
		end
	else
		addon:QueueSetCVar("nameplateLargeTopInset", -1)
		addon:QueueSetCVar("nameplateLargeBottomInset", -1)
	end

	value = controls.showFriendlyNpcCheck:GetValue()
	if value ~= GetCVarBool("nameplateShowFriendlyNPCs") then
		addon:QueueSetCVar("nameplateShowFriendlyNPCs", value and 1 or 0)
	end

	value = tostring(controls.overlapHSlider:GetValue())
	if tonumber(value) then
		if value ~= GetCVar("nameplateOverlapH") then
			addon:QueueSetCVar("nameplateOverlapH", value)
		end
		profile.nameplateOverlapH = (value == GetCVarDefault("nameplateOverlapH")) and 0 or tonumber(value)
	end

	value = tostring(controls.overlapVSlider:GetValue())
	if tonumber(value) then
		if value ~= GetCVar("nameplateOverlapV") then
			addon:QueueSetCVar("nameplateOverlapV", value)
		end
		profile.nameplateOverlapV = (value == GetCVarDefault("nameplateOverlapV")) and 0 or tonumber(value)
	end

	value = controls.motionSpeedDropdown:GetValue()
	if value and motionSpeedValues[value] then
		addon:QueueSetCVar("nameplateMotionSpeed", motionSpeedValues[value])
	end

	profile.redHostile = controls.redHostileCheck:GetValue()
	profile.friendlyClassColor = controls.friendlyClassColorCheck:GetValue()
	profile.alwaysShowUnitName = controls.alwaysShowNameCheck:GetValue()
	profile.dynamicOpacity = controls.dynamicOpacityCheck:GetValue()

	local classID = controls.rangeCheckerModePlayerClass:GetUserData("classID")
	if classID and GetClassInfo(classID) then
		value = controls.rangeCheckerModeDropdown:GetValue()
		if value == profile.rangeCheckerMode.default then
			value = nil
		end
		profile.rangeCheckerMode[classID] = value
	end

	profile.showPlayerGuild = controls.showGuildNameCheck:GetValue()
	profile.showPlayerRealm = controls.showRealmNameCheck:GetValue()
	profile.showPlayerTitle = controls.showTitleCheck:GetValue()
	profile.powerBarEnemy = controls.enemyPowerBarCheck:GetValue()
	profile.friendlyClickThrough = controls.friendlyClickThroughCheck:GetValue()
	profile.dungeonFriendlyClickThrough = controls.dungeonFriendlyClickThroughCheck:GetValue()
	profile.disableFriendlyBars = controls.disableFreindlyBarsCheck:GetValue()
	profile.targetAlwaysOnTop = controls.targetAlwaysOnTop:GetValue()
	profile.disableFactionIcon = controls.disableFactionIconCheck:GetValue()
	profile.disableObjectiveIcon = controls.disableQuestObjectiveIconCheck:GetValue()
	profile.disableTrivialScaleInInstance = controls.disableTrivialScaleInInstanceCheck:GetValue()
	if not profile.disableObjectiveIcon then
		addon:QueueSetCVar("showQuestTrackingTooltips", 1)
	end
	profile.performanceMode = controls.performanceModeDropdown:GetValue()

	local value = controls.disableDefaultFiltersCheck:GetValue() and true
	if profile.disableDefaultFilters ~= value then
		profile.disableDefaultFilters = value
		addon:ClearFilterCacheAll()
	end

	options:SaveUserFilters()
	options:ClearUserFilters()
	options:SaveUserAuras()
	options:ClearUserAuras()
	addon:LoadProfile(true)
end

function mainPanel:default()
	db:ResetProfile()
	mainPanel:refresh()
	mainPanel:okay()
end

function filterPanel:refresh()
	options:RefreshFilters()
end

function filterPanel:okay()

end

function filterPanel:cancel()
	options:ClearUserFilters()
end

function filterPanel:default()
	HideUIPanel(ColorPickerFrame)
	options:ResetUserFilters()
	options:ClearUserFilters()
	addon:UpdateFilter()
	addon:RestyleNamePlates()
	filterPanel:refresh()
end

function auraPanel:refresh()
	options:RefreshAuras()
end

function auraPanel:okay()

end

function auraPanel:cancel()
	options:ClearUserAuras()
end

function auraPanel:default()
	HideUIPanel(ColorPickerFrame)
	options:ClearUserAuras()
	auraPanel:refresh()
end

local function NOP() end

local function Slider_OnMouseWheel(frame, delta)
	local widget = frame.obj
	if not widget.disabled then
		widget:SetValue(math.min(math.max(widget.value + (widget.step * delta), widget.min), widget.max))
	end
end

local function SliderEditbox_OnFocusGained(frame)
	frame.obj.frame:EnableMouseWheel(true)
	frame.obj.frame:SetScript("OnMouseWheel", Slider_OnMouseWheel)
end

local function SliderEditbox_OnFocusLost(frame)
	frame.obj.frame:EnableMouseWheel(false)
	frame.obj.frame:SetScript("OnMouseWheel", nil)
end

local function CreateGroup(name, title, parent)
	local group = GUI:Create("InlineGroup")
	group.frame:SetParent(parent or mainPanel)
	group:SetTitle(title)
	group:SetLayout("Flow")
	group.frame:EnableMouseWheel(true)
	group.frame:SetScript("OnMouseWheel", NOP)
	--group.frame:Show()
	controls[name] = group
	return group
end

local function CreateGroup2(name, title)
	local group = GUI:Create("InlineGroup")
	group:SetFullWidth(true)
	group:SetTitle(title)
	group:SetLayout("Flow")
	-- group.frame:EnableMouseWheel(true)
	-- group.frame:SetScript("OnMouseWheel", NOP)
	controls[name] = group
	return group
end

local function CreateSlider(name, label, min, max, step, width, onValueChanged)
	if not onValueChanged and type(width) == "function" then
		onValueChanged = width
		width = nil
	end
	local slider = GUI:Create("Slider")
	if not width or width < 1 then
		slider:SetRelativeWidth(width or 0.242)
	else
		slider:SetWidth(width)
	end
	slider:SetLabel(label)
	slider:SetSliderValues(min, max, step)
	-- slider.frame:EnableMouseWheel(true)
	-- slider.frame:SetScript("OnMouseWheel", Slider_OnMouseWheel)
	slider.editbox:SetScript("OnEditFocusGained", SliderEditbox_OnFocusGained)
	slider.editbox:SetScript("OnEditFocusLost", SliderEditbox_OnFocusLost)
	if type(onValueChanged) == "function" then
		slider:SetCallback("OnValueChanged", onValueChanged)
	end
	controls[name] = slider
	return slider
end

local function CreateHeader(title, name)
	local header = GUI:Create("Heading")
	header:SetFullWidth(true)
	if title then
		header:SetText(title)
	end
	if name then
		controls[name] = header
	end
	return header
end

local function Widget_OnEnter(widget)
	local offsetX = widget.checkbg and widget.checkbg:GetWidth() or 0
	if widget.checkbg then
		offsetX = widget.checkbg:GetWidth()
	else
		offsetX = 2
	end
	GameTooltip:SetOwner(widget.frame, "ANCHOR_TOPLEFT", offsetX, -2)
	GameTooltip:AddLine(widget:GetUserData("tooltipDesc"))
	GameTooltip:Show()
end

local function Dropdown_OnEnter(dropdown)
	GameTooltip:SetOwner(dropdown.frame, "ANCHOR_RIGHT", 0, 0)
	GameTooltip:SetText(dropdown:GetUserData("tooltipDesc"):gsub("<(.-)>", _G.NORMAL_FONT_COLOR_CODE.."%1|r"), 1, 1, 1)
	GameTooltip:Show()
end

local function Widget_OnLeave(widget)
	GameTooltip:Hide()
end

local function CreateCheckBox(name, label, desc, width, onValueChanged)
	local check = GUI:Create("CheckBox")
	if width > 0 then
		check:SetRelativeWidth(width)
	else
		check:SetWidth(-width)
	end
	check:SetLabel(label)
	if desc then
		if desc:sub(1, 1) == "!" then
			check:SetUserData("tooltipDesc", desc:sub(2))
			check:SetCallback("OnEnter", Widget_OnEnter)
			check:SetCallback("OnLeave", Widget_OnLeave)
		else
			check:SetDescription(desc)
		end
	end
	if type(onValueChanged) == "function" then
		check:SetCallback("OnValueChanged", onValueChanged)
	end
	controls[name] = check
	return check
end

local function DefaultButton_OnClick(button)
	local confirm = button:GetUserData("confirm")
	local panel = button:GetUserData("panel")
	if not panel then return end
	if confirm then
		button:SetUserData("confirm", false)
		button:SetText(_G.DEFAULTS)
		panel:default()
	else
		button:SetUserData("confirm", true)
		button:SetText(_G.OKAY)
		C_Timer.After(4, function()
			if button:GetUserData("confirm") then
				button:SetText(_G.DEFAULTS)
				button:SetUserData("confirm", false)
			end
		end)
	end
end

local function ResetHiddenCVars()
	if InCombatLockdown() then
		print("Not available during combat.")
		return
	end

	local cvars = {
		"NamePlateClassificationScale",
		"NamePlateMaximumClassificationScale",
		"nameplateGameObjectMaxDistance",
		"nameplateGlobalScale",
		"nameplateHideHealthAndPower",
		"nameplateLargerScale",
		"nameplateMaxAlpha",
		"nameplateMaxAlphaDistance",
		"nameplateMaxScale",
		"nameplateMaxScaleDistance",
		"nameplateMinAlpha",
		"nameplateMinAlphaDistance",
		"nameplateMinScale",
		"nameplateMinScaleDistance",
		"nameplateOccludedAlphaMult",
		"nameplatePlayerLargerScale",
		"nameplateSelectedAlpha",
		"nameplateSelectedScale",
		"nameplateSelfAlpha",
		"nameplateSelfBottomInset",
		"nameplateSelfScale",
		"nameplateSelfTopInset",
		"nameplateTargetBehindMaxDistance",
		"nameplateTargetRadialPosition",
		"ShowClassColorInFriendlyNameplate",
		"ShowClassColorInNameplate",
		-- "nameplateMaxDistance",
		-- "nameplatePlayerMaxDistance",
		-- "nameplateMotionSpeed",
	}

	local count = 0
	for i, v in ipairs(cvars) do
		local defaultValue = GetCVarDefault(v)
		if defaultValue ~= nil then
			local currentValue = GetCVar(v)
			if defaultValue ~= currentValue then
				print(v, ":", currentValue, "=>", defaultValue)
				SetCVar(v, defaultValue)
				count = count + 1
			end
		end
	end
	if count == 0 then
		print("No CVars to change were found.")
	end
end

local function CVarReduceFlucuation()
	if InCombatLockdown() then
		print("Not available during combat.")
		return
	end

	local cvars = {
		["nameplateLargerScale"] = "1.0",
		["nameplatePlayerLargerScale"] = "1.0",
		["nameplateSelectedScale"] = "0.965",
	}
	for k, v in pairs(cvars) do
		SetCVar(k, v)
		-- print(k, v)
	end
end

function options:CreateWidget()
	local titleText = mainPanel:CreateFontString(nil, nil, "GameFontNormalLarge")
	titleText:SetText(mainPanel.name)
	titleText:SetPoint("TOPLEFT", mainPanel, FRAME_MARGIN, -FRAME_MARGIN)

	local defaultButton = GUI:Create("Button") -- Default
	defaultButton.frame:SetParent(mainPanel)
	defaultButton:SetWidth(110)
	-- defaultButton.frame:SetHeight(20)
	defaultButton:SetPoint("TOPRIGHT", mainPanel, -7, -6)
	defaultButton:SetText(_G.DEFAULTS)
	defaultButton:SetUserData("panel", mainPanel)
	defaultButton:SetCallback("OnClick", DefaultButton_OnClick)
	defaultButton.frame:Show()
	mainPanel.defaultButton = defaultButton

	local applyButton = GUI:Create("Button") -- Apply
	applyButton.frame:SetParent(mainPanel)
	applyButton:SetWidth(110)
	-- applyButton.frame:SetHeight(20)
	applyButton:SetPoint("RIGHT", defaultButton.frame, "LEFT", -7, 0)
	applyButton:SetText(_G.APPLY)
	applyButton:SetCallback("OnClick", function()
		mainPanel:okay()
	end)
	applyButton.frame:Show()

	-- local aurasButton = GUI:Create("Button") -- Auras
	-- aurasButton.frame:SetParent(mainPanel)
	-- aurasButton:SetWidth(90)
	-- aurasButton.frame:SetHeight(20)
	-- aurasButton:SetPoint("TOPRIGHT", applyButton.frame, "TOPLEFT", -FRAME_MARGIN, 0)
	-- aurasButton:SetText(auraPanel.name)
	-- aurasButton:SetCallback("OnClick", function()
	-- 	-- InterfaceOptionsFrame_OpenToCategory(auraPanel)
	-- 	if auraPanel.category then
	-- 		_G.SettingsPanel:SelectCategory(auraPanel.category)
	-- 	end
	-- end)
	-- aurasButton.frame:Show()
	--
	-- local filtersButton = GUI:Create("Button") -- Filters
	-- filtersButton.frame:SetParent(mainPanel)
	-- filtersButton:SetWidth(90)
	-- filtersButton.frame:SetHeight(20)
	-- filtersButton:SetPoint("TOPRIGHT", aurasButton.frame, "TOPLEFT", -4, 0)
	-- filtersButton:SetText(filterPanel.name)
	-- filtersButton:SetCallback("OnClick", function()
	-- 	-- InterfaceOptionsFrame_OpenToCategory(filterPanel)
	-- 	if filterPanel.category then
	-- 		_G.SettingsPanel:SelectCategory(filterPanel.category)
	-- 	end
	-- end)
	-- filtersButton.frame:Show()

	local mainGroup = GUI:Create("ScrollFrame")
	-- group:AddChild(filterGroup)
	mainGroup.frame:SetParent(mainPanel)
	mainGroup:SetLayout("Flow")
	-- mainGroup:SetFullHeight(true)
	-- mainGroup:SetFullWidth(true)
	mainGroup:SetPoint("TOPLEFT", mainPanel, FRAME_MARGIN, -36)
	mainGroup:SetPoint("TOPRIGHT", mainPanel, -6, -36)
	mainGroup:SetPoint("BOTTOM", mainPanel, 0, 7)
	--mainGroup.frame:SetHeight(485)
	mainGroup.frame:Show()

	local group = CreateGroup2("styleGroup", "Style")
	mainGroup:AddChild(group)
	-- group:SetPoint("TOPLEFT", mainPanel, FRAME_MARGIN, -136)
	-- group:SetPoint("TOPRIGHT", mainPanel, -FRAME_MARGIN, -136)
	-- group.frame:Show()

	-- group:AddChild(CreateHeader("Frame"))
	group:AddChild(CreateSlider("healthWidthSlider", "Frame Width", 50, 200, 0.5, 0.325))
	group:AddChild(CreateSlider("frameMarginY", "Frame Margin", 0, 60, 1, 0.325))
	group:AddChild(CreateSlider("trivialScaleSlider", "Trivial Scale", 0.4, 1, 0.05, 0.325))

	group:AddChild(CreateHeader("Bar"))
	group:AddChild(CreateSlider("healthHeightSlider", "Health Bar Height", 3, 25, 0.1, 0.4))
	group:AddChild(CreateSlider("castHeightSlider", "Cast Bar Height", 3, 25, 0.1, 0.4))

	if AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.statusbar then
		local healthTextureDropdown = GUI:Create("LSM30_Statusbar")
		healthTextureDropdown:SetLabel("Health Bar Texture")
		healthTextureDropdown:SetRelativeWidth(0.4)
		local healthTexturelist = {[BARTEXTURE_DEFAULT] = addon.defaults.castBarTexture or addon.defaults.barTexture}
		for k, v in pairs(AceGUIWidgetLSMlists.statusbar) do
			healthTexturelist[k] = v
		end
		healthTextureDropdown:SetList(healthTexturelist)
		healthTextureDropdown:SetCallback("OnValueChanged", function(widget, event, key)
			widget:SetValue(key)
		end)
		controls.healthTextureDropdown = healthTextureDropdown
		group:AddChild(healthTextureDropdown)

		local castTextureDropdown = GUI:Create("LSM30_Statusbar")
		castTextureDropdown:SetLabel("Cast Bar Texture")
		castTextureDropdown:SetRelativeWidth(0.4)
		local castTexturelist = {[BARTEXTURE_DEFAULT] = addon.defaults.castBarTexture or addon.defaults.barTexture}
		for k, v in pairs(AceGUIWidgetLSMlists.statusbar) do
			castTexturelist[k] = v
		end
		castTextureDropdown:SetList(castTexturelist)
		castTextureDropdown:SetCallback("OnValueChanged", function(widget, event, key)
			widget:SetValue(key)
		end)
		controls.castTextureDropdown = castTextureDropdown
		group:AddChild(castTextureDropdown)
		group:AddChild(CreateSlider("barOffsetYSlider", "Health Bar Offset Y", -20, 30, 1, 0.4))
	else
		local noLSMLabel1 = GUI:Create("Label")
		noLSMLabel1:SetRelativeWidth(0.9)
		noLSMLabel1:SetFontObject(GameFontNormalLarge)
		noLSMLabel1:SetText("AceGUI-3.0-SharedMediaWidgets was not found.\n\n")
		group:AddChild(noLSMLabel1)
	end

	group:AddChild(CreateHeader("Border"))
	group:AddChild(CreateSlider("borderWidthSlider", "Border Width", 1, 15, 0.5, 0.325))

	local borderStyleDropdown = GUI:Create("Dropdown")
	borderStyleDropdown:SetLabel("Border Style")
	borderStyleDropdown:SetRelativeWidth(0.23)
	local list = {}
	for i = 1, #borderTypes do list[i] = borderTypes[i].name end
	borderStyleDropdown:SetList(list)
	controls.borderStyleDropdown = borderStyleDropdown
	group:AddChild(borderStyleDropdown)

	group:AddChild(CreateHeader("Fonts"))

	if AceGUIWidgetLSMlists and AceGUIWidgetLSMlists.font then
		local unitFontDropdown = GUI:Create("LSM30_Font")
		unitFontDropdown:SetLabel("Unit Name")
		unitFontDropdown:SetRelativeWidth(0.55)
		local unitFontList = {[_G.DEFAULT] = _G.GameFontWhite:GetFont()}
		for k, v in pairs(AceGUIWidgetLSMlists.font) do
			unitFontList[k] = v
		end
		unitFontDropdown:SetList(unitFontList)
		unitFontDropdown:SetCallback("OnValueChanged", function(widget, event, key)
			widget:SetValue(key)
		end)
		controls.unitFontDropdown = unitFontDropdown
		group:AddChild(unitFontDropdown)
		group:AddChild(CreateSlider("unitNameSlider", "Size", 5, 30, 0.1, 0.24))
		group:AddChild(CreateCheckBox("unitNameOutlineCheck", "Outline", nil, 0.18))

		local spellFontDropdown = GUI:Create("LSM30_Font")
		spellFontDropdown:SetLabel("Spell Name and Status Text")
		spellFontDropdown:SetRelativeWidth(0.55)
		local spellFontList = {[_G.DEFAULT] = _G.GameFontWhiteTiny:GetFont()}
		for k, v in pairs(AceGUIWidgetLSMlists.font) do
			spellFontList[k] = v
		end
		spellFontDropdown:SetList(spellFontList)
		spellFontDropdown:SetCallback("OnValueChanged", function(widget, event, key)
			widget:SetValue(key)
		end)
		controls.spellFontDropdown = spellFontDropdown
		group:AddChild(spellFontDropdown)
		group:AddChild(CreateSlider("spellNameSlider", "Size (Spell Name Only)", 5, 30, 0.1, 0.24))
		group:AddChild(CreateCheckBox("spellNameOutlineCheck", "Outline", nil, 0.18))

		local unitFontPlayerDropdown = GUI:Create("LSM30_Font")
		unitFontPlayerDropdown:SetLabel("Friendly Player"..ORANGE_FONT_COLOR_CODE.." *only used when no health bar"..FONT_COLOR_CODE_CLOSE)
		unitFontPlayerDropdown:SetRelativeWidth(0.55)
		local unitFontList = {[_G.DEFAULT] = _G.GameFontWhite:GetFont()}
		for k, v in pairs(AceGUIWidgetLSMlists.font) do
			unitFontList[k] = v
		end
		unitFontPlayerDropdown:SetList(unitFontList)
		unitFontPlayerDropdown:SetCallback("OnValueChanged", function(widget, event, key)
			widget:SetValue(key)
		end)
		controls.unitFontPlayerDropdown = unitFontPlayerDropdown
		group:AddChild(unitFontPlayerDropdown)
		group:AddChild(CreateSlider("unitNamePlayerSlider", "Size", 5, 30, 0.1, 0.24))
		group:AddChild(CreateCheckBox("unitNamePlayerOutlineCheck", "Outline", nil, 0.18))
	else
		local noLSMLabel1 = GUI:Create("Label")
		noLSMLabel1:SetRelativeWidth(0.9)
		noLSMLabel1:SetFontObject(GameFontNormalLarge)
		noLSMLabel1:SetText("AceGUI-3.0-SharedMediaWidgets was not found.\n\n")
		group:AddChild(noLSMLabel1)
	end

	group:AddChild(CreateHeader("Raid Icon"))
	local raidIconAnchorDropdown = GUI:Create("Dropdown")
	raidIconAnchorDropdown:SetLabel("Raid Icon Anchor")
	raidIconAnchorDropdown:SetRelativeWidth(0.18)
	raidIconAnchorDropdown:SetList({TOP = "Top", LEFT = "Left", RIGHT = "Right", BOTTOM = "Bottom"}, {"TOP", "LEFT", "RIGHT", "BOTTOM"})
	controls.raidIconAnchorDropdown = raidIconAnchorDropdown
	group:AddChild(raidIconAnchorDropdown)

	group:AddChild(CreateSlider("raidIconOffsetXSlider", "Raid Icon Offset X", -50, 50, 1, 0.26))
	group:AddChild(CreateSlider("raidIconOffsetYSlider", "Raid Icon Offset Y", -50, 50, 1, 0.26))
	group:AddChild(CreateSlider("raidIconSlider", "Raid Icon Size", 5, 40, 0.5, 0.26))

	group:AddChild(CreateHeader("Miscellaneous"))

	local dungeonFontDropdown = GUI:Create("Dropdown")
	dungeonFontDropdown:SetLabel("Dungeon Friendly Name Size")
	dungeonFontDropdown:SetRelativeWidth(0.325)
	dungeonFontDropdown:SetList({[14] = "14", [16] = "16", [18] = "18"}, {14, 16, 18})
	controls.dungeonFontDropdown = dungeonFontDropdown
	group:AddChild(dungeonFontDropdown)

	group:AddChild(CreateSlider("nobarOffsetYSlider", "Friendly Name Offset Y", -20, 30, 1, 0.325))
	group:AddChild(CreateSlider("spellIconSlider", "Spell Icon Size", 5, 30, 0.5, 0.325))
	group:AddChild(CreateSlider("dungeonWidthMultiSlider", "Dungeon Friendly Multiplier", 0.1, 1, 0.01, 0.325))

	local group = CreateGroup2("healthTextGroup", "Health Text")
	group:AddChild(CreateCheckBox("healthTextCheck", "Display Health Text", nil, 0.9, HealthText_OnValueChanged))
	group:AddChild(CreateCheckBox("healthTextPercentageCheck", "Percentage", nil, 0.9))
	group:AddChild(CreateCheckBox("healthTextMaxCheck", "Maximum Health", nil, 0.9))
	group:AddChild(CreateCheckBox("disableExecuteCheck", "Disable Execute State", nil, 0.3, ExecuteColorCheck_OnValueChanged))
	group:AddChild(CreateSlider("executeThresholdSlider", "Execute Threshold", 0.1, 0.9, 0.01, 0.3))
	controls.executeThresholdSlider:SetIsPercent(true)
	local executeColor = GUI:Create("ColorPicker")
	executeColor:SetHasAlpha(false)
	executeColor:SetRelativeWidth(0.35)
	executeColor:SetLabel("Execute Color")
	controls.executeColor = executeColor
	group:AddChild(executeColor)
	mainGroup:AddChild(group)

	local group = CreateGroup2("targetGroup", "Target Emphasize")
	mainGroup:AddChild(group)
	-- group:SetPoint("TOPLEFT", controls.styleGroup.frame, "BOTTOMLEFT", 0, -FRAME_SPACE)
	-- group:SetPoint("TOPRIGHT", controls.styleGroup.frame, "BOTTOMRIGHT", 0, -FRAME_SPACE)
	group:AddChild(CreateCheckBox("flashCheck", "Flash", nil, 0.15))
	group:AddChild(CreateCheckBox("shineCheck", "Shine", nil, 0.15, Shine_OnValueChanged))
	group:AddChild(CreateSlider("shineAlphaSlider", "Shine Alpha", 0.1, 1.0, 0.05))
	group:AddChild(CreateHeader())
	group:AddChild(CreateCheckBox("animationCheck", "Animation", nil, 0.2, Animation_OnValueChanged))
	group:AddChild(CreateSlider("animationAlphaSlider", "Animation Alpha", 0.01, 1.0, 0.01, 155))

	local animationStyleDropdown = GUI:Create("Dropdown")
	animationStyleDropdown:SetLabel("Animation Style")
	animationStyleDropdown:SetRelativeWidth(0.2)
	animationStyleDropdown:SetList({default = _G.DEFAULT, fit = "Fit", wide = "Wide", full = "Full"}, {"default", "fit", "wide", "full"})
	controls.animationStyleDropdown = animationStyleDropdown
	group:AddChild(animationStyleDropdown)

	group:AddChild(CreateCheckBox("animationOverlayCheck", "Overlay", nil, 0.15))

	local group = CreateGroup2("distanceGroup", "Visibility")
	mainGroup:AddChild(group)

	group:AddChild(CreateSlider("maxDistanceSlider", "Max Distance", 20, 60, 1, 0.48))
	group:AddChild(CreateSlider("playerMaxDistanceSlider", "Player Max Distance", 20, 60, 1, 0.48))
	group:AddChild(CreateCheckBox("distanceDungeonCheck", "in Dungeon", nil, 0.185, DistanceDungeonCheck_OnValueChanged))
	group:AddChild(CreateSlider("distanceDungeonSlider", "", 20, 60, 1, 0.4))
	local label = GUI:Create("Label")
	label:SetRelativeWidth(0.3)
	group:AddChild(label)
	group:AddChild(CreateCheckBox("distanceRaidCheck", "in Raid", nil, 0.185, DistanceRaidCheck_OnValueChanged))
	group:AddChild(CreateSlider("distanceRaidSlider", "", 20, 60, 1, 0.4))


	local group = CreateGroup2("commonGroup", "Common")
	mainGroup:AddChild(group)
	-- group:SetPoint("TOPLEFT", controls.targetGroup.frame, "BOTTOMLEFT", 0, -FRAME_SPACE)
	-- group:SetPoint("TOPRIGHT", controls.targetGroup.frame, "BOTTOMRIGHT", 0, -FRAME_SPACE)

	group:AddChild(CreateCheckBox("redHostileCheck", "Use red color for hostile NPC", nil, 0.9))
	group:AddChild(CreateCheckBox("friendlyClassColorCheck", "Use class colors for friendly players", nil, 0.9))
	group:AddChild(CreateCheckBox("alwaysShowNameCheck", "Always display name with health bar", nil, 0.9))
	group:AddChild(CreateCheckBox("dynamicOpacityCheck", "Dynamic Opacity "..RELOAD, "!Nameplate Opacity is dynamically changed based on LoS.", 0.9, DynamicOpacity_OnValueChanged))

	local rangeCheckerModeDropdown = GUI:Create("Dropdown")
	rangeCheckerModeDropdown:SetLabel("Range Checker Mode")
	rangeCheckerModeDropdown:SetRelativeWidth(0.25)
	rangeCheckerModeDropdown:SetList({disabled = _G.VIDEO_OPTIONS_DISABLED, item30 = "Item 30 yd", item40 = "Item 40 yd", spell = "Spell"}, {"disabled", "item30", "item40", "spell"})
	rangeCheckerModeDropdown:SetUserData("tooltipDesc",
		"<Each nameplate is checked every frame.>\n\n"..
		"<Disabled:>\n No range check.\n\n"..
		"<Item:>\n Check with item. Only slightly affects performance.\n\n"..
		"<Spell:>\n Check with class spell. Little affects performance.\n\n"..
		"<Range Checker depends on Dynamic Opacity.>"
	)
	rangeCheckerModeDropdown:SetCallback("OnEnter", Dropdown_OnEnter)
	rangeCheckerModeDropdown:SetCallback("OnLeave", Widget_OnLeave)
	controls.rangeCheckerModeDropdown = rangeCheckerModeDropdown
	group:AddChild(rangeCheckerModeDropdown)

	local label = GUI:Create("Label")
	label:SetRelativeWidth(0.013)
	group:AddChild(label)

	local rangeCheckerModePlayerClass = GUI:Create("Label")
	rangeCheckerModePlayerClass:SetRelativeWidth(0.55)
	controls.rangeCheckerModePlayerClass = rangeCheckerModePlayerClass
	group:AddChild(rangeCheckerModePlayerClass)

	group:AddChild(CreateCheckBox("showGuildNameCheck", "Display guild name for friendly players", nil, 0.9))
	group:AddChild(CreateCheckBox("showRealmNameCheck", "Display realm name for players", nil, 0.9))
	group:AddChild(CreateCheckBox("showTitleCheck", "Display title for players", nil, 0.9))
	group:AddChild(CreateCheckBox("enemyPowerBarCheck", "Display power bar for hostile players", nil, 0.9))
	group:AddChild(CreateCheckBox("friendlyClickThroughCheck", "Click-through for friendly units", "!Check this you can't select by mouse-click on those units.", 0.9))
	group:AddChild(CreateCheckBox("dungeonFriendlyClickThroughCheck", "Click-through for friendly units in Dungeon", "!Check this you can't select by mouse-click on those units.", 0.9))
	group:AddChild(CreateCheckBox("disableFreindlyBarsCheck", "Do not display a health bar for frinedly units", "This will aslo shrink Friendly Nameplates in the dungeon.", 0.9))
	group:AddChild(CreateCheckBox("disableFactionIconCheck", "Do not display a faction icon in PvP Battle Zone", nil, 0.9))
	group:AddChild(CreateCheckBox("disableQuestObjectiveIconCheck", "Disable Quest Objective Indicator", nil, 0.9))
	group:AddChild(CreateCheckBox("disableTrivialScaleInInstanceCheck", "Disable Trivial Scale in the instance", nil, 0.9))
	group:AddChild(CreateCheckBox("targetAlwaysOnTop", "Target is always on top", nil, 0.9))

	local performanceModeDropdown = GUI:Create("Dropdown")
	performanceModeDropdown:SetLabel("Performance Mode")
	performanceModeDropdown:SetRelativeWidth(0.2)
	performanceModeDropdown:SetList({[-1] = "Auto", [0] = _G.VIDEO_OPTIONS_DISABLED, [1] = _G.VIDEO_OPTIONS_ENABLED}, {-1, 0, 1})
	controls.performanceModeDropdown = performanceModeDropdown
	group:AddChild(performanceModeDropdown)

	local label = GUI:Create("Label")
	label:SetRelativeWidth(0.013)
	group:AddChild(label)

	local label = GUI:Create("Label")
	label:SetText("Fully suspend the hidden Blizzard Nameplates. Personal Resource will be disabled. In addition, Friendly Nameplates are hidden in the dungeon. If enable this improve performance. "..NORMAL_FONT_COLOR_CODE.."Currently "..(addon.performanceMode and _G.VIDEO_OPTIONS_ENABLED or _G.VIDEO_OPTIONS_DISABLED)..FONT_COLOR_CODE_CLOSE..".\n"..RELOAD)
	label:SetRelativeWidth(0.77)
	group:AddChild(label)

	local group = CreateGroup2("advancedGroup", "Advanced Control (Character Specific)")
	group:AddChild(CreateCheckBox("showFriendlyNpcCheck", "Show friendly NPC", nil, 0.9))

	local clampingGroup = CreateGroup2("clampingGroup", "Clamping")
	group:AddChild(clampingGroup)
	clampingGroup:AddChild(CreateCheckBox("normalClampCheck", "", nil, 0.07, NormalClampCheck_OnValueChanged))
	clampingGroup:AddChild(CreateSlider("normalTopInsetSlider", ("Top Inset (%s %s)"):format(_G.DEFAULT, GetCVarDefault("nameplateOtherTopInset")), -0.1, 0.2, 0.01, 0.45))
	clampingGroup:AddChild(CreateSlider("normalBottomInsetSlider", ("Bottom Inset (%s %s)"):format(_G.DEFAULT, GetCVarDefault("nameplateOtherBottomInset")), -0.1, 0.2, 0.01, 0.45))
	clampingGroup:AddChild(CreateCheckBox("bossClampCheck", "", nil, 0.07, BossClampCheck_OnValueChanged))
	clampingGroup:AddChild(CreateSlider("bossTopInsetSlider", ("Boss Top Inset (%s %s)"):format(_G.DEFAULT, GetCVarDefault("nameplateLargeTopInset")), -0.1, 0.2, 0.01, 0.45))
	clampingGroup:AddChild(CreateSlider("bossBottomInsetSlider", ("Boss Bottom Inset (%s %s)"):format(_G.DEFAULT, GetCVarDefault("nameplateLargeBottomInset")), -0.1, 0.2, 0.01, 0.45))

	local motionSpeedDropdown = GUI:Create("Dropdown")
	motionSpeedDropdown:SetLabel("Motion Speed")
	motionSpeedDropdown:SetRelativeWidth(0.22)
	motionSpeedDropdown:SetList({VERYSLOW = "Very Slow", SLOW = "Slow", DEFAULT = _G.DEFAULT, FAST = "Fast", VERYFAST = "Very Fast", SUPERFAST = "Super Fast"}, {"VERYSLOW", "SLOW", "DEFAULT", "FAST", "VERYFAST", "SUPERFAST"})
	controls.motionSpeedDropdown = motionSpeedDropdown
	group:AddChild(motionSpeedDropdown)
	local label = GUI:Create("Label")
	label:SetRelativeWidth(0.7)
	group:AddChild(label)

	local overlapGroup = CreateGroup2("overlapGroup", "Stacking Overlap")
	group:AddChild(overlapGroup)

	local label = GUI:Create("Label")
	label:SetText("This will NOT change the nameplate's clickable rect. If the value is less than 1.0, they overlap on the clickable area.")
	label:SetFullWidth(true)
	overlapGroup:AddChild(label)

	overlapGroup:AddChild(CreateSlider("overlapHSlider", ("Horizontal (%s %s)"):format(_G.DEFAULT, GetCVarDefault("nameplateOverlapH")), 0.5, 1.5, 0.05, 0.4))
	overlapGroup:AddChild(CreateSlider("overlapVSlider", ("Vertical (%s %s)"):format(_G.DEFAULT, GetCVarDefault("nameplateOverlapV")), 0.5, 1.5, 0.05, 0.4))

	local cvarResetButton = GUI:Create("Button")
	local buttonText = "Reset CVars"
	cvarResetButton:SetText(buttonText)
	cvarResetButton:SetWidth(180)
	-- cvarResetButton:SetCallback("OnEnter", function()
	-- 	GameTooltip:SetOwner(cvarResetButton.frame, "ANCHOR_RIGHT", 0, 0)
	-- 	GameTooltip:SetText("Reset CVars for hidden nameplate attributes. This may resolve strange behaviour.")
	-- 	GameTooltip:Show()
	-- end)
	cvarResetButton:SetUserData("tooltipDesc", "Reset CVars for hidden nameplate attributes. This may resolve strange behaviour.")
	cvarResetButton:SetCallback("OnEnter", Widget_OnEnter)
	cvarResetButton:SetCallback("OnLeave", Widget_OnLeave)
	cvarResetButton:SetCallback("OnClick", function()
		local confirm = cvarResetButton:GetUserData("confirm")
		if confirm then
			cvarResetButton:SetUserData("confirm", false)
			cvarResetButton:SetText(buttonText)
			ResetHiddenCVars()
		else
			cvarResetButton:SetUserData("confirm", true)
			cvarResetButton:SetText(_G.OKAY)
			C_Timer.After(4, function()
				if cvarResetButton:GetUserData("confirm") then
					cvarResetButton:SetText(buttonText)
					cvarResetButton:SetUserData("confirm", false)
				end
			end)
		end
	end)
	group:AddChild(cvarResetButton)

	local cvarFix1Button = GUI:Create("Button")
	local buttonText = "Reduce fluctuation"
	cvarFix1Button:SetText(buttonText)
	cvarFix1Button:SetWidth(180)
	cvarFix1Button:SetUserData("tooltipDesc", "Some scale adjustments in CVars reduce moving fluctuations of the nameplates.")
	cvarFix1Button:SetCallback("OnEnter", Widget_OnEnter)
	cvarFix1Button:SetCallback("OnLeave", Widget_OnLeave)
	cvarFix1Button:SetCallback("OnClick", CVarReduceFlucuation)
	group:AddChild(cvarFix1Button)

	mainGroup:AddChild(group)

end

local NpcNames, GetNpcGuild do
	local NpcGuilds = {}
	function GetNpcGuild(npcID)
		if NpcGuilds[npcID] then
			return NpcGuilds[npcID]
		else
			return NpcNames[npcID] and NpcGuilds[npcID] or nil
		end
	end
	local FORMAT_TOOLTIP_LEVEL = "^"..TOOLTIP_UNIT_LEVEL:gsub("%%s", ".+")
	local FORMAT_GUID_NPC = "unit:Creature-0-1-1-12345-%d-0000000000"

	NpcNames = setmetatable({}, {__index =
		function(self, key)
			local link = FORMAT_GUID_NPC:format(key)
			-- link = "unit:Creature-0-2083-2222-1255-173138-00004AC504"
			local tooltipData = C_TooltipInfo.GetHyperlink(link)
			if tooltipData and tooltipData.lines[2] then
				local lines = tooltipData.lines
				TooltipUtil.SurfaceArgs(lines[1])
				TooltipUtil.SurfaceArgs(lines[2])
				local value, guildName = lines[1].leftText, lines[2].leftText
				if value then
					self[key] = value
					NpcGuilds[key] = guildName
					return value
				end
			end
			return _G.UNKNOWN
		end
	})

	if _TOCVERSION < 100002 then
		local tooltip = CreateFrame("GameTooltip", "NamePlateKAINPCTooltip", nil, "SharedTooltipTemplate")
		NpcNames = setmetatable({}, {__index =
			function(self, key)
				tooltip:SetOwner(_G.UIParent, "ANCHOR_NONE")
				local link = FORMAT_GUID_NPC:format(key)
				-- link = "unit:Creature-0-2083-2222-1255-173138-00004AC504"
				tooltip:SetHyperlink(link)
				local value, guildName = tooltip.TextLeft1:GetText(), tooltip.TextLeft2:GetText()
				tooltip:Hide()
				if value then
					self[key] = value
					NpcGuilds[key] = guildName
				else
					value = _G.UNKNOWN
				end
				return value
			end
		})
	end
end

function options:ResetUserFilters()
	if _G.NamePlateKAIFilter then
		for map, filter in pairs(_G.NamePlateKAIFilter) do
			if filter.recolor then
				for name, color in pairs(filter.recolor) do
					if type(color) == "table" then
						wipe(color)
					end
				end
				wipe(filter.recolor)
			end
			wipe(filter)
			--addon:ClearFilterCache(map)
		end
		wipe(_G.NamePlateKAIFilter)
	end
	addon:ClearFilterCacheAll()
end

function options:SaveUserFilters()
	if not _G.NamePlateKAIFilter then
		_G.NamePlateKAIFilter = {}
	end
	local db = _G.NamePlateKAIFilter

	for map, filter in pairs(userFilters) do
		if filter.modified then
			if not db[map] then db[map] = { recolor = {} } end
			if not db[map].recolor then db[map].recolor = {} end
			wipe(db[map].recolor)
			for name, color in pairs(filter.color) do
				db[map].recolor[name] = color
			end
			if next(db[map].recolor) == nil then
				wipe(db[map])
				db[map] = nil
			end
			if map == "global" then
				addon:ClearFilterCacheAll()
			else
				addon:ClearFilterCache(map)
			end
			filter.modified = nil
		end
	end
	if not next(db) then
		_G.NamePlateKAIFilter = nil
	end
end

function options:ClearUserFilters()
	for map, filter in pairs(userFilters) do
		if filter.color then
			wipe(filter.color)
		end
		wipe(filter)
	end
	wipe(userFilters)

	controls.filterGroup:ReleaseChildren()
	wipe(filterControls)
end

local function GetColoredText(text, color)
	return ("|cff%.2x%.2x%.2x%s|r"):format(color[1] * 255, color[2] * 255, color[3] * 255, text)
end

local function GetColoredSqure(text, color)
	return ("|T130871:0:0:0:0:8:8:0:8:0:8:%d:%d:%d|t"):format(color[1] * 255, color[2] * 255, color[3] * 255)..(text and GetColoredText(text, color) or "")
end

local function LoadZoneFilter(map)
	if not addon.defaultFilters[map] then return end
	local t = zoneFilters[map] or {}
	for k, v in pairs(t) do wipe(v) end
	wipe(t)
	for _, difficulty in pairs({"*", "Heroic", "Challenge", "Mythic"}) do
		if difficulty == "*" or addon.defaultFilters[map][difficulty] then
			local filter = addon:LoadFilter(addon.defaultFilters[map], "-"..difficulty)
			for k, v in pairs(filter.color) do
				if not t[k] then t[k] = {} end
				t[k][difficulty] = v
			end
		end
	end

	zoneFilters[map] = t
	return zoneFilters[map]
end

local function RefreshFilterNpcNames()
	local id
	for k, v in pairs(filterControls) do
		if k:find("\\nameLabel$") then
			id = v:GetUserData("id")
			if type(id) == "number" then
				v:SetText(NpcNames[id])
			end
		elseif k:find("\\header$") then
			id = tonumber(k:match("^npc(%d+)\\"))
			if id then -- npcID
				v:SetText(NpcNames[id])
			else
				id = tonumber(k:match("^npcg(%d+)\\"))
				if id then
					v:SetText(GetNpcGuild(id))
				end
			end
		end
	end
end

local filterOrder = {}
function options:RefreshFilters()
	controls.filterGroup:ReleaseChildren()
	wipe(filterControls)
	local map = controls.filterZoneDropdown:GetValue()
	if not map then
		map = addon.filterID or "default"
		if not controls.filterZoneDropdown.list[map] then
			map = "default"
		end
		controls.filterZoneDropdown:SetValue(map)
	end

	controls.filterGroup:PauseLayout()

	local zoneFilter = LoadZoneFilter(map)

	wipe(filterOrder)
	local order = addon.defaultFilters[map] and addon.defaultFilters[map].order
	if type(order) == "table" then
		local id
		for i, v in ipairs(order) do
			id = type(v) == "string" and tonumber(v)
			if id then
				tinsert(filterOrder, id < 0 and EJ_GetEncounterInfo(-id) or EJ_GetSectionInfo(id) or id)
			else
				tinsert(filterOrder, v)
			end
		end
	end

	local header = GUI:Create("Label")
	header:SetFullWidth(true)
	controls.filterGroup:AddChild(header)

	if not userFilters[map] then
		userFilters[map] = { color = {} }
		addon:LoadUserFilter(map, userFilters[map], true)
	end

	local count = 0

	for name, v in pairs(zoneFilter) do
		if not tContains(filterOrder, name) then
			options:AddFilterWidget(map, name, zoneFilter)
			count = count + 1
		end
	end

	local header
	for _, name in ipairs(filterOrder) do
		headerText = type(name) == "string" and name:match("h\\(.+)")
		if headerText then
			if tonumber(headerText) then
				headerText = EJ_GetEncounterInfo(headerText) or headerText
			end
			local header = GUI:Create("Heading")
			header:SetFullWidth(true)
			if headerText ~= "-" then
				header:SetText(headerText)
				local id = tonumber(headerText:match("^npc(%d+)"))
				if id then
					header:SetText(NpcNames[id])
				else
					id = tonumber(headerText:match("^npcg(%d+)"))
					if id then
						header:SetText(GetNpcGuild(id) or headerText)
					end
				end
				filterControls[headerText.."\\header"] = header
			end
			controls.filterGroup:AddChild(header)
		elseif zoneFilter[name] then
			options:AddFilterWidget(map, name, zoneFilter)
			count = count + 1
		end
	end

	--for name, v in pairs(zoneFilter) do
	--	options:AddFilterWidget(map, name, zoneFilter)
	--	count = count + 1
	--end

	if count > 0 then
		local header = GUI:Create("Heading")
		header:SetFullWidth(true)
		controls.filterGroup:AddChild(header)
	end

	for name, v in pairs(userFilters[map].color) do
		if not zoneFilter[name] then
			options:AddFilterWidget(map, name)
			count = count + 1
		end
	end

	if count > 0 then
		C_Timer.After(1, RefreshFilterNpcNames)
	else
		local noneLabel = GUI:Create("Label")
		noneLabel:SetRelativeWidth(0.3)
		noneLabel:SetFontObject(GameFontNormal)
		noneLabel:SetText(_G.NONE)
		controls.filterGroup:AddChild(noneLabel)
		local header = GUI:Create("Heading")
		header:SetFullWidth(true)
		controls.filterGroup:AddChild(header)
	end

	options:AddFilterButton()

	controls.filterGroup:ResumeLayout()
	controls.filterGroup:DoLayout()
end

local function GetZoneList()
	local list = {}
	local order = {}
	local name
	for map, filter in pairs(addon.defaultFilters) do
		if type(filter.zone) == "number" then
			name = EJ_GetInstanceInfo(filter.zone)
		else
			name = filter.zone
		end
		if not name then
			name = _G.UNKNOWN.."["..map.."]"
		end
		if filter.coloredZoneText then

		elseif type(filter.categoryColorHex) == "string" and tonumber("0x"..filter.categoryColorHex) then
			name = "|cff"..filter.categoryColorHex..name.."|r"
		elseif type(filter.category) == "number" then
			if filter.category > 1000 then
				name = "|cffffeecc"..name.."|r"
			elseif filter.category > 900 then
				name = "|cffcc55dd"..name.."|r"
			elseif filter.category > 800 then
				name = "|cffb0e0f0"..name.."|r"
			elseif filter.category > 700 then
					name = "|cff44ff44"..name.."|r"
			elseif filter.category > 600 then
				name = "|cffff8844"..name.."|r"
			elseif filter.category > 500 then
				name = "|cff44ffcc"..name.."|r"
			elseif filter.category > 400 then
				name = "|cffff4444"..name.."|r"
			end
		end
		if type(filter.category) == "number" then
			if (filter.category % 100) > 90 then
				name = name.." (".._G.PVP..")"
			elseif (filter.category % 100) > 70 then
				name = name.." (".._G.TRACKER_HEADER_SCENARIO..")"
			elseif (filter.category % 100) > 50 then
				name = name.." (".._G.RAID..")"
			end
		end
		tinsert(order, map)
		list[map] = name
	end
	local p1, p2
	table.sort(order, function(v1, v2)
		v1 = tonumber(v1) or v1
		v2 = tonumber(v2) or v2
		p1 = tonumber(addon.defaultFilters[v1] and addon.defaultFilters[v1].category or 10000)
		p2 = tonumber(addon.defaultFilters[v2] and addon.defaultFilters[v2].category or 10000)
		p1 = p1 == 0 and 9000 or p1
		p2 = p2 == 0 and 9000 or p2
		if math.floor(p1 / 100) == math.floor(p2 / 100) then
			return p1 < p2
		else
			return math.floor(p1 / 100) > math.floor(p2 / 100)
		end
	end)
	return list, order
end

local function GetFilterDefaultText(zoneFilter, name)
	local text = " ".._G.DEFAULT
	local textDiff
	local color

	for _, v in ipairs({"*", "Heroic", "Challenge", "Mythic"}) do
		if zoneFilter[name][v] then
			color = zoneFilter[name][v]
			if v ~= "*" then
				textDiff = (textDiff or "")..v:sub(1, 1)
			end
		end
	end
	if color then
		if textDiff then
			text = text.." - "..textDiff
		end
		return GetColoredSqure(text, color)
	else
		return _G.DEFAULT
	end
end

local function FilterColorDropdown_Refresh(dropdown)
	local map = dropdown:GetUserData("map")
	local name = dropdown:GetUserData("id")
	local value = "default"
	local colorPicker = filterControls[name.."\\colorPicker"]
	--if not colorPicker then return end
	if userFilters[map] then
		local color = userFilters[map].color[name]
		if color == false then
			value = "disable"
		elseif type(color) == "number" then
			value = color
		elseif type(color) == "table" then
			value = "custom"
			colorPicker = colorPicker or options:AddFilterColorPicker(map, name)
			colorPicker:SetColor(color[1], color[2], color[3])
		end
	end
	dropdown:SetValue(value)
	if colorPicker then
		colorPicker.frame:SetShown(value == "custom")
	end
end

local filterColors = {
	[1] = GetColoredSqure("1 Light Yellow", profile.filterColors[1]),
	[2] = GetColoredSqure("2 Light Purple", profile.filterColors[2]),
	[3] = GetColoredSqure("3 Light Blue", profile.filterColors[3]),
	[4] = GetColoredSqure("4 (no aggro)", profile.filterColors[4]),
	[5] = GetColoredSqure("5 (no aggro)", profile.filterColors[5]),
	[6] = GetColoredSqure("6 (no aggro)", profile.filterColors[6]),
	[7] = GetColoredSqure("7 Dark Green", profile.filterColors[7]),
	[8] = GetColoredSqure("8 White", profile.filterColors[8]),
	[9] = GetColoredSqure("9 Hue rotate", profile.filterColors[9]),
	disable = _G.DISABLE,
	custom = _G.CUSTOM,
}
local colorOrder = {"default", "disable", 1, 2, 3, 4, 5, 6, 7, 8, 9, "custom"}
local userOrder = {"disable", 1, 2, 3, 4, 5, 6, 7, 8, 9, "custom", "remove"}

--do
--	for name, c in pairs(RAID_CLASS_COLORS) do
--		filterColors[name] = GetColoredSqure(name, {c.r, c.g, c.b})
--		tinsert(colorOrder, name)
--	end
--end

local function FilterColorDropdown_OnValueChanged(dropdown, event, key)
	HideUIPanel(ColorPickerFrame)
	local map = dropdown:GetUserData("map")
	local name = dropdown:GetUserData("id")
	local userFilter = userFilters[map]
	if not userFilter then return end

	if key == "default" then
		userFilter.color[name] = nil
	elseif key == "disable" then
		userFilter.color[name] = false
	elseif key == "custom" then
		if type(userFilter.color[name]) ~= "table" then
			local colorPicker = filterControls[name.."\\colorPicker"]
			if colorPicker then
				userFilter.color[name] = {colorPicker.r, colorPicker.g, colorPicker.b}
			else
				userFilter.color[name] = {unpack(profile.filterColors[1], 1, 3)}
			end
		end
	elseif key == "remove" then
		userFilter.color[name] = nil
		userFilter.modified = true
		if not zoneFilters[map][name] then
			options:RemoveFilterWidget(map, name)
			controls.filterGroup:DoLayout()
			return
		end
	elseif type(key) == "number" then
		userFilter.color[name] = key
	else
		return
	end
	userFilter.modified = true
	FilterColorDropdown_Refresh(dropdown)
end

local function FilterZoneDropdown_OnValueChanged(widget, event, key)
	HideUIPanel(ColorPickerFrame)
	options:RefreshFilters()
end

local function FilterColorPicker_OnValueConfirmed(colorPicker, event, r, g, b, a)
	local map = colorPicker:GetUserData("map")
	local name = colorPicker:GetUserData("id")
	local color = userFilters[map] and userFilters[map].color[name]
	if type(color) == "table" and (color[1] ~= r or color[2] ~= g or color[3] ~= b) then
		wipe(color)
		color[1] = r
		color[2] = g
		color[3] = b
		userFilters[map].modified = true
	end
end

local function FilterResetButton_OnClick(button, event)
	HideUIPanel(ColorPickerFrame)
	local map = controls.filterZoneDropdown:GetValue()
	if not map then return end
	if not userFilters[map] then
		userFilters[map] = { color = {} }
	end
	local userFilter = userFilters[map]
	wipe(userFilter.color)
	userFilter.modified = true
	options:RefreshFilters()
end

function options:CreateFiltersWidget()
	local filterTitleText = filterPanel:CreateFontString(nil, nil, "GameFontNormalLarge")
	filterTitleText:SetText(mainPanel.name.." - "..filterPanel.name)
	filterTitleText:SetPoint("TOPLEFT", filterPanel, FRAME_MARGIN, -FRAME_MARGIN)

	local checkBox = CreateCheckBox("disableDefaultFiltersCheck", "Disable all bult-in filters", nil, -210)
	checkBox.frame:SetParent(filterPanel)
	checkBox:SetPoint("TOPRIGHT", filterPanel, -FRAME_MARGIN, -FRAME_MARGIN)
	checkBox.frame:Show()

	local group = CreateGroup("filterGroup", "", filterPanel)
	group:SetPoint("TOPLEFT", filterPanel, FRAME_MARGIN, -26)
	group:SetPoint("BOTTOMRIGHT", filterPanel, -FRAME_MARGIN, FRAME_MARGIN -4)
	group.frame:Show()

	local filterZoneDropdown = GUI:Create("Dropdown")
	filterZoneDropdown.text:SetJustifyH("CENTER")
	--filterZoneDropdown:SetFullWidth(true)
	filterZoneDropdown:SetRelativeWidth(0.84)
	filterZoneDropdown:SetList(GetZoneList())
	filterZoneDropdown:SetCallback("OnValueChanged", FilterZoneDropdown_OnValueChanged)
	hooksecurefunc(filterZoneDropdown.pullout, "Open", function()
		HideUIPanel(ColorPickerFrame)
	end)
	controls.filterZoneDropdown = filterZoneDropdown
	group:AddChild(filterZoneDropdown)

	local resetButton = GUI:Create("Button") -- Reset
	resetButton:SetRelativeWidth(0.15)
	resetButton:SetText(_G.RESET)
	resetButton:SetCallback("OnClick", FilterResetButton_OnClick)
	controls.resetButton = resetButton
	group:AddChild(resetButton)

	local filterGroup = GUI:Create("ScrollFrame")
	group:AddChild(filterGroup)
	filterGroup:SetLayout("Flow")
	filterGroup:SetFullHeight(true)
	filterGroup:SetFullWidth(true)
	controls.filterGroup = filterGroup
end

function options:AddFilterWidget(map, name, zoneFilter)
	if not name then return end

	local nextWidget = filterControls.nameEdit

	local idLabel = GUI:Create("Label")
	idLabel:SetUserData("id", name)
	idLabel:SetRelativeWidth(0.13)
	idLabel:SetFontObject(GameFontNormal)
	idLabel:SetText(type(name) == "number" and name or nil)
	filterControls[name.."\\idLabel"] = idLabel
	controls.filterGroup:AddChild(idLabel, nextWidget)

	local nameLabel = GUI:Create("Label")
	nameLabel:SetUserData("id", name)
	nameLabel:SetRelativeWidth(0.52)
	nameLabel:SetFontObject(GameFontNormal)
	local text = name
	if type(name) == "number" then
		text = NpcNames[name]
	end
	nameLabel:SetText(text or _G.UNKNOWN)
	filterControls[name.."\\nameLabel"] = nameLabel
	controls.filterGroup:AddChild(nameLabel, nextWidget)

	local colorDropdown = GUI:Create("Dropdown")
	colorDropdown:SetUserData("id", name)
	colorDropdown:SetUserData("map", map)
	colorDropdown:SetRelativeWidth(0.27)
	local text
	local list, order
	if zoneFilter then
		list = {default = GetFilterDefaultText(zoneFilter, name)}
		order = colorOrder
	else
		list = {remove = _G.DELETE}
		order = userOrder
	end
	for k, v in pairs(filterColors) do
		list[k] = v
	end
	colorDropdown:SetList(list, order)
	colorDropdown:SetCallback("OnValueChanged", FilterColorDropdown_OnValueChanged)
	filterControls[name.."\\colorDropdown"] = colorDropdown
	controls.filterGroup:AddChild(colorDropdown, nextWidget)

	local footer = GUI:Create("Label")
	footer:SetUserData("id", name)
	footer:SetFullWidth(true)
	filterControls[name.."\\footer"] = footer
	controls.filterGroup:AddChild(footer, nextWidget)

	--controls.filterGroup:AddChildren(idLabel, nameLabel, colorDropdown, footer)

	FilterColorDropdown_Refresh(colorDropdown)
end

function options:AddFilterColorPicker(map, name)
	local colorPicker = GUI:Create("ColorPicker")
	colorPicker:SetUserData("id", name)
	colorPicker:SetUserData("map", map)
	colorPicker:SetRelativeWidth(0.04)
	colorPicker:SetColor(0, 0, 0)
	colorPicker:SetHasAlpha(false)
	colorPicker:SetCallback("OnValueConfirmed", FilterColorPicker_OnValueConfirmed)
	filterControls[name.."\\colorPicker"] = colorPicker
	controls.filterGroup:AddChild(colorPicker, filterControls[name.."\\footer"])
	return colorPicker
end

function options:AddFilter(map, name)
	if not map then return end
	if not name then return end
	name = tonumber(name) or name

	local zoneFilter = zoneFilters[map]
	if not zoneFilter then return end
	if zoneFilter[name] then
		return "Filter already exists: "..name
	end

	if not userFilters[map] then
		userFilters[map] = { color = {} }
	end
	local userFilter = userFilters[map]
	if userFilter.color[name] ~= nil then
		return "Filter already exists: "..name
	end
	userFilter.color[name] = false
	userFilter.modified = true
	options:AddFilterWidget(map, name)
end

local function FilterAddButton_OnClick(widget, event, ...)
	HideUIPanel(ColorPickerFrame)
	local name = filterControls.nameEdit:GetText()
	if name and name ~= "" then
		local errorMsg = options:AddFilter(controls.filterZoneDropdown:GetValue(), name)
		if errorMsg then
			filterControls.nameEdit:SetLabel(errorMsg)
		else
			filterControls.nameEdit:SetText()
			C_Timer.After(0.3, RefreshFilterNpcNames)
		end
	end
end

function options:AddFilterButton()
	local nameEdit = GUI:Create("EditBox")
	nameEdit:SetRelativeWidth(0.5)
	nameEdit:SetLabel("Enter NPC ID or Name")
	filterControls.nameEdit = nameEdit
	controls.filterGroup:AddChild(nameEdit)

	local addButton = GUI:Create("Button")
	addButton:SetRelativeWidth(0.22)
	addButton:SetText(ADD_FILTER)
	addButton:SetCallback("OnClick", FilterAddButton_OnClick)
	filterControls.addButton = addButton
	controls.filterGroup:AddChild(addButton)
end

function options:RemoveFilterWidget(map, name)
	for k, v in pairs(filterControls) do
		if k:find(name.."\\", 1, true) == 1 then
			filterControls[k] = nil
			v:Release()
			tDeleteItem(controls.filterGroup.children, v)
		end
	end
end

function options:AuraEditPanelIsShown()
	return controls.auraEditPanel and controls.auraEditPanel:IsShown()
end

function options:AuraEditPanelClose()
	if controls.auraEditPanel then
		-- controls.auraEditPanel.closebutton:Click()
		controls.auraEditPanel.frame:Hide()
	end
end

local function AuraEditOkayButton_OnClick(widget)
	local info = controls.auraEditPanel and controls.auraEditPanel:GetUserData("info")
	if not info then return end

	info.friendly = controls.auraEditReactionDropdown:GetValue() == "friendly"
	info.hostile = not info.friendly
	info.buff = controls.auraEditTypeDropdown:GetValue() == "buff"
	info.debuff = not info.buff
	info.show = controls.auraEditActionCheckShow:GetValue()
	info.hide = controls.auraEditActionCheckHide:GetValue()
	info.player = controls.auraEditYourCheck:GetValue()
	info.enlarge = controls.auraEditEnlargeCheck:GetValue()
	info.emphasize = controls.auraEditEmphasizeCheck:GetValue()

	if info.isNew then
		info.isNew = nil
		tinsert(userAuras, info)
		options:RefreshAuras(true)
	end

	options:UpdateAuraWidget(info)

	options:AuraEditPanelClose()
end

function options:CreateAuraEditWidget()
	local panel = GUI:Create("Window")
	controls.auraEditPanel = panel
	-- panel.frame:SetName("NamePlateKAIOptionsAuraEditPanel")
	_G.NamePlateKAIOptionsAuraEditFrame = panel.frame
	tinsert(_G.UISpecialFrames, "NamePlateKAIOptionsAuraEditFrame")
	_G.panel = panel

	for k, v in pairs({panel.frame:GetRegions()}) do
		if v.GetTexture and v:GetTexture() == "Interface\\Tooltips\\UI-Tooltip-Background" then
			v:SetTexture("Interface/Buttons/WHITE8X8")
			v:SetVertexColor(0.05, 0.05, 0.05, 0.85)
			break
		end
	end

	panel:ClearAllPoints()
	panel:SetParent(controls.AuraGroup)
	panel.frame:SetFrameStrata("DIALOG")
	panel:SetPoint("BOTTOM", 0, 20)
	panel:SetWidth(480)
	panel:SetHeight(320)
	panel.frame:SetMovable(false)
	panel.title:EnableMouse(false)
	panel:EnableResize(false)
	panel:SetLayout("Flow")

	panel:SetTitle(mainPanel.name.." - Edit Aura")

	local spacer = GUI:Create("Label")
	spacer:SetWidth(5)
	panel:AddChild(spacer)

	local auraEditLabel = GUI:Create("InteractiveLabel")
	controls.auraEditLabel = auraEditLabel
	auraEditLabel:SetFontObject(Game24Font)
	-- auraEditLabel:SetHeight(34)
	auraEditLabel:SetImageSize(32, 32)
	-- auraEditLabel:SetFullWidth(true)
	auraEditLabel:SetRelativeWidth(0.9)
	auraEditLabel:SetCallback("OnEnter", function()
		local info = panel:GetUserData("info")
		if info.spellID then
			GameTooltip:SetOwner(auraEditLabel.frame, "ANCHOR_TOPLEFT")
			GameTooltip:SetSpellByID(info.spellID)
		end
	end)
	auraEditLabel:SetCallback("OnLeave", function()
		GameTooltip:Hide()
	end)
	panel:AddChild(auraEditLabel)

	local mainGroup = GUI:Create("SimpleGroup")
	mainGroup:SetFullWidth(true)
	mainGroup:SetLayout("Flow")
	mainGroup:SetHeight(350)
	-- panel:AddChild(mainGroup)
	mainGroup.frame:SetParent(panel.frame)
	mainGroup:ClearAllPoints()
	mainGroup:SetPoint("TOPLEFT", 20, -62)
	mainGroup:SetPoint("BOTTOMRIGHT", -20, 18)
	mainGroup.frame:Show()

	mainGroup:AddChild(CreateHeader())

	local auraEditReactionDropdown = GUI:Create("Dropdown")
	auraEditReactionDropdown:SetLabel("Unit Reaction")
	auraEditReactionDropdown:SetRelativeWidth(0.3)
	auraEditReactionDropdown:SetList({hostile = ORANGE_FONT_COLOR:WrapTextInColorCode(_G.HOSTILE), friendly = GREEN_FONT_COLOR:WrapTextInColorCode(_G.FRIENDLY)}, {"friendly", "hostile"})
	controls.auraEditReactionDropdown = auraEditReactionDropdown
	mainGroup:AddChild(auraEditReactionDropdown)

	local auraEditTypeDropdown = GUI:Create("Dropdown")
	auraEditTypeDropdown:SetLabel("Aura Type")
	auraEditTypeDropdown:SetRelativeWidth(0.3)
	auraEditTypeDropdown:SetList({debuff = RED_FONT_COLOR:WrapTextInColorCode("Debuff"), buff = BATTLENET_FONT_COLOR:WrapTextInColorCode("Buff")}, {"buff", "debuff"})
	controls.auraEditTypeDropdown = auraEditTypeDropdown
	mainGroup:AddChild(auraEditTypeDropdown)

	mainGroup:AddChild(CreateCheckBox("auraEditYourCheck", "Your Aura", nil, 0.6))
	mainGroup:AddChild(CreateCheckBox("auraEditEnlargeCheck", "Enlarge", nil, 0.45))
	mainGroup:AddChild(CreateCheckBox("auraEditEmphasizeCheck", "Emphasize", "!Check this to display as non-transparent in background.", 0.45))

	local group = CreateGroup2("auraEditActionGroup", "Action")
	mainGroup:AddChild(group)
	local auraEditActionCheckShow = CreateCheckBox("auraEditActionCheckShow", _G.SHOW, nil, 0.45, function(widget, event, value)
		controls.auraEditActionCheckHide:SetValue(not value)
	end)
	auraEditActionCheckShow:SetType("radio")
	group:AddChild(auraEditActionCheckShow)
	local auraEditActionCheckHide = CreateCheckBox("auraEditActionCheckHide", _G.HIDE, nil, 0.45, function(widget, event, value)
		controls.auraEditActionCheckShow:SetValue(not value)
	end)
	auraEditActionCheckHide:SetType("radio")
	group:AddChild(auraEditActionCheckHide)

	local auraEditCancelButton = GUI:Create("Button")
	auraEditCancelButton.frame:SetParent(mainGroup.frame)
	auraEditCancelButton:SetWidth(110)
	auraEditCancelButton.frame:SetHeight(20)
	auraEditCancelButton:SetPoint("BOTTOMRIGHT")
	auraEditCancelButton:SetText(_G.CANCEL)
	auraEditCancelButton:SetCallback("OnClick", function()
		options:AuraEditPanelClose()
	end)
	auraEditCancelButton.frame:Show()

	local auraEditOkayButton = GUI:Create("Button")
	auraEditOkayButton.frame:SetParent(mainGroup.frame)
	auraEditOkayButton:SetWidth(110)
	auraEditOkayButton.frame:SetHeight(20)
	auraEditOkayButton:SetPoint("RIGHT", auraEditCancelButton.frame, "LEFT", -5, 0)
	auraEditOkayButton:SetText(_G.OKAY)
	auraEditOkayButton:SetCallback("OnClick", AuraEditOkayButton_OnClick)
	auraEditOkayButton.frame:Show()

	return panel
end

function options:ShowAuraEditPanel(info)
	if not info or not info.spellID then return end
	local panel = controls.auraEditPanel or options:CreateAuraEditWidget()

	panel:SetUserData("info", info)
	controls.auraEditLabel:SetText((GetSpellInfo(info.spellID)))
	controls.auraEditLabel:SetImage((GetSpellTexture(info.spellID)))
	controls.auraEditReactionDropdown:SetValue(info.friendly and "friendly" or "hostile")
	controls.auraEditTypeDropdown:SetValue(info.buff and "buff" or "debuff")
	controls.auraEditActionCheckShow:SetValue(not info.hide)
	controls.auraEditActionCheckHide:SetValue(info.hide)
	controls.auraEditYourCheck:SetValue(info.player)
	controls.auraEditEnlargeCheck:SetValue(info.enlarge)
	controls.auraEditEmphasizeCheck:SetValue(info.emphasize)
	panel:Show()
end

local function AuraAddButton_OnClick(widget, event, ...)
	if options:AuraEditPanelIsShown() then return end
	local text = controls.auraSpellEdit:GetText()
	if not text or #text == 0 then return end
	local spellID = text and tonumber(text) or nil
	spellID = select(7, GetSpellInfo(spellID or text or 0)) or addon.UnitAuraID("player", text, true) or addon.UnitAuraID("target", text, true)
	if not spellID then
		controls.auraInfoLabel:SetText(NORMAL_FONT_COLOR_CODE.." Unknown Spell: "..FONT_COLOR_CODE_CLOSE..text)
		return
	end
	controls.auraInfoLabel:SetText()
	controls.auraSpellEdit:SetText()

	local info = {isNew = true}
	info.spellID = spellID
	info.player = true
	local unit
	unit = addon.UnitAuraID("target", text) and "target" or addon.UnitAuraID("player", text) and "player"
	info.buff = unit and true
	unit = unit or addon.UnitAuraID("target", text, "HARMFUL") and "target" or addon.UnitAuraID("player", text, "HARMFUL") and "player"
	info.friendly = unit == "player" and true or unit == "target" and UnitIsFriend("player", "target")

	options:ShowAuraEditPanel(info)
end

local function AuraNameLabel_OnClick(widget)
	-- _G.nameLabel = widget
	if options:AuraEditPanelIsShown() then return end
	local info = widget:GetUserData("info")
	if info.deleteThis then return end
	options:ShowAuraEditPanel(info)
end

local function AuraDeleteIcon_OnClick(widget)
	if options:AuraEditPanelIsShown() then return end
	local info = widget:GetUserData("info")
	info.deleteThis = not info.deleteThis
	options:UpdateAuraWidget(info)
end

local function GetDisabledColor(disabled)
	return (disabled and _G.DISABLED_FONT_COLOR or _G.HIGHLIGHT_FONT_COLOR):GetRGB()
end

local function WidgetSetDisabled(widget, disabled)
	if widget.type == "InteractiveLabel" then
		widget.image:SetDesaturated(disabled)
		widget.image:SetVertexColor(GetDisabledColor(disabled))
	elseif widget.type == "Icon" then
		widget.image:SetDesaturated(disabled)
	end
	if widget.type == "InteractiveLabel" or widget.type == "Label" then
		widget:SetColor(GetDisabledColor(disabled))
		if widget.SetDisabled then
			widget:SetDisabled(disabled)
		end
	end
end

local function SetRightLabel(parent)
	local label = tremove(auraPanel.labelPool)
	if not label then
		label = auraPanel:CreateFontString()
		label:SetFontObject(GameFontNormal)
		label:SetJustifyH("LEFT")
	end
	label:SetParent(parent.frame)
	label:ClearAllPoints()
	label:SetPoint("TOPRIGHT", parent.label, 0, 0)
	label:SetPoint("BOTTOMRIGHT", parent.label, 0, 0)
	label:SetWidth(200)
	label:SetTextColor(parent.label:GetTextColor())
	label:Show()
	parent:SetUserData("rightLabel", label)
	return label
end

local function ReleaseRightLabel(parent)
	local label = parent:GetUserData("rightLabel")
	if not label then return end
	parent:SetUserData("rightLabel", nil)
	label:SetParent(auraPanel)
	label:SetText()
	label:Hide()
	tinsert(auraPanel.labelPool, label)
end

local function ColorText(fontColor, text)
	return _G[fontColor.."_FONT_COLOR"]:WrapTextInColorCode(text)
end

function options:UpdateAuraWidget(info)
	local disabled = info.deleteThis
	WidgetSetDisabled(auraControls[info.index.."\\idLabel"], disabled)
	WidgetSetDisabled(auraControls[info.index.."\\spellIcon"], disabled)
	local nameLabel = auraControls[info.index.."\\nameLabel"]
	WidgetSetDisabled(nameLabel, disabled)
	nameLabel:SetText(GetSpellInfo(info.spellID) or _G.UNKNOWN)
	local spellIcon = auraControls[info.index.."\\spellIcon"]
	spellIcon:SetImage(GetSpellTexture(info.spellID))
	local rightLabel = nameLabel:GetUserData("rightLabel")
	rightLabel:SetText("hogeHOGE"..info.spellID)
	local reaction = info.friendly and ColorText("GREEN", _G.FRIENDLY) or ColorText("ORANGE", _G.HOSTILE)
	local auraType = info.buff and ColorText("BATTLENET", "Buff") or ColorText("RED", "Debuff")
	local text = reaction.."  "..auraType
	if info.hide or not info.show then
		text = text.."  "..ColorText("TRANSMOGRIFY", _G.HIDE)
	end
	rightLabel:SetTextColor(GetDisabledColor(disabled))
	rightLabel:SetText(disabled and text:gsub("|c%x%x%x%x%x%x%x%x(.-)|r", "%1") or text)
	WidgetSetDisabled(auraControls[info.index.."\\deleteIcon"], disabled)
end

function options:AddAuraWidget(info)
	if not info then return end

	local idLabel = GUI:Create("Label")
	idLabel:SetUserData("info", info)
	idLabel:SetRelativeWidth(0.11)
	-- idLabel:SetFontObject(GameFontNormal)
	idLabel:SetText(info.spellID.."    ")
	idLabel.label:SetJustifyH("RIGHT")
	auraControls[info.index.."\\idLabel"] = idLabel
	controls.auraGroup:AddChild(idLabel)

	local spellIcon = GUI:Create("Icon")
	spellIcon:SetUserData("info", info)
	spellIcon:SetRelativeWidth(0.045)
	-- spellIcon:SetWidth(22)
	spellIcon:SetImage(130775)
	spellIcon:SetImageSize(20, 20)
	-- spellIcon.highlight:SetAlpha(0)
	-- deleteIcon:SetFontObject(GameFontNormal)
	-- deleteIcon:SetText("|T130775:0:0|t ")
	spellIcon:SetCallback("OnClick", AuraNameLabel_OnClick)
	spellIcon.frame:EnableMouse(false)
	auraControls[info.index.."\\spellIcon"] = spellIcon
	controls.auraGroup:AddChild(spellIcon)

	local nameLabel = GUI:Create("InteractiveLabel")
	nameLabel:SetUserData("info", info)
	nameLabel:SetRelativeWidth(0.78)
	nameLabel:SetFontObject(GameFontNormal)
	nameLabel:SetHighlight(136809)
	nameLabel.highlight:SetVertexColor(0.196, 0.388, 0.8, 0.7)
	nameLabel:SetCallback("OnClick", AuraNameLabel_OnClick)
	auraControls[info.index.."\\nameLabel"] = nameLabel
	SetRightLabel(nameLabel)
	controls.auraGroup:AddChild(nameLabel)

	-- local typeLabel = GUI:Create("InteractiveLabel")
	-- typeLabel:SetUserData("info", info)
	-- typeLabel:SetRelativeWidth(0.3)
	-- typeLabel:SetFontObject(GameFontNormal)
	-- typeLabel.label:SetJustifyH("CENTER")
	-- typeLabel:SetHighlight(136809)
	-- typeLabel.highlight:SetVertexColor(0.196, 0.388, 0.8, 0.7)
	-- typeLabel:SetCallback("OnClick", AuraTypeLabel_OnClick)
	-- auraControls[info.index.."\\typeLabel"] = typeLabel
	-- controls.auraGroup:AddChild(typeLabel)

	local deleteIcon = GUI:Create("Icon")
	deleteIcon:SetUserData("info", info)
	deleteIcon:SetRelativeWidth(0.045)
	-- deleteIcon:SetWidth(22)
	deleteIcon:SetImage(130775)
	deleteIcon:SetImageSize(20, 20)
	-- deleteIcon:SetFontObject(GameFontNormal)
	-- deleteIcon:SetText("|T130775:0:0|t ")
	deleteIcon:SetCallback("OnClick", AuraDeleteIcon_OnClick)
	auraControls[info.index.."\\deleteIcon"] = deleteIcon
	controls.auraGroup:AddChild(deleteIcon)

	local footer = GUI:Create("Label")
	footer:SetUserData("info", info)
	footer:SetFullWidth(true)
	auraControls[info.index.."\\footer"] = footer
	controls.auraGroup:AddChild(footer)

	options:UpdateAuraWidget(info)
end

function options:SaveUserAuras()
	if not _G.NamePlateKAIAura then
		_G.NamePlateKAIAura = {}
	end
	local db = wipe(_G.NamePlateKAIAura)

	local info
	for i, info in ipairs(userAuras) do
		info.index = nil
		if not info.deleteThis then
			-- info.deleteThis = nil
			for k, v in pairs(info) do
				if not v then
					info[k] = nil
				end
			end
			tinsert(db, CopyTable(info))
		end
	end

	if not next(db) then
		_G.NamePlateKAIAura = nil
	end
end

function options:ReleaseAuraWidget()
	for k, widget in pairs(auraControls) do
		if widget.type == "Icon" then
			-- widget.highlight:SetAlpha(1)
			widget.frame:EnableMouse(true)
		elseif widget.type == "InteractiveLabel" then
			if widget.highlight then
				widget.highlight:SetVertexColor(1, 1, 1, 1)
			end
			if widget.image then
				widget.image:SetDesaturated(false)
				widget.image:SetVertexColor(1, 1, 1)
				widget.image:SetAlpha(1)
			end
			if widget.label then
				widget.label:SetJustifyH("LEFT")
				ReleaseRightLabel(widget)
			end
		elseif widget.type == "Label" then
			if widget.label then
				widget.label:SetJustifyH("LEFT")
			end
		end
	end
	controls.auraGroup:ReleaseChildren()
	wipe(auraControls)
end

function options:ClearUserAuras()
	for k, v in pairs(userAuras) do
		wipe(v)
	end
	wipe(userAuras)
	options:ReleaseAuraWidget()
end

local function LoadUserAuras()
	local db = _G.NamePlateKAIAura
	if not db then return end
	for i, info in ipairs(db) do
		if type(info.spellID) == "number" then
			tinsert(userAuras, CopyTable(info))
		end
	end
end

function options:RefreshAuras(noLoad)
	if noLoad then
		options:ReleaseAuraWidget()
	else
		options:ClearUserAuras()
		LoadUserAuras()
	end

	controls.auraGroup:PauseLayout()

	table.sort(userAuras, addon:GetAuraCompareFunc())
	for i, info in ipairs(userAuras) do
		info.index = i
		options:AddAuraWidget(info)
	end

	local dummyLabel = GUI:Create("Label")
	dummyLabel:SetRelativeWidth(0.11)
	-- dummyLabel:SetFontObject(GameFontNormal)
	dummyLabel:SetText(" ")
	auraControls["dummyLabel"] = dummyLabel
	controls.auraGroup:AddChild(dummyLabel)

	controls.auraGroup:ResumeLayout()
	controls.auraGroup:DoLayout()

end

auraPanel:SetScript("OnHide", function()
	options:AuraEditPanelClose()
end)

function options:CreateAurasWidget()
	local auraTitleText = auraPanel:CreateFontString(nil, nil, "GameFontNormalLarge")
	auraTitleText:SetText(mainPanel.name.." - "..auraPanel.name)
	auraTitleText:SetPoint("TOPLEFT", auraPanel, FRAME_MARGIN, -FRAME_MARGIN)

	local aurasGroup = CreateGroup("aurasGroup", "", auraPanel)
	aurasGroup:SetPoint("TOPLEFT", auraPanel, FRAME_MARGIN, -26)
	aurasGroup:SetPoint("TOPRIGHT", auraPanel, -FRAME_MARGIN, -26)
	aurasGroup:AddChild(CreateCheckBox("showDebuffCheck", "Enemy Auras", nil, 0.45))
	aurasGroup:AddChild(CreateCheckBox("showBuffCheck", "Friendly Auras", nil, 0.45))
	aurasGroup:AddChild(CreateCheckBox("showCountdownCheck", "Countdown Numbers", nil, 0.45))
	aurasGroup:AddChild(CreateCheckBox("disableOmniccCheck", "Disable OmniCC", nil, 0.45))
	aurasGroup:AddChild(CreateCheckBox("showMagicCheck", "Always show the magic", nil, 0.45))
	aurasGroup:AddChild(CreateCheckBox("showEnrageCheck", "Always show the enrage", "!This effective only with Boss or Elite", 0.45))
	aurasGroup:AddChild(CreateSlider("auraHeightSlider", "Icon Height", 8, 30, 1))
	aurasGroup:AddChild(CreateSlider("auraBorderSlider", "Border Width", 1, 3, 0.5))

	aurasGroup.frame:Show()

	local group = CreateGroup("AuraGroup", _G.FILTERS, auraPanel)
	group:SetPoint("TOPLEFT", aurasGroup.frame, "BOTTOMLEFT", 0, -2)
	group:SetPoint("BOTTOMRIGHT", auraPanel, -FRAME_MARGIN, FRAME_MARGIN -4)
	group.frame:Show()

	local spellEdit = GUI:Create("EditBox")
	spellEdit:SetRelativeWidth(0.35)
	spellEdit:SetLabel("Enter Spell ID or Name")
	controls.auraSpellEdit = spellEdit
	group:AddChild(spellEdit)

	local addButton = GUI:Create("Button")
	addButton:SetRelativeWidth(0.15)
	-- addButton.frame:SetHeight(20)
	addButton:SetText(_G.ADD)
	addButton:SetCallback("OnClick", AuraAddButton_OnClick)
	controls.auraAddButton = addButton
	group:AddChild(addButton)

	local infoLabel = GUI:Create("Label")
	infoLabel:SetRelativeWidth(0.45)
	infoLabel:SetText()
	controls.auraInfoLabel = infoLabel
	group:AddChild(infoLabel)

	group:AddChild(CreateHeader())

	local auraGroup = GUI:Create("ScrollFrame")
	group:AddChild(auraGroup)
	auraGroup:SetLayout("Flow")
	auraGroup:SetFullHeight(true)
	auraGroup:SetFullWidth(true)
	controls.auraGroup = auraGroup

end

mainPanel.OnCommit = mainPanel.okay
mainPanel.OnDefault = mainPanel.default
mainPanel.OnRefresh = mainPanel.refresh
if not mainPanel:GetParent() then
	 mainPanel.category = InterfaceOptions_AddCategory(mainPanel)
end

auraPanel.category = InterfaceOptions_AddCategory(auraPanel)
filterPanel.category = InterfaceOptions_AddCategory(filterPanel)

mainPanel:refresh()
auraPanel:Hide()
filterPanel:Hide()
C_Timer.After(0.5, auraPanel.refresh)
C_Timer.After(0.5, filterPanel.refresh)

if _G.SettingsPanel.AddOnsTab.selected then
	mainPanel.category.expanded = true
	_G.SettingsPanel.CategoryList:CreateCategories()
end
