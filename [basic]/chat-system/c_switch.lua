addEvent('chat-system:cefData', true)
addEventHandler('chat-system:cefData', root, function(switch, data)
    if isElement(browser) then
        showCursor(false)
        focusBrowser(nil)
        guiSetInputMode("allow_binds")
    end

    if switch == 'ic' then
        triggerServerEvent('chat-system:sendMessageToNearbyPlayers', localPlayer, localPlayer, 'say', data)
    elseif switch == 'command' then
        local commandData = fromJSON(data)

        local commandExecuted = executeCommandHandler(commandData.command, unpack(commandData.arguments))

        if not commandExecuted then
            triggerServerEvent('executeServerCommand', localPlayer, data)
        end
    end
end)
