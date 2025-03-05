local Symbols = {}

Symbols.types = {
    star = "star",
    diamond = "diamond",
    club = "club",
    heart = "heart",
    spade = "spade",
    circle = "circle",
    square = "square",
    triangle = "triangle"
}

function Symbols.load()
    Symbols.icons = {
        [Symbols.types.star] = love.graphics.newImage("img/star.png"),
        [Symbols.types.diamond] = love.graphics.newImage("img/diamond.png"),
        [Symbols.types.club] = love.graphics.newImage("img/club.png"),
        [Symbols.types.heart] = love.graphics.newImage("img/heart.png"),
        [Symbols.types.spade] = love.graphics.newImage("img/spade.png"),
        [Symbols.types.circle] = love.graphics.newImage("img/circle.png"),
        [Symbols.types.square] = love.graphics.newImage("img/square.png"),
        [Symbols.types.triangle] = love.graphics.newImage("img/triangle.png")
    }
end

function Symbols.drawSymbol(symbol, x, y, knownStatus)
    if knownStatus then
        love.graphics.draw(Symbols.icons[symbol], x, y, 0, .025, .025)
    else
        love.graphics.print("?", x, y - 3)
    end
end

return Symbols 