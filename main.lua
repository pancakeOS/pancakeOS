
local cursorImage
local customCursor
local selectCursorImage
local selectCursor
local textCursorImage
local textCursor

-- Cursor states: "default", "select", "text" (dont suggest changing these lol)
local cursorState = "default"

function love.load()
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
