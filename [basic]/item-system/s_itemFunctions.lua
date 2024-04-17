local mysql = exports.mysql
local food = {}
local foodState = {}

function giveHealth(thePlayer, health)
    if health ~= nil then
        setElementHealth(thePlayer, math.min(100, getElementHealth(thePlayer) + health))
    end
end

function takeItem(thePlayer, itemDBID, delete)
    itemDBID = tostring(itemDBID)

    local items = getElementData(thePlayer, 'items')
    for i, item in pairs(items) do
        if tostring(item[5]) == itemDBID then
            local itemValue = tonumber(item[3])
            if delete or itemValue == 1 then -- usuwa całkowicie przedmiot bez sprawdzenia jego value
                table.remove(items, i)
                setElementData(thePlayer, 'items', items)
                mysql:execute("DELETE FROM items WHERE id=?", itemDBID)
            else
                item[3] = itemValue - 1
                setElementData(thePlayer, 'items', items)
            end
        end
    end
end
addEvent("item-system:takeItem", true)
addEventHandler("item-system:takeItem", root, takeItem)

addEvent("item-system:useItem", true)
addEventHandler("item-system:useItem", root, function(item)
    local name, value1, value2, itemID, id, owner = item.name, item.value1, item.value2, item.itemID, item.id, item.owner
    if itemID == 1 then
        if getElementData(client, "healthAddon") then
            return
        end
        triggerClientEvent(client, 'inventory:toggleInventoryBrowser', client)
        takeItem(client, id)
        bindKey(client, "mouse1", "down", useFood)
        bindKey(client, "mouse2", "down", destroyFood)
        foodState[client] = 1
        food[client] = createObject(2880, 0, 0, 0)
        setObjectScale(food[client], 0.8)
        exports.bone_attach:attachElementToBone(food[client], client, 12, -0.1, 0, 0.05, 0, 0, 0)
        setElementData(client, "healthAddon", value1)
        toggleControl(client, "fire", false)
    elseif itemID == 2 then

    else
        triggerClientEvent(client, 'hud:sendNotification', client, 'warning', name, 'Ten przedmiot nic nie robi.')
    end
end)

addEvent("item-system:destroyItem", true)
addEventHandler("item-system:destroyItem", root, function(item)
    local id, name, category = item.id, item.name, item.category
    if category == 1 or category == 3 then
        return triggerClientEvent(client, 'hud:sendNotification', client, 'warning', 'Ekwipunek', 'Nie możesz usuwać przedmiotów z tej kategorii.')
    end
    takeItem(client, id, true)
end)

function useFood(thePlayer)
    if getPedOccupiedVehicle(thePlayer) then
        triggerClientEvent(thePlayer, 'hud:sendNotification', thePlayer, 'warning', 'Jedzenie', "Nie możesz wykonać tej czynności będąc w pojeździe.")
        return
    end

    if getElementData(thePlayer, "healthAddon") then
        if isTimer(timer) then
            return
        end

        local health = getElementData(thePlayer, "healthAddon")
        if foodState[thePlayer] <= 3 then
            setPedAnimation(thePlayer, "FOOD", "EAT_Burger", 1000, false, true, false)
            timer = setTimer(function()
                foodState[thePlayer] = foodState[thePlayer] + 1
            end, 1000, 1, thePlayer)
        else
            setPedAnimation(thePlayer, "FOOD", "EAT_Burger", 1000, false, true, false)
            unbindKey(thePlayer, "mouse1", "down", useFood)
            unbindKey(thePlayer, "mouse2", "down", destroyFood)
            setTimer(function()
                setPedAnimation(thePlayer)
                removeElementData(thePlayer, "healthAddon")
                giveHealth(thePlayer, health)
                toggleControl(thePlayer, "fire", true)
                if isElement(food[thePlayer]) then
                    destroyElement(food[thePlayer])
                end
                foodState[thePlayer] = 1
            end, 1000, 1, thePlayer)
        end
    end
end

function destroyFood(thePlayer)
    if getPedOccupiedVehicle(thePlayer) then
        triggerClientEvent(thePlayer, 'hud:sendNotification', thePlayer, 'warning', 'Wyrzucanie jedzenia', "Nie możesz wykonać tej czynności będąc w pojeździe.")
        return
    end

    if getElementData(thePlayer, "healthAddon") then
        if isTimer(timer) then
            return
        end

        unbindKey(thePlayer, "mouse1", "down", useFood)
        unbindKey(thePlayer, "mouse2", "down", destroyFood)
        removeElementData(thePlayer, "healthAddon")
        toggleControl(thePlayer, "fire", true)
        if isElement(food[thePlayer]) then
            destroyElement(food[thePlayer])
        end
        foodState[thePlayer] = 1
        triggerClientEvent(thePlayer, 'hud:sendNotification', thePlayer, 'success', 'Wyrzucono jedzenie', "Piękny pokaz marnowania jedzenia.")
    end
end
