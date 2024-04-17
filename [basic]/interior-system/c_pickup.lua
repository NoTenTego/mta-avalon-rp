local screenWidth, screenHeight = guiGetScreenSize()
local px, py = (screenWidth / 1920), (screenHeight / 1080)
local zoom = 1
local fh = 1920
if screenWidth < fh then
    zoom = math.min(2, fh / screenWidth)
end

local initBrowser = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
local browser = guiGetBrowser(initBrowser)
guiSetVisible(initBrowser, false)

addEventHandler("onClientBrowserCreated", browser, function()
    loadBrowserURL(browser, "http://mta/cef/build/index.html#/interior")
end)

local data = {}

local pickup = nil
local boundKey = {}

local function isTableEmpty(t)
    for _, _ in pairs(t) do
        return false
    end
    return true
end

function enterInterior()
    if getPedOccupiedVehicle(localPlayer) then
        return
    end

    data = {}
    local jsonData = toJSON(data)
    executeBrowserJavascript(browser, "clientData(`" .. base64Encode(jsonData) .. "`);")

    if boundKey['e'] then
        unbindKey("e", "down", enterInterior)
        boundKey['e'] = false
    end

    triggerServerEvent('interior-system:enterInterior', localPlayer, pickup)
end

function buyInterior()
    if getPedOccupiedVehicle(localPlayer) then
        return
    end

    data = {}
    local jsonData = toJSON(data)
    executeBrowserJavascript(browser, "clientData(`" .. base64Encode(jsonData) .. "`);")

    triggerServerEvent('interior-system:buyInterior', localPlayer, pickup)
    return
end

addEventHandler("onClientPlayerPickupHit", localPlayer, function(thePickup, matchingDimension)
    if not matchingDimension then
        return
    end

    local pickupData = getElementData(thePickup, 'interior') or false
    if not pickupData then
        return
    end

    pickup = thePickup

    if pickupData.pickupName == 'enter' then
        local x, y, z = getElementPosition(thePickup)
        local streetName, citiesName = getZoneName(x, y, z), getZoneName(x, y, z, true)

        data.closed = pickupData.locked or true
        data.title = pickupData.id .. ' ' .. streetName .. ', ' .. citiesName
        if string.len(pickupData.name) > 2 then
            data.title = data.title .. ', ' .. pickupData.name
        end
        data.description = pickupData.description or 'Ten budynek nie posiada jeszcze opisu.'
        data.items = {}
        data.owner = pickupData.owner
        data.cost = pickupData.cost
        data.type = pickupData.type
        data.confirmation = false

        local jsonData = toJSON(data)
        executeBrowserJavascript(browser, "clientData(`" .. base64Encode(jsonData) .. "`);")

        guiSetVisible(initBrowser, true)
        guiFocus(initBrowser)
    end

    if not boundKey['e'] then
        bindKey("e", "down", enterInterior)
        boundKey['e'] = true
    end
end)

addEventHandler("onClientPlayerPickupLeave", localPlayer, function(thePickup, matchingDimension)
    if not matchingDimension then
        return
    end

    local pickupData = getElementData(thePickup, 'interior') or false
    if not pickupData then
        return
    end

    pickup = nil

    guiSetVisible(initBrowser, false)

    if boundKey['e'] then
        unbindKey("e", "down", enterInterior)
        boundKey['e'] = false
    end

    data = {}
    local jsonData = toJSON(data)
    executeBrowserJavascript(browser, "clientData(`" .. base64Encode(jsonData) .. "`);")
end)