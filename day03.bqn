lines ← •FLines ⊑•args

# part one
# for each line, split it into two and find the common character
intersections ← {(((≠𝕩)÷2)↑𝕩) (∊/⊣) (((≠𝕩)÷¯2)↑𝕩)}¨ lines
items ← ⊑¨ intersections
# sum the priorities for each character (a..z -> 1..26, A..Z -> 27..52)
characters ← ('a'+↕26) ∾ ('A'+↕26)
scores ← 1+ ⊑¨ characters⊸⊐¨ items
•Show scores
•Show +´ scores

# part two
# for each three lines, find the common character (i.e. three-way intersection)
# how to group lines into threes?
# BQNcrate: i0(⌊∘÷˜⟜(↕≠)⊔⊢)y  split y into groups of length i0, plus a shorter one at the end if needed
# still pretty opaque
# parenthesized like this:
# i0((⌊∘÷˜⟜(↕≠))⊔⊢)y
# because ∘,⊸ have higher precedence than ⊔
# 3(÷˜⟜(↕≠))↕5 = (↕5)÷3
# then ⌊ takes the floor of that to get integers [[0 0 0] [1 1 1] ...]
# which are the grouping spec for ⊔
triples ← 3 (⌊∘÷˜⟜(↕≠)⊔⊢) lines
items2 ← (⍷∘(∊/⊣))´¨ triples  # reduce each triple by intersection, then deduplicate
•Show items2
scores2 ← 1+ ⊑¨ characters⊸⊐¨ items2
•Show +´ scores2


