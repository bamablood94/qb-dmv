local Translations = {
    info = {
        open_shop = "[E] Shop",
        sell_chips = "[E] Sell Chips"
    },
    error = {
        dealer_decline = "Der Verkäufer möchte dir keine Schusswaffen zeigen",
        talk_cop = "Rede mit der Polizei um einen Waffenschein zu bekommen"
    },
    success = {
        dealer_verify = "Der verkäufer verifiziert deine Lizenz"
    },
}

Lang = Locale:new({phrases = Translations})
