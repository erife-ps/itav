local grid = require("grid")
local flexbox = require("flexbox")

local bulletin_scene = {
    grid = nil,
    fonts = {}
}

-- Initialize the bulletin board scene
function bulletin_scene:init()
    self.fonts = {
        title = love.graphics.newFont(28),
        normal = love.graphics.newFont(16)
    }
    
    -- Create a main grid for layout (header + content)
    self.grid = grid.create({
        rows = 2,
        cols = 1,
        padding = 20,
        spacing = 10
    })
    
    -- Initialize bulletin board elements
    self.title = "Community Bulletin Board"
    self.cards = {}
    
    -- Create 7 sample cards with specified dimensions
    for i = 1, 7 do
        table.insert(self.cards, {
            title = "Notice #" .. i,
            text = "This is bulletin card " .. i .. ". Each card is 100x150 pixels.",
            color = {math.random()*0.5+0.5, math.random()*0.5+0.5, math.random()*0.5+0.5},
            width = 100,   -- Card width
            height = 150,  -- Card height
            draw = function(self, x, y, width, height)
                -- Card background
                love.graphics.setColor(self.color[1], self.color[2], self.color[3], 0.9)
                love.graphics.rectangle("fill", x, y, width, height)
                
                -- Card border
                love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
                love.graphics.rectangle("line", x, y, width, height)
                
                -- Card content
                love.graphics.setColor(0, 0, 0)
                love.graphics.setFont(bulletin_scene.fonts.normal)
                love.graphics.printf(self.title, x + 5, y + 10, width - 10, "center")
                love.graphics.printf(self.text, x + 5, y + 40, width - 10, "left")
            end
        })
    end
    
    -- Create flexbox layout for cards
    self.flexLayout = flexbox.create({
        padding = 20,        -- Padding around the container
        margin = 10,         -- Margin between cards
        itemWidth = 100,     -- Default card width
        itemHeight = 150,    -- Default card height
        debug = true         -- Show layout outlines
    })
    
    -- Add cards to flexbox
    self.flexLayout:addItems(self.cards)
end

-- Handle resize events
function bulletin_scene:resize(width, height)
    -- Recalculate layouts
    self:layoutComponents(width, height)
end

-- Layout all components
function bulletin_scene:layoutComponents(width, height)
    -- Update the main grid layout
    self.grid:layout(0, 0, width, height)
    
    -- Get content area (below title)
    local contentCell = self.grid:getCell(2, 1)
    
    -- Update flexbox layout
    self.flexLayout:layout(
        contentCell.x, 
        contentCell.y, 
        contentCell.width, 
        contentCell.height
    )
end

-- Draw the bulletin board scene
function bulletin_scene:draw(x, y, width, height)
    -- Set background
    love.graphics.setColor(0.9, 0.9, 0.95)
    love.graphics.rectangle("fill", x, y, width, height)
    
    -- Calculate layout if needed
    if not self.layoutDone then
        self:layoutComponents(width, height)
        self.layoutDone = true
    end
    
    -- Draw title in first grid cell
    local titleCell = self.grid:getCell(1, 1)
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.setFont(self.fonts.title)
    local titleWidth = self.fonts.title:getWidth(self.title)
    love.graphics.print(
        self.title, 
        titleCell.x + titleCell.width/2 - titleWidth/2, 
        titleCell.y + titleCell.height/2 - self.fonts.title:getHeight()/2
    )
    
    -- Draw cards using flexbox layout
    self.flexLayout:draw()
end

return bulletin_scene 