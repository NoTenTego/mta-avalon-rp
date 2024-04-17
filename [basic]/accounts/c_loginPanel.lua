local screenWidth, screenHeight = guiGetScreenSize()
initloginPanelbrowser = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
loginPanelbrowser = guiGetBrowser(initloginPanelbrowser)
local components = {"ammo", "area_name", "armour", "breath", "clock", "health", "money", "radar", "vehicle_name", "weapon", "radio", "wanted"}
local animateScreen = {
    [1] = {2079.1259765625, -1653.15234375, 40.260612487793, 2079.38671875, -1845.08203125, 32.534748077393},
    [2] = {1569.8271484375, -1735.2900390625, 47.129894256592, 1539.169921875, -1649.8603515625, 35.231113433838},
    [3] = {1061.33984375, -1420.44921875, 47.626876831055, 1099.658203125, -1327.173828125, 37.626876831055},
    [4] = {1204.087890625, -1405.9521484375, 33.792552947998, 1270.3564453125, -1408.14453125, 26.263690948486},
    [5] = {1966.607421875, -1170.673828125, 45.119743347168, 1966.607421875, -1170.673828125, 35.119743347168}
}
local moved = 250
local speed = 0.3

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function()
    if getElementData(localPlayer, "loggedIn") == true then
        return
    end

    addEventHandler("onClientBrowserCreated", loginPanelbrowser, function()
        loadBrowserURL(loginPanelbrowser, "http://mta/cef/build/index.html#/loginpanel")
    end)

    addEventHandler("onClientBrowserDocumentReady", root, function(url)
        if url == "http://mta/cef/build/index.html#/loginpanel" then
            local accountData = xmlLoadFile('account.xml')

            if accountData then
                local username = xmlFindChild(accountData, 'username', 0)
                local password = xmlFindChild(accountData, 'password', 0)

                if username then
                    username = xmlNodeGetValue(username)
                end

                if password then
                    password = xmlNodeGetValue(password)
                end

                local jsonData = toJSON({
                    username = username,
                    password = password
                })
                executeBrowserJavascript(loginPanelbrowser, "clientData('accountData', '" .. base64Encode(jsonData) .. "');")

                xmlUnloadFile(accountData)
            end
        end
    end)

    for i, component in ipairs(components) do
        setPlayerHudComponentVisible(component, false)
    end

    showChat(false)
    fadeCamera(true)
    showCursor(true)

    addEventHandler("onClientRender", root, renderPanel)
    setDevelopmentMode(true, true)
end)

local function shuffleScreen()
    local rand = math.random(1, #animateScreen)
    if rand ~= old then
        old_screen = rand
        return animateScreen[rand]
    else
        return shuffleScreen(old)
    end
end

local function slideScreen()
    local matrix = {getCameraMatrix(localPlayer)}
    matrix[1] = matrix[1] + speed
    moved = moved + speed
    if moved > 200 then
        local scr = shuffleScreen()
        moved = 0
        setCameraMatrix(scr[1], scr[2], scr[3], scr[4], scr[5], scr[6], 0, 180)
    else
        setCameraMatrix(unpack(matrix))
    end
end

function renderPanel()
    slideScreen()
end

function destroyLoginScreen()
    destroyElement(initloginPanelbrowser)
    removeEventHandler("onClientRender", root, renderPanel)
end
