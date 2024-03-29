local c
local enabledJudgment = playerConfig:get_data().JudgmentText
local JTEnabled = false--JudgementTweensEnabled()

local JudgeCmds = {
	TapNoteScore_W1 = THEME:GetMetric("Judgment", "JudgmentW1Command"),
	TapNoteScore_W2 = THEME:GetMetric("Judgment", "JudgmentW2Command"),
	TapNoteScore_W3 = THEME:GetMetric("Judgment", "JudgmentW3Command"),
	TapNoteScore_W4 = THEME:GetMetric("Judgment", "JudgmentW4Command"),
	TapNoteScore_W5 = THEME:GetMetric("Judgment", "JudgmentW5Command"),
	TapNoteScore_Miss = THEME:GetMetric("Judgment", "JudgmentMissCommand")
}

local TNSFrames = {
	TapNoteScore_W1 = 0,
	TapNoteScore_W2 = 1,
	TapNoteScore_W3 = 2,
	TapNoteScore_W4 = 3,
	TapNoteScore_W5 = 4,
	TapNoteScore_Miss = 5
}

local t = Def.ActorFrame {
	Name = "Judgment", -- c++ renames this to "Judgment" 
	BeginCommand = function(self)
		c = self:GetChildren()
		-- queued to run slightly late
		self:queuecommand("SetUpMovableValues")
		registerActorToCustomizeGameplayUI(self)
	end,
	SetUpMovableValuesMessageCommand = function(self)
		self:xy(MovableValues.JudgmentX, MovableValues.JudgmentY)
		self:zoom(MovableValues.JudgmentZoom)
	end,
	Def.Sprite {
		Texture = "../../../../" .. getAssetPath("judgment"),
		Name = "Judgment",
		InitCommand = function(self)
			self:pause()
			self:visible(false)
		end,
		ResetCommand = function(self)
			self:finishtweening()
			self:stopeffect()
			self:visible(false)
		end,
	},

	JudgmentMessageCommand = function(self, param)
		if param.HoldNoteScore or param.FromReplay then
			return
		end
		local iNumStates = c.Judgment:GetNumStates()
		local iFrame = TNSFrames[param.TapNoteScore]
		if not iFrame then
			return
		end
		if iNumStates == 12 then
			iFrame = iFrame * 2
			if not param.Early then
				iFrame = iFrame + 1
			end
		end

		self:playcommand("Reset")
		c.Judgment:visible(true)
		c.Judgment:setstate(iFrame)
		if JTEnabled then
			JudgeCmds[param.TapNoteScore](c.Judgment)
		end
	end,
}

if enabledJudgment then
	return t
end

return Def.ActorFrame {}
