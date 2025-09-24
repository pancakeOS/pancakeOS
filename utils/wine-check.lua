-- wine-check.lua
-- We got a AppImage version of PancakeOS for Linux so we block Wine usage Hehe
local ffi = require("ffi")
local P = {}

-- Returns true if running under Wine on Windows
function P.isWine()
    local os = love.system.getOS()
    if os ~= "Windows" then
        return false -- macOS/Linux, skip Wine check
    end

    -- LuaJIT FFI is required duh
    if not jit then return false end

    -- Try to load ntdll.dll and check for wine_get_version
    local ok, ntdll = pcall(ffi.load, "ntdll")
    if not ok then return false end

    ffi.cdef[[
        const char *wine_get_version(void);
    ]]

    local success, fn = pcall(function() return ntdll.wine_get_version end)
    return success and fn ~= nil
end

-- Show message and quit if Wine detected :3
function P.blockIfWine()
    -- Only run on Windows
    if love.system.getOS() ~= "Windows" then -- Check if your runnuing Windows
        return
    end

    if P.isWine() then
        love.window.showMessageBox(
            "Unsupported :(",
            "Wine is not supported!\nYou can download an AppImage from GitHub releases. :)", -- Shows a very nice message :)
            "error"
        )
        love.event.quit()
    end
end

return P
