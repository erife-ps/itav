local grid = require("grid")
local flexbox = require("flexbox")
local shared_state = require("shared_state")

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
    
    -- List of event names
    local events = {
        "Dance Party - Friday Night",
        "Book Club Discussion",
        "Community Garden Meetup",
        "Cooking Workshop",
        "Movie Night",
        "Art Exhibition",
        "Yoga Class"
    }
    
    -- Create cards with events
    for i = 1, 7 do
        table.insert(self.cards, {
            id = i,  -- Add ID for tracking selection
            title = events[i],
            text = "Join us for this exciting community event! Click to add to your schedule.",
            color = {math.random()*0.5+0.5, math.random()*0.5+0.5, math.random()*0.5+0.5},
            width = 100,
            height = 150,
            selected = false,
            draw = function(self, x, y, width, height)
                -- Card background
                love.graphics.setColor(self.color[1], self.color[2], self.color[3], 0.9)
                love.graphics.rectangle("fill", x, y, width, height)
                
                -- Card border (red if selected)
                if shared_state.isEventSelected(self.id) then
                    love.graphics.setColor(1, 0, 0, 0.8)
                    love.graphics.setLineWidth(3)
                else
                    love.graphics.setColor(0.2, 0.2, 0.2, 0.8)
                    love.graphics.setLineWidth(1)
                end
                love.graphics.rectangle("line", x, y, width, height)
                love.graphics.setLineWidth(1)  -- Reset line width
                
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
        padding = 20,
        margin = 10,
        itemWidth = 100,
        itemHeight = 150,
        debug = true
    })
    
    -- Add cards to flexbox
    self.flexLayout:addItems(self.cards)
end

-- Handle mouse clicks on cards
function bulletin_scene:mousepressed(x, y, button)
    if button == 1 then  -- Left click
        for _, card in ipairs(self.cards) do
            -- Check if click is within card boundaries
            if x >= card.x and x <= card.x + card.width and
               y >= card.y and y <= card.y + card.height then
                -- Toggle selection
                if shared_state.isEventSelected(card.id) then
                    shared_state.removeSelectedEvent(card.id)
                else
                    shared_state.addSelectedEvent({
                        id = card.id,
                        title = card.title,
                        text = card.text,
                        color = card.color
                    })
                end
                return true  -- Click handled
            end
        end
    end
    return false  -- Click not on any card
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

-- Handle resize events
function bulletin_scene:resize(width, height)
    -- Recalculate layouts
    self:layoutComponents(width, height)
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
    
    -- Draw instructions
    love.graphics.setFont(self.fonts.normal)
    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.printf(
        "Click on events to add them to your schedule", 
        x + 20, 
        height - 40, 
        width - 40, 
        "center"
    )
end

return bulletin_scene 