local screenWidth, screenHeight = guiGetScreenSize()
local px, py = (screenWidth / 1920), (screenHeight / 1080)
local zoom = 1
local fh = 1920
if screenWidth < fh then
    zoom = math.min(2, fh / screenWidth)
end

local browser = createBrowser(screenWidth, screenHeight, true, true)
local data = {}

local function webBrowserRender()
    if not getElementData(localPlayer, 'loggedIn') == true then
        return
    end

    dxDrawImage(0, 0, screenWidth, screenHeight, browser, 0, 0, 0, tocolor(255, 255, 255, 255), true)
end

addEventHandler("onClientBrowserCreated", browser, function()
    loadBrowserURL(browser, "http://mta/cef/build/index.html#/notifications")

    addEventHandler("onClientBrowserDocumentReady", root, function(url)
        if url == "http://mta/cef/build/index.html#/notifications" then
            addEventHandler("onClientRender", root, webBrowserRender)

            local maxWidth = 365 / zoom
            local bottom = 274 * py
            local left = 19 / zoom

            local data = {
                maxWidth = maxWidth,
                bottom = bottom,
                left = left
            }

            local jsonData = toJSON(data)

            executeBrowserJavascript(browser, "clientData(`settings`, `" .. base64Encode(jsonData) .. "`);")
        end
    end)
end)

addEvent('hud:sendNotification', true)
addEventHandler('hud:sendNotification', root, function(type, title, description)
    local data = {
        type = type,
        title = title,
        description = description
    }

    local jsonData = toJSON(data)
    jsonData = string.gsub(jsonData, '`', "'")
    executeBrowserJavascript(browser, "clientData(`notification`, `" .. base64Encode(jsonData) .. "`);")
end)
