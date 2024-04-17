local mysql = exports.mysql

function findInTable(t, value)
    for k, v in pairs(t) do
        if value == k then
            return v
        end
    end

    return false
end

function math.percent(percent, maxvalue)
    if tonumber(percent) and tonumber(maxvalue) then
        return (maxvalue * percent) / 100
    end
    return false
end

local trackTimer = {}
local trackMarker = {}
local trackBlip = {}

function vehicleSpawnMenu(switch, thePlayer, vehicleId)
    if switch == 'spawnVehicle' then
        local result = mysql:query('SELECT vehicles.*, vehlib.id AS vehlib_id, vehlib.mta_model, vehlib.brand, vehlib.model, vehlib.year, vehlib.price, vehlib.variant, vehlib.additional, vehlib.handling FROM vehicles INNER JOIN vehlib ON vehicles.vehlib = vehlib.id WHERE vehicles.id = ?', vehicleId)
        if not result then
            return triggerClientEvent(thePlayer, 'hud:sendNotification', thePlayer, 'warning', 'Spawn pojazdu', 'Wystąpił problemy [001] ze spawnem pojazdu, zgłoś to!')
        end

        if result[1].spawned == 1 then
            mysql:query('UPDATE vehicles SET spawned=0 WHERE id=?', vehicleId)

            local vehicle = getElementByID('vehicle:' .. vehicleId)
            if not isElement(vehicle) then
                return
            end

            destroyElement(vehicle)
            return
        else
            mysql:query('UPDATE vehicles SET spawned=1 WHERE id=?', vehicleId)

            spawnOneVehicle(result[1], vehicleId, thePlayer)
        end
    elseif switch == 'trackVehicle' then
        local vehicle = getElementByID('vehicle:' .. vehicleId)

        if not isElement(vehicle) then
            return
        end
        if isTimer(trackTimer[vehicle]) then
            return
        end

        local x, y, z = getElementPosition(vehicle)

        trackMarker[vehicle] = createMarker(x, y, z, 'checkpoint', 5, 255, 255, 255, 100, thePlayer)
        trackBlip[vehicle] = createBlip(x, y, z, 55, 2, 255, 255, 255, 255, 0, 65535, thePlayer)

        triggerClientEvent(thePlayer, 'hud:sendNotification', thePlayer, 'success', 'Namierzanie pojazdu', 'Pomyślnie namierzono pojazd, zaznaczono go ikonką pojazdu na radarze.')

        trackTimer[vehicle] = setTimer(function()
            destroyElement(trackMarker[vehicle])
            destroyElement(trackBlip[vehicle])
        end, 30000, 1)
    elseif switch == 'toggleVehiclePanel' then

    end
end
addEvent('vehicle-system:vehicleSpawnMenu', true)
addEventHandler('vehicle-system:vehicleSpawnMenu', root, vehicleSpawnMenu)

function spawnOneVehicle(vehicleData, vehicleId, thePlayer)
    local vehicle

    if vehicleModelVariants[vehicleData['mta_model']] and exports.global:findInTable(vehicleModelVariants[vehicleData['mta_model']], vehicleData['variant']) then
        vehicle = createVehicle(vehicleData['mta_model'], vehicleData['spawn_x'], vehicleData['spawn_y'], vehicleData['spawn_z'], 0, 0, vehicleData['spawn_rotation'], string.upper(vehicleData['plate']), false, vehicleData['variant'], vehicleData['variant'])
    else
        vehicle = createVehicle(vehicleData['mta_model'], vehicleData['spawn_x'], vehicleData['spawn_y'], vehicleData['spawn_z'], 0, 0, vehicleData['spawn_rotation'], string.upper(vehicleData['plate']))
    end

    setElementDimension(vehicle, vehicleData['spawn_dimension'])
    setElementInterior(vehicle, vehicleData['spawn_interior'])
    setElementHealth(vehicle, vehicleData['health'])

    local color1 = fromJSON(vehicleData['color1'])
    local color2 = fromJSON(vehicleData['color2'])
    local color3 = fromJSON(vehicleData['color3'])
    local color4 = fromJSON(vehicleData['color4'])
    setVehicleColor(vehicle, color1[1], color1[2], color1[3], color2[1], color2[2], color2[3], color3[1], color3[2], color3[3], color4[1], color4[2], color4[3])

    setElementID(vehicle, 'vehicle:' .. vehicleData['id'])

    local handling = fromJSON(vehicleData['handling'])
    for property, value in pairs(handling) do
        setVehicleHandling(vehicle, property, value)
    end

    local currentAcceleration = findInTable(handling, 'engineAcceleration')
    local currentmaxVelocity = findInTable(handling, 'maxVelocity')

    if vehicleData['odometer'] >= 8000 then
        currentAcceleration = currentAcceleration - math.percent(20, currentAcceleration)
        currentmaxVelocity = currentmaxVelocity - math.percent(15, currentmaxVelocity)
    elseif vehicleData['odometer'] >= 5000 then
        currentAcceleration = currentAcceleration - math.percent(15, currentAcceleration)
        currentmaxVelocity = currentmaxVelocity - math.percent(10, currentmaxVelocity)
    elseif vehicleData['odometer'] >= 3000 then
        currentAcceleration = currentAcceleration - math.percent(10, currentAcceleration)
        currentmaxVelocity = currentmaxVelocity - math.percent(5, currentmaxVelocity)
    end

    setVehicleHandling(vehicle, 'engineAcceleration', currentAcceleration)
    setVehicleHandling(vehicle, 'maxVelocity', currentmaxVelocity)

    local vehlibData = {
        id = vehicleData['id'],
        mta_model = vehicleData['mta_model'],
        brand = vehicleData['brand'],
        model = vehicleData['model'],
        year = vehicleData['year'],
        price = vehicleData['price'],
        variant = vehicleData['variant'],
        additional = vehicleData['additional'],
        handling = vehicleData['handling']
    }

    setElementData(vehicle, 'data', {
        id = vehicleData['id'],
        vehlib = vehlibData,
        owner = vehicleData['owner'],
        fuel = vehicleData['fuel'],
        odometer = vehicleData['odometer'],
        faction = vehicleData['faction'],
        business = vehicleData['business'],
        spawned = 1
    })

    setVehicleEngineState(vehicle, false)

    for i = 0, 5 do
        setVehicleDoorState(vehicle, i, 0)
    end

    setVehicleLocked(vehicle, true)
    setElementFrozen(vehicle, true)
end

addEventHandler('onResourceStart', getResourceRootElement(getThisResource()), function()
    local result = mysql:query('SELECT vehicles.*, vehlib.id AS vehlib_id, vehlib.mta_model, vehlib.brand, vehlib.model, vehlib.year, vehlib.price, vehlib.variant, vehlib.additional, vehlib.handling FROM vehicles INNER JOIN vehlib ON vehicles.vehlib = vehlib.id WHERE vehicles.spawned = 0 AND vehicles.deleted = 0 AND faction > 0 or business > 0')
    if not result then
        return
    end

    for _, vehicleData in pairs(result) do
        spawnOneVehicle(vehicleData)
    end
end)

addEventHandler('onVehicleEnter', root, function(thePlayer, seat, jacked)
    setElementData(thePlayer, 'realInVehicle', true)
end)

addEventHandler('onVehicleExit', root, function(thePlayer, seat, jacked)
    removeElementData(thePlayer, 'realInVehicle')
end)
