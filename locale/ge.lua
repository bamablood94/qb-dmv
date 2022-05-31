local Translations = {
    info = {
        open_shop = "[E] მაღაზია",
        sell_chips = "[E] Sell Chips"
    },
    error = {
        dealer_decline = "დილერს არ სურს გაჩვენოთ პროდუქცია ლიცენზიის გარეშე",
        talk_cop = "მიმართეთ ძალოვან სტრუქტურას ლიცენზიის ასაღებად."
    },
    success = {
        dealer_verify = "დილერმა დაადასტურა ლიცენზიის ვარგისიანობა"
    },
}

Lang = Locale:new({phrases = Translations})
