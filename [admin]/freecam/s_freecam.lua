function setPlayerFreecamEnabled(player, x, y, z, dontChangeFixedMode)
    removePedFromVehicle(player)
    setElementData(player, "realinvehicle", 0, false)

    return triggerClientEvent(player, "doSetFreecamEnabled", getRootElement(), x, y, z, dontChangeFixedMode)
end

function setPlayerFreecamDisabled(player, dontChangeFixedMode)
    return triggerClientEvent(player, "doSetFreecamDisabled", getRootElement(), dontChangeFixedMode)
end

function setPlayerFreecamOption(player, theOption, value)
    return triggerClientEvent(player, "doSetFreecamOption", getRootElement(), theOption, value)
end

function isPlayerFreecamEnabled(player)
    return isEnabled(player)
end

function asyncActivateFreecam()
    if not exports.global:hasPermission(source, 'freecam', 'activate') then
        return
    end

    if not isEnabled(source) then
        removePedFromVehicle(source)
        setElementAlpha(source, 0)
        setElementFrozen(source, true)
        setElementData(source, "freecam:state", true, false)
    end
end
addEvent("freecam:asyncActivateFreecam", true)
addEventHandler("freecam:asyncActivateFreecam", root, asyncActivateFreecam)

function asyncDeactivateFreecam()
    if true or isEnabled(source) then
        removePedFromVehicle(source)
        setElementAlpha(source, 255)
        setElementFrozen(source, false)
        setElementData(source, "freecam:state", false, false)
    end
end
addEvent("freecam:asyncDeactivateFreecam", true)
addEventHandler("freecam:asyncDeactivateFreecam", root, asyncDeactivateFreecam)

