QBCore = exports['qb-core']:GetCoreObject()

-------------
-- Variables --
------------
local CurrentTest = nil
local drivingTest = false
local LastCheckPoint = -1
local CurrentCheckPoint = 0

local PlayerData = QBCore.Functions.GetPlayerData()
local pedSpawned = false
local ped = {}
local listen = false



---------------------------------------
            -- FUNCTIONS --
---------------------------------------
local function createBlips()
  if pedSpawned then return end
  for k, v in pairs(Config.Locations) do
    if v.blip.showblip then
      local DMVBlip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
      SetBlipSprite(DMVBlip, v.blip.blipsprite)
      SetBlipScale(DMVBlip, v.blip.blipscale)
      SetBlipDisplay(DMVBlip, 4)
      SetBlipColour(DMVBlip, v.blip.blipcolor)
      SetBlipAsShortRange(DMVBlip, true)
      BeginTextCommandSetBlipName("STRING")
      AddTextComponentSubstringPlayerName(v.blip.label)
      EndTextCommandSetBlipName(DMVBlip)
    end
  end
end


local function createPeds()
  if pedSpawned then return end

  for k, v in pairs(Config.Locations) do
    local current = type(v.pedModel) == 'number' and v.pedModel or joaat(v.pedModel)

    RequestModel(current)
    while not HasModelLoaded(current) do
      Wait(0)
    end

    ped[k] = CreatePed(0, current, v.coords.x, v.coords.y, v.coords.z-1, v.coords.w, false, false)
    TaskStartScenarioInPlace(ped[k], v.scenario, 0, true)
    FreezeEntityPosition(ped[k], v.freezePed)
    SetEntityInvincible(ped[k], v.invinciblePed)
    SetBlockingOfNonTemporaryEvents(ped[k], true)

    if Config.UseTarget then
      exports['qb-target']:AddTargetEntity(ped[k], {
        options = {
          {
            label = 'Open DMV',
            icon = 'fa-solid fa-car-burst',
            action = function ()
              OpenMenu()
            end,
          }
        },
        distance = 2.5
      })
    end
  end
  pedSpawned = true
end

local function deletePeds()
  if not pedSpawned then return end

  for _, v in pairs(ped) do
    DeletePed(v)
  end
  pedSpawned = false
end

function OpenMenu()
  local DMV = {
    {
      header = 'DMV School',
      isMenuHeader = true,
    },
    {
      icon = 'fas fa-circle-xmark',
      header = '', txt = 'Close',
      params = {
        event = '',
      },
    },
  }

  if not PlayerData.metadata['licences']['permit'] then

    DMV[#DMV+1] = {
      header = 'Start Theoritical Test',
      icon = 'fa-solid fa-clipboard-question',
      txt = '$'..Config.Amount['theoritical'],
      params = {
        event = 'qb-dmv:client:StartQuiz',
        args = {
          CurrentTest = 'theoritical'
        }
      }
    }

  else

    if not PlayerData.metadata['licences']['driver'] then
      
      DMV[#DMV+1] = {
        header = 'Start Driving Test',
        icon = 'fa-solid fa-car-side',
        txt = '$'..Config.Amount['driver'],
        params = {
          event = 'qb-dmv:client:StartDrivingTest',
          args = {
            CurrentTest = 'driver',
          },
        },
      }

    end

    if not PlayerData.metadata['licences']['bike'] and PlayerData.metadata['licences']['driver'] and QBCore.Functions.HasItem(Config.Items['driver']) then
      
      DMV[#DMV+1] = {
        header = 'Start Bike Driving Test',
        icon = 'fa-solid fa-motorcycle',
        txt = '$'..Config.Amount['bike'],
        params = {
          event = 'qb-dmv:client:StartDrivingTest',
          args = {
            CurrentTest = 'bike',
          },
        },
      }

    end

    if not PlayerData.metadata['licences']['cdl'] and PlayerData.metadata['licences']['driver'] then
      
      DMV[#DMV+1] = {
        header = 'Start CDL Driving Test',
        icon = 'fa-solid fa-truck-fast',
        txt = '$'..Config.Amount['cdl'],
        params = {
          event = 'qb-dmv:client:StartDrivingTest',
          args = {
            CurrentTest = 'cdl',
          },
        },
      }

    end
  end

  exports['qb-menu']:openMenu(DMV)
end

function DrawMissionText(msg, time)
  ClearPrints()
  SetTextEntry_2('STRING')
  AddTextComponentString(msg)
  DrawSubtitleTimed(time, 1)
end

function SetCurrentZoneType(type)
  CurrentZoneType = type
end

function StopTheoryTest(success) 
  CurrentTest = nil
  SendNUIMessage({
    openQuestion = false
  })
  SetNuiFocus(false)
  TriggerServerEvent('qb-dmv:server:TheoryTestResult', success)
end

function StopDriveTest(success, testType)
  local playerPed = PlayerPedId()
  local veh = GetVehiclePedIsIn(playerPed)

  if success then
    QBCore.Functions.Notify('You passed the Driving Test!', 'success', 3000)
    QBCore.Functions.DeleteVehicle(veh)
  else
    QBCore.Functions.Notify('You failed the driving test, try again...', 'error', 3000)
    RemoveBlip(CurrentBlip)
    QBCore.Functions.DeleteVehicle(veh)
    Wait(1000)
    SetEntityCoords(playerPed, Config.PlayerCoordsAfterTest.x, Config.PlayerCoordsAfterTest.y, Config.PlayerCoordsAfterTest.z)
    SetEntityHeading(playerPed, Config.PlayerCoordsAfterTest.w)
  end

  TriggerServerEvent('qb-dmv:server:DrivingTestResult', success, testType)
  CurrentTest     = nil
end

function DrivingTest(testType)
  while drivingTest do
    local checkPoints = Config.NewCheckPoints[testType]['checkpoints']
    local nextCheckPoint = CurrentCheckPoint + 1
    local playerCoords = GetEntityCoords(PlayerPedId())
    Wait(10)
    if CurrentTest then
      if checkPoints[nextCheckPoint] == nil then
        if DoesBlipExist(CurrentBlip) then
          RemoveBlip(CurrentBlip)
        end
        CurrentTest = nil
        StopDriveTest(true, testType)
      else
        if CurrentCheckPoint ~= LastCheckPoint then
          if DoesBlipExist(CurrentBlip) then
            RemoveBlip(CurrentBlip)
          end
          CurrentBlip = AddBlipForCoord(checkPoints[nextCheckPoint].pos.x, checkPoints[nextCheckPoint].pos.y, checkPoints[nextCheckPoint].pos.z, true)
          SetBlipRoute(CurrentBlip, 1)
          LastCheckPoint = CurrentCheckPoint
        end
        if #(GetEntityCoords(PlayerPedId()) - vector3(checkPoints[nextCheckPoint].pos.x, checkPoints[nextCheckPoint].pos.y, checkPoints[nextCheckPoint].pos.z)) < 100.0 then
          DrawMarker(1, checkPoints[nextCheckPoint].pos.x, checkPoints[nextCheckPoint].pos.y, checkPoints[nextCheckPoint].pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
        end
        if #(GetEntityCoords(PlayerPedId()) - vector3(checkPoints[nextCheckPoint].pos.x, checkPoints[nextCheckPoint].pos.y, checkPoints[nextCheckPoint].pos.z)) < 3.0 then
          DrawMissionText(checkPoints[nextCheckPoint].txt, 5000)
          if checkPoints[nextCheckPoint].freezePlayer ~= nil then
            if checkPoints[LastCheckPoint].playsound then
              PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
            end
            if checkPoints[nextCheckPoint].freezePlayer then
              FreezeEntityPosition(CurrentVehicle, true)
              Wait(3000)
              FreezeEntityPosition(CurrentVehicle, false)
            end
          end
          if checkPoints[nextCheckPoint].txt2 ~= nil then
            Wait(2000)
            DrawMissionText(checkPoints[nextCheckPoint].txt2, 5000)
          end
          CurrentCheckPoint = CurrentCheckPoint + 1
        end
        if checkPoints[nextCheckPoint].currentzone ~= nil then
          SetCurrentZoneType(checkPoints[nextCheckPoint].currentzone)
        end
      end
    end
    if CurrentCheckPoint ~= nil and CurrentCheckPoint > 0 then
      if checkPoints[CurrentCheckPoint].endpoint ~= nil then
        if checkPoints[CurrentCheckPoint].endpoint then
          QBCore.Functions.DeleteVehicle(CurrentVehicle)
          SetEntityAsMissionEntity(CurrentVehicle, true, true)
          drivingTest = false
          RemoveBlip(CurrentBlip)
          StopDriveTest(true, testType)
        end
      end
    end
  end
end

---------------------------------------
            -- PLAYER EVENTS --
---------------------------------------

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function ()
  PlayerData = QBCore.Functions.GetPlayerData()
  createPeds()
  createBlips()
end)

RegisterNetEvent('QBCore:Client:OnPlyaerUnload', function ()
  deletePeds()
  PlayerData = nil
end)

RegisterNetEvent('QBCore:Player:SetPlayerData', function (val)
  PlayerData = val
end)

AddEventHandler('onResourceStart', function (resourceName)
  if GetCurrentResourceName() ~= resourceName then return end
  createBlips()
  createPeds()
end)

AddEventHandler('onResourceStop', function (resourceName)
  if GetCurrentResourceName() ~= resourceName then return end
  deletePeds()
end)

---------------------------------------
            -- NUI Callbacks --
---------------------------------------
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

RegisterNetEvent('qb-dmv:client:StartDrivingTest', function(data)
  CurrentTest = data.CurrentTest
  DriveErrors = 0
  LastCheckPoint = -1
  CurrentCheckPoint = 0
  IsAboveSpeedLimit = false
  CurrentZoneType = Config.NewCheckPoints[data.CurrentTest]['startingzone']
  StartingPoint = Config.NewCheckPoints[data.CurrentTest]['startingpoint']

  QBCore.Functions.SpawnVehicle(Config.VehicleModels[data.CurrentTest], function(veh)
    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
    exports[Config.FuelResource]:SetFuel(veh, 100)
    SetVehicleNumberPlateText(veh, Config.VehPlate)
    SetEntityAsMissionEntity(veh, true, true)
    SetEntityHeading(veh,StartingPoint.w)
    TriggerEvent('vehiclekeys:client:SetOwner', QBCore.Functions.GetPlate(veh))
    TriggerServerEvent('qb-vehicletuning:server:SaveVehicleProps', QBCore.Functions.GetVehicleProperties(veh))
    LastVehicleHealth = GetVehicleBodyHealth(veh)
    CurrentVehicle = veh
  end, vector3(StartingPoint.x, StartingPoint.y, StartingPoint.z), false)

  drivingTest = true
  DrivingTest(data.CurrentTest)
end)

RegisterNetEvent('qb-dmv:client:StartQuiz', function ()
  
  if PlayerData.money[Config.PaymentType] < Config.Amount['theoritical'] then
    QBCore.Functions.Notify('Not Enough Money in '..Config.PaymentType)
    return
  end
  
  SendNUIMessage({
    Wait(10),
    openQuestion = true
  })

  SetTimeout(200, function ()
      SetNuiFocus(true, true)
  end)
end)

---------------------------------------
            -- THREADS --
---------------------------------------

-- Speed/Damage Control
CreateThread( function ()
  while true do
    local sleep = 1000
    local playerPed = PlayerPedId()
    
    if CurrentTest ~= nil then
      sleep = 10

      if IsPedInAnyVehicle(playerPed,  false) then
        local health = GetVehicleBodyHealth(vehicle)
        local vehicle = GetVehiclePedIsIn(playerPed,  false)

        if Config.SpeedMultiplier == 'mph' then
          speedMultiplier = 2.236936
        elseif Config.SpeedMultiplier == 'kmh' then
          speedMultiplier = 3.6
        else
          speedMultiplier = 3.6
        end

        local speed = GetEntitySpeed(vehicle) * speedMultiplier
        local tooMuchSpeed = false

        for k,v in pairs(Config.SpeedLimits) do
            if CurrentZoneType == k and speed > v then
              tooMuchSpeed = true

                if not IsAboveSpeedLimit then
                    DriveErrors       = DriveErrors + 1
                    IsAboveSpeedLimit = true
                    QBCore.Functions.Notify('Driving too fast. Slow Down', 'warning', 3000)
                    QBCore.Functions.Notify('Errors: '..tostring(DriveErrors)..' / '..Config.MaxErrors, 'error', 3000)
                end

            end
        end

        if not tooMuchSpeed then
            IsAboveSpeedLimit = false
        end

        if health < LastVehicleHealth then
            DriveErrors = DriveErrors + 1
            QBCore.Functions.Notify('You damaged the vehicle.', 'warning', 3000)
            QBCore.Functions.Notify('Errors: '..tostring(DriveErrors)..' / '..Config.MaxErrors, 'warning', 3000)
            LastVehicleHealth = health
        end

        if DriveErrors >= Config.MaxErrors then
          Wait(500)
          StopDriveTest(false)
        end
      end
    end
    Wait(sleep)
  end
end)