local temporaryIDs = {}

function assignTemporaryID(player)
    for slot = 1, 5000 do
        if not temporaryIDs[slot] then
            temporaryIDs[slot] = player
            setElementData(player, "playerID", slot)
            break
        end
    end
end

function removeTemporaryID(player)
    local slot = getElementData(player, "playerID")

    if slot then
        temporaryIDs[slot] = nil
    end
end

addEventHandler("onPlayerJoin", getRootElement(), function()
    assignTemporaryID(source)
end)

addEventHandler("onPlayerQuit", getRootElement(), function()
    removeTemporaryID(source)
end)

addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), function()
    for i = 1, #temporaryIDs do
        temporaryIDs[i] = nil
    end

    for _, player in ipairs(getElementsByType("player")) do
        assignTemporaryID(player)
    end
end)