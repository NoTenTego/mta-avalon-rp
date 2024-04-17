local sx, sy = guiGetScreenSize()
local px, py = (sx / 1920), (sy / 1080)
local zoom = 1
local fh = 1920
if sx < fh then
    zoom = math.min(2, fh / sx)
end
local fontBig = dxCreateFont(":assets/fonts/signika.ttf", 17)
local fontSmall = dxCreateFont(":assets/fonts/signika.ttf", 15)

function isEventHandlerAdded(sEventName, pElementAttachedTo, func)
    if type(sEventName) == 'string' and isElement(pElementAttachedTo) and type(func) == 'function' then
        local aAttachedFunctions = getEventHandlers(sEventName, pElementAttachedTo)
        if type(aAttachedFunctions) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs(aAttachedFunctions) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

k = 1
n = 17
m = 17

local function getPlayers()
    local players = {}
    for k, v in pairs(getElementsByType("player")) do
        table.insert(players, v)
    end
    return players
end

function onRender()
    if getElementData(localPlayer, "loggedIn") == true then

        players = getPlayers()

        table.sort(players, function(a, b)
            return (getElementData(a, "playerid") or 0) < (getElementData(b, "playerid") or 0)
        end)

        dxDrawRectangle(735 / zoom, 240 * py, 450 / zoom, 600 * py, tocolor(0, 0, 0, 175), true)
        dxDrawRectangle(750 / zoom, 280 * py, 420 / zoom, 1 * py, tocolor(200, 200, 200, 255), true)

        dxDrawText("Avalon RolePlay ", 750 / zoom, 263 * py, 1920 / zoom, 263 * py, tocolor(200, 200, 200, 255), 1 / zoom, fontSmall, "left", "center", false, false, true)
        dxDrawText("Graczy " .. #players .. "/1024", 1920 / zoom, 263 * py, 1170 / zoom, 263 * py, tocolor(200, 200, 200, 255), 1 / zoom, fontSmall, "right", "center", false, false, true)

        dxDrawText("ID", 750 / zoom, 300 * py, 1920 / zoom, 300 * py, tocolor(255, 255, 255, 255), 1 / zoom, fontBig, "left", "center", false, false, true)
        dxDrawText("Dane osobowe", 800 / zoom, 300 * py, 1920 / zoom, 300 * py, tocolor(255, 255, 255, 255), 1 / zoom, fontBig, "left", "center", false, false, true)
        dxDrawText("Ping", 1126 / zoom, 300 * py, 1920 / zoom, 300 * py, tocolor(255, 255, 255, 255), 1 / zoom, fontBig, "left", "center", false, false, true)

        y = 0
        for i, v in ipairs(getElementsByType("player")) do
            if i >= k and i <= n then
                y = y + 30
                if getElementData(v, "loggedIn") == true then
                    dxDrawText(getElementData(v, "playerID"), 750 / zoom, 300 * py + y * py, 1920 / zoom, 300 * py + y * py, tocolor(200, 200, 200, 255), 1 / zoom, fontSmall, "left", "center", false, false, true)
                    dxDrawText(getElementData(v, 'charactername'):gsub("_", " "), 800 / zoom, 300 * py + y * py, 1920 / zoom, 300 * py + y * py, tocolor(200, 200, 200, 255), 1 / zoom, fontSmall, "left", "center", false, false, true)
                    dxDrawText(getPlayerPing(v), 1136 / zoom, 300 * py + y * py, 1920 / zoom, 300 * py + y * py, tocolor(200, 200, 200, 255), 1 / zoom, fontSmall, "left", "center", false, false, true)
                else
                    dxDrawText("-", 750 / zoom, 300 * py + y * py, 1920 / zoom, 300 * py + y * py, tocolor(150, 150, 150, 255), 1 / zoom, fontSmall, "left", "center", false, false, true)
                    dxDrawText("Ktoś dołącza...", 800 / zoom, 300 * py + y * py, 1920 / zoom, 300 * py + y * py, tocolor(150, 150, 150, 255), 1 / zoom, fontSmall, "left", "center", false, false, true)
                    dxDrawText("-", 1136 / zoom, 300 * py + y * py, 1920 / zoom, 300 * py + y * py, tocolor(150, 150, 150, 255), 1 / zoom, fontSmall, "left", "center", false, false, true)
                end
            end
        end

    end
end

bindKey("tab", "both", function()
    if getElementData(localPlayer, "loggedIn") == false then
        return
    end

    if isEventHandlerAdded("onClientRender", root, onRender) then
        removeEventHandler("onClientRender", root, onRender)
    else
        addEventHandler("onClientRender", root, onRender)
    end
end)

bindKey("mouse_wheel_down", "both", function()
    if isEventHandlerAdded("onClientRender", root, onRender) then
        if n >= players then
            return
        end
        k = k + 1
        n = n + 1
    end
end)

bindKey("mouse_wheel_up", "both", function()
    if isEventHandlerAdded("onClientRender", root, onRender) then
        if n == m then
            return
        end
        k = k - 1
        n = n - 1
    end
end)
