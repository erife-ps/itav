io.stdout:setvbuf("no")

local Card = require("card")
local Player = require("player")
local Symbols = require("symbols")
local Header = require("header")
local Scenes = require("scenes")

function love.load()
    -- Set window size if needed
    love.window.setMode(1280, 720, {
        resizable = true,
        minwidth = 800,
        minheight = 600
    })
    
    -- Load all modules
    Symbols.load()
    Header.load()
    Scenes.load()
    
    -- Create player
    player = Player.setupDefaultPlayer()
    
    -- Create sample cards
    cards = {
        Card({
            initial_cost = 100,
            ongoing_cost = 25,
            symbols = {"A", "B", "C"},
            text = "This is a sample card with multiple lines of text to demonstrate how text wrapping works in the card layout.",
            recurrence = "Every Monday",
            num_tabs = 4
        }),
        Card({
            initial_cost = 75,
            ongoing_cost = 15,
            symbols = {"X", "Y"},
            text = "Another sample card with different content.",
            recurrence = "First Tuesday of the month",
            num_tabs = 3
        }),
        Card({
            initial_cost = 150,
            ongoing_cost = 50,
            symbols = {"1", "2", "3", "4", "5"},
            text = "A third card with many symbols.",
            recurrence = "Every other Thursday",
            num_tabs = 6
        }),
        Card({
            initial_cost = 50,
            ongoing_cost = 10,
            symbols = {"@"},
            text = "Fourth card with minimal symbols.",
            recurrence = "One time",
            num_tabs = 2
        }),
        Card({
            initial_cost = 200,
            ongoing_cost = 30,
            symbols = {"#", "$", "%", "&"},
            text = "Final card in the layout.",
            recurrence = "Every Friday",
            num_tabs = 5
        })
    }

    -- Add more sample cards to test the 5-card layout
    for i = 1, 5 do
        table.insert(cards, Card({
            initial_cost = 50 + i * 25,
            ongoing_cost = 5 + i * 5,
            symbols = {"X" .. i},
            text = "Extra card #" .. i,
            recurrence = "Monthly",
            num_tabs = 3
        }))
    end

    -- Add cards to bulletin board
    for _, card in ipairs(cards) do
        Scenes.addCardToBulletin(card)
    end
    
    -- Explicitly arrange cards after adding them all
    Scenes.arrangeCards()
end

function love.draw()
    -- Set background color
    love.graphics.setBackgroundColor(0.9, 0.9, 0.9)
    
    -- Render all cards
    for _, card in ipairs(cards) do
        card:render()
    end

    -- Draw header and current scene
    -- Uncomment to show the header and scenes
     Scenes.drawCurrentScene(player)
end

function love.update(dt)
    -- Update game logic here
end

function love.keypressed(key)
    if key == "e" then
        Scenes.changeScene("event")
    end
    if key == "b" then
        Scenes.changeScene("bulletinBoard")
    end
end

function love.resize(w, h)
    -- Handle window resize
    Scenes.resize()
end

