local screenWidth, screenHeight = guiGetScreenSize()
local initInventoryBrowser = nil
local inventoryBrowser = nil
local isBrowserOpen = false

initInventoryBrowser = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
inventoryBrowser = guiGetBrowser(initInventoryBrowser)
guiSetVisible(initInventoryBrowser, false)

addEventHandler("onClientBrowserCreated", inventoryBrowser, function()
    loadBrowserURL(inventoryBrowser, "http://mta/cef/build/index.html#/inventory")
end)

function toggleInventoryBrowser()
    if not isBrowserOpen then
        local items = toJSON(getElementData(localPlayer, "items"))
        executeBrowserJavascript(inventoryBrowser, "clientData(`items`, `" .. base64Encode(items) .. "`);")

        isBrowserOpen = true
        showCursor(true)
        guiSetVisible(initInventoryBrowser, true)
        guiFocus(initInventoryBrowser)
    else
        guiSetVisible(initInventoryBrowser, false)
        isBrowserOpen = false
        showCursor(false)
    end
end
bindKey("i", "down", toggleInventoryBrowser)
bindKey("p", "down", toggleInventoryBrowser)
addEvent('inventory:toggleInventoryBrowser', true)
addEventHandler('inventory:toggleInventoryBrowser', root, toggleInventoryBrowser)

function itemsChangeUpdate(theKey, oldValue, newValue)
    if theKey == "items" then
        local jsonData = toJSON(newValue)

        executeBrowserJavascript(inventoryBrowser, "clientData(`items`, `" .. base64Encode(jsonData) .. "`);")
    end
end
addEventHandler("onClientElementDataChange", root, itemsChangeUpdate)
