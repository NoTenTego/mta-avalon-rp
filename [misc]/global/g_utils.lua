function isLeapYear(year)
    if year then
        year = math.floor(year)
    else
        year = getRealTime().year + 1900
    end
    return ((year % 4 == 0 and year % 100 ~= 0) or year % 400 == 0)
end

function getTimestamp(year, month, day, hour, minute, second)
    local monthseconds = {2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400}
    local timestamp = 0
    local datetime = getRealTime()
    year, month, day = year or datetime.year + 1900, month or datetime.month + 1, day or datetime.monthday
    hour, minute, second = hour or datetime.hour, minute or datetime.minute, second or datetime.second

    for i = 1970, year - 1 do
        timestamp = timestamp + (isLeapYear(i) and 31622400 or 31536000)
    end
    for i = 1, month - 1 do
        timestamp = timestamp + ((isLeapYear(year) and i == 2) and 2505600 or monthseconds[i])
    end
    timestamp = timestamp + 86400 * (day - 1) + 3600 * hour + 60 * minute + second

    timestamp = timestamp - 3600
    if datetime.isdst then
        timestamp = timestamp - 3600
    end

    return timestamp
end

function getPlayerName(thePlayer)
    local playerName = getElementData(thePlayer, 'charactername')
    return string.gsub(playerName, "_", ' ')
end

function findInTable(t, value)
    for k, v in ipairs(t) do
        if value == v then
            return true
        end
    end

    return false
end

function getVehicleVelocity(vehicle)
    local speedx, speedy, speedz = getElementVelocity(vehicle)
    local actualspeed = (speedx ^ 2 + speedy ^ 2 + speedz ^ 2) ^ (0.5)
    return actualspeed * 180
end