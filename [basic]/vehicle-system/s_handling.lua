local mysql = exports.mysql
local testVehicle = {}

function existVehicle(id)
    local result = mysql:query('SELECT * FROM vehlib WHERE id=?', id)

    if not result[1] then
        triggerClientEvent(client, 'hud:sendNotification', client, 'error', 'Biblioteka pojazdów', 'Pojazd nie istnieje w bazie danych, odśwież biblioteke pojazdów.')
        return
    end

    return result[1]
end

function cancelEditingHandling(thePlayer)
    local handlingData = getElementData(thePlayer, 'handlingTest')
    if not handlingData then
        return
    end

    removeElementData(thePlayer, 'handlingTest')
    removePedFromVehicle(thePlayer)

    setElementDimension(thePlayer, handlingData.dimension)
    setElementInterior(thePlayer, handlingData.interior)
    setElementPosition(thePlayer, unpack(handlingData.position))

    local playerVehicle = testVehicle[thePlayer]
    if playerVehicle and isElement(playerVehicle) then
        destroyElement(playerVehicle)
        testVehicle[thePlayer] = nil
    end

    triggerClientEvent(client, 'vehicle-system:toggleHandlingWindow', client, false)
end
addEvent("vehicle-system:cancelEditingHandling", true)
addEventHandler("vehicle-system:cancelEditingHandling", root, cancelEditingHandling)

addCommandHandler('vehlib', function(thePlayer)
    if not exports.global:hasPermission(thePlayer, 'vehicle-system', 'vehlib') then
        return
    end

    local result = mysql:query('SELECT id, mta_model AS mtaModel, brand AS mark, model, year, price, variant, additional, last_update AS lastUpdate FROM vehlib WHERE enabled=1')
    if not result then
        return
    end

    triggerClientEvent(thePlayer, 'vehicle-system:toggleVehlib', thePlayer, result)
end)

addEvent("vehicle-system:makeVehicle", true)
addEventHandler("vehicle-system:makeVehicle", root, function(data)
    if not exports.global:hasPermission(client, 'vehicle-system', 'makeVehicle') then
        return
    end

    local mta_model, brand, model, year, price, variant, additional = data.mta_model, data.brand, data.model, data.year, data.price, data.variant, data.additional

    price = math.floor(tonumber(price))
    if not price or price < 1 then
        triggerClientEvent(client, 'hud:sendNotification', client, 'error', 'Biblioteka pojazdów', 'Pojazd nie został stworzony, cena pojazdu posiada nieprawidłową wartość.')
        return
    end

    local handling = getModelHandling(mta_model)
    if not handling then
        triggerClientEvent(client, 'hud:sendNotification', client, 'error', 'Biblioteka pojazdów', 'Pojazd nie został stworzony, MTA Model nie jest prawidłowy.')
        return
    end

    local result = mysql:execute('INSERT INTO vehlib SET mta_model=?, brand=?, model=?, year=?, price=?, variant=?, additional=?, handling=?', tonumber(mta_model), brand, model, year, price, variant, additional, toJSON(handling))
    if not result then
        triggerClientEvent(client, 'hud:sendNotification', client, 'error', 'Biblioteka pojazdów', 'Wystąpił problem z tworzeniem pojazdu.')
        return
    end

    executeCommandHandler('vehlib', client)
    executeCommandHandler('vehlib', client)
end)

addEvent("vehicle-system:editVehicle", true)
addEventHandler("vehicle-system:editVehicle", root, function(data)
    if not exports.global:hasPermission(client, 'vehicle-system', 'editVehicle') then
        return
    end

    local id, mta_model, brand, model, year, price, variant, additional = data.id, data.mta_model, data.brand, data.model, data.year, data.price, data.variant, data.additional

    if not existVehicle(id) then
        return
    end

    price = math.floor(tonumber(price))
    if not price or price < 1 then
        triggerClientEvent(client, 'hud:sendNotification', client, 'error', 'Biblioteka pojazdów', 'Pojazd nie został zedytowany, cena pojazdu posiada nieprawidłową wartość.')
        return
    end

    local result = mysql:execute('UPDATE vehlib SET mta_model=?, brand=?, model=?, year=?, price=?, variant=?, additional=? WHERE id=?', tonumber(mta_model), brand, model, year, price, variant, additional, id)
    if not result then
        triggerClientEvent(client, 'hud:sendNotification', client, 'error', 'Biblioteka pojazdów', 'Wystąpił problem z edycją pojazdu.')
        return
    end
end)

addEvent("vehicle-system:deleteVehicle", true)
addEventHandler("vehicle-system:deleteVehicle", root, function(data)
    if not exports.global:hasPermission(client, 'vehicle-system', 'deleteVehicle') then
        return
    end

    local id = data

    if not existVehicle(id) then
        return
    end

    local result = mysql:execute('UPDATE vehlib SET enabled=0 WHERE id=?', id)
    if not result then
        triggerClientEvent(client, 'hud:sendNotification', client, 'error', 'Biblioteka pojazdów', 'Wystąpił problem z usuwaniem pojazdu.')
    end
end)

addEvent("vehicle-system:editHandling", true)
addEventHandler("vehicle-system:editHandling", root, function(data)
    if not exports.global:hasPermission(client, 'vehicle-system', 'editHandling') then
        return
    end

    local handlingData = getElementData(client, 'handlingTest')
    if handlingData then
        cancelEditingHandling(client)
    end

    local id = data

    if not existVehicle(id) then
        return
    end

    triggerClientEvent(client, 'vehicle-system:toggleVehlib', client)

    local vehicleData = existVehicle(id)

    testVehicle[client] = createVehicle(vehicleData.mta_model, 1456.1016845703, -2593.5288085938, 13.546875, 0, 0, 270, 'testowe!', false)

    setElementID(testVehicle[client], 'handlingTest:' .. id)

    if vehicleData.variant ~= -1 then
        setVehicleVariant(testVehicle[client], vehicleData.variant)
    end

    local x, y, z = getElementPosition(client)
    local dimension = getElementDimension(client)
    local interior = getElementInterior(client)
    setElementData(client, 'handlingTest', {
        position = {x, y, z},
        dimension = dimension,
        interior = interior,
        id = id
    })

    setElementDimension(testVehicle[client], 1)
    setElementDimension(client, 1)

    warpPedIntoVehicle(client, testVehicle[client])

    triggerClientEvent(client, 'vehicle-system:toggleHandlingWindow', client, true, vehicleData.handling)
end)

addEvent("vehicle-system:updateHandling", true)
addEventHandler("vehicle-system:updateHandling", root, function(data)
    if not exports.global:hasPermission(client, 'vehicle-system', 'updateHandling') then
        return
    end

    local handlingData = getElementData(client, 'handlingTest')
    if not handlingData then
        return
    end

    local vehicle = getElementByID('handlingTest:' .. handlingData.id)
    if not vehicle then
        return
    end

    for property, value in pairs(data) do
        setVehicleHandling(vehicle, property, value)
    end
end)

addEvent("vehicle-system:resetHandling", true)
addEventHandler("vehicle-system:resetHandling", root, function(data)
    if not exports.global:hasPermission(client, 'vehicle-system', 'resetHandling') then
        return
    end

    local handlingData = getElementData(client, 'handlingTest')
    if not handlingData then
        return
    end

    local vehicle = getElementByID('handlingTest:' .. handlingData.id)
    if not vehicle then
        return
    end

    setVehicleHandling(vehicle, false)
    local vehicleHandling = toJSON(getVehicleHandling(vehicle))
    triggerClientEvent(client, 'vehicle-system:updateHandlingCefData', client, vehicleHandling)
end)

addEvent("vehicle-system:saveHandling", true)
addEventHandler("vehicle-system:saveHandling", root, function()
    if not exports.global:hasPermission(client, 'vehicle-system', 'saveHandling') then
        return
    end

    local handlingData = getElementData(client, 'handlingTest')
    if not handlingData then
        return
    end

    local vehicle = getElementByID('handlingTest:' .. handlingData.id)
    if not vehicle then
        return
    end

    local vehicleHandling = toJSON(getVehicleHandling(vehicle))

    local result = mysql:execute('UPDATE vehlib SET handling=?, last_update=NOW() WHERE id=?', vehicleHandling, handlingData.id)
    if result then
        triggerClientEvent(client, 'hud:sendNotification', client, 'success', 'Biblioteka pojazdów', 'Handling pojazdu został zaktualizowany.')

        cancelEditingHandling(client)
    else
        triggerClientEvent(client, 'hud:sendNotification', client, 'error', 'Biblioteka pojazdów', 'Handling pojazdu nie został zaktualizowany.')
    end

    triggerClientEvent(client, 'vehicle-system:toggleHandlingWindow', client, false)
end)
