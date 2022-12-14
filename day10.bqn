lines ← •FLines ⊑•args

Num ← 10⊸×⊸+˜´∘⌽
ParseInt ← {𝕩: # deal with sign
 (⊑𝕩)='-' ? -Num -⟜'0' 1↓𝕩; Num -⟜'0' 𝕩
}

t←1
x←1
y←0  # for part one, sum of strengths
draws←240⥊0  # for part two, screen to draw to
Observe ← {𝕊𝕩:
  {⊑ t ∊ 20‿60‿100‿140‿180‿220 ? y+↩t×x; @}
  {1≥|x-40|t-1 ? draws +↩ (t-1)=↕240; @}
}

Observe t
{
"noop": t+↩1 ⋄ Observe t;
𝕩:
  t+↩1 ⋄ Observe t
  x+↩ParseInt 5↓𝕩
  t+↩1 ⋄ Observe t
}¨ lines
•Show y

•Show " #" ⊏˜ 6‿40 ⥊ draws

