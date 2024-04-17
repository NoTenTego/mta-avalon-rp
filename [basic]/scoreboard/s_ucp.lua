function receiveResponse(responseData, errorCode, playerToReceive)

end

local function getPlayers()
    local players = {}
    for k, v in pairs(getElementsByType("player")) do
        table.insert(players, v)
    end
    return players
end

setTimer(function()
    local players = getPlayers()

    table.sort(players, function(a, b)
        return (getElementData(a, "playerid") or 0) < (getElementData(b, "playerid") or 0)
    end)

    local postData = {}

    for i, player in ipairs(players) do
        if getElementData(player, 'loggedIn') == true then
            table.insert(postData, {
                id = getElementData(player, "playerID"),
                fullName = getElementData(player, 'charactername'):gsub("_", " "),
                hours = getElementData(player, "hours"),
                ping = getPlayerPing(player)
            })
        else
            table.insert(postData, {
                id = '-',
                fullName = 'Ktoś dołącza...',
                hours = '-',
                ping = '-'
            })
        end
    end

    fetchRemote('http://localhost:8800/api/dashboard/getAllStats', {
        method = 'POST',
        postData = toJSON(postData),
        headers = {
            ["Content-Type"] = "application/json"
        }
    }, receiveResponse)
end, 5000, 0)