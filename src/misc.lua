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
SMODS.Sticker:take_ownership("rental", {
      loc_vars = function(self, info_queue, card)
        return { vars = { G.GAME.rental_rate or 1 } }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and not next(SMODS.find_card("j_nrc_nosteal")) then
            return {
                  dollars = -G.GAME.rental_rate,   
            }
        end
    end
},true)
SMODS.Blind:take_ownership("ox", {
        loc_vars = function(self)
        return { vars = { localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands') } }
    end,
    collection_loc_vars = function(self)
        return { vars = { localize('ph_most_played') } }
    end,
    calculate = function(self, blind, context)
        if blind.disabled then return end
        if context.debuff_hand then
            blind.triggered = false
            if context.scoring_name == G.GAME.current_round.most_played_poker_hand then
                blind.triggered = true
                if not context.check and not next(SMODS.find_card("j_nrc_nosteal")) then
                    return {
                        dollars = -G.GAME.dollars,
                        instant = true,
                        func = function()
                            blind:wiggle()
                        end
                    }
                end
            end
        end
    end
},true)
SMODS.Blind:take_ownership("tooth", {
    key = "tooth",
    dollars = 5,
    mult = 2,
    pos = { x = 0, y = 22 },
    boss = { min = 3 },
    boss_colour = HEX("b52d2d"),
    calculate = function(self, blind, context)
        if blind.disabled  then return end

        if context.press_play and not next(SMODS.find_card("j_nrc_nosteal"))then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    for i = 1, #G.play.cards do
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.play.cards[i]:juice_up()
                                return true
                            end,
                        }))
                        ease_dollars(-1)
                        delay(0.23)
                    end
                    return true
                end
            }))
            blind.triggered = true -- This won't trigger Matador in this context due to a Vanilla bug (a workaround is setting it in context.debuff_hand)
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = (function()
                    SMODS.juice_up_blind()
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.06 * G.SETTINGS.GAMESPEED,
                        blockable = false,
                        blocking = false,
                        func = function()
                            play_sound('tarot2', 0.76, 0.4)
                            return true
                        end
                    }))
                    play_sound('tarot2', 1, 0.4)
                    return true
                end)
            }))
            delay(0.4)
        end
    end
},true)
SMODS.Consumable:take_ownership("wraith" ,{

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                SMODS.add_card({ set = 'Joker', rarity = 'Rare', key_append = 'wra' })
                card:juice_up(0.3, 0.5)
                if G.GAME.dollars ~= 0 and not next(SMODS.find_card("j_nrc_nosteal")) then
                    ease_dollars(-G.GAME.dollars, true)
                end
                return true
            end
        }))
        delay(0.6)
    end,
},true)
