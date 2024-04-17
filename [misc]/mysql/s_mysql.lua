function execute(query, ...)
    local handlePreparedString = dbPrepareString(DBConnection, query, ...)
    local execResult = dbExec(DBConnection, handlePreparedString)
    if not execResult then
        outputDebugString("Błąd wykonania zapytania: " .. dbError())
        return nil
    end

    return true
end

function query(query, ...)
    local handlePreparedString = dbPrepareString(DBConnection, query, ...)
    local queryHandle = dbQuery(DBConnection, handlePreparedString)
    if not queryHandle then
        outputDebugString("Błąd zapytania: " .. dbError())
        return nil
    end

    local result, affectedRows, lastInsertedID = dbPoll(queryHandle, -1)
    return result, affectedRows, lastInsertedID
end