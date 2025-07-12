-- crash.lua

-- Purpose is a script to make a Blue Screen of Death type thing but we will call it the Orange Screen of Death
-- this only happens when (smtg)

local crash = {}

function crash.load()
    -- Load the crash images (totally not a rickroll and sob emoji)
    crash_qrcode = love.graphics.newImage('assets/crash_qrcode.png')
    crash_sob = love.graphics.newImage('assets/crash_sob.png')
    font = love.graphics.newFont('assets/fonts/UbuntuMono.tff', 17)
end

function crash.draw()
    love.graphics.draw(crash_sob, 100, 100)
end

