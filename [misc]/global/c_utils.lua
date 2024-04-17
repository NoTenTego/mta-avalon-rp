bindKey("w", "down", function()
    setPedControlState("walk", true)
end)

function disableTargetMarkers()
    setPedTargetingMarkerEnabled(false)
end
addEventHandler("onClientResourceStart", resourceRoot, disableTargetMarkers)

addEvent('global:playSound', true)
addEventHandler('global:playSound', root, function(soundName, volume)
    local sound = playSound(":assets/sounds/" .. soundName)
    setSoundVolume(sound, volume)
end)

addEvent('global:playSound3D', true)
addEventHandler('global:playSound3D', root, function(soundName, volume, position, looped, distance)
    local sound = playSound3D(":assets/sounds/" .. soundName, position[1], position[2], position[3], looped)
    setSoundVolume(sound, volume)
    setSoundMaxDistance(sound, distance)
end)

bindKey('m', 'down', function()
    showCursor(not isCursorShowing())
end)
