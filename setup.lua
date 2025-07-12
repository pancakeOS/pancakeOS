-- setup.lua

-- When u first start pancakeOS, you will see this screen (Also in the original scratch project lol)

local setup = {}

function setup.load()
    --load images
    pancakeosLogo = love.graphics.newImage('assets/logo.png')
end 

function setup.draw()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local logoWidth, logoHeight = pancakeosLogo:getWidth(), pancakeosLogo:getHeight()
    local scale = 1.2

    love.graphics.draw(pancakeosLogo, (windowWidth - logoWidth * scale) / 2, (windowHeight - logoHeight * scale) / 2, 0, scale, scale)

    love.graphics.print("Welcome to PancakeOS Setup Utility", 10, 10)
    love.graphics.print("Press Enter to continue...", 10, 30)
end