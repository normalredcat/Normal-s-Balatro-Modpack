SMODS.Rarity {
    key = 'nrc_crazy',
    default_weight = 0.002,
    badge_colour = HEX("ff0000"),
    get_weight = function(self, weight, object_type)
        return weight
    end,
    pools ={
        ["Joker"]=true
    }
}