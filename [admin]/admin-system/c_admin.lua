function takePosition()
    local x, y, z = getElementPosition(localPlayer)
    setClipboard(x .. ", " .. y .. ", " .. z)
    triggerEvent('hud:sendNotification', localPlayer, 'success', 'Twoja pozycja', 'Pomyślnie skopiowano twoje XYZ do schowka.')
end
addCommandHandler("getpos", takePosition)

function takeRotation()
    local x, y, z = getElementRotation(localPlayer)
    setClipboard(x .. ", " .. y .. ", " .. z)
    triggerEvent('hud:sendNotification', localPlayer, 'success', 'Twoja rotacja', 'Pomyślnie skopiowano twoją rotacje do schowka.')
end
addCommandHandler("getrot", takeRotation)

function takeCameraPosition()
    local x, y, z, lx, ly, lz = getCameraMatrix()
    setClipboard(x .. ", " .. y .. ", " .. z .. ", " .. lx .. ", " .. ly .. ", " .. lz)
    triggerEvent('hud:sendNotification', localPlayer, 'success', 'Pozycja kamery', 'Pomyślnie skopiowano pozycje kamery do schowka.')
end
addCommandHandler("getcam", takeCameraPosition)