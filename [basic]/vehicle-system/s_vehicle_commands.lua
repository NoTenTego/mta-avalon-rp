local mysql = exports.mysql

local function isVehicleReady(thePlayer)
    if not getElementData(thePlayer, 'realInVehicle') then
        return
    end

    local vehicle = getPedOccupiedVehicle(thePlayer)
    if not vehicle then
        return
    end

    local seat = getPedOccupiedVehicleSeat(thePlayer)
    if seat ~= 0 then
        return
    end

    return vehicle
end

function toggleEngine(thePlayer)
    local vehicle = isVehicleReady(thePlayer)
    if not vehicle then
        return
    end

    local playerDBID = getElementData(thePlayer, 'id')
    local vehicleOwner = getElementData(vehicle, 'data').owner -- TODO: oprocz tego trzeba pamietac o osobach dla ktorych jest udostepnione auto lub czy jest frakcyjne
    if playerDBID ~= vehicleOwner then
        return
    end

    local engineState = getVehicleEngineState(vehicle) -- TODO: dodać sprawdzenie czy pojazd w ogole posiada silnik
    if engineState then
        setVehicleEngineState(vehicle, false)
    else
        setVehicleEngineState(vehicle, true)
    end
end

function toggleHandbrake(thePlayer) -- TODO: chujowa funkcja - totalnie do zmiany
    local vehicle = isVehicleReady(thePlayer)
    if not vehicle then
        return
    end

    local vehicleSpeed = exports.global:getVehicleVelocity(vehicle)
    local isVehicleGround = isVehicleOnGround(vehicle, 0) -- TODO: ta funkcja ma bledy po uzyciu setVehicleHandling (trzeba przeniesc do client side i skorzystac z innej funkcji)

    if vehicleSpeed > 0 then
        return triggerClientEvent(thePlayer, 'hud:sendNotification', thePlayer, 'warning', 'Hamulec ręczny', 'Pojazd nie może się poruszać żeby zaciągnąć ręczny.')
    end

    if isElementFrozen(vehicle) then
        setElementFrozen(vehicle, false)
    else
        setElementFrozen(vehicle, true)
    end
end

function toggleLights(thePlayer)
    local vehicle = isVehicleReady(thePlayer)
    if not vehicle then
        return
    end

    local lights = getVehicleOverrideLights(vehicle) -- TODO: dodać sprawdzenie czy pojazd w ogole posiada światła
    if lights ~= 2 then
        setVehicleOverrideLights(vehicle, 2)
    else
        setVehicleOverrideLights(vehicle, 1)
    end
end

local keysBind = {{
    key = 'k',
    state = 'down',
    func = toggleEngine
}, {
    key = 'l',
    state = 'down',
    func = toggleLights
}, {
    key = 'lalt',
    state = 'down',
    func = toggleHandbrake
}}

addEventHandler('onResourceStart', getResourceRootElement(getThisResource()), function()
    for _, player in pairs(getElementsByType('player')) do
        if getElementData(player, 'loggedIn') == true then
            for i, keyBind in pairs(keysBind) do
                if not isKeyBound(player, keyBind.key, keyBind.state, keyBind.func) then
                    bindKey(player, keyBind.key, keyBind.state, keyBind.func)
                end
            end
        end
    end
end)

addEventHandler('onPlayerJoin', root, function()
    for i, keyBind in pairs(keysBind) do
        if not isKeyBound(source, keyBind.key, keyBind.state, keyBind.func) then
            bindKey(source, keyBind.key, keyBind.state, keyBind.func)
        end
    end
end)

function updateDataVehicleMenu(thePlayer)
    local playerDBID = getElementData(thePlayer, 'id')
    local result = mysql:query('SELECT vehicles.*, vehlib.mta_model, vehlib.id AS vehlib_id, vehlib.brand, vehlib.model, vehlib.year FROM vehicles INNER JOIN vehlib ON vehicles.vehlib = vehlib.id WHERE vehicles.owner=?', playerDBID)
    triggerClientEvent(thePlayer, 'vehicle-system:updateVehicleMenu', thePlayer, result)
end
addEvent('vehicle-system:updateDataVehicleMenu', true)
addEventHandler('vehicle-system:updateDataVehicleMenu', root, updateDataVehicleMenu)

addCommandHandler('v', function(thePlayer, commandName, subCommandName)
    if not subCommandName then
        local playerDBID = getElementData(thePlayer, 'id')
        local result = mysql:query('SELECT vehicles.*, vehlib.mta_model, vehlib.id AS vehlib_id, vehlib.brand, vehlib.model, vehlib.year FROM vehicles INNER JOIN vehlib ON vehicles.vehlib = vehlib.id WHERE vehicles.owner=?', playerDBID)

        if #result == 0 then
            return triggerClientEvent(thePlayer, 'hud:sendNotification', thePlayer, 'info', 'Lista pojazdów', 'Nie posiadasz żadnego pojazdu.')
        end
        
        triggerClientEvent(thePlayer, 'vehicle-system:toggleVehicleMenu', thePlayer, true, result)
    end

    if subCommandName == 'drzwi' or subCommandName == 'otworz' then
        local vehicle = getPedOccupiedVehicle(thePlayer)
        if not vehicle then

            local x, y, z = getElementPosition(thePlayer)
            local interior = getElementInterior(thePlayer)
            local dimension = getElementDimension(thePlayer)
            local foundVehicle = nil

            for _, vehicle in pairs(getElementsByType('vehicle')) do
                local vehicleX, vehicleY, vehicleZ = getElementPosition(vehicle)
                local vehicleInterior = getElementInterior(vehicle)
                local vehicleDimension = getElementDimension(vehicle)

                if interior == vehicleInterior and dimension == vehicleDimension then
                    local distance = getDistanceBetweenPoints3D(x, y, z, vehicleX, vehicleY, vehicleZ)
                    local playerDBID = getElementData(thePlayer, 'id')
                    local vehicleOwner = getElementData(vehicle, 'data').owner -- TODO: oprocz tego trzeba pamietac o osobach dla ktorych jest udostepnione auto lub czy jest frakcyjne

                    if distance < 10 and playerDBID == vehicleOwner then
                        foundVehicle = vehicle
                        break
                    end
                end
            end

            if not foundVehicle then
                return
            end

            if isVehicleLocked(foundVehicle) then
                setVehicleLocked(foundVehicle, false)
            else
                setVehicleLocked(foundVehicle, true)
            end

            setPedAnimation(thePlayer, "INT_HOUSE", "wash_up", 750, false, false, false, false, 250)

            local x, y, z = getElementPosition(foundVehicle)
            triggerClientEvent(root, 'global:playSound3D', root, 'carAlarmChirp.mp3', 1, {x, y, z}, false, 30)

            for i = 0, 5 do
                setVehicleDoorOpenRatio(foundVehicle, i, 0, 1200)
            end
        else
            if not getElementData(thePlayer, 'realInVehicle') then
                return
            end

            local seat = getPedOccupiedVehicleSeat(thePlayer)

            if seat ~= 0 then
                return
            end

            local playerDBID = getElementData(thePlayer, 'id')
            local vehicleOwner = getElementData(vehicle, 'data').owner -- TODO: oprocz tego trzeba pamietac o osobach dla ktorych jest udostepnione auto lub czy jest frakcyjne

            if playerDBID ~= vehicleOwner then
                return
            end

            if isVehicleLocked(vehicle) then
                setVehicleLocked(vehicle, false)
            else
                setVehicleLocked(vehicle, true)
            end

            local x, y, z = getElementPosition(vehicle)
            triggerClientEvent(root, 'global:playSound3D', root, 'carLock.mp3', 2, {x, y, z}, false, 20)

            for i = 0, 5 do
                setVehicleDoorOpenRatio(vehicle, i, 0, 1200)
            end
        end
    end
end)
