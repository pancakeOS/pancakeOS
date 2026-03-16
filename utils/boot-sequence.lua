-- boot-sequence.lua
-- dont need to explain what this does i think you can guess 

local bootSequence = {
    "Checking system RAM: OK",
    "Initializing PancakeKernel: OK" ,
    "Starting pancake.usb: OK",
    "Starting pancake.hid: OK",
    "Starting pancake.bluetooth: OK",
    "Starting pancake.sata: OS",
    "Starting pancake.filesystem: OK",
    "Starting pancake.vga: OK",
    "Starting pancake.gpu: FAIL", -- lets hope it isnt a nvidia gpu
    "Starting pancake.igpu: OK",
    "Starting pancake.cpu: OK",
    "Starting pancake.acpi: OK",
    "Starting pancake.audio: OK",
    "Starting pancake.input: OK",
    "Starting pancake.network: OK",
    "Starting pancake.power: OK",
    "Starting pancake.security: OK",
    "Starting pancake.system: OK",
    "Starting pancake.desktop: OK",
    ".........................",
    "Loading user interface: ..."
}

local bootIndex = 1
local bootText = ""
local bootTimer = 0
local bootDelay = 0.05  -- Delay between characters
local lineDelay = 0.5   -- Delay between lines
local booting = true
local mainBootText = {}
local terminalLaunched = false

-- Memory reservation variables
local totalMemory = 128 * 1024  -- 128 KB of "memory"
local reservedMemory = 0

function startBootSequence()
    booting = true
    bootIndex = 1
    bootText = ""
    bootTimer = 0
    mainBootText = {}
    terminalLaunched = false
    reservedMemory = 0
end

function updateBootSequence(dt)
    if not booting then return end

    bootTimer = bootTimer + dt
    if bootIndex <= #bootSequence then
        if bootTimer >= bootDelay then
            bootTimer = 0
            if bootSequence[bootIndex] == "Reserving system memory..." then
                if reservedMemory < totalMemory then
                    reservedMemory = math.min(reservedMemory + 1024, totalMemory)  -- Increment by 1 KB
                    bootText = string.format("Reserving system memory... %d KB / %d KB", 
                                             reservedMemory / 1024, totalMemory / 1024)
                else
                    bootIndex = bootIndex + 1
                    bootText = ""
                end
            elseif #bootText < #bootSequence[bootIndex] then
                bootText = bootText .. bootSequence[bootIndex]:sub(#bootText + 1, #bootText + 1)
            else
                bootTimer = 0
                table.insert(mainBootText, {text = bootText, color = 2})
                bootIndex = bootIndex + 1
                bootText = ""
                bootTimer = -lineDelay  -- Wait before starting the next line
            end
        end
    else
        booting = false
        if not terminalLaunched then
            terminalLaunched = true
            return true  -- Signal to launch terminal
        end
    end
    return false
end
