QBCore = exports['qb-core']:GetCoreObject()

--Event to Remove Money from player upon failed attempt at theoritical test
RegisterNetEvent('qb-dmv:theorypaymentfailed', function()
    local amount = Config.Amount['theoretical']/2
	local _source = source
	local Player = QBCore.Functions.GetPlayer(_source)
    Player.Functions.RemoveMoney(Config.PaymentType, amount)
    TriggerClientEvent('QBCore:Notify', "You paid $"..amount.."","success")
    TriggerClientEvent('QBCore:Notify', "You failed the test. Please try again!", "error")
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
            TriggerClientEvent('QBCore:Notify', "You passed and got your Permit", "success")
            TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items['permit'], 'add')
        else
            TriggerClientEvent('QBCore:Notify', "You passed the test. Go to City to get your Permit")
        end
        TriggerClientEvent('QBCore:Notify', "You paid $"..Config.Amount['theoretical'], "success")
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
            TriggerClientEvent('QBCore:Notify', "You passed and got your Drivers License", "success")
            TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items['driver_license'], 'add')
        else
            TriggerClientEvent('QBCore:Notify', "You passed! Go to City Hall and get your Drivers License")
        end
        TriggerClientEvent('QBCore:Notify', "You paid $"..Config.Amount['driving'],"success")
        
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
            TriggerClientEvent('QBCore:Notify', "You passed the Drivers Test and got your Drivers License", "success")
            TriggerClientEvent('inventory:client:ItemBox', _source, QBCore.Shared.Items['driver_license'], 'add')
        else
            TriggerClientEvent('QBCore:Notify', "You passed the Drivers Test. Go to City Hall to get your License")
        end
        TriggerClientEvent('QBCore:Notify', "You paid $"..Config.Amount['driving'],"success")
    end
end)

RegisterNetEvent('qb-dmv:driverpaymentfailed', function ()
    local amount = Config.Amount['driving']/2
    local _source = source
    local Player = QBCore.Functions.GetPlayer(_source)
    Player.Functions.RemoveMoney(Config.PaymentType, amount)
    QBCore.Functions.Notify("You paid $"..amount.."","success")
end)

QBCore.Functions.CreateCallback('qb-dmv:server:menu', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local licenseTable = Player.PlayerData.metadata['licences']
    if licenseTable['permit'] == true then
        cb(false)
    else
        cb(true)
    end
end)

QBCore.Functions.CreateCallback('qb-dmv:server:menu2', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local licenseTable = Player.PlayerData.metadata['licences']
    if licenseTable['driver'] then
        cb(false)
    elseif licenseTable['permit'] and licenseTable['driver'] == false then
        cb(true)
    end
end)

