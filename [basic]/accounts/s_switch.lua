addEvent('accounts:server', true)
addEventHandler('accounts:server', root, function(switch, data)
    if switch == 'verifyLogin' then
        verifyLogin(data.username, data.password)
    elseif switch == 'spawnCharacter' then
        spawnCharacter(data)
    end
end)