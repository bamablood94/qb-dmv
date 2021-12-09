# esx_dmvschool converted to QBCore with added details
 We all know the old dmvschool from esx. Well welcome it to QBCore framework with a few new details.

# Installation

Insert the below item into the shared.lua of qb-core
```['permit']						 = {['name'] = 'permit',						['label'] = 'Driving Permit',			['weight'] = 0,			['type'] = 'item',		['image'] = 'id_card.png',				['unique'] = true,		['useable'] = true,		['shouldClose'] = false,   ['combinable'] = nil,   ['description'] = 'A Driving permit to show you can drive a vehicle as long as you have a passenger'},```

If you want to give players an id_card instead then go into the server.lua and replace any instance of permit to id_card and don't worry about adding the above line.

# New Details
Added Permit upon completion of Theoretical test
Vehicle will despawn once MaxErrors(can be edited in config.lua) has been reached
Player will be teleported back to the DMV once MaxErrors has been reached.
Theoritcal Test UI has been updated and looks different.
Added ability to only have to take Theoritcal Test(Config.DriversTest) if it is set to false then players will only have to take Theoritcal test to get a Driver's License. Set to True to make players take driving test to get a drivers license.
Maybe others that I can't think of at the moment.

# Planned Details
Add Permit to players table in the database and make default false
Make it so players must be in starting vehicle to complete the drivers test
ETC.
