local screenWidth, screenHeight = guiGetScreenSize()

addEvent("accounts:characterSelection", true)
addEventHandler("accounts:characterSelection", root, function(characters)
    destroyLoginScreen()
    fadeCamera(false)

    initcharacterSelectionBrowser = guiCreateBrowser(0, 0, screenWidth, screenHeight, true, true, false)
    characterSelectionBrowser = guiGetBrowser(initcharacterSelectionBrowser)

    addEventHandler("onClientBrowserCreated", characterSelectionBrowser, function()
        loadBrowserURL(characterSelectionBrowser, "http://mta/cef/build/index.html#/characterselection")
    end)

    addEventHandler("onClientBrowserDocumentReady", characterSelectionBrowser, function(url)
        if url == "http://mta/cef/build/index.html#/characterselection" then
            for i, character in ipairs(characters) do
                character.business = nil
            end
            local jsonData = toJSON(characters)

            executeBrowserJavascript(characterSelectionBrowser, "clientData(`" .. base64Encode(jsonData) .. "`);")
            characterSelection(characters[1])
            fadeCamera(true)
        end
    end)
end)

function characterSelection(character)
    local x, y, z, rotation = character.x, character.y, character.z, character.rotation
    local camDistance = 3.5
    local camX = x + math.sin(math.rad(-rotation)) * camDistance
    local camY = y + math.cos(math.rad(-rotation)) * camDistance
    setCameraMatrix(camX, camY, z + 0.5, x, y, z, 0, 0)

    if isElement(ped) then
        if getElementData(ped, 'fakeName') == character.charactername then
            triggerServerEvent('accounts:server', localPlayer, 'spawnCharacter', character)
            enterCharacter()
            destroyElement(ped)
            return
        end

        setElementPosition(ped, x, y, z)
        setElementRotation(ped, 0, 0, rotation)
        setElementModel(ped, character.skin)
        setElementData(ped, 'fakeName', character.charactername)
    else
        ped = createPed(character.skin, x, y, z, rotation, false)
        setElementData(ped, 'fakeName', character.charactername)
    end
    setElementDimension(ped, getElementData(localPlayer, 'accountID'))
end

function enterCharacter()
    destroyElement(initcharacterSelectionBrowser)
    showChat(true)
    showCursor(false)
end
