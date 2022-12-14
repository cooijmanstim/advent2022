x ← •FLines ⊑ •args

# want to split the list of lines on empty lines
# from BQNcrate:
#groups ← ⟨⟩((⊢-˜+`×¬)∘=⊔⊢)x
# ⊔ collect into groups: 1‿0‿1‿2‿2‿3‿3 ⊔ 4‿5‿6‿6‿4‿7‿5 == [[5] [4 6] [6 4] [7 5]]
# ⊣ ⊢ as dyads return left and right operand respectively (left id, right id)
# = is elementwise equal
#⟨⟩=x  # does not work because I need to specify that ⟨⟩ is to be treated as an atom
#"1000"=x # even this does not work because "1000" is also a sequence
# idea: use ¨ to manually map my operation
#{𝕩="1000"}¨x # that does not work either because = is still elementwise within the map
# 𝕨 ⍷ 𝕩 seems to be the way, which finds occurences of string 𝕨 in superstring 𝕩
# however the empty string of course is a substring of every string
# (in future, ≡ (Match) is for equality)

# ok instead of checking for the empty string, check for length 0
# ⊑≢𝕩 is 𝕩.shape[0]
# ≠¨x would do the same thing
lengths ← {⊑≢𝕩}¨x
emptylines ← lengths=0

# what is ⊢-˜+`×¬ ?
#   ¬ logical not
#   × sign or multiply
#   ` is reduce (left to right)
#   + is add
#   𝔽˜ is swap arguments to 𝔽
#   - is negate or subtract
#   ⊢ right identity

# BQNcrate: a1(⊢-˜+`×¬)⊸⊔y  Split y at 1s in a1, not including cells of y at those locations
# ⊔ collect into groups: 1‿0‿1‿2‿2‿3‿3 ⊔ 4‿5‿6‿6‿4‿7‿5 == [[5] [4 6] [6 4] [7 5]]
# ⊸ is dyadic before: 𝕨 𝔽⊸𝔾 𝕩 == (𝔽 𝕨) 𝔾 𝕩
# so it kinda just reverses the visual ordering of 𝔽 and 𝕨
# 𝕨(⊢-˜+`×¬)⊸⊔𝕩 == ((⊢-˜+`×¬)𝕨)⊔𝕩
# need the extra parentheses, so ⊢-˜+`×¬ parsing depends
# (⊢)-˜(+`×¬)  is how it parses
# same as (+`×¬)-⊢
# (+`×(¬foo))-foo where foo is the argument
# ((+`foo)×(¬foo))-foo is what it is
# so +`×¬ parses to (+`)×(¬) which is a little computation graph
# how does bqn know that ¬ is not data, to which monadic × is applied and then monadic +`?
# I guess ¬ is never data unless marked otherwise. how?
groups←emptylines(⊢-˜+`×¬)⊸⊔x

# next. parse each line into a number
# BQNcrate: (10⊸×⊸+˜´∘⌽ -⟜'0')d1
# not sure why the compose ∘ is needed
Parseint←{𝕨+10×𝕩}´∘⌽ -⟜'0'
numbers ← Parseint¨¨ groups

maxsum ← ⌈´+´¨ numbers
•Show maxsum

# for part two, want sum of top 3
sums ← +´¨ numbers
# taking topk efficiently according to BQNcrate:
# i0{(𝕨↑·⍒⊏⟜𝕩)⊸⊏/𝕩≥(𝕨-1)⊑∨(⌈∘√𝕨⊸×)⊸•rand.Subset∘≠⊸⊏𝕩}n1
# sqrt?? random subset?? :-O  preposterous
# just implement it myself, use fold
top3 ← 0‿0‿0 {3↑∨𝕨∾𝕩}´ sums
•Show +´top3

