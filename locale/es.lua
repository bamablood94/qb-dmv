
local Translations = {
    info = {
        open_shop = "[E] Tienda",
        sell_chips = "[E] Sell Chips"
    },
    error = {
        dealer_decline = "El distribuidor se niega a mostrarle las armas de fuego",
        talk_cop = "Hable con la policía para obtener una licencia de armas de fuego"
    },
    success = {
        dealer_verify = "El distribuidor verifica su licencia"
    },
}

Lang = Locale:new({phrases = Translations})
