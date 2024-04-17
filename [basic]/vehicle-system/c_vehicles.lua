function getVehicleHandlingProperty(element, property)
    if isElement(element) and getElementType(element) == "vehicle" and type(property) == "string" then
        local handlingTable = getVehicleHandling(element)
        local value = handlingTable[property]

        if value then
            return value
        end
    end

    return false
end

local function calculateDistance(vehicle)
    if not getElementData(vehicle, 'data') then
        return
    end

    local odometerData = getElementData(vehicle, 'odometerData')
    if not odometerData then
        local x, y, z = getElementPosition(vehicle)
        setElementData(vehicle, 'odometerData', {
            x = x,
            y = y,
            z = z,
            value = 0
        })
        return
    end

    if odometerData.value >= 10 then
        odometerData.value = 0
        setElementData(vehicle, 'odometerData', odometerData)

        local vehicleData = getElementData(vehicle, 'data')
        local fuelConsumptionRate = 0.01
        local engineAcceleration = getVehicleHandlingProperty(vehicle, 'engineAcceleration')
        local maxVelocity = getVehicleHandlingProperty(vehicle, 'maxVelocity')

        vehicleData.odometer = vehicleData.odometer + 1
        vehicleData.fuel = vehicleData.fuel - fuelConsumptionRate * (maxVelocity / engineAcceleration)

        setElementData(vehicle, 'data', vehicleData)
        return
    end

    local x, y, z = getElementPosition(vehicle)
    local distanceTraveled = getDistanceBetweenPoints3D(x, y, z, odometerData.x, odometerData.y, odometerData.z)

    if distanceTraveled > 20 then
        setElementData(vehicle, 'odometerData', {
            x = x,
            y = y,
            z = z,
            value = odometerData.value + 1
        })
    end
end

addEventHandler('onClientRender', root, function()
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if not vehicle then
        return
    end

    local seat = getPedOccupiedVehicleSeat(localPlayer)
    if seat ~= 0 then
        return
    end

    calculateDistance(vehicle)
end)
