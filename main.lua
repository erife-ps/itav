io.stdout:setvbuf("no")
require("card")


function love.load()
scenes = {}
scenes.drawBulletinBoard = drawBulletinBoard
scenes.drawEvent = drawEvent
scene = "drawBulletinBoard"

star = "star"
starIcon = love.graphics.newImage("img/star.png")          
diamond = "diamond"
diamondIcon = love.graphics.newImage("img/diamond.png")
club = "club"
clubIcon = love.graphics.newImage("img/club.png")
heart = "heart"
heartIcon = love.graphics.newImage("img/heart.png")
spade = "spade"
spadeIcon = love.graphics.newImage("img/spade.png")
circle = "circle"
circleIcon = love.graphics.newImage("img/circle.png")
square = "square"
squareIcon = love.graphics.newImage("img/square.png")
triangle = "triangle"
triangleIcon = love.graphics.newImage("img/triangle.png")


player = {}
player.name = 'Elaina'
player.cash = 12
player.income = 3
player.thrills = {}
player.chills = {}

table.insert(player.thrills, {star, icon = starIcon, known = true})
table.insert(player.thrills, {diamond, icon = diamondIcon, known = true})
table.insert(player.thrills, {heart, icon = heartIcon, known = false})
table.insert(player.chills, {circle, icon = circleIcon, known = false})
table.insert(player.chills, {square, icon = squareIcon, known = false})
table.insert(player.chills, {triangle, icon = triangleIcon, known = true})

headerFont = love.graphics.newFont(24)
subHeaderFont = love.graphics.newFont(18)

-- Create sample cards
cards = {
    Card({
        initial_cost = 100,
        ongoing_cost = 25,
        symbols = {"A", "B", "C"},
        text = "This is a sample card with multiple lines of text to demonstrate how text wrapping works in the card layout.",
        recurrence = "Every Monday",
        num_tabs = 4,
        x = 50,
        y = 50
    }),
    Card({
        initial_cost = 75,
        ongoing_cost = 15,
        symbols = {"X", "Y"},
        text = "Another sample card with different content.",
        recurrence = "First Tuesday of the month",
        num_tabs = 3,
        x = 270,
        y = 50
    }),
    Card({
        initial_cost = 150,
        ongoing_cost = 50,
        symbols = {"1", "2", "3", "4", "5"},
        text = "A third card with many symbols.",
        recurrence = "Every other Thursday",
        num_tabs = 6,
        x = 490,
        y = 50
    }),
    Card({
        initial_cost = 50,
        ongoing_cost = 10,
        symbols = {"@"},
        text = "Fourth card with minimal symbols.",
        recurrence = "One time",
        num_tabs = 2,
        x = 50,
        y = 370
    }),
    Card({
        initial_cost = 200,
        ongoing_cost = 30,
        symbols = {"#", "$", "%", "&"},
        text = "Final card in the layout.",
        recurrence = "Every Friday",
        num_tabs = 5,
        x = 270,
        y = 370
    })
}
end

function drawHeader()
    love.graphics.setFont(headerFont) 
    love.graphics.print("Elaina", 50, 70)
    love.graphics.setFont(subHeaderFont) 
    love.graphics.print("Cash: " .. player.cash, 50, 100)
    love.graphics.print("Income: " .. player.income, 50, 120)
    drawThrills()
    drawChills()
end

function drawThrills()
    love.graphics.setFont(subHeaderFont) 
    local x = love.graphics.getWidth() * 0.7
    love.graphics.print("Thrills: ", x, 70)
    for i, v in ipairs(player.thrills) do
        if v.known then
            love.graphics.draw(v.icon, x - 20 + i * 20, 95, 0, .025, .025)
        else
            love.graphics.print("?", x - 20 + i * 20, 92)
        end
    end

end


function drawChills()
    love.graphics.setFont(subHeaderFont) 
    local x = love.graphics.getWidth() * 0.8
    love.graphics.print("Chills: ", x, 70)
    for i, v in ipairs(player.chills) do
        if v.known then
            love.graphics.draw(v.icon, x - 20 + i * 20, 95, 0, .025, .025)
        else
            love.graphics.print("?", x - 20 + i * 20, 92)
        end
    end
end

function drawBulletinBoard()
    love.graphics.rectangle("line", 50, 50, 700, 500)

end

function drawEvent()
    love.graphics.print("event", 100, 100)
end


function love.draw()
    -- Set background color
    love.graphics.setBackgroundColor(0.9, 0.9, 0.9)
    
    -- Render all cards
    for _, card in ipairs(cards) do
        card:render()
    end

   -- drawHeader()
   -- scenes[scene]()
end

function love.update(dt)
end

function love.keypressed(key)
    if key == "e" then
        scene = "drawEvent"
    end
    if key == "b" then
        scene = "drawBulletinBoard"
    end
end

