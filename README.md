# UNDER COMPLETE RECONSTRUCTION!





# ESX DMVSchool Converted to QBCore.

## Driving School MLO
https://forum.cfx.re/t/mlo-driving-school-interior/1466079
### DISCLAIMER: This is not my MLO. I just found it on cfx forums and used it as the basis for this script

# Installation

## QB-Core Script:

## Insert Item into QBCore/Shared/Items.lua:
```
['permit']						 = {['name'] = 'permit',						['label'] = 'Driving Permit',			['weight'] = 0,			['type'] = 'item',		['image'] = 'id_card.png',				['unique'] = true,['useable'] = true,		['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'A Driving permit to show you can drive a vehicle as long as you have a passenger'},
['cdl_license']					 = {['name'] = 'cdl_license',					['label'] = 'CDL License',				['weight'] = 0,			['type'] = 'item',		['image'] = 'driver_license.png',		['unique'] = true,		['useable'] = true,		['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'Permit to show you can drive a Commercial Vehicle.'},
['bike_license']				 = {['name'] = 'bike_license',					['label'] = 'Bike License',				['weight'] = 0,			['type'] = 'item',		['image'] = 'driver_license.png',		['unique'] = true,		['useable'] = true,		['shouldClose'] = false,	['combinable'] = nil,	['description'] = 'Permit to show you can drive a Motorcycle/ATV'},
```

## Open qb-core/server/players.lua and find:
```
PlayerData.metadata['licences'] = PlayerData.metadata['licences'] or {
    ['driver'] = true,
    ['business'] = false,
    ['weapon'] = false,
}
```
Replace With:
```
PlayerData.metadata['licences'] = PlayerData.metadata['licences'] or {
    ['permit'] = false,
    ['driver'] = false,
    ['cdl'] = false,
    ['bike'] = false,
    ['business'] = false,
    ['weapon'] = false
}
```

## Open qb-core/shared/main.lua
Find ```QBShared.StarterItems``` and remove the driver license line

## QB-Cityhall Script:

### Open qb-cityhall/config.lua
Replace This:
```
Config.Cityhalls = {
    { -- Cityhall 1
        coords = vec3(-265.0, -963.6, 31.2),
        showBlip = true,
        blipData = {
            sprite = 487,
            display = 4,
            scale = 0.65,
            colour = 0,
            title = "City Services"
        },
        licenses = {
            ["id_card"] = {
                label = "ID Card",
                cost = 50,
            },
            ["driver_license"] = {
                label = "Driver License",
                cost = 50,
                metadata = "driver"
            },
            ["weaponlicense"] = {
                label = "Weapon License",
                cost = 50,
                metadata = "weapon"
            }
        }
    },
}
```
WITH THIS:
```
Config.Cityhalls = {
    { -- Cityhall 1
        coords = vec3(-265.0, -963.6, 31.2),
        showBlip = true,
        blipData = {
            sprite = 487,
            display = 4,
            scale = 0.65,
            colour = 0,
            title = "City Services"
        },
        licenses = {
            ["id_card"] = {
                label = "ID Card",
                cost = 50,
            },
            ["permit"] = {
                label = 'Permit',
                cost = 25,
                metadata = 'permit',
            },
            ["cdl"] = {
                label = 'CDL',
                cost = 75,
                metadata = 'cdl',
            },
            ["bike"] = {
                label = 'Bike License',
                cost = 50,
                metadata = 'bike',
            },
            ["driver_license"] = {
                label = "Driver License",
                cost = 50,
                metadata = "driver"
            },
            ["weaponlicense"] = {
                label = "Weapon License",
                cost = 50,
                metadata = "weapon"
            },
        }
    },
}
```

### Open qb-cityhall/server/main.lua
Replace This:
```
RegisterNetEvent('qb-cityhall:server:requestId', function(item, hall)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local itemInfo = Config.Cityhalls[hall].licenses[item]
    if not Player.Functions.RemoveMoney("cash", itemInfo.cost) then return TriggerClientEvent('QBCore:Notify', src, ('You don\'t have enough money on you, you need %s cash'):format(itemInfo.cost), 'error') end
    local info = {}
    if item == "id_card" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
    elseif item == "driver_license" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = "Class C Driver License"
    elseif item == "weaponlicense" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
    else
        return DropPlayer(src, 'Attempted exploit abuse')
    end
    if not Player.Functions.AddItem(item, 1, nil, info) then return end
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
end)
```
WITH THIS:
```
RegisterNetEvent('qb-cityhall:server:requestId', function(item, hall)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    local itemInfo = Config.Cityhalls[hall].licenses[item]
    if not Player.Functions.RemoveMoney("cash", itemInfo.cost) then return TriggerClientEvent('QBCore:Notify', src, ('You don\'t have enough money on you, you need %s cash'):format(itemInfo.cost), 'error') end
    local info = {}
    if item == "id_card" then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
    elseif item == "driver_license" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = "Class C Driver License"
    elseif item == "weaponlicense" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
    elseif item == "permit" then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
    else
        return DropPlayer(src, 'Attempted exploit abuse')
    end
    if not Player.Functions.AddItem(item, 1, nil, info) then return end
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
end)
```

# New Details
Different Routes for each type of test.

# Planned Details

Make it so players must be in starting vehicle to complete the drivers test

# Contact Me

If you have any questions or any problems please don't hesitate to message me Bama94#1994.
If you have any fixes for something, just put in a PR Request if you have any issues, your more than welcome to put in a ticket issue here, but It's less likely for me to respond
