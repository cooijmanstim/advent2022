lines ← •FLines ⊑•args

ParseInt ← 10⊸×⊸+˜´∘⌽-⟜'0'
moves ← {𝕊l:
  dx ← {'L': 0‿¯1; 'R': 0‿1; 'U': ¯1‿0; 'D': 1‿0} ⊑l
  n ← ParseInt 2↓l
  ⟨n, dx⟩
}¨ lines

# construct sequence of head positions
h ← 0‿0
hs ← ⟨h⟩
{n‿dx: {𝕊𝕩: h+↩dx ⋄ hs∾↩<h}¨ ↕n}¨ moves

Follow ← {𝕊hs:
  # construct sequence of positions of a knot following the head sequence
  {t𝕊h:
    {(∨´ 1⊸< | h-t) ? t+×(h-t) ; t}
  }` hs
}

# part one: two knots, tail follows head
ts ← Follow hs
•Show ≠⍷ts

# part two: ten knots, tail follows penultimate knot, ..., second knot follows head
ts2 ← Follow⍟ 9 hs
•Show ≠⍷ts2

