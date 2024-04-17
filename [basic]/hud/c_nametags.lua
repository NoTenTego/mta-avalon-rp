local screenWidth, screenHeight = guiGetScreenSize()

local font = dxCreateFont(":assets/fonts/signika.ttf", 14)
local fontSmall = dxCreateFont(":assets/fonts/signika.ttf", 12)

function removeHexFromString(str)
    return str:gsub("#%x%x%x%x%x%x", "")
end

-- nametags for players

addEventHandler("onClientRender", getRootElement(), function()
    if not getElementData(localPlayer, 'loggedIn') == true then
        return
    end

    local rx, ry, rz = getCameraMatrix()

    for i, player in pairs(getElementsByType("player")) do
        local loggedIn = getElementData(player, "loggedIn") == true
        if loggedIn then

            local id = getElementData(player, "playerID")
            local charactername = getElementData(player, 'charactername'):gsub("_", " ")
            local bx, by, bz = getPedBonePosition(player, 8)
            local fx, fy = getScreenFromWorldPosition(bx, by, bz + 0.4)

            if fx and fy then
                local sx, sy = math.floor(fx), math.floor(fy) - 10
                local dist = getDistanceBetweenPoints3D(rx, ry, rz, bx, by, bz)

                if dist <= 20 then

                    local playerName = "#ffffff" .. charactername .. " #ffffff(" .. id .. ")"

                    if getElementData(player, 'bw') then
                        playerName = playerName .. ' #cc0055(' .. getElementData(player, 'bw')[1] .. ')'
                    end

                    if hasElementData(player, 'adminDuty') then
                        local rankName, rankColor = exports.global:getRankName(player)
                        local playerName = rankColor .. '[' .. rankName .. '] #ffffff' .. getElementData(player, 'username') .. " (" .. id .. ")"

                        dxDrawText(removeHexFromString(playerName), sx + 4, sy + 7, sx + 1, sy + 6, tocolor(0, 0, 0, 255), 1, font, "center", "center", false, false, false, true, false)
                        dxDrawText(playerName, sx + 2, sy + 6, sx + 1, sy + 6, tocolor(0, 0, 0, 255), 1, font, "center", "center", false, false, false, true, false)
                    else
                        if hasElementData(localPlayer, 'adminDuty') then
                            playerName = playerName .. ' #c8c8c8(' .. getElementData(player, 'username') .. ')'
                        end

                        -- dxDrawText(removeHexFromString('#F10443LSFD'), sx + 4, sy - 14, sx + 1, sy - 13, tocolor(0, 0, 0, 255), 1, fontSmall, "center", "center", false, false, false, true, false)
                        -- dxDrawText('#F10443LSFD', sx + 2, sy - 13, sx + 1, sy - 13, tocolor(0, 0, 0, 255), 1, fontSmall, "center", "center", false, false, false, true, false)
                        dxDrawText(removeHexFromString(playerName), sx + 4, sy + 7, sx + 1, sy + 6, tocolor(0, 0, 0, 255), 1, font, "center", "center", false, false, false, true, false)
                        dxDrawText(playerName, sx + 2, sy + 6, sx + 1, sy + 6, tocolor(0, 0, 0, 255), 1, font, "center", "center", false, false, false, true, false)
                        dxDrawText(removeHexFromString('(umięśniony, kamizelka)'), sx + 3, sy + 26, sx, sy + 25, tocolor(0, 0, 0, 255), 1, fontSmall, "center", "center", false, false, false, true, false)
                        dxDrawText('(umięśniony, kamizelka)', sx + 1, sy + 25, sx, sy + 25, tocolor(200, 200, 200, 255), 1, fontSmall, "center", "center", false, false, false, true, false)
                    end
                end
            end
        end
    end

    -- nametags for bots

    for i, ped in pairs(getElementsByType("ped")) do
        local name = getElementData(ped, "name")

        if name then
            local bx, by, bz = getPedBonePosition(ped, 8)
            local fx, fy = getScreenFromWorldPosition(bx, by, bz + 0.4)

            if fx and fy then
                local sx, sy = math.floor(fx), math.floor(fy)
                local dist = getDistanceBetweenPoints3D(rx, ry, rz, bx, by, bz)

                if dist >= 1 and dist <= 12 then
                    dxDrawText(name .. " (#00ccffBOT#ffffff)", sx + 1, sy + 6, sx, sy + 5, tocolor(255, 255, 255, 240), 1, font, "center", "center", false, false, false, true, false)
                end
            end
        end
    end
end)

-- character description

addEventHandler("onClientRender", root, function()
    local cmX, cmY, cmZ = getCameraMatrix()

    for i, player in ipairs(getElementsByType("player", root)) do
        local loggedIn = getElementData(player, "loggedIn") == true

        if loggedIn then
            if not hasElementData(player, 'adminDuty') then
                local description = 'młody chłopak w luźnych ciuchach, na szyi widoczny jest mały tatuaż w postaci serduszka'

                if description then
                    local x, y, z = getPedBonePosition(player, 3)
                    local distance = getDistanceBetweenPoints3D(cmX, cmY, cmZ, x, y, z)

                    if distance <= 10 then
                        local wpX, wpY = getScreenFromWorldPosition(x, y, z + 0.4)

                        if wpX and wpY then
                            dxDrawText(description, wpX - (screenWidth / 10) + 2, wpY + (screenHeight / 10) + 1, wpX + (screenWidth / 10), wpY + (screenHeight / 10), tocolor(0, 0, 0, 255), 1, fontSmall, "center", "center", false, true)
                            dxDrawText(description, wpX - (screenWidth / 10), wpY + (screenHeight / 10), wpX + (screenWidth / 10), wpY + (screenHeight / 10), tocolor(220, 220, 220, 255), 1, fontSmall, "center", "center", false, true)
                        end
                    end
                end
            end
        end
    end
end)

-- nametages for vehicles

addEventHandler("onClientRender", root, function()
    local rx, ry, rz = getCameraMatrix()

    if not hasElementData(localPlayer, 'adminDuty') then
        return
    end

    if not getKeyState('lalt') then
        return
    end

    for i, vehicle in pairs(getElementsByType("vehicle")) do
        local bx, by, bz = getElementPosition(vehicle, 8)
        local fx, fy = getScreenFromWorldPosition(bx, by, bz + 0.4)

        if fx and fy then
            local sx, sy = math.floor(fx), math.floor(fy)
            local dist = getDistanceBetweenPoints3D(rx, ry, rz, bx, by, bz)

            local id = "ID: " .. string.gsub(getElementID(vehicle), 'vehicle:', '')

            if dist >= 1 and dist <= 12 then
                dxDrawText(id, sx + 3, sy + 7, sx, sy + 5, tocolor(0, 0, 0, 255), 1, font, "center", "center", false, false, false, true, false)
                dxDrawText(id, sx + 1, sy + 6, sx, sy + 5, tocolor(255, 255, 255, 255), 1, font, "center", "center", false, false, false, true, false)
            end
        end
    end
end)