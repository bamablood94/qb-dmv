local Translations = {
    info = {
        open_shop = "[E] Obchod",
        sell_chips = "[E] Sell Chips"
    },
    error = {
        dealer_decline = "Prodejce zbraní vám nechce ukázat zbraně na prodej",
        talk_cop = "Promluvte si s policií pro získaní zbrojního průkazu"
    },
    success = {
        dealer_verify = "Prodejce úspěšně ověříl vaší licenci"
    },
}

Lang = Locale:new({phrases = Translations})
