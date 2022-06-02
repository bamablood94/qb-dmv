# ESX DMVSchool Converted to QBCore. With Many new features
We all know the old dmvschool from esx right? Well welcome it to QBCore Framework with a few added details.
 
## If Config.UseNewQB = true
This uses the new QBCore export for DrawText
![This is an image](https://i.imgur.com/7kEKN84.png)
## If Config.UseNewQB = false
This uses a function that has been around to draw a marker for a specific location
![This is an image](https://i.imgur.com/mMYYUlH.png)

## If you use Config.UseTarget the above 2 configs does not matter
![This is an image](https://i.imgur.com/9BqL4oj.png)

## First you will need the MLO for the driving school
You can find the MLO here:
https://forum.cfx.re/t/mlo-driving-school-interior/1466079
### DISCLAIMER: This is not my MLO. I just found it on cfx forums and used it as the basis for this script

# Installation

## QB-Core Script:

## Insert Item into QBCore/Shared/Items.lua:
```
['permit']						 = {['name'] = 'permit',						['label'] = 'Driving Permit',			['weight'] = 0,			['type'] = 'item',		['image'] = 'id_card.png',				['unique'] = true,		['useable'] = true,		['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'A Driving permit to show you can drive a vehicle as long as you have a passenger'},
```

If you want to give players an id_card instead then go into the server.lua and replace any instance of permit to id_card and don't worry about adding the above line.
Update:(you will have to add permit to the players table in the metadata column for exsisting players as it wont auto update. This means this script looks for permit to be true/false in the license portion of the metadata column on which options to give you. So if you pass the theoritical test it changes permit to true in the metadata column, so you can then do the driving test) -- atleast to my knowledge



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
    ['driver'] = false,
    ['business'] = false,
    ['weapon'] = false,
    ['permit'] = false
}
```

## Open qb-core/shared/main.lua
Find ```QBShared.StarterItems``` and remove the driver license line

#### The Above Code is for both NEW and OLD QBCore

## QB-Cityhall Script:
Cityhall Script has been updated. So with this being said, Below will be how to install it both ways. If you open the ```config.lua``` and don't see the below code, then you have the old styl qbcore which means you have to go further down this readme to find the part that you need to do.

I will be starting with the new version of the cityhall script followed by the old version. So if you are running the old version, then scroll on till you see OLD QBCORE.

## NEW QBCORE:

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
            ['permit'] = {
                label = "Permit",
                cost = 50,
                metadata = 'permit'
            }
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
If you are using new QBCore, You are done with installation. At the bottom of this readme is how to contact me for support or any future plans or added details to the script.do
    
end
## OLD QBCORE

### Open qb-cityhall/client/main.lua
Replace this:
```
local idTypes = {
    ["id_card"] = {
        label = "ID Card",
        item = "id_card"
    },
    ["driver_license"] = {
        label = "Drivers License",
        item = "driver_license"
    },
    ["weaponlicense"] = {
        label = "Firearms License",
        item = "weaponlicense"
    }
}
```

With This:

```
local idTypes = {
    ["id_card"] = {
        label = "ID Card",
        item = "id_card"
    },
    ["driver_license"] = {
        label = "Drivers License",
        item = "driver_license"
    },
    ["weaponlicense"] = {
        label = "Firearms License",
        item = "weaponlicense"
    },
    ["permit"] = {
        label = "Drivers Permit",
        item = "permit"
    }
}
```

Then Replace This:

```
RegisterNUICallback('requestLicenses', function(data, cb)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local licensesMeta = PlayerData.metadata["licences"]
    local availableLicenses = {}

    for type,_ in pairs(licensesMeta) do
        if licensesMeta[type] then
            local licenseType = nil
            local label = nil

            if type == "driver" then
                licenseType = "driver_license"
                label = "Drivers Licence"
            elseif type == "weapon" then
                licenseType = "weaponlicense"
                label = "Firearms License"
            end

            availableLicenses[#availableLicenses+1] = {
                idType = licenseType,
                label = label
            }
        end
    end
    cb(availableLicenses)
end)
```

With This:

```
RegisterNUICallback('requestLicenses', function(data, cb)
    local PlayerData = QBCore.Functions.GetPlayerData()
    local licensesMeta = PlayerData.metadata["licences"]
    local availableLicenses = {}

    for type,_ in pairs(licensesMeta) do
        if licensesMeta[type] then
            local licenseType = nil
            local label = nil

            if type == "driver" then
                licenseType = "driver_license"
                label = "Drivers Licence"
            elseif type == "weapon" then
                licenseType = "weaponlicense"
                label = "Firearms License"
            elseif type == "permit" then
                licenseType = "permit"
                label = "Drivers Permit"
            end

            availableLicenses[#availableLicenses+1] = {
                idType = licenseType,
                label = label
            }
        end
    end
    cb(availableLicenses)
end)
```

# New Details

Added Permit to database defaults false. So now qb-dmv won't look to see if they have the item in their inventory rather the database to see if true or false. So they can't spam taking the test.

Fixed the Drivers Test activating upon opening the Menu. Now Drivers Test activates upon clicking Start Drivers Test.

Fixed the players from being able to go back to the dmv menu to start a second driver's test while the original is still going.

Added a config for GiveItem. If false then upon completion of the drivers test then they have to go to City Hall to Buy a license. If true then qb-dmv will give them the item.

Added Permit upon completion of Theoretical test

Vehicle will despawn once MaxErrors(can be edited in config.lua) has been reached

Player will be teleported back to the DMV once MaxErrors has been reached.

Theoritcal Test UI has been updated and looks different.

Added ability to only have to take Theoritcal Test(Config.DriversTest) if it is set to false then players will only have to take Theoritcal test to get a Driver's License. Set to True to make players take driving test to get a drivers license.

Implemented Target and QBCores new export for DrawText

Added a config to use okokNotify or QBCore:Notify

Maybe others that I can't think of at the moment.

# Planned Details

Make it so players must be in starting vehicle to complete the drivers test

# Contact Me

If you have any questions or any problems please don't hesitate to message me or ask on the qbcore discord. We are happy to help.
If you have any fixes for something, just put in a PR Request if you have any issues, your more than welcome to put in a ticket issue here, but It's less likely for me to respond

Bama94#1994

My City Discord: https://discord.gg/Z6pP5Ke2t9

QBCore Discord: https://discord.gg/pKUZvJBxq4

# Credits

ConnorTheDev#5982 - Credit for finding the way to add to the database.(I was unaware of this method)

cambrey1#2143 - Credit for sending me the files to find the reason behind the UI getting stuck on screen after failing test and trying again.
