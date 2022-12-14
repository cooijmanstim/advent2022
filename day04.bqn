lines ← •FLines ⊑•args

# part one
# parse each line a-b,c-d into two ranges a through b and c through d
Split ← (⊢-˜+`×¬)∘=⊔⊢
ParseInt ← (10⊸×⊸+˜´∘⌽-⟜'0')
abcds ← {
  ParseInt¨ ⥊ > '-'⊸Split¨ ',' Split 𝕩
}¨ lines
Range ← {𝕨 + ↕𝕩+1-𝕨 }

# part one: find pairs where [a,b] contains [c,d] or vice versa
containment ← {𝕊a‿b‿c‿d:
  (((a ≤ c) ∧ (d ≤ b)) ∨ ((c ≤ a) ∧ (b ≤ d)))
}¨ abcds
•Show +´ containment

# part two: find pairs where the ranges overlap at all
overlap ← {𝕊a‿b‿c‿d:
  (a⌈c) ≤ (b⌊d)
}¨ abcds
•Show +´ overlap

