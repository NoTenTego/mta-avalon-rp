function saveAccountData(data)
    local accountData = xmlLoadFile('account.xml')

    if accountData then
        local username = xmlFindChild(accountData, 'username', 0)
        local password = xmlFindChild(accountData, 'password', 0)

        if username then
            xmlNodeSetValue(username, data.username)
        end

        if password then
            xmlNodeSetValue(password, data.password)
        end
    else
        accountData = xmlCreateFile('account.xml', 'accountData')

        local username = xmlCreateChild(accountData, 'username')
        local password = xmlCreateChild(accountData, 'password')

        xmlNodeSetValue(username, data.username)
        xmlNodeSetValue(password, data.password)
    end

    xmlSaveFile(accountData)
    xmlUnloadFile(accountData)
end

addEvent('accounts:cefData', true)
addEventHandler('accounts:cefData', root, function(switch, data)
    if switch == 'UCPLink' then
        setClipboard(data)
    elseif switch == 'handleLogin' then
        data = fromJSON(data)
        triggerServerEvent('accounts:server', localPlayer, 'verifyLogin', data)

        if data.rememberMe then
            saveAccountData(data)
        end
    elseif switch == 'characterEnter' then
        data = fromJSON(data)
        characterSelection(data)
    end
end)

addEvent('accounts:client', true)
addEventHandler('accounts:client', root, function(switch, data)
    if switch == 'error' then
        executeBrowserJavascript(loginPanelbrowser, "clientData('error', '" .. data .. "');")
    end
end)
