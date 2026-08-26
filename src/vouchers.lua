SMODS.Voucher {
    key = 'luckycharm',
    atlas= 'placeholder',
    pos = { x = 0, y = 0 },
    config = { extra = { uncommon_rate=2,rare_rate=2.5, display = 2 } },
    unlocked = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.display, } }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.uncommon_mod = G.GAME.uncommon_mod * card.ability.extra.uncommon_rate
                G.GAME.rare_mod = G.GAME.rare_mod * card.ability.extra.uncommon_rate
                return true
            end
        }))
    end,
 
}
SMODS.Voucher {
    key = 'jackpot',
    atlas= 'placeholder',
    pos = { x = 0, y = 0 },
    config = { extra = { joker_rate=2,uncommon_rate=1.5,rare_rate=2.5,crazy_rate=5, display = 2 } },
    requires = { 'v_nrc_luckycharm' },
    unlocked = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.display, } }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.joker_rate= G.GAME.joker_rate * card.ability.extra.joker_rate
                G.GAME.uncommon_mod = G.GAME.uncommon_mod * card.ability.extra.uncommon_rate
                G.GAME.rare_mod = G.GAME.rare_mod * card.ability.extra.uncommon_rate
                G.GAME.nrc_crazy_mod = G.GAME.nrc_crazy_mod * card.ability.extra.crazy_rate
                return true
            end
        }))
    end,
 
}