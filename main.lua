SMODS.Atlas 
{
    key ='placeholder',
    path='placeholder.png',
    px=71,
    py=95
}
assert(SMODS.load_file("src/jokers.lua"))()
assert(SMODS.load_file("src/vouchers.lua"))()
assert(SMODS.load_file("src/stakes.lua"))()
assert(SMODS.load_file("src/rarities.lua"))()
assert(SMODS.load_file("src/spectral.lua"))()
assert(SMODS.load_file("src/misc.lua"))()

