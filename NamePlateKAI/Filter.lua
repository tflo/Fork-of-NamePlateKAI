local addon = select(2, ...)
local db = addon.defaultFilters

addon.MapAreaID = {
	[807]=1114,[616]=995,[903]=1178,[712]=1045,[808]=1114,[617]=995,[453]=885,[713]=1046,[777]=1094,[809]=1115,[618]=995,[778]=1094,[810]=1115,[438]=875,[454]=885,[779]=1094,[556]=953,[620]=1008,
	[780]=1094,[812]=1115,[621]=1008,[455]=885,[471]=896,[749]=1079,[781]=1094,[813]=1115,[845]=1146,[909]=1188,[782]=1094,[814]=1115,[846]=1146,[440]=876,[910]=1188,[472]=896,[751]=1081,[783]=1094,
	[560]=953,[847]=1146,[911]=1188,[752]=1081,[784]=1094,[561]=953,[848]=1146,[441]=876,[912]=1188,[473]=896,[753]=1081,[785]=1094,[817]=1115,[849]=1146,[913]=1188,[754]=1081,[786]=1094,[818]=1115,
	[850]=1147,[442]=876,[914]=1188,[474]=897,[755]=1081,[787]=1094,[819]=1115,[596]=988,[915]=1188,[756]=1081,[788]=1094,[820]=1115,[597]=988,[443]=877,[661]=1026,[475]=897,[789]=1094,[821]=1115,
	[598]=988,[662]=1026,[822]=1115,[854]=1147,[444]=877,[918]=1188,[476]=898,[508]=930,[568]=953,[855]=1147,[919]=1188,[569]=953,[856]=1147,[445]=877,[665]=1026,[477]=898,[761]=1087,[570]=953,
	[602]=989,[666]=1026,[762]=1087,[430]=867,[446]=877,[667]=1026,[478]=898,[731]=1065,[763]=1087,[668]=1026,[732]=1066,[764]=1088,[573]=964,[431]=871,[669]=1026,[479]=898,[733]=1067,[765]=1088,
	[574]=969,[606]=993,[670]=1026,[766]=1088,[575]=969,[432]=871,[703]=1041,[509]=930,[767]=1088,[510]=930,[576]=969,[608]=993,[511]=930,[515]=930,[704]=1041,[558]=953,[768]=1088,[559]=953,[563]=953,
	[609]=993,[567]=953,[595]=987,[705]=1041,[615]=994,[769]=1088,[663]=1026,[458]=887,[610]=994,[565]=953,[457]=887,[706]=1042,[920]=1188,[770]=1088,[459]=887,[917]=1188,[611]=994,[811]=1115,
	[916]=1188,[707]=1042,[815]=1115,[771]=1088,[456]=886,[437]=875,[612]=994,[514]=930,[599]=988,[708]=1042,[607]=993,[772]=1088,[816]=1115,[512]=930,[613]=994,[429]=867,[439]=876,[600]=988,[513]=930,
	[664]=1026,[564]=953,[593]=984,[614]=994,[601]=989,[435]=874,[710]=1045,[851]=1147,[562]=953,[806]=1114,[853]=1147,[436]=874,[852]=1147,[557]=953,[711]=1045,[566]=953,
}

db.default = { zone = _G.DEFAULT,
	category = 0,
	-- 0x0001: hide Name
	-- 0x0002: hide Auras
	-- 0x0004: ignore Threat
	-- 0x0008: hide Cast Bar
	-- 0x0010: ignore Alpha
	-- 0x0020: dungeon boss
	-- 0x0040: target aggro
	-- 0x0080: no trivial
	-- 0x0800: show Power Bar
	-- flags = {
	-- 	["*"] = {
	-- 		[103832] = 0x0001,
	-- 		[107025] = 0x0800 + 0x0001 + 0x3000,
	-- 		[113966] = 0x0002,
	-- 		[113964] = 0x0008 + 0x0001,
	-- 		[38926] = 0x3800,
	-- 	},
	-- },
	flags = {
		["*"] = {
			[161846] = 0x0020 + 0x0040, -- Maw Assassin
			[161849] = 0x0020 + 0x0040, -- Maw Assassin
			[161854] = 0x0020 + 0x0040, -- Maw Assassin
			[161855] = 0x0020 + 0x0040, -- Maw Assassin
			[161856] = 0x0020 + 0x0040, -- Maw Assassin
			[176258] = 0x0020 + 0x0040, -- Slavering Devourer
		}
	},
	recolor = {
		-- [173138] = 3, -- Mawsworn Outrider
		-- [174568] = 9, -- dummy
		[201339] = 6, -- Stone Pylon
	},
}

local function CheckMasquerade()
	return addon.UnitAuraID("player", GetSpellInfo(202477), "HELPFUL")
end

db.global = { zone = "Global",
	order = {
		"h\\"..C_ChallengeMode.GetAffixInfo(13), 120651,
		-- "h\\"..C_ChallengeMode.GetAffixInfo(16), 141851,
		-- "h\\"..C_ChallengeMode.GetAffixInfo(117), 148716, 148893, 148894,
		-- "h\\"..C_ChallengeMode.GetAffixInfo(119), 155432, 155433, 155434,
		-- "h\\"..C_ChallengeMode.GetAffixInfo(120), 161502, 161408, 161510, 161437,
		"h\\"..C_ChallengeMode.GetAffixInfo(123), 174773,
		-- "h\\"..C_ChallengeMode.GetAffixInfo(121), 173729,
		-- "h\\"..C_ChallengeMode.GetAffixInfo(128), 179446, 179890, 179891, 179892,
		"h\\"..C_ChallengeMode.GetAffixInfo(131), 189878, 190128, 190174,

		-- Dragonflight season2
		"h\\"..C_ChallengeMode.GetAffixInfo(135), 204773,
	},
	recolor = {
		-- Fated Raid
		-- [189706] = 9, -- Chaotic Essence
		-- [188302] = 9, -- Reconfiguration Emitter
		-- [188703] = 9, -- Protoform Barrier
		-- [189707] = 7, -- Chaotic Mote
	},
	Challenge = {
		flags = {
			["*"] = {
				[120651] = 0x0014,
				[141851] = 0x0014,
				[155432] = 0x0020 + 0x0014 + 0x4800,
				[155433] = 0x0020 + 0x0014,
				[155434] = 0x0020,
				[174773] = 0x0040,
				[173729] = 0x0020,
				[190128] = 0x0020,
			},
		},
		recolor = {
			[120651] = {1, 0, 0.75, 1}, -- Explosives
			-- [141851] = {1, 0, 0.75, 1}, -- Spawn of G'huun
			-- [148716] = {0.7, 0.7, 0.6}, -- Risen Soul
			-- [148893] = "DEATHKNIGHT", -- Tormented Soul
			-- [148894] = {0.35, 1, 0.9}, -- Lost Soul
			-- [155432] = "DEATHKNIGHT", -- Enchanted Emissary
			-- [155433] = "DEATHKNIGHT", -- Void-Touched Emissary
			-- [155434] = "DEATHKNIGHT", -- Emissary of the Tides
			-- [161502] = 1, -- Ravenous Fleshfiend
			-- [161408] = 6, -- Malicious Growth
			-- [161510] = 1, -- Mindrend Tentacle
			-- [161437] = "DRUID", -- Explosive Scarab
			[174773] = {1, 0, 0.75, 1}, -- Spiteful Shade
			-- [173729] = "DEATHKNIGHT", -- Manifestation of Pride
			-- [179446] = "DEATHKNIGHT", -- Incinerator Arkolath
			-- [179892] = "DEATHKNIGHT", -- Oros Coldheart
			-- [179890] = "DEATHKNIGHT", -- Executioner Varruth
			-- [179891] = "DEATHKNIGHT", -- Soggodon the Breaker
			-- [185680] = "DEATHKNIGHT", -- Vy Relic
			-- [184908] = "DEATHKNIGHT", -- Vy Interceptor
			-- [185683] = "DEATHKNIGHT", -- Wo Relic
			-- [184910] = "DEATHKNIGHT", -- Wo Drifter
			-- [185685] = "DEATHKNIGHT", -- Urh Relic
			-- [184911] = "DEATHKNIGHT", -- Urh Dismantler
			[189878] = 9, -- Nathrezim Infiltrator
			[190128] = 9, -- Zul'gamux
			[190174] = 9, -- Hypnosis Bat
			[204773] = 9, -- Afflicted Soul
			[204560] = 9, -- Incorporeal Being
		},
	},
	auras = {
		{id = "i1220:203761", spellID = 203761, buff = true, r = 0.5, g = 0.1, b = 0, zoneInstanceID = 1220, activateFunc = CheckMasquerade}, -- Masquerade Detector
		{id = "i1220:213486", spellID = 213486, buff = true, r = 0.5, g = 0.1, b = 0, zoneInstanceID = 1220, activateFunc = CheckMasquerade}, -- Masquerade Demonic Vision
		{id = "global:277242", spellID = 277242, buff = true, enlarge = true, emphasize = true, r = 0.85, g = 1, b = 0, affixID = 16}, -- Symbiosis
		{id = "global:226510", spellID = 226510, buff = true, enlarge = false, emphasize = true, r = 1, g = 0.25, b = 0.85, affixID = 8}, -- Ichor sanguin
		-- {id = "global:302417", spellID = 302417, buff = true, enlarge = false, emphasize = true, r = 1, g = 1, b = 0.85, affixID = 119}, -- Queen's Decree: Unstoppable (Emissary of the Tides)
		-- {id = "global:290027", spellID = 290027, buff = true, enlarge = false, emphasize = true, color = 4, affixID = 119}, -- Queen's Decree: Blowback
		{id = "global:290026", spellID = 290026, buff = true, enlarge = false, emphasize = false, color = 4, affixID = 119}, -- Queen's Decree: Blowback
		{id = "global:343502", spellID = 343502, buff = true, enlarge = false, emphasize = true, r = 0.73, g = 1, b = 0, affixID = 122}, -- Inspiring Presence
		{id = "global:373011", spellID = 373011, buff = true, enlarge = false, emphasize = true, color = 1, affixID = 131}, -- Disguised
		{id = "global:373785", spellID = 373785, buff = true, enlarge = false, emphasize = true, color = 4, affixID = 131}, -- Disguised (Named)
	},
}

--[[
db["map213"] = { zone = 226, -- Ragefire Chasm
	category = 101,
	flags = {
		["*"] = {
			[61658] = 0x0040,
		},
	},
	recolor = {
		["-694"] = 4,
		[61724] = "WARRIOR", -- Commander Bagran
		["Adolescent Flame Hound"] = 2,
		[61658] = 4,
	},
	Heroic = {
		--noInherit = true,
		recolor = {
			["Adolescent Flame Hound"] = 2,
			[61658] = 1,
		},
	},
}
--]]

-------------------------------------------------------------------------------
-- Mists of Pandaria
-------------------------------------------------------------------------------
db[867] = { zone = 313, -- Temple of the Jade Serpent
	category = 501,
	order = {
		"h\\672", 200126, 62358, 59873, -- Wise Mari
		"h\\664", 59555, 59547, 65317, 59546, 59553, 59552, -- Lorewalker Stonestep
		"h\\658", 200387, 200388, 200137, 200131, 57109, 58319, -- Liu Flameheart
		"h\\335", 56792, -- Sha of Doubt
	},
	flags = {
		["*"] = {
			[56448] = 0x0020,
			[59051] = 0x0020,
			[59726] = 0x0020,
			[56732] = 0x0020,
			[56762] = 0x0020,
			[56439] = 0x0020,
		},
	},
	recolor = {
		[62358] = 7, -- Corrupt Droplet
		[59873] = 2, -- Corrupt Living Water
		-- [200126] = "SHAMAN", -- Fallen Waterspeaker

		[59555] = "PRIEST", -- Haunting Sha
		[59547] = "MONK", -- Jiang
		[65317] = "MONK", -- Xiang
		[59546] = 1, -- The Talking Fish
		[59553] = "DRUID", -- The Songbird Queen
		[59552] = "WARRIOR", -- The Crybaby Hozen

		[200387] = 1, -- Shambling Infester
		[200388] = "DEMONHUNTER", -- Malformed Sha
		[200137] = "WARLOCK", -- Depraved Mistweaver
		-- [200131] = "MONK", -- Sha-Touched Guardian
		[57109] = 2, -- Minion of Doubt
		[58319] = "DEMONHUNTER", -- Lesser Sha

		[56792] = 1, -- Figment of Doubt
	},
	auras = {
		{id = "867:113315", spellID = 113315, buff = true, enlarge = true, emphasize = true, color = 4}, -- Intensity
	},

}

db[871] = { zone = 311, -- Scarlet Halls
	category = 502,
	Heroic = {
		noInherit = true,
		recolor = {
			[59372] = 2, -- Scarlet Scholar
			[58756] = "MAGE", -- Scarlet Evoker
			[58685] = "PRIEST", -- Scarlet Evangelist
		},
	},
}

db[874] = { zone = 316, -- Scarlet Monastery
	category = 503,
	Heroic = {
		noInherit = true,
		recolor = {
			[59722] = 1, -- Pile of Corpses
			[60033] = 2, -- Frenzied Spirit
			[59884] = 1, -- Fallen Crusader
			[59974] = 3, -- Evicted Soul
			[58569] = "MAGE", -- Scarlet Purifier
			[58590] = "PRIEST", -- Scarlet Zealot
		},
	},
}

db[875] = { zone = 303, -- Gate of the Setting Sun
	category = 504,
	Heroic = {
		noInherit = true,
		recolor = {
			[59801] = 1, -- Krik'thik Wind Shaper
			[56875] = 2, -- Krik'thik Demolisher
			[59800] = 2, -- Krik'thik Rager
		},
	},
}

db[876] = { zone = 302, -- Stormstout Brewery
	category = 505,
	recolor = {
		["5647"] = 1, -- Bopper
		["5645"] = 3, -- Hopper
		["5654"] = 3, -- Yeasty Brew Alemental
		[59684] = 5, -- Hozen Party Animal
		[57097] = 5, -- Hozen Party Animal
		[56927] = 5, -- Hozen Party Animal
	},
}

db[877] = { zone = 312, -- Shado-pan Monastery
	category = 506,
	recolor = {
		[59751] = 2, -- Shado-Pan Warden
		[56765] = 2, -- Destroying Sha
		[66652] = 1, -- Lesser Volatile Energy
		[58812] = 1, -- Hateful Essence
		[59804] = 3, -- Gripping Hatred
	},
}

db[885] = { zone = 321, -- Mogu'Shan Palace
	category = 507,
	Heroic = {
		noInherit = true,
		recolor = {
			[61946] = 1, -- Harthak Stormcaller
			[61240] = 1, -- Glintrok Skulker
			[61338] = 1, -- Glintrok Skulker
			[61337] = 2, -- Glintrok Ironhide
			[61242] = 2, -- Glintrok Ironhide
			[61339] = 3, -- Glintrok Oracle
			[61239] = 3, -- Glintrok Oracle
			[61392] = 1, -- Harthak Flameseeker
		},
	},
}

db[887] = { zone = 324, -- Siege of Niuzao Temple
	category = 508,
	Heroic = {
		noInherit = true,
		recolor = {
		},
	},
}

db[898] = { zone = 246, -- Scholomance
	category = 509,
	Heroic = {
		noInherit = true,
		recolor = {
			[58822] = 2, -- Risen Guard
			[59359] = 1, -- Flesh Horror
			[59078] = 3, -- Failed Student
			[59503] = 5, -- Brittle Skeleton
			[59480] = 5, -- Brittle Skeleton
		},
	},
}

db[896] = { zone = 317, -- Mogu'shan Vaults
	category = 551,
	recolor = {
		-- The Stone Guard
		["5691"] = "WARLOCK", -- Amethyst Guardian
		["5771"] = "SHAMAN", -- Cobalt Guardian
		["5773"] = "MONK", -- Jade Guardian
		["5774"] = "DEATHKNIGHT", -- Jasper Guardian
		-- Gara'jal the Spiritbinder
		["5742"] = 1, -- Spirit Totem
		["5757"] = 3, -- Severer of Souls
		-- The Spirit Kings
		["5861"] = 1, -- Pinning Arrow
		["5853"] = 2, -- Undying Shadows
		-- Elegon
		["6189"] = 1, -- Energy Charge
		["7074"] = 2, -- Soul Fragment
		-- Will of the Emperor
		["5677"] = 2, -- Emperor's Strength
		["5674"] = 3, -- Titan Spark
	},
}

db[897] = { zone = 330, -- Heart of Fear
	category = 552,
	recolor = {
		-- Wind Lord Mel'jarak
		["6305"] = 1, -- Mender
		["6334"] = 2, -- Blademaster
		["6300"] = 3, -- Trapper
		-- Amber-Shaper Un'sok
		["6261"] = 1, -- Living Amber
		-- Grand Empress Shek'zeer
		["6325"] = 1, -- Dissonance Field
		["6480"] = 2, -- Kor'thik Reaver
		[64383] = 3, -- Bubbling Resin
	},
}

db[886] = { zone = 320, -- Terrace of Endless Spring
	category = 553,
	recolor = {
		-- Tsulong
		[64393] = 2, -- Night Terror
		-- Lei Shi
		["6224"] = 1, -- Animated Protector
	},
}

db[930] = { zone = 362, -- Throne of Thunder
	category = 554,
	recolor = {
		-- Horridon
		["7866"] = 4, -- Direhorn Spirit
		["7086"] = 1, -- Zandalari Dinomancer
		["7107"] = 1, -- Amani'shi Beast Shaman
		["7098"] = 2, -- Farraki Wastewalker
		["7100"] = 2, -- Gurubashi Venom Priest
		["7113"] = 2, -- Venomous Effusion
		["7103"] = 2, -- Drakkari Frozen Warlord
		["7105"] = 3, -- Amani'shi Flame Caster
		["7106"] = 2, -- Amani Warbear
		["7101"] = 3, -- Risen Drakkari Warrior
		["7102"] = 3, -- Risen Drakkari Champion
		-- Tortos
		["7129"] = 2, -- Whirl Turtle
		[69639] = 3, -- Humming Crystal
		-- Council of Elders
		["7072"] = 2, -- Shadowed Loa Spirit
		["7070"] = 2, -- Blessed Loa Spirit
		["7066"] = 1, -- Living Sand
		-- Ji-Kun
		[68194] = 3, -- Young Egg of Ji-Kun
		[70134] = 2, -- Nest Guardian
	},
}

db[953] = { zone = 369, -- Siege of Orgrimmar
	category = 555,
	recolor = {
		-- The Fallen Protectors
		["7885"] = "MONK", -- Rook Stonetoe
		["8395"] = 2, -- Embodied Misery
		["8396"] = 3, -- Embodied Sorrow
		["8397"] = 3, -- Embodied Gloom
		["7889"] = "ROGUE", -- He Softfoot
		[71478] = 4, -- Embodied Anguish
		["7904"] = "PRIEST", -- Sun Tenderheart
		[71482] = 3, -- Embodied Desperation
		--[71712] = 1,
		-- Norushen
		["8232"] = 2, -- Manifestation of Corruption
		-- Sha of Pride
		["8262"] = 1, -- Manifestation of Pride
		[72569] = 3, -- Corrupted Fragment
		-- Galakras
		["8422"] = 2, -- Master Cannoneer Dagryn
		["8423"] = 2, -- Liutenant General Krugruk
		["8424"] = 2, -- High Enforcer Thranok
		["8425"] = 2, -- Korgra the Snake
		["8428"] = 1, -- Dragonmaw Bonecrusher
		["8431"] = 3, -- Dragonmaw Tidal Shaman
		["8489"] = {1, 1, 1, 1}, -- Healing Tide Totem
		[73310] = {0.72, 1, 0, 1}, -- Dragonmaw War Banner
		[73088] = {0.72, 1, 0, 1}, -- Dragonmaw War Banner
		-- Kor'kron Dark Shaman
		["8143"] = 3, -- Iron Tomb
		-- General Nazgrim
		["7922"] = "WARRIOR", -- Kor'kron Ironblade
		["7923"] = "MAGE", -- Kor'kron Arcweaver
		["7924"] = "ROGUE", -- Kor'kron Assassin
		["7925"] = "SHAMAN", -- Kor'kron Warshaman
		["7946"] = "HUNTER", -- Kor'kron Sniper
		["7912"] = {0.72, 1, 0, 1}, -- Kor'kron Banner
		-- Malkorok
		["7952"] = 3,
		-- Spoils of Pandaria
		["8462"] = 2, -- Jun-Wei
		["8460"] = 2, -- Zu Yin
		["8461"] = 2, -- Xiang-Lin
		["8464"] = 2, -- Kun-Da
		[73951] = 2, -- Commander Tik
		[73948] = 2, -- Commander Ik'tal
		[73949] = 2, -- Commander Na'kaz
		[71409] = 2, -- Commander Zak'tar
		[71392] = "WARLOCK", -- Shadow Ritualist Phylactery
		["8355"] = 1, -- Modified Anima Golem
		["8356"] = 1, -- Mogu Shadow Ritualist
		["8357"] = 1, -- Zar'thik Amber Priest
		["8358"] = 1, -- Set'thik Wind Wielder
		["8361"] = "WARLOCK", -- Burial Urn
		["8380"] = 3, -- Spark of Life
		["8364"] = "WARLOCK", -- Amber-Encased Kunchong
		["8386"] = "MONK", -- Ancient Brewmaster Spirit
		["8389"] = "MONK", -- Wise Mistweaver Spirit
		["8391"] = "MONK", -- Nameless Windwalker Spirit
		["8469"] = 4, -- Unstable Spark
		-- Siegecrafter Blackfuse
		["8210"] = 3, -- Electromagnet
		["8204"] = 2, -- Shockwave Missile Turret
		["8208"] = 1, -- Leser Turret
		-- Paragons of the Klaxxi
		["8065"] = 4, -- Amber Parasite
		[71407] = 2, -- Amber
		-- Garrosh Hellscream
		["8282"] = "WARRIOR", -- Kor'kron Warbringer
		["8294"] = "SHAMAN", -- Farseer Wolf Rider
		["8298"] = 1, -- Siege Engineer
		["8300"] = 2, -- Kor'kron Iron Star
		["8304"] = 3, -- Desecrated Weapon
	},
}

-------------------------------------------------------------------------------
-- Warlords of Draenor
-------------------------------------------------------------------------------
db[964] = { zone = 385, -- Bloodmaul Slag Mines
	category = 601,
	recolor = {
		[75193] = 1, -- Bloodmaul Overseer
		[75426] = 1, -- Bloodmaul Overseer
		--[84978] = 1, -- Bloodmaul Enforcer
		--[83624] = 1, -- Bloodmaul Enforcer
		[75198] = 3, -- Bloodmaul Geomancer
		[75360] = 5, -- Searing Ember
		[75272] = "MAGE", -- Bloodmaul Ogre Mage
		[83622] = "MAGE", -- Bloodmaul Ogre Mage
		[74349] = "WARLOCK", -- Bloodmaul Magma Binder
		[83621] = "WARLOCK", -- Bloodmaul Magma Binder
		[75210] = 2, -- Bloodmaul Warder
		[83623] = 2, -- Bloodmaul Warder
		[75209] = 1, -- Molten Earth Elemental
		[75820] = 1, -- Vengeful Magma Elemental
		[74570] = 2, -- Ruination
		[74571] = 2, -- Calamity
		[74927] = 4, -- Unstable Slag
	},
}

db[969] = { zone = 537, -- Shadowmoon Burial Grounds
	category = 602,
	order = {
		"h\\1139", 75713, 75506, 75451, 77006, 75966, -- Sadana Bloodfury
		"h\\1168", 77700, 76446, 75979, 75899,  -- Nhallish
		"h\\1140", 76104, 75459, -- Bonemaw
		"h\\1160", 76518, -- Ner'zhul
	},
	flags = {
		["*"] = {
			[75509] = 0x0020,
			[75829] = 0x0020,
			[75452] = 0x0020,
			[76407] = 0x0020,
		},
	},
	recolor = {
		[75713] = 3, -- Shadowmoon Bone-Mender
		[75506] = "DRUID", -- Shadowmoon Loyalist
		[77006] = 7, -- Corpse Skitterling
		[75966] = 4, -- Defiled Spirit

		[77700] = 1, -- Shadowmoon Exhumer
		[76446] = 2, -- Shadowmoon Dominator
		[75979] = 5, -- Exhumed Spirit
		[75899] = 4, -- Possessed Soul

		[76104] = 2, -- Monstrous Corpse Spider
		[75459] = 1, -- Plagued Bat

		[76518] = 1, -- Ritual of Bones
	},
	auras = {
		{id = "969:398151", spellID = 398151, buff = true, enlarge = true, emphasize = true, color = 10}, -- Sinister Focus
	},
}

db[984] = { zone = 547, -- Auchindoun
	category = 603,
	recolor = {
		[77812] = 1, -- Sargerei Soulbinder
		[77134] = 2, -- Sargerei Cleric
		[77131] = 3, -- Sargerei Spirit-Tender
		[77080] = 2, -- Sargerei Arbiter
		[87074] = 1, -- Sargerei Magus
		[76263] = 1, -- Sargerei Magus
		[77935] = 1, -- Sargerei Warden
		[79510] = 1, -- Cackling Pyromaniac
		[76260] = 1, -- Cackling Pyromaniac
		[79508] = 4, -- Felborne Abyssal
		[77905] = 4, -- Felborne Abyssal
	},
}

db[987] = { zone = 558, -- Iron Docks
	category = 604,
	flags = {
		["*"] = {
			[81305] = 0x0020,
			[81297] = 0x0020,
			[80816] = 0x0020,
			[80805] = 0x0020,
			[80808] = 0x0020,
			[79852] = 0x0020,
			[83612] = 0x0020,
			[83613] = 0x0020,
			[83616] = 0x0020,
		},
	},
	recolor = {
		[81432] = 2, -- Grom'kar Technician
		[83763] = 2, -- Grom'kar Technician
		[83025] = 2, -- Grom'kar Battlemaster
		[86526] = 2, -- Grom'kar Chainmaster
		[81603] = 1, -- Champion Druna
		[83026] = 1, -- Siegemaster Olugar
		["10456"] = 1, -- Neesa Nox
		["10449"] = 2, -- Ahri'ok Dugru
		[81297] = "DRUID", -- Dreadfang
		[83613] = "WARRIOR", -- Koramar
		[83616] = 1, -- Zoggosh
	},
}

db[989] = { zone = 476, -- Skyreach
	category = 605,
	recolor = {
		[79466] = 3, -- Initiate of the Rising Sun
		[78933] = "PRIEST", -- Herald of Sunrise
		[79462] = 2, -- Blinding Solar Flare
		[76097] = 1, -- Solar Familiar
		[76778] = 4, -- Life-Pact Familiar
		[78932] = 1, -- Driving Gale-Caller
		[79467] = 3, -- Adept of the Dawn
		[76094] = 4, -- Sun Trinket
		[77605] = 2, -- Whirling Dervish
		[79469] = 2, -- Whirling Dervish
		[76154] = 2, -- Skyreach Raven Whisperer
		[76227] = 4, -- Solar Flare
		[79463] = 2, -- Radiant Supernova
		[76267] = 4, -- Solar Zealot
		[76292] = 1, -- Skyreach Shield Construct
	},
}

db[993] = { zone = 536, -- Grimrail Depot
	category = 606,
	flags = {
		["*"] = {
			[77803] = 0x0020,
			[77816] = 0x0020,
			[79545] = 0x0020,
			[80005] = 0x0020,
		},
	},
	recolor = {
		[81236] = 2, -- Grimrail Technician
		[81212] = 1, -- Grimrail Overseer
		[77803] = 2, -- Railmaster Rocketspark
		["9721"] = 1, -- Grom'kar Boomer
		["9719"] = 1, -- Grom'kar Grenadier
		["9717"] = 2, -- Grom'kar Gunner
		[82579] = 3, -- Grom'kar Far Seer
		[82590] = 2, -- Grimrail Scout
		[82597] = 1, -- Grom'kar Captain
		[88163] = 3, -- Grom'kar Cinderseer
	},
}

db[995] = { zone = 559, -- Upper Blackrock Spire
	category = 607,
	recolor = {
		[76157] = 2, -- Black Iron Leadbelcher
		[76181] = 1, -- Ragemaw Worg
		[76222] = 4, -- Rallying Banner
		[76314] = 5, -- Sentry Cannon
		[76101] = 3, -- Black Iron Engineer
		[77037] = 1, -- Black Iron Elite
		[77096] = 5, -- Vilemaw Hatchling
		[77036] = "WARLOCK", -- Black Iron Summoner
		[77033] = 2, -- Black Iron Siegebreaker
		[76599] = 2, -- Black Iron Groundshaker
		[76694] = 5, -- Emberscale Whelpling
		[76696] = 1, -- Emberscale Adolescent
		[80703] = 4, -- Windfury Totem
	},
}

db[1008] = { zone = 556, -- The Everbloom
	category = 608,
	recolor = {
		[84767] = 2, -- Twisted Abomination
		[81820] = "SHAMAN", -- Everbloom Mender
		[81638] = 4, -- Aqueous Globule
		[81821] = 4, -- Aqueous Globule
		["10409"] = "SHAMAN",
		["10413"] = "DRUID",
		[84554] = 2, -- Venom-Crazed Pale One
		[86554] = 3, -- Venom-Crazed Pale Hulk
		[86552] = 1, -- Gorged Burster
		[84989] = 1, -- Infested Icecaller
		[84957] = 2, -- Putrid Pyromancer
		[84400] = 2, -- Gnarled Ancient
		[86684] = 3, -- Feral Lasher
		[85194] = 4, -- Entanglement
		[84499] = 4, -- Entanglement
		[84401] = 5, -- Swift Sproutling
	},
}

db[994] = { zone = 477, -- Highmaul
	category = 651,
	recolor = {
		[80071] = 2, -- Bladespire Sorcerer
		[81224] = 2, -- Bladespire Sorcerer
		[80822] = 2, -- Night-Twisted Berserker
		["9390"] = 1, -- Iron Bomber
		["9387"] = 3, -- Drunken Bileslinger
		["9987"] = 3, -- Spore Shooter
		["9994"] = 4, -- Mind Fungus
		["9919"] = 3, -- Volatile Anomaly
		--["10063"] = 1, -- Shard of Tectus
		["10064"] = 1, -- Mote of Tectus
		["9945"] = 2, -- Arcane Aberration
		["9946"] = 2, -- Displacing Arcane Aberration
		["9947"] = 2, -- Fortified Arcane Aberration
		["9948"] = 2, -- Replicating Arcane Aberration
	},
}

db[988] = { zone = 457, -- Blackrock Foundry
	category = 652,
	order = {
		"h\\1122", 76796, "9307",
		"h\\1123", "9354", "9345", 78912,
		"h\\1147", "9555", "9543", "9542", "9549", "9540",
		"h\\1154", "9649", "9640", "9655", "9657", "9659",
		"h\\1162", 77893,
		"h\\1203", 78583,
		"h\\959", "9571",
	},
	recolor = {
		-- Beastlord Darmac
		[76796] = 6,
		["9307"] = 1, -- Pack Beast
		-- Flamebender Ka'graz
		["9354"] = 3, -- Aknor Steelbringer
		["9345"] = 4, -- Cinder Wolf
		[78912] = 1, -- Overheated Cinder Wolf
		-- Operator Thogar
		["9555"] = 4, -- Iron Gunnery Sergeant
		["9543"] = 3, -- Grom'kar Firemender
		["9542"] = 5, -- Iron Crack-Shot
		["9549"] = 2, -- Grom'kar Man-at-Arms
		["9540"] = 1, -- Iron Raider
		-- The Blast Furnace
		["9649"] = 3, -- Furnace Engineer
		["9640"] = 2, -- Foreman Feldspar
		["9655"] = 4, -- Primal Elementalist
		["9657"] = 1, -- Slag Elemental
		["9659"] = 3, -- Firecaller
		-- Kromog
		[77893] = 6, -- Grasping Earth
		-- The Iron Maidens
		[78583] = 4, -- Dominator Turret
		-- Blackhand
		--["9576"] = 5, -- Iron Soldier
		["9571"] = 4, -- Siegemaker
	},
}

db[1026] = { zone = 669, -- Hellfire Citadel
	category = 653,
	order = {
		"h\\1426", 90409, 92522, 92911, 93881, 95652, 90410, 90432, 90485, 91103, 93435,
		"h\\1425", 93717, 94312, 94326, 94955,
		"h\\1392", 91368,
		"h\\1396", "11261", "11263", "11266", "11269", 90411, 90414,
		"h\\1372", 90508, 90568, 90570, 90388, 90385,
		"h\\1433", 91543, 93985, 91541, 93968, 91539, 93952, 93625,
		"h\\1427", 95101, 92767, 91938, 91941,
		"h\\1447", 94185, 94397, 94239,
		"h\\1394", 90270, 90271, 90272,
		"h\\1395", 91241, 93598, 93605, 93599, 93597, 91259,
		"h\\1438", 92208, 92740, 93615, 94412, 93297, 95775,
	},
	recolor = {
		-- Hellfire Assault
		[90409] = "WARLOCK", -- Gorebound Felcaster
		[92522] = "WARLOCK", -- Gorebound Terror
		[92911] = 1, -- Hulking Berserker
		[93881] = 3, -- Contracted Engineer
		[95652] = 2, -- Grand Corruptor U'rogg (Mythic)
		--[95653] = , -- Grute (Mythic)
		[90410] = 4, -- Felfire Crusher
		[90432] = 4, -- Felfire Flamebelcher
		[90485] = 4, -- Felfire Artillery
		[91103] = 4, -- Felfire Demolisher
		[93435] = 6, -- Felfire Transporter (Mythic)
		-- Iron Reaver
		[93717] = 4, -- Volatile Firebomb
		[94312] = 2, -- Quick-Fuse Firebomb (Mythic)
		[94326] = 3, -- Reactive Firebomb (Mythic)
		[94955] = 1, -- Reinforced Firebomb (Mythic)
		-- Kormrok
		[91368] = 4, -- Crushing Hand
		-- Kilrogg Deadeye
		["11261"] = {1, 0.5, 0.5, 1}, -- Blood Globule
		["11263"] = {1, 0.5, 0.5, 1}, -- Fel Blood Globule
		["11266"] = 6, -- Salivating Bloodthirster
		["11269"] = 1, -- Hulking Terror
		[90411] = 2, -- Hellblaze Fiend
		[90414] = 1, -- Hellblaze Mistress
		-- Gorefiend
		[90508] = 4, -- Gorebound Construct
		[90568] = 3, -- Gorebound Essence
		[90570] = 2, -- Gorebound Spirit
		[90388] = 1, -- Tortured Essences
		[90385] = 2, -- Enraged Spirits
		-- Shadow-Lord Iskar
		[91543] = "PRIEST", -- Corrupted Talonpriest
		[93985] = "PRIEST", -- Corrupted Talonpriest
		[91541] = 1, -- Shadowfel Warden
		[93968] = 1, -- Shadowfel Warden
		[91539] = 2, -- Fel Raven
		[93952] = 2, -- Fel Raven
		[93625] = 3, -- Phantasmal Radiance (Mythic)
		-- Socrethar the Eternal
		[95101] = 4, -- Voracious Soulstalker (Mythic)
		[92767] = 1, -- Sargerei Dominator
		[91938] = 3, -- Haunting Soul
		[91941] = 2, -- Sargerei Shadowcaller
		-- Xhul'haroc
		[94185] = 1, -- Vanguard Akkelion
		[94397] = 6, -- Unstable Voidfiend
		[94239] = 2, -- Omnus
		-- Tyrant Velhari
		[90270] = 3, -- Ancient Enforcer
		[90271] = 3, -- Ancient Harbinger
		[90272] = 3, -- Ancient Sovereign
		-- Mannoroth
		[91241] = 1, -- Doom Lord
		[93598] = 1, -- Doom Lord Asrogol
		[93605] = 1, -- Doom Lord Kaz'eth
		[93599] = 1, -- Doom Lord Usael
		[93597] = 1, -- Doom Lord Xorgok
		[91259] = {1, 0.75, 1, 1}, -- Fel Imp
		--[91270] = 3, -- Dread Infernal
		-- Archimonde
		[92208] = 4,
		[92740] = "WARLOCK", -- Hellfire Deathcaller
		[93615] = 1, -- Felborne Overfiend
		[94412] = 2, -- Infernal Doombringer
		[93297] = 6, -- Living Shadow
		[95775] = 4, -- Void Star
	},
}

-------------------------------------------------------------------------------
-- Legion
-------------------------------------------------------------------------------

db[1066] = { zone = 777, -- Assault on Violet Hold
	category = 701,
	order = {
		"h\\-", 102337, 102335, 102336, 102302, 102372, 103381, 112742, 112733, 102380, 102400, 102395, 102397, 112733, 112738,
		"h\\1693", "12646", "12651",
		"h\\1702", "12748",
		"h\\1686", 101994,
		"h\\1688", "12617", "12624",
		"h\\1696", "12682",
	},
	recolor = {
		[102337] = 2, -- Portal Guardian (Inquisitor)
		[102335] = 2, -- Portal Guardian (Jailer)
		[102336] = 2, -- Portal Keeper (Dreadlord)
		[102302] = 2, -- Portal Keeper (Felguard)
		[102372] = 1, -- Felhound Mage Slayer
		[103381] = 4, -- Jailer Cage
		[112742] = 6, -- Broodling
		[102380] = "WARLOCK", -- Shadow Council Warlock
		[102400] = "PRIEST", -- Eredar Shadow Mender
		[102395] = "ROGUE", -- Infiltrator Assassin
		[102397] = "WARRIOR", -- Wrathlord Bulwark
		[112733] = 1, -- Venomhide Shadowspinner
		[112738] = 2, -- Acolyte of Sael'orn
		-- Festerface
		["12646"] = 6, -- Congealed Goo
		["12651"] = 4, -- Black Bile
		-- Blood-Princess Thal'ena
		["12748"] = 6, -- Congealed Blood
		-- Mindflayer Kaahrj
		[101994] = 4, -- Faceless Tendril
		-- Millificent Manastorm
		["12617"] = 4, -- Thorium Rocket Chicken
		["12624"] = 5, -- Reinforced Thorium Rocket Chicken
		-- Anub'esset
		["12682"] = 2, -- Spitting Scarab
	}
}

db[1081] = { zone = 740, -- Black Rook Hold
	category = 702,
	flags = {
		["*"] = {
			[98542] = 0x0020,
			[98696] = 0x0020,
			[98949] = 0x0020,
			[94923] = 0x0020,
			[99611] = 0x0020,
		},
	},
	order = {
		"h\\-", 98368, 98370, 98521, 99664,
		"h\\-", 114516, 98280, 101549, 101839, 98691, 98243, 98706, 100485,
		"h\\-", 98810, 98792, 102781,
		"h\\-", 102095, 102094,
	},
	recolor = {
		[98368] = 1, -- Ghostly Protector
		[98370] = 3, -- Ghostly Councilor
		[98521] = 2, -- Lord Etheldrin Ravencrest
		[98538] = 2, -- Lady Velandras Ravencrest
		[99664] = 4, -- Restless Soul
		[114516] = 5, -- Rook Spiderling
		[98280] = "MAGE", -- Risen Arcanist
		--[98275] = "HUNTER", -- Risen Archer
		[101549] = 4, -- Arcane Minion
		[101839] = "DEMONHUNTER", -- Risen Companion
		[98275] = "HUNTER", -- Risen Archer
		--[98691] = 1, -- Risen Scout
		[98243] = 2, -- Soul-Torn Champion
		[98706] = 2, -- Commander Shemdah'sohn
		[100485] = 1, -- Soul-torn Vanguard
		[98810] = 2, -- Wrathguard Bladelord
		[98792] = 1, -- Wyrmtongue Scavenger
		[102781] = 5, -- Fel Bat Pup
		[102095] = 1, -- Risen Lancer
		[102094] = 2, -- Risen Swordsman
		[101008] = 4, -- Stinging Swarm
	}
}

db[1146] = { zone = 900, -- Cathedral of Eternal Night
	category = 703,
	flags = {
		["*"] = {
			[118717] = 0x0001,
		},
	},
	order = {
		"h\\-", 118704, 119952, 120374, 121553, 119923, 118714, 118703, 119977, 119978,
		"h\\-", 118717, 118723, 121392, 121364, 121384,
		"h\\-", 118718, 120646, 120650, 118712, 118713, 118705, 118801, 118834, 118802,
	},
	recolor = {
		[118704] = 2, -- Dul'zak
		-- [118690] = 1, -- Wrathguard Invader
		-- [120550] = 1, -- Wrathguard Invader
		[119952] = 1, -- Felguard Destroyer
		[120374] = 1, -- Felguard Destroyer
		[121553] = 2, -- Dreadhunter
		[119923] = 3, -- Helblaze Soulmender
		[118714] = "WARLOCK", -- Hellblaze Temptress
		[120366] = "WARLOCK", -- Hellblaze Temptress
		[118703] = "DRUID", -- Felborne Botanist
		[119977] = 1, -- Stranglevine Lasher
		[119978] = 4, -- Fulminating Lasher
		[118717] = 7, -- Helblaze Imp
		[118723] = 2, -- Gazerax
		[121392] = 1, -- Biographical Animated Book
		[121364] = 2, -- Satirical Animated Book
		[121384] = 3, -- Fictional Animated Book
		[118718] = 4, -- Book of Eternal Winter
		[120646] = 6, -- Book of Arcane Monstrosities
		[120650] = 2, -- Arcane Horror
		[118712] = 1, -- Felstrider Enforcer
		[118713] = "WARLOCK", -- Felstrider Orbcaster
		[118705] = 2, -- Nal'asha
		[118801] = 7, -- Imp
		[118834] = 3, -- Fel Portal Guardian
		[118802] = 2, -- Hellblaze Mistress
	}
}

db[1087] = { zone = 800, -- Court of Stars
	category = 704,
	flags = {
		["*"] = {
			[104215] = 0x0020,
			[104217] = 0x0020,
			[104218] = 0x0020,
		},
	},
	order = {
		"h\\-", 104251, 104918, 105699, 105703, 104270, 105705, 104215, 105704,
		"h\\-", 104295, 105715, 104300, 104278, "13074", "13075", "13076",
	},
	recolor = {
		[104251] = "DRUID", -- Duskwatch Sentry
		[104918] = 7, -- Vigilant Duskwatch
		--[105699] = 7, -- Mana Saber
		[105703] = 7, -- Mana Wyrm
		[104270] = 2, -- Guardian Construct
		[105705] = "MAGE", -- Bound Energy
		-- [104215] = 1, -- Patrol Captaion Gerdo
		[105704] = 2, -- Arcane Manifestation

		[104295] = 7, -- Blazing Imp
		[105715] = "WARLOCK", -- Watchful Inquisitor
		[104300] = 3, -- Shadow Mistress
		[104278] = "DRUID", -- Felbound Enforcer
		[112668] = 6, -- Infernal Imp
		["13074"] = 1, -- Jazshariu
		["13075"] = 1, -- Baalgar the Watchful
		["13076"] = 1, -- Imacu'tya
	}
}

db[1067] = { zone = 762, -- Darkheart Thicket
	category = 705,
	flags = {
		["*"] = {
			[96512] = 0x0020,
			[103344] = 0x0020,
			[99200] = 0x0020,
			[99192] = 0x0020,
		},
	},
	order = {
		"h\\-", 95769, 95771, 95766, 95779, "13302",
		"h\\-", 99360, 99358, 99359, 100960, 100991, 107288,
		"h\\-", 100531, 101074,
		"h\\-", 100527, 100539, 102277, 99366,
	},
	recolor = {
		--[95772] = false, -- Frenzied Nightclaw
		--[101679] = false, -- Dreadsoul Poisoner
		[95769] = 1, -- Mindshattered Screecher
		[95771] = 2, -- Dreadsoul Ruiner
		[95766] = 3, -- Crazed Razorbeak
		--[95779] = "DRUID", -- Festerhide Grizzly
		["13302"] = 7, -- Nightmare Abomination
		[99360] = 2, -- Vilethorn Blossom
		--[99358] = 1, -- Rotheart Dryad
		[99359] = 1, -- Rotheart Keeper
		--[100960] = 4, -- Vile Mushroom
		[100991] = 6, -- Strangling Roots
		[107288] = 1, -- Vilethorn Sapling
		[100531] = 2, -- Bloodtainted Fury
		[101074] = 5, -- Hatespawn Whelpling
		[100527] = 1, -- Dreadfire Imp
		[100539] = 2, -- Taintheart Deadeye
		[102277] = 5, -- Deadeye Decoy
		[99366] = "WARLOCK", -- Taintheart Summoner
	}
}

db[1046] = { zone = 716, -- Eye of Azshara
	category = 706,
	flags = {
		["*"] = {
			[91784] = 0x0020,
			[91789] = 0x0020,
			[91808] = 0x0020,
			[97259] = 0x0020,
			[97260] = 0x0020,
			[91797] = 0x0020,
			[96028] = 0x0020,
		},
	},
	order = {
		"h\\-", 91783, 95861, 100216, "12028", "12030",
		"h\\-", 97171, 95920, "12139",
		"h\\-", 113111,
		"h\\-", 91793, "12015", "12017",
		"h\\-", 100248, 100249, 100250,
	},
	recolor = {
		[91783] = 2, -- Hatecoil Stormweaver
		--[111638] = 2, -- Hatecoil Stormweaver
		[95861] = 3, -- Hatecoil Oracle
		--[111636] = 3, -- Hatecoil Oracle
		--[91782] = "WARRIOR", -- Hatecoil Crusher
		--[111632] = "WARRIOR", -- Hatecoil Crusher
		[100216] = 1, -- Hatecoil Wrangler
		--[111635] = 1, -- Hatecoil Wrangler
		["12028"] = 2, -- Hatecoil Shellbreaker
		["12030"] = 3, -- Hatecoil Crestrider
		[97171] = "MAGE", -- Hatecoil Arcanist
		[95920] = 1, -- Animated Storm
		["12139"] = 6, -- Saltsea Globule
		[113111] = 1, -- Saltscale Swarmer
		--[91793] = 1, -- Seaspray Crab
		["12015"] = {0.85, 0.2, 0, 1}, -- Blazing Hydra Spawn
		["12017"] = {0.8, 0.2, 0.7, 1}, -- Arcane Hydra Spawn
		[100248] = 1, -- Ritualist Lesha
		[100249] = 2, -- Channeler Varisz
		[100250] = 3, -- Binder Ashioi
	}
}

db[1041] = { zone = 721, -- Halls of Valor
	category = 707,
	order = {
		"h\\1485", 97068, 95842, -- Hymdall
		"h\\1486", 96664, 95834, 96640, 97197, 101637, -- Hyrja
		"h\\1487", 99828, 99891, 99922, -- Fenryr
		"h\\1488", 97083, 95843, 97081, 97084, 101326, 104822, -- God-King Skovald
		"h\\1489", "12605", -- Odyn
	},
	flags = {
		["*"] = {
			[94960] = 0x0020,
			[95833] = 0x0020,
			[95674] = 0x0020,
			[99868] = 0x0020,
			[95675] = 0x0020,
			[95676] = 0x0020,
		},
	},
	recolor = {
		[97068] = 1, -- Storm Drake
		[95842] = 2, -- Valarjar Thundercaller
		[96664] = 1, -- Valarjar Runecarver
		[95834] = 3, -- Valarjar Mystic
		[96640] = "HUNTER", -- Valarjar Marksman
		--[95832] = 1, -- Valarjar Shieldmaiden
		[97197] = 1, -- Valarjar Purifier
		[101637] = 1, -- Valarjar Aspirant
		--[96934] = 1, -- Valarjar Trapper

		[99828] = 7, -- Trained Hawk
		[99891] = 1, -- Storm Drake
		-- Fenryr
		[99922] = 1, -- Ebonclaw Packmate
		-- King Bjorn
		[101326] = 6, -- Honored Ancestor
		-- God-King Skovald
		[97083] = 3, -- King Ranulf
		[95843] = "WARRIOR", -- King Haldor
		[97081] = 1, -- King Bjorn
		[97084] = 2, -- King Tor
		[104822] = 4, -- Flame of Woe
		-- Odyn
		["12605"] = 2, -- Stormforged Obliterator
	}
}

db[1042] = { zone = 727, -- Maw of Souls
	category = 708,
	order = {
		"h\\-", 102104, 97200, 98246,
		"h\\-", 97119, 98919, 97365, 97182, 98973, 97097, "12212",
		"h\\-", 99033, 99307, 98973,
		"h\\1663", "12364", "12492",
	},
	recolor = {
		[102104] = 1, -- Enslaved Shieldmaiden
		[97200] = 2, -- Seacursed Soulkeeper
		[98246] = 2, -- Risen Warrior
		[97119] = 7, -- Shroud Hound
		--[98919] = 1, -- Seacursed Swiftblade
		[97365] = "PRIEST", -- Seacursed Mistmender
		[97182] = "WARLOCK", -- Night Watch Mariner
		[98973] = 5, -- Skeletal Warrior
		[97097] = 1, -- Helarjar Champion
		["12212"] = 6, -- Shackled Servitor
		[99033] = 3, -- Helarjar Mistcaller
		[99307] = 2, -- Skjal
		[98973] = "WARRIOR", -- Skeletal Warrior
		["12364"] = 2, -- Destructor Tentacle
		["12492"] = 1, -- Grasping Tentacle
	}
}

db[1065] = { zone = 767, -- Neltharion's Lair
	category = 709,
	flags = {
		["*"] = {
			[91003] = 0x0020 + 0x3800,
			[91004] = 0x0020 + 0x3800,
			[91005] = 0x0020 + 0x3800,
			[91007] = 0x0020 + 0x3800,
		},
	},
	order = {
		"h\\1662", 91001, 91006, 96247, 91000, 97720, -- Rokmora
		"h\\1665", 92610, 92387, 91332, 113998, 90997, 91008, 90998, 94224, 94331, 101437, 98081, -- Ularogg Cragshaper
		"h\\1673", 92538, 91002, 102430, 102404, 101075, -- Naraxas
		"h\\1687", 102287, 113537, 101476, -- Dargrul the Underking
	},
	recolor = {
		[91001] = 2, -- Tarspitter Lurker
		-- [91006] = 1, -- Rockback Gasher
		[96247] = 7, -- Vileshard Crawler
		[91000] = "WARRIOR", -- Vileshard Hulk
		[97720] = 1, -- Blightshard Skitter

		[92610] = "DRUID", -- Understone Drummer
		--[92387] = 4, -- Drums of War
		[91332] = 1, -- Stoneclaw Hunter
		[113998] = 2, -- Mightstone Breaker
		[90997] = 2, -- Mightstone Breaker
		[91008] = "HUNTER", -- Rockbound Pelter
		[90998] = "MAGE", -- Blightshard Shaper
		[94224] = 5, -- Petrifying Totem
		[94331] = 4, -- Petrifying Crystal
		[101437] = "DEMONHUNTER", -- Burning Geode
		[98081] = 4, -- Bellowing Idol

		[92538] = "WARLOCK", -- Tarspitter Grub
		[91002] = "DEMONHUNTER", -- Rotdrool Grabber
		[102430] = 5, -- Tarspitter Slug
		[102404] = 1, -- Stoneclaw Grubmaster
		[101075] = 4, -- Wormspeaker Devout

		[102287] = 1, -- Emberhusk Dominator
		[113537] = 1, -- Emberhusk Dominator
		[101476] = 3, -- Molten Charskin
	}
}

db[1115] = { zone = 860, -- Return to Karazhan
	category = 710,
	flags = {
		["*"] = {
			[114251] = 0x0020,
			[114284] = 0x0020,
			[114260] = 0x0020,
			[114261] = 0x0020,
			[114329] = 0x0020,
			[114522] = 0x0020,
			[114328] = 0x0020,
			[114330] = 0x0020,
			[113971] = 0x0020,
			[114262] = 0x0020,
			[114264] = 0x0020,
			[114312] = 0x0020,
			[114247] = 0x0020,
			[114350] = 0x0020,
			[114675] = 0x0020,
			[116494] = 0x0020,
			[114790] = 0x0020,
		},
	},
	order = {
		"h\\-", 114542, 114544, 114783, 114624, 114792, 114636, 115019, 114650, 114802, 114803, 115484, 115115, 114627,
		"h\\1820", "14020", "14028", "14023",
		"h\\1826", "14122", "14125", "14128",
		"h\\1827", "14145", "14148", "14151", 116574,
		"h\\1835", 114262,
		"h\\1837", "14360", "14366", "14369", "14372", "14374", "14376", "14378",
		"h\\1836", "14327",
		"h\\1817", "14268",
		"h\\"..GetSpellInfo(229467), 115388, 115395, 115406, 115401, 115402, 115407,
		"h\\1838", "14428", "14430",
		"h\\"..GetSpellInfo(31116), 114903,
	},
	recolor = {
		[114542] = 2, -- Ghostly Philanthoropist
		--[114783] = 2, -- Reformed Maiden
		[114792] = 1, -- Virtuous Lady
		[114636] = 2, -- Phantom Guardsman
		[114650] = 7, -- Phantom Hound
		[114802] = 2, -- Spectral Journeyman
		[114803] = 3, -- Spectral Stable Hand
		[115484] = 6, -- Fel Bat
		[114544] = 1, -- Skeltal Usher
		[114624] = "MAGE", -- Arcane Warden
		[115019] = 1, -- Coldmist Widow
		[115115] = 1, -- Coldmist Stalker
		[114627] = 2, -- Shrieking Terror
		-- Opera Hall: Wikket
		["14023"] = 4, -- Winged Assistant
		["14020"] = "PRIEST", -- Elfyra
		--["14028"] = 1, -- Galindre
		-- Opera Hall: Westfall Story
		["14122"] = 1, -- Gang Ruffian
		["14125"] = 3, -- Mrrgria
		["14128"] = 2, -- Shoreline Tidespeaker
		-- Opera Hall: Beautiful Beast
		["14145"] = 2, -- Luminore
		["14148"] = 3, -- Mrs. Cauldrons
		["14151"] = 1, -- Babblet
		[116574] = 7, -- Silver Forks
		-- ["14142"] = "", -- Coggleston
		-- Attumen the Huntsman
		[114262] = 2, -- Attumen the Huntsman
		-- Moroes
		-- ["14360"] = "ROGUE", -- Moroes
		["14366"] = "MAGE", -- Baroness Dorothea Millstipe
		["14369"] = "PRIEST", -- Lady Catriona Von'indi
		["14372"] = 1, -- Baron Rafe Dreuger
		["14374"] = "PALADIN", -- Lady Keira Berrybuck
		["14376"] = "WARRIOR", -- Lord Robin Daris
		["14378"] = "DEMONHUNTER", -- Lord Crispin Ference
		-- The Curator
		["14327"] = 6, -- Volatile Energy
		-- Shade of Medivh
		["14268"] = 4, -- Guardian's Image
		-- Chess
		[115388] = "PALADIN", -- King
		[115395] = "WARLOCK", -- Queen
		[115406] = "WARRIOR", -- Knight
		[115401] = "PRIEST", -- Bishop
		[115402] = "PRIEST", -- Bishop
		[115407] = "MAGE", -- Rook
		-- Viz'aduum the Watcher
		["14428"] = 1, -- Felguard Sentry
		["14430"] = 2, -- Fel Flame Spitter
		-- Nightbane
		[114903] = 2, -- Bonecurse
	}
}

db[1178] = { zone = 945, -- Seat of the Triumvirate
	category = 711,
	order = {
		"h\\-", 122322, 124171, 122716, 122482,
		"h\\-", 122571, 125860, 122401, 125981, 122413, 122403, "16078", "16336",
		"h\\-", 122405, 122404, 122423, 124967, 124964, 124947, 122827, 125615,
		"h\\-", 123050, 124745,
	},
	recolor = {
		[122322] = 1, -- Famished Broken
		[124171] = 2, -- Shadowguard Subjugator
		[122716] = 7, -- Coalesced Void
		[122482] = 4, -- Dark Aberration
		[122571] = "WARLOCK", -- Rift Warden
		[125860] = "WARLOCK", -- Rift Warden
		[122401] = "ROGUE", -- Shadowguard Trickster
		[125981] = 7, -- Fragmented Voidling
		[122413] = 1, -- Shadowguard Riftstalker
		[122403] = "WARRIOR", -- Shadowguard Champion
		["16078"] = 1, -- Darkfang
		["16336"] = 2, -- Shadewing
		[122405] = 2, -- Shadowguard Conjurer
		[122404] = "PRIEST", -- Shadowguard Voidbender
		[122423] = 1, -- Grand Shadow-Weaver
		[124967] = 7, -- Shadow-Weaver Essence
		[124964] = 4, -- Unstable Dark Matter
		[124947] = 5, -- Void Flayer
		[122827] = 1, -- Umbral Tentacle
		[125615] = 4, -- Shadowguard Voidtender
		[123050] = 1, -- Waning Void
		[124745] = "WARLOCK", -- Greater Rift Warden
	}
}

db[1079] = { zone = 726, -- The Arcway
	category = 712,
	order = {
		"h\\-", 106546, 98756, 102351, 106059,
		"h\\-", 98426, 98435, 98728, 105915, 105921,
		"h\\-", 105629, 105682, 105617, 98770, "12489",
		"h\\-", 105876, "13765",
	},
	recolor = {
		[98426] = 2, -- Unstable Ooze
		[98435] = 5, -- Unstable Oozeling
		[98728] = 1, -- Acidic Bile
		[105915] = 2, -- Nightborne Reclaimer
		[105921] = 1, -- Nightborne Spellsword

		[106546] = 4, -- Astral Spark
		[98756] = 2, -- Arcane Anomaly
		--[102351] = 6, -- Mana Wyrm
		[106059] = 1, -- Warp Shade

		[105876] = "MAGE", -- Enchanted Broodling
		["13765"] = 1, -- Vicious Manafang

		[105629] = 5, -- Wyrmtongue Scavanger
		[105682] = 1, -- Felguard Destroyer
		[105617] = "WARLOCK", -- Eredar Chaosbringer
		[98770] = 2, -- Wrathguard Felblade
		["12489"] = 1, -- Dread Felbat
	}
}

db[1045] = { zone = 707, -- Vault of the Wardens
	category = 713,
	flags = {
		["*"] = {
			[95885] = 0x0020,
			[96015] = 0x0020,
			[95887] = 0x0020,
			[95886] = 0x0020,
			[95888] = 0x0020,
		},
	},
	order = {
		"h\\-", 96584, 98926, 98177, 96480, 98954, 99956, 102583, 107101,
		"h\\-", 95833, "12883", "12884", "12897", "12895", "12893", "12888",
		"h\\-", "12665",
		"h\\-", 96657,
		"h\\-", 97678, 100351, 104293,
	},
	recolor = {
		[96584] = 1, -- Immoliant Fury
		[98926] = "WARLOCK", -- Shadow Hunter
		[98177] = 2, -- Glayvianna Soulrender
		[96480] = 5, -- Viletongue Belcher
		--[98954] = 1, -- Felsworn Myrmidon
		[99956] = 2, -- Fel-Infused Fury
		--[102583] = 1, -- Fel Scorcher
		[107101] = 2, -- Fle Fury
		[98533] = 2, -- Foul Mother
		["12897"] = 1, -- Lingering Corruption
		["12883"] = 1, -- Shadowmoon Technician
		["12884"] = "WARLOCK", -- Shadowmoon Warlock
		["12895"] = 1, -- Deranged Mindflayer
		["12893"] = 2, -- Faceless Voidcaster
		["12888"] = 1, -- Mogu'shan Secret Keeper
		[96657] = 2, -- Blade Dancer Illianna
		["12665"] = 4, -- Ember
		[97678] = 2, -- Aranasi Broodmother
		[100351] = 6, -- Avatar of Vengeance
		[104293] = 4, -- Avatar of Shadow
	}
}

db[1094] = { zone = 768, -- The Emerald Nightmare
	category = 751,
	order = {
		"h\\-", 111333, 113113, 111354, 113088, 112474, 112162, 113920, 111980, 113089, 113090, 111370, 111398,
		"h\\1744", "13262", "13496",
		"h\\1738", "13186", "13188", "13190", "13191", "13189", "13570",
		"h\\1704", "12779", "12864", "12850", "13460",
		"h\\1750", "13348", "13350", "13354", "13357",
		"h\\1726", "12973", "12972", "13162", "12977",
	},
	recolor = {
		-- trash
		[111333] = 1, -- Taintheart Trickster
		[113113] = 7, -- Essence of Nightmare
		[111354] = 2, -- Taintheart Befouler
		[113088] = 6, -- Corrupted Feeler
		[112474] = 4, -- Corrupted Totem
		[112162] = 1, -- Grisly Trapper
		[113920] = 3, -- Flail of Il'gynoth
		[111980] = 2, -- Nightmother
		[113089] = 1, -- Defiled Keeper
		[113090] = 2, -- Corrupted Gatewarden
		[111370] = 2, -- Creature in the Shadows
		[111398] = 1, -- Nightmare Amalgamation
		--[111405] = 3, -- Shadow Pounder

		-- Nythendra

		-- Il'gynoth, Heart of Corruption
		["13186"] = "MAGE", -- Nightmare Ichor
		["13188"] = 2, -- Nightmare Horror
		["13190"] = 4, -- Deathglare Tentacle
		["13191"] = 4, -- Corruptor Tentacle
		--["13189"] = 2, -- Dominator Tentacle
		["13570"] = 1, -- Shriveled Eyetalk (Mythic)

		-- Elerethe Renferal
		["13262"] = "MAGE", -- Venomous Spiderling
		["13496"] = 1, -- Skittering Spiderling

		-- Ursoc

		-- Dragons of Nightmare
		["12779"] = "PRIEST", -- Dread Horror
		["12864"] = 3, -- Essence of Corruption
		["12850"] = 4, -- Shade of Taerar
		["13460"] = 1, -- Lumbering Mindgorger (Mythic)

		-- Cenarius
		["13348"] = 6, -- Corrupted Wisp
		["13350"] = 2, -- Nightmare Ancient
		["13354"] = 1, -- Rotten Drake
		["13357"] = 3, -- Twisted Sister

		-- Xavius
		["12973"] = 2, -- Corruption Horror
		["12972"] = 6, -- Lurking Terror
		["13162"] = 1, -- Inconceivable Horror
		["12977"] = 3, -- Nightmare Tentacle
	}
}

db[1114] = { zone = 861, -- Trial of Valor
	category = 752,
	order = {
		"h\\1819", "14005", "14006",
		-- "h\\1830",
		"h\\1829", "14309", "14217", "14263", "14278", "14311",
	},
	recolor = {
		-- Odyn
		["14005"] = 1, -- Hymdall
		["14006"] = 2, -- Hyrja

		-- Guarm

		-- Helya
		["14309"] = 6, -- Griping Tentacle
		["14217"] = 4, -- Bilewater Slime
		["14263"] = 1, -- Grimelord
		["14278"] = 2, -- Night Watch Mariner
		["14311"] = 7, -- Decaying Minion

	}
}

db[1088] = { zone = 786, -- The Nighthold
	category = 753,
	order = {
		"h\\1706", 103217, 103224,
		"h\\1725", "14721",
		"h\\1731", 104596,
		"h\\1751", 107237, 107285, 107287, 107592,
		"h\\1762", "13515", "13525",
		"h\\1713", "12914",
		"h\\1761", "13682", "13684", "13694", "13699", 109804,
		"h\\1732", "13066", "13057",
		"h\\1743", 106643, "13226", "13229",
		"h\\1737", "14894", "14897", 105630, 106545,
	},
	flags = {
		["1706"] = {
			[103217] = 0x0001 + 0x0002, -- Crystalline Scorpid
		},
		["1731"] = {
			[104596] = 0x0001 + 0x0002 + 0x0004 + 0x1800, -- Scrubber
		},
		["1751"] = {
			[107237] = 0x0001, -- Icy Enchantment
			[107285] = 0x0001 + 0x0004, -- Fiery Enchantment
			[107287] = 0x0001 + 0x0004, -- Arcane Enchantment
		},
		["1737"] = {
			[104154] = 0x3800, -- Gul'dan
			[105503] = 0x3800, -- Gul'dan
			[106545] = 0x6800, -- Empowered Eye of Gul'dan
		},
	},
	recolor = {
		[108359] = 1, -- Volatile Scorpid
		[108360] = 3, -- Acidmaw Scorpid
		[112655] = 3, -- Celestial Acolyte
		[112664] = 4, -- Arc Well
		[112803] = 2, -- Astrologer Jarin

		-- Skorpyron
		-- [103217] = 2, -- Crystalline Scorpid
		[103224] = 1, -- Volatile Scorpid

		-- Chronomatic Anomaly
		["14721"] = 6, -- Fragmented Time Particle

		-- Trilliax
		[104596] = "ROGUE", -- Scrubber

		-- Spellblade Aluriel
		[107237] = 2, -- Icy Enchantment
		[107285] = 1, -- Fiery Enchantment
		[107287] = 3, -- Arcane Enchantment
		[107592] = 4, -- Ice Shards

		-- Tichondrius
		["13515"] = 1, -- Felsworn Spellguard
		["13525"] = 2, -- Sightless Watcher

		-- Krosus
		["12914"] = 4, -- Burning Ember

		-- High Botanist Tel'arn
		["13699"] = "DRUID", -- Parasitic Lasher
		[109804] = 4, -- Plasma Sphere
		["13682"] = 1, -- Solarist Tel'arn
		["13684"] = 3, -- Naturalist Tel'arn
		-- ["13694"] = 2, -- Arcanist Tel'arn

		-- Star Augur Etraeus
		["13066"] = 1, -- Voidling
		["13057"] = 2, -- Thing That Should Not Be

		-- Grand Magistrix Elisande
		[106643] = "WARRIOR", -- Elisande
		["13226"] = {0, 0.55, 1}, -- Recursive Elemental
		["13229"] = {1, 0, 0.3}, -- Expedient Elemental

		-- Gul'dan
		["14894"] = 2, -- Fel Lord Kuraz'mal
		["14897"] = 1, -- Inquisitor Vethriz
		[105630] = 4, -- Eye of Gul'dan
		[106545] = 4, -- Empowered Eye of Gul'dan
	}
}

db[1147] = { zone = 875, -- Tomb of Sargeras
	category = 754,
	order = {
		-- "h\\1862", -- Goroth
		"h\\1867", 116691, -- Demonic Inquistion
		"h\\1856", 117596, 116569, -- Harjatan
		"h\\1903", 119205, -- Sisters of Moon
		"h\\1861", 115795, 115902, -- Mistress Sassz'ine
		"h\\1896", 118715, 118728, 118729, 118730, -- The Desolate Host
		-- "h\\1897", -- Maiden of Vigilance
		"h\\1873", 117264, -- Fallen Avatar
		"h\\1898", 119206, 119107, -- Kil'jaeden
	},
	flags = {
		["1896"] = {
			[118730] = 0x0001,
		}
	},
	recolor = {
		[120777] = 2, -- Guardian Sentry
		[120473] = 2, -- Tidescale Combatant
		[120482] = 1, -- Tidescale Seacaller

		-- Goroth

		-- Demonic Inquistion
		[116691] = "WARLOCK", -- Belac

		-- Harjatan
		[117596] = 1, -- Razorjaw Gladiator
		[116569] = 2, -- Razorjaw Wavemender

		-- Sisters of Moon
		[119205] = 3, -- Moontalon

		-- Mistress Sassz'ine
		[115795] = 1, -- Abyss Stalker
		[115902] = 4, -- Razorjaw Waverunner

		-- The Desolate Host
		[118715] = 2, -- Reanimated Templar
		[118728] = 1, -- Ghastly Bonewarden
		[118730] = 7, -- Soul Residue
		[118729] = "PRIEST", -- Fallen Priestess

		-- Maiden of Vigilance

		-- Fallen Avatar
		[117264] = 3, -- Maiden of Valor

		-- Kil'jaeden
		[119206] = 6, -- Erupting Reflection
		[119107] = 4, -- Wailing Reflection
	}
}

db[1188] = { zone = 946, -- Antorus, the Burning Throne
	category = 755,
	order = {
		"h\\-", 123480, -- trash
		--"h\\1992", -- Garothi Worldbreaker
		"h\\1987", 122135, -- Felhounds of Sargeras
		"h\\1997", 122718, 122890, 128069, -- Antoran High Command
		"h\\1985", 122783, 123702, 123223, 122897, -- Portal Keeper Hasabel
		"h\\2025", 123760, 124207, 124227, 123726, -- Eonar the Life-Binder
		-- "h\\2009", -- Imonar the Soulhunter
		-- "h\\2004", -- Kin'garoth
		"h\\1983", "16350", -- Varimathras
		"h\\1986", 122467, 122469, 125436, "16430", "16431", "16432", "16433", -- The Coven of Shivarra
		"h\\1984", 122532, 121985, -- Aggramar
		"h\\2031", 127809, -- Argus the Unmaker
	},
	flags = {

	},
	recolor = {
		-- Trash
		[123480] = 1, -- Antoran Champion

		-- Garothi Worldbreaker

		-- Felhounds of Sargeras
		[122135] = "WARLOCK", -- Shatug

		-- Antoran High Command
		[122718] = "WARRIOR", -- Felblade Shocktrooper
		[122890] = "MAGE", -- Fanatical Pyromancer
		[128069] = 4, -- Screaming Shrike (Mythic)

		-- Portal Keeper Hasabel
		[122783] = 6, -- Blazing Imp
		[123702] = 1, -- Feltouched Skitterer
		[123223] = "WARLOCK", -- Hungering Stalker
		[122897] = 4, -- Felsilk Web

		-- Eonar the Life-Binder
		[123760] = 1, -- Fel-Infused Destructor
		[124207] = 3, -- Fel-Charged Obfuscator
		[124227] = 4, -- Volant Kerapteron
		[123726] = 2, -- Fel-Powered Purifier

		-- The Coven of Shivarra
		--[122468] = "WARRIOR", -- Noura, Mother of Flames
		[122467] = "WARLOCK", -- Asara, Mother of Night
		[122469] = "MAGE", -- Diima, Mother of Gloom
		[125436] = 1, -- Thu'raya, Mother of the Cosmos (Mythic)
		["16430"] = 4, -- Torment of Aman'Thul
		["16431"] = 4, -- Torment of Khaz'goroth
		["16432"] = 4, -- Torment of Golganneth
		["16433"] = 6, -- Torment of Norgannon

		-- Varimathras
		["16350"] = 6, -- Shadow of Varimathras (Mythic)

		-- Aggramar
		[122532] = 4, -- Ember of Taeshalach
		[121985] = 1, -- Flame of Taeshalach

		-- Argus the Unmaker
		[127809] = 4, -- Reorigination Module

	},
}

-------------------------------------------------------------------------------
-- Battle for Azeroth
-------------------------------------------------------------------------------

db["map934"] = { zone = 968, -- Atal'Dazar
	group = 275,
	category = 801,
	order = {
		"h\\2082", 131009, -- Priestess Alun'za
		"h\\2036", 125977, -- Vol'kaal
		"h\\2083", 129517, -- Rezan
		"h\\2030", 125828, -- Yazma
	},
	flags = {
		["*"] = {
			[122967] = 0x0020 + 0x1800,
			[122965] = 0x0020,
			[122963] = 0x0020,
			[122968] = 0x0020 + 0xD800,
		},
	},
	recolor = {
		[122970] = "ROGUE", -- Shadowblade Stalker
		[127315] = 4, -- Reanimation Totem
		[127757] = 1, -- Reanimated Honor Guard
		[122969] = "WARLOCK", -- Zanchuli Witch-Doctor
		[122973] = "PRIEST", -- Dazar'ai Confessor
		[125977] = 4, -- Reanimation Totem(Vol'kaal)
		[128435] = 7, -- Toxic Saurid
		[129552] = 2, -- Monzumi
		[122971] = "WARRIOR", -- Dazar'ai Juggernaut
		[122972] = 2, -- Dazar'ai Augur
		[132126] = 3, -- Gilded Priestess
		[131009] = 4, -- Spirit of Gold
		[129517] = 2, -- Reanimated Raptor
		[125828] = 4, -- Soulspawn
	}
}

db["map936"] = { zone = 1001, -- Freehold
	category = 802,
	order = {
		"h\\2102", 129602, 126928, 129788, -- Skycap'n Kragg
		"h\\2093", 127111, 129559, 130404, 130024, 129550, 129600, 129527, 126848, 126845, 130896, -- Council o' Captains
		"h\\2094", 129547, 129601, 130400, -- Ring of Booty
		"h\\2095", 126919, 130012, 127106, 129758, -- Harlan Sweete
	},
	flags = {
		["*"] = {
			[126832] = 0x0020,
			[126847] = 0x0020,
			[126848] = 0x0020,
			[126845] = 0x0020,
			[126969] = 0x0020,
			[126983] = 0x0020,
		},
	},
	recolor = {
		[129602] = 2, -- Irontide Enforcer
		[126928] = 1, -- Irontide Corsair
		[129788] = 3, -- Irontide Bonesaw

		[127111] = "WARLOCK", -- Irontide Oarsman
		[129559] = "WARRIOR", -- Cutwater Duelist
		[130404] = "HUNTER", -- Vermin Trapper
		[130024] = 5, -- Soggy Shiprat
		[129550] = 2, -- Bilge Rat Padfoot
		[129600] = "MAGE", -- Bilge Rat Brinescale
		[129527] = "DRUID", -- Bilge Rat Buccaneer
		[126848] = 1, -- Captain Eudora
		[126845] = 2, -- Captain Jolly
		[130896] = 4, -- Blackout Barrel

		[129547] = "WARRIOR", -- Blacktooth Knuckleduster
		[129601] = 1, -- Cutwater Harpooner
		[130400] = 2, -- Irontide Crusher

		[126919] = "SHAMAN", -- Irontide Stormcaller
		[130012] = 1, -- Irontie Ravager
		[127106] = 2, -- Irontide Officer
		[129758] = 4, -- Irontide Grenadier
	}
}

db["map1004"] = { zone = 1041, -- King's Rest
	category = 803,
	order = {
		"h\\2165", 133943, 134174, 134158, 135406, -- The Golden Serpent
		"h\\2171", 137484, 134331, 134251, 137486, 137474, 137989, 136264, -- Mchimba the Embalmer
		"h\\2170", 135204, 135239, 137591, 135192, 135759, 135761, 135764, 135765, -- The Council of Tribes
		"h\\2172", 136984, 136976, -- Dazar, The First King
	},
	flags = {
		["*"] = {
			[135322] = 0x0020,
			[134993] = 0x0020,
			[135475] = 0x0020,
			[135470] = 0x0020,
			[135472] = 0x0020,
			[136160] = 0x0020,
		},
	},
	recolor = {
		[133943] = 6, -- Minion of Zul
		[134174] = "WARLOCK", -- Shadow-Borne Witch Doctor
		[134158] = 2, -- Shadow-Borne Champion
		[135406] = 6, -- Animated Gold
		[137484] = 1, -- King A'akul
		[134331] = 2, -- King Rahu'ai
		[134251] = 3, -- Seneschal M'bara
		[137486] = 1, -- Queen Patlaa
		[137474] = "WARRIOR", -- King Timalji
		[137989] = 2, -- Embalming Fluid
		[136264] = 4, -- Half-Finished Mummy
		[135204] = 1, -- Spectral Hex Priest
		[135239] = 3, -- Spectral Witch Doctor
		[137591] = 4, -- Healing Tide Totem
		[135192] = 1, -- Honored Raptor
		[135759] = {1, 0.5, 0, 1}, -- Earthwall Totem
		[135761] = 6, -- Thundering Totem
		[135764] = 4, -- Explosive Totem
		[135765] = {0, 0.5, 1, 1}, -- Torrent Totem
		[136984] = 1, -- Reban
		[136976] = 2, -- T'zala
	}
}

db["map1039"] = { zone = 1036, -- Shrine of the Storm
	group = 281,
	category = 804,
	order = {
		"h\\2153", 136186, 134139, 134173, 134144, 134612, -- Aqu'sirr
		"h\\2154", 136347, 136214, 139799, 134150, 134063, -- Tidesage Council
		"h\\2155", 134417, 139626, 134423, 134514, -- Lord Stormsong
		"h\\2156", 136297, 136083, 135903, -- Vol'zith the Whisperer
	},
	flags = {
		["*"] = {
			[134056] = 0x0020,
			[134058] = 0x0020 + 0x0800,
			[134063] = 0x0020 + 0x4800,
			[134060] = 0x0020 + 0x0800,
			[134069] = 0x0020 + 0x7800,
			[134173] = 0x0001,
			[135903] = 0x0001 + 0x0004,
		},
	},
	recolor = {
		[136186] = 3, -- Tidesage Spiritualist
		[134139] = 1, -- Shrine Templar
		-- [134173] = 5, -- Animated Droplet
		[134144] = "MAGE", -- Living Current
		[134612] = 4, -- Grasping Tentacles
		[136347] = 7, -- Tidesage Initiate
		[136214] = 1, -- Windspeaker Heldis
		[139799] = "WARRIOR", -- Ironhull Apprentice
		[134150] = 2, -- Runecarver Sorn
		[134063] = "WARRIOR", -- Brother Ironhull
		[134417] = "WARLOCK", -- Deepsea Ritualist
		[139626] = 5, -- Dredged Sailor
		[134423] = 6, -- Abyss Dweller
		[134514] = 1, -- Abyssal Cultist
		[136297] = 2, -- Forgotten Denizen
		[136083] = 2, -- Forgotten Denizen
		[135903] = 1, -- Manifestation of the Deep
	},
	auras = {
		{id = "map1039:268212", spellID = 268212, buff = true, enlarge = false, emphasize = true, color = "MONK"}, -- Minor Reinforcing Ward
		{id = "map1039:268183", spellID = 268183, buff = true, enlarge = false, emphasize = true, color = 1}, -- Minor Swiftness Ward
		-- {id = "e2131:267890", spellID = 267890, buff = true, enlarge = false, emphasize = true, color = 1, encounterID = 2131}, -- Swiftness Ward
		{id = "e2131:267890", spellID = 268186, buff = true, enlarge = false, emphasize = true, color = "MONK", encounterID = 2131}, -- Reinforcing Ward
		{id = "e2131:267901", spellID = 267901, buff = true, enlarge = true, emphasize = true, color = 4, encounterID = 2131}, -- Blessing of Ironsides
	},
}

db["map1162"] = { zone = 1023, -- Siege of Boralus
	category = 805,
	order = {
		"h\\2132", 138002, 133990, 141495, 141282, 141565, 129370, 141284, 129369, 129371, 129640, 129372, "17727", "17764", "17725", "17762", -- Chopper Redhook
		"h\\2133", 141284, "17764", -- Sergeant Bainbridge
		"h\\2173", 128969, 137517, 138247, 135258, 135263, 138255, 141939, "18232", -- Dread Captain Lockwood
		"h\\2134", 129366, 135245, 129367, 137516, 128967, 144170, -- Hadal Darkfathom
		"h\\2140", "18340", "18334", -- Viq'Goth
	},
	flags = {
		["*"] = {
			[128650] = 0x0020,
			[128649] = 0x0020,
			[129208] = 0x0020 + 0x3800,
			[128651] = 0x0020 + 0x0800,
			[128652] = 0x0020,
		},
	},
	recolor = {
		[138002] = 7, -- Scrimshaw Gutter
		[133990] = 7, -- Scrimshaw Gutter
		[141495] = 7, -- Kul Tiran Footman
		[141282] = 7, -- Kul Tiran Footman
		[141565] = 7, -- Kul Tiran Footman
		[129370] = 3, -- Irontide Waveshaper
		[141284] = 3, -- Kul Tiran Wavetender
		[129369] = "WARRIOR", -- Irontide Raider
		[129371] = "ROGUE", -- Riptide Shredder
		[129640] = 2, -- Snarling Dockhound
		[129372] = "DRUID", -- Blacktar Bomber
		["17727"] = 7, -- Irontide Powdershot
		["17764"] = 7, -- Kur Tiran Marksman
		["17725"] = 2, -- Irontide Cleaver
		["17762"] = 2, -- Kul Tiran Vanguard
		[141284] = 3, -- Kul Tiran Wavetender
		["17764"] = 7, -- Kul Tiran Marksman
		[128969] = 2, -- Ashvane Commander
		[137517] = 1, -- Ashvane Destroyer
		[138247] = 7, -- Irontide Marauder
		[135258] = 7, -- Irontide Marauder
		[135263] = "WARLOCK", -- Ashvane Spotter
		[138255] = "WARLOCK", -- Ashvane Spotter
		[141939] = "WARLOCK", -- Ashvane Spotter
		-- [141939] = "WARLOCK", -- Ashvane Spotter
		["18232"] = 2, -- Ashvane Cannoneer
		-- [129366] = 1, -- Bilge Rat Buccaneer
		[135245] = "DRUID", -- Bilge Rat Demolisher
		[129367] = 3, -- Bilge Rat Tempest
		-- [137516] = 1, -- Ashvane Invader
		[128967] = "HUNTER", -- Ashvane Sniper
		[144170] = "HUNTER", -- Ashvane Sniper
		["18340"] = "DRUID", -- Demolishing Terror
		-- ["18334"] = 2, -- Gripping Terror
	},
	auras = {
		{id = "map1162:256957", spellID = 256957, buff = true, emphasize = true, color = 8}, -- Watertite Shell
	},
}

db["map1038"] = { zone = 1030, -- Temple of Sethraliss
	group = 283,
	category = 806,
	order = {
		"h\\2142", 134616, 134990, 134991, 133944, 134602, -- Adderis and Aspix
		"h\\2143", 134686, 134364, 134388, -- Merektha
		"h\\2144", 136076, -- Galvazzt
		"h\\2145", 135971, 139949, 137204, 137233, "18295",-- Avater of Sethraliss
	},
	flags = {
		["*"] = {
			[133379] = 0x0020 + 0x2800,
			[133944] = 0x0020 + 0xB800,
			[133384] = 0x0020,
			[133389] = 0x0020 + 0xB800,
			[135971] = 0x0001 + 0x0002, -- Faithless Conscript
		},
	},
	recolor = {
		[134616] = 7, -- Krolusk Pup
		[134990] = 3, -- Charged Dust Devil
		[134991] = "WARRIOR", -- Sandfury Stonefist
		[134602] = "ROGUE", -- Shrouded Fang
		[133944] = 2, -- Aspix
		[134686] = 2, -- Mature Krolusk
		[134364] = "PRIEST", -- Faithless Tender
		[134388] = 4, -- A Knot of Snakes
		[136076] = 1, -- Agitated Nimbus
		[135971] = 7, -- Faithless Conscript
		["18295"] = 2, -- Plague Doctor
		[137204] = 4, -- Hoodoo Hexer
		[137233] = 5, -- Plague Toad
	},
	auras = {
		{id = "e2124:263246", spellID = 263246, buff = true, enlarge = true, emphasize = true, color = 4, encounterID = 2124}, -- Lightning Shield
		{id = "map1038:269129", spellID = 269129, buff = true, enlarge = false, emphasize = true, color = 6}, -- Accumulated Charge
		{id = "map1038:269896", spellID = 269896, buff = true, enlarge = false, emphasize = true, color = 2}, -- Embryonic Vigor
	},
}

db["map1010"] = { zone = 1012, -- The MOTHERLODE!!
	category = 807,
	order = {
		"h\\2109", 136470, 130488, 130435, 136139, 134232, -- Coin-Operated Crowd Pummeler
		"h\\2114", 130437, 130661, 136643, 134005, 134012, 129802, -- Azerokk
		"h\\2115", 133345, 133432, 133430, 136934, 133963, -- Rixxa Fluxflame
		"h\\2116", 133593, 133482, 137029, 133463, 132056, -- Mogul Razdunk
	},
	flags = {
		["*"] = {
			[129214] = 0x0020 + 0xB800,
			[129227] = 0x0020 + 0x3800,
			[129231] = 0x0020 + 0x0800,
			[129232] = 0x0020,
		},
	},
	recolor = {
		[136470] = 3, -- Refreshment Vendor
		[130488] = "DRUID", -- Mech Jockey
		[130435] = 2, -- Addled Thug
		[136139] = 1, -- Mechanized Peacekeeper
		[134232] = "ROGUE", -- Hired Assassin
		[130437] = 7, -- Mine Rat
		[130661] = 3, -- Venture Co. Earthshaper
		[136643] = 1, -- Azerite Extractor
		[134005] = 7, -- Shalebiter
		[134012] = "WARRIOR", -- Taskmaster Askari
		[129802] = 2, -- Earthrager
		[133345] = 3, -- Feckless Assistant
		[133432] = 1, -- Venture Co. Alchemist
		-- [133430] = 2, -- Venture Co. Mastermind
		-- [133963] = 7, -- Test Subject
		[136934] = "WARRIOR", -- Weapons Tester
		[133593] = 3, -- Expert Technician
		[133482] = 6, -- Crawler Mine
		[137029] = "DEMONHUNTER", -- Ordnance Specialist
		[133463] = 2, -- Venture Co. War Machine
		[132056] = 3, -- Venture Co. Skyscorcher(Mogul Razdunk)
	}
}

db["map1041"] = { zone = 1022, -- The Underrot
	group = 282,
	category = 808,
	order = {
		"h\\2157", 131402, 131436, 131492, 133685, 134701, -- Elder Leaxa
		"h\\2131", 130909, 133870, 133835, 132051, -- Cragmaw the Infested
		"h\\2130", 138187, 134284, -- Sporecaller Zancha
		"h\\2158", 138281, 133912, 137103, 137458, -- Unbound Abomination
	},
	flags = {
		["*"] = {
			[131318] = 0x0020,
			[131817] = 0x0020 + 0x3800,
			[131383] = 0x0020 + 0x4800,
			[133007] = 0x0020 + 0x1800,
		},
	},
	recolor = {
		[131402] = 7, -- Underrot Tick
		[131436] = 1, -- Chosen Blood Matron
		[131492] = "PRIEST", -- Devout Blood Priest
		[133685] = 2, -- Befouled Spirit
		[134701] = 4, -- Blood Effigy
		[130909] = "DEMONHUNTER", -- Fetid Maggot
		[133870] = 2, -- Diseased Lasher
		[133835] = 1, -- Feral Bloodswarmer
		[132051] = 7, -- Blood Tick
		[138187] = 2, -- Grotesque Horror
		[134284] = "DRUID", -- Fallen Deathspeaker
		[138281] = 1, -- Faceless Corruptor
		[133912] = "WARLOCK", -- Bloodsworn Defiler
		[135169] = 4, -- Spirit Drain Totem
		[137103] = "DEMONHUNTER", -- Blood Visage
		[137458] = 6, -- Rotting Spore
	},
	auras = {
		{id = "map1041:265091", spellID = 265091, buff = true, emphasize = true, color = 8}, -- Gift of G'huun
	},
}

db["map974"] = { zone = 1002, -- Tol Dagor
	group = 277,
	category = 809,
	order = {
		"h\\2097", 127480, 131785, -- The Sand Queen
		"h\\2098", 130025, 135706, 127485, 130026, 130655, -- Jes Howlis
		"h\\2099", 135699, 127486, -- Knight Captain Valyri
	},
	flags = {
		["*"] = {
			[127479] = 0x0020,
			[127484] = 0x0020,
			[127490] = 0x0020,
			[127503] = 0x0020,
		},
	},
	recolor = {
		[127480] = 7, -- Stinging Parasite
		[131785] = 2, -- Buzzing Drone
		[130025] = 1, -- Irontide Thug
		[135706] = 7, -- Bilge Rat Looter
		[127485] = 7, -- Bilge Rat Looter
		[130026] = 1, -- Bilge Rat Seaspeaker
		[130655] = "WARRIOR", -- Bobby Howlis
		[135699] = 2, -- Ashvane Jailer
		[127486] = 2, -- Ashvane Officer
	}
}

db["map1015"] = { zone = 1021, -- Waycrest Manor
	group = 279,
	category = 810,
	order = {
		"h\\2125", 135240, 131685, 131677, 135474, 131823, 131824, -- Heartsbane Triad
		"h\\2126", 135049, 131818, 131812, 131587, 131669, 131666, 135329, 136330, -- Soulbound Goliath
		"h\\2127", 134024, 142587, 131847, 137830, 131586, 133361, 136541, -- Raal the Gluttonous
		"h\\2128", 131731, 131617, 135365, 131545, -- Lord and Lady Waycrest
		"h\\2129", 135552, -- Gorak Tul
	},
	flags = {
		["*"] = {
			[131823] = 0x0020,
			[131824] = 0x0020,
			[131825] = 0x0020,
			[131667] = 0x0020,
			[131863] = 0x0020,
			[131527] = 0x0020,
			[131545] = 0x0020,
			[131864] = 0x0020 + 0x0800,
			[136330] = 0x0001 + 0x0010, -- Soul Thorns
			[136541] = 0x0001,
		},
	},
	recolor = {
		[135240] = 7, -- Soul Essence
		[131685] = 2, -- Runic Disciple
		[131677] = 1, -- Heartsbane Runeweaver
		[135474] = 3, -- Thistle Acolyte
		[131823] = 1, -- Sister Malady
		[131824] = 2, -- Sister Solena
		-- [135049] = 3, -- Dreadwing Raven
		[131818] = "WARLOCK", -- Marked Sister
		[131812] = "PRIEST", -- Heartsbane Soulcharmer
		[131587] = 1, -- Bewitched Captain
		[131669] = 7, -- Jagged Hound
		[131666] = 3, -- Coven Thornshaper
		[135329] = "DRUID", -- Matron Bryndle
		[136330] = 4, -- Soul Thorns
		[134024] = 7, -- Devouring Maggot
		[142587] = 7, -- Devouring Maggot
		[131847] = 7, -- Waycrest Reveler
		[137830] = 1, -- Pallid Gorger
		[131586] = 2, -- Banquet Steward
		[133361] = 4, -- Wasting Servant
		[136541] = 6, -- Bile Oozeling
		[131731] = 7, -- Sown Lasher
		[131617] = 1, -- Groundskeeper Lilith
		[135365] = 2, -- Matron Alma
		[131545] = 2, -- Lady Waycrest
		[135552] = 1, -- Deathtouched Slaver
	},
	auras = {
		{id = "e2113:260805", spellID = 260805, buff = true, enlarge = true, emphasize = true, color = 4, encounterID = 2113}, -- Focusing Iris
		{id = "map1015:264027", spellID = 264027, buff = true, enlarge = false, emphasize = true, color = "MONK"}, -- Warding Candles
	},
}

db["map1490"] = { zone = 1178, -- Operation: Mechagon
	group = 399,
	category = 811,
	order = {
		"h\\2357", 153196, "20128",
		"h\\2358", 153377,
		"h\\2360", 153755,
		-- "h\\2355",
		"h\\2336", 151658, 151657, 145185,
		"h\\2339", 144301, 144246,
		"h\\2348", 144298, 144294, 144295, 151613, 151579,
		-- "h\\2331",
	},
	flags = {
		["*"] = {
			[150159] = 0x0020,
			[153377] = 0x0020,
			[153755] = 0x0020,
			[150712] = 0x0020,
			[150190] = 0x0020,
			[150295] = 0x0020,
			[144244] = 0x0020,
			[145185] = 0x0020,
			[144246] = 0x0020,
			[144248] = 0x0020,
			[150397] = 0x0020,
			[150396] = 0x0020,
			[144249] = 0x0020,
			[150397] = 0x0020,
			[151613] = 0x0040 + 0x0010, -- Anti-Personnel Squirrel
		},
	},
	recolor = {
		-- trash
		[150547] = 7, -- Scrapbone Grunter
		[150146] = "WARLOCK", -- Scrapbone Shaman
		[150142] = "HUNTER", -- Scrapbone Trashtosser
		[150160] = 2, -- Scrapbone Bully
		[152703] = "DEATHKNIGHT", -- Walkie Shockie X1
		[150250] = "HUNTER", -- Pistonhead Blaster
		[150251] = 3, -- Pistonhead Mechanic
		[150276] = "WARRIOR", -- Heavy Scrapbot
		[150297] = 1, -- Mechagon Renormalizer
		[155090] = 2, -- Anodized Coilbearer
		[150292] = "DEMONHUNTER", -- Mechagon Cavalry
		[154663] = 5, -- Gnome-Eating Droplet
		[150169] = "WARLOCK", -- Toxic Lurker
		[150253] = "DRUID", -- Weaponized Crawler


		-- King Gobbamak
		[153196] = 7, -- Scrapbone Grunter
		["20128"] = 1, -- Stolen Scrapbot

		-- Gunker
		[153377] = 4, -- Goop

		-- Trixie and Naeno
		[153755] = 2, -- Naeno Megacrash

		-- HK-8

		-- Tussle Tonk
		[151658] = 1, -- Strider Tonk
		[151657] = 3, -- Bomb Tonk
		[145185] = 2, -- Gnomercy 4.U.

		-- K.U.-J.0.
		[144301] = "DEMONHUNTER", -- Living Waste
		-- [144246] =

		-- Mechanist's Garden
		[144298] = 1, -- Defense Bot Mk III
		[144294] = "WARLOCK", -- Mechagon Tinkerer
		[144295] = 3, -- Mechagon Mechanic
		[151613] = 4, -- Anti-Personnel Squirrel
		[151579] = "PRIEST", -- Shield Generator
		[152033] = 6, -- Inconspicuous Plant

		-- King Mechagon
		-- [150396] = 1, -- Aerial Unit R-21/X

	},
	auras = {
	},
}

db["map1148"] = { zone = 1031, -- Uldir
	group = 384,
	category = 851,
	order = {
		"h\\-", -- trash
		"h\\2168", 138959, 138530, -- Taloc
		"h\\2167", 136315, -- MOTHER
		"h\\2146", 133492, -- Fetid Devourer
		"h\\2169", 134503, 135824, 135083, -- Zek'voz, Herald of N'zoth
		"h\\2166", 135016, -- Vectis
		"h\\2195", 139059, 139057, 139051, 139195, -- Zul, Reborn
		"h\\2194", 139381, 139487, -- Mythrax the Unraveler
		"h\\2147", "18122", "18828", "18101", 134590, 134010, -- G'huun
	},
	flags = {
		["2167"] = {
			[135452] = 0x0800, -- MOTHER
		},
		["2146"] = {
			[133298] = 0x2800, -- Fetid Devourer
		},
		["2195"] = {
			[139051] = 0x2800, -- Nazmani Crusher
		},
	},
	recolor = {
		-- Taloc
		[138959] = 2, -- Coalesced Blood
		[138530] = 6, -- Volatile Droplet

		-- MOTHER
		[136315] = 1, -- Remnant of Corruption

		-- Fetid Devourer
		[133492] = 4, -- Corruption Corpuscle

		-- Zek'voz, Herald of N'zoth
		[134503] = 6, -- Silithid Warrior
		[135824] = "WARLOCK", -- Nerubian Voidweaver
		[135083] = 2, -- Guardian of Yogg-Saron

		-- Vectis
		[135016] = 3, -- Plague Amalgam

		-- Zul, Reborn
		[139059] = 7, -- Bloodthirsty Crawg
		[139057] = 3, -- Nazmani Bloodhexer
		[139051] = 2, -- Nazmani Crusher
		[139195] = 4, -- Animated Ichor

		-- Mythrax the Unraveler
		[139381] = 2, -- N'raqi Destroyer
		[139487] = 1, -- Vision of Madness

		-- G'huun
		["18122"] = 6, -- Amorphous Cyst
		["18828"] = 1, -- Cyclopean Terror
		["18101"] = 2, -- Dark Young
		[134590] = 4, -- Blightspreader Tendril
		[134010] = "DRUID", -- Gibbering Horror
	},
}

db["map1352"] = { zone = 1176, -- Battle of Dazar'alor
	group = 396,
	category = 852,
	order = {
		"h\\2344",  -- Champion of the Light
		"h\\"..PLAYER_FACTION_COLORS[1]:WrapTextInColorCode(_G.FACTION_ALLIANCE), 147895, 147896,
		"h\\"..PLAYER_FACTION_COLORS[0]:WrapTextInColorCode(_G.FACTION_HORDE), 145898, 145903,
		"h\\2323", "19423", -- Jadefire Masters
		"h\\"..PLAYER_FACTION_COLORS[1]:WrapTextInColorCode(_G.FACTION_ALLIANCE), 144692, 147374, 147069,
		"h\\"..PLAYER_FACTION_COLORS[0]:WrapTextInColorCode(_G.FACTION_HORDE), 144693, 147376, 147098,
		"h\\2325", -- Grong
		"h\\"..PLAYER_FACTION_COLORS[1]:WrapTextInColorCode(_G.FACTION_ALLIANCE), 144998,
		"h\\"..PLAYER_FACTION_COLORS[0]:WrapTextInColorCode(_G.FACTION_HORDE), 144876,
		"h\\2342", 147218, -- Opulence
		"h\\2330", 144747, 144963, 144941, "19019", -- Conclave of the Chosen
		"h\\2335", 146320, 146322, "19180", 146491, 146492, "19434", 146731, -- King Rastakhan
		"h\\2334", 144942, -- High Tinker Mekkatorque
		"h\\2337", 146436, 146756, -- Stormwall Blockade
		"h\\2343", "19561", 148522, 148631, 149144, 148907, -- Lady Jaina Proudmoore
	},
	flags = {
		["2344"] = {
			[144683] = 0x0800, -- Ra'wani Kanae
		},
		["2323"] = {
			[144691] = 0x2800, -- Ma'ra Grimfang
		},
		["2340"] = {
			[144638] = 0x6800, -- Grong the Revenant
		},
		["2342"] = {
			[145261] = 0x0800, -- Opulence
		},
		["2330"] = {
			[144963] = 0x1800, -- Kimbul's Aspect
			[144941] = 0xB800, -- Akunda's Aspect
			[148962] = 0x0040, -- Ravenous Stalker
			[144807] = 0x0040, -- Ravenous Stalker
		},
		["2337"] = {
			[146436] = 0x0040, -- Tempting Siren
		},
		["2343"] = {
			[148631] = 0x0014,
			[148907] = 0x0014,
			[146409] = 0x2800, -- Lady Jaina Proudmoore
		},
	},
	recolor = {
		[147497] = 1, -- Prelate Akk'al
		[147498] = 2, -- Prelate Jakit
		[147835] = "DEMONHUNTER", -- Rastari Alpha
		[147829] = 1, -- Rastari Beastmaster
		[147868] = 7, -- Frenzied Saurid
		[148118] = 1, -- Caravan Brutosaur
		[148119] = 2, -- Furious Merchant
		[148200] = 7, -- Restless Bones
		[148221] = 2, -- Risen Hulk
		[148195] = "WARLOCK", -- Hateful Shade
		[148488] = 2, -- Unliving Augur
		[148483] = "WARRIOR", -- Ancestral Avenger
		[149569] = 7, -- Dazari Worshipper
		[148617] = 2, -- Akunda the Devout
		[147830] = "MAGE", -- Rastari Flamespeaker
		-- [148619] = 1, -- Echo of Akunda
		[148443] = 1, -- Defense-A-Bot
		[148665] = "ROGUE", -- Rastari Royal Guard
		[148673] = "WARLOCK", -- Vessel of Bwonsamdi

		-- Champion of the Light [A]
		[147895] = "PRIEST", -- Rezani Disciple
		[147896] = "PALADIN", -- Zandalari Crusader

		-- Champion of the Light [H]
		[145898] = "PRIEST", -- Anointed Disciple
		[145903] = "PALADIN", -- Darkforged Crusader

		-- Jadefire Masters [A]
		["19423"] = 4, -- Living Bomb
		[144692] = "MAGE", -- Anathos Firecaller
		[147374] = 1, -- Barrier
		[147069] = "DRUID", -- Spirit of Xuen

		-- Jadefire Masters [H]
		[144693] = "MAGE", -- Manceroy Flamefist
		[147376] = 1, -- Barrier
		[147098] = "DRUID", -- Spirt of Xuen

		-- Grong, the Revenant [A]
		[144998] = 1, -- Death Specter

		-- Grong, the Revenant [H]
		[144876] = 1, -- Apetagonizer 3000

		-- Opulence
		[147218] = 6 , -- Spirit of Gold

		-- Conclave of the Chosen
		[144747] = 1, -- Pa'ku's Aspect
		[144963] = 2, -- Kimbul's Aspect
		[144941] = "SHAMAN", -- Akunda's Aspect
		["19019"] = 4, -- Ravenous Stalker

		-- King Rastakhan
		[146320] = 1, -- Prelate Za'lan
		[146322] = 2, -- Siegebreaker Roka
		["19180"] = 3, -- Headhunter Gal'wana
		[146491] = 1, -- Phantom of Retribution
		[146492] = 2, -- Phantom of Rage
		["19434"] = 3, -- Phantom of Slaughter
		[146731] = 4, -- Zombie Dust Totem

		-- High Tinker Mekkatorque
		[144942] = 6, -- Spark Bot

		-- Stormwall Blockade
		[146436] = 4, -- Tempting Siren
		[146756] = 4, -- Energized Storm

		-- Lady Jaina Proudmoore
		["19561"] = 2, -- Kul Tiran Marine
		[148522] = "DRUID", -- Ice Block
		-- [148631] = "DEMONHUNTER", -- Unexploded Ordnance
		[149144] = 1, -- Jaina's Tide Elemental
		[148907] = 4, -- Prismatic Image
	},
	auras = {
		{id = "e2265:284436", spellID = 284436, buff = true, enlarge = true, emphasize = true, color = 4, encounterID = 2265}, -- Seal of Reckoning
		{id = "e2268:282098", spellID = 282098, buff = true, emphasize = true, color = "MONK", encounterID = 2268}, -- Gift of Wind
		{id = "e2268:290570", spellID = 290570, buff = true, emphasize = true, color = "MONK", encounterID = 2268}, -- Gift of Wind (LFR)
		{id = "e2281:288219", spellID = 288219, buff = true, emphasize = true, color = 1, encounterID = 2281}, -- Refractive Ice
	},
}

db["map1345"] = { zone = 1177, -- Crucible of Storms
	group = 393,
	category = 853,
	order = {
		"h\\-", 151098, 151068, 151059, 151056, -- trash
		"h\\2328", "19059", "19060", 144755, -- The Restless Cabal
		"h\\2332", 146940, 146945, 146829, -- Uu'nat, Harbinger of the Void
	},
	flags = {
		["2332"] = {
			[145371] = 0x0800, -- Uu'nat
		},
	},
	recolor = {
		-- [151098] = 1, -- Shadowy Appendage
		[151068] = "PRIEST", -- Tentacled Voidpriest
		[151059] = 1, -- Eternal Guardian
		[151056] = 2, -- Varanq'ul the Mighty

		-- The Restless Cabal
		["19059"] = 6, -- Visage from Beyond
		["19060"] = 1, -- Eldritch Abomination
		[144755] = "WARLOCK", -- Zaxasj the Speaker

		-- Uu'nat, Harbinger of the Void
		[146940] = 3, -- Primordial Mindbender
		[146945] = 7, -- Swarming Voidspawn
		[146829] = 1, -- Undying Guardian
	},
	auras = {
		-- {id = "e2273:287692", spellID = 287692, buff = true, enlarge = false, emphasize = true, color = 4, encounterID = 2273}, -- Sightless Bond
		{id = "e2273:286310", spellID = 286310, buff = true, enlarge = true, emphasize = true, color = "PRIEST", encounterID = 2273}, -- Void Shield
	},
}

db["map1512"] = { zone = 1179, -- The Eternal Palace
	group = 400,
	category = 854,
	order = {
		"h\\-", 155618, 155616, 155920, 155919, 155899, 155900, 155859, 155628, 155272, 155791, 155873,
		-- "h\\2352", -- Abyssal Commander Sivara
		"h\\2347", 150773, -- Blackwater Behemoth
		"h\\2353", 152816, 152512, -- Radiance of Azshara
		"h\\2354", 153194, -- Lady Ashvane
		"h\\2351", 152159, 152313, 152312, -- Orgozoa
		"h\\2359", 152852, 153335, -- The Queen's Court
		"h\\2349", "20172", 151581, -- Za'qul, Harbinger of Ny'alotha
		"h\\2361", 152910, 153059, 153064, 155845, 154240, 155354, 153091, 153090, 154565, -- Queen Azshara
	},
	flags = {
		["2361"] = {
			[155845] = 0x0010,
			[154240] = 0x0010,
			[155354] = 0x0010,
		},
	},
	recolor = {
		-- Trash
		[155618] = 1, -- Zanj'ir Huntress
		[155616] = 2, -- Zanj'ir Brute
		[155920] = "WARRIOR", -- Azsh'ari Galeblade
		[155919] = 4, -- Stormling
		[155899] = 1, -- Sak'ja
		[155900] = 1, -- Zsal'iss
		[155859] = 1, -- Vizja'ra
		[155628] = 3, -- Azsh'ari Oracle
		[155272] = "DRUID", -- Blackwater Oracle
		[155791] = "WARLOCK", -- Horrific Shrieker
		[155873] = 1, -- Darkcast Annihilator

		-- Blackwater Behemoth
		[150773] = "ROGUE", -- Shimmerskin Pufferfish

		-- Radiance of Azshara
		[152816] = 1, -- Stormling
		[152512] = "PRIEST", -- Stormwraith

		-- Lady Ashvane
		[153194] = 6, -- Briny Bubble

		-- Orgozoa
		[152159] = 2, -- Zoatroid
		[152313] = 1, -- Dreadcoil Hulk
		[152312] = "SHAMAN", -- Azsh'ari Witch

		-- The Queen's Court
		[152852] = 1, -- Pashmar the Fanatical
		[153335] = 4, -- Potent Spark

		-- Za'qul, Harbinger of Ny'alotha
		["20172"] = 4, -- Horrific Summoner
		[151581] = 1, -- Horrific Vision

		-- Queen Azshara
		-- [152910] = "MAGE", -- Queen Azshara
		[153059] = 1, -- Aethanel
		[153064] = 2, -- Overzealous Hulk
		[155845] = 4, -- Crushing Depths
		[154240] = {1, 0.9, 0.9, 1}, -- Azshara's Devoted
		[155354] = {1, 0.9, 0.9, 1}, -- Azshara's Indomitable
		[153091] = "DRUID", -- Serena Scarscale
		[153090] = "DRUID", -- Lady Venomtongue
		[154565] = 1, -- Loyal Myrmidon
	},
	auras = {
	},
}

db["map1581"] = { zone = 1180, -- Ny'alotha, the Waking City
  group = 407,
	category = 855,
	order = {
		"h\\-", 159303, 159305, 159425, 159219, 159417, 160183, 160182, 159405, 162718, 162716, 162719, 162306, 162664, 162303, 161217, 161218, 161173, 159767, 159510, 161335, 161312, 162828,
		"h\\2368", 158327, -- Wrathion, the Black Emperor
		"h\\2365", 156650,-- Maut
		"h\\2369", 158781, -- The Prophet Skitra
		"h\\2377", -- Dark Inquisitor Xanesh
		"h\\2372", 157255, 157256, 160599, 157254, -- The Hivemind
		"h\\2367", -- Shad'har the Insatiable
		"h\\2373", 157614, 157612, 157613, -- Drest'agath
		"h\\2374", 159514, -- Il'gynoth, Corruption Reborn
		"h\\2370", 157447, 157449, 157450, 157467, -- Vexiona
		"h\\2364", 156980, 156884, 157365, 157366, -- Ra-den the Despoiled
		"h\\2366", 157452, 157486, 157461, 157475, 157442, -- Carapace of N'Zoth
		"h\\2375", 158376, 158375, 158367, -- N'Zoth the Corruptor
	},
	flags = {
		["2365"] = {
			[156650] = 0x0800, -- Dark Manifestation
		},
		["2345"] = {
			[159514] = 0x0040 + 0x0004, -- Blood of Ny'alotha
		},
	},
	recolor = {
		-- Trash
		[159303] = 1, -- Monstrous Behemoth
		[159305] = 2, -- Maddened Conscript
		[159425] = "PRIEST", -- Occult Shadowmender
		[159219] = "WARLOCK", -- Umbral Seer
		[159417] = "ROGUE", -- Demented Knife-Twister
		[160183] = 7, -- Void Fanatic
		[160182] = 7, -- Void Initiate
		[159405] = 7, -- Aqir Scarab
		[162718] = 2, -- Iron-Willed Enforcer
		[162716] = "WARLOCK", -- Spellbound Ritualist
		[162719] = 1, -- Void Ascendant
		[162306] = 7, -- Aqir Drone
		[162664] = 7, -- Aqir Swarmer
		[162303] = 2, -- Aqir Swarmkeeper
		[161217] = 7, -- Aqir Skitterer
		[161218] = 1, -- Aqir Crusher
		[161173] = 1, -- Abyssal Watcher
		[159767] = 1, -- Sanguimar
		[159510] = "DEMONHUNTER", -- Eye of the Depths
		[161335] = "PRIEST", -- Void Horror
		[161312] = 1, -- Crushing Tendril
		[162828] = 2, -- Corrosive Digester

		-- Wrathion, the Black Emperor
		[158327] = 1, -- Crackling Shard

		-- Maut
		[156650] = 1, -- Dark Manifestation

		-- The Prophet Skitra
		[158781] = 1, -- Shredded Psyche

		-- The Hivemind
		[157255] = 7, -- Aqir Drone
		[157256] = 3, -- Aqir Darter
		[160599] = 2, -- Aqir Ravager
		[157254] = "WARLOCK", -- Tek'ris

		-- Drest'agath
		[157614] = 1, -- Tentacle of Drest'agath
		[157612] = 2, -- Eye of Drest'agath
		[157613] = 3, -- Maw of Drest'agath

		-- Il'gynoth, Corruption Reborn
		[159514] = 1, -- Blood of Ny'alotha

		-- Vexiona
		[157447] = 7, -- Fanatical Cultist
		[157449] = 2, -- Sinister Soulcarver
		[157450] = "PRIEST", -- Spellbound Ritualist
		[157467] = 1, -- Void Ascendant

		-- Ra-den the Despoiled
		[156980] = 4, -- Essence of Void
		[156884] = 6, -- Essence of Vita
		[157365] = 1, -- Crackling Stalker
		[157366] = 2, -- Void Hunter

		-- Carapace of N'Zoth
		[157452] = 2, -- Nightmare Antigen
		[157486] = 4, -- Horrific Hemorrhage
		-- [157461] = 6, -- Mycelial Cyst
		[157475] = 6, -- Synthesis Growth
		[157442] = 3, -- Gaze of Madness

		-- N'Zoth the Corruptor
		[158376] = "WARRIOR", -- Psychus
		[158375] = 3, -- Corruptor Tentacle
		[158367] = 2, -- Bassher Tentacle
	},
}

db["map1469"] = { zone = C_Map.GetMapInfo(1469).name, -- Vision of Orgrimmar
  category = 871,
	order = {
		156406, 153097, 156146, 158565, 161140, 157825, 152987, 157608, 152988, 157607, 153401, 157610, 157605, 156145, 153531, 156089, 155951, 155952, 155953, 155657, 157349,
	},
	flags = {
		["*"] = {
			[153244] = 0x0020, -- Oblivion Elemental
			[152874] = 0x0020, -- Vez'okk the Lightless
			[156161] = 0x0020, -- Inquisitor Gnshal
			[155098] = 0x0020, -- Rexxar
		}
	},
	recolor = {
		[156406] = "WARRIOR", -- Voidbound Honor Guard
		[153097] = "SHAMAN", -- Voidbound Shaman
		[156146] = 2, -- Voidbound Shieldbearer
		[158565] = "DRUID", -- Naros
		[161140] = "DRUID", -- Bwemba
		[157825] = 1, -- Crazed Tormenter
		-- [153130] = "WARLOCK", -- Greater Void Elemental
		[152987] = "WARRIOR", -- Faceless Willbreaker
		[152988] = "WARLOCK", -- Faceless Shadowcaller
		[157608] = "WARRIOR", -- Faceless Willbreaker
		[157607] = "WARLOCK", -- Faceless Shadowcaller
		[153401] = "PRIEST", -- K'thir Dominator
		[157610] = "PRIEST", -- K'thir Dominator
		[157605] = 6, -- Burrowing Appendage
		[156145] = 6, -- Burrowing Appendage
		[153531] = 2, -- Aqir Bonecrusher
		[156089] = 2, -- Aqir Venomweaver
		[155951] = "DEMONHUNTER", -- Ruffer
		[155952] = "DEMONHUNTER", -- Suffer
		[155953] = "DEMONHUNTER", -- C'Thuffer
		[155657] = "DEMONHUNTER", -- Huffer
		[157349] = "DEMONHUNTER", -- Void Boar
	}
}

db["map1470"] = { zone = C_Map.GetMapInfo(1470).name, -- Vision of Stormwind
	category = 872,
	order = {
		158478, 152722, 153760, 158146, 152987, 152988, 158437, 158158, 156145, 158452, 158690, 157158, 161293, 156949, 156795, 152809, 158315, 159266, 152939, 159275,
	},
	flags = {
		["*"] = {
				[156577] = 0x0020, -- Therum Deepforge
				[153541] = 0x0020, -- Slavemaster Ul'rok
				[158157] = 0x0020, -- Overlord Mathias Shaw
				[158035] = 0x0020, -- Magister Umbric
				[158315] = 0x0001 + 0x0002 + 0x0004, -- Eye of Chaos
		}
	},
	recolor = {
		[158478] = 4, -- Corruption Tumor
		[152722] = "PRIEST", -- Fallen Voidspeaker
		[153760] = 1, -- Enthralled Footman
		[158146] = "PALADIN", -- Fallen Riftwalker
		[152987] = "WARRIOR", -- Faceless Willbreaker
		[152988] = "WARLOCK", -- Faceless Shadowcaller
		[158437] = 3, -- Fallen Taskmaster
		[158158] = 2, -- Forge-Guard Hurrul
		[156145] = 6, -- Burrowing Appendage
		[158452] = 6, -- Mindtwist Tendril
		[158690] = 1, -- Cultist Tormenter
		[157158] = "WARRIOR", -- Cultist Slavedriver
		[161293] = 1, -- Neglected Guild Bank
		[156949] = 2, -- Armsmaster Terenson
		[156795] = "PRIEST", -- SI:7 Informant
		[152809] = 2, -- Alx'kov the Infested
		[158315] = "DRUID", -- Eye of Chaos
		[159266] = 1, -- Portal Master
		[152939] = 2, -- Boundless Corruption
		[159275] = "PRIEST", -- Portal Keeper

	}
}

db["island"] = { zone = _G.ISLANDS_HEADER,
	category = 871,
	order = {
		"h\\"..PLAYER_FACTION_COLORS[0]:WrapTextInColorCode(_G.FACTION_HORDE),
		"h\\npcg134997", 134997, 134998, 130872, 130871, -- Gazlowe's Greasemonkeys
		"h\\npcg134332", 134332, 134333, 129364, -- Greenbelly's Raiders
		"h\\npcg133738", 133738, 133733, 133734, -- The Highborne
		"h\\npcg129064", 129064, 129065, 129062, -- The Blazing Sunhawks
		"h\\npcg130302", 130302, 130301, 130303, -- The Headhunters
		"h\\npcg134269", 134269, 134270, 134271, -- Warbraves
		"h\\npcg144785", 144785, 144789, 144784, -- Draenor's Blood
		"h\\npcg151025", 151025, 151017, 151026, -- Raptari
		"h\\"..PLAYER_FACTION_COLORS[1]:WrapTextInColorCode(_G.FACTION_ALLIANCE),
		"h\\npcg135248", 135248, 135246, 135247, -- Briona's Buccaneers
		"h\\npcg130620", 130620, 130622, 130621, -- Auric's Angels
		"h\\npcg134283", 134283, 134286, 134280, -- Light's Vengeance
		"h\\npcg133556", 133556, 133585, 133627, -- Razak's Roughriders
		"h\\npcg134215", 134215, 134214, 134216, -- Riftrunners
		"h\\npcg131727", 131727, 131726, 131728, -- The Wolfpack
		"h\\npcg144776", 144776, 144772, 144782, -- Dark Iron Demolishers
		"h\\npcg151029", 151029, 151028, 151027, -- Thornspeakers
	},
	flags = {["*"] = {}},
	recolor = {
		-- Horde npcs
		[134997] = 2, -- Gazlowe
		[134998] = 2, -- Gazlowe(vehicle)
		[130872] = "SHAMAN", -- Lady Sena
		[130871] = "ROGUE", -- Skaggit

		[134332] = "HUNTER", -- Captain Greenbelly
		[134333] = "WARRIOR", -- Dorp
		[129364] = "ROGUE", -- Sneaky Pete

		[133738] = "MAGE", -- Astralite Visara
		[133733] = "WARRIOR", -- Moonscythe Pelani
		[133734] = "MAGE", -- Rune Scribe Lusaris

		[129064] = "MAGE", -- Phoenix Mage Rhydras
		[129065] = "MAGE", -- Phoenix Mage Ryleia
		[129062] = "PALADIN", -- Sunbringer Firasi

		[130302] = "WARRIOR", -- Berserker Zar'ri
		[130301] = "HUNTER", -- Shadow Hunter Ju'loa
		[130303] = "SHAMAN", -- Witch Doctor Unbugu

		[134269] = "SHAMAN", -- Mahna Flamewhisper
		[134270] = "DRUID", -- Spiritwalker Quura
		[134271] = "PALADIN", -- Sunwalker Ordel

		[144785] = "HUNTER", -- Nagtar Wolfsbane
		[144789] = "MONK", -- Ranah Saberclaw
		[144784] = "DEATHKNIGHT", -- Charg

		[151025] = "DRUID", -- Wardruid Ko'chus
		[151017] = "DRUID", -- Guardian M'sheke
		[151026] = "DRUID", -- Mooncaller Mozo'kas

		-- Alliance npcs
		[135248] = "HUNTER", -- Briona the Bloodthirsty
		[135246] = "ROGUE", -- "Stabby" Lottie
		[135247] = "WARRIOR", -- Varigg

		[130620] = "PALADIN", -- Frostfencer Seraphi
		[130622] = "MAGE", -- Squallshaper Auran
		[130621] = "MAGE", -- Squallshaper Bryson

		[134283] = "PRIEST", -- Anchorite Lanna
		[134286] = "MAGE", -- Archmage Tamuura
		[134280] = "PALADIN", -- Vindicator Baatul

		[133556] = "WARRIOR", -- Razak Ironsides
		[133585] = 2, -- Dizzy Dina
		[133627] = "SHAMAN", -- Tally Zapnabber

		[134215] = "PRIEST", -- Duskrunner Lorinas
		[134214] = "WARRIOR", -- Riftblade Kelain
		[134216] = "PRIEST", -- Shadeweaver Zarra

		[131727] = "HUNTER", -- Fenrae the Cunning
		[131726] = "WARRIOR", -- Gunnolf the Ferocious
		[131728] = "SHAMAN", -- Raul the Tenacious

		[144776] = "HUNTER", -- Airyn Swiftfeet
		[144772] = "DEATHKNIGHT", -- Lady Tamakeen
		[144782] = "MONK", -- Brother Bruen

		[151029] = "DRUID", -- Thornspeaker Tavery
		[151028] = "DRUID", -- Thornstalker Nydora
		[151027] = "DRUID", -- Thornguard Burton
	}
}

for k, v in pairs(db.island.recolor) do
	db.island.flags["*"][k] = 0x0020
end

-------------------------------------------------------------------------------
-- Shadowlands
-------------------------------------------------------------------------------

db["map1679"] = { zone = 1188, -- De Other Side
	group = 413,
	category = 901,
	order = {
		"h\\2410", 168949, 169905, 169912, 168942,
		"h\\2408", 170490, 170572, 170480, 170483, 165905,
		"h\\2409", 167964, 167962, 167966, 164556,
		"h\\2398", 164862, 164873, 164861, 171341, 171184,
	},
	flags = {
		["*"] = {
			[164558] = 0x0020,
			[164555] = 0x0020,
			[164556] = 0x0020,
			[164450] = 0x0020,
			[166608] = 0x0020,
			[167966] = 0x0001,
			[165905] = 0x0040,
		},
	},
	recolor = {
		[168949] = 1, -- Risen Bonesoldier
		[169905] = 2, -- Risen Warlord
		[169912] = 6, -- Enraged Mask
		[168942] = "WARLOCK", -- Death Speaker

		-- Hakkar the Soulflayer
		[170490] = "PRIEST", -- Atal'ai High Priest
		[170572] = "SHAMAN", -- Atal'ai Hoodoo Hexxer
		[170480] = "WARRIOR", -- Atal'ai Deathwalker
		[170483] = 6, -- Atal'ai Deathwalker's Spirit
		[165905] = 6, -- Son of Hakkar

		-- The Manastorms
		[167964] = 2, -- 4.RF-4.RF
		[167962] = 1, -- Defunct Dental Drill
		[167966] = 6, -- Experimental Sludge
		[170147] = 4, -- Volatile Memory
		[164556] = "MAGE", -- Millhouse Manastorm

		-- Dealer Xy'exa
		[164862] = 1, -- Weald Shimmermoth
		[164873] = 2, -- Runestag Elderhorn
		[164861] = "MAGE", -- Spriggan Barkbinder
		[171341] = 7, -- Bladebeak Hatchling
		[171184] = "WARRIOR", -- Mythresh, Sky's Talons
	},
	auras = {
		{id = "map1679:333875", spellID = 333875, buff = true, emphasize = true, color = 4}, -- Death's Embrace
	},
}

db["map1663"] = { zone = 1185, -- Halls of Atonement
	group = 409,
	category = 902,
	order = {
		"h\\2406", 164562, 167806, 165414, 164557, 165515, 174175, -- Halkias, the Sin-Stained Goliath
		"h\\2387", 167612, 167610, 167607, 164363, -- Echelon
		"h\\2411", 167615, 165913, -- High Adjudicator Aleez
		"h\\2413", 167876, -- Lord Chamberlain
	},
	flags = {
		["*"] = {
			[165408] = 0x0020,
			[164185] = 0x0020,
			[165410] = 0x0020,
			[164218] = 0x0020,
		},
	},
	recolor = {
		[164562] = 2, -- Depraved Houndmaster
		[167806] = 7, -- Animated Sin
		[165414] = "WARLOCK", -- Depraved Obliterator
		[164557] = "WARRIOR", -- Shard of Halkias
		[165515] = 1, -- Depraved Darkblade
		[174175] = 3, -- Loyal Stoneborn

		[167612] = 2, -- Stoneborn Reaver
		[167610] = 7, -- Stonefiend Anklebiter
		[167607] = 1, -- Stoneborn Slasher
		[164363] = 6, -- Undying Stonefiend

		[167615] = 1, -- Depraved Darkblade
		[165913] = 6, -- Ghastly Parishioner

		[167876] = "PRIEST", -- Inquisitor Sigar
	},
	auras = {
	},
}

db["map1669"] = { zone = 1184, -- Mists of Tirna Scithe
	category = 903,
	order = {
		"h\\2400", 164921, 164926, 164920, 164804, 164929, 168988, -- Ingra Maloch
		"h\\2402", 171772, 163058, 166299, 166275, 165108, 165251, -- Mistcaller
		"h\\2405", 167111, 172312, 167117, 165560, -- Tred'ova
	},
	flags = {
		["*"] = {
			[164567] = 0x0020,
			[164501] = 0x0020,
			[164517] = 0x0020,
			[165251] = 0x0040,
			[165560] = 0x0040,
		},
	},
	recolor = {
		[164921] = "WARLOCK", -- Drust Harvester
		[164926] = 2, -- Drust Boughbreaker
		-- [164920] = 1, -- Drust Soulcleaver
		[164804] = "DEMONHUNTER", -- Droman Oulfarran
		[164929] = "DRUID", -- Tirnenn Villager
		[168988] = 4, -- Overgrowth

		[171772] = 1, -- Mistveil Defender
		[163058] = 1, -- Mistveil Defender
		[166299] = 3, -- Mistveil Tender
		[166275] = "DRUID", -- Mistveil Shaper
		[165108] = "ROGUE", -- Illusionary Clone
		[165251] = 4, -- Illusionary Vulpin

		[167111] = 3, -- Spinemaw Staghorn
		[172312] = 1, -- Spinemaw Gorger
		[167117] = 7, -- Spinemaw Larva
		[165560] = 4, -- Gormling Larva
	},
	auras = {
		{id = "map1669:324776", spellID = 324776, buff = true, emphasize = true, color = 10}, -- Bramblethorn Coat
		{id = "map1669:326046", spellID = 326046, buff = true, emphasize = true, color = 8}, -- Stimulate Resistance
		{id = "map1669:322569", spellID = 322569, buff = true, emphasize = true, color = 4}, -- Hand of Thros
		{id = "map1669:324914", spellID = 324914, buff = true, emphasize = true, color = "MONK"}, -- Nourish the Forest
	},
}

db["map1674"] = { zone = 1183, -- Plaguefall
	group = 415,
	category = 904,
	order = {
		"h\\2419", 168578, 168572, 168574, 163882, 168393, 168396, 168394, 168398, 164362, 168969, 171887, -- Globgrog
		"h\\2403", 163894, 164550, 168310, 168153, 168627, 168891, 168878, 169498, 164707, 165010, 170851, -- Doctor Ickus
		"h\\2423", 168747, 167493, 164737, 168837, 170474, 172282, -- Domina Venomblade
		"h\\2404", 169861, 165430, 163857, 171188,  -- Margrave Stradama
	},
	flags = {
		["*"] = {
			[164255] = 0x0020,
			[164967] = 0x0020,
			[164266] = 0x0020,
			[164267] = 0x0020,
			[171887] = 0x0004,
			[168394] = 0x0004,
			[168398] = 0x0004,
			[164362] = 0x0004,
			[163857] = 0x0001,
		},
	},
	recolor = {
		[168578] = 1, -- Fungalmancer
		[168572] = "WARRIOR", -- Fungi Stormer
		[168574] = 2, -- Pestilent Harvester
		[163882] = "DRUID", -- Decaying Flesh Giant
		-- [168393] = 3, -- Plaguebelcher
		-- [168396] = 3, -- Plaguebelcher
		[168394] = 3, -- Slimy Morsel
		[168398] = 3, -- Slimy Morsel
		[164362] = 3, -- Slimy Morsel
		[168969] = 7, -- Gushing Slime
		[171887] = 2, -- Slimy Smorgasbord

		[163894] = "WARRIOR", -- Blighted Spinebreaker
		[164550] = 6, -- Slithering Ooze
		[168310] = 1, -- Plagueroc
		[168153] = 1, -- Plagueroc
		[168627] = 2, -- Plaguebinder
		[168891] = "DEMONHUNTER", -- Rigged Plagueborer
		[168878] = "DEMONHUNTER", -- Rigged Plagueborer
		[169498] = 4, -- Plague Bomb
		[164707] = 1, -- Congealed Slime
		[165010] = 1, -- Congealed Slime
		[170851] = 4, -- Volatile Plague Bomb

		[168747] = 5, -- Venomfang
		[167493] = "HUNTER", -- Venomous Sniper
		[164737] = 2, -- Brood Ambusher
		[168837] = 6, -- Stealthling
		[170474] = 3, -- Brood Assassin
		[172282] = 4, -- Web Wrap

		[169861] = 2, -- Ickor Bileflesh
		[165430] = 4, -- Malignant Spawn
		[163857] = 7, -- Plaguebound Devoted
		[171188] = 1, -- Plaguebound Devoted (boss)
	},
	auras = {
		{id = "map1674:333737", spellID = 333737, buff = true, emphasize = true, color = 4}, -- Congealed Contagion
		{id = "map1674:328175", spellID = 328175, buff = false, emphasize = true, color = 1}, -- Congealed Contagion (aura)
		{id = "map1674:340702", spellID = 340702, enlarge = true, buff = true, emphasize = true, color = 4}, -- Oozing Carcass
		{id = "map1674:341022", spellID = 341022, buff = false, emphasize = true, color = 1}, -- Oozing Carcass (aura)
	},
}

db["map1675"] = { zone = 1189, -- Sanguine Depths
	group = 412,
	category = 905,
	order = {
		"h\\2388", 162047, 162046, 162039, 162040, 162038,
		"h\\2415", 162057, 171376, 171799, 162049, 168058, 165556,
		"h\\2407", 171448, 162133, 166589, 168457, 167956, 167955, 162056,
	},
	flags = {
		["*"] = {
			[162100] = 0x0020 + 0x0800,
			[162103] = 0x0020,
			[162102] = 0x0020,
			[162099] = 0x0020 + 0x8800,
			[162133] = 0x0020 + 0x8800,
			[165556] = 0x3800,
		},
	},
	recolor = {
		[162047] = "WARRIOR", -- Insatiable Brute
		[162046] = 7, -- Famished Tick
		[162039] = "WARLOCK", -- Wicked Oppressor
		[162040] = 1, -- Grand Overseer
		[162038] = 2, -- Regal Mistdancer

		[162057] = "DEMONHUNTER", -- Chamber Sentinel
		-- [171376] = "DRUID", -- Head Custodian Javlin
		[171799] = "DRUID", -- Depths Warden
		[162049] = 3, -- Vestige of Doubt
		[168058] = 7, -- Infused Quill-feather
		[165556] = 3, -- Fleeting Manifestation

		[171448] = "HUNTER", -- Dreadful Huntmaster
		[162133] = 2, -- General Kaal
		[168457] = 7, -- Stonewall Gargon
		-- [167956] = 7, -- Dark Acolyte
		-- [167955] = 7, -- Sanguine Cadet
		-- [162056] = 7, -- Rockbound Sprite
		[166589] = {0.4, 0.8, 0.8}, -- Animated Weapon
	},
	auras = {
		{id = "map1675:322433", spellID = 322433, buff = true, emphasize = true, color = 8}, -- Stoneskin
	},
}

db["map1693"] = { zone = 1186, -- Spire of Ascension
	group = 419,
	category = 906,
	order = {
		"h\\2399", 163459, 163458, 168318, 163077, -- Kin-Tara
		"h\\2416", 163501, 163524, 168420, 168418, 163520, -- Ventunax
		"h\\2414", 168718, 168717, 166411, -- Oryphrion
	},
	flags = {
		["*"] = {
			[162059] = 0x0020,
			[163077] = 0x0020,
			[162058] = 0x0020,
			[162060] = 0x0020,
			[162061] = 0x0020,
		},
	},
	recolor = {
		[163459] = "PRIEST", -- Forsworn Mender
		[163458] = "MAGE", -- Forsworn Castigator
		[168318] = "WARRIOR", -- Forsworn Goliath
		[163077] = 1, -- Azules

		[163501] = "HUNTER", -- Forsworn Skirmisher
		[163524] = 2, -- Kyrian Dark-Praetor
		[168420] = 3, -- Forsworn Champion
		[168418] = 1, -- Forsworn Inquisitor
		[163520] = "DRUID", -- Forsworn Squad-Leader

		-- [168681] = 1, -- Forsworn Helion
		[168718] = "PRIEST", -- Forsworn Warden
		[168717] = 2, -- Forsworn Justicar
		[166411] = 7, -- Forsworn Usurper
	},
	auras = {
	},
}

db["map1666"] = { zone = 1182, -- The Necrotic Wake
	group = 410,
	category = 907,
	order = {
		"h\\2395", 163121, 166302, 165597, 165138, 165137, 164702, -- Blightbone
		"h\\2391", 163618, 163126, 163122, 163128, 165222, 165919, 165824, 165197, 168246, 164427, 164414, -- Amarth, The Harvester
		"h\\2392", 166266, 166264, 173016, 172981, 165872, 163621, 163620, 164578, -- Surgeon Stitchflesh
	},
	flags = {
		["*"] = {
			[162691] = 0x0020,
			[163157] = 0x0020,
			[162689] = 0x0020,
			[162693] = 0x0020,
		},
	},
	recolor = {
		[163121] = "WARRIOR", -- Stitched Vanguard
		[166302] = 2, -- Corpse Harvester
		[165597] = 7, -- Patchwerk Soldier
		[165138] = 7, -- Blight Bag
		[165137] = "WARLOCK", -- Zolramus Gatekeeper
		[164702] = "DEMONHUNTER", -- Carrion Worm

		[163618] = 2, -- Zolramus Necromancer
		[163126] = "MAGE", -- Brittlebone Mage
		[163122] = 7, -- Brittlebone Warrior
		[163128] = 3, -- Zolramus Sorcerer
		[165222] = "PRIEST", -- Zolramus Bonemender
		[165919] = 1, -- Skeletal Marauder
		[165824] = "DRUID", -- Nar'zudah
		[165197] = "DRUID", -- Skeletal Monstrosity
		[168246] = 7, -- Reanimated Crossbowman
		[164427] = 7, -- Reanimated Warrior
		[164414] = "MAGE", -- Reanimated Mage

		[166266] = 7, -- Spare Parts
		[166264] = 7, -- Spare Parts
		[173016] = "MAGE", -- Corpse Collector
		[172981] = 2, -- Kyrian Stitchwerk
		[165872] = 3, -- Flesh Crafter
		[163621] = 2, -- Goregrind
		[163620] = "DRUID", -- Rotspew
		[164578] = 2, -- Stitchflesh's Creation
	},
	auras = {
	},
}

db["map1683"] = { zone = 1187, -- Theater of Pain
	group = 414,
	category = 908,
	order = {
		"h\\2397", 174197, 170850, 164451, 164463, 164461, 164464, -- An Affront of Challengers
		"h\\2401", 170690, 174210, 163086, 165260, -- Gorechop
		"h\\2390", 164510, 167538, 164506, 170234, -- Xav the Unfallen
		"h\\2389", 167998, 160495, 162763, 169893, -- Kul'tharok
		"h\\2417", 166524, -- Mordretha, the Endless Empress
	},
	flags = {
		["*"] = {
			[164451] = 0x0020,
			[164463] = 0x0020,
			[164461] = 0x0020,
			[164464] = 0x0020,
			[162317] = 0x0020,
			[162329] = 0x0020,
			[162309] = 0x0020,
			[165946] = 0x0020,
		},
	},
	recolor = {
		[174197] = "PRIEST", -- Battlefield Ritualist
		[170850] = 1, -- Raging Bloodhorn
		[164451] = "WARRIOR", -- Dessia the Decapitator
		[164463] = "WARLOCK", -- Paceran the Virulent
		[164461] = "PRIEST", -- Sathel the Accursed
		[164464] = "ROGUE", -- Xira the Underhanded

		-- Xav the Unfallen
		[164510] = "HUNTER", -- Shambling Arbalest
		[167538] = 2, -- Dokigg the Brutalizer
		[164506] = "WARRIOR", -- Ancient Captain
		[170234] = 4, -- Oppressive Banner

		-- Kul'tharok
		[167998] = 1, -- Portal Guardian
		[160495] = 3, -- Maniacal Soulbinder
		[162763] = 2, -- Soulforged Bonereaver
		[169893] = "WARLOCK", -- Nefarious Darkspeaker

		-- Gorechop
		[170690] = 2, -- Diseased Horror
		[174210] = 1, -- Blighted Sludge-Spewer
		-- [330586] = 3, -- Putrid Butcher
		[163086] = "DEMONHUNTER", -- Rancid Gasbag
		[165260] = 3, -- Oozing Leftovers

		-- Mordretha, the Endless Empress
		[166524] = 3, -- Deathwalker
	},
	auras = {
		{id = "map1683:330545", spellID = 330545, buff = true, enlarge = false, emphasize = true, color = 1}, -- Commanding Presence
	},
}

db["map1989"] = { zone = 1194, -- Tazavesh, the Veiled Market
	group = 423,
	category = 909,
	order = {
		"h\\2437", 177817, 177816, 177808, 175576, -- Zo'phex the Sentinel
		"h\\2454", 176705, 176555, 177237, -- The Grand Menagerie
		"h\\2436", 179841, 179840, 179821, 176395, 175677, -- Mailroom Mayhem
		"h\\2452", 178394, 179269, 176565, 180470, 180486, 180484, 180399, -- Myza's Oasis
		"h\\2451", -- So'azmi
		"h\\2448", 178163, 178141, 179733, 178139, 178142, 178165, 176551, -- Hylbrande
		"h\\2449", 179388, 180015, 179386, 177500, -- Timecap'n Hooktail
		"h\\2455", 180429, 180433, 180431, 177716, -- So'leah
	},
	flags = {
		["*"] = {
			[175616] = 0x0020,
			[176556] = 0x0020,
			[176555] = 0x0020,
			[176705] = 0x0020,
			[175646] = 0x0020,
			[176563] = 0x0020,
			[175806] = 0x0020,
			[175663] = 0x0020,
			[175546] = 0x0020,
			[177269] = 0x0020,
			[179733] = 0x0004, -- Invigorating Fish Stick
		},
	},
	recolor = {
		-- Zo'phex the Sentinel
		[177817] = 1, -- Support Officer
		[177816] = 2, -- Interrogation Specialist
		[177808] = "DRUID", -- Armored Overseer
		[175576] = 4, -- Containment Cell

		-- The Grand Menagerie
		[176705] = "WARRIOR", -- Venza Goldfuse
		[176555] = 2, -- Achillite
		[177237] = 4, -- Chains of Damnation

		-- Mailroom Mayhem
		[179841] = "MAGE", -- Veteran Sparkcaster
		[179840] = "WARRIOR", -- Market Peacekeeper
		[179821] = 2, -- Commander Zo'far
		[176395] = 1, -- Overloaded Mailemental
		[175677] = "DRUID", -- Smuggled Creature

		-- Myza's Oasis
		[178394] = 7, -- Cartel Lackey
		[179269] = "WARRIOR", -- Oasis Security
		[176565] = 2, -- Disruptive Patron
		[180470] = 1, -- Verethian
		[180486] = 2, -- Dirtwhistle
		[180484] = 3, -- Vilt
		[180399] = "DEMONHUNTER", -- Evaile

		-- So'azmi

		-- Hylbrande
		[178163] = 7, -- Murkbrine Shorerunner
		[178141] = 3, -- Murkbrine Scalebinder
		[179733] = "PRIEST", -- Invigorating Fish Stick
		[178139] = 2, -- Murkbrine Shellcrusher
		[178142] = "MAGE", -- Murkbrine Fishmancer
		[178165] = 1, -- Coastwalker Goliath
		[176551] = 2, -- Vault Purifier

		-- Timecap'n Hooktail
		-- [179388] = 1, -- Hourglass Tidesage
		[180015] = "WARRIOR", -- Burly Deckhand
		[179386] = 2, -- Corsair Officer
		[177500] = "DEMONHUNTER", -- Corsair Brute

		-- So'leah
		[180429] = "DRUID", -- Adorned Starseer
		[180433] = 4, -- Wandering Pulsar
		[180431] = "MAGE", -- Focused Ritualist
		[177716] = "ROGUE", -- So' Cartel Assassin
	},
	auras = {
		{id = "map1989:347775", spellID = 347775, buff = true, emphasize = true, color = 8}, -- Spam Filter
		{id = "map1989:355147", spellID = 355147, buff = true, emphasize = true, color = 1}, -- Fish Invigoration
		{id = "map1989:356133", spellID = 356133, buff = true, emphasize = true, color = 4}, -- Super Saison
	},
}

db["map1735"] = { zone = 1190, -- Castle Nathria
	group = 420,
	category = 951,
	order = {
		"h\\-",  173189, 174336, 174069, 173484, 165481, 174208, 173604, 174843, -- Trash
		"h\\2393", -- Shriekwing
		"h\\2429", "22312", "22311", "22310", 171557, -- Huntsman Altimor
		"h\\2422", 167566, 165763, 165764, 168700, 165762, 165805, 168962, -- Sun King's Salvation
		"h\\2418", -- Artificer Xy'mox
		"h\\2428", -- Hungering Destroyer
		"h\\2420", "22617", "22618", -- Lady Inerva Darkvein
		"h\\2426", 166971, 166969, 166970, 175992, 169924, 169925,  -- The Council of Blood
		"h\\2394", -- Sludgefist
		"h\\2425", 168113, 172858, -- Stone Legion Generals
		"h\\2424", 169196, 168156, 167999, -- Sire Denathrius
	},
	flags = {
		["*"] = {
			[168700] = 0x0001, -- Pestering Fiend
			[168962] = 0x0040, -- Reborn Phoenix
			[167999] = 0x0001 + 0x0008 + 0x0002, -- Echo of Sin
		},
	},
	recolor = {
		-- Trash
		[173189] = 1, -- Nathrian Hawkeye
		[174336] = 3, -- Kennel Overseer
		[174069] = 2, -- Hulking Gargon
		[173484] = 6, -- Conjured Manifestation
		[165481] = "ROGUE", -- Court Assassin
		[174208] = "WARLOCK", -- Court Executor
		[173604] = 2, -- Sinister Antiquarian
		[174843] = "DEMONHUNTER", -- Stoneborn Maitre D'

		-- [189706] = 9, -- Chaotic Essence
		-- [188302] = 9, -- Reconfiguration Emitter
		-- [188703] = 9, -- Protoform Barrier
		-- [189707] = 7, -- Chaotic Mote

		-- Huntsman Altimor
		["22312"] = "DRUID", -- Margore
		["22311"] = "WARLOCK", -- Bargast
		["22310"] = "WARRIOR", -- Hecutis
		[171557] = 6, -- Shade of Bargast

		-- Sun King's Salvation
		[167566] = "ROGUE", -- Bleakwing Assassin
		[165763] = 3, -- Vile Occultist
		-- [165764] = "DEMONHUNTER", -- Rockbound Vanquisher
		[168700] = 7, -- Pestering Fiend
		[165762] = 6, -- Soul Infuser
		[165805] = "DRUID", -- Shade of Kael'thas
		[168962] = 4, -- Reborn Phoenix

		-- Lady Inerva Darkvein
		["22617"] = 1, -- Harnessed Specter
		["22618"] = 2, -- Conjured Manifestation

		-- The Council of Blood
		[166971] = "MONK", -- Castellan Niklaus
		[166969] = "WARLOCK", -- Baroness Frieda
		[166970] = 2, -- Lord Stavros
		[175992] = 4, -- Dutiful Attendant
		[169924] = 3, -- Veteran Stoneguard
		[169925] = 6, -- Begrudging Waiter

		-- Stone Legion Generals
		[168113] = "WARRIOR", -- General Grashaal
		-- [168112] = 1, -- General Kaal
		[172858] = 1, -- Stone Legion Goliath

		-- Sire Denathrius
		[169196] = 1, -- Crimson Cabalist
		[168156] = 2, -- Remornia
		[167999] = 6, -- Echo of Sin
	},
	auras = {
		-- Huntsman Altimor
		{id = "e2418:334695", spellID = 334695, buff = false, enlarge = true, emphasize = true, color = 1, encounterID = 2418}, -- Destabilize
	},
}

db["map1998"] = { zone = 1193, -- Sanctum of Domination
	group = 426,
	category = 952,
	order = {
		"h\\-", 176535, 176537, 176538, 176539, 178630, 178731, 178071, 179894, 176940, 176879, 180779, 180782, 176957, 180428, 180864, 178862, 180407, -- Trash
		-- "h\\2435", -- The Tarragrue
		-- "h\\2442", -- The Eye of the Jeiler
		"h\\2439", 177095, 175726, 177407, -- The Nine
		"h\\2444", 177117, -- Remnant of Ner'zhul
		"h\\2445", 177594, -- Soulrender Dormazain
		"h\\2443", 176581, -- Painsmith Raznal
		-- "h\\2446", -- Guardian of the First Ones
		"h\\2447", 179124, 179010, 180323, -- Fatescribe Roh-Kalo
		"h\\2440", 176605, 176703, 176973, 175861, 176974, -- Kel'Thuzad
		"h\\2441", 176920, 177154, 177889, 177892, 177891, 178008, -- Sylvanas Windrunner
	},
	flags = {
		["*"] = {
			[179124] = 0x0040, -- Shade of Destiny
			[176703] = 0x0004 + 0x0040, -- Frostbound Devoted
			[176605] = 0x0020, -- Soul Shard
			[177594] = 0x0004, -- Mawsworn Agonizer
		},
	},
	recolor = {
		-- Trash
		[176535] = "DRUID", -- Infused Goliath
		[176537] = "DRUID", -- Infused Goliath
		[176538] = "DRUID", -- Infused Goliath
		[176539] = "DRUID", -- Infused Goliath
		[178630] = "WARLOCK", -- Mawsworn Seeker
		[178731] = 2, -- Bonesteel
		[178071] = "ROGUE", -- Maw Assassin
		[179894] = 1, -- Deathseeker Eye
		[176940] = "DRUID", -- Soulember
		[176879] = "DRUID", -- Hollowsoul
		[180779] = "WARLOCK", -- Terrorspine
		[180782] = 7, -- Consumed Soul
		[176957] = 2, -- Shadowsteel Colossus
		[180428] = 6, -- Tortured Soul
		[180864] = 1, -- High Torturer
		[178862] = "DRUID", -- Screamspike
		[180407] = 1, -- Gorgoan Sentinel

		-- The Tarragrue

		-- The Eye of the Jeiler

		-- The Nine
		[177095] = 2, -- Kyra
		[175726] = 1, -- Skyja
		[177407] = "DRUID", -- Formless Mass

		-- Remnant of Ner'zhul
		[177117] = 4, -- Orb of Torment

		-- Soulrender Dormazain
		[177594] = 3, -- Mawsworn Agonizer

		-- Painsmith Raznal
		[176581] = 6, -- Spiked Ball

		-- Guardian of the First Ones

		-- Fatescribe Roh-Kalo
		[179124] = "DRUID", -- Shade of Destiny
		[179010] = 1, -- Fatespawn Anomaly
		[180323] = 2, -- Fatespawn Monstrosity

		-- Kel'Thuzad
		[176605] = 4, -- Soul Shard (copy of tank)
		[176703] = "DRUID", -- Frostbound Devoted
		[176973] = "WARRIOR", -- Abomi
		[175861] = "PRIEST", -- Spike
		[176974] = "WARLOCK", -- Soul Reaver

		-- Sylvanas Windrunner
		[176920] = 4, -- Domination Arrow
		[177154] = 1, -- Mawforged Vanguard
		[177889] = 2, -- Mawforged Souljugdge
		[177892] = "DRUID", -- Mawforged Goliath
		[177891] = "WARLOCK", -- Mawforged Summoner
		[178008] = 4, -- Decrepit Orb
	},
	auras = {
		{id = "e2432:355790", spellID = 355790, buff = true, enlarge = true, emphasize = true, color = 1, encounterID = 2432}, -- Eternal Torment
	},
}

db["map2047"] = { zone = 1195, -- Sepulcher of the First Ones
	group = 427,
	category = 953,
	order = {
		"h\\-", 184530, 184954, 184651, 184791, 186353, 183416, 183406, 184880, 183438, 183439, 185154, 185155, 184533, 183499, 185008, 185032, 183496, 183497, 185537, 183495, 185271, 185268, 185274, 184737, 185363,
		"h\\2458", 181856, 182311, 181850, 183992, 184522, -- Vigilant Guardian
		-- "h\\2465", -- Skolex, the Insatiable Ravener
		"h\\2470", 183688, 184140, 183707, -- Artificer Xy'mox
		"h\\2459", 181244, -- Dausegne, the Fallen Oracle
		"h\\2460", 181549, 181546, 181548, 181551, 182045, 183409, -- Prototype Pantheon
		"h\\2461", 182074, 182071, 185423, -- Lihuvim, Principal Architect
		"h\\2463", 181012, -- Halondrus the Reclaimer
		"h\\2469", 184520, 183463, 183669, 183033, 185005, -- Anduin Wrynn
		"h\\2457", 181399, 183138, -- Loads of Dread
		"h\\2467", 182778, 183945, -- Rygelon
		"h\\2464", 184622, -- The Jailler

	},
	flags = {
		["*"] = {
			[183669] = 0x0001, -- Fiendish Soul
			[183033] = 0x0004, -- Grim Reflection
		},
	},
	recolor = {
		-- Trash
		[184530] = 2, -- Eternal Sentry
		[184954] = 1, -- Ancient Shaper
		[184651] = "DRUID", -- Subjugator Zeltoth
		[184791] = 7, -- Inner Hatred
		[186353] = "WARLOCK", -- Dominated Shaper
		[183416] = "DEMONHUNTER", -- Bound Realmbreaker
		[183406] = "DEMONHUNTER", -- Colossal Realmcrafter
		[184880] = 2, -- Dominated Disrupter
		[183438] = "WARRIOR", -- Chainbound Construct
		[183439] = 1, -- Mawsworn Annihilator
		[185154] = "DRUID", -- Mal'Ganis
		[185155] = "PRIEST", -- Kin'tessa
		[184533] = "WARRIOR", -- Overthrown Protector
		[184737] = 3, -- Acquisitions Automa
		[183499] = 2, -- Hired Muscle
		[185008] = 4, -- Volatile Sentry
		[185032] = "DRUID", -- Taskmaster Xy'pro
		[183496] = "WARRIOR", -- Foul Gorger
		[183497] = 3, -- Foul Controller
		[185537] = 3, -- Foul Controller
		[183495] = 2, -- Twisted Worldeater
		[185363] = "DRUID", -- Manifestor Krugan

		[185271] = 7, -- Stellar Mote
		[185268] = "WARRIOR", -- Ebonsteel Construct
		-- [185274] = 1, -- Astral Particle

		-- Vigilant Guardian
		[181856] = "WARLOCK", -- Point Defense Drone
		[182311] = 2, -- Pre-Fabricated Sentry
		[181850] = 2, -- Pre-Fabricated Sentry
		[183992] = 3, -- Automated Defense Matrix
		[184522] = 1, -- Vigilant Custodian

		-- Artificer Xy'mox
		[183688] = 4, -- Stasis Trap
		[184140] = 2, -- Xy Acolyte
		[183707] = "MAGE", -- Xy Spellslinger

		-- Dausegne, the Fallen Oracle
		[181244] = 4, -- Domination Core

		-- Prototype Pantheon
		[181549] = "PRIEST", -- Prototype of War
		[181546] = "DRUID", -- Prototype of Renewal
		[181548] = "DEMONHUNTER", -- Prototype of Absolution
		-- [181551] = 2, -- Prototype of Duty
		[182045] = 4, -- Necrotic Ritualist
		[183409] = 6, -- Pinning Weapon

		-- Lihuvim, Principal Architect
		[182074] = 3, -- Acquisitions Automa
		[182071] = 2, -- Guardian Automa
		[185423] = "WARRIOR", -- Reaving Automa: Neo

		-- Halondrus the Reclaimer
		[181012] = 2, -- Strange Construct

		-- Anduin Wrynn
		[184520] = 2, -- Anduin's Despair
		[183463] = "DEMONHUNTER", -- Remnant of a Fallen King
		[183669] = "ROGUE", -- Fiendish Soul
		[183033] = "PRIEST", -- Grim Reflection
		[185005] = "DRUID", -- Anduin's Grief

		-- Loads of Dread
		[181399] = "PRIEST", -- Kin'tessa
		[183138] = 6, -- Corporeal Shadow

		-- Rygelon
		[182778] = 1, -- Collapsing Quasar
		[183945] = 2, -- Unstable Matter

		-- The Jailler
		[184622] = 4, -- Incarnation of Torment

	},
	auras = {
	},
}

db["scenario2162"] = { zone = GetDifficultyInfo(167), -- Torghast
	category = 971,
	order = {
	},
	flags = {
		["*"] = {
		},
	},
	recolor = {
		[151353] = 5, -- Mawrat
		[154030] = 3, -- Oddly Large Mawrat
		[155793] = 2, -- Skeletal Remains
		[157340] = 2, -- Skeletal Remains
		[155824] = 2, -- Lumbering Creation
		[155908] = "WARLOCK", -- Deathspeaker
		[155828] = "WARRIOR", -- Runecarved Colossus
		[155790] = 1, -- Mawsworn Acolyte
		[155831] = "MAGE", -- Mawsworn Soulbinder
		[151127] = "WARLOCK", -- Lord of Torment
		[157634] = "WARRIOR", -- Flameforge Enforcer
		[157571] = "PRIEST", -- Mawsworn Flametender
		[152661] = 7, -- Mawsworn Ward
		[150958] = 1, -- Mawsworn Guard
		[157584] = "MAGE", -- Flameforge Master
		[151128] = "DRUID", -- Lord of Locks
		[152708] = 2, -- Mawsworn Seeker
		[152875] = "DRUID", -- Massive Crusher
		[150959] = "HUNTER", -- Mawsworn Interceptor
		[170071] = {1, 0.1, 1}, -- Mawsworn Shadestalker
		[152656] = 1, -- Deadsoul Stalker
		[151818] = 2, -- Deadsoul Miscreation
		[153885] = 3, -- Deadsoul Shambler
		[151817] = "DEMONHUNTER", -- Deadsoul Devil
		[154129] = "MAGE", -- Burning Emberguard
		[171171] = "HUNTER", -- Mawsworn Archer
		[152898] = "DRUID", -- Deadsoul Chorus
		[160161] = "WARRIOR", -- Fog Dweller
		[170093] = {1, 0.1, 1}, -- Mawsworn Seeker
		[156245] = "WARRIOR", -- Grand Automaton
		[156226] = "MAGE", -- Coldheart Binder
		[165594] = "ROGUE", -- Coldheart Ambusher
		[156159] = "HUNTER", -- Coldheart Javelineer
		[156157] = 1, -- Coldheart Ascendant
		[156212] = "WARLOCK", -- Coldheart Agent
		[177286] = 4, -- Phantasmic Amalgamation
	},
	auras = {
		{id = "senario2162:299150", spellID = 299150, buff = true, enlarge = true, emphasize = true, color = 4}, -- Unnatural Power
		{id = "senario2162:296651", spellID = 296651, buff = true, enlarge = false, emphasize = true, color = "ROGUE"}, -- Fading Away
		{id = "senario2162:350931", spellID = 350931, buff = true, enlarge = false, emphasize = true, color = 8}, -- Phantasmic Ward
	},
}

-------------------------------------------------------------------------------
-- Dragonflight
-------------------------------------------------------------------------------

db["map2097"] = { zone = 1201, -- Algeth'ar Academy
	group = 433,
	category = 1001,
	order = {
		"h\\2509", 196577, 196576, 196671, 196044, -- Vexamus
		"h\\2512", 197406, 197219, 197398, 196548, -- Overgrown Ancient
		"h\\2495", 192680, 192329, -- Crawth
		"h\\2514", 196200, 196203, 196202, -- Echo of Doragosa

	},
	flags = {
		["*"] = {
			[194181] = 0x0020,
			[196482] = 0x0020,
			[191736] = 0x0020,
			[190609] = 0x0020,
		},
	},
	recolor = {
		[196577] = "WARRIOR", -- Spellbound Battleaxe
		[196576] = 1, -- Spellbound Scepter
		[196671] = 2, -- Arcane Ravager
		[196044] = "MAGE", -- Unruly Textbook

		[197406] = 1, -- Aggravated Skitterfly
		[197219] = "WARLOCK", -- Vile Lasher
		[197398] = 6, -- Hungry Lasher
		[196642] = 6, --
		[196548] = "DRUID", -- Ancient Branch

		-- [192680] = "DRUID", -- Guardian Sentry
		[192329] = 7, -- Territorial Eagle

		[196200] = 1, -- Algeth'ar Echoknight
		[196203] = "MAGE", -- Ethereal Restorer
		[196202] = 2, -- Spectral Invoker
	},
	auras = {
		{id = "map2097:387955", spellID = 387955, buff = true, emphasize = true, color = 8}, -- Celestial Shield
	},
}

db["map2096"] = { zone = 1196, -- Brackenhide Hollow
	group = 432,
	category = 1002,
	order = {
		"h\\2471", 185528, 185529, 185534, 186191, 193799, 193352, 186122, 186124, 186125, -- Hackclaw's War-Band
		"h\\2473", 189363, 208994, 186220, 199916, 189299, 192481, 186226, 190426, 186229, 187033, -- Treemouth
		"h\\2472", 186242, 197857, 186246, 186208, 194745, -- Gutshot
		"h\\2474", 185656, 187315, 187224, 187238, 194373, 190381, -- Decatriarch Wratheye
	},
	flags = {
		["*"] = {
			[186122] = 0x0020,
			[186124] = 0x0020,
			[186125] = 0x0020,
			[186120] = 0x0020,
			[186116] = 0x0020,
			[186121] = 0x0020,
			[199916] = 0x0001,
			[193352] = 0x0080,
			[190426] = 0x0080,
		},
	},
	recolor = {
		[185528] = 2, -- Trickclaw Mystic
		[185529] = "WARRIOR", -- Bracken Warscourge
		[185534] = "HUNTER", -- Bonebolt Hunter
		[186191] = 1, -- Decay Speaker
		[193799] = 4, -- Rotchanting Totem
		[193352] = 9, -- Hextrick Totem
		[186122] = "WARRIOR", -- Rira Hackclaw
		[186124] = "ROGUE", -- Gashtooth
		[186125] = "SHAMAN", -- Tricktotem

		[189363] = 7, -- Infected Lasher
		[208994] = 7, -- Infected Lasher (summoned)
		[186220] = 1, -- Brackenhide Shaper
		[199916] = "DEMONHUNTER", -- Decaying Slime
		[189299] = "DEMONHUNTER", -- Decaying Slime
		[192481] = "DEMONHUNTER", -- Decaying Slime
		[186226] = "WARLOCK", -- Fetid Rotsinger
		[190426] = 4, -- Decay Totem
		[186229] = 2, -- Wilted Oak
		[187033] = "DRUID", -- Stinkbreath

		[186242] = "ROGUE", -- Skulking Gutstabber
		[197857] = "ROGUE", -- Gutstabber
		[186246] = 1, -- Fleshripper Vulture
		[186208] = 2, -- Rotbow Stalker
		[194745] = 1, -- Rotfang Hyena

		-- [187231] = 7, -- Wither Biter
		[185656] = "WARLOCK", -- Filth Caller
		-- [187315] = 1, -- Disease Slasher
		[187224] = 2, -- Vile Rothexer
		[187238] = 7, [194373] = 7, -- Witherling
		[190381] = 4, -- Rotburst Totem
	},
	auras = {
		{id = "map2096:377950", spellID = 377950, buff = true, emphasize = true, color = "MONK"}, -- Greater Healing Rapids
	},
}

db["map2082"] = { zone = 1204, -- Halls of Infusion
	group = 434,
	category = 1003,
	order = {
		"h\\2504", 190345, 190340, 190342, 196712, -- Watcher Irideus
		"h\\2507", 199037, 190359, 190370, 190368, 190923, 190366, 195399, -- Gulping Goliath
		"h\\2510", 190403, 190401, 190404, 190377, 190371, 190373, -- Khajin the Unyielding
		"h\\2511", 190407, 190406, 190405, 196043, -- Primal Tsunami
	},
	flags = {
		["*"] = {
			[189719] = 0x0020,
			[189722] = 0x0020,
			[189727] = 0x0020,
			[189729] = 0x0020,
			[190366] = 0x0040,
			[195399] = 0x0040,
		},
	},
	recolor = {
		[190345] = 1, -- Primalist Geomancer
		[190340] = "WARRIOR", -- Refti Defender
		[190342] = 2, -- Containment Apparatus
		[196712] = 3, -- Nullification Device

		[199037] = 2, -- Primalist Shocktrooper
		[190359] = "ROGUE", -- Skulking Zealot
		[190370] = "DRUID", -- Squallbringer Cyraz
		[190368] = "MAGE", -- Flamecaller Aymi
		[190923] = 7, -- Zephyrling
		[190366] = "PRIEST", -- Curious Swoglet
		[195399] = "PRIEST", -- Curious Swoglet

		[190403] = 1, -- Glacial Proto-Dragon
		[190401] = "DRUID", -- Gusting Proto-Dragon
		[190404] = "WARLOCK", -- Subterranean Proto-Dragon
		[190377] = 2, -- Primalist Icecaller
		-- [190371] = "WARRIOR", -- Primalist Earthshaker
		[190373] = "SHAMAN", -- Primalist Galesinger

		-- [190407] = 1, -- Aqua Rager
		[190406] = 7, -- Aqualing
		[190405] = "DRUID", -- Infuser Sariya
		[196043] = "DEMONHUNTER", -- Primalist Infuser
	},
	auras = {
	},
}

db["map2080"] = { zone = 1199, -- Neltharus
	group = 431,
	category = 1004,
	order = {
		"h\\2490", 193293, 189227, 189669, 189247, 189266, 189235, 189265,  -- Chargath, Bane of Scales
		"h\\2489", 189472, 189464, 189471, 189466, 194816, -- Forgemaster Gorek
		"h\\2494", 192781, 192786, 192788, 193944, 194389, -- Magmatusk
		"h\\2501", 193291, 192464, -- Warlord Sargha
	},
	flags = {
		["*"] = {
			[189340] = 0x0020,
			[189478] = 0x0020,
			[181861] = 0x0020,
			[189901] = 0x0020,
			[192464] = 0x0040,
		},
	},
	recolor = {
		[193293] = "WARRIOR", -- Qalashi Warden
		-- [189227] = "HUNTER", -- Qalashi Hunter
		[189669] = 9, -- Binding Spear
		[189247] = "MAGE", -- Tamed Phoenix
		[189266] = 2, -- Qalashi Trainee
		[189235] = "DRUID", -- Overseer Lahar
		[189265] = 3, -- Qalashi Bonetender
		[189472] = "WARLOCK", -- Qalashi Lavabearer
		[189464] = "WARRIOR", -- Qalashi Irontorch
		[189471] = 1, -- Qalashi Blacksmith
		[189466] = "DRUID", -- Irontorch Commander
		[194816] = 2, -- Forgewroght Monstrosity
		[192781] = 1, -- Ore Elemental
		-- [192786] = 1, -- Qalashi Plunderer
		[192788] = 2, -- Qalashi Thaumaturge
		[193944] = "PRIEST", -- Qalashi Lavamancer
		[194389] = 7, -- Lava Spawn
		[193291] = "DEMONHUNTER", -- Apex Blazewing
		[192464] = 4, -- Raging Ember
	},
	auras = {
	},
}

db["map2095"] = { zone = 1202, -- Ruby Life Pools
	group = 430,
	category = 1005,
	order = {
		"h\\2488", 188244, 188011, 199790, 190484, "25783", -- Melidrussa Chillworn
		"h\\2485", 190206, 190034, 190205, 197697, 197698, 189886, -- Kokia Blazehoof
		"h\\2503", 197509, 198047, 197985, 197535, -- Kyrakka and Erkhart Stormvein
	},
	flags = {
		["*"] = {
			[188252] = 0x0020,
			[189232] = 0x0020,
			[199790] = 0x0020,
			[190484] = 0x0020,
			[190485] = 0x0020,
		},
	},
	recolor = {
		[188244] = 2, -- Primal Juggernaut
		[188011] = 1, -- Primal Terrasentry
		[188067] = "MAGE", -- Flashfrost Chillweaver
		[187897] = "WARRIOR", -- Defier Draghar
		["25783"] = 2, -- Infused Whelp

		[190206] = "WARRIOR", -- Primalist Flamedancer
		[190034] = 3, -- Blazebound Destroyer
		[190205] = 7, -- Scorchling
		[197697] = 2, -- Flamegullet
		[197698] = 2, -- Thunderhead
		[189886] = 4, -- Blazebound Firestorm

		[197509] = 7, -- Primal Thundercloud
		[198047] = "DRUID", -- Tempest Channeler
		[197985] = 1, -- Flame Channeler
		[197535] = "SHAMAN", -- High Channeler Ryvati
	},
	auras = {
		{id = "map2095:372749", spellID = 372749, buff = true, emphasize = true, color = 8}, -- Ice Shield
		{id = "map2095:384933", spellID = 384933, buff = true, emphasize = true, color = 8}, -- Ice Shield
		{id = "map2095:391050", spellID = 391050, buff = true, emphasize = true, color = 8}, -- Tempest Stormshield
	},
}

db["map2073"] = { zone = 1203, -- The Azure Vault
	group = 428,
	category = 1006,
	order = {
		"h\\2492", 196115, 187159, 191313, 196559, -- Leymor
		"h\\2505", 186741, 187154, 186740, 196117, 187155, 191739, 190187, 192955, -- Azureblade
		"h\\2483", 187246, 187240, -- Telash Greywing
		"h\\2508", 199368, 195138, -- Umbrelskul
	},
	flags = {
		["*"] = {
			[186644] = 0x0020,
			[186739] = 0x0020,
			[186737] = 0x0020,
			[186738] = 0x0020,
			[195138] = 0x0004,
			[199368] = 0x0004,
		},
	},
	recolor = {
		[196115] = 1, -- Arcane Tender
		[187159] = 7, -- Shrieking Whelp
		[191313] = 7, -- Bubbling Sapling
		[196559] = 1, -- Volatile Sapling

		[186741] = 1, -- Arcane Elemental
		[187154] = 2, -- Unstable Curator
		[186740] = "DEMONHUNTER", -- Arcane Construct
		[196117] = "DRUID", -- Crystal Thrasher
		[187155] = "PRIEST", -- Rune Seal Keeper
		[191739] = "WARRIOR", -- Scalebane Lieutenant
		[190187] = 1, -- Draconic Image
		[192955] = 4, -- Draconic Illusion

		[187246] = 1, -- Nullmagic Hornswog
		[187240] = "WARRIOR", -- Drakonid Breaker

		[199368] = "DRUID", -- Hardened Crystal
		[195138] = "DRUID", -- Detonating Crystal
	},
	auras = {
		{id = "map2073:389686", spellID = 389686, buff = true, enlarge = true, emphasize = true, color = 10}, -- Arcane Fury
		{id = "map2073:374778", spellID = 374778, buff = true, enlarge = false, emphasize = true, color = 10}, -- Brilliant Scales
	},
}

db["map2093"] = { zone = 1198, -- The Nokhud Offensive
	category = 1007,
	order = {
		"h\\2498", 192789, 192796, 192803, 192791, 192794, 191847, 192800, -- Granyth
		"h\\2497", 194897, 194898, 194895, 194894, 195696, 195265, 194315, 194316, 194317, 195579, -- The Raging Tempest
		"h\\2478", 195855, 195877, 195851, 195842, 195927, 195928, 195929, 195930, -- Teera and Maruuk
		"h\\2477", 199717, 193373, 193457, 193462, 190294, -- Balakar Khan
	},
	flags = {
		["*"] = {
			[186616] = 0x0020,
			[186615] = 0x0020 + 0x0800,
			[186338] = 0x0020,
			[186339] = 0x0020,
			[186151] = 0x0020,
			[194897] = 0x0004,
		},
	},
	recolor = {
		[192789] = "HUNTER", -- Nokhud Longbow
		[192796] = 2, -- Nokhud Hornsounder
		[192803] = 7, -- War Ohuna
		-- [192791] = 1, -- Nokhud Warspear
		[192794] = "DRUID", -- Nokhud Beastmaster
		[191847] = "WARRIOR", -- Nokhud Plainstomper
		[192800] = "WARRIOR", -- Nokhud Lancemaster

		[194897] = 8, -- Stormsurge Totem
		-- [194898] = "DEMONHUNTER", -- Primalist Arcblade
		[194895] = 7, -- Unstable Squall
		[194894] = "DRUID", -- Primalist Stormspeaker
		[195696] = 1, -- Primalist Thunderbeast
		[195265] = "SHAMAN", -- Stormcaller Arynga
		[194315] = "SHAMAN", -- Stormcaller Solongo
		[194316] = "SHAMAN", -- Stormcaller Zarii
		[194317] = "SHAMAN", -- Stormcaller Boroo
		-- [195579] = 7, -- Primal Gust

		[195855] = "WARRIOR", -- Risen Warrior
		-- [195877] = 1, -- Risen Mystic
		[195851] = 2, -- Ukhel Deathspeaker
		[195842] = "WARLOCK", -- Ukhel Deathspeaker
		[195927] = "PRIEST", -- Soulharvester Galtmaa
		[195928] = "PRIEST", -- Soulharvester Duuren
		[195929] = "PRIEST", -- Soulharvester Tumen
		[195930] = "PRIEST", -- Soulharvester Mandakh

		[199717] = "WARRIOR", -- Nokhud Defender
		[193373] = 2, -- Nokhud Thunderfist
		[193457] = 1, -- Balara
		[193462] = "WARRIOR", -- Batak
		[190294] = 4, -- Nokhud Stormcaster
	},
	auras = {
		{id = "map2093:387596", spellID = 387596, buff = true, enlarge = false, emphasize = true, color = 10}, -- Swift Wind
	},
}

db["map2071"] = { zone = 1197, -- Uldaman Legacy of Tyr
	group = 429,
	category = 1008,
	order = {
		"h\\2475", 184134, 184020, 184022, 184023, 184581, 184582, 184580, -- The Lost Dwarves
		"h\\2487", 184019, 186664, 186658, 186696, -- Bromach
		"h\\2484", 184130, 184319, 186420, -- Sentinel Talondras
		"h\\2476", 184132, 184107, 184303, 184301, 186107, -- Emberon
		"h\\2479", 184300, 184131, 184335, 184331, 191311, -- Chrono-Lord Deios
	},
	flags = {
		["*"] = {
			[184580] = 0x0020,
			[184582] = 0x0020,
			[184581] = 0x0020,
			[184018] = 0x0020,
			[184124] = 0x0020 + 0x3800,
			[184422] = 0x0020 + 0x0800,
			[184125] = 0x0020 + 0x0800,
		},
	},
	recolor = {
		[184134] = 7, -- Scavenging Leaper
		[184020] = 2, -- Hulking Berserker
		[184022] = "SHAMAN", -- Stonevault Geomancer
		-- [184023] = 1, -- Vicious Basilisk
		[184581] = 2, -- Baelog
		[184582] = 1, -- Eric "The Swift"
		[184580] = "WARRIOR", -- Olaf

		[184019] = 2, -- Burly Rock-Thrower
		[186664] = 1, -- Stonevault Ambusher
		[186658] = "SHAMAN", -- Stonevault Geomancer
		[186696] = 4, -- Quaking Totem

		-- [184130] = 1, -- Earthen Custodian
		[184319] = 2, -- Refti Custodian
		[186420] = "MAGE", -- Earthen Weaver

		[184132] = "WARLOCK", -- Earthen Warder
		[184107] = "DRUID", -- Runic Protector
		-- [184303] = 2, -- Skittering Crawler
		[184301] = 1, -- Cavern Seeker
		[186107] = 4, -- Vault Keeper

		[184300] = "WARRIOR", -- Ebonstone Golem
		[184131] = 2, -- Earthen Guardian
		-- [184335] = 1, -- Infinite Argent
		[184331] = 2, -- Infinite Timereaver
		[191311] = 7, -- Infinite Whelp
	},
	auras = {
	},
}

db["map325"] = { zone = 68, -- The Vortex Pinnacle
	category = 401,
	order = {
		"h\\114", 45912, 45915, 45477, 45704, 45917, 204337, -- Grand Vizier Ertan
		"h\\115", 45922, 45919, -- Altairus
		"h\\116", 45926, 45928, 45935, 45930, 45932, 52019, -- Asaad, Caliph of Zephyrs
	},
	flags = {
		["*"] = {
			[43878] = 0x0020,
			[43873] = 0x0020,
			[43875] = 0x0020,
		},
	},
	recolor = {
		[45915] = "WARRIOR", -- Armored Mistral
		[45912] = 2, -- Wild Vortex
		-- [45477] = 1, -- Gust Solider
		[45704] = 6, -- Lurking Tempest
		[45917] = "DRUID", -- Cloud Prince
		[204337] = 4, -- Lurking Tempest

		[45922] = "ROGUE", -- Empyrean Assassin
		[45919] = 2, -- Young Storm Dragon

		-- [45926] = 1, -- Servant of Asaad
		[45928] = 2, -- Executor of the Caliph
		[45935] = 3, -- Temple of Adept
		[45930] = "DRUID", -- Minister of Air
		[45932] = 6, -- Skyfall Star
		[52019] = 4, -- Skyfall Nova
	},
	auras = {

	},
}

db["map2125"] = { zone = 1200, -- Vault of the Incarnates
	group = 437,
	category = 1051,
	order = {
		"h\\-", 198310, 197831, 197801, 198081, 198424, 192767, 199182, 193558, 193709, 184693, 198502, 197149, 196856, 198878,
		198868, 198263,	194147, 192761, 197835, 196855, 192769, 198214, -- Trash
		"h\\2480", 187638, 187593, 196845, 196846, -- Eranog
		"h\\2500", 196993, -- Terros
		"h\\2486", 187771, 187768, 187767, 187772, 188026, 196946, -- The Primal Council
		"h\\2482", 189233, 189234, -- Sennarth, the Cold Breath
		"h\\2502", 192934, 194647, 197671, -- Dathea, Ascended
		"h\\2491", 190586, 190588, 190686, 190688, 190690, 198038, -- Kurog Grimtotem
		"h\\2493", 191206, 191222, 191225, 197298, 191215, 191230, 191232, 196679, -- Broodkeeper Diurna
		"h\\2499", 194999, 193760, 194990, 197145, 191714, 198370, -- Raszageth the Storm-Eater
	},
	flags = {
		["*"] = {
			[187638] = 0x0040,
			[196679] = 0x0001,
			[187967] = 0x0800,
			[190496] = 0x0800,
			[194999] = 0x0002 + 0x0004,
		},
	},
	recolor = {
		-- Trash
		[194147] = "DRUID", -- Volcanius
		[192761] = "DRUID", -- Iskakx
		[197835] = "DRUID", -- Kaurdyth
		[196855] = "DRUID", -- Braekkas
		[192769] = "DRUID", -- Thondrozus
		[198214] = "DRUID", -- Broodguardian Ziruss

		[198310] = 7, -- Flame Tarasek
		[197831] = "WARRIOR", -- Quarry Stonebreaker
		[197801] = 2, -- Awakened Terrasentry
		[198081] = 7, -- Quarry Earthshaper
		[198424] = 1, -- Primalist Frostsculptor
		[192767] = 2, -- Primal Icebulk
		[199182] = 7, --
		[193558] = "MAGE", -- Primalist Flamecaller
		[193709] = "WARRIOR", -- Primalist Earthwarden
		[184693] = 1, -- Living Flame
		[198502] = 1, -- Council Stormcaller
		[197149] = "MAGE", -- Qalashi Lavamancer
		-- [196856] = 2, -- Primal Stormsentry
		[198878] = 1, -- Primalist Tempestmaker
		[198868] = "MAGE", -- Primalist Voltweaver
		[198263] = 1, -- Stalwart Broodwarden

		-- Eranog
		[187638] = 6, -- Flamescale Tarasek
		[187593] = 4, -- Primal Flame
		[196845] = "PRIEST", -- Frozen Behemoth
		[196846] = 2, -- Freezing Vapor

		-- Terros
		[196993] = 3, -- Energized Earth

		-- The Primal Council
		[187771] = "MAGE", -- Kadros Icewrath
		[187768] = "SHAMAN", -- Dathea Stormlash
		[187767] = 1, -- Embar Firepath
		-- [187772] = "WARRIOR", -- Opalfang
		[188026] = 4, -- Frost Tomb
		[196946] = "PRIEST", -- Lurking Lunker

		-- Sennarth, the Cold Breath
		[189233] = "ROGUE", -- Caustic Spiderling
		[189234] = "DEMONHUNTER", -- Frostbreath Arachnid

		-- Dathea, Ascended
		[192934] = "DRUID", -- Volatile Infuser
		[197671] = "DRUID", -- Volatile Infuser
		[194647] = 2, -- Thunder Caller

		-- Kurog Grimtotem
		[190586] = 2, -- Earth Braeker
		[190588] = "WARRIOR", -- Tectonic Crusher
		[190686] = "MAGE", -- Frozen Destroyer
		[190688] = 1, -- Blazing Fiend
		[190690] = "PRIEST", -- Thundering Ravager
		[198038] = 3, -- Primal Avatar

		-- Broodkeeper Diurna
		[191206] = "MAGE", -- Primalist Mage
		[191222] = "PRIEST", -- Juvenile Frost Proto-Dragon
		[191225] = "DEMONHUNTER", -- Tarasek Earthreaver
		[197298] = "WARRIOR", -- Nascent Proto-Dragon
		[191215] = 1, -- Tarasek Legionnaire
		[191230] = 3, -- Dragonspawn Flamebender
		[191232] = 2, -- Drakonid Stormbringer
		[196679] = 6, -- Frozen Shroud

		-- Raszageth the Storm-Eater
		-- [194999] = 4, -- Volatile Spark
		[193760] = 2, -- Surging Ruiner
		[194990] = "MAGE", -- Stormseeker Acolyte
		[197145] = 2, -- Colossal Stormfiend
		[191714] = 4, -- Seeking Stormling
		[198370] = "PRIEST", -- Concentrated Storm
	},
	auras = {
		{id = "map2125:375487", spellID = 375487, buff = true, emphasize = true, color = "MONK"}, -- Cauterizing Flashflames
	},
}

db["map2166"] = { zone = 1208, -- Aberrus, the Shadowed Crucible
	group = 438,
	category = 1052,
	order = {
		"h\\-", 201288, 205638,  -- Trash
		"h\\2522",  -- Kazzra, the Hellforged
		"h\\2529", 201773, 201774, 205378, -- The Amalgamation Chamber
		"h\\2530", 202824,  -- The Forgotten Experiments
		"h\\2524", 199703, 200840, 199812, 200836, -- Assault of the Zaqali
		"h\\2525",  -- Rashok, the Elder
		"h\\2532", 203230, -- The Vigilant Steward, Zskarn
		"h\\2527",  -- Magmorax
		"h\\2523", 203812, 202814, -- Echo of Neltharion
		"h\\2520", 202971, -- Scalecommander Sarkareth
	},
	flags = {
		["*"] = {
		},
	},
	recolor = {
		-- Trash
		[201288] = 2, -- Sundered Champion
		[205638] = 9, -- Sundered Flame Banner

		-- The Amalgamation Chamber
		[201773] = "DRUID", -- Eternal Blaze
		[201774] = "WARLOCK", -- Essence of Shadow
		[205378] = "PRIEST", -- Shadowflame Remnant

		-- The Forgotten Experiments
		[202824] = 4, -- Erratic Remnant

		-- Assault of the Zaqali
		[199703] = "PRIEST", -- Magma Mystic
		[200840] = 2, -- Flamebound Huntsman
		[199812] = 1, -- Zaqali Wallclimber
		[200836] = 2, -- Obsidian Guard

		-- The Vigilant Steward, Zskarn
		[203230] = 3, -- Dragonfire Golem

		-- Echo of Neltharion
		[203812] = 6, -- Voice From Beyond
		[202814] = 1, -- Twisted Aberration

		-- Scalecommander Sarkareth
		[202971] = 1, -- Null Glimmer
	},
	auras = {
	},
}
