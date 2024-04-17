function getRankName(thePlayer)
    local supportLevel = getElementData(thePlayer, 'support_level') or 0
    local adminLevel = getElementData(thePlayer, 'admin_level') or 0

    if adminLevel == 4 then
        return 'Administrator', '#ff0000'
    elseif adminLevel == 3 then
        return 'Administrator', '#ff0000'
    elseif adminLevel == 2 then
        return 'Community Manager', '#ff0000'
    elseif adminLevel == 1 then
        return 'Gamemaster', '#ff0000'
    end

    if supportLevel == 1 then
        return 'Supporter', '#00ff00'
    end

    return 'Ekipa Serwera', '#ff0000'
end