local sx, sy = guiGetScreenSize()
local px, py = (sx / 1920), (sy / 1080)
local zoom = 1
local fh = 1920
if sx < fh then
    zoom = math.min(2, fh / sx)
end

local font = dxCreateFont(":assets/fonts/signika.ttf", 35)

addEventHandler("onClientPlayerDamage", localPlayer, function(attacker, weapon, bodypart)
    if getElementData(source, 'adminDuty') then
        cancelEvent()
    end
end)

addEvent('bw-system:playerDeath', true)
addEventHandler('bw-system:playerDeath', getRootElement(), function(state)
    if state then
        addEventHandler('onClientRender', root, renderDeath)

        local x, y, z = getElementPosition(localPlayer)
        local interior = getElementInterior(localPlayer)
        if interior > 0 then
            z = z + 5
        else
            z = z + 9
        end

        setCameraMatrix(x, y, z + 7, x, y, z)
    else
        removeEventHandler('onClientRender', root, renderDeath)

        setCameraTarget(localPlayer)
    end
end)

function secondsToMinutes(seconds)
    local totalSec = tonumber(seconds)
    if totalSec then
        local hours = math.floor(seconds / 3600)
        if hours < 10 then
            hours = "0" .. hours
        end
        local seconds = math.fmod(math.floor(totalSec), 60)
        if seconds < 10 then
            seconds = "0" .. seconds
        end
        local minutes = math.fmod(math.floor(totalSec / 60), 60)
        if minutes < 10 then
            minutes = "0" .. minutes
        end
        if seconds and minutes and hours then
            return seconds, minutes, hours
        end
    end
end

function renderDeath()
    if not getElementData(localPlayer, 'loggedIn') == true then
        return
    end

    local deathTime = getElementData(localPlayer, 'bw')[2]
    if not deathTime then
        return
    end

    local seconds, minutes = secondsToMinutes(deathTime)

    dxDrawRectangle(0, 0, sx, sy, tocolor(0, 0, 0, 100))
    dxDrawRectangle(1675 / zoom, 982 * py, 209 / zoom, 43 * py, tocolor(0, 0, 0, 100))
    dxDrawText("BW - " .. minutes .. ":" .. seconds, 1680 / zoom, 1000 * py, 1920 / zoom, 1000 * py, tocolor(255, 255, 255, 255), 1 / zoom, font, "left", "center", false)
end
