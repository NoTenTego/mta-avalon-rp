local mysql = exports.mysql

local gotoplaceLocations = {
    ['ls'] = {1481.1105957031, -1707.5395507812, 14.046875},
    ['idlewood'] = {2080.39453125, -1761.7220458984, 13.5625},
    ['market'] = {995.32348632812, -1311.4466552734, 13.546875}
}

local blockedPermissions = {'givemoney', 'giveitem', 'givepermission'}

function adminDuty(thePlayer)
    local supportLevel = getElementData(thePlayer, 'support_level') or 0
    local adminLevel = getElementData(thePlayer, 'admin_level') or 0

    if (supportLevel > 0) or (adminLevel > 0) then
        if hasElementData(thePlayer, 'adminDuty') then
            removeElementData(thePlayer, 'adminDuty')
        else
            setElementData(thePlayer, 'adminDuty', true)
        end
    end
end
addCommandHandler('aduty', adminDuty)
addCommandHandler('adminduty', adminDuty)
addCommandHandler('sduty', adminDuty)

addCommandHandler('vehlib', function(thePlayer)
    if not exports.global:hasPermission(thePlayer, 'vehicle-system', 'vehlib') then
        return
    end

    triggerEvent('vehicle-system:getVehlibData', thePlayer, thePlayer)
end)

addCommandHandler('giveitem', function(thePlayer, commandName, targetPlayer, dbid, value1, value2, ...)
    if not exports.global:hasPermission(thePlayer, 'item-system', 'giveitem') then
        return
    end

    dbid = tonumber(dbid)
    if not dbid or not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przykład użycia komendy', "Przykład: /" .. commandName .. " [ID gracza] [DBID] OPCJONALNIE -> [value1 LUB 0] [value2 LUB 0] [name]")
    end

    targetPlayer = exports.global:findPlayer(targetPlayer)
    if not targetPlayer then
        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono gracza', 'Nie znaleziono gracza o podanych danych.')
        return
    end

    local result = mysql:query("SELECT * FROM itemlist WHERE id=?", dbid)
    local itemData = result[1]

    if not value1 or value1 == 0 then
        value1 = itemData.value_1
    end

    if not value2 or value2 == 0 then
        value2 = itemData.value_2
    end

    local name = table.concat({...}, " ")
    if string.len(name) < 2 then
        name = itemData.name
    end

    local items = getElementData(targetPlayer, "items")
    if not items then
        items = {}
    end

    local itemReplaced = false
    for i, item in pairs(items) do
        if (item[1] == name) and (item[2] == value1) and (tostring(item[4]) == tostring(itemData.itemID)) then
            item[3] = item[3] + value2
            mysql:execute('UPDATE items SET value_2=? WHERE id = ?', item[3], item[5])

            triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Tworzenie przedmiotu', "Pomyślnie stworzono przedmiot o nazwie " .. name .. ", Wartość 1: " .. value1 .. ", Wartość 2: " .. value2 .. "")
            triggerClientEvent(targetPlayer, "hud:sendNotification", targetPlayer, 'success', 'Otrzymałeś przedmiot', "Administrator " .. getElementData(thePlayer, "username") .. " stworzył Ci przedmiot o nazwie " .. name .. ". Wygląda na to, że posiadasz już taki przedmiot, w takim wypadku otrzymałeś kolejny ;))")

            itemReplaced = true
            break
        end
    end

    if not itemReplaced then
        local result, affectedRows, lastInsertedID = mysql:query("INSERT INTO items SET owner=?, itemID=?, value_1=?, value_2=?, name=?, additional=?", getElementData(targetPlayer, 'id'), itemData.itemID, value1, value2, name, itemData.additional)
        table.insert(items, {name, value1, value2, itemData.itemID, lastInsertedID, getElementData(targetPlayer, 'id'), itemData.category, itemData.additional})

        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Tworzenie przedmiotu', "Pomyślnie stworzono przedmiot o nazwie " .. name .. ", Wartość 1: " .. value1 .. ", Wartość 2: " .. value2 .. "")
        triggerClientEvent(targetPlayer, "hud:sendNotification", targetPlayer, 'success', 'Otrzymałeś przedmiot', "Administrator " .. getElementData(thePlayer, "username") .. " stworzył Ci przedmiot o nazwie " .. name .. ". Sprawdź ekwipunek.")
    end

    setElementData(targetPlayer, "items", items)
end)

function healPlayer(thePlayer, commandName, targetPlayer, health)
    if not exports.global:hasPermission(thePlayer, 'admin-system', 'heal') then
        return
    end

    if targetPlayer then
        targetPlayer, targetPlayerName = exports.global:findPlayer(targetPlayer)
        if not targetPlayer then
            return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono gracza', "Nie znaleziono gracza więc niestety nie został wyleczony :((")
        end
    else
        local characterName = getElementData(thePlayer, 'charactername')
        targetPlayer, targetPlayerName = thePlayer, string.gsub(characterName, '_', ' ')
        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przypominajka argumentów', "Przykład: /" .. commandName .. " [ID gracza] [punkty życia]")
    end

    health = tonumber(health)
    if not health then
        setElementHealth(targetPlayer, 200)
        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Wyleczono gracza', "Gracz " .. targetPlayerName .. " został przez Ciebie wyleczony. Super robota!")
    else
        setElementHealth(targetPlayer, health)
        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Wyleczono gracza', "Ustawiłeś " .. health .. " punktów życia dla " .. targetPlayerName)
    end
end
addCommandHandler('heal', healPlayer)
addCommandHandler('aheal', healPlayer)
addCommandHandler('sethp', healPlayer)

function armorPlayer(thePlayer, commandName, targetPlayer, armor)
    if not exports.global:hasPermission(thePlayer, 'admin-system', 'setarmor') then
        return
    end

    if targetPlayer then
        targetPlayer, targetPlayerName = exports.global:findPlayer(targetPlayer)
        if not targetPlayer then
            return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono gracza', "Nie znaleziono gracza więc niestety nie otrzymał armora :((")
        end
    else
        local characterName = getElementData(thePlayer, 'charactername')
        targetPlayer, targetPlayerName = thePlayer, string.gsub(characterName, '_', ' ')
    end

    armor = tonumber(armor)
    if not armor then
        setPedArmor(targetPlayer, 100)
        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Ustawienie armora', "Gracz " .. targetPlayerName .. " otrzymał pełny armor.")
    else
        setPedArmor(targetPlayer, armor)
        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Ustawienie armora', "Ustawiłeś " .. armor .. " punktów armora dla " .. targetPlayerName)
    end
end
addCommandHandler('setarmor', armorPlayer)
addCommandHandler('givearmor', armorPlayer)

function givePermission(thePlayer, commandName, targetPlayer, resourceName, permission, time)
    if not exports.global:hasPermission(thePlayer, 'admin-system', 'givepermission') then
        return
    end

    time = tonumber(time)

    if not targetPlayer or not resourceName or not permission or not time then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Przykład użycia komendy', "Przykład: /" .. commandName .. " [ID gracza] [nazwa zasobu] [nazwa permisji] [czas działania - maks. 120 minut]")
    end

    targetPlayer, targetPlayerName = exports.global:findPlayer(targetPlayer)
    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono gracza', "Nie znaleziono gracza więc niestety nie otrzymał permisji :((")
    end

    if exports.global:findInTable(blockedPermissions, permission) then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Ta permisja jest zablokowana', "Nie możesz nadać permisji " .. permission .. ' dla ' .. targetPlayerName)
    end

    if time > 120 or time < 1 then
        return
    end

    local currentTimeStamp = exports.global:getTimestamp()
    local currentTimeStamp = currentTimeStamp + time * 60

    if hasElementData(targetPlayer, 'temporaryPermissions') then
        local temporaryPermissions = getElementData(targetPlayer, 'temporaryPermissions')
        table.insert(temporaryPermissions, {
            resourceName = resourceName,
            permission = permission,
            time = currentTimeStamp
        })
        setElementData(targetPlayer, 'temporaryPermissions', temporaryPermissions)
    else
        setElementData(targetPlayer, 'temporaryPermissions', {
            resourceName = resourceName,
            permission = permission,
            time = currentTimeStamp
        })
    end

    triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Nadawanie permisji', "Pomyślnie nadano permisje " .. permission .. ' dla ' .. targetPlayerName .. ' na okres ' .. time .. ' minut.')
    triggerClientEvent(targetPlayer, "hud:sendNotification", targetPlayer, 'success', 'Otrzymano permisje', "Otrzymano permisje " .. permission .. ' na okres ' .. time .. ' minut.')
end
addCommandHandler('givepermission', givePermission)
addCommandHandler('addpermission', givePermission)
addCommandHandler('setpermission', givePermission)

function teleportToPlayer(thePlayer, commandName, targetPlayer)
    if not exports.global:hasPermission(thePlayer, 'admin-system', 'teleport') then
        return
    end

    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Teleport do gracza', "Przykład: /" .. commandName .. " [ID gracza]")
    end

    targetPlayer, targetPlayerName = exports.global:findPlayer(targetPlayer)
    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono gracza', "Nie znaleziono gracza o podanych danych.")
    end

    local x, y, z = getElementPosition(targetPlayer)
    local _, _, rotation = getElementRotation(targetPlayer)
    local interior = getElementInterior(targetPlayer)
    local dimension = getElementDimension(targetPlayer)

    local x = x + math.sin(math.rad(-rotation)) * 1.5
    local y = y + math.cos(math.rad(-rotation)) * 1.5

    setElementDimension(thePlayer, dimension)
    setElementInterior(thePlayer, interior)
    setElementPosition(thePlayer, x, y, z)
    setElementRotation(thePlayer, 0, 0, rotation + 180)
end
addCommandHandler('tp', teleportToPlayer)
addCommandHandler('teleport', teleportToPlayer)
addCommandHandler('goto', teleportToPlayer)

function teleportPlayer(thePlayer, commandName, targetPlayer)
    if not exports.global:hasPermission(thePlayer, 'admin-system', 'teleport') then
        return
    end

    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Teleport gracza', "Przykład: /" .. commandName .. " [ID gracza]")
    end

    targetPlayer, targetPlayerName = exports.global:findPlayer(targetPlayer)
    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono gracza', "Nie znaleziono gracza o podanych danych.")
    end

    local x, y, z = getElementPosition(thePlayer)
    local _, _, rotation = getElementRotation(thePlayer)
    local interior = getElementInterior(thePlayer)
    local dimension = getElementDimension(thePlayer)

    local x = x + math.sin(math.rad(-rotation)) * 1.5
    local y = y + math.cos(math.rad(-rotation)) * 1.5

    setElementDimension(targetPlayer, dimension)
    setElementInterior(targetPlayer, interior)
    setElementPosition(targetPlayer, x, y, z)
    setElementRotation(targetPlayer, 0, 0, rotation + 180)
end
addCommandHandler('gethere', teleportPlayer)
addCommandHandler('tphere', teleportPlayer)

addCommandHandler('gotoplace', function(thePlayer, commandName, targetPlayer, place)
    if not exports.global:hasPermission(thePlayer, 'admin-system', 'teleport') then
        return
    end

    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Teleport do miejsca', "Przykład: /" .. commandName .. " [ID gracza] [miejsce]")
    end

    targetPlayer, targetPlayerName = exports.global:findPlayer(targetPlayer)
    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono gracza', "Nie znaleziono gracza o podanych danych.")
    end

    place = gotoplaceLocations[place]

    if not place then
        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Teleport do miejsca', "Przykład: '/" .. commandName .. " [ID gracza] [miejsce]")
        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'info', 'Lista miejsc', "ls, idlewood, market")
        return
    end

    if thePlayer ~= targetPlayer then
        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Teleport do miejsca', "Pomyślnie przeteleportowano gracza " .. targetPlayerName)
    end

    setElementPosition(targetPlayer, unpack(place))
    setElementDimension(targetPlayer, 0)
    setElementInterior(targetPlayer, 0)
end)

addCommandHandler('givemoney', function(thePlayer, commandName, targetPlayer, money)
    if not exports.global:hasPermission(thePlayer, 'admin-system', 'givemoney') then
        return
    end

    if not targetPlayer or not money then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Respienie pieniędzy', "Przykład: /" .. commandName .. " [ID gracza] [ilość]")
    end

    money = math.floor(tonumber(money))
    if money < 1 or money > 1000000 then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Respienie pieniędzy', "Możesz respić pieniądze w zakresie $1 - $1,000,000")
    end

    targetPlayer, targetPlayerName = exports.global:findPlayer(targetPlayer)
    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono gracza', "Nie znaleziono gracza o podanych danych.")
    end

    if not thePlayer == targetPlayer then
        triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'success', 'Zastrzyk gotówki', "Zrespiono $" .. money .. ' dla ' .. targetPlayerName .. '.')
        triggerClientEvent(targetPlayer, "hud:sendNotification", targetPlayer, 'success', 'Zastrzyk gotówki', "Administrator " .. getElementData(thePlayer, "username") .. ' zrespił Ci $' .. money)
    end

    exports.global:giveMoney(targetPlayer, money)
end)

function revivePlayer(thePlayer, commandName, targetPlayer)
    if not exports.global:hasPermission(thePlayer, 'bw-system', 'revive') then
        return
    end

    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'UNBW', "Przykład: /" .. commandName .. " [ID gracza]")
    end

    targetPlayer, targetPlayerName = exports.global:findPlayer(targetPlayer)
    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono gracza', "Nie znaleziono gracza o podanych danych.")
    end

    triggerClientEvent(targetPlayer, 'bw-system:playerDeath', targetPlayer, false)
    removeElementData(targetPlayer, 'bw')

    local x, y, z = getElementPosition(targetPlayer)
    local _, _, rotation = getElementRotation(targetPlayer)
    local skin = getElementModel(targetPlayer)
    local interior = getElementInterior(targetPlayer)
    local dimension = getElementDimension(targetPlayer)

    spawnPlayer(targetPlayer, x, y, z, rotation, skin, interior, dimension)
end
addCommandHandler('revive', revivePlayer)
addCommandHandler('odratuj', revivePlayer)
addCommandHandler('unbw', revivePlayer)

addCommandHandler('sw', function(thePlayer, commandName, weather)
    setWeather(weather)
end)

function weatherChange(thePlayer, commandName, weather)
    if not exports.global:hasPermission(thePlayer, 'weather-system', 'sw') then
        return
    end

    weather = tonumber(weather)
    if not weather then
        return
    end

    setWeather(weather)
end

function fixPlayerVehicle(thePlayer, commandName, targetPlayer)
    if not exports.global:hasPermission(thePlayer, 'admin-system', 'fixveh') then
        return
    end

    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Naprawa pojazdu', "Przykład: /" .. commandName .. " [ID gracza]")
    end

    targetPlayer, targetPlayerName = exports.global:findPlayer(targetPlayer)
    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono gracza', "Nie znaleziono gracza o podanych danych.")
    end

    local vehicle = getPedOccupiedVehicle(targetPlayer)
    if not vehicle then
        return
    end

    fixVehicle(vehicle)
end
addCommandHandler('fixveh', fixPlayerVehicle)
addCommandHandler('fixcar', fixPlayerVehicle)

function unflipPlayerVehicle(thePlayer, commandName, targetPlayer)
    if not exports.global:hasPermission(thePlayer, 'admin-system', 'unflip') then
        return
    end

    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Odwrócenie pojazdu', "Przykład: /" .. commandName .. " [ID gracza]")
    end

    targetPlayer, targetPlayerName = exports.global:findPlayer(targetPlayer)
    if not targetPlayer then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono gracza', "Nie znaleziono gracza o podanych danych.")
    end

    local vehicle = getPedOccupiedVehicle(targetPlayer)
    if not vehicle then
        return
    end

    local r, o, t = getElementRotation(vehicle)
    setElementRotation(vehicle, r + 180, o, t)
end
addCommandHandler('unflip', unflipPlayerVehicle)

function teleportVehicle(thePlayer, commandName, vehicleID)
    if not exports.global:hasPermission(thePlayer, 'admin-system', 'teleport') then
        return
    end

    if not vehicleID then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Teleport pojazdu', "Przykład: /" .. commandName .. " [ID pojazdu]")
    end

    vehicle = getElementByID("vehicle:"..vehicleID)
    if not vehicle then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Nie znaleziono pojazdu', "Nie znaleziono pojazdu o podanym id.")
    end

    local x, y, z = getElementPosition(thePlayer)
    local _, _, rotation = getElementRotation(thePlayer)
    local interior = getElementInterior(thePlayer)
    local dimension = getElementDimension(thePlayer)

    local x = x + math.sin(math.rad(-rotation)) * 2.5
    local y = y + math.cos(math.rad(-rotation)) * 2.5

    setElementDimension(vehicle, dimension)
    setElementInterior(vehicle, interior)
    setElementPosition(vehicle, x, y, z)

    setElementRotation(vehicle, 0, 0, rotation + 90)
end
addCommandHandler('getcar', teleportVehicle)
addCommandHandler('getveh', teleportVehicle)
