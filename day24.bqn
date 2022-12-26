b ← ⊑¨ "^v<>#."⊸⊐¨ > •FLines⊑•args
up‿down‿left‿right‿wall ← b⊸=¨↕5

Step ← {u‿d‿l‿r:
  u  1⊸⌽ ⌾ (((1⊸↓)∘(¯1⊸↓)))↩
  d ¯1⊸⌽ ⌾ (((1⊸↓)∘(¯1⊸↓)))↩
  l  1⊸⌽ ⌾ (((1⊸↓)∘(¯1⊸↓))∘⍉ )↩
  r ¯1⊸⌽ ⌾ (((1⊸↓)∘(¯1⊸↓))∘⍉ )↩
  u‿d‿l‿r
}
ShowState ← {𝕊udlr:
  counts ← +´ udlr ⋄ indices ← +´ udlr ×¨ 1+↕4
  •Show wall {𝕨 ? '#'; 𝕩}¨ indices {𝕩>1? 𝕩+'0'; 𝕩=1? 𝕨 ⊑ ".∧∨<>"; '.'}¨ counts
}
Expand ← {𝕊f‿udlr:
  (¬wall∨´udlr) ∧ f ∨´⥊ «‿» {𝕎⌾𝕏 f}⌜ ⊢‿⍉
}
MeasurePath ← {a‿b𝕊t‿udlr:
  {udlr Step↩ ⋄ t +↩ 1 ⋄ Expand 𝕩‿udlr}•_while_{¬b⊑𝕩} 1⌾ (a⊸⊑) 0¨ wall
  t‿udlr
}

{ # part one
  udlr ← up‿down‿left‿right
  •Show ⊑ (0‿1)‿(¯1‿¯2) MeasurePath 0‿udlr
}

{ # part two; assume can solve the three consecutive problems independently,
  # then add up the time. in general would need to solve it jointly though,
  # e.g. with a concatenation of three boards
  udlr ← up‿down‿left‿right
  t ← 0
  t‿udlr ↩ (0‿1)‿(¯1‿¯2) MeasurePath t‿udlr
  t‿udlr ↩ (¯1‿¯2)‿(0‿1) MeasurePath t‿udlr
  t‿udlr ↩ (0‿1)‿(¯1‿¯2) MeasurePath t‿udlr
  •Show t
}

