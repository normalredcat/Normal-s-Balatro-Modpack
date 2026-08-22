--#region Dark Simpsons
SMODS.Joker {
    key = 'darksimpsons',
    atlas= 'placeholder',
    pos = {
        x=0,
        y=0
    },
    config = {
        extra =  {
            xmults = 1,
            scaling=0.1
        }
    },
    rarity = 3,
    perishable_compat = false,
    cost = 8,
    loc_vars = function (self,info_queue,card)
         return {
                vars = {
                    card.ability.extra.xmults,
                    card.ability.extra.scaling
                }

            }
    end,
calculate = function(self, card, context)
    if context.joker_main then
        return {
            xmult=  card.ability.extra.xmults
        }
    end


    if context.destroying_card and not context.blueprint and G.GAME.current_round.hands_left == 0 then
        SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = 'xmults',
            scalar_value ='scaling',
            
       })
          return {   
                remove = true,
               
            }
    end
end
}
--#endregion
--#region Purple Joker
SMODS.Joker {
    key = "purple",
    atlas= 'placeholder',
    blueprint_compat = true,
    rarity = 3,
    cost = 9,
    pos = { x = 1, y = 0 },
    config = { extra = { xmult = 1 } },
    loc_vars = function(self, info_queue, card)
      --  info_queue[#info_queue + 1] = G.P_CENTERS.m_stone

        local purple_seal = 0
        if G.playing_cards then
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:get_seal() == 'Purple' then purple_seal = purple_seal + 1 end
            end
        end
        return { vars = { card.ability.extra.xmult, card.ability.extra.xmult * (purple_seal+1) } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local purple_seal = 1
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:get_seal() == 'Purple' then purple_seal = purple_seal + 1
                end
            end
            return {
                xmult = card.ability.extra.xmult * purple_seal,
          
            }
        end
    end,
    in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
            for _, playing_card in ipairs(G.playing_cards) do
                if playing_card:get_seal() == 'purple'  then
                return true
            end
        end
        return false
    end
}
--#endregion
--#region Color Bomb
SMODS.Joker {
    key = "colorbomb",
    atlas= 'placeholder',
    blueprint_compat = true,
    rarity = 1,
    cost = 6,
     eternal_compat = false,
    perishable_compat = false,
    pos = { x = 3, y = 0 },
    config = { extra = { xmult = 10 } },
    loc_vars = function (self,info_queue,card)
        return {
            vars = {
                card.ability.extra.xmult,
                }
            }
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
            SMODS.destroy_cards(card, nil, nil, true)
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.RED
                }
        end        
        if context.joker_main then
            return {
                xmult =card.ability.extra.xmult,
                
            }
        end
    end
  
}
SMODS.Joker {
    key = "ursula",
    atlas= 'placeholder',
    blueprint_compat = false,
    rarity = 2,
    cost = 7,
    pos = { x = 2, y = 0 },

    calculate = function(self, card, context)
    if context.discard and not context.blueprint and #context.full_hand == 2 
    and context.full_hand[1]:get_id() == context.full_hand[2]:get_id() and context.full_hand[1]:get_id() ~= 14 then
    if context.other_card == context.full_hand[1] then
        local card_copied = SMODS.copy_card(context.full_hand[1])
        assert(SMODS.modify_rank(card_copied, 1))
        card_copied.states.visible = nil
            G.E_MANAGER:add_event(Event({
                func = function()
                    card_copied:start_materialize()
                    return true
                end
            }))
        end    
            return {   
                remove = true,
                delay = 0.45
            }
        end  
    end
}
SMODS.Joker {
    key = "PNM",
    atlas= 'placeholder',
    blueprint_compat = true,
    rarity = 'nrc_crazy',
    cost = 12,
    pos = { x = 4, y = 0 },
    config = { extra = { xmult = 1 } },
    loc_vars = function(self, info_queue, card)
        local negative_count = 1
        if G.jokers ~= nil then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].edition and G.jokers.cards[i].edition.negative and 
                G.jokers.cards[i].ability.set == 'Joker' then 
                    negative_count = negative_count + 1 end
                end
        end
        return { vars = { card.ability.extra.xmult*negative_count+1, card.ability.extra.xmult*negative_count*(negative_count+1)/2 } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local negative_count = 1
        for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].edition and G.jokers.cards[i].edition.negative and
        G.jokers.cards[i].ability.set == 'Joker'
        then negative_count = negative_count + 1 end
        end
            return {
                xmult =  negative_count*(negative_count+1)/2
            }
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
       G.GAME.ecto_minus = 1
    end
}
--[[
local smods_PNM_ref = SMODS.PNM
function SMODS.PNM(...)
    if next(SMODS.find_card('j_nrc_PNM')) then
         G.GAME.ecto_minus = 0
         return true
    end
    return smods_PNM_ref(...)
end]]
SMODS.Joker {
    key = "noA",
    atlas= 'placeholder',
    blueprint_compat = true,
    rarity = 'nrc_crazy',
    cost = 15,
    pos = { x = 0, y = 1 },
    config = { extra = { xmult = 14 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
        for i=1,#context.full_hand,1 do 
            if context.full_hand[i]:get_id()==14 then
            return
            end
        end
        return {xmult = card.ability.extra.xmult}
    end
end
}