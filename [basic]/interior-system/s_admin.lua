local mysql = exports.mysql

local enterPickup = {}
local exitPickup = {}

function findInTable(t, value)
    for k, v in ipairs(t) do
        if value == v then
            return k
        end
    end

    return false
end

local function createInteriorPickup(x, y, z, type, model, interiorData, interior, dimension)
    local pickup = createPickup(x, y, z - 0.2, 3, model, 0)
    setElementData(pickup, 'interior', interiorData)
    setElementInterior(pickup, interior)
    setElementDimension(pickup, dimension)
    return pickup
end

addEventHandler('onResourceStart', getResourceRootElement(getThisResource()), function()
    local interiorList = mysql:query('SELECT * FROM interiors WHERE disabled=0')

    for i, interior in ipairs(interiorList) do
        local pickupType = (interior.owner < 0) and 1318 or (interior.owner == 0) and 1239 or 1273

        local enterPickupData = {
            pickupName = 'enter',
            entrance_x = interior.entrance_x,
            entrance_y = interior.entrance_y,
            entrance_z = interior.entrance_z,
            entrance_rotation = interior.entrance_rotation,
            type = interior.type,
            owner = interior.owner,
            locked = interior.locked,
            cost = math.floor(interior.cost),
            name = interior.name,
            description = interior.description,
            interiorId = interior['interior'],
            interiorDimension = interior.id,
            id = interior.id
        }

        enterPickup[i] = createInteriorPickup(interior.x, interior.y, interior.z, 3, pickupType, enterPickupData, interior.interior_in, interior.dimension_in)

        local exitPickupData = {
            pickupName = 'exit',
            entrance_x = interior.x,
            entrance_y = interior.y,
            entrance_z = interior.z,
            entrance_rotation = interior.entrance_rotation,
            interiorId = interior.interior_in,
            interiorDimension = interior.dimension_in,
            id = interior.id
        }

        exitPickup[i] = createInteriorPickup(interior.entrance_x, interior.entrance_y, interior.entrance_z, 3, 1318, exitPickupData, interior['interior'], interior.id)
    end

    setInteriorSoundsEnabled(false)
end)

function makeInterior(thePlayer, commandName, interiorType, cost, interiorID, ...)
    if not exports.global:hasPermission(thePlayer, 'interior-system', 'addint') then
        return
    end

    interiorType = tonumber(interiorType)
    cost = tonumber(cost)
    interiorID = tonumber(interiorID)
    local name = table.concat({...}, " ")

    if not interiorType or not cost or not interiorID or not name then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przykład komendy', "Przykład: /" .. commandName .. " [typ] [cena] [ID nieruchomości] [nazwa]")
    end

    local interior = interiors[interiorID]
    if not interior then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Tworzenie nieruchomości', "Nie znaleziono nieruchomości o podanym ID.")
    end

    local x, y, z = getElementPosition(thePlayer)
    local interiorPlayer = getElementInterior(thePlayer)
    local dimensionPlayer = getElementDimension(thePlayer)
    local interiorID, interiorX, interiorY, interiorZ, interiorRot = unpack(interior)

    local result, affectedRows, lastInsertedID = mysql:query('INSERT INTO interiors SET x=?, y=?, z=?, type=?, cost=?, name=?, interior=?, entrance_x=?, entrance_y=?, entrance_z=?, entrance_rotation=?, interior_in=?, dimension_in=?', x, y, z, interiorType, cost, name, interiorID, interiorX, interiorY, interiorZ, interiorRot, interiorPlayer, dimensionPlayer)

    if result then
        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Tworzenie nieruchomości', "Pomyślnie stworzono nieruchomość o DBID " .. lastInsertedID)

        local enterPickupData = {
            pickupName = 'enter',
            entrance_x = interiorX,
            entrance_y = interiorY,
            entrance_z = interiorZ,
            entrance_rotation = interiorRot,
            type = interiorType,
            owner = 0,
            locked = 0,
            cost = math.floor(cost),
            name = name,
            description = 'Ten budynek nie posiada jeszcze opisu.',
            interiorId = interiorID,
            interiorDimension = lastInsertedID,
            id = lastInsertedID
        }
        enterPickup[#enterPickup + 1] = createInteriorPickup(x, y, z, 3, 1239, enterPickupData, interiorPlayer, dimensionPlayer)

        local exitPickupData = {
            pickupName = 'exit',
            entrance_x = x,
            entrance_y = y,
            entrance_z = z,
            entrance_rotation = interiorRot,
            interiorId = interiorPlayer,
            interiorDimension = dimensionPlayer,
            id = lastInsertedID
        }
        exitPickup[#exitPickup + 1] = createInteriorPickup(interiorX, interiorY, interiorZ, 3, 1318, exitPickupData, interiorID, lastInsertedID)
    else
        outputDebugString("Failed to insert interior into the database")
    end
end
addCommandHandler('addint', makeInterior)

addCommandHandler('gotoint', function(thePlayer, commandName, interior)
    if not exports.global:hasPermission(thePlayer, 'interior-system', 'gotoint') then
        return
    end

    interior = tonumber(interior)
    if not interior then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przykład komendy', "Przykład: /" .. commandName .. " [DBID nieruchomości]")
    end

    for i, pickup in pairs(enterPickup) do
        local pickupData = getElementData(pickup, 'interior') or false

        if pickupData.id == interior then
            local x, y, z = getElementPosition(pickup)
            local interiorPickup = getElementInterior(pickup)
            local dimensionPickup = getElementDimension(pickup)

            setElementPosition(thePlayer, x, y, z)
            setElementInterior(thePlayer, interiorPickup)
            setElementDimension(thePlayer, dimensionPickup)
            return
        end
    end

    triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Teleport do nieruchomości', "Nie znaleziono nieruchomości o podanym DBID.")
end)

addCommandHandler('delint', function(thePlayer, commandName, interior)
    if not exports.global:hasPermission(thePlayer, 'interior-system', 'delint') then
        return
    end

    interior = tonumber(interior)
    if not interior then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przykład komendy', "Przykład: /" .. commandName .. " [DBID nieruchomości]")
    end

    local interiorId = false

    for i, pickup in pairs(getElementsByType('pickup')) do
        local pickupData = getElementData(pickup, 'interior') or false

        if pickupData.id == interior then
            interiorId = pickupData.id

            local foundInEnterPickup = findInTable(enterPickup, pickup)
            if foundInEnterPickup then
                table.remove(enterPickup, foundInEnterPickup)
            end

            local foundInExitPickup = findInTable(exitPickup, pickup)
            if foundInExitPickup then
                table.remove(exitPickup, foundInExitPickup)
            end

            destroyElement(pickup)
        end
    end

    if interiorId then
        mysql:execute('UPDATE interiors SET disabled=1 WHERE id=?', interiorId)
        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Usuwanie nieruchomości', "Pomyślnie usunięto nieruchomość o DBID " .. interiorId)
    end
end)

addCommandHandler('renameint', function(thePlayer, commandName, interior, ...)
    if not exports.global:hasPermission(thePlayer, 'interior-system', 'renameint') then
        return
    end

    local name = table.concat({...}, " ")
    interior = tonumber(interior)

    if not interior or not name then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przykład komendy', "Przykład: /" .. commandName .. " [DBID nieruchomości] [nazwa]")
    end

    for i, pickup in pairs(enterPickup) do
        local pickupData = getElementData(pickup, 'interior') or false

        if pickupData.id == interior then
            if string.len(pickupData.name) < 1 then
                pickupData.name = 'BRAK NAZWY'
            end
            triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Zmiana nazwy nieruchomości', "Pomyślnie zmieniłeś nazwe nieruchomości z " .. pickupData.name .. ' na ' .. name .. '.')

            pickupData.name = name
            setElementData(pickup, 'interior', pickupData)

            mysql:execute('UPDATE interiors SET name=? WHERE id=?', name, interior)
            break
        end
    end
end)

addCommandHandler('setinttype', function(thePlayer, commandName, interior, interiorType)
    if not exports.global:hasPermission(thePlayer, 'interior-system', 'setinttype') then
        return
    end

    interiorType = tonumber(interiorType)
    interior = tonumber(interior)

    if not interior or not interiorType then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przykład komendy', "Przykład: /" .. commandName .. " [DBID nieruchomości] [typ] ")
    end

    for i, pickup in pairs(enterPickup) do
        local pickupData = getElementData(pickup, 'interior') or false

        if pickupData.id == interior then
            triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Zmiana typu nieruchomości', "Pomyślnie zmieniłeś typ nieruchomości z " .. pickupData.type .. ' na ' .. interiorType .. '.')

            pickupData.type = interiorType
            setElementData(pickup, 'interior', pickupData)

            mysql:execute('UPDATE interiors SET type=? WHERE id=?', interiorType, interior)
            break
        end
    end
end)

addCommandHandler('setintowner', function(thePlayer, commandName, targetPlayer, interior)
    if not exports.global:hasPermission(thePlayer, 'interior-system', 'setintowner') then
        return
    end

    interior = tonumber(interior)

    if not interior or not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przykład komendy', "Przykład: /" .. commandName .. " [ID gracza] [DBID nieruchomości]")
    end

    targetPlayer = exports.global:findPlayer(targetPlayer)
    if not targetPlayer then
        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono gracza', 'Nie znaleziono gracza o podanych danych.')
        return
    end

    local owner = getElementData(targetPlayer, 'id')

    for i, pickup in pairs(enterPickup) do
        local pickupData = getElementData(pickup, 'interior') or false

        if pickupData.id == interior then
            triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Zmiana typu nieruchomości', "Pomyślnie zmieniłeś właściciela nieruchomości z " .. pickupData.owner .. ' na ' .. owner .. '.')

            pickupData.owner = owner
            setElementData(pickup, 'interior', pickupData)

            local pickupType = (owner < 0) and 1318 or (owner == 0) and 1239 or 1273
            setPickupType(pickup, 3, pickupType)

            mysql:execute('UPDATE interiors SET owner=? WHERE id=?', owner, interior)
            break
        end
    end
end)

addCommandHandler('setintprice', function(thePlayer, commandName, interior, price)
    if not exports.global:hasPermission(thePlayer, 'interior-system', 'setintprice') then
        return
    end

    price = tonumber(price)
    interior = tonumber(interior)

    if not interior or not price then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przykład komendy', "Przykład: /" .. commandName .. " [DBID nieruchomości] [cena] ")
    end

    for i, pickup in pairs(enterPickup) do
        local pickupData = getElementData(pickup, 'interior') or false

        if pickupData.id == interior then
            triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Zmiana typu nieruchomości', "Pomyślnie zmieniłeś cene nieruchomości z $" .. pickupData.cost .. ' na $' .. price .. '.')

            pickupData.cost = price
            setElementData(pickup, 'interior', pickupData)

            mysql:execute('UPDATE interiors SET cost=? WHERE id=?', price, interior)
            break
        end
    end
end)

addCommandHandler('setintid', function(thePlayer, commandName, interior, interiorId)
    if not exports.global:hasPermission(thePlayer, 'interior-system', 'setintid') then
        return
    end

    interior = tonumber(interior)

    if not interior or not interiorId then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przykład komendy', "Przykład: /" .. commandName .. " [DBID nieruchomości] [ID nieruchomości] ")
    end

    interiorId = interiors[tonumber(interiorId)]

    if not interiorId then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Tworzenie nieruchomości', "Nie znaleziono nieruchomości o podanym ID.")
    end

    for i, pickup in pairs(enterPickup) do
        local pickupData = getElementData(pickup, 'interior') or false

        if pickupData.id == interior then
            pickupData.interiorId = interiorId[1]
            pickupData.entrance_x = interiorId[2]
            pickupData.entrance_y = interiorId[3]
            pickupData.entrance_z = interiorId[4]
            pickupData.entrance_rotation = interiorId[5]

            setElementData(pickup, 'interior', pickupData)

            mysql:execute('UPDATE interiors SET interior=?, entrance_x=?, entrance_y=?, entrance_z=?, entrance_rotation=? WHERE id=?', interiorId[1], interiorId[2], interiorId[3], interiorId[4], interiorId[5], interior)
            break
        end
    end

    for i, pickup in pairs(exitPickup) do
        local pickupData = getElementData(pickup, 'interior') or false

        if pickupData.id == interior then
            setElementPosition(pickup, interiorId[2], interiorId[3], interiorId[4])
            setElementInterior(pickup, interiorId[1])

            break
        end
    end

    for _, player in pairs(getElementsByType('player')) do
        local dimension = getElementDimension(player)

        if dimension == interior then
            setElementInterior(player, interiorId[1])
            setElementPosition(player, interiorId[2], interiorId[3], interiorId[4])
            setElementRotation(player, 0, 0, interiorId[5])
        end
    end
end)
