local defaultGameplaySizeRatios = {
	HEIGHTBASED = {
		-- instances of 480 are based on til death
		-- otherwise should probably be 720
		-- old gameplay text sizes should probably go here too
		judgeDisplayVerticalSpacing = 10 / 480,
		miniProgressBar = 4 / 480,
		npsGraph = 100 / 480,
		playerInfoFrameYFromBottom = 50 / 480,
		playerInfoAvatar = 50 / 480,
		playerInfoMeterY = 24 / 480,
		playerInfoMSDY = 28 / 480,
		playerInfoModsY = 39 / 480,
		playerInfoJudgeY = -2 / 480,
		playerInfoScoreTypeY = 8 / 480,

		-- textsizes
		bpmDisplayText = 0.4 / 480,
		errorBarText = 0.35 / 480,
		fullProgressBarText = 0.45 / 480,
		judgeDisplayJudgeText = 0.4 / 480,
		judgeDisplayCountText = 0.35 / 480,
		meanDisplayText = 0.3 / 480,
		npsDisplayText = 1 / 480,
		playerInfoModsText = 0.4 / 480,
		playerInfoJudgeText = 0.45 / 480,
		playerInfoMeterText = 0.45 / 480,
		playerInfoMSDText = 1.1 / 480,
		playerInfoScoreTypeText = 0.45 / 480,
		rateDisplayText = 0.35 / 480,
		wifeDisplayText = 0.3 / 480,
	},
	WIDTHBASED = {
		-- instances of 854 are based on til death
		-- otherwise should probably be 1280
		errorBarBarWidth = 2 / 854,
		fullProgressBarWidthBeforeHalf = 100 / 854, -- these names dont ask
		judgeDisplay = 60 / 854,
		miniProgressBar = 34 / 854,
		npsGraph = 140 / 854,
		playerInfoFrameX = 0 / 854,
		playerInfoMeter = 120 / 854,
		playerInfoMeterX = 90 / 854,
		playerInfoMSDX = 52 / 854,
		playerInfoModsX = 91 / 854,
		playerInfoJudgeX = 53 / 854,
		playerInfoScoreTypeX = 53 / 854,
	},
}

GAMEPLAY = {}
function GAMEPLAY.getItemHeight(self, item)
	if defaultGameplaySizeRatios.HEIGHTBASED[item] == nil then
		return 0
	end
	return defaultGameplaySizeRatios.HEIGHTBASED[item] * SCREEN_HEIGHT
end
function GAMEPLAY.getItemWidth(self, item)
	if defaultGameplaySizeRatios.WIDTHBASED[item] == nil then
		return 0
	end
	return defaultGameplaySizeRatios.WIDTHBASED[item] * SCREEN_WIDTH
end
-- im not gonna be that mean, have some aliases
function GAMEPLAY.getItemY(self, item)
	return self:getItemHeight(item)
end
function GAMEPLAY.getItemX(self, item)
	return self:getItemWidth(item)
end


local defaultGameplayCoordinates = {
	JudgeX = 0,
	JudgeY = 0,
	ComboX = 30/854*SCREEN_WIDTH,
	ComboY = -20/480*SCREEN_HEIGHT,
	ErrorBarX = SCREEN_CENTER_X,
	ErrorBarY = SCREEN_CENTER_Y + 53/480*SCREEN_HEIGHT,
	TargetTrackerX = SCREEN_CENTER_X + 26/854*SCREEN_WIDTH,
	TargetTrackerY = SCREEN_CENTER_Y + 25/480*SCREEN_HEIGHT,
	MiniProgressBarX = SCREEN_CENTER_X + 44/854*SCREEN_WIDTH,
	MiniProgressBarY = SCREEN_CENTER_Y + 34/480*SCREEN_HEIGHT,
	FullProgressBarX = SCREEN_CENTER_X,
	FullProgressBarY = 20/480*SCREEN_HEIGHT,
	JudgeCounterX = SCREEN_CENTER_X / 2,
	JudgeCounterY = SCREEN_CENTER_Y,
	DisplayPercentX = SCREEN_CENTER_X / 2 + 60/2, -- above the judge counter, middle of it
	DisplayPercentY = SCREEN_CENTER_Y - 54.5/480*SCREEN_HEIGHT,
	DisplayMeanX = SCREEN_CENTER_X / 2 + 60/2, -- below the judge counter, middle of it
	DisplayMeanY = SCREEN_CENTER_Y + 46.5/480*SCREEN_HEIGHT,
	NPSDisplayX = 5,
	NPSDisplayY = SCREEN_BOTTOM - 175/480*SCREEN_HEIGHT,
	NPSGraphX = 0,
	NPSGraphY = SCREEN_BOTTOM - 160/480*SCREEN_HEIGHT,
	NoteFieldX = 0,
	NoteFieldY = 0,
	ProgressBarPos = 1,
	LeaderboardX = 0,
	LeaderboardY = SCREEN_HEIGHT / 10,
	ReplayButtonsX = SCREEN_WIDTH - 45/854*SCREEN_WIDTH,
	ReplayButtonsY = SCREEN_HEIGHT / 2 - 100/480*SCREEN_HEIGHT,
	LifeP1X = 178/854*SCREEN_WIDTH,
	LifeP1Y = 10/480*SCREEN_HEIGHT,
	LifeP1Rotation = 0,
	PracticeCDGraphX = 10/854*SCREEN_WIDTH,
	PracticeCDGraphY = 85/480*SCREEN_HEIGHT,
	BPMTextX = SCREEN_CENTER_X,
	BPMTextY = SCREEN_BOTTOM - 20/480*SCREEN_HEIGHT,
	MusicRateX = SCREEN_CENTER_X,
	MusicRateY = SCREEN_BOTTOM - 10/480*SCREEN_HEIGHT,
}

local defaultGameplaySizes = {
	JudgeZoom = 1.0,
	ComboZoom = 0.6,
	ErrorBarWidth = 240/854*SCREEN_WIDTH,
	ErrorBarHeight = 10/480*SCREEN_HEIGHT,
	TargetTrackerZoom = 0.4,
	FullProgressBarWidth = 1.0,
	FullProgressBarHeight = 1.0,
	DisplayPercentZoom = 1,
	DisplayMeanZoom = 1,
	NPSDisplayZoom = 0.5,
	NPSGraphWidth = 1.0,
	NPSGraphHeight = 1.0,
	NoteFieldWidth = 1.0,
	NoteFieldHeight = 1.0,
	NoteFieldSpacing = 0.0,
	LeaderboardWidth = 1.0,
	LeaderboardHeight = 1.0,
	LeaderboardSpacing = 0.0,
	ReplayButtonsZoom = 1.0,
	ReplayButtonsSpacing = 0.0,
	LifeP1Width = 1.0,
	LifeP1Height = 1.0,
	PracticeCDGraphWidth = 0.8,
	PracticeCDGraphHeight = 1,
	MusicRateZoom = 1.0,
	BPMTextZoom = 1.0
}

local defaultConfig = {
	BPMDisplay = true,
	DisplayPercent = true,
	ErrorBar = 1,
	FullProgressBar = true,
	JudgeCounter = true,
	LaneCover = 0, -- soon to be changed to: 0=off, 1=sudden, 2=hidden
	-- leaderboard
	DisplayMean = true,
	MeasureCounter = true,
	MiniProgressBar = true,
	NPSDisplay = true,
	NPSGraph = true,
	PlayerInfo = true,
	RateDisplay = true,
	TargetTracker = true,

	JudgmentText = true,
	ComboText = true,
	CBHighlight = true,

	ConvertedAspectRatio = false, -- defaults false so that we can load and convert element positions, then set true
	CurrentHeight = SCREEN_HEIGHT,
	CurrentWidth = SCREEN_WIDTH,

	ScreenFilter = 1,
	JudgeType = 1,
	AvgScoreType = 0,
	GhostScoreType = 1,
	TargetGoal = 93,
	TargetTrackerMode = 0,
	leaderboardEnabled = false,
	LaneCoverHeight = 10,
	ReceptorSize = 100,
	ErrorBarCount = 30,
	BackgroundType = 1,
	UserName = "",
	PasswordToken = "",
	CustomizeGameplay = false,
	PracticeMode = false,
	GameplayXYCoordinates = {
		["3K"] = DeepCopy(defaultGameplayCoordinates),
		["4K"] = DeepCopy(defaultGameplayCoordinates),
		["5K"] = DeepCopy(defaultGameplayCoordinates),
		["6K"] = DeepCopy(defaultGameplayCoordinates),
		["7K"] = DeepCopy(defaultGameplayCoordinates),
		["8K"] = DeepCopy(defaultGameplayCoordinates),
		["9K"] = DeepCopy(defaultGameplayCoordinates),
		["10K"] = DeepCopy(defaultGameplayCoordinates),
		["12K"] = DeepCopy(defaultGameplayCoordinates),
		["16K"] = DeepCopy(defaultGameplayCoordinates)
	},
	GameplaySizes = {
		["3K"] = DeepCopy(defaultGameplaySizes),
		["4K"] = DeepCopy(defaultGameplaySizes),
		["5K"] = DeepCopy(defaultGameplaySizes),
		["6K"] = DeepCopy(defaultGameplaySizes),
		["7K"] = DeepCopy(defaultGameplaySizes),
		["8K"] = DeepCopy(defaultGameplaySizes),
		["9K"] = DeepCopy(defaultGameplaySizes),
		["10K"] = DeepCopy(defaultGameplaySizes),
		["12K"] = DeepCopy(defaultGameplaySizes),
		["16K"] = DeepCopy(defaultGameplaySizes)
	}
}

function getDefaultGameplaySize(obj)
	return defaultGameplaySizes[obj]
end

function getDefaultGameplayCoordinate(obj)
	return defaultGameplayCoordinates[obj]
end

playerConfig = create_setting("playerConfig", "playerConfig.lua", defaultConfig, -1)
local convertXPosRatio = 1
local convertYPosRatio = 1
local tmp2 = playerConfig.load
playerConfig.load = function(self, slot)
	local tmp = force_table_elements_to_match_type
	force_table_elements_to_match_type = function()
	end
	local x = create_setting("playerConfig", "playerConfig.lua", {}, -1)
	x = x:load(slot)

	-- aspect ratio is not the same. we must account for this
	if x.GameplayXYCoordinates ~= nil and (not x.ConvertedAspectRatio or x.CurrentHeight ~= defaultConfig.CurrentHeight or x.CurrentWidth ~= defaultConfig.CurrentWidth) then
		x.ConvertedAspectRatio = true
		defaultConfig.ConvertedAspectRatio = true

		-- set up a default 16:9 480p (all themes that use playerConfig use this, Til' Death and spawncamping-wallhack)
		-- i realize this is not 16:9 but promise, this is correct according to how the game works
		-- no further explanation
		if not x.CurrentHeight then
			x.CurrentHeight = 480
		end
		if not x.CurrentWidth then
			x.CurrentWidth = 854
		end

		--[[
			OTHER VALUES FOR THE WEIRDOS THAT USE THEM: IM NOT GONNA BOTHER ACCOMODATING YOU ANY FURTHER THAN THIS
			(all HEIGHT values are 480)
			(if your height value is not 480, you know how to generate these numbers - stop looking at them, they are not correct for you)
				4:3 - WIDTH: 640
				16:10 - WIDTH: 768
				21:9 - WIDTH: 1120
				8:3 - WIDTH: 1280
				5:4 - WIDTH: 600
				1:1 - WIDTH: 480
				3:4 - WIDTH: 360
			USE A CUSTOM DisplayAspectRatio PREFERENCE? FIGURE IT OUT YOURSELF
			HINT: IT ISN'T 480 x DisplayAspectRatio (look in ScreenDimensions.cpp)
			ms.ok(SCREEN_WIDTH .. " " .. SCREEN_HEIGHT)
		]]

		convertXPosRatio = x.CurrentWidth / defaultConfig.CurrentWidth
		convertYPosRatio = x.CurrentHeight / defaultConfig.CurrentHeight
	end

	-------
	-- cope with a minor renaming of the NoteField elements
	-- didnt test
	if x.GameplayXYCoordinates ~= nil and x.GameplayXYCoordinates.NotefieldX ~= nil then
		defaultGameplayCoordinates.NoteFieldX = x.GameplayXYCoordinates.NotefieldX
	end
	if x.GameplayXYCoordinates ~= nil and x.GameplayXYCoordinates.NotefieldY ~= nil then
		defaultGameplayCoordinates.NoteFieldY = x.GameplayXYCoordinates.NotefieldY
	end
	if x.GameplaySizes ~= nil and x.GameplaySizes.NotefieldWidth ~= nil then
		defaultGameplaySizes.NoteFieldWidth = x.GameplaySizes.NotefieldWidth
	end
	if x.GameplaySizes ~= nil and x.GameplaySizes.NotefieldSpacing ~= nil then
		defaultGameplaySizes.NoteFieldSpacing = x.GameplaySizes.NotefieldSpacing
	end
	if x.GameplaySizes ~= nil and x.GameplaySizes.NotefieldHeight ~= nil then
		defaultGameplaySizes.NoteFieldHeight = x.GameplaySizes.NotefieldHeight
	end
	-------

	--------
	-- converts single 4k setup to the multi keymode setup (compatibility with very old customize gameplay versions)
	local coords = x.GameplayXYCoordinates
	local sizes = x.GameplaySizes
	if sizes and not sizes["4K"] then
		defaultConfig.GameplaySizes["3K"] = sizes
		defaultConfig.GameplaySizes["4K"] = sizes
		defaultConfig.GameplaySizes["5K"] = sizes
		defaultConfig.GameplaySizes["6K"] = sizes
		defaultConfig.GameplaySizes["7K"] = sizes
		defaultConfig.GameplaySizes["8K"] = sizes
		defaultConfig.GameplaySizes["9K"] = sizes
		defaultConfig.GameplaySizes["10K"] = sizes
		defaultConfig.GameplaySizes["12K"] = sizes
		defaultConfig.GameplaySizes["16K"] = sizes
	end
	if coords and not coords["4K"] then
		defaultConfig.GameplayXYCoordinates["3K"] = coords
		defaultConfig.GameplayXYCoordinates["4K"] = coords
		defaultConfig.GameplayXYCoordinates["5K"] = coords
		defaultConfig.GameplayXYCoordinates["6K"] = coords
		defaultConfig.GameplayXYCoordinates["7K"] = coords
		defaultConfig.GameplayXYCoordinates["8K"] = coords
		defaultConfig.GameplayXYCoordinates["9K"] = coords
		defaultConfig.GameplayXYCoordinates["10K"] = coords
		defaultConfig.GameplayXYCoordinates["12K"] = coords
		defaultConfig.GameplayXYCoordinates["16K"] = coords
	end
	--
	--------
	force_table_elements_to_match_type = tmp
	return tmp2(self, slot)
end
playerConfig:load()

-- converting coordinates if aspect ratio changes across loads
local coords = playerConfig:get_data().GameplayXYCoordinates
if coords and coords["4K"] then
	-- converting all categories individually
	for cat, t in pairs(playerConfig:get_data().GameplayXYCoordinates) do
		for e, v in pairs(t) do
			-- dont scale defaulted coordinates
			if defaultGameplayCoordinates[e] ~= nil and v ~= defaultGameplayCoordinates[e] then
				if e:sub(-1) == "Y" then
					-- convert y pos
					t[e] = v / convertYPosRatio
				elseif e:sub(-1) == "X" then
					-- convert x pos
					t[e] = v / convertXPosRatio
				end
			end
		end
	end
	
	-- hacks for specifically the error bar this is really bad
	local sz = playerConfig:get_data().GameplaySizes
	if sz and sz["4K"] then
		for cat, t in pairs(sz) do
			if t["ErrorBarWidth"] ~= defaultGameplaySizes["ErrorBarWidth"] then
				sz[cat]["ErrorBarWidth"] = t["ErrorBarWidth"] / convertXPosRatio
			end
			if t["ErrorBarHeight"] ~= defaultGameplaySizes["ErrorBarHeight"] then
				sz[cat]["ErrorBarHeight"] = t["ErrorBarHeight"] / convertYPosRatio
			end
		end
	end
	playerConfig:get_data().ConvertedAspectRatio = true
end