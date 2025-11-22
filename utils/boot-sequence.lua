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
    ".........................",
    "Loading user interface: ..."
}
