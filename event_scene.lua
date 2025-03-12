local shared_state = require("shared_state")

local event_scene = {
    fonts = {}
}

-- Initialize the event scene
function event_scene:init()
    self.fonts = {
        title = love.graphics.newFont(28),
        normal = love.graphics.newFont(16),
        small = love.graphics.newFont(14)
    }
    
    -- Sample event data
    self.events = {
        {
            title = "Community Gathering",
            date = "March 15, 2023",
            description = "Join us for a community gathering at the town square."
        },
        {
            title = "Workshop",
            date = "April 2, 2023",
            description = "Learn new skills at our workshop event."
        },
        {
            title = "Game Night",
            date = "April 10, 2023",
            description = "Fun and games for the whole community."
        }
    }
end

-- Draw the event scene
function event_scene:draw(x, y, width, height)
    -- Background
    love.graphics.setColor(0.85, 0.9, 0.95)
    love.graphics.rectangle("fill", x, y, width, height)
    
    -- Title
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.setFont(self.fonts.title)
    local title = "Your Selected Events"
    local titleWidth = self.fonts.title:getWidth(title)
    love.graphics.print(title, x + width/2 - titleWidth/2, y + 30)
    
    -- Get selected events
    local events = shared_state.getSelectedEvents()
    
    -- Display selected events or instruction message
    if #events == 0 then
        love.graphics.setFont(self.fonts.normal)
        love.graphics.setColor(0.4, 0.4, 0.4)
        love.graphics.printf(
            "You haven't selected any events yet.\nGo to the Bulletin Board to select events.", 
            x + 50, 
            y + height/2 - 30, 
            width - 100, 
            "center"
        )
    else
        -- Events list
        love.graphics.setFont(self.fonts.normal)
        local eventHeight = 80
        local startY = y + 100
        
        for i, event in ipairs(events) do
            local eventY = startY + (i-1) * (eventHeight + 20)
            
            -- Event card background (using original color)
            love.graphics.setColor(event.color[1], event.color[2], event.color[3], 0.8)
            love.graphics.rectangle("fill", x + 50, eventY, width - 100, eventHeight)
            
            -- Event border
            love.graphics.setColor(0.2, 0.2, 0.2)
            love.graphics.rectangle("line", x + 50, eventY, width - 100, eventHeight)
            
            -- Event details
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(event.title, x + 70, eventY + 15)
            love.graphics.setFont(self.fonts.small)
            love.graphics.print(event.text, x + 70, eventY + 40)
            
            -- Remove button
            love.graphics.setColor(0.9, 0.3, 0.3, 0.8)
            love.graphics.rectangle("fill", x + width - 120, eventY + 15, 60, 25)
            
            love.graphics.setColor(1, 1, 1)
            love.graphics.setFont(self.fonts.small)
            love.graphics.print("Remove", x + width - 115, eventY + 20)
        end
    end
end

-- Handle resize events
function event_scene:resize(width, height)
    -- Nothing specific needed for resizing
end

-- Handle mouse clicks to remove events
function event_scene:mousepressed(x, y, button)
    if button == 1 then -- left click
        local events = shared_state.getSelectedEvents()
        local eventHeight = 80
        local startY = 100  -- This is relative to the scene's y position
        
        -- We need to account for the scene's y position (100px below header)
        local sceneY = y - 100  -- Adjust y to be relative to scene start
        
        for i, event in ipairs(events) do
            local eventY = startY + (i-1) * (eventHeight + 20)
            
            -- Check if click is on the remove button
            if x >= love.graphics.getWidth() - 120 and
               x <= love.graphics.getWidth() - 60 and
               sceneY >= eventY + 15 and
               sceneY <= eventY + 40 then
                shared_state.removeSelectedEvent(event.id)
                print("Removing event: " .. event.title)
                return true
            end
        end
    end
    return false
end

return event_scene 