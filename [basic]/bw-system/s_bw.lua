local damageTypes = {
    [19] = {
        name = "Rocket",
        deathTime = 900
    },
    [37] = {
        name = "Burnt",
        deathTime = 300
    },
    [49] = {
        name = "Rammed",
        deathTime = 600
    },
    [50] = {
        name = "Ranover/Helicopter Blades",
        deathTime = 900
    },
    [51] = {
        name = "Explosion",
        deathTime = 900
    },
    [52] = {
        name = "Driveby",
        deathTime = 600
    },
    [53] = {
        name = "Drowned",
        deathTime = 300
    },
    [54] = {
        name = "Fall",
        deathTime = 300
    },
    [55] = {
        name = "Unknown",
        deathTime = 300
    },
    [56] = {
        name = "Melee",
        deathTime = 300
    },
    [57] = {
        name = "Weapon",
        deathTime = 300
    },
    [59] = {
        name = "Tank Grenade",
        deathTime = 900
    },
    [63] = {
        name = "Blown",
        deathTime = 900
    }
}

addEventHandler("onPlayerStealthKill", root, function()
    cancelEvent(true, "No more stealth kills.")
end)

local bodyParts = {
    [3] = 1.1,
    [4] = 1,
    [5] = 0.7,
    [6] = 0.7,
    [7] = 0.7,
    [8] = 0.7,
    [9] = 2
}

addEventHandler("onPlayerDamage", root, function(attacker, weapon, bodypart, loss)
    local bodyPartScale = bodyParts[bodypart]
    if bodyPartScale then
        loss = loss * bodyPartScale
    end

    local health = getElementHealth(source)

    setElementHealth(source, health - loss)
end)

addEventHandler("onPlayerWasted", root, function(ammo, attacker, weapon, bodypart)
    setCameraTarget(source)

    local deathTime = 180
    local nametag = 'y'
    local gender = getElementData(source, 'gender')
    
    if gender == 1 then
        nametag = 'a'
    end

    if weapon == 0 then
        nametag = 'pobit' .. nametag
    else
        if damageTypes[weapon] then
            deathTime = damageTypes[weapon].deathTime
            nametag = 'rann'..nametag
        else
            nametag = 'postrzelon' .. nametag
            deathTime = 600
        end
    end

    setElementData(source, 'bw', {nametag, deathTime})
    triggerClientEvent(source, 'bw-system:playerDeath', source, true)

    spawnCharacterAfterDeath(source, deathTime)
end)

local deathTimer = {}

function spawnCharacterAfterDeath(thePlayer, deathTime)
    deathTimer[thePlayer] = setTimer(function()
        local bwData = getElementData(thePlayer, 'bw') or false

        if not bwData then
            return killTimer(deathTimer[thePlayer])
        end

        if bwData[2] <= 1 then
            triggerClientEvent(thePlayer, 'bw-system:playerDeath', thePlayer, false)
            removeElementData(thePlayer, 'bw')

            local x, y, z = getElementPosition(thePlayer)
            local _, _, rotation = getElementRotation(thePlayer)
            local skin = getElementModel(thePlayer)
            local interior = getElementInterior(thePlayer)
            local dimension = getElementDimension(thePlayer)

            spawnPlayer(thePlayer, x, y, z, rotation, skin, interior, dimension)
            setElementHealth(thePlayer, 20)
            triggerClientEvent(thePlayer, 'hud:sendNotification', thePlayer, 'info', 'BW', 'Czas BW minął, pamiętaj żeby zregenerować punkty hp.')

            killTimer(deathTimer[thePlayer])
            return
        end

        setElementData(thePlayer, 'bw', {bwData[1], bwData[2] - 1})
    end, 1000, deathTime)
end
