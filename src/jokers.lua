--#region Dark Simpsons
SMODS.Joker({
	key = "darksimpsons",
	atlas = "placeholder",
	pos = {
		x = 0,
		y = 0,
	},
	config = {
		extra = {
			xmults = 1,
			scaling = 0.15,
		},
	},
	rarity = 3,
	perishable_compat = false,
	cost = 8,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmults,
				card.ability.extra.scaling,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmults,
			}
		end
		--[[] if
			context.after
			and context.scoring_hand
			and not context.blueprint
            and G.GAME.current_round.hands_left == 0
		then
            for j = 1, #context.scoring_hand do
							 SMODS.scale_card(card, {
            ref_table = card.ability.extra,
            ref_value = 'xmults',
            scalar_value ='scaling',
            
       })
          return {   
                remove = true,
               
            }
		end]]

		if context.destroying_card and not context.blueprint and G.GAME.current_round.hands_left == 0 then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "xmults",
				scalar_value = "scaling",
			})
			return {
				remove = true,
			}
		end
	end,
})
--#endregion
--#region Purple Joker
SMODS.Joker({
	key = "purple",
	atlas = "placeholder",
	blueprint_compat = true,
	rarity = 3,
	cost = 9,
	pos = { x = 1, y = 0 },
	config = { extra = { xmult = 1, odds = 8 } },
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
		info_queue[#info_queue + 2] = G.P_CENTERS.m_purple_seal

		local purple_seal = 0
		if G.playing_cards then
			for _, playing_card in ipairs(G.playing_cards) do
				if playing_card:get_seal() == "Purple" then
					purple_seal = purple_seal + 1
				end
			end
		end
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "nrc_purple")
		return {
			vars = { card.ability.extra.xmult, card.ability.extra.xmult * (purple_seal + 1), numerator, denominator },
		}
	end,
	calculate = function(self, card, context)
		if context.after and context.scoring_hand and not context.blueprint then
			G.E_MANAGER:add_event(Event({
				trigger = "before",
				delay = 1.3,
				func = function() -- i can't figure out how to split these events without making em look bad so you get this?
					for j = 1, #context.scoring_hand do
						if
							not context.scoring_hand[j].seal
							and SMODS.pseudorandom_probability(card, "nrc_purple", 1, card.ability.extra.odds)
						then
							context.scoring_hand[j]:set_seal("Purple")
							context.scoring_hand[j]:juice_up()
						end
					end
					play_sound("gold_seal", 1.2, 0.4)
					card:juice_up()
					return true
				end,
			}))
			return nil, true
		end
		if context.joker_main then
			local purple_seal = 1
			for _, playing_card in ipairs(G.playing_cards) do
				if playing_card:get_seal() == "Purple" then
					purple_seal = purple_seal + 1
				end
			end
			return {
				xmult = card.ability.extra.xmult * purple_seal,
			}
		end
	end,
	in_pool = function(self, args) --equivalent to `enhancement_gate = 'm_stone'`
		for _, playing_card in ipairs(G.playing_cards) do
			if playing_card:get_seal() == "Purple" then
				return true
			end
		end
		return false
	end,
})
--#endregion
--#region Color Bomb
SMODS.Joker({
	key = "colorbomb",
	atlas = "placeholder",
	blueprint_compat = true,
	rarity = 1,
	cost = 6,
	eternal_compat = false,
	perishable_compat = false,
	pos = { x = 3, y = 0 },
	config = { extra = { xmult = 10 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.xmult,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			SMODS.destroy_cards(card, nil, nil, true)
			return {
				message = localize("k_eaten_ex"),
				colour = G.C.RED,
			}
		end
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult,
			}
		end
	end,
})
SMODS.Joker({
	key = "ursula",
	atlas = "placeholder",
	blueprint_compat = false,
	rarity = 2,
	cost = 7,
	pos = { x = 2, y = 0 },

	calculate = function(self, card, context)
		if
			context.discard
			and not context.blueprint
			and #context.full_hand == 2
			and context.full_hand[1]:get_id() == context.full_hand[2]:get_id()
			and context.full_hand[1]:get_id() ~= 14
		then
			if context.other_card == context.full_hand[1] then
				local card_copied = SMODS.copy_card(context.full_hand[1])
				assert(SMODS.modify_rank(card_copied, 1))
				card_copied.states.visible = nil
				G.E_MANAGER:add_event(Event({
					func = function()
						card_copied:start_materialize()
						return true
					end,
				}))
			end
			return {
				remove = true,
				delay = 0.45,
			}
		end
	end,
})
SMODS.Joker({
	key = "PNM",
	atlas = "placeholder",
	blueprint_compat = true,
	rarity = "nrc_crazy",
	cost = 12,
	pos = { x = 4, y = 0 },
	config = { extra = { xmult = 1 } },
	loc_vars = function(self, info_queue, card)
		local negative_count = 1
		if G.jokers ~= nil then
			for i = 1, #G.jokers.cards do
				if
					G.jokers.cards[i].edition
					and G.jokers.cards[i].edition.negative
					and G.jokers.cards[i].ability.set == "Joker"
				then
					negative_count = negative_count + 1
				end
			end
		end
		return {
			vars = {
				card.ability.extra.xmult * negative_count + 1,
				card.ability.extra.xmult * negative_count * (negative_count + 1) / 2,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			local negative_count = 1
			for i = 1, #G.jokers.cards do
				if
					G.jokers.cards[i].edition
					and G.jokers.cards[i].edition.negative
					and G.jokers.cards[i].ability.set == "Joker"
				then
					negative_count = negative_count + 1
				end
			end
			return {
				xmult = negative_count * (negative_count + 1) / 2,
			}
		end
	end,
	remove_from_deck = function(self, card, from_debuff)
		G.GAME.ecto_minus = 1
	end,
})
--[[
local smods_PNM_ref = SMODS.PNM
function SMODS.PNM(...)
    if next(SMODS.find_card('j_nrc_PNM')) then
         G.GAME.ecto_minus = 0
         return true
    end
    return smods_PNM_ref(...)
end]]
SMODS.Joker({
	key = "noA",
	atlas = "placeholder",
	blueprint_compat = true,
	rarity = "nrc_crazy",
	cost = 15,
	pos = { x = 0, y = 1 },
	config = { extra = { xmult = 14 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.joker_main then
			for i = 1, #context.full_hand, 1 do
				if context.full_hand[i]:get_id() == 14 then
					return
				end
			end
			return { xmult = card.ability.extra.xmult }
		end
	end,
})
SMODS.Joker({
	key = "nosteal",
	atlas = "placeholder",
	blueprint_compat = false,
	rarity = 3,
	cost = 15,
	pos = { x = 1, y = 1 },
	--[[
    add_to_deck = function(self, card, from_debuff)
        G.GAME.rental_rate = 0
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.rental_rate = 3
    end
]]
})
SMODS.Joker({
	key = "betonsomething",
	atlas = "placeholder",
	blueprint_compat = false,
	rarity = 2,
	cost = 8,
	pos = { x = 2, y = 1 },
	config = { extra = { blind = 2, extra_money = 8 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.blind, card.ability.extra.extra_money } }
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.blind
			G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
		end
	end,
	calc_dollar_bonus = function(self, card)
		return card.ability.extra.extra_money
	end,
})
SMODS.Joker({
	key = "palindrome",
	atlas = "placeholder",
	blueprint_compat = false,
	rarity = 1,
	cost = 5,
	perishable_compat = false,
	pos = { x = 4, y = 1 },
	config = { extra = { mult = 0, multscaling = 1, chips = 0, chipscaling = 3 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.multscaling,
				card.ability.extra.chips,
				card.ability.extra.chipscaling,
			},
		}
	end,

	calculate = function(_, card, context)
		if context.before and not context.blueprint then
			if
				isPalindromic(context.scoring_hand, function(a, b)
					return (a:get_id() == b:get_id())
				end) and #context.scoring_hand > 2
			then
				return SMODS.scale_card(card, {
					ref_table = card.ability.extra,
					ref_value = "mult",
					scalar_value = "multscaling",
				}),
					SMODS.scale_card(card, {
						ref_table = card.ability.extra,
						ref_value = "chips",
						scalar_value = "chipscaling",
					})
			end
		end

		if context.joker_main then
			return {
				chips = card.ability.extra.chips,
				mult = card.ability.extra.mult,
			}
		end
	end,
})
function isPalindromic(arr, comp)
	---@type fun(a: T, b: T): boolean
	local eq = comp or function(a, b)
		return a == b
	end

	local n = #arr
	-- An empty array or a single-element array is trivially palindromic
	for i = 1, math.floor(n / 2) do
		if not eq(arr[i], arr[n - i + 1]) then
			return false
		end
	end

	return true
end
SMODS.Joker({
	key = "99",
	blueprint_compat = true,
	rarity = 3,
	atlas = "placeholder",
	cost = 9,
	pos = { x = 3, y = 1 },
	config = { extra = { repetitions = 1, chips = 99, mult = 9 } },
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.mult,
				card.ability.extra.repetitions,
				card.ability.extra.chips,
			},
		}
	end,

	calculate = function(self, card, context)
		if
			context.repetition
			and ((context.cardarea == G.hand and (next(context.card_effects[1]) or #context.card_effects > 1)) or context.cardarea == G.hand)
			and context.other_card:get_id() == 9
		then
			return {
				repetitions = card.ability.extra.repetitions,
			}
		end
		if context.individual and context.cardarea == G.play and context.other_card:get_id() == 9 then
			return {
				mult = card.ability.extra.mult,
				chips = card.ability.extra.chips,
			}
		end
	end,
})
SMODS.Joker({
	key = "74",
	blueprint_compat = true,
	rarity = 1,
	cost = 6,
	atlas = "placeholder",
	pos = { x = 0, y = 2 },
	config = { extra = { chips = 74, numerator = 74, denominator = 1000 } },
	loc_vars = function(self, info_queue, card)
		local numerator, denominator =
			SMODS.get_probability_vars(card, card.ability.extra.numerator, card.ability.extra.denominator, "nrc_74")
		return {
			vars = {
				card.ability.extra.chips,
				numerator,
				denominator,
			},
		}
	end,
	calculate = function(self, card, context)
		if
			context.individual
			and context.cardarea == G.play
			and (context.other_card:get_id() == 7 or context.other_card:get_id() == 4)
		then
			return {
				chips = card.ability.extra.chips,
			}
		end
		if
			context.end_of_round
			and context.game_over == false
			and SMODS.pseudorandom_probability(
				card,
				"nrc_74",
				card.ability.extra.numerator,
				card.ability.extra.denominator
			)
		then
			SMODS.destroy_cards(card, nil, nil, true)
			return {
				message = localize("k_extinct_ex"),
			}
		else
			return {
				message = localize("k_safe_ex"),
			}
		end
	end,
})
SMODS.Joker({
	key = "pancake",
	blueprint_compat = true,
	eternal_compat = false,
	rarity = 1,
	cost = 6,
	atlas = "placeholder",
	pos = { x = 1, y = 2 },
	config = { extra = { dollars = 7, reducerate = 1 } },
   loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.extra.dollars,
				card.ability.extra.reducerate,
			},
		}
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false then
			return {
				dollars = card.ability.extra.dollars,
				func = function() -- i can't figure out how to split these events without making em look bad so you get this?
					card.ability.extra.dollars = card.ability.extra.dollars - 1
				end,
				message = localize({
					type = "variable",
					key = "a_mult_minus",
					vars = { card.ability.extra.reducerate },
				}),
			}
		end
	end,
})
SMODS.Joker({
	key = "star",
	blueprint_compat = true,
	rarity = "nrc_op",
	cost = 6,
	atlas = "placeholder",
	pos = { x = 2, y = 2 },
	config = { extra = { emult = 2, scalar = 0.25 } },
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and G.GAME.dollars >= 100 and not context.blueprint then
			SMODS.scale_card(card, {
				ref_table = card.ability.extra,
				ref_value = "emult",
				scalar_value = "scalar",
			})
		end
		if context.joker_main then
			return { emult = card.ability.extra.emult }
		end
	end,
})
SMODS.Joker({
	key = "eye",
	blueprint_compat = true,
	rarity = "nrc_op",
	cost = 6,
	atlas = "placeholder",
	pos = { x = 3, y = 2 },
	config = { extra = { emult = 1, highscalar = 0.15, lowscalar = 0.1 } },
	calculate = function(self, card, context)
		if context.before and not context.blueprint then
			if not context.debuff_hand and G.GAME.hands[context.scoring_name].level > 1 then
				return {
					level_up = -1,
					func = function()
						local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
						local most_played_poker_hand = false
						for handname, values in pairs(G.GAME.hands) do
							if
								handname ~= context.scoring_name
								and values.played >= play_more_than
								and SMODS.is_poker_hand_visible(handname)
							then
								most_played_poker_hand = true
							end
                        end
							if most_played_poker_hand then
								SMODS.scale_card(card, {
									ref_table = card.ability.extra,
									ref_value = "emult",
									scalar_value = "lowscalar",
								})
							else
								SMODS.scale_card(card, {
									ref_table = card.ability.extra,
									ref_value = "emult",
									scalar_value = "highscalar",
								})
							end
						end
				}
			end
		end

		if context.joker_main then
			return { emult = card.ability.extra.emult }
		end
	end,
})
