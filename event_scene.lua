local event_scene = {
    fonts = {}
}

-- Initialize the event scene
function event_scene:init()
    self.fonts = {
        title = love.graphics.newFont(28),
        normal = love.graphics.newFont(16)
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
    local title = "Upcoming Events"
    local titleWidth = self.fonts.title:getWidth(title)
    love.graphics.print(title, x + width/2 - titleWidth/2, y + 30)
    
    -- Events list
    love.graphics.setFont(self.fonts.normal)
    local eventHeight = 100
    local startY = y + 100
    
    for i, event in ipairs(self.events) do
        local eventY = startY + (i-1) * (eventHeight + 20)
        
        -- Event card background
        love.graphics.setColor(1, 1, 1, 0.8)
        love.graphics.rectangle("fill", x + 50, eventY, width - 100, eventHeight)
        
        -- Event details
        love.graphics.setColor(0.1, 0.1, 0.1)
        love.graphics.print(event.title, x + 70, eventY + 15)
        love.graphics.print(event.date, x + 70, eventY + 40)
        love.graphics.print(event.description, x + 70, eventY + 65)
    end
end

-- Handle resize events
function event_scene:resize(width, height)
    -- Nothing specific needed for resizing in this scene
end

return event_scene 