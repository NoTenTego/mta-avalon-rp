local screenWidth, screenHeight = guiGetScreenSize()
local initBrowser
local browser

function toggleVehicleMenu(state, data)
    if state then
        initBrowser = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
        browser = guiGetBrowser(initBrowser)

        addEventHandler("onClientBrowserCreated", browser, function()
            loadBrowserURL(browser, "http://mta/cef/build/index.html#/vehicle/spawn")
        end)

        addEventHandler("onClientBrowserDocumentReady", root, function(url)
            if url == "http://mta/cef/build/index.html#/vehicle/spawn" then
                local data = toJSON(data)
                executeBrowserJavascript(browser, "clientData(`" .. base64Encode(data) .. "`);")
                showCursor(true)
            end
        end)
    else
        if isElement(initBrowser) then
            destroyElement(initBrowser)
        end

        showCursor(false)
    end
end
addEvent('vehicle-system:toggleVehicleMenu', true)
addEventHandler('vehicle-system:toggleVehicleMenu', root, toggleVehicleMenu)

addEvent('vehicle-system:updateVehicleMenu', true)
addEventHandler('vehicle-system:updateVehicleMenu', root, function(data)
    if isElement(browser) then
        local data = toJSON(data)
        executeBrowserJavascript(browser, "clientData(`" .. base64Encode(data) .. "`);")
    end
end)
