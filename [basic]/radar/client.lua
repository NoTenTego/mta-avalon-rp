local screenWidth, screenHeight = guiGetScreenSize()
local px, py = (screenWidth / 1920), (screenHeight / 1080)
local zoom = 1
local fh = 1920
if screenWidth < fh then
    zoom = math.min(2, fh / screenWidth)
end

local font = dxCreateFont(':assets/fonts/signika.ttf', 15)

local map = dxCreateTexture("images/map.jpg")

local factorScale = 6000 / 3072

local mapImageScaleX, mapImageScaleY = 363, 230

function getPedMaxHealth(ped)
    assert(isElement(ped) and (getElementType(ped) == "ped" or getElementType(ped) == "player"), "Bad argument @ 'getPedMaxHealth' [Expected ped/player at argument 1, got " .. tostring(ped) .. "]")

    local stat = getPedStat(ped, 24)

    local maxhealth = 100 + (stat - 569) / 4.31

    return math.max(1, maxhealth)
end

function renderMinimap()
    if not getElementData(localPlayer, 'loggedIn') == true then
        return
    end

    local mapImageX, mapImageY = 20 / zoom, screenHeight - 23 - mapImageScaleY * py
    if getElementData(localPlayer, 'adminDuty') then
        mapImageY = screenHeight - 13 - mapImageScaleY * py
    end

    local playerX, playerY, playerZ = getElementPosition(localPlayer)
    local _, _, rot = getElementRotation(localPlayer)

    -- Border of minimap
    local borderYOffset = 14
    if getElementData(localPlayer, 'adminDuty') then
        borderYOffset = 4
    end

    dxDrawRectangle(mapImageX - 2, mapImageY - 2, mapImageScaleX / zoom + 4, mapImageScaleY * py + borderYOffset, tocolor(0, 0, 0, 100))

    -- Radar
    dxDrawImageSection(mapImageX, mapImageY, mapImageScaleX / zoom, mapImageScaleY * py, ((playerX + 3000) / factorScale) - mapImageScaleX / zoom / 2, ((-playerY + 3000) / factorScale) - mapImageScaleY * py / 2, mapImageScaleX / zoom, mapImageScaleY * py, map, 0, 0, 0, tocolor(255, 255, 255, 180))
    dxDrawImage(mapImageX + (mapImageScaleX / zoom - 15) / 2, mapImageY + (mapImageScaleY * py - 15) / 2, 18, 18, 'images/arrow.png', 360 - rot)

    -- Zone Name
    local zoneName = getZoneName(playerX, playerY, playerZ, false)
    local zoneNameWidth = dxGetTextWidth(zoneName, 1, font)
    local zoneNameWidth, zoneNameHeight = dxGetTextSize(zoneName, zoneNameWidth, 1 / zoom, font)

    dxDrawRectangle(mapImageX, mapImageY + mapImageScaleY * py - zoneNameHeight, mapImageScaleX / zoom, zoneNameHeight, tocolor(0, 0, 0, 175))
    dxDrawText(zoneName, mapImageX + 3, mapImageY + mapImageScaleY * py - zoneNameHeight, mapImageScaleX / zoom, zoneNameHeight, tocolor(255, 255, 255, 255), 1 / zoom, font)

    -- Staty
    if not getElementData(localPlayer, 'adminDuty') then
        local playerArmor = getPedArmor(localPlayer)
        local barArmorLength = math.min(mapImageScaleX / zoom, mapImageScaleX / zoom * (playerArmor / 100))

        local playerHealth, playerMaxHealth = getElementHealth(localPlayer), getPedMaxHealth(localPlayer)
        local healthRatio = playerHealth / playerMaxHealth
        local barHealthLength = math.min(mapImageScaleX / zoom, mapImageScaleX / zoom * healthRatio)

        dxDrawRectangle(mapImageX, mapImageY + mapImageScaleY * py + 2, mapImageScaleX / zoom / 2 - 1, 8, tocolor(200, 0, 0, 75))
        dxDrawRectangle(mapImageX, mapImageY + mapImageScaleY * py + 2, barHealthLength / 2 - 1, 8, tocolor(200, 0, 0, 255))

        -- Armor
        dxDrawRectangle(mapImageX + (mapImageScaleX / zoom / 2), mapImageY + mapImageScaleY * py + 2, mapImageScaleX / zoom / 2, 8, tocolor(116, 133, 127, 200))
        dxDrawRectangle(mapImageX + (mapImageScaleX / zoom / 2), mapImageY + mapImageScaleY * py + 2, barArmorLength / 2, 8, tocolor(200, 220, 210, 255))
    end
end
addEventHandler("onClientRender", root, renderMinimap)
