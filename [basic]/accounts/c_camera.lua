-- Inicjalizacja stanu kamery
local cameraState = {
    moving = false,
    startTick = 0,
    animationTime = 0,
    startPos = {{}, {}},
    endPos = {{}, {}}
}

-- Funkcja usuwająca obsługę kamery
local function removeCameraHandler()
    if cameraState.moving then
        cameraState.moving = false
    end
end

-- Funkcja renderująca kamerę
local function renderCamera()
    local now = getTickCount()
    
    if cameraState.moving then
        local progress = (now - cameraState.startTick) / cameraState.animationTime
        
        local x1, y1, z1 = interpolateBetween(cameraState.startPos[1][1], cameraState.startPos[1][2], cameraState.startPos[1][3],
            cameraState.endPos[1][1], cameraState.endPos[1][2], cameraState.endPos[1][3], progress, "InOutQuad")
        
        local x2, y2, z2 = interpolateBetween(cameraState.startPos[2][1], cameraState.startPos[2][2], cameraState.startPos[2][3],
            cameraState.endPos[2][1], cameraState.endPos[2][2], cameraState.endPos[2][3], progress, "InOutQuad")
        
        setCameraMatrix(x1, y1, z1, x2, y2, z2)
    else
        removeEventHandler("onClientRender", root, renderCamera)
    end
end

-- Funkcja do płynnego przemieszczania kamery
function smoothMoveCamera(x1, y1, z1, x1t, y1t, z1t, x2, y2, z2, x2t, y2t, z2t, time)
    if cameraState.moving then
        if isTimer(timer1) then
            killTimer(timer1)
        end
        removeEventHandler("onClientRender", root, renderCamera)
    end
    
    cameraState.moving = true
    timer1 = setTimer(removeCameraHandler, time, 1)
    cameraState.startTick = getTickCount()
    cameraState.animationTime = time
    cameraState.startPos[1] = {x1, y1, z1}
    cameraState.startPos[2] = {x1t, y1t, z1t}
    cameraState.endPos[1] = {x2, y2, z2}
    cameraState.endPos[2] = {x2t, y2t, z2t}
    
    addEventHandler("onClientRender", root, renderCamera)
    
    return true
end
