local guified = require("libs.guified.init")
local discordRPC = require("libs.discordRPC") -- require the discordRPC module

local appId = "1456929588977598617" -- application id

if arg[2] == "debug" then
    require("lldebugger").start()
end

local wineCheck = require("utils/wine-check") -- Load the wine-check module
local bootSequence = require("utils/boot-sequence") -- load bootSequence

function discordRPC.ready(userId, username, discriminator, avatar)
    print(string.format("Discord: ready (%s, %s, %s, %s)", userId, username, discriminator, avatar))
end

function discordRPC.disconnected(errorCode, message)
    print(string.format("Discord: disconnected (%d: %s)", errorCode, message))
end

function discordRPC.errored(errorCode, message)
    print(string.format("Discord: error (%d: %s)", errorCode, message))
end

function discordRPC.joinGame(joinSecret)
    print(string.format("Discord: join (%s)", joinSecret))
end

function discordRPC.spectateGame(spectateSecret)
    print(string.format("Discord: spectate (%s)", spectateSecret))
end

function discordRPC.joinRequest(userId, username, discriminator, avatar)
    print(string.format("Discord: join request (%s, %s, %s, %s)", userId, username, discriminator, avatar))
    discordRPC.respond(userId, "yes")
end

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

    -- Initialize Discord RPC
    discordRPC.initialize(appId, true)
    local now = os.time(os.date("*t"))
    presence = {
        state = "Looking to Play",
        details = "1v1 (Ranked)",
        startTimestamp = now,
        endTimestamp = now + 60,
        partyId = "party id",
        partyMax = 2,
        matchSecret = "match secret",
        joinSecret = "join secret",
        spectateSecret = "spectate secret",
    }

    nextPresenceUpdate = 0
end

function love.update()
    if nextPresenceUpdate < love.timer.getTime() then
        discordRPC.updatePresence(presence)
        nextPresenceUpdate = love.timer.getTime() + 2.0
    end
    discordRPC.runCallbacks()
end

function love.quit()
    discordRPC.shutdown()
end
