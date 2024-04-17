local screenWidth, screenHeight = guiGetScreenSize()

function toggleHandlingWindow(state, data)
    if state then
        initHandlingBrowser = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
        handlingBrowser = guiGetBrowser(initHandlingBrowser)

        addEventHandler("onClientBrowserCreated", handlingBrowser, function()
            loadBrowserURL(handlingBrowser, "http://mta/cef/build/index.html#/handling")
        end)

        addEventHandler("onClientBrowserDocumentReady", root, function(url)
            if url == "http://mta/cef/build/index.html#/handling" then
                executeBrowserJavascript(handlingBrowser, "clientData(`" .. base64Encode(data) .. "`);")
                showCursor(false)
            end
        end)
    else
        if isElement(initHandlingBrowser) then
            destroyElement(initHandlingBrowser)
        end
        
        showCursor(false)
    end
end
addEvent('vehicle-system:toggleHandlingWindow', true)
addEventHandler('vehicle-system:toggleHandlingWindow', root, toggleHandlingWindow)

addEvent('vehicle-system:updateHandlingCefData', true)
addEventHandler('vehicle-system:updateHandlingCefData', root, function(data)
    executeBrowserJavascript(handlingBrowser, "clientData(`" .. base64Encode(data) .. "`);")
end)
