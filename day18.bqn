ParseNat ← 10⊸×⊸+˜´ ∘⌽ -⟜'0'
ParseNum ← {𝕊𝕩: '-'≡⊑𝕩 ? -ParseNat 1↓𝕩; ParseNat 𝕩}
Numbers ← {𝕊s: ParseNum¨ s ⊔˜ {1-˜𝕩×+`0⌈𝕩-»𝕩} ('-'=s) ∨ (('0' ≤ s) ∧ (s ≤ '9'))}
RavelIndex ← {idx𝕊shape: +´ idx × ×`⌾ ⌽  1« shape}
_setmany_ ← {i _𝕣_ v x: v⌾ ((RavelIndex⟜(≢x)¨ i)⊸⊏∘⥊) x}

xs ← Numbers¨ •FLines ⊑•args
min ← ⌊˝ >xs ⋄ max ← ⌈˝ >xs
b ← (1+-⟜min¨xs) _setmany_ (1¨xs) (3+max-min) ⥊ 0
h‿w‿d ← ≢b

# part one
•Show +´⥊ b× +´ ⥊ «‿» {¬𝕎 ⎉𝕩 b}⌜ 1‿2‿3 

# part two
f ← {𝕊i‿j‿k: ∨´ ⟨i=0, j=0, k=0, i=h-1, j=w-1, k=d-1⟩}¨ ↕≢b
{𝕊done:
  fnew ← f ∨ (¬b) ∧ ∨´ ⥊ «‿» {𝕎 ⎉𝕩 f}⌜ 1‿2‿3
  done ↩ f≡fnew ⋄ f ↩ fnew ⋄ done
} •_while_ ¬ 0
•Show +´⥊ b× +´ ⥊ «‿» {(𝕎 ⎉𝕩)⌾ ¬ f}⌜ 1‿2‿3

