addEvent("vehicle-system:cefData", true)
addEventHandler("vehicle-system:cefData", root, function(switch, data)
    if switch == 'makeVehicle' then
        data = fromJSON(data)
        triggerServerEvent('vehicle-system:makeVehicle', localPlayer, data)
    end

    if switch == 'deleteVehicle' then
        triggerServerEvent('vehicle-system:deleteVehicle', localPlayer, data)
    elseif switch == 'editHandling' then
        triggerServerEvent('vehicle-system:editHandling', localPlayer, data)
    elseif switch == 'cancelHandling' then
        triggerServerEvent('vehicle-system:cancelEditingHandling', localPlayer, localPlayer)
    elseif switch == 'updateHandling' then
        data = fromJSON(data)
        triggerServerEvent('vehicle-system:updateHandling', localPlayer, data)
    elseif switch == 'saveHandling' then
        triggerServerEvent('vehicle-system:saveHandling', localPlayer)
    elseif switch == 'resetHandling' then
        triggerServerEvent('vehicle-system:resetHandling', localPlayer)
    elseif switch == 'editVehicle' then
        data = fromJSON(data)
        triggerServerEvent('vehicle-system:editVehicle', localPlayer, data)
    end

    if switch == 'spawnVehicle' then
        triggerServerEvent('vehicle-system:vehicleSpawnMenu', localPlayer, 'spawnVehicle', localPlayer, data)
        triggerServerEvent('vehicle-system:updateDataVehicleMenu', localPlayer, localPlayer)
    elseif switch == 'trackVehicle' then
        triggerServerEvent('vehicle-system:vehicleSpawnMenu', localPlayer, 'trackVehicle', localPlayer, data)
    elseif switch == 'toggleVehiclePanel' then
        toggleVehicleMenu(false)
    end
end)
