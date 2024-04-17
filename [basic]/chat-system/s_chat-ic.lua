function capitalizeFirstLetter(message)
    return message:sub(1, 1):upper() .. message:sub(2)
end

addEventHandler("onPlayerChat", root, function()
    cancelEvent()
end)

function playerChat(thePlayer, commandName, ...)
    if not getElementData(thePlayer, "loggedIn") == true then
        return
    end

    local message = table.concat({...}, " ")
    if not message then
        return
    end

    if string.len(message) < 2 or string.len(message) > 128 then
        return
    end

    local playerName = exports.global:getPlayerName(thePlayer)
    local posX1, posY1, posZ1 = getElementPosition(thePlayer)
    local dimension = getElementDimension(thePlayer)

    local lastLetter = string.sub(message, -1)
    if not (lastLetter == '?' or lastLetter == '!' or lastLetter == '.') then
        message = message .. '.'
    end

    if isPedDead(thePlayer) then
        return triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'BW', "Dopóki masz BW, możesz korzystać tylko z komend narracyjnych.")
    end

    message = capitalizeFirstLetter(message)

    for id, player in ipairs(getElementsByType("player")) do
        local posX2, posY2, posZ2 = getElementPosition(player)
        if getDistanceBetweenPoints3D(posX1, posY1, posZ1, posX2, posY2, posZ2) <= 20 then
            if getElementDimension(player) == dimension then
                outputChatBox(playerName .. ' mówi: ' .. message, player, 255, 255, 255)
                triggerClientEvent(player, "sendChatICMessage", player, playerName .. ' mówi: ' .. message, {
                    color = 'rgb(255, 255, 255)'
                })
            end
        end
    end
end
addEvent('chat-system:sendMessageToNearbyPlayers', true)
addEventHandler('chat-system:sendMessageToNearbyPlayers', root, playerChat)
addCommandHandler('say', playerChat)

addCommandHandler('me', function(thePlayer, commandName, ...)
    local message = table.concat({...}, " ")
    if not message then
        return
    end

    if string.len(message) < 2 or string.len(message) > 128 then
        return
    end

    local playerName = exports.global:getPlayerName(thePlayer)
    local posX1, posY1, posZ1 = getElementPosition(thePlayer)
    local dimension = getElementDimension(thePlayer)

    local lastLetter = string.sub(message, -1)
    if not (lastLetter == '?' or lastLetter == '!' or lastLetter == '.') then
        message = message .. '.'
    end

    for id, player in ipairs(getElementsByType("player")) do
        local posX2, posY2, posZ2 = getElementPosition(player)
        if getDistanceBetweenPoints3D(posX1, posY1, posZ1, posX2, posY2, posZ2) <= 20 then
            if getElementDimension(player) == dimension then
                outputChatBox('** ' .. playerName .. ' ' .. message, player, 220, 162, 244)
                triggerClientEvent(player, "sendChatICMessage", player, '** ' .. playerName .. ' ' .. message, {
                    color = 'rgb(220, 162, 244)'
                })
            end
        end
    end
end)

function loudMessage(thePlayer, commandName, ...)
    if not getElementData(thePlayer, "loggedIn") == true then
        return
    end

    if isPedDead(thePlayer) then
        return
    end

    local message = capitalizeFirstLetter(table.concat({...}, " "))
    if not message then
        return
    end

    if string.len(message) < 2 or string.len(message) > 128 then
        return
    end

    local playerName = exports.global:getPlayerName(thePlayer)
    local posX1, posY1, posZ1 = getElementPosition(thePlayer)
    local dimension = getElementDimension(thePlayer)

    for id, player in ipairs(getElementsByType("player")) do
        local posX2, posY2, posZ2 = getElementPosition(player)
        if getDistanceBetweenPoints3D(posX1, posY1, posZ1, posX2, posY2, posZ2) <= 30 then
            if getElementDimension(player) == dimension then
                outputChatBox(playerName .. ' krzyczy: ' .. message .. '!', player, 255, 255, 255)
                triggerClientEvent(player, "sendChatICMessage", player, playerName .. ' krzyczy: ' .. message .. '!', {
                    color = 'rgb(255, 255, 255)'
                })
            end
        end
    end
end
addCommandHandler('k', loudMessage)
addCommandHandler('krzyk', loudMessage)
addCommandHandler('krzycz', loudMessage)

function silentMessage(thePlayer, commandName, ...)
    if not getElementData(thePlayer, "loggedIn") == true then
        return
    end

    local message = capitalizeFirstLetter(table.concat({...}, " "))
    if not message then
        return
    end

    if string.len(message) < 2 or string.len(message) > 128 then
        return
    end

    local lastLetter = string.sub(message, -1)
    if not (lastLetter == '?' or lastLetter == '!' or lastLetter == '.') then
        message = message .. '.'
    end

    local playerName = exports.global:getPlayerName(thePlayer)
    local posX1, posY1, posZ1 = getElementPosition(thePlayer)
    local dimension = getElementDimension(thePlayer)

    for id, player in ipairs(getElementsByType("player")) do
        local posX2, posY2, posZ2 = getElementPosition(player)
        if getDistanceBetweenPoints3D(posX1, posY1, posZ1, posX2, posY2, posZ2) <= 5 then
            if getElementDimension(player) == dimension then
                outputChatBox(playerName .. ' szepcze: ' .. message, player, 200, 200, 200)
                triggerClientEvent(player, "sendChatICMessage", player, playerName .. ' szepcze: ' .. message, {
                    color = 'rgb(200, 200, 200)'
                })
            end
        end
    end
end
addCommandHandler('s', silentMessage)
addCommandHandler('szept', silentMessage)
addCommandHandler('szepcz', silentMessage)

addCommandHandler('do', function(thePlayer, commandName, ...)
    if not getElementData(thePlayer, "loggedIn") == true then
        return
    end

    local message = table.concat({...}, " ")
    if not message then
        return
    end

    if string.len(message) < 2 or string.len(message) > 128 then
        return
    end

    local playerName = exports.global:getPlayerName(thePlayer)
    local posX1, posY1, posZ1 = getElementPosition(thePlayer)
    local dimension = getElementDimension(thePlayer)

    message = capitalizeFirstLetter(message)

    for id, player in ipairs(getElementsByType("player")) do
        local posX2, posY2, posZ2 = getElementPosition(player)
        if getDistanceBetweenPoints3D(posX1, posY1, posZ1, posX2, posY2, posZ2) <= 20 then
            if getElementDimension(player) == dimension then
                outputChatBox('** ' .. message .. ' (( ' .. playerName .. ' ))**', player, 132, 130, 184)
                triggerClientEvent(player, "sendChatICMessage", player, '** ' .. message .. ' (( ' .. playerName .. ' ))**', {
                    color = 'rgb(132, 130, 184)'
                })
            end
        end
    end
end)
