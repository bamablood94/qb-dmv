QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
            Citizen.Wait(200)
        end
    end
end)

-------------
-- Variables --
-------------
local src = source
local CurrentTest = nil
local LastCheckPoint = -1
local CurrentCheckPoint = 0
local CurrentZoneType   = nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    isLoggedIn = true
    Player = QBCore.Functions.GetPlayerData()
end)

-- Opens qb-menu to select dmv options
function OpenMenu()
    exports['qb-menu']:openMenu({
      {
        header = "DMV School",
        isMenuHeader = true,
      },
      {
        header = "Start Theoretical Test",
        txt = "$"..Config.Amount['theoretical'].."",
        params = {
          event = 'qb-dmv:startquiz'
        }
      }
    })
end

function OpenMenu2()
  exports['qb-menu']:openMenu({
    {
      header = "DMV School",
      isMenuHeader = true,
    },
    {
      header = "Start Driving Test",
      txt = "$"..Config.Amount['driving'].."",
      params = {
        event = 'qb-dmv:startdriver'
      }
    },
    --[[{
      header = "Start CDL Drving Test",
      txt = "$"..Config.Amount['cdl'].."",
      params = {
        event = 'qb-dmv:startcdl'
      }
    }]]
  })
end
-- Event to put in qb-menu to start driving test
RegisterNetEvent('qb-dmv:startdriver', function()
        CurrentTest = 'drive'
        DriveErrors = 0
        LastCheckPoint = -1
        CurrentCheckPoint = 0
        IsAboveSpeedLimit = false
        CurrentZoneType = 'residence'
        local prevCoords = GetEntityCoords(PlayerPedId())
        QBCore.Functions.SpawnVehicle(Config.VehicleModels.driver, function(veh)
            TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
            exports['LegacyFuel']:SetFuel(veh, 100)
            SetVehicleNumberPlateText(veh, 'DMV')
            SetEntityAsMissionEntity(veh, true, true)
            SetEntityHeading(veh, Config.Location['spawn'].w)
            TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(veh))
            TriggerServerEvent('qb-vehicletuning:server:SaveVehicleProps', QBCore.Functions.GetVehicleProperties(veh))
            LastVehicleHealth = GetVehicleBodyHealth(veh)
            CurrentVehicle = veh
            QBCore.Functions.Notify('You are taking the Driving test')
        end, Config.Location['spawn'], false)
end)



-- Event for qb-menu to run to start quiz
RegisterNetEvent('qb-dmv:startquiz')
AddEventHandler('qb-dmv:startquiz', function (src)
    CurrentTest = 'theory'
    SendNUIMessage({
      Wait(10),
      openQuestion = true
    })

    SetTimeout(200, function ()
        SetNuiFocus(true, true)
    end)

end)

-- When stopping/finishing theoritical test
function StopTheoryTest(success) 
    local Player = QBCore.Functions.GetPlayerData(src)
    CurrentTest = nil
    SendNUIMessage({
      openQuestion = false
    })
    SetNuiFocus(false)
    if success then
      QBCore.Functions.Notify('You passed your test!', 'success')
      TriggerServerEvent('qb-dmv:theorypaymentpassed')
    else
      QBCore.Functions.Notify('You failed the test!', 'error')
      TriggerServerEvent('qb-dmv:theorypaymentfailed')
    end
end

--Stop Drive Test
function StopDriveTest(success)
    local playerPed = PlayerPedId()
    local veh = GetVehiclePedIsIn(playerPed)
    if success then
      TriggerServerEvent('qb-dmv:driverpaymentpassed')
      QBCore.Functions.Notify('You passed the Drving Test!')
      QBCore.Functions.DeleteVehicle(veh)
    elseif success == false then
      TriggerServerEvent('qb-dmv:driverpaymentfailed')
      QBCore.Functions.Notify('You Failed the Driving Test!')
      CurrentTest = nil
      RemoveBlip(CurrentBlip)
      QBCore.Functions.DeleteVehicle(veh)
      Wait(1000)
      SetEntityCoords(playerPed, Config.Location['marker'].x+1, Config.Location['marker'].y+1, Config.Location['marker'].z)
    end
  
    CurrentTest     = nil
    CurrentTestType = nil
  
  end

-- Drive test
Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
    if CurrentTest == 'drive' then
      local marker = Config.Location['marker']
      local playerPed      = PlayerPedId()
      local coords         = GetEntityCoords(playerPed)
      local nextCheckPoint = CurrentCheckPoint + 1
      if Config.CheckPoints[nextCheckPoint] == nil then
        if DoesBlipExist(CurrentBlip) then
          RemoveBlip(CurrentBlip)
        end
        CurrentTest = nil
        StopDriveTest(true)
        --QBCore.Functions.Notify('Drving Test Complete')
      else
        if CurrentCheckPoint ~= LastCheckPoint then
          if DoesBlipExist(CurrentBlip) then
            RemoveBlip(CurrentBlip)
          end
          CurrentBlip = AddBlipForCoord(Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z)
          SetBlipRoute(CurrentBlip, 1)
          LastCheckPoint = CurrentCheckPoint
        end
        local distance = GetDistanceBetweenCoords(coords, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, true)
        if distance <= 100.0 then
          DrawMarker(1, Config.CheckPoints[nextCheckPoint].Pos.x, Config.CheckPoints[nextCheckPoint].Pos.y, Config.CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
        end
        if distance <= 3.0 then
          Config.CheckPoints[nextCheckPoint].Action(playerPed, CurrentVehicle, SetCurrentZoneType)
          CurrentCheckPoint = CurrentCheckPoint + 1
        end
      end
    end
  end
end)


-- Speed / Damage control
--[[Citizen.CreateThread(function()
    while true do
      Citizen.Wait(10)
        if CurrentTest == 'drive' then
            local playerPed = PlayerPedId()
            if IsPedInAnyVehicle(playerPed,  false) then
                local vehicle      = GetVehiclePedIsIn(playerPed,  false)
                local speed        = GetEntitySpeed(vehicle) * Config.SpeedMultiplier
                local tooMuchSpeed = false
                for k,v in pairs(Config.SpeedLimits) do
                    if CurrentZoneType == k and speed > v then
                    tooMuchSpeed = true
                        if not IsAboveSpeedLimit then
                            DriveErrors       = DriveErrors + 1
                            IsAboveSpeedLimit = true
                            QBCore.Functions.Notify('Driving too fast',"error")
                            QBCore.Functions.Notify("Errors:"..tostring(DriveErrors).."/" ..Config.MaxErrors.. "", "error")
                        end
                    end
                end
                if not tooMuchSpeed then
                    IsAboveSpeedLimit = false
                end
                local health = GetVehicleBodyHealth(vehicle)
                if health < LastVehicleHealth then
                    DriveErrors = DriveErrors + 1
                    --ESX.ShowNotification(_U('you_damaged_veh'))
                    QBCore.Functions.Notify('You Damaged the Vehicle')
                    QBCore.Functions.Notify("Errors:"..tostring(DriveErrors).."/" ..Config.MaxErrors.. "", "error")
                    LastVehicleHealth = health
                end 
            end
        end
    end
end)]]

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(10)
      if CurrentTest == 'drive' then
          local playerPed = PlayerPedId()
          if IsPedInAnyVehicle(playerPed,  false) then
              local vehicle      = GetVehiclePedIsIn(playerPed,  false)
              local speed        = GetEntitySpeed(vehicle) * Config.SpeedMultiplier
              local tooMuchSpeed = false
              for k,v in pairs(Config.SpeedLimits) do
                  if CurrentZoneType == k and speed > v then
                  tooMuchSpeed = true
                      if not IsAboveSpeedLimit then
                          DriveErrors       = DriveErrors + 1
                          IsAboveSpeedLimit = true
                          QBCore.Functions.Notify('Driving too fast',"error")
                          QBCore.Functions.Notify("Errors:"..tostring(DriveErrors).."/" ..Config.MaxErrors.. "", "error")
                      end
                  end
              end
              if not tooMuchSpeed then
                  IsAboveSpeedLimit = false
              end
              local health = GetVehicleBodyHealth(vehicle)
              if health < LastVehicleHealth then
                  DriveErrors = DriveErrors + 1
                  QBCore.Functions.Notify('You Damaged the Vehicle')
                  QBCore.Functions.Notify("Errors:"..tostring(DriveErrors).."/" ..Config.MaxErrors.. "", "error")
                  LastVehicleHealth = health
              end
              if DriveErrors >= Config.MaxErrors then
                Wait(10)
                StopDriveTest(false)
              end
          end
      end
  end
end)


--Page Selections changing to different page of UI for theoritical quiz
RegisterNUICallback('question', function(data, cb)
    SendNUIMessage({
      openSection = 'question'
    })
    cb('OK')
end)

RegisterNUICallback('close', function(data, cb)
    StopTheoryTest(true)
    cb('OK')
end)

RegisterNUICallback('kick', function(data, cb)
    StopTheoryTest(false)
    cb('OK')
end)

--Block UI
Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(10)
        if CurrentTest =='theory' then
            local playerPed = GetPlayerPed(-1)

            DisableControlAction(0, 1, true) -- LookLeftRight
            DisableControlAction(0, 2, true) -- LookUpDown
            DisablePlayerFiring(playerPed, true) -- Disable weapon firing
            DisableControlAction(0, 142, true) -- MeleeAttackAlternate
            DisableControlAction(0, 106, true) -- VehicleMouseControlOverride
        end
    end
end)

--Blips
Citizen.CreateThread(function ()
    blip = AddBlipForCoord(Config.Location['marker'].x, Config.Location['marker'].y, Config.Location['marker'].z)
    SetBlipSprite(blip, Config.Blip.Sprite)
    SetBlipDisplay(blip, Config.Blip.Display)
    SetBlipColour(blip, Config.Blip.Color)
    SetBlipScale(blip, Config.Blip.Scale)
    SetBlipAsShortRange(blip, Config.Blip.ShortRange)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.Blip.BlipName)
    EndTextCommandSetBlipName(blip)
end)

--Marker
Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        local drive = Config.DriversTest
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        local dist = GetDistanceBetweenCoords(pos,Config.Location['marker'].x, Config.Location['marker'].y, Config.Location['marker'].z, true)
        if dist <= 6.0 then
            local marker ={
                ['x'] = Config.Location['marker'].x,
                ['y'] = Config.Location['marker'].y,
                ['z'] = Config.Location['marker'].z
            }
            DrawText3Ds(marker['x'], marker['y'], marker['z'], "[E] Open Menu")
            if dist <= 1.5 then
              if IsControlJustReleased(0, 46) then
                QBCore.Functions.TriggerCallback('qb-dmv:server:menu', function (HasItems1)
                    if HasItems1 == false then
                        QBCore.Functions.TriggerCallback('qb-dmv:server:menu2', function (HasItems2)
                            if HasItems2 then
                                if drive then
                                  if CurrentTest == 'drive' then
                                    QBCore.Functions.Notify("You\'re already taking the driving test", "error")
                                  else
                                    OpenMenu2()
                                    CurrentTest = 'drive'
                                  end
                                else
                                  QBCore.Functions.Notify("You already have your Driver\'s License")
                                end
                            else
                              QBCore.Functions.Notify("You already took your tests!")
                            end
                        end)
                    else
                      OpenMenu()
                    end
                end)
              end
            end
        end
    end
end)



-----------------DrawText3Ds Function-------------------
DrawText3Ds = function(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local factor = #text / 370
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	DrawRect(_x,_y + 0.0125, 0.015 + factor, 0.03, 0, 0, 0, 120)
end
-----------------DrawMissionText Function-------------------
function DrawMissionText(msg, time)
    ClearPrints()
    SetTextEntry_2('STRING')
    AddTextComponentString(msg)
    DrawSubtitleTimed(time, 1)
end
-----------------SetCurrentZoneType Function-------------------
function SetCurrentZoneType(type)
    CurrentZoneType = type
  end

-----------------Ped Spawner------------------- for Config.UseTarget CURRENTLY NOT WORKING(If you manage to make this work the way I'm looking for it too please let me know Bama94#1994)
CreateThread(function ()
  if Config.UseTarget then
    SpawnPed = Config.Ped
    exports['qb-target']:SpawnPed({
      model = SpawnPed,
      coords = vector4(Config.Location['ped'].x, Config.Location['ped'].y, Config.Location['ped'].z, Config.Location['ped'].w),
      minusOne = true,
      freeze = true,
      invincible = true,
      blockevents = true,
      scenario = 'WORLD_HUMAN_CLIPBOARD',
      target = {
        options = {}
      }
    })
  else
    DeletePed(SpawnPed)
  end
  if Config.UseTarget then
    QBCore.Functions.TriggerCallback('qb-dmv:server:menu', function (HasItems1)
      if HasItems1 == false then
          QBCore.Functions.TriggerCallback('qb-dmv:server:menu2', function (HasItems2)
              if HasItems2 then
                exports['qb-target']:AddTargetModel(SpawnPed, {       --Drivers Test Menu
                  options = {
                      {
                        type = "client",
                        event = "qb-dmv:startdriver",
                        icon = 'fas fa-example',
                        label = 'Start Drivers Test $'..Config.Amount['driving'].."",
                      },
                      {
                        type = "client",
                        event = "qb-dmv:startcdl",
                        icon = "fas fa-example",
                        label = 'Start Drivers Test $'..Config.Amount['cdl'].."",
                      }
                  },
                    distance = 2.5,
              })
              else
                QBCore.Functions.Notify("You already took your tests!")
              end
          end)
      else
        exports['qb-target']:AddTargetModel(SpawnPed, {     --Theoretical Test Menu
          options = {
              {
                type = "client",
                event = "qb-dmv:startquiz",
                icon = 'fas fa-example',
                label = 'Start Theoretical Test $'..Config.Amount['theoretical'].."",
              },
          },
            distance = 2.5,
      })
      end
    end)
  end
end)