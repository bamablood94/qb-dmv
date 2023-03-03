QBCore = exports['qb-core']:GetCoreObject()
local info = {}

RegisterNetEvent('qb-dmv:server:TheoryTestResult', function (success)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    info.firstname = Player.PlayerData.charinfo.firstname
    info.lastname = Player.PlayerData.charinfo.lastname
    info.birthdate = Player.PlayerData.charinfo.birthdate
    info.type = 'Class R License'

    if not success then
        Player.Functions.RemoveMoney(Config.PaymentType, Config.Amount['theoritical']/2)
        TriggerClientEvent('QBCore:Notify', src, 'You failed the Test. Please Try again.', 'error', 3000)
    else
        if Config.DriversTest then
            Player.PlayerData.metadata['licences']['permit'] = true
            Player.Functions.SetMetaData('licences', Player.PlayerData.metadata['licences'])
            if Config.GiveItem then
                if Player.Functions.AddItem('permit', 1, nil, info) then
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['permit'], 'add')
                    TriggerClientEvent('QBCore:Notify', src, 'Congradulations! You passed the Theoritical Test.', 'success', 3000)
                end
            else
                TriggerClientEvent('QBCore:Notify', src, 'Congradulations! You passed! You must go to City Hall to pick up your permit.', 'success', 4500)
            end
        else
            Player.PlayerData.metadata['licences']['driver'] = true
            Player.PlayerData.metadata['licences']['permit'] = true
            Player.Functions.SetMetaData('licences', Player.PlayerData.metadata['licences'])
            if Config.GiveItem then
                if Player.PlayerData.metadata['licences']['bike'] then
                    info.endorsement = 'Motorcycle Endorsement'
                else
                    info.endorsement = 'None'
                end
                if Player.Functions.AddItem('driver_license', 1, nil, info) then
                    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['driver_license'], 'add')
                    TriggerClientEvent('QBCore:Notify', src, 'You passed and got your License. Congradulations!', 'success', 3000)
                end
            else
                TriggerClientEvent('QBCore:Notify', src, 'You passed! Go to City Hall and get your License.', 'success', 3000)
            end
        end
        Player.Functions.RemoveMoney(Config.PaymentType, Config.Amount['theoritical'])
        TriggerClientEvent('QBCore:Notify', src, 'You paid $'..Config.Amount['theoritical'], 'success', 3000)
    end
end)

RegisterNetEvent('qb-dmv:server:DrivingTestResult', function (success, testType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    info.firstname = Player.PlayerData.charinfo.firstname
    info.lastname = Player.PlayerData.charinfo.lastname
    info.birthdate = Player.PlayerData.charinfo.birthdate
    if testType == 'driver' then
        info.type = 'Class R License'
        if Player.PlayerData.metadata['licences']['bike'] then
            info.endorsement = 'Motorcycle Endorsement'
        else
            info.endorsement = 'None'
        end
        info.endorsement = 'None'
    elseif testType == 'cdl' then
        info.type = 'Class A License'
    end

    if success and testType ~= nil then
        if Config.DriversTest then  -- Safety for hackers trying to trigger this event
            Player.PlayerData.metadata['licences'][testType] = true
            if Player.Functions.RemoveMoney(Config.PaymentType, Config.Amount[testType], 'passed-'..testType..'-test') then
                Player.Functions.SetMetaData('licences', Player.PlayerData.metadata['licences'])
                if Config.GiveItem then
                    if Config.BikeEndorsement and testType == 'bike' then
                        if Player.Functions.RemoveItem(Config.Items['driver'], 1) then
                            if Player.PlayerData.metadata['licences']['bike'] then
                                info.endorsement = 'Motorcycle Endorsement'
                            else
                                info.endorsement = 'None'
                            end
                            if Player.Functions.AddItem(Config.Items['driver'], 1, nil, info) then
                                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['driver_license'], 'add')
                            end
                        end
                    else
                        if Player.Functions.AddItem(Config.Items[testType], 1, nil, info) then
                            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.Items[testType]], 'add')
                        end
                    end
                else
                    TriggerClientEvent('QBCore:Notify', src, 'Go to the City Hall to pick up your driver\'s license.', 'success', 3000)
                end
            else
                TriggerClientEvent('QBCore:Notify', src, 'You don\'t have enough money to pay for your test. You must take it again to pass.', 'warning', 3000)
            end
        end
    else
        if Player.Functions.RemoveMoney(Config.PaymentType, (Config.Amount[testType] / 2)) then
            TriggerClientEvent('QBCore:Notify', src, 'Paid(Half Price): '..(Config.Amount[testType] / 2))
        end
    end
end)




QBCore.Commands.Add(Config.CommandName, 'Reset A Players License', {{name = "id", help = 'Player ID'}, {name = "license", help = 'License Type'}}, false, function(source, args)
	local src = source
	if args[1] and args[2] then
        local Player = QBCore.Functions.GetPlayer(tonumber(args[1]))
        Player.PlayerData.metadata['licences'][args[2]] = false
        Player.Functions.SetMetaData('licences', Player.PlayerData.metadata['licences'])
    else
        TriggerClientEvent('QBCore:Notify', src, 'Must Input each Arguement.')
    end
end, "admin")