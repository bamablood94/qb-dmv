QBCore = exports['qb-core']:GetCoreObject()

--Event to Remove Money from player upon failed attempt at theoritical test
RegisterNetEvent('qb-dmv:theorypaymentfailed', function()
    local amount = Config.Amount['theoretical']/2
	local _source = source
	local Player = QBCore.Functions.GetPlayer(_source)
    Player.Functions.RemoveMoney(Config.PaymentType, amount)
    TriggerClientEvent('qb-dmv:Notify', source, 'You paid $'..amount, 3000, 'error', 'Paid')
    TriggerClientEvent('qb-dmv:Notify', source, 'You failed the test. Please try again!', 3000, 'error', 'Failed')

end)

--Event to Remove Money and Add Item upon successful attempt at theoritical test
RegisterNetEvent('qb-dmv:theorypaymentpassed', function()
	local _source = source
	local Player = QBCore.Functions.GetPlayer(_source)
    local license = true
    local info = {}
    if Config.DriversTest then
        local info = {}
        local _source = source
        local Player = QBCore.Functions.GetPlayer(_source)
        local licenseTable = Player.PlayerData.metadata['licences']
        info.type = "Drivers Permit"
        licenseTable['permit'] = true
        Player.Functions.SetMetaData('licences', licenseTable)
        Player.Functions.RemoveMoney(Config.PaymentType, Config.Amount['theoretical'])
        if Config.GiveItem then
            Player.Functions.AddItem('permit', 1, nil, info)
            TriggerClientEvent('qb-dmv:Notify', source, 'You passed and got your permit. Congradulations!', 3000, 'success', 'Passed')
            TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items['permit'], 'add')
        else
            TriggerClientEvent('qb-dmv:Notify', source, 'You passed the test. Go to city hall to get your permit. Congradulations!', 3000, 'success', 'Passed')
        end
        TriggerClientEvent('qb-dmv:Notify', source, 'You paid $'..Config.Amount['theoretical'], 3000, 'success', 'Paid')
    elseif Config.DriversTest == false then
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.type = "Class C Driver License"
        local licenseTable = Player.PlayerData.metadata['licences']
        licenseTable['driver'] = true
        Player.Functions.SetMetaData('licences', licenseTable)
        Player.Functions.RemoveMoney(Config.PaymentType, Config.Amount['driving'])
        if Config.GiveItem then
            Player.Functions.AddItem('driver_license', 1, nil, info)
            TriggerClientEvent('qb-dmv:Notify',source, 'You passed and got your drivers license. Congradulations!', 3000, 'success', 'Passed')
            TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items['driver_license'], 'add')
        else
            TriggerClientEvent('qb-dmv:Notify', source, 'You passed! Got to city hall and get your drivers license.', 3000, 'success', 'Passed')
        end
        TriggerClientEvent('qb-dmv:Notify', source, 'You paid $ '..Config.Amount['driving'], 3000, 'info', 'Paid')
    end
end)

RegisterNetEvent('qb-dmv:driverpaymentpassed', function ()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = {}
    if Config.DriversTest then
        local info = {}
        local _source = source
        local Player = QBCore.Functions.GetPlayer(_source)
        local licenseTable = Player.PlayerData.metadata['licences']
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
        licenseTable['driver'] = true
        Player.Functions.SetMetaData('licences', licenseTable)
        Player.Functions.RemoveMoney(Config.PaymentType, Config.Amount['driving'])
        if Config.GiveItem == true then
            Player.Functions.AddItem('driver_license', 1, nil, info)
            TriggerClientEvent('qb-dmv:Notify', source, 'You passed the drivers test and got your drivers licens. Congradulations!', 3000, 'success', 'Passed')
            TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items['driver_license'], 'add')
        else
            TriggerClientEvent('qb-dmv:Notify', source, 'You passed the Drivers Test. Go to City Hall to get your license.', 3000, 'success', 'Passed')
        end
        TriggerClientEvent('qb-dmv:Notify', source, 'You paid $'..Config.Amount['driving'], 3000, 'success', 'Paid')
    end
end)

RegisterNetEvent('qb-dmv:driverpaymentfailed', function ()
    local amount = Config.Amount['driving']/2
    local _source = source
    local Player = QBCore.Functions.GetPlayer(_source)
    Player.Functions.RemoveMoney(Config.PaymentType, amount)
    TriggerClientEvent('qb-dmv:Notify', source, 'You paid $'..amount, 3000, 'error', 'Paid')
end)

QBCore.Functions.CreateCallback('qb-dmv:server:permitdata', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local licenseTable = Player.PlayerData.metadata['licences']
    if licenseTable['permit'] == true then
        cb(false)
    else
        cb(true)
    end
end)

QBCore.Functions.CreateCallback('qb-dmv:server:licensedata', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local licenseTable = Player.PlayerData.metadata['licences']
    if licenseTable['driver'] then
        cb(false)
    elseif licenseTable['permit'] and licenseTable['driver'] == false then
        cb(true)
    end
end)


-------- THIS IS A TEST FOR ADDING PERMIT AND LICENSE TO DATABASE FOR EXISTING PLAYERS
RegisterNetEvent('qb-dmv:server:updatemetadata', function ()
    local src = source
    local PlayerData = QBCore.Players[source].PlayerData
    MySQL.Async.insert('INSERT INTO players (metadata) VALUES (:metadata) ON DUPLICATE KEY UPDATE metadata = :metadata', {
        metadata = 'permit = false'
    })
end)




RegisterNetEvent('qb-cityhall:server:banPlayer', function()
    local src = source
    TriggerClientEvent('chatMessage', -1, "QB Anti-Cheat", "error", GetPlayerName(src).." has been banned for sending POST Request's ")
    MySQL.Async.insert('INSERT INTO bans (name, license, discord, ip, reason, expire, bannedby) VALUES (?, ?, ?, ?, ?, ?, ?)', {
        GetPlayerName(src),
        QBCore.Functions.GetIdentifier(src, 'license'),
        QBCore.Functions.GetIdentifier(src, 'discord'),
        QBCore.Functions.GetIdentifier(src, 'ip'),
        'Abuse localhost:13172 For POST Requests',
        2145913200,
        GetPlayerName(src)
    })
    DropPlayer(src, 'Attempting To Exploit')
end)
