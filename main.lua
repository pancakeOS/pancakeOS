local guified = require("libs.guified.init")

if arg[2] == "debug" then
    require("lldebugger").start()
end

local wineCheck = require("utils/wine-check") -- Load the wine-check module --? Why?

local customCursor
local selectCursor
--local textCursor

-- Cursor states: "default", "select", "text" (dont suggest changing these lol)
local cursorState = "default"

function love.load()
    wineCheck.blockIfWine() -- Block execution if running under Wine --? Why?

    -- Load custom cursor images
    customCursor = love.mouse.newCursor(love.image.newImageData('assets/images/cursor.png'), 0, 0)
    selectCursor = love.mouse.newCursor(love.image.newImageData('assets/images/cursor_select.png'), 0, 0)

    love.window.maximize()

    love.mouse.setCursor(customCursor)

    guified.registry.register(guified.elements.text("Press F1 for Setup Utility      Press F10 for Boot Menu", 0, 825))
    local vendorLogo = love.graphics.newImage("assets/images/panmicrosystems.png")
    local scale = 1.2
    local guifiedImage = guified.elements.image((love.graphics.getWidth() - vendorLogo:getWidth() * scale) / 2, (love.graphics.getHeight() - vendorLogo:getHeight() * scale) / 2, vendorLogo)
    guifiedImage.resize = function() --? add a hook to it so it will resize when the window WH change
        guifiedImage.setPOS((love.graphics.getWidth() - vendorLogo:getWidth() * scale) / 2, (love.graphics.getHeight() - vendorLogo:getHeight() * scale) / 2)
    end
    guified.registry.register(guifiedImage)
end
