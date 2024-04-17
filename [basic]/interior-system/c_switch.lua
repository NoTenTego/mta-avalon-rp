addEvent("interior-system:cefData", true)
addEventHandler("interior-system:cefData", root, function(switch, data)
    if switch == 'buyInterior' then
        buyInterior()
    end
end)
