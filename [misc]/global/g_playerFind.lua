function findPlayer(playerName)
    local foundPlayer = false
    local foundPlayerName = ''

    for _, player in ipairs(getElementsByType('player')) do
        if getElementData(player, 'playerID') == tonumber(playerName) then
            foundPlayer = player
            foundPlayerName = string.gsub(getElementData(foundPlayer, 'charactername'), '_', ' ')
            break
        end

        if string.find(getElementData(player, 'charactername'), playerName) then
            foundPlayer = player
            foundPlayerName = string.gsub(getElementData(foundPlayer, 'charactername'), '_', ' ')
            break
        end
    end

    return foundPlayer, foundPlayerName
end
