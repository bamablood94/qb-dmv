local Translations = {
    info = {
        open_shop = "[E] Open DMV",
        already_taking = 'You are already taking the driving test.',
        already_took = 'You already took your tests! Go to the City Hall to buy your license.',
        
    },
    error = {
        failed_theory = 'You failed your test!',
        failed_driver = 'You failed the driving test, please try again.',
        driving_fast = 'You are driving too fast. Slow Down',
        damaged_vehicle = 'You damaed the vehicle.',
        errors = 'Errors: %{value} / %{value2}',
        error_paid = 'You paid $ %{value}'
    },
    success = {
        take_driver = 'You are taking the driving Test.',
        passed_theory = 'You passed your test!',
        passed_driver = 'You passed the driving test!',
        passed_theory_giveitem = 'You passed and got your permit. Congradulations!',
        passed_theory_cityhall = 'You passed the test. Go to the city hall to get your permit. Congradulations!',
        passed_theory_pay = 'You paid $ %{value}',
        passed_driver_giveitem = 'You passed and got your drivers license. Congradulations!',
        passed_driver_cityhall = 'You passed! Go to city hall and get your drivers license.',
        passed_driver_pay = 'You paid $ %{value}'
    },
    -- Uses for any Notify script that has a title before the message
    title = {
        take_driver = 'Taking Driving Test',
        passed = 'Passed',
        failed = 'Failed',
        already_taking = 'Already Taking',
        already_took = 'Already Took',
        paid = 'Paid'
    }
}

Lang = Locale:new({phrases = Translations})