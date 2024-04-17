local permissions = {
    ['superman'] = {
        ['fly'] = {
            ['admin_level'] = 1
        }
    },
    ['freecam'] = {
        ['activate'] = {
            ['admin_level'] = 1,
            ['support_level'] = 1
        }
    },

    ['weather-system'] = {
        ['sw'] = {
            ['admin_level'] = 1,
            ['support_level'] = 1
        }
    },

    ['interior-system'] = {
        ['addint'] = {
            ['admin_level'] = 3
        },
        ['delint'] = {
            ['admin_level'] = 3
        },
        ['renameint'] = {
            ['admin_level'] = 3
        },
        ['gotoint'] = {
            ['admin_level'] = 1,
            ['support_level'] = 1
        },
        ['setinttype'] = {
            ['admin_level'] = 3
        },
        ['setintowner'] = {
            ['admin_level'] = 3
        },
        ['setintprice'] = {
            ['admin_level'] = 3
        },
        ['setintid'] = {
            ['admin_level'] = 3
        }
    },

    ['item-system'] = {
        ['giveitem'] = {
            ['admin_level'] = 3
        }
    },

    ['admin-system'] = {
        ['adminduty'] = {
            ['admin_level'] = 1,
            ['support_level'] = 1
        },
        ['heal'] = {
            ['admin_level'] = 1,
            ['support_level'] = 1
        },
        ['setarmor'] = {
            ['admin_level'] = 1,
            ['support_level'] = 1
        },
        ['givepermission'] = {
            ['admin_level'] = 4
        },
        ['givemoney'] = {
            ['admin_level'] = 3
        },
        ['teleport'] = {
            ['admin_level'] = 1,
            ['support_level'] = 1,
            ['vct_level'] = 1
        },
        ['fixveh'] = {
            ['admin_level'] = 1,
            ['vct_level'] = 1
        },
        ['unflip'] = {
            ['admin_level'] = 1,
            ['vct_level'] = 1
        },
    },

    ['vehicle-system'] = {
        ['vehlib'] = {
            ['admin_level'] = 3,
            ['support_level'] = 1,
            ['vct_level'] = 1
        },
        ['makeVehicle'] = {
            ['admin_level'] = 3,
            ['vct_level'] = 2
        },
        ['editVehicle'] = {
            ['admin_level'] = 3,
            ['vct_level'] = 2
        },
        ['deleteVehicle'] = {
            ['admin_level'] = 3,
            ['vct_level'] = 2
        },
        ['editHandling'] = {
            ['admin_level'] = 3,
            ['vct_level'] = 1
        },
        ['updateHandling'] = {
            ['admin_level'] = 3,
            ['vct_level'] = 1
        },
        ['resetHandling'] = {
            ['admin_level'] = 3,
            ['vct_level'] = 1
        },
        ['saveHandling'] = {
            ['admin_level'] = 3,
            ['vct_level'] = 2
        },
        ['makeveh'] = {
            ['admin_level'] = 3
        },
        ['setodometer'] = {
            ['admin_level'] = 1
        },
        ['delveh'] = {
            ['admin_level'] = 3
        },
        ['setcolor'] = {
            ['admin_level'] = 1
        },
        ['enterveh'] = {
            ['admin_level'] = 1
        }
    },

    ['bw-system'] = {
        ['revive'] = {
            ['admin_level'] = 1,
            ['support_level'] = 1
        }
    },

    ['chat-system'] = {
        ['ekipa'] = {
            ['admin_level'] = 1,
            ['support_level'] = 1,
            ['vct_level'] = 1
        }
    }
}

function hasPermission(thePlayer, resourceName, permission)
    if hasElementData(thePlayer, 'temporaryPermissions') then -- trzeba zablokowac dawanie permisji osobą ktore juz posiadaja taka permisje na aduty
        local temporaryPermissions = getElementData(thePlayer, 'temporaryPermissions')
        local currentTimeStamp = exports.global:getTimestamp()

        for k, value in ipairs(temporaryPermissions) do
            if resourceName == value.resourceName and permission == value.permission then
                if currentTimeStamp >= value.time then
                    table.remove(temporaryPermissions, foundIndex)
                    setElementData(thePlayer, 'temporaryPermissions', temporaryPermissions)
                    triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'warning', 'Permisja wygasła', "Twój czas na używanie tej permisji dobiegł końca.")
                else
                    return true
                end
            end
        end
    end

    if not (thePlayer or resourceName or permission) then
        outputDebugString('Uzupełnij argumenty w funkcji: hasPermission [Gracz] [nazwaZasobu] [permisja] [' .. resourceName .. ' ' .. permission .. ']!')
        return
    end

    if not permissions[resourceName][permission] then
        return
    end

    if not hasElementData(thePlayer, 'adminDuty') then
        return
    end

    local supportLevel = getElementData(thePlayer, 'support_level') or 0
    local adminLevel = getElementData(thePlayer, 'admin_level') or 0
    local vctLevel = getElementData(thePlayer, 'vct_level') or 0

    local permissionData = permissions[resourceName][permission]

    if permissionData['support_level'] and supportLevel >= permissionData['support_level'] then
        return true
    end

    if permissionData['admin_level'] and adminLevel >= permissionData['admin_level'] then
        return true
    end

    if permissionData['vct_level'] and vctLevel >= permissionData['vct_level'] then
        return true
    end

    return
end
