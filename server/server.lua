QBCore = exports['qb-core']:GetCoreObject()
TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)


--Event to Remove Money from player upon failed attempt at theoritical test
RegisterServerEvent('qb-dmv:theorypaymentfailed')
AddEventHandler('qb-dmv:theorypaymentfailed', function()
    local amount = Config.Amount['theoretical']/2
	local _source = source
	local Player = QBCore.Functions.GetPlayer(_source)
    Player.Functions.RemoveMoney(Config.PaymentType, amount)
    TriggerClientEvent('QBCore:Notify', "You paid $"..amount.."","success")
    TriggerClientEvent('QBCore:Notify', "You failed the test. Please try again!", "error")
end)

--Event to Remove Money and Add Item upon successful attempt at theoritical test
RegisterServerEvent('qb-dmv:theorypaymentpassed')
AddEventHandler('qb-dmv:theorypaymentpassed', function()
	local _source = source
	local Player = QBCore.Functions.GetPlayer(_source)
    local license = true
    local info = {}
    if Config.DriversTest then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
        info.type = "Drivers Permit"
        Player.Functions.RemoveMoney(Config.PaymentType, Config.Amount['theoretical'])
        Player.Functions.AddItem('permit', 1, nil, info)
        TriggerClientEvent('QBCore:Notify', "You paid $"..Config.Amount['theoretical'].."", "success")
        TriggerClientEvent('QBCore:Notify', "You passed and got your Permit", "success")
    elseif Config.DriversTest == false then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
        info.type = "Class C Driver License"
        Player.Functions.RemoveMoney(Config.PaymentType, Config.Amount['driving'])
        Player.Functions.AddItem('driver_license', 1, nil, info)
        TriggerClientEvent('QBCore:Notify', "You paid $"..Config.Amount['driving'].."","success")
        TriggerClientEvent('QBCore:Notify', "You passed and got your Drivers License", "success")
    end
end)

RegisterServerEvent('qb-dmv:driverpaymentpassed')
AddEventHandler('qb-dmv:driverpaymentpassed', function ()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local info = {}
    if Config.DriversTest then
        info.citizenid = Player.PlayerData.citizenid
        info.firstname = Player.PlayerData.charinfo.firstname
        info.lastname = Player.PlayerData.charinfo.lastname
        info.birthdate = Player.PlayerData.charinfo.birthdate
        info.gender = Player.PlayerData.charinfo.gender
        info.nationality = Player.PlayerData.charinfo.nationality
        Player.Functions.RemoveMoney(Config.PaymentType, Config.Amount['driving'])
        Player.Functions.AddItem('driver_license', 1, nil, info)
        TriggerClientEvent('QBCore:Notify', "You paid $"..Config.Amount['driving'].."","success")
        TriggerClientEvent('QBCore:Notify', "You passed the Drivers Test and got your Drivers License", "success")
    end
end)

RegisterServerEvent('qb-dmv:driverpaymentfailed')
AddEventHandler('qb-dmv:driverpaymentfailed', function ()
    local amount = Config.Amount['driving']/2
    local _source = source
    local Player = QBCore.Functions.GetPlayer(_source)
    Player.Functions.RemoveMoney(Config.PaymentType, amount)
    QBCore.Functions.Notify("You paid $"..amount.."","success")
    --TriggerClientEvent('QBCore:Notify', "You failed the Drivers Test. Please Try Again", "error")
end)

QBCore.Functions.CreateCallback('qb-dmv:server:menu', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local hasItem = Player.Functions.GetItemByName('permit')
    if hasItem ~= nil and Player.Functions.GetItemByName('permit').amount >= 1 then
        cb(false)
    else
        cb(true)
    end
end)

QBCore.Functions.CreateCallback('qb-dmv:server:menu2', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local hasItem = Player.Functions.GetItemByName('permit')
    local hasItem2 = Player.Functions.GetItemByName('driver_license')
    if hasItem2 ~= nil and Player.Functions.GetItemByName('driver_license').amount >= 1 then
        cb(false)
    elseif hasItem ~= nil and Player.Functions.GetItemByName('permit').amount >= 1 then
        cb(true)
    end
end)
