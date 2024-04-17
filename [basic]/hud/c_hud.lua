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

    if isPedDead(localPlayer) then
        return
    end

    dxDrawImage(0, 0, screenWidth, screenHeight, browser, 0, 0, 0, tocolor(255, 255, 255, 255), true)

    data.money = getElementData(localPlayer, 'money')
    data.dutyName = ''
    data.dutyTime = ''
    data.dutyColor = ''

    local vehicle = getPedOccupiedVehicle(localPlayer)

    if vehicle then
        local vehicleData = getElementData(vehicle, 'data')
        local vehicleSpeed = exports.global:getVehicleVelocity(vehicle) or 0

        data.vehicle = true
        data.actualSpeed = math.floor(vehicleSpeed)
        data.maxFuel = 100
        if not vehicleData then
            data.currentFuel = 100
        else
            data.currentFuel = math.floor(vehicleData.fuel)
        end
    else
        data.vehicle = false
    end

    local jsonData = toJSON(data)
    executeBrowserJavascript(browser, "clientData('" .. base64Encode(jsonData) .. "');")
end

addEventHandler("onClientBrowserCreated", browser, function()
    loadBrowserURL(browser, "http://mta/cef/build/index.html#/hud")

    addEventHandler("onClientBrowserDocumentReady", root, function(url)
        if url == "http://mta/cef/build/index.html#/hud" then
            addEventHandler("onClientRender", root, webBrowserRender)
        end
    end)
end)

local fps = 0
local nextTick = 0
function getCurrentFPS()
    return fps
end

local function updateFPS(msSinceLastFrame)
    local now = getTickCount()
    if (now >= nextTick) then
        fps = (1 / msSinceLastFrame) * 1000
        nextTick = now + 1000
    end
end
addEventHandler("onClientPreRender", root, updateFPS)

local function drawFPS()
    if not getCurrentFPS() then
        return
    end
    local roundedFPS = math.floor(getCurrentFPS())
    dxDrawText('Aktualne FPS: ' .. roundedFPS, 1920 / zoom, 1064 * py, 1820 / zoom, 1064 * py, tocolor(150, 150, 150), 1, 1, 'default', 'right')
end
addEventHandler("onClientHUDRender", root, drawFPS)
