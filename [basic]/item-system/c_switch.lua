addEvent('inventory:client', true)
addEventHandler('inventory:client', root, function(switch, data)
    if switch == 'closeInventory' then
        toggleInventoryBrowser()
    elseif switch == 'useItem' then
        triggerServerEvent('item-system:useItem', localPlayer, fromJSON(data))
    elseif switch == 'deleteItem' then
        triggerServerEvent('item-system:destroyItem', localPlayer, fromJSON(data))
    end
end)
