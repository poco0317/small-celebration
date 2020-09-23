local t = Def.ActorFrame {
    Name = "ProfileSelectFile",
    InitCommand = function(self)
        self:x(SCREEN_WIDTH)
    end,
    BeginCommand = function(self)
        self:smooth(0.5)
        self:x(0)
    end,
}

local ratios = {
    FrameLeftGap = 1303 / 1920, -- left of screen to left of item bg
    FrameUpperGap = 50 / 1080, -- from top of screen to top of first item bg
    Width = 555 / 1920,
    ItemHeight = 109 / 1080,

    ItemGlowVerticalSpan = 12 / 1080, -- measurement of visible portion of the glow doubled
    ItemGlowHorizontalSpan = 12 / 1920, -- same
    ItemGap = 57 / 1080, -- distance between the bg of items

    AvatarWidth = 109 / 1920,

    NameLeftGap = 8 / 1920, -- from edge of avatar to left edge of words
    NameUpperGap = 11 / 1080, -- top edge to top edge
    InfoLeftGap = 9 / 1920, -- from edge of avatar to left edge of lines below profile name
    Info1UpperGap = 39 / 1080, -- top edge to top edge
    Info2UpperGap = 62 / 1080, -- middle line
    Info3UpperGap = 85 / 1080, -- bottom line
    NameToRatingRequiredGap = 25 / 1920, -- we check this amount on player name lengths
    -- if the distance is not at least this much, truncate the name until it works

    RatingLeftGap = 393 / 1920, -- left edge to left edge of text
    -- this means the allowed space for this text is Width - RatingLeftGap
    RatingInfoUpperGap = 11 / 1080,
    OnlineUpperGap = 43 / 1080,
    OfflineUpperGap = 79 / 1080,
}

local actuals = {
    FrameLeftGap = ratios.FrameLeftGap * SCREEN_WIDTH,
    FrameUpperGap = ratios.FrameUpperGap * SCREEN_HEIGHT,
    Width = ratios.Width * SCREEN_WIDTH,
    ItemHeight = ratios.ItemHeight * SCREEN_HEIGHT,
    ItemGlowVerticalSpan = ratios.ItemGlowVerticalSpan * SCREEN_HEIGHT,
    ItemGlowHorizontalSpan = ratios.ItemGlowHorizontalSpan * SCREEN_WIDTH,
    ItemGap = ratios.ItemGap * SCREEN_HEIGHT,
    AvatarWidth = ratios.AvatarWidth * SCREEN_WIDTH,
    NameLeftGap = ratios.NameLeftGap * SCREEN_WIDTH,
    NameUpperGap = ratios.NameUpperGap * SCREEN_HEIGHT,
    InfoLeftGap = ratios.InfoLeftGap * SCREEN_WIDTH,
    Info1UpperGap = ratios.Info1UpperGap * SCREEN_HEIGHT,
    Info2UpperGap = ratios.Info2UpperGap * SCREEN_HEIGHT,
    Info3UpperGap = ratios.Info3UpperGap * SCREEN_HEIGHT,
    NameToRatingRequiredGap = ratios.NameToRatingRequiredGap * SCREEN_WIDTH,
    RatingLeftGap = ratios.RatingLeftGap * SCREEN_WIDTH,
    RatingInfoUpperGap = ratios.RatingInfoUpperGap * SCREEN_HEIGHT,
    OnlineUpperGap = ratios.OnlineUpperGap * SCREEN_HEIGHT,
    OfflineUpperGap = ratios.OfflineUpperGap * SCREEN_HEIGHT,
}

local profileIDs = PROFILEMAN:GetLocalProfileIDs()
local renameNewProfile = false
local focused = false

-- how many items to put on screen -- will fit for any screen height
local numItems = #profileIDs > 1 and math.floor(SCREEN_HEIGHT / (actuals.ItemHeight + actuals.ItemGap)) or 1
local itemBGColor = color("0,0,0,1")

local nameTextSize = 0.75
local playcountTextSize = 0.5
local arrowsTextSize = 0.5
local playTimeTextSize = 0.5
local playerRatingsTextSize = 0.75
local onlineTextSize = 0.6
local offlineTextSize = 0.6

local textzoomFudge = 5

-- if there are no profiles, make a new one
if #profileIDs == 0 then
    local new = PROFILEMAN:CreateDefaultProfile()
    profileIDs = PROFILEMAN:GetLocalProfileIDs()
    renameNewProfile = true
end

local function generateItems()
    local maxPage = math.ceil(#profileIDs / numItems)
    local page = 1
    local selectionIndex = 1

    -- select current option with keyboard or mouse double click
    local function selectCurrent()
        PROFILEMAN:SetProfileIDToUse(profileIDs[selectionIndex])
        SCREENMAN:GetTopScreen():PlaySelectSound()
        TITLE:HandleFinalGameStart()
    end

    -- move page with keyboard or mouse
    local function movePage(n)
        if maxPage <= 1 then
            return
        end

        -- math to make pages loop both directions
        local nn = (page + n) % (maxPage + 1)
        if nn == 0 then
            nn = n > 0 and 1 or maxPage
        end
        page = nn

        MESSAGEMAN:Broadcast("MovedPage")
    end

    -- move current selection using keyboard
    local function move(n)
        local beforeindex = selectionIndex
        selectionIndex = clamp(selectionIndex + n, 1, #profileIDs)
        local lowerbound = numItems * (page-1) + 1
        local upperbound = numItems * page
        if lowerbound > selectionIndex or upperbound < selectionIndex then
            page = clamp(math.floor((selectionIndex-1) / numItems) + 1, 1, maxPage)
            MESSAGEMAN:Broadcast("MovedPage")
        else
            MESSAGEMAN:Broadcast("MovedIndex")
        end
        if beforeindex ~= selectionIndex then
            SCREENMAN:GetTopScreen():PlayChangeSound()
        end
    end

    -- change focus back to scroller options with keyboard
    local function backOut()
        TITLE:ChangeFocus()
    end


    local function generateItem(i)
        local index = i
        local profile = nil
        local id = nil

        return Def.ActorFrame {
            Name = "Choice_"..i,
            InitCommand = function(self)
                self:y((i-1) * (actuals.ItemHeight + actuals.ItemGap))
                self:diffusealpha(0)
            end,
            BeginCommand = function(self)
                self:playcommand("Set")
            end,
            UpdateProfilesCommand = function(self)
                self:playcommand("Set")
            end,
            MovedPageMessageCommand = function(self)
                index = (page-1) * numItems + i
                self:playcommand("Set")
            end,
            SetCommand = function(self)
                if profileIDs[index] then
                    id = profileIDs[index]
                    profile = PROFILEMAN:GetLocalProfile(id)
                    self:finishtweening()
                    self:smooth(0.1)
                    self:diffusealpha(1)
                else
                    id = nil
                    profile = nil
                    self:finishtweening()
                    self:smooth(0.1)
                    self:diffusealpha(0)
                end
            end,

            UIElements.QuadButton(1) .. {
                Name = "BG",
                InitCommand = function(self)
                    self:halign(0):valign(0)
                    self:zoomto(actuals.Width, actuals.ItemHeight)
                    self:diffuse(itemBGColor)
                end,
                MouseDownCommand = function(self, params)
                    if self:IsInvisible() then return end
                    if params.event == "DeviceButton_left mouse button" then
                        if selectionIndex == index and focused then
                            selectCurrent()
                        else
                            selectionIndex = index
                            MESSAGEMAN:Broadcast("MovedIndex")
                        end
                    end
                end
            },
            Def.Sprite {
                Name = "Avatar",
                InitCommand = function(self)
                    self:halign(0):valign(0)
                end,
                SetCommand = function(self)
                    self:Load(getAssetPathFromProfileID("avatar", id))
                    self:zoomto(actuals.AvatarWidth, actuals.ItemHeight)
                end
            },
            Def.ActorFrame {
                Name = "LeftText",
                InitCommand = function(self)
                    self:x(actuals.AvatarWidth)
                end,

                LoadFont("Common Normal") .. {
                    Name = "NameRank",
                    InitCommand = function(self)
                        self:x(actuals.NameLeftGap)
                        self:y(actuals.NameUpperGap)
                        self:valign(0):halign(0)
                        self:zoom(nameTextSize)
                        -- this maxwidth probably wont cause issues
                        -- .... but if it does.....
                        self:maxwidth((actuals.RatingLeftGap - actuals.AvatarWidth - actuals.NameLeftGap) / nameTextSize - textzoomFudge)
                    end,
                    SetCommand = function(self)
                        if profile then
                            local name = profile:GetDisplayName()
                            self:visible(false)
                            self:truncateToWidth(name, (actuals.RatingLeftGap - actuals.AvatarWidth - actuals.NameLeftGap) - textzoomFudge - 25)
                            self:visible(true)
                        end
                    end
                },
                LoadFont("Common Normal") .. {
                    Name = "Playcount",
                    InitCommand = function(self)
                        self:x(actuals.InfoLeftGap)
                        self:y(actuals.Info1UpperGap)
                        self:valign(0):halign(0)
                        self:zoom(playcountTextSize)
                        self:maxwidth((actuals.RatingLeftGap - actuals.AvatarWidth - actuals.InfoLeftGap) / playcountTextSize - textzoomFudge)
                    end,
                    SetCommand = function(self)
                        if profile then
                            local scores = profile:GetTotalNumSongsPlayed()
                            self:settextf("%d plays", scores)
                        end
                    end
                },
                LoadFont("Common Normal") .. {
                    Name = "Arrows",
                    InitCommand = function(self)
                        self:x(actuals.InfoLeftGap)
                        self:y(actuals.Info2UpperGap)
                        self:valign(0):halign(0)
                        self:zoom(arrowsTextSize)
                        self:maxwidth((actuals.RatingLeftGap - actuals.AvatarWidth - actuals.InfoLeftGap) / arrowsTextSize - textzoomFudge)
                    end,
                    SetCommand = function(self)
                        if profile then
                            local taps = profile:GetTotalTapsAndHolds()
                            self:settextf("%d arrows smashed", taps)
                        end
                    end
                },
                LoadFont("Common Normal") .. {
                    Name = "Playtime",
                    InitCommand = function(self)
                        self:x(actuals.InfoLeftGap)
                        self:y(actuals.Info3UpperGap)
                        self:valign(0):halign(0)
                        self:zoom(playTimeTextSize)
                        self:maxwidth((actuals.RatingLeftGap - actuals.AvatarWidth - actuals.InfoLeftGap) / playTimeTextSize - textzoomFudge)
                    end,
                    SetCommand = function(self)
                        if profile then
                            local secs = profile:GetTotalSessionSeconds()
                            self:settextf("%s playtime", SecondsToHHMMSS(secs))
                        end
                    end
                }
            },
            Def.ActorFrame {
                Name = "RightText",
                InitCommand = function(self)
                    self:x(actuals.RatingLeftGap)
                end,

                LoadFont("Common Normal") .. {
                    Name = "PlayerRatings",
                    InitCommand = function(self)
                        self:y(actuals.RatingInfoUpperGap)
                        self:valign(0):halign(0)
                        self:zoom(playerRatingsTextSize)
                        self:maxwidth((actuals.Width - actuals.RatingLeftGap) / playerRatingsTextSize - textzoomFudge)
                        self:settext("Player Ratings:")
                    end
                },
                --[[-- online ratings for individual profiles have no direct api
                LoadFont("Common Normal") .. {
                    Name = "Online",
                    InitCommand = function(self)
                        self:y(actuals.OnlineUpperGap)
                        self:valign(0):halign(0)
                        self:zoom(onlineTextSize)
                        self:maxwidth((actuals.Width - actuals.RatingLeftGap) / onlineTextSize - textzoomFudge)
                    end,
                    SetCommand = function(self)
                        self:settext("Online - 00.00")
                    end
                },]]
                LoadFont("Common Normal") .. {
                    Name = "Offline",
                    InitCommand = function(self)
                        self:y(actuals.OfflineUpperGap)
                        self:valign(0):halign(0)
                        self:zoom(offlineTextSize)
                        self:maxwidth((actuals.Width - actuals.RatingLeftGap) / offlineTextSize - textzoomFudge)
                    end,
                    SetCommand = function(self)
                        if profile then
                            local rating = profile:GetPlayerRating()
                            self:settextf("Offline - %5.2f", rating)
                        end
                    end
                }
            }
        }
    end

    local t = Def.ActorFrame {
        Name = "ItemList",
        InitCommand = function(self)
            self:xy(actuals.FrameLeftGap, actuals.FrameUpperGap)
        end,
        BeginCommand = function(self)
            -- make sure the focus is set on the scroller options
            -- false means that we are focused on the profile choices
            TITLE:SetFocus(true)
            SCREENMAN:set_input_redirected(PLAYER_1, false)
            SCREENMAN:GetTopScreen():AddInputCallback(function(event)
                if focused then
                    if event.type == "InputEventType_FirstPress" then
                        if event.button == "MenuUp" or event.button == "Up" 
                        or event.button == "MenuLeft" or event.button == "Left" then
                            move(-1)
                        elseif event.button == "MenuDown" or event.button == "Down" 
                        or event.button == "MenuRight" or event.button == "Right" then
                            move(1)
                        elseif event.button == "Start" then
                            selectCurrent()
                        elseif event.button == "Back" then
                            backOut()
                        end
                    end
                end
            end)
        end,
        FirstUpdateCommand = function(self)
            if renameNewProfile then
                local profile = PROFILEMAN:GetLocalProfile(profileIDs[1])
                local function f(answer)
                    profile:RenameProfile(answer)
                    self:playcommand("UpdateProfiles")
                end
                local question = "No Profiles detected! A new one was made for you.\nPlease enter a new profile name."
                askForInputStringWithFunction(
                    question,
                    64,
                    false,
                    f,
                    function(answer)
                        local result = answer ~= nil and answer:gsub("^%s*(.-)%s*$", "%1") ~= "" and not answer:match("::") and answer:gsub("^%s*(.-)%s*$", "%1"):sub(-1) ~= ":"
                        if not result then
                            SCREENMAN:GetTopScreen():GetChild("Question"):settext(question .. "\nDo not leave this space blank. Do not use ':'")
                        end
                        return result, "Response invalid."
                    end
                )
            end
        end,
        ToggledTitleFocusMessageCommand = function(self, params)
            focused = not params.scrollerFocused
            -- focused means we must pay attention to the profiles instead of the left scroller
            if focused then
                if #profileIDs == 1 then
                    -- there is only 1 choice, no need to care about picking a profile
                    -- skip forward
                    TITLE:HandleFinalGameStart()
                else
                    -- consider our options...
                    -- (locking input here because of a race condition that counts our enter button press twice)
                    SCREENMAN:GetTopScreen():lockinput(0.05)
                    SCREENMAN:set_input_redirected(PLAYER_1, true)
                end
            else
                SCREENMAN:set_input_redirected(PLAYER_1, false)
            end
            self:GetChild("FocusBG"):playcommand("FocusChange")
        end,

        Def.Quad {
            Name = "FocusBG",
            InitCommand = function(self)
                self:diffuse(color("0,0,0"))
                self:diffusealpha(0)
            end,
            BeginCommand = function(self)
                -- offset position to fill whole screen
                self:xy(-self:GetParent():GetX(), -self:GetParent():GetY())
                self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
                self:halign(0):valign(0)
            end,
            FocusChangeCommand = function(self)
                if focused then
                    self:hurrytweening(0.5)
                    self:smooth(0.4)
                    self:diffusealpha(0.75)
                else
                    self:hurrytweening(0.5)
                    self:smooth(0.4)
                    self:diffusealpha(0)
                end
            end
        },
        Def.Quad {
            Name = "MouseWheelRegion",
            InitCommand = function(self)
                self:diffusealpha(0)
            end,
            BeginCommand = function(self)
                -- offset position to fill whole screen
                self:xy(-self:GetParent():GetX(), -self:GetParent():GetY())
                self:zoomto(SCREEN_WIDTH, SCREEN_HEIGHT)
                self:halign(0):valign(0)
            end,
            MouseScrollMessageCommand = function(self, params)
                if params.direction == "Up" then
                    movePage(-1)
                else
                    movePage(1)
                end
            end
        },


        Def.Sprite {
            Name = "Cursor",
            Texture = THEME:GetPathG("", "profileselectorGlow"),
            InitCommand = function(self)
                self:xy(-actuals.ItemGlowHorizontalSpan / 2, -actuals.ItemGlowVerticalSpan / 2)
                self:halign(0):valign(0)
                self:zoomto(actuals.Width + actuals.ItemGlowHorizontalSpan, actuals.ItemHeight + actuals.ItemGlowVerticalSpan)
            end,
            MovedPageMessageCommand = function(self)
                local lowerbound = numItems * (page-1) + 1
                local upperbound = math.min(numItems * page, #profileIDs)
                if lowerbound > selectionIndex or upperbound < selectionIndex then
                    local cursorpos = (selectionIndex-1) % numItems
                    local newpos = cursorpos + (page-1) * numItems + 1
                    if profileIDs[newpos] == nil then
                        -- dont let the cursor get into an impossible position
                        selectionIndex = clamp(newpos, lowerbound, upperbound)
                    else
                        selectionIndex = newpos
                    end
                end
                self:playcommand("MovedIndex")
            end,
            MovedIndexMessageCommand = function(self)
                local cursorindex = (selectionIndex-1) % numItems
                self:finishtweening()
                self:linear(0.05)
                self:y(cursorindex * (actuals.ItemHeight + actuals.ItemGap) - actuals.ItemGlowVerticalSpan / 2)
            end
        }
    }

    for i = 1, numItems do
        t[#t+1] = generateItem(i)
    end
    return t
end

t[#t+1] = generateItems()

return t