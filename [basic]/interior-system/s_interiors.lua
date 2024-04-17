local mysql = exports.mysql

local propertyViewing = {}
local entryTimer = {}

addEvent('interior-system:enterInterior', true)
addEventHandler('interior-system:enterInterior', getRootElement(), function(pickup)
    if not isElement(pickup) then
        return
    end

    local pickupData = getElementData(pickup, 'interior') or false
    if not pickupData then
        return
    end

    if pickupData.locked == 1 then
        return triggerClientEvent(client, 'hud:sendNotification', client, 'warning', pickupData.name or '', 'Nieruchomość do której próbujesz wejść jest zamknięta.')
    end

    local dimension, interior, x, y, z, rotation, id = pickupData.interiorDimension, pickupData.interiorId, pickupData.entrance_x, pickupData.entrance_y, pickupData.entrance_z, pickupData.entrance_rotation, pickupData.id

    if not propertyViewing[client] then
        propertyViewing[client] = {}
    end

    if propertyViewing[client].id == id then
        if isTimer(propertyViewing[client].timer) then
            killTimer(propertyViewing[client].timer)
        end
    end

    setElementDimension(client, dimension)
    setElementInterior(client, interior)
    setElementPosition(client, x, y, z)
    setElementRotation(client, 0, 0, rotation)
    setElementFrozen(client, true)

    entryTimer[client] = setTimer(function(thePlayer)
        setElementFrozen(thePlayer, false)
    end, 500, 1, client)

    if pickupData.owner == 0 then
        if isTimer(propertyViewing[client].timer) then
            return
        end

        propertyViewing[client].id = id
        propertyViewing[client].position = {getElementPosition(pickup)}
        propertyViewing[client].interior = getElementInterior(pickup)
        propertyViewing[client].dimension = getElementDimension(pickup)

        triggerClientEvent(client, 'hud:sendNotification', client, 'info', pickupData.name or '', 'Masz 60 sekund na oglądanie nieruchomości, po tym czasie zostaniesz wyrzucony z budynku.')

        propertyViewing[client].timer = setTimer(function(thePlayer)
            triggerClientEvent(thePlayer, 'hud:sendNotification', thePlayer, 'info', pickupData.name or '', 'Czas na oglądanie nieruchomości minął.')

            setElementDimension(thePlayer, propertyViewing[thePlayer].dimension)
            setElementInterior(thePlayer, propertyViewing[thePlayer].interior)
            setElementPosition(thePlayer, unpack(propertyViewing[thePlayer].position))
        end, 60000, 1, client)
    end
end)

addEvent('interior-system:buyInterior', true)
addEventHandler('interior-system:buyInterior', getRootElement(), function(pickup)
    if not isElement(pickup) then
        return
    end

    local pickupData = getElementData(pickup, 'interior') or false
    if not pickupData then
        return
    end

    local result = mysql:query('SELECT owner, cost FROM interiors WHERE id=?', pickupData.id)
    if not result[1] then
        return
    end

    local cost, owner = tonumber(result[1].cost), tonumber(result[1].owner)

    if owner ~= 0 then
        return triggerClientEvent(client, 'hud:sendNotification', 'warning', client, pickupData.name or '', 'Ktoś już kupił tą nieruchomość.')
    end

    if getElementData(client, 'money') < cost then
        return triggerClientEvent(client, 'hud:sendNotification', 'warning', client, pickupData.name or '', 'Nie stać Cię na tą nieruchomość.')
    end

    local newOwner = getElementData(client, 'id')

    exports.global:takeMoney(client, cost)

    pickupData.owner = newOwner

    setElementData(pickup, 'interior', pickupData)
    setPickupType(pickup, 3, 1273)

    mysql:execute('UPDATE interiors SET owner=? WHERE id=?', newOwner, pickupData.id)

    triggerClientEvent(client, 'hud:sendNotification', client, 'success', pickupData.name or '', 'Pomyślnie zakupiono nieruchomość.')
end)