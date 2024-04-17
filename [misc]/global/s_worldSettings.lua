local weathers = {0, 1, 3, 7, 8, 9, 10, 11}

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
    setCloudsEnabled(false)
    setFarClipDistance(750)
    setFogDistance(325)

    -- Nie jestem pewny, do przetestowania.
    -- setInteriorSoundsEnabled(false)

    local realtime = getRealTime()

    setTime(realtime.hour, realtime.minute)
    setMinuteDuration(60000)

    setTrafficLightState('disabled')

    setWeather(0)
    setTimer(function()
        setWeatherBlended(math.random(1, #weathers))
    end, 10800000, 0)
end)