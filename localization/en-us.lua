return {
    	misc = {
			challenge_names = {},
			dictionary = {
				k_nrc_crazy = "Crazy",
                k_npc_op = "Very OP you will shit yourself"
			},
			labels = {
				k_nrc_crazy = "Crazy",
                k_nrc_op = "Very OP you will shit yourself",
			},
		},
	
	descriptions = {
		Stake = {
			stake_nrc_joker = {
				name = "Joker Stake",
				text = {
					"{C:attention}Jokers{} are less likely to appear on shop",
					"{s:0.8}Applies all previous Stakes",
				},
			},
		},
		Voucher = {
			v_nrc_luckycharm = {
				name = "Lucky Charm",
				text = {
					"{C:attention}Uncommon and {C:attention}Rare Jokers",
					"appear more frequently",
				},
			},
			v_nrc_jackpot = {
				name = "Jackpot",
				text = {
					"{C:attention}Jokers{} appear more frequently",
					"with higher chance to get",
					"rarer jokers",
				},
			},
		},
		Spectral = {
			c_nrc_ectoplasm_fix = {
				name = "Ectoplasm",
				text = {
					"Add {C:dark_edition}Negative{} to",
					"a random {C:attention}Joker",
				},
			},
		},
		Joker = {
			j_nrc_darksimpsons = {
				name = "Dark Joker",
				text = {
					"{X:mult,C:white}X#1#{} Mult, gain {X:mult,C:white}X#2#{} Mult for each",
					"card scored and destroy them",
					"at final hand of round",
				},
			},
			j_nrc_purple = {
				name = "Purple Joker",
				text = {
					"Gives {X:mult,C:white}X#1#{} Mult for",
					"each {C:purple}Purple Seal{}",
					"in your {C:attention}full deck{}",
					"{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
				},
			},
			j_nrc_colorbomb = {
				name = "Color Bomb",
				text = {
					"{X:mult,C:white}X#1#{} Mult",
					"{C:red,E:2}self destructs{} at end of round",
				},
			},
			j_nrc_ursula = {
				name = "Grandma",
				text = {
					"If discarded hand contains 2 cards",
					"of the same rank destroy it and",
					"create a card with the suit of",
					"the left and one rank higher",
					"(Discarded cards' ranks must not be Ace)",
					"(Removes all enhancement, seals and editions)",
				},
			},
			j_nrc_PNM = {
				name = "Photo-Negative Joker",
				text = {
					"Gain {X:mult,C:white}X#1#{} Mult for every",
					"{C:attention}Negative{} Joker and remove",
					"{C:attention}Ectoplasm{}'s downside",
					"{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
					"{s:0.8}(Scale Polynomial degree-2)",
				},
			},
			j_nrc_noA = {
				name = "0xA",
				text = {
					"{X:mult,C:white}X#1#{} Mult if played hand",
					"doesn't contain any Ace",
				},
			},
			j_nrc_nosteal = {
				name = "ORGINAL MONEY DO NOT STEAL",
				text = {
					"Halves money loss (rounds down) when",
					"losing money (except shops and rerolls)",
				},
			},
			j_nrc_betonsomething = {
				name = "Always bet on... something?",
				text = {
					"{X:mult,C:black}X#1#{} blind requiremnt",
					"{C:attention}$#2#{} at end of round",
				},
			},
			j_nrc_palindrome = {
				name = "Palindrome",
				text = {
					"This joker gain {C:chips}+#4#{} Chips",
					"and {C:red}+#2#{} Mult if scoring hand",
					"is palindrome and contains atleast 3 cards",
					"(Currently {C:chips}+#1#{} Chips and {C:red}+#1#{} Mult)",
					"{s=0.6}{C:inactive}(Special thanks to rhelv on discord for helping me)",
				},
			},
		},
    }
}
