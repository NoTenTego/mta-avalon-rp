local screenWidth, screenHeight = guiGetScreenSize()
local initVehlibBrowser = nil
local vehlibBrowser = nil
local isBrowserOpen = false

local initVehlibBrowser = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
local vehlibBrowser = guiGetBrowser(initVehlibBrowser)
guiSetVisible(initVehlibBrowser, false)

addEventHandler("onClientBrowserCreated", vehlibBrowser, function()
    loadBrowserURL(vehlibBrowser, "http://mta/cef/build/index.html#/vehlib")
end)

function toggleVehlib(data)
    if not isBrowserOpen then
        local vehicles = toJSON(data)
        executeBrowserJavascript(vehlibBrowser, "clientData(`" .. base64Encode(vehicles) .. "`);")

        isBrowserOpen = true
        showCursor(true)
        guiSetVisible(initVehlibBrowser, true)
        guiFocus(initVehlibBrowser)
    else
        guiSetVisible(initVehlibBrowser, false)
        isBrowserOpen = false
        showCursor(false)
    end
end
addEvent('vehicle-system:toggleVehlib', true)
addEventHandler('vehicle-system:toggleVehlib', root, toggleVehlib)