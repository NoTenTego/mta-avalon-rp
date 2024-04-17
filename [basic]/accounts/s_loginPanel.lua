local mysql = exports.mysql

function verifyLogin(username, password)
    local row = mysql:query("SELECT id, salt, password, admin_level, support_level FROM accounts WHERE username = ?", username)
    if not row[1] then
        triggerClientEvent(client, "accounts:client", client, 'error', "Wprowadzone dane są nieprawidłowe.")
        return
    end

    local encryptionRule = row[1]["salt"]
    local encryptedPW = md5(md5(password):lower() .. encryptionRule):lower()
    if encryptedPW == row[1]["password"] then
        for _, player in ipairs(getElementsByType("player")) do
            local dbid = tonumber(getElementData(player, "accountID"))
            if dbid and dbid == tonumber(row[1]["id"]) then
                triggerClientEvent(player, 'hud:sendNotification', player, 'warning', 'Uwaga!', "Ktoś próbował zalogować się na to konto!")
                kickPlayer(client, "To konto jest obecnie używane.")
                return
            end
        end

        setElementData(client, 'accountID', tonumber(row[1]["id"]))
        setElementData(client, 'username', username)
        setElementData(client, 'admin_level', tonumber(row[1]["admin_level"]) or 0)
        setElementData(client, 'support_level', tonumber(row[1]["support_level"]) or 0)
        setElementData(client, 'vct_level', tonumber(row[1]["vct_level"]) or 0)
        setElementDimension(client, tonumber(row[1]["id"]))

        -- sprawdź czy konto posiada postacie, jeśli tak to wczytaj
        local characters = mysql:query("SELECT * FROM `characters` WHERE `account` = ?", row[1]["id"])
        if not characters[1] then
            triggerClientEvent(client, "accounts:client", client, 'error', "Nie posiadasz żadnych postaci, stwórz je na UCP.")
            return
        end

        triggerClientEvent(client, "accounts:characterSelection", client, characters)
    else
        triggerClientEvent(client, "accounts:client", client, 'error', "Wprowadzone dane są nieprawidłowe.")
    end
end
