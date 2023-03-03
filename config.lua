Config = {}

Config.UseTarget = true                                       -- (true | false)
Config.FuelResource = 'LegacyFuel'                            -- (LegacyFuel | lj-fuel | cdn-fuel)<--Which fuel reource are you using?
Config.VehPlate = 'DMV '..math.random(100, 999)               -- Plate Text that comes on a DMV vehicle when spawned
Config.CommandName = 'resetlicense'                           -- Command to reset a players license meta back to false. (permit | driver | cdl | bike)


Config.PaymentType = 'cash'                                   -- (cash | bank) What account to use for payment
Config.DriversTest = true                                     -- (true | false) Take the physical Driving Test or Not
Config.SpeedMultiplier = 'mph'                                -- ('mph' | 'kmh')
Config.MaxErrors       = 100                                   -- Max Amount of Errors for Driving Test before Failing.
Config.PlayerCoordsAfterTest = vector4(222.85, -1392.84, 30.59, 310.38) -- Teleport Players to Coords after passing/failing drivers test.

Config.BikeEndorsement = true                                 -- (true | false) Adds "Motorcycle Endorsement" to Drivers License else uses a seperate Bike License

Config.Locations = {  -- Coords and Ped to Spawn
  [1] = {
    pedModel = `s_m_y_cop_01`, 
    coords = vector4(214.6, -1400.15, 30.58, 324.82),
    blip = {
      showblip = true,
      blipsprite = 380,
      blipscale = 0.7,
      blipcolor = 1,
      label = 'DMV School'
    }
  },
}

Config.GiveItem = true                                      -- (true | false) If false then player will have to go to city hall to get the licenses
Config.Items = {                                            -- if config.giveitem = true then use this to give the item for each test
  ['driver'] = 'driver_license',
  ['cdl'] = 'cdl_license',
  ['bike'] = 'bike_license'
}


Config.Amount = {
    ['theoritical'] = 50,                                     --theoretical test payment amount(If Config.DriversTest = false then the theoritical test will go to the drivers test amount.)
    ['driver']      = 150,                                     --Drivers Test Payment Amount
    ['cdl']         = 250,                                    --CDL Test Payment Amount
    ['bike']        = 125                                     -- Bike Test Payment
}

Config.Blip = {                                             -- Blip Config
  Sprite = 380,
  Display = 4,
  Color = 1,
  Scale = 0.8,
  ShortRange = true,
  BlipName = 'DMV'
}

Config.VehicleModels = {                                    -- Vehicle to Spawn with Driver Test
  ['driver'] = 'sultan',
  ['cdl'] = 'stockade',
  ['bike'] = 'sanchez'
}

Config.SpeedLimits = {                                      -- Speed Limits in each zone
  residence = 35,
  town      = 55,
  freeway   = 80
}

Config.NewCheckPoints = { -- Can now determine different locations for each type of test
  ['driver'] = { 
    ['startingzone'] = 'residence', -- What zone is the player starting in? (residence | freeway | town)
    ['startingpoint'] = vector4(222.41, -1387.88, 30.11, 270.57), -- Where the vehicle spawns

    ['checkpoints'] = { -- Each Check Point for the Test
      -- EXAMPLE:
      --[[
        {
          pos = (vector3) Where the marker will be,
          txt = The text that will show when the player has reached this marker,
          playsound = (true | false) Will Play a hud sound when reached this marker
          freezePlayer = (true | false) Will freeze the player and vehicle for 3 seconds at this marker,
          txt2 = Text that will show up 3 seconds after the first txt.
          currentzone = determines a new zone(residence | town | freeway) This is so the speed Check will be correct
          endpoint = (true) -- Only use this for the LAST checkpoint for the Test as this will delete the Car and teleport the player to Config.PlayerCoordsAfterTest
        }
      ]]
      {
        pos = vector3(255.139, -1400.731, 29.537),
        txt = 'Go to the next point! Speed Limit: ~y~'..Config.SpeedLimits['residence']..' '..Config.SpeedMultiplier,
      },
      {
        pos = vector3(271.874, -1370.574, 30.932),
        txt = 'Go to next point',
      },
      {
        pos = vector3(234.907, -1345.385, 29.542),
        txt = '~r~Stop~s~ for the pedestrian ~y~crossing',
        playsound = true,
        freezePlayer = true,
        txt2 = '~g~Good~s~, continue.'
      },
      {
        pos = vector3(217.821, -1410.520, 28.292),
        txt = '~r~Stop~s~ and look ~y~Left~s~. Speed Limit:~y~ '..Config.SpeedLimits['town']..' '..Config.SpeedMultiplier,
        playsound = true,
        freezePlayer = true,
        txt2 = '~g~Good~s~, turn right and follow the line.',
        currentzone = 'town'
      },
      {
        pos = vector3(178.550, -1401.755, 27.725),
        txt = 'Go to the next point.',
      },
      {
        pos = vector3(113.160, -1365.276, 27.725),
        txt = 'Go to the next point.',
      },
      {
        pos = vector3(-73.542, -1364.335, 27.789),
        txt = '~r~Stop~s~ for passing vehicles!',
        playsound = true,
        freezePlayer = true
      },
      {
        pos = vector3(-355.143, -1420.282, 27.868),
        txt = 'Go to the Next Point.'
      },
      {
        pos = vector3(-439.148, -1417.100, 27.704),
        txt = 'Go to the Next Point.',
      },
      {
        pos = vector3(-453.790, -1444.726, 27.665),
        txt = 'It\'s time to drive on the highway! Speed Limit:~y~ '..Config.SpeedLimits['freeway']..' '..Config.SpeedMultiplier,
        playsound = true,
        currentzone = 'freeway',
      },
      {
        pos = vector3(-463.237, -1592.178, 37.519),
        txt = 'Go to the Next Point.',
      },
      {
        pos = vector3(-900.647, -1986.28, 26.109),
        txt = 'Go to the Next Point.',
      },
      {
        pos = vector3(1225.759, -1948.792, 38.718),
        txt = 'Entered Town. Pay attention to you speed! Speed Limit:~y~ '..Config.SpeedLimits['town']..' '..Config.SpeedMultiplier,
        currentzone = 'town',
      },
      {
        pos = vector3(1163.603, -1841.771, 35.679),
        txt = 'I\'m Impressed, but don\'t forget to stay ~r~ALERT~s~ whilst Driving.',
      },
      {
        pos = vector3(235.283, -1398.329, 28.921),
        endpoint = true,
      }
    }
  },
  ['cdl'] = { 
    ['startingzone'] = 'residence', -- What zone is the player starting in? (residence | freeway | town)
    ['startingpoint'] = vector4(222.41, -1387.88, 30.11, 270.57), -- Where the vehicle spawns

    ['checkpoints'] = { -- Each Check Point for the Test
      -- EXAMPLE:
      --[[
        {
          pos = (vector3) Where the marker will be,
          txt = The text that will show when the player has reached this marker,
          playsound = (true | false) Will Play a hud sound when reached this marker
          freezePlayer = (true | false) Will freeze the player and vehicle for 3 seconds at this marker,
          txt2 = Text that will show up 3 seconds after the first txt.
          currentzone = determines a new zone(residence | town | freeway) This is so the speed Check will be correct
          endpoint = (true) -- Only use this for the LAST checkpoint for the Test as this will delete the Car and teleport the player to Config.PlayerCoordsAfterTest
        }
      ]]
      {
        pos = vector3(255.139, -1400.731, 29.537),
        txt = 'Go to the next point! Speed Limit: ~y~'..Config.SpeedLimits['residence']..' '..Config.SpeedMultiplier,
      },
      {
        pos = vector3(271.874, -1370.574, 30.932),
        txt = 'Go to next point',
      },
      {
        pos = vector3(234.907, -1345.385, 29.542),
        txt = '~r~Stop~s~ for the pedestrian ~y~crossing',
        playsound = true,
        freezePlayer = true,
        txt2 = '~g~Good~s~, continue.'
      },
      {
        pos = vector3(217.821, -1410.520, 28.292),
        txt = '~r~Stop~s~ and look ~y~Left~s~. Speed Limit:~y~ '..Config.SpeedLimits['town']..' '..Config.SpeedMultiplier,
        playsound = true,
        freezePlayer = true,
        txt2 = '~g~Good~s~, turn right and follow the line.',
        currentzone = 'town'
      },
      {
        pos = vector3(178.550, -1401.755, 27.725),
        txt = 'Go to the next point.',
      },
      {
        pos = vector3(113.160, -1365.276, 27.725),
        txt = 'Go to the next point.',
      },
      {
        pos = vector3(-73.542, -1364.335, 27.789),
        txt = '~r~Stop~s~ for passing vehicles!',
        playsound = true,
        freezePlayer = true
      },
      {
        pos = vector3(-355.143, -1420.282, 27.868),
        txt = 'Go to the Next Point.'
      },
      {
        pos = vector3(-439.148, -1417.100, 27.704),
        txt = 'Go to the Next Point.',
      },
      {
        pos = vector3(-453.790, -1444.726, 27.665),
        txt = 'It\'s time to drive on the highway! Speed Limit:~y~ '..Config.SpeedLimits['freeway']..' '..Config.SpeedMultiplier,
        playsound = true,
        currentzone = 'freeway',
      },
      {
        pos = vector3(-463.237, -1592.178, 37.519),
        txt = 'Go to the Next Point.',
      },
      {
        pos = vector3(-900.647, -1986.28, 26.109),
        txt = 'Go to the Next Point.',
      },
      {
        pos = vector3(1225.759, -1948.792, 38.718),
        txt = 'Entered Town. Pay attention to you speed! Speed Limit:~y~ '..Config.SpeedLimits['town']..' '..Config.SpeedMultiplier,
        currentzone = 'town',
      },
      {
        pos = vector3(1163.603, -1841.771, 35.679),
        txt = 'I\'m Impressed, but don\'t forget to stay ~r~ALERT~s~ whilst Driving.',
      },
      {
        pos = vector3(235.283, -1398.329, 28.921),
        endpoint = true,
      }
    }
  },
  ['bike'] = { 
    ['startingzone'] = 'residence', -- What zone is the player starting in? (residence | freeway | town)
    ['startingpoint'] = vector4(222.41, -1387.88, 30.11, 270.57), -- Where the vehicle spawns

    ['checkpoints'] = { -- Each Check Point for the Test
      -- EXAMPLE:
      --[[
        {
          pos = (vector3) Where the marker will be,
          txt = The text that will show when the player has reached this marker,
          playsound = (true | false) Will Play a hud sound when reached this marker
          freezePlayer = (true | false) Will freeze the player and vehicle for 3 seconds at this marker,
          txt2 = Text that will show up 3 seconds after the first txt.
          currentzone = determines a new zone(residence | town | freeway) This is so the speed Check will be correct
          endpoint = (true) -- Only use this for the LAST checkpoint for the Test as this will delete the Car and teleport the player to Config.PlayerCoordsAfterTest
        }
      ]]
      {
        pos = vector3(255.139, -1400.731, 29.537),
        txt = 'Go to the next point! Speed Limit: ~y~'..Config.SpeedLimits['residence']..' '..Config.SpeedMultiplier,
      
      },
      {
        pos = vector3(271.874, -1370.574, 30.932),
        txt = 'Go to next point',
      },
      {
        pos = vector3(234.907, -1345.385, 29.542),
        txt = '~r~Stop~s~ for the pedestrian ~y~crossing',
        playsound = true,
        freezePlayer = true,
        txt2 = '~g~Good~s~, continue.'
      },
      {
        pos = vector3(217.821, -1410.520, 28.292),
        txt = '~r~Stop~s~ and look ~y~Left~s~. Speed Limit:~y~ '..Config.SpeedLimits['town']..' '..Config.SpeedMultiplier,
        playsound = true,
        freezePlayer = true,
        txt2 = '~g~Good~s~, turn right and follow the line.',
        currentzone = 'town'
      },
      {
        pos = vector3(178.550, -1401.755, 27.725),
        txt = 'Go to the next point.',
      },
      {
        pos = vector3(113.160, -1365.276, 27.725),
        txt = 'Go to the next point.',
      },
      {
        pos = vector3(-73.542, -1364.335, 27.789),
        txt = '~r~Stop~s~ for passing vehicles!',
        playsound = true,
        freezePlayer = true
      },
      {
        pos = vector3(-355.143, -1420.282, 27.868),
        txt = 'Go to the Next Point.'
      },
      {
        pos = vector3(-439.148, -1417.100, 27.704),
        txt = 'Go to the Next Point.',
      },
      {
        pos = vector3(-453.790, -1444.726, 27.665),
        txt = 'It\'s time to drive on the highway! Speed Limit:~y~ '..Config.SpeedLimits['freeway']..' '..Config.SpeedMultiplier,
        playsound = true,
        currentzone = 'freeway',
      },
      {
        pos = vector3(-463.237, -1592.178, 37.519),
        txt = 'Go to the Next Point.',
      },
      {
        pos = vector3(-900.647, -1986.28, 26.109),
        txt = 'Go to the Next Point.',
      },
      {
        pos = vector3(1225.759, -1948.792, 38.718),
        txt = 'Entered Town. Pay attention to you speed! Speed Limit:~y~ '..Config.SpeedLimits['town']..' '..Config.SpeedMultiplier,
        currentzone = 'town',
      },
      {
        pos = vector3(1163.603, -1841.771, 35.679),
        txt = 'I\'m Impressed, but don\'t forget to stay ~r~ALERT~s~ whilst Driving.',
      },
      {
        pos = vector3(235.283, -1398.329, 28.921),
        endpoint = true,
      }
    }
  },
}