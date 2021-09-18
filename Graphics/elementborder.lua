-- border used for customize gameplay primarily but feel free to attempt to use it for something else and have it not work

local borderAlpha = 0.2
local buttonHoverAlpha = 0.6

return Def.ActorFrame {
    Name = "BorderContainer", -- not really necessary to have this in an actorframe unless the border is more complex
    UIElements.QuadButton(1) .. {
        Name = "Border",
        OnCommand = function(self)
            self:queuecommand("SetUp")
        end,
        SetUpCommand = function(self)
            local pf = self:GetParent():GetParent()

            -- avoid shadowing self in the below nested functions, so store self in some variable
            local poop = self
            self:GetParent():SetUpdateFunction(function(self)
                -- find the largest actor child of the assigned parent we are making a border for
                -- assign this border to match its size basically
                local bigw = 0
                local bigh = 0
                local eleh = nil
                pf:RunCommandsRecursively(
                    function(self)
                        local w = self:GetZoomedWidth()
                        local h = self:GetZoomedHeight()
                        if w > bigw then bigw = w eleh = self end
                        if h > bigh then bigh = h eleh = self end
                    end
                )
                poop:halign(eleh:GetHAlign())
                poop:valign(eleh:GetVAlign())
                poop:x(eleh:GetX())
                poop:y(eleh:GetY())
                poop:zoomto(bigw, bigh)
            end)
            self:diffusealpha(borderAlpha)

            -- allow this to function as a button
            self:z(5)

            -- place the quad behind the whole actorframe we are bordering
            self:draworder(-99)
            pf:SortByDrawOrder()

            self.alphaDeterminingFunction = function(self)
                if isOver(self) then
                    pf:diffusealpha(buttonHoverAlpha)
                    self:diffusealpha(borderAlpha * buttonHoverAlpha)
                else
                    pf:diffusealpha(1)
                    self:diffusealpha(borderAlpha)
                end
            end
        end,
        MouseOverCommand = function(self)
            self:alphaDeterminingFunction()
        end,
        MouseOutCommand = function(self)
            self:alphaDeterminingFunction()
        end,
        MouseDragCommand = function(self, params)
            local pp = self:GetParent():GetParent()
            local ppp = pp:GetParent()
            local trueX = pp:GetTrueX()
            local trueY = pp:GetTrueY()
            local zoomfactor = 1

            -- this is almost always true but
            -- the primary reason this exists is to offset the Player related things properly
            -- normally it should be 0, but instead it is 640 for example
            -- hindsight comment: gonna be real with u chief this is a huge hack but it works
            -- if it stops working RESTRUCTURE YOUR ELEMENTS
            -- this only works because 'pp' is the ActorFrame that represents the gameplay element
            -- if ppp has been zoomed (breaking everything), then pp is a child of something that isn't a screen,
            -- such as the NoteField being pp and the Player being ppp
            if ppp ~= nil then
                trueX = trueX - ppp:GetTrueX()
                trueY = trueY - ppp:GetTrueY()
                zoomfactor = ppp:GetZoom()
            end

            local newx = params.MouseX + trueX - (self.initialClickX or 0)
            local newy = params.MouseY + trueY - (self.initialClickY or 0)
            pp:x(newx / zoomfactor):y(newy / zoomfactor)
        end,
        MouseDownCommand = function(self, params)
            self.initialClickX = params.MouseX
            self.initialClickY = params.MouseY
        end,
    }
}