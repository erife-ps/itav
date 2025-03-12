local header = {}

-- Initialize header
function header:init()
    self.fonts = {
        title = love.graphics.newFont(24),
        nav = love.graphics.newFont(16)
    }
    
    self.buttons = {
        {
            text = "Bulletin Board",
            scene = "bulletin",
            x = 0,
            y = 0,
            width = 0,
            height = 0
        },
        {
            text = "Events",
            scene = "event",
            x = 0,
            y = 0,
            width = 0,
            height = 0
        }
    }
end

-- Resize header
function header:resize(width, height)
    -- Layout buttons
    local buttonWidth = width / 4
    for i, button in ipairs(self.buttons) do
        button.width = buttonWidth
        button.height = height / 2
        button.x = width - (buttonWidth * i)
        button.y = height / 4
    end
end

-- Draw header
function header:draw(x, y, width, height)
    -- Background
    love.graphics.setColor(0.2, 0.2, 0.3)
    love.graphics.rectangle("fill", x, y, width, height)
    
    -- Title
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(self.fonts.title)
    love.graphics.print("Community Hub", x + 20, y + height/2 - self.fonts.title:getHeight()/2)
    
    -- Navigation buttons
    love.graphics.setFont(self.fonts.nav)
    for _, button in ipairs(self.buttons) do
        -- Button background
        love.graphics.setColor(0.3, 0.3, 0.4)
        love.graphics.rectangle("fill", button.x, button.y, button.width, button.height)
        
        -- Button text
        love.graphics.setColor(1, 1, 1)
        local textWidth = self.fonts.nav:getWidth(button.text)
        local textHeight = self.fonts.nav:getHeight()
        love.graphics.print(
            button.text, 
            button.x + button.width/2 - textWidth/2, 
            button.y + button.height/2 - textHeight/2
        )
    end
end

-- Handle mouse click
function header:mousepressed(x, y, button)
    if button == 1 then -- Left click
        for _, btn in ipairs(self.buttons) do
            if x >= btn.x and x <= btn.x + btn.width and
               y >= btn.y and y <= btn.y + btn.height then
                local scene_manager = require("scene_manager")
                scene_manager.switchTo(btn.scene)
                break
            end
        end
    end
end

return header 