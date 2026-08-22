SMODS.Consumable:take_ownership("c_ectoplasm",{
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
        if next(SMODS.find_card("j_nrc_PNM")) then
            return { key = "c_nrc_ectoplasm_fix" or nil }
        else
            return { vars = { G.GAME.ecto_minus or 1 } }
        end
    end,
    use = function(self, card, area, copier)
        local editionless_jokers = SMODS.Edition:get_edition_cards(G.jokers, true)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()

                local eligible_card = pseudorandom_element(editionless_jokers, 'c_ectoplasm')
                eligible_card:set_edition("e_negative")
                card:juice_up(0.3, 0.5)
                if not next(SMODS.find_card("j_nrc_PNM")) then
                G.GAME.ecto_minus = G.GAME.ecto_minus or 1
                G.hand:change_size(-G.GAME.ecto_minus)
                G.GAME.ecto_minus = G.GAME.ecto_minus + 1
                end
                return true
            end
        }))
    end,
    can_use = function(self, card)
        return next(SMODS.Edition:get_edition_cards(G.jokers, true))
    end,
    draw = function(self, card, layer)
        -- This is for the Spectral shader. You don't need this with `set = "Spectral"`
        -- Also look into SMODS.DrawStep if you make multiple cards that need the same shader
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
            card.children.center:draw_shader('booster', nil, card.ARGS.send_to_shader)
        end
    end

},true)
SMODS.Rarity:take_ownership("Legendary",{
    default_weight = 0,
   
    badge_colour = HEX("b26cbb"),
    pools ={
        ["Joker"]=true
    },
    get_weight = function(self, weight, object_type)
        if G.GAME.used_vouchers["v_nrc_jackpot"] then
           return 0.1
        end
        return weight
    end,

},true)

