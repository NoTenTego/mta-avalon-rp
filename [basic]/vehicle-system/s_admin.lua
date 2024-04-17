local mysql = exports.mysql

function randomString()
    local length = 8
    local characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    local randomString = ""

    for i = 1, length do
        local randomIndex = math.random(#characters)
        local randomChar = string.sub(characters, randomIndex, randomIndex)
        randomString = randomString .. randomChar
    end

    return toupper(randomString)
end

function makeVehicle(thePlayer, commandName, targetPlayer, vehlib)
    if not exports.global:hasPermission(thePlayer, 'vehicle-system', 'makeveh') then
        return
    end

    vehlib = tonumber(vehlib)

    if not targetPlayer or not vehlib then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przykład użycia komendy', "Przykład /" .. commandName .. ' [ID Gracza] [DBID vehlib]')
    end

    targetPlayer, targetPlayerName = exports.global:findPlayer(targetPlayer)
    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono gracza', "Nie znaleziono gracza o podanych danych.")
    end

    local result = mysql:query('SELECT * FROM vehlib WHERE id=?', vehlib)
    if not result[1] then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono pojazdu', "Nie znaleziono pojazdu w bibliotece.")
    end

    local vehlibData = result[1]

    local x, y, z = getElementPosition(thePlayer)
    local _, _, rotation = getElementRotation(thePlayer)
    local interior = getElementInterior(thePlayer)
    local dimension = getElementDimension(thePlayer)
    local characterId = getElementData(targetPlayer, 'id')

    local x = x + math.sin(math.rad(-rotation)) * 2
    local y = y + math.cos(math.rad(-rotation)) * 2

    local numberplate = randomString()

    local vehicle
    if vehicleModelVariants[vehlibData.mta_model] and exports.global:findInTable(vehicleModelVariants[vehlibData.mta_model], vehlibData.variant) then
        vehicle = createVehicle(vehlibData.mta_model, x, y, z, 0, 0, rotation + 90, numberplate, false, tonumber(vehlibData.variant), tonumber(vehlibData.variant))
    else
        vehicle = createVehicle(vehlibData.mta_model, x, y, z, 0, 0, rotation + 90, numberplate)
    end

    local health = getElementHealth(vehicle)
    local vehicleColor = {getVehicleColor(vehicle, true)}
    local color1 = toJSON({vehicleColor[1], vehicleColor[2], vehicleColor[3]})
    local color2 = toJSON({vehicleColor[4], vehicleColor[5], vehicleColor[6]})
    local color3 = toJSON({vehicleColor[7], vehicleColor[8], vehicleColor[9]})
    local color4 = toJSON({vehicleColor[10], vehicleColor[11], vehicleColor[12]})

    local result, affectedRows, lastInsertedId = mysql:query('INSERT INTO vehicles SET vehlib=?, owner=?, x=?, y=?, z=?, rotation=?, spawn_x=?, spawn_y=?, spawn_z=?, spawn_rotation=?, fuel=?, health=?, color1=?, color2=?, color3=?, color4=?, plate=?, dimension=?, interior=?, spawn_dimension=?, spawn_interior=?, spawned=?', vehlib, characterId, x, y, z, rotation + 90, x, y, z, rotation + 90, 100, health, color1, color2, color3, color4, numberplate, dimension, interior, dimension, interior, 1)
    if result then
        setElementDimension(vehicle, dimension)
        setElementInterior(vehicle, interior)

        setElementID(vehicle, 'vehicle:' .. lastInsertedId)
        setElementData(vehicle, 'data', {
            id = lastInsertedId,
            vehlib = vehlibData,
            owner = characterId,
            fuel = 100,
            odometer = 0,
            faction = 0,
            business = 0,
            spawned = 1
        })

        local handling = fromJSON(vehlibData.handling)
        for property, value in pairs(handling) do
            setVehicleHandling(vehicle, property, value)
        end
    else
        if isElement(vehicle) then
            destroyElement(vehicle)
        end

        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'error', 'Pojazd nie został stworzony!', "Wystąpił nieznany problem podczas tworzenia pojazdu, skontaktuj się z developerem!")
    end
end
addCommandHandler('makeveh', makeVehicle)
addCommandHandler('makecar', makeVehicle)

function setOdometer(thePlayer, commandName, vehicleId, odometer)
    if not exports.global:hasPermission(thePlayer, 'vehicle-system', 'setodometer') then
        return
    end

    odometer = tonumber(odometer)

    if not vehicleId or not odometer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przykład użycia komendy', "Przykład /" .. commandName .. ' [ID pojazdu] [przebieg]')
    end

    local vehicle = getElementByID('vehicle:' .. vehicleId)
    if not vehicle then
        return
    end

    local handling = getVehicleHandling(vehicle)
    local currentAcceleration = findInTable(handling, 'engineAcceleration')
    local currentmaxVelocity = findInTable(handling, 'maxVelocity')

    if odometer >= 8000 then
        currentAcceleration = currentAcceleration - math.percent(20, currentAcceleration)
        currentmaxVelocity = currentmaxVelocity - math.percent(15, currentmaxVelocity)
    elseif odometer >= 5000 then
        currentAcceleration = currentAcceleration - math.percent(15, currentAcceleration)
        currentmaxVelocity = currentmaxVelocity - math.percent(10, currentmaxVelocity)
    elseif odometer >= 3000 then
        currentAcceleration = currentAcceleration - math.percent(10, currentAcceleration)
        currentmaxVelocity = currentmaxVelocity - math.percent(5, currentmaxVelocity)
    end

    setVehicleHandling(vehicle, 'engineAcceleration', currentAcceleration)
    setVehicleHandling(vehicle, 'maxVelocity', currentmaxVelocity)

    local vehicleData = getElementData(vehicle, 'data')
    vehicleData.odometer = odometer

    triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Zmiana przebiegu', 'Pomyślnie zmieniono przebieg pojazdu.')
end
addCommandHandler('setodometer', setOdometer)
addCommandHandler('setmilage', setOdometer)

function delVehicle(thePlayer, commandName, vehicleId)
    if not exports.global:hasPermission(thePlayer, 'vehicle-system', 'delveh') then
        return
    end

    if not vehicleId then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przykład użycia komendy', "Przykład /" .. commandName .. ' [ID pojazdu]')
    end

    local vehicle = getElementByID('vehicle:' .. vehicleId)
    if not vehicle then
        return
    end

    local result = mysql:execute('UPDATE vehicles SET deleted=1 WHERE id=?', vehicleId)
    if result then
        destroyElement(vehicle)
        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Usuwanie pojazdu', 'Pomyślnie usunięto pojazd.')
    else
        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'error', 'Usuwanie pojazdu', 'Wystąpił problem z usuwaniem pojazdu.')
    end
end
addCommandHandler('delveh', delVehicle)
addCommandHandler('delcar', delVehicle)

function hex2rgb(hex)
    hex = hex:gsub("#", "")
    return tonumber("0x" .. hex:sub(1, 2)), tonumber("0x" .. hex:sub(3, 4)), tonumber("0x" .. hex:sub(5, 6))
end

function setPlayerVehicleColor(thePlayer, commandName, vehicleId, color)
    if not exports.global:hasPermission(thePlayer, 'vehicle-system', 'setcolor') then
        return
    end

    if not vehicleId or not color then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przykład użycia komendy', "Przykład /" .. commandName .. ' [ID pojazdu] [Kolor w HEX]')
    end

    local vehicle = getElementByID('vehicle:' .. vehicleId)
    if not vehicle then
        return
    end

    setVehicleColor(vehicle, hex2rgb(color))
end
addCommandHandler('setvehcolor', setPlayerVehicleColor)
addCommandHandler('setcarcolor', setPlayerVehicleColor)

function setPlayerInVehicle(thePlayer, commandName, targetPlayer, vehicleId)
    if not exports.global:hasPermission(thePlayer, 'vehicle-system', 'enterveh') then
        return
    end

    if not vehicleId or not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przykład użycia komendy', "Przykład /" .. commandName .. ' [ID gracza] [ID pojazdu]')
    end

    targetPlayer, targetPlayerName = exports.global:findPlayer(targetPlayer)
    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono gracza', "Nie znaleziono gracza o podanych danych.")
    end

    local vehicle = getElementByID('vehicle:' .. vehicleId)
    if not vehicle then
        return
    end

    warpPedIntoVehicle(targetPlayer, vehicle)
end
addCommandHandler('enterveh', setPlayerInVehicle)
addCommandHandler('entercar', setPlayerInVehicle)
