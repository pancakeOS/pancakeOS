
local cursorImage
local customCursor
local selectCursorImage
local selectCursor
local textCursorImage
local textCursor

-- Cursor states: "default", "select", "text" (dont suggest changing these lol)
local cursorState = "default"

function love.load()

    vendorLogo = love.graphics.newImage('assets/panmicrosystems.png')

    love.window.setMode(800, 600, {
        resizable = true,
        minwidth = 800,
        minheight = 600,
        highdpi = true
    })

    love.window.maximize()

    -- Load custom cursor images
    cursorImage = love.image.newImageData('assets/cursor.png')
    customCursor = love.mouse.newCursor(cursorImage, 0, 0)
    selectCursorImage = love.image.newImageData('assets/cursor_select.png')
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

