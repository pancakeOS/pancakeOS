if arg[2] == "debug" then
    require("lldebugger").start()
end

local wineCheck = require("utils/wine-check") -- Load the wine-check module -- Why?

local cursorImage
local customCursor
local selectCursorImage
local selectCursor
--local textCursorImage
--local textCursor

local vendorLogo --? have it as a local not a global

-- Cursor states: "default", "select", "text" (dont suggest changing these lol)
local cursorState = "default"

function love.load()

    wineCheck.blockIfWine() -- Block execution if running under Wine

    vendorLogo = love.graphics.newImage('assets/images/panmicrosystems.png')

    love.window.setMode(800, 600, {
        resizable = true,
        minwidth = 800,
        minheight = 600,
        highdpi = true
    })

    love.window.maximize()

    -- Load custom cursor images
    cursorImage = love.image.newImageData('assets/images/cursor.png')
    customCursor = love.mouse.newCursor(cursorImage, 0, 0)
    selectCursorImage = love.image.newImageData('assets/images/cursor_select.png')
    selectCursor = love.mouse.newCursor(selectCursorImage, 0, 0)

    love.mouse.setCursor(customCursor)
end

function love.draw()
    local windowWidth, windowHeight = love.graphics.getDimensions()
    local logoWidth, logoHeight = vendorLogo:getWidth(), vendorLogo:getHeight()
    local scale = 1.2

    love.graphics.draw(vendorLogo, (windowWidth - logoWidth * scale) / 2, (windowHeight - logoHeight * scale) / 2, 0, scale, scale)

    love.graphics.print("Press F1 for Setup Utility      Press F10 for Boot Menu", 0, 825)
    
end
