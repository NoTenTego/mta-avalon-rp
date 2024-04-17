function giveMoney(thePlayer, money)
    local oldMoney = getElementData(thePlayer, 'money')
    local newMoney = oldMoney + money

    setElementData(thePlayer, 'money', newMoney)
    triggerClientEvent(thePlayer, 'global:playSound', thePlayer, 'giveMoney.mp3', 0.2)

    return true
end

function takeMoney(thePlayer, money)
    local oldMoney = getElementData(thePlayer, 'money')
    local newMoney = oldMoney - money

    setElementData(thePlayer, 'money', newMoney)
    triggerClientEvent(thePlayer, 'global:playSound', thePlayer, 'takeMoney.mp3', 0.2)

    return true
end

addEvent('executeServerCommand', true)
addEventHandler('executeServerCommand', root, function(data)
    local commandData = fromJSON(data)

    local executeCommand = executeCommandHandler(commandData.command, client, unpack(commandData.arguments))

    if not executeCommand then
        triggerClientEvent(client, "hud:sendNotification", client, 'warning', 'Nieprawidłowa komenda', "Nie odnaleziono komendy którą wpisałeś. Zgłoś to administracji: Error 400 "..commandData.command.." ["..unpack(commandData.arguments).."]")
    end
end)