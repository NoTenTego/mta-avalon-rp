local screenWidth, screenHeight = guiGetScreenSize()
browser = createBrowser(screenWidth, screenHeight, true, true)
local chatState = true

function webBrowserRender()
    if not getElementData(localPlayer, "loggedIn") == true then
        return
    end

    if isChatVisible() then
        showChat(false)
    end

    if not chatState then
        return
    end

    dxDrawImage(0, 0, screenWidth, screenHeight, browser, 0, 0, 0, tocolor(255, 255, 255, 255))
end

addCommandHandler('togglechat', function()
    cancelEvent()

    chatState = not chatState
end)

addEventHandler("onClientBrowserCreated", browser, function()
    loadBrowserURL(browser, "http://mta/cef/build/index.html#/chatooc")

    addEventHandler("onClientBrowserDocumentReady", root, function(url)
        if url == "http://mta/cef/build/index.html#/chatooc" then
            addEventHandler("onClientRender", root, webBrowserRender)

            settingsRefresh = setTimer(function()
                local mtaChatSettings = toJSON(getChatboxLayout())

                executeBrowserJavascript(browser, "clientData('config', 'config', '" .. mtaChatSettings .. "');")
            end, 1000, 0)

            addEventHandler("onClientKey", root, function(button)
                if not isElement(browser) then
                    return
                end

                if button == "mouse_wheel_down" then
                    injectBrowserMouseWheel(browser, -40, 0)
                elseif button == "mouse_wheel_up" then
                    injectBrowserMouseWheel(browser, 40, 0)
                end
            end)

            addEventHandler("onClientCursorMove", root, function(relativeX, relativeY, absoluteX, absoluteY)
                if not isElement(browser) then
                    return
                end

                injectBrowserMouseMove(browser, absoluteX, absoluteY)
            end)

            addEventHandler("onClientClick", root, function(button, state)
                if not isElement(browser) then
                    return
                end

                if state == "down" then
                    injectBrowserMouseDown(browser, button)
                else
                    injectBrowserMouseUp(browser, button)
                end
            end)

            addEventHandler("onClientKey", root, function(button, press)
                if not isElement(browser) then
                    return
                end

                if not press then
                    if button == 't' then
                        if isBrowserFocused(browser) then
                            return
                        end

                        focusBrowser(browser)
                        showCursor(true)
                        guiSetInputMode("no_binds")

                        executeBrowserJavascript(browser, "clientData('config', 'inputActive', '" .. toJSON(true) .. "');")
                    end
                end

                if press then
                    if button == 'escape' then
                        if not isBrowserFocused(browser) then
                            return
                        end

                        cancelEvent()
                        showCursor(false)
                        focusBrowser(nil)
                        guiSetInputMode("allow_binds")

                        executeBrowserJavascript(browser, "clientData('config', 'inputActive', '" .. toJSON(false) .. "');")
                    end
                end
            end)
        end
    end)
end)

addEvent('sendChatOOCMessage', true)
addEventHandler('sendChatOOCMessage', root, function(data)
    if not isElement(browser) then
        return
    end

    local message = toJSON(data)

    executeBrowserJavascript(browser, "clientData('ooc', 'message', '" .. base64Encode(message) .. "');")
end)

addCommandHandler('clearooc', function()
    executeBrowserJavascript(browser, "clientData('ooc', 'deleteMessages');")
end)

addEvent('sendChatICMessage', true)
addEventHandler('sendChatICMessage', root, function(message, additional)
    if not isElement(browser) then
        return
    end

    local message = toJSON({
        message = message,
        additional = additional or {}
    })

    executeBrowserJavascript(browser, "clientData('ic', 'message', '" .. base64Encode(message) .. "');")
end)

addCommandHandler('clearchat', function()
    executeBrowserJavascript(browser, "clientData('ic', 'deleteMessages');")
end)

addCommandHandler('toggleooc', function()
    executeBrowserJavascript(browser, "clientData('config', 'oocActive');")
end)
