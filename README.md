# ESX DMVSchool Converted to QBCore.
Players Can Take a Theoritical test and get their Permit, they can then take 1 Driving Test each for: Personal Vehicles, Bikes/Motorcycles, and CDL License. Depending on how you want to set it up you can make it so when the player takes the Motorcycle Test it just adds an endorsement to the players Drivers License or you can give the player a Bike License to carry around. Each Type of driving test can have a unique route along with multiple locations for a DMV Ped.

<br />

# Driving School MLO
https://forum.cfx.re/t/mlo-driving-school-interior/1466079

**DISCLAIMER: This is not my MLO. I just found it on cfx forums and used it as the basis for this script**

<br />

# Installation:
<br />

## QB-CORE
<br />

> ## QB-Core/Shared/Items.lua:
```
['permit']						 = {['name'] = 'permit',						['label'] = 'Driving Permit',			['weight'] = 0,			['type'] = 'item',		['image'] = 'id_card.png',				['unique'] = true,['useable'] = true,		['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'A Driving permit to show you can drive a vehicle as long as you have a passenger'},
['cdl_license']					 = {['name'] = 'cdl_license',					['label'] = 'CDL License',				['weight'] = 0,			['type'] = 'item',		['image'] = 'driver_license.png',		['unique'] = true,		['useable'] = true,		['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'Permit to show you can drive a Commercial Vehicle.'},
['bike_license']				 = {['name'] = 'bike_license',					['label'] = 'Bike License',				['weight'] = 0,			['type'] = 'item',		['image'] = 'driver_license.png',		['unique'] = true,		['useable'] = true,		['shouldClose'] = false,	['combinable'] = nil,	['description'] = 'Permit to show you can drive a Motorcycle/ATV'},
```

<br />

> ## QB-Core/Server/Players.lua
**FIND:**
```
PlayerData.metadata['licences'] = PlayerData.metadata['licences'] or {
    ['driver'] = true,
    ['business'] = false,
    ['weapon'] = false,
}
```
**AND REPLACE WITH:**
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
<br />

## QB-CITYHALL
<br />

> ## QB-Cityhall/server/main.lua
**FIND:**
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
        return false -- DropPlayer(src, 'Attempted exploit abuse')
    end
    if not Player.Functions.AddItem(item, 1, nil, info) then return end
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
end)
```
**AND REPLACE WITH:**
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
        info.type = "Class R Driver License"
        if Player.PlayerData.metadata['licences']['bike'] then
            info.endorsement = 'Motorcycle Endorsement'
        else
            info.endorsement = 'None'
        end
    elseif item == 'cdl_license' then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = "Class A Driver License"
    elseif item == 'bike_license' then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
    elseif item == 'permit' then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = "Class R Driver License"
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

> ## QB-Cityhall/config.lua
**FIND:**
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
        }
    },
}
```
**AND REPLACE WITH:**
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

<br />

## Inventory
If you use `qb-inventory` or `lj-inventory` go to your-inventory/html/js/app.js and find **`FormatItemInfo`** and add the following:
```
else if (itemData.name == "cdl_license") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>First Name: </strong><span>" +
                itemData.info.firstname +
                "</span></p><p><strong>Last Name: </strong><span>" +
                itemData.info.lastname +
                "</span></p><p><strong>Birth Date: </strong><span>" +
                itemData.info.birthdate +
                "</span></p><p><strong>Licenses: </strong><span>" +
                itemData.info.type +
                "</span></p>"
            );
        } else if (itemData.name == "permit") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>First Name: </strong><span>" +
                itemData.info.firstname +
                "</span></p><p><strong>Last Name: </strong><span>" +
                itemData.info.lastname +
                "</span></p><p><strong>Birth Date: </strong><span>" +
                itemData.info.birthdate +
                "</span></p>"
            );
        } else if (itemData.name == "bike_license") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>First Name: </strong><span>" +
                itemData.info.firstname +
                "</span></p><p><strong>Last Name: </strong><span>" +
                itemData.info.lastname +
                "</span></p><p><strong>Birth Date: </strong><span>" +
                itemData.info.birthdate +
                "</span></p>"
            );
        }
```
If you don't want the bike license and instead want a `Motorcycle Endorsemeonet` on your Driver License then replace the `driver_license` line with this one:
```
else if (itemData.name == "driver_license") {
            $(".item-info-title").html("<p>" + itemData.label + "</p>");
            $(".item-info-description").html(
                "<p><strong>First Name: </strong><span>" +
                itemData.info.firstname +
                "</span></p><p><strong>Last Name: </strong><span>" +
                itemData.info.lastname +
                "</span></p><p><strong>Birth Date: </strong><span>" +
                itemData.info.birthdate +
                "</span></p><p><strong>Licenses: </strong><span>" +
                itemData.info.type +
                "<p><strong>Endorsements: </strong><span>" +
                itemData.info.endorsement +
                "</span></p>"

            );
        }
```

> ## Qb-Cityhall/server/main.lua
Find the GiveItem Command and add:
```
elseif itemData["name"] == "permit" then
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
				elseif itemData["name"] == "cdl_license" then
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
				elseif itemData["name"] == "bike_license" then
					info.firstname = Player.PlayerData.charinfo.firstname
					info.lastname = Player.PlayerData.charinfo.lastname
					info.birthdate = Player.PlayerData.charinfo.birthdate
```

<br />

If you want the endorsement for the drivers license then remove the bike_license line and instead add the following to the drivers license line:
```
if Player.PlayerData.metadata['licences']['bike'] then
						info.endorsement = 'Motorcycle Endorsement'
					else
						info.endorsement = 'None'
					end
```

<br />


That should be all for the installation. Now just start the server up and enjoy!
# New Details

- [x] Different Routes for each type of test.

# Planned Details

- [ ] Make it so players must be in starting vehicle to complete the drivers test

# Contact Me

If you have any questions or any problems please don't hesitate to message me Bama94#1994.
If you have any fixes for something, just put in a PR Request if you have any issues, your more than welcome to put in a ticket issue here, but It's less likely for me to respond
