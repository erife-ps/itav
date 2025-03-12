local Scenes = {}
local Header = require("header")
local Card = require("card")

function Scenes.load()
    Scenes.current = "bulletinBoard"
    
    Scenes.draw = {
        bulletinBoard = Scenes.drawBulletinBoard,
        event = Scenes.drawEvent
    }
    
    -- Store cards for the bulletin board
    Scenes.bulletinCards = {}
end

function Scenes.addCardToBulletin(card)
    table.insert(Scenes.bulletinCards, card)
end

function Scenes.drawBulletinBoard()
    -- Draw bulletin board background
    love.graphics.setColor(0.9, 0.8, 0.7)
    love.graphics.rectangle("fill", 20, 50, love.graphics.getWidth() - 40, love.graphics.getHeight() - 60)
    love.graphics.setColor(0.6, 0.5, 0.4)
    love.graphics.rectangle("line", 20, 50, love.graphics.getWidth() - 40, love.graphics.getHeight() - 60)
    
    -- Draw bulletin board title
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("COMMUNITY BULLETIN BOARD", 30, 60)
    
    -- Draw all cards in the bulletin board
    for _, card in ipairs(Scenes.bulletinCards) do
        card:render()
    end
end

function Scenes.drawEvent()
    love.graphics.print("Event View", 100, 100)
    -- Event view content would go here
end

function Scenes.drawCurrentScene(player)
    -- Reset color
    love.graphics.setColor(1, 1, 1)
    
    -- Draw the header first
    Header.draw(player)
    
    -- Then draw the current scene content
    love.graphics.setColor(1, 1, 1)
    Scenes.draw[Scenes.current]()
end

function Scenes.changeScene(sceneName)
    if Scenes.draw[sceneName] then
        Scenes.current = sceneName
        return true
    end
    return false
end

return Scenes 