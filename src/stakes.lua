SMODS.Stake {
    name = "Joker Stake",
    key = "joker",
    applied_stakes = { "gold" },
    pos = { x = 4, y = 1 },
    sticker_pos = { x = 3, y = 1 },
     prefix_config = {
        applied_stakes = {
            mod = false
        }
    },
    modifiers = function()
        G.GAME.joker_rate =  G.GAME.joker_rate /2
    end,
    colour = G.C.white,

}