QBCore = exports['qb-core']:GetCoreObject()

-------------
-- Variables --
------------
local CurrentTest = nil
local LastCheckPoint = -1
local CurrentCheckPoint = 0
local CurrentZoneType   = nil
local inDMV = false

RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
  isLoggedIn = true
  Player = QBCore.Functions.GetPlayerData()
end)

--Page Selections changing to different page of UI for theoritical quiz
RegisterNUICallback('question', function(data, cb)
    SendNUIMessage({
      openSection = 'question'
    })
    cb()
end)

RegisterNUICallback('close', function(data, cb)
    StopTheoryTest(true)
    cb()
end)

RegisterNUICallback('kick', function(data, cb)
    StopTheoryTest(false)
    cb()
end)

---------------------------------------
            -- EVENTS --
---------------------------------------
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
      TriggerEvent('qb-dmv:Notify', 'You are taking the driving test.', 3000, 'success', 'Taking Driving Test')
  end, Config.Location['spawn'], false)
end)



-- Event for qb-menu to run to start quiz
RegisterNetEvent('qb-dmv:startquiz')
AddEventHandler('qb-dmv:startquiz', function ()
  CurrentTest = 'theory'
  SendNUIMessage({
    Wait(10),
    openQuestion = true
  })

  SetTimeout(200, function ()
      SetNuiFocus(true, true)
  end)
end)

--Event For Notification Type
RegisterNetEvent('qb-dmv:Notify', function (msg, time, type, title)
  local notify = Config.NotifyType
  if type == 'info' then
    if notify == 'qbcore' then
      type = 'primary'
    elseif notify == 'okok' then
      type = type
    end
  elseif type == 'warning' then
    if notify == 'qbcore' then
      type = 'error'
    elseif notify == 'okok' then
      type = type
    end
  end
  if notify == 'qbcore' then
    TriggerEvent('QBCore:Notify', msg, type, time)
    --QBCore.Functions.Notify(msg, type, time)
  elseif notify == 'okok' then
    exports['okokNotify']:Alert(title, msg, time, type)
  else
    TriggerEvent('chat:addMessage', {
      color = {255, 0, 0},
      multiline = false,
      args = {title, msg}
    })
  end
end)

RegisterNetEvent('qb-dmv:client:dmvoptions', function ()
  DMVOptions()
end)
---------------------------------------
            -- FUNCTIONS --
---------------------------------------

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

-- When stopping/finishing theoritical test
function StopTheoryTest(success) 
  CurrentTest = nil
  SendNUIMessage({
    openQuestion = false
  })
  SetNuiFocus(false)
  if success then
    TriggerEvent('qb-dmv:Notify', 'You passed your test!', 3000, 'success', 'Passed')
    TriggerServerEvent('qb-dmv:theorypaymentpassed')
  else
    TriggerEvent('qb-dmv:Notify', 'You failed the test!', 3000, 'error', 'Failed')
    TriggerServerEvent('qb-dmv:theorypaymentfailed')
  end
end

--Stop Drive Test
function StopDriveTest(success)
  local playerPed = PlayerPedId()
  local veh = GetVehiclePedIsIn(playerPed)
  if success then
    TriggerEvent('qb-dmv:Notify', 'You passed the driving test!', 3000, 'success', 'Passed')
    TriggerServerEvent('qb-dmv:driverpaymentpassed')
    QBCore.Functions.DeleteVehicle(veh)
    CurrentTest = nil
  elseif success == false then
    TriggerServerEvent('qb-dmv:driverpaymentfailed')
    TriggerEvent('qb-dmv:Notify', 'You failed the driving test, please try again.', 3000, 'success', 'Failed')
    CurrentTest = nil
    RemoveBlip(CurrentBlip)
    QBCore.Functions.DeleteVehicle(veh)
    Wait(1000)
    SetEntityCoords(playerPed, Config.Location['marker'].x+1, Config.Location['marker'].y+1, Config.Location['marker'].z)
  end

  CurrentTest     = nil
  CurrentTestType = nil
  
end

-- Opens Theroritical menu if permit = false in database
--[[function OpenMenu()
  exports['qb-menu']:openMenu({
    {
      header = "DMV School",
      isMenuHeader = true,
    },
    {
      header = "Start Theoretical Test",
      txt = "$"..Config.Amount['theoretical'].."",
      params = {
        event = 'qb-dmv:startquiz',
        args = {
          CurrentTest = 'theory'
        }
      }
    }
  })
end]]

-- Opens Driving Test Menu if driver = false in database
function OpenMenu(menu)
  if menu == 'theoritical' then
    exports['qb-menu']:openMenu({
      {
        header = "DMV School",
        isMenuHeader = true,
      },
      {
        header = "Start Theoretical Test",
        txt = "$"..Config.Amount['theoretical'].."",
        params = {
          event = 'qb-dmv:startquiz',
          args = {
            CurrentTest = 'theory'
          }
        }
      }
    })
  elseif menu == 'driver' then
    exports['qb-menu']:openMenu({
      {
        header = "DMV School",
        isMenuHeader = true,
      },
      {
        header = "Start Driving Test",
        txt = "$"..Config.Amount['driving'].."",
        params = {
          event = 'qb-dmv:startdriver',
          args = {
            CurrentTest = 'drive'
          }
        }
      },
      {
        header = "Start CDL Drving Test",
        txt = "$"..Config.Amount['cdl'].."",
        params = {
          event = 'qb-dmv:startcdl'
        }
      }
    })
  end
end

function DMVOptions()
  local drive = Config.DriversTest
  if CurrentTest == 'drive' then
    TriggerEvent('qb-dmv:Notify', 'You\'re already taking the driving test.', 3000, 'error', 'Already Taking Test')
  else
    QBCore.Functions.TriggerCallback('qb-dmv:server:permitdata', function (permit)
      if permit then
        OpenMenu('theoritical')
      else
        QBCore.Functions.TriggerCallback('qb-dmv:server:licensedata', function (license)
          if license then
            if drive then
              OpenMenu('driver')
            else
              TriggerEvent('qb-dmv:Notify', 'You already took your tests! Go to the City Hall to buy your license', 3000, 'info', 'Already took the test')
            end
          end
        end)
      end
    end)
  end
end
---------------------------------------
            -- THREADS --
---------------------------------------

--Block UI
CreateThread(function ()
  while true do
      Wait(10)
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
CreateThread(function ()
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

CreateThread( function ()
  if not Config.UseTarget then
    if Config.UseNewQB then
      local dmvzone = CircleZone:Create(vector3(Config.Location['coords']['x'], Config.Location['coords']['y'], Config.Location['coords']['z']), Config.Location['radius'], {useZ = Config.Location['useZ']})
      dmvzone:onPlayerInOut( function (isPointInside)
        if isPointInside then
          inDMV = true
          exports['qb-core']:DrawText('[E] Open DMV')
        else
          exports['qb-core']:HideText()
        end
      end)
    else
      while true do
        Wait(0)
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
              if CurrentTest ~= 'drive' then
                if IsControlJustReleased(0, 46) then
                  QBCore.Functions.TriggerCallback('qb-dmv:server:permitdata', function (permit)
                      if permit == false then
                          QBCore.Functions.TriggerCallback('qb-dmv:server:licensedata', function (license)
                              if license then
                                  if drive then
                                      Wait(10)
                                      OpenMenu2()
                                  end
                              else
                                TriggerEvent('qb-dmv:Notify', 'You already took your tests! Go to the City Hall to buy your license.', 3000, 'info', 'Already took the Test')
                              end
                          end)
                      else
                        Wait(10)
                        OpenMenu()
                      end
                  end)
                end
              elseif CurrentTest == 'drive' and IsControlJustReleased(0, 46) then
                TriggerEvent('qb-dmv:Notify', 'You\'re already taking the driving test.', 3000, 'error', 'Already Taking Test')
              end
            end
        end
      end
    end
  else
    exports['qb-target']:SpawnPed({
      model = Config.Location['ped']['model'],
      coords = Config.Location['coords'],
      minusOne = Config.TargetOptions.minusOne,
      freeze = Config.TargetOptions.freeze,
      invincible = Config.TargetOptions.invincible,
      blockevents = Config.TargetOptions.blockevents,
      target = {
          options = {
            {
              type = 'client',
              icon = Config.TargetOptions.options.icon,
              label = Config.TargetOptions.options.label,
              event = 'qb-dmv:client:dmvoptions'
            },
          },
          distance = Config.Location['radius'],
      }
    })
  end
  while true do
    local sleep = 1000
    if inDMV then
      sleep = 0
      if IsControlJustPressed(0, 38) then
        sleep = 1000
        exports['qb-core']:KeyPressed()
        DMVOptions()
      end
    end
    Wait(sleep)
  end
end)

-- Drive test
CreateThread(function()
  while true do
    Wait(10)
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
CreateThread(function()
  while true do
    Wait(10)
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
                          TriggerEvent('qb-dmv:Notify', 'You\'re driving too fast. Slow down', 3000, 'warning', 'Watch your speed!')
                          TriggerEvent('qb-dmv:Notify', 'Errors: '..tostring(DriveErrors)..' / '..Config.MaxErrors, 3000, 'warning', 'Error')
                      end
                  end
              end
              if not tooMuchSpeed then
                  IsAboveSpeedLimit = false
              end
              local health = GetVehicleBodyHealth(vehicle)
              if health < LastVehicleHealth then
                  DriveErrors = DriveErrors + 1
                  TriggerEvent('qb-dmv:Notify', 'You damaged the vehicle', 3000, 'warning', 'Damaged the Vehicle')
                  TriggerEvent('qb-dmv:Notify', 'Errors: '..tostring(DriveErrors)..' / '..Config.MaxErrors, 3000, 'warning', 'Error!')
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