function chatOOC(thePlayer, commandName, ...)
    if not getElementData(thePlayer, "loggedIn") == true then
        return
    end

    local message = table.concat({...}, " ")
    if not message then
        return
    end

    if string.len(message) > 128 then
        return
    end

    local name = exports.global:getPlayerName(thePlayer)
    local dimension = getElementDimension(thePlayer)
    local x, y, z = getElementPosition(thePlayer)

    local data = {
        message = name .. ': ' .. message
    }

    if getElementData(thePlayer, 'adminDuty') then
        local rankName, rankColor = exports.global:getRankName(thePlayer)
        local username = getElementData(thePlayer, 'username')

        data.before = '<span style="color:' .. rankColor .. ';">' .. rankName .. ' </span> '
        data.message = username .. ': ' .. message
    end

    for _, nearbyPlayer in ipairs(getElementsByType("player")) do
        if getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyPlayer)) < 20 then
            if getElementDimension(nearbyPlayer) == dimension then
                triggerClientEvent(nearbyPlayer, "sendChatOOCMessage", nearbyPlayer, data)
            end
        end
    end
end
addCommandHandler("ooc", chatOOC)

function teamChat(thePlayer, commandName, ...)
    if not exports.global:hasPermission(thePlayer, 'chat-system', 'ekipa') then
        return
    end

    if not getElementData(thePlayer, "loggedIn") == true then
        return
    end

    local message = table.concat({...}, " ")
    if not message then
        return
    end

    local username = getElementData(thePlayer, 'username')

    for _, player in ipairs(getElementsByType("player")) do
        if exports.global:hasPermission(player, 'chat-system', 'ekipa') then
            triggerClientEvent(player, "sendChatOOCMessage", player, data)
        end
    end
end
addCommandHandler('ekipa', teamChat)
addCommandHandler('e', teamChat)
