-- board for the notefield
-- this is an underlay to the notefield
-- usually used for measure counters and stuff for edit mode
-- but this lua defines a black background and the cbhighlight stuff

local allowedCustomization = playerConfig:get_data().CustomizeGameplay
local padding = 20 -- 10px on each side
local arrowWidth = 64 -- until noteskin metrics are implemented...

--moving notefield shenanigans
local noteFieldWidth = MovableValues.NotefieldWidth
local oldWidth = noteFieldWidth
local oldspacing = MovableValues.NotefieldSpacing
local filter
local cbContainer

-- this happens when not in gameplay (we dont need it anyways)
if noteFieldWidth == nil then
	return Def.ActorFrame {}
end

local function input(event)
	if getAutoplay() ~= 0 then
		if Movable.current == "DeviceButton_t" and event.type ~= "InputEventType_Release" then
			if event.DeviceInput.button == "DeviceButton_left" then
				oldWidth = noteFieldWidth
				noteFieldWidth = noteFieldWidth - 0.01
				filter:playcommand("Update")
				cbContainer:playcommand("Update")
			end
			if event.DeviceInput.button == "DeviceButton_right" then
				oldWidth = noteFieldWidth
				noteFieldWidth = noteFieldWidth + 0.01
				filter:playcommand("Update")
				cbContainer:playcommand("Update")
			end
		end

		if Movable.current == "DeviceButton_n" and event.type ~= "InputEventType_Release" then
			if event.DeviceInput.button == "DeviceButton_up" or event.DeviceInput.button == "DeviceButton_down" then
				filter:playcommand("Update")
				cbContainer:playcommand("Update")
				oldspacing = MovableValues.NotefieldSpacing
			end
		end
	end
	return false
end

local style = GAMESTATE:GetCurrentStyle()
local cols = style:ColumnsPerPlayer()
local hCols = math.floor(cols / 2)
local evenCols = cols - cols%2
local filterWidth = (arrowWidth * cols) + padding

local function laneHighlight()
	local enabled = playerConfig:get_data().CBHighlight
	local judgeThreshold = Enum.Reverse(TapNoteScore)[ComboContinue()]
	local alpha = 0.4
	local r = Def.ActorFrame {
		InitCommand = function(self)
			cbContainer = self
		end
	}
	local width = style:GetWidth()
	local colWidth = width/cols
	local border = 4
	
	if not enabled then
		return r
	end
	
	for i = 1, cols do
		r[#r+1] = Def.Quad {
			InitCommand = function(self)
				self:zoomto((arrowWidth - 4) * noteFieldWidth, SCREEN_HEIGHT * 2)
				
				local reverse = GAMESTATE:GetPlayerState():GetCurrentPlayerOptions():UsingReverse()
				local receptor = reverse and THEME:GetMetric("Player", "ReceptorArrowsYStandard") or THEME:GetMetric("Player", "ReceptorArrowsYReverse")

				self:diffusealpha(alpha)
				local thewidth
				if noteFieldWidth >= 1 then
					thewidth = math.abs(1-noteFieldWidth)
				else
					thewidth = noteFieldWidth - 1
				end
				-- x position is relative to the center of the notefield
				-- account for the column width and also the number of columns
				-- consider that we are also setting positions without aligns so the coordinate is the center of the column
				self:xy((-(arrowWidth * (cols / 2)) + ((i - 1) * arrowWidth) + (arrowWidth / 2)) + (i-(cols/2)-(1/2))*colWidth*(thewidth),-receptor)
				-- mimic the behavior of the moving function for spacing to set the last bit of x position
				-- this moves all columns except "the middle" by however much the spacing requires
				self:addx((i - hCols - 1) * (MovableValues.NotefieldSpacing and MovableValues.NotefieldSpacing or 0))
				self:fadebottom(0.6):fadetop(0.6)
				self:visible(false)
			end,
			JudgmentMessageCommand=function(self,params)
				local notes = params.Notes
				local firstTrack = params.FirstTrack+1
				if params.HoldNoteScore then return end
				if params.TapNoteScore then
					local enum  = Enum.Reverse(TapNoteScore)[params.TapNoteScore]
					if enum < judgeThreshold and enum > 3 and i == firstTrack then
						self:stoptweening()
						self:visible(true)
						self:diffuse(colorByJudgment(params.TapNoteScore))
						self:diffusealpha(alpha)
						self:tween(0.25, "TweenType_Bezier",{0,0,0.5,0,1,1,1,1})
						self:diffusealpha(0)
					end
				end
			end,
			UpdateCommand = function(self)
				noteFieldWidth = MovableValues.NotefieldWidth
				self:zoomtowidth((colWidth-border) * noteFieldWidth)
				-- add x here, accounting for the difference in the width of the notefield and the difference in the spacing
				self:addx((i-(cols/2)-(1/2))*colWidth * (noteFieldWidth - oldWidth) + (i - hCols - 1) * (MovableValues.NotefieldSpacing - oldspacing))
			end
		}
	end

	return r
end

local t =
	Def.ActorFrame {
	OnCommand = function()
		if (allowedCustomization) then
			-- this isnt really necessary but it stops lua errors
			-- basically this just triggers if we exit playeroptions into gameplay
			-- and i dont want to investigate what causes it
			-- but it doesnt break anything when it happens
			-- so this just stops the lua error and breaks nothing else
			if SCREENMAN:GetTopScreen() == nil then return end
			SCREENMAN:GetTopScreen():AddInputCallback(input)
		end
	end
}

local filterColor = COLORS:getGameplayColor("notefieldBG")
local filterAlphas = playerConfig:get_data().ScreenFilter
if filterAlphas == nil then
	filterAlphas = 0
else
	filterAlphas = tonumber(filterAlphas)
end

t[#t+1] = Def.Quad {
	Name = "SinglePlayerFilter",
	InitCommand = function(self)
		self:zoomto(filterWidth * noteFieldWidth + (MovableValues.NotefieldSpacing and MovableValues.NotefieldSpacing or 0) * evenCols, SCREEN_HEIGHT * 2)
		-- offset the filter by this much for even column counts
		self:addx(cols % 2 == 0 and -(MovableValues.NotefieldSpacing and MovableValues.NotefieldSpacing or 0) / 2 or 0)
		self:diffuse(filterColor)
		self:diffusealpha(filterAlphas)
		filter = self
	end,
	UpdateCommand = function(self)
		noteFieldWidth = MovableValues.NotefieldWidth
		-- offset the filter by the difference in spacing for even column counts
		self:addx(cols % 2 == 0 and -(MovableValues.NotefieldSpacing - oldspacing) / (cols-1) or 0)
		self:zoomto(filterWidth * noteFieldWidth + MovableValues.NotefieldSpacing * evenCols, SCREEN_HEIGHT * 2)
	end
}

t[#t+1] = laneHighlight()

return t