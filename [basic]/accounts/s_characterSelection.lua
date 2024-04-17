local mysql = exports.mysql

function spawnCharacter(character)
    setCameraTarget(client)
    clearChatBox()
    setElementFrozen(client, false)
    setPlayerNametagShowing(client, false)
    setPlayerName(client, character['charactername'])

    setElementPosition(client, character['x'], character['y'], character['z'])
    setElementRotation(client, 0, 0, character['rotation'])
    setElementInterior(client, character['interior'])
    setElementDimension(client, character['dimension'])
    setElementHealth(client, character['health'])
    setPedArmor(client, character['armor'])
    setElementModel(client, character['skin'])

    setElementData(client, 'money', character['money'])
    setElementData(client, 'charactername', character['charactername'])
    setElementData(client, "id", character['id'])
    setElementData(client, "class", character['class'])
    setElementData(client, "skincolor", character['skincolor'])
    setElementData(client, "gender", character['gender'])
    setElementData(client, "age", character['age'])
    setElementData(client, "weight", character['weight'])
    setElementData(client, "height", character['height'])
    setElementData(client, "description", character['description'])
    setElementData(client, "active", character['active'])
    setElementData(client, "hours", character['hours'])

    setElementData(client, "loggedIn", true)

    -- przedmioty

    local row = mysql:query("SELECT * FROM `items` WHERE `owner` = ?", getElementData(client, 'id'))
    if row[1] then
        items = {}
        for i, item in pairs(row) do
            table.insert(items, {item.name, item.value_1, item.value_2, item.itemID, item.id, item.owner, item.category, item.additional})
        end
        setElementData(client, "items", items)
    end
end
