Config = {}

Config.NotifyType = 'qbcore'                                 --(qbcore | okok)<--This is the 2 options. Right now only supports QBCore:Notify or okokNotify

Config.PaymentType = 'cash'                                  -- 'cash' or 'bank' What account to use for payment
Config.DriversTest = true                                    --[[False = Do not have to take the drivers test to get a Drivers License(will give drivers_license after 
                                                                questionairre.) True = Requires you to take Drivers Test to get driver_license]]
Config.SpeedMultiplier = 2.236936                            --KM/H = 3.6 MPH = 2.236936
Config.MaxErrors       = 10
Config.UseTarget       = true                                -- True = Spawns a Ped to use qb-target with. False = Will use exports['qb-core']:DrawText or DrawText3Ds function depending on Config.UseNewQB
Config.UseNewQB        = true                                -- If Not Using Target then if your QB files aren't updated to use exports['qb-core']:DrawText then make this false. If you'd rather use the exports['qb-core']:DrawText than use Target then make this true and make Config.UseTarget = false


Config.TargetOptions = {
  minusOne = true,
  freeze = true,
  invincible = true,
  blockevents = true,
  options = {
    icon = 'fa-solid fa-car-burst',
    label = 'Open DMV',
  }
}

Config.Location = {
  ['marker'] = vector3(215.31, -1398.99, 30.58),           --Location of Blip for DMV School and Location of Start Marker if Config.UseNewQB = false
  ['spawn'] = vector4(236.08, -1401.41, 30.58, 265.06),    -- Location to spawn vehicle upon starting Drivers Test
  ['coords'] = vector4(214.6, -1400.15, 30.58, 324.82),    -- Location of Ped if Config.UseTarget True or Loction of QB:DrawText Area if Config.UseTarget = false and Config.UseNewQB = true
  ['useZ'] = true,                                         -- Use Z coord for Config.Loacation['coords']. Best to leave this true

  ['ped'] = {
    ['model'] = 'a_m_m_indian_01',                          -- Ped to spawn if Config.UseTarget is true.
  },
  ['radius'] = 5.0,                                         -- If Config.UseNewQB = true and Config.UseTarget = false then this is how far away you have to be from the above coordinates.
}

Config.GiveItem = true                                      -- true = will give item after passing. False = will require players to go to city hall to accuire item

Config.Amount = {
    ['theoretical'] = 50,                                   --theoretical test payment amount(If Config.DriversTest = false then the theoritical test will go to the drivers test amount.)
    ['driving']     = 150,                                  --Drivers Test Payment Amount
    ['cdl']         = 250                                   --CDL Test Payment Amount
}

Config.Blip = {                                             -- Blip Config
  Sprite = 380,
  Display = 4,
  Color = 1,
  Scale = 0.8,
  ShortRange = true,
  BlipName = 'DMV School'
}

Config.VehicleModels = {
  driver = 'sultan',                                         -- Car to spawn with Driver's Test
  cdl = 'stockade'                                          -- Truck to spawn with CDL Test
}

Config.SpeedLimits = {                                      -- Speed Limits in each zone
  residence = 35,
  town      = 55,
  freeway   = 80
}

Config.CheckPoints = {                                      -- Each Cheackpoint for the Drivers Test

  {
    Pos = {x = 255.139, y = -1400.731, z = 29.537},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('go to the next point! Speed Limit: ~y~' .. Config.SpeedLimits['residence'] .. 'mph', 5000)
    end
  },

  {
    Pos = {x = 271.874, y = -1370.574, z = 30.932},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('Go to next point', 5000)
    end
  },

  {
    Pos = {x = 234.907, y = -1345.385, z = 29.542},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      Citizen.CreateThread(function()
        DrawMissionText('~r~Stop~s~ for the pedestrian ~y~crossing', 5000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
        FreezeEntityPosition(vehicle, true)
        Citizen.Wait(4000)
        FreezeEntityPosition(vehicle, false)
        DrawMissionText('~g~Good~s~, continue.', 5000)

      end)
    end
  },

  {
    Pos = {x = 217.821, y = -1410.520, z = 28.292},
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('town')

      Citizen.CreateThread(function()
        DrawMissionText('~r~Stop~s~ and look ~y~left~s~. Speed Limit:~y~ ' .. Config.SpeedLimits['town'] .. 'mph', 5000)
        PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
        FreezeEntityPosition(vehicle, true)
        Citizen.Wait(6000)
        FreezeEntityPosition(vehicle, false)
        DrawMissionText('~g~Good~s~, turn right and follow the line', 5000)
      end)
    end
  },

  {
    Pos = {x = 178.550, y = -1401.755, z = 27.725},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('watch the traffic and ~y~turn on your lights~s~!', 5000)
    end
  },

  {
    Pos = {x = 113.160, y = -1365.276, z = 27.725},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('go to the next point!', 5000)
    end
  },

  {
    Pos = {x = -73.542, y = -1364.335, z = 27.789},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('~r~Stop~s~ for passing vehicles!', 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
      FreezeEntityPosition(vehicle, true)
      Citizen.Wait(6000)
      FreezeEntityPosition(vehicle, false)
    end
  },

  {
    Pos = {x = -355.143, y = -1420.282, z = 27.868},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('go to the next point!', 5000)
    end
  },

  {
    Pos = {x = -439.148, y = -1417.100, z = 27.704},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('go to the next point!', 5000)
    end
  },

  {
    Pos = {x = -453.790, y = -1444.726, z = 27.665},
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('freeway')

      DrawMissionText('it\'s time to drive on the highway! Speed Limit:~y~ ' .. Config.SpeedLimits['freeway'] .. 'mph', 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = -463.237, y = -1592.178, z = 37.519},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('go to the next point!', 5000)
    end
  },

  {
    Pos = {x = -900.647, y = -1986.28, z = 26.109},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('go to the next point!', 5000)
    end
  },

  {
    Pos = {x = 1225.759, y = -1948.792, z = 38.718},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('go to the next point!', 5000)
    end
  },

  {
    Pos = {x = 1225.759, y = -1948.792, z = 38.718},
    Action = function(playerPed, vehicle, setCurrentZoneType)

      setCurrentZoneType('town')

      DrawMissionText('entered town, pay attention to your speed! Speed Limit: ~y~' .. Config.SpeedLimits['town'] .. 'mph', 5000)
    end
  },

  {
    Pos = {x = 1163.603, y = -1841.771, z = 35.679},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      DrawMissionText('i\'m impressed, but don\'t forget to stay ~r~alert~s~ whilst driving!', 5000)
      PlaySound(-1, 'RACE_PLACED', 'HUD_AWARDS', 0, 0, 1)
    end
  },

  {
    Pos = {x = 235.283, y = -1398.329, z = 28.921},
    Action = function(playerPed, vehicle, setCurrentZoneType)
      function QBCore.Functions.DeleteVehicle(vehicle)
        SetEntityAsMissionEntity(vehicle, true, true)
        DeleteVehicle(vehicle)
      end
    end
  },

}