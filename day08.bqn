lines ← •FLines ⊑•args

# parse into a matrix of numbers
x ← > '0'⊸(-˜)¨¨ lines
x ↩ 1+x  # move up by one to avoid 0 clashing with » fill value

# part one: how many trees are visible?
# produce four binary matrices indicating visibility from top,left,bottom,right
# then logical or and count
t ← x >     » ⌈`     x  # from top
b ← x >   ⌽ » ⌈` ⌽   x  # from bottom
l ← x > ⍉   » ⌈`   ⍉ x  # from left
r ← x > ⍉ ⌽ » ⌈` ⌽ ⍉ x  # from right
•Show +´ ⥊ ∨´ t‿b‿l‿r

# part two: scenic scores
# for each location, figure out how far you can look in each direction.
LookDownward ← > {𝕊x: {𝕊i:
  head ← i⊏x
  tail ← (i+1)↓x
  shorties ← ⍉  0⊐˜˘ ⍉ (head⊸>˘ tail)
  # possibly add one to count as visible the taller tree that blocked our sight.
  # but don't add one if we've reached the edge without seeing any taller trees.
  (≠tail) ⌊ 1 + shorties
}¨ ↕≠x }
LookUpward ← ⌽ ∘LookDownward∘⌽
LookLeftward ← ⍉ ∘⌽ ∘LookDownward∘⌽ ∘⍉
LookRightward ← ⍉ ∘LookDownward∘⍉
#•Show [LookDownward x, LookUpward x, LookLeftward x, LookRightward x]
scenicscores ← ×˝ [LookDownward x, LookUpward x, LookLeftward x, LookRightward x]
•Show ⌈´ ⥊ scenicscores

