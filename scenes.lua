local Scenes = {}
local Header = require("header")

function Scenes.load()
    Scenes.current = "bulletinBoard"
    
    Scenes.draw = {
        bulletinBoard = Scenes.drawBulletinBoard,
        event = Scenes.drawEvent
    }
end

function Scenes.drawBulletinBoard()
    love.graphics.rectangle("line", 50, 50, 700, 500)
end

function Scenes.drawEvent()
    love.graphics.print("event", 100, 100)
end

function Scenes.drawCurrentScene(player)
    Header.draw(player)
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