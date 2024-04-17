local attachedItem = {
    effect = {},
    sound = {},
    effectTimer = {}
}

function handleMakeEffect(vehicle)
    local vehicleX, vehicleY, vehicleZ = getElementPosition(vehicle)
    local vehicleDimension = getElementDimension(vehicle)

    attachedItem.sound[vehicle] = playSound3D('sounds/blowoff.wav', vehicleX, vehicleY, vehicleZ)
    attachElements(attachedItem.sound[vehicle], vehicle)
    setElementDimension(attachedItem.sound[vehicle], vehicleDimension)
    setSoundVolume(attachedItem.sound[vehicle], 0.4)
end

local lastGear = 1

addEventHandler("onClientRender", root, function()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle then
        return
    end

    local actualGear = getVehicleCurrentGear(vehicle)

    if actualGear > lastGear then
        lastGear = actualGear

        handleMakeEffect(vehicle)
    elseif actualGear < lastGear then
        lastGear = actualGear
    end
end)
