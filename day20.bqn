_d←{e←0⋄ r←𝕨𝔽⎊{e↩1⋄•CurrentError𝕩}𝕩⋄ •Show["calling"‿((<𝕨)⊢⊘∾𝕗‿𝕩),(e⊑"returned"‿"errored")‿r]⋄ r!¬e⋄r}
ParseNat ← 10⊸×⊸+˜´ ∘⌽ -⟜'0'
ParseNum ← {𝕊𝕩: '-'≡⊑𝕩 ? -ParseNat 1↓𝕩; ParseNat 𝕩}
Enumerate ← {𝕩⋈˜¨↕≠𝕩}
xs ← ParseNum¨ •FLines⊑•args
n ← ≠xs

Mix ← {k𝕊xs:  # correct up to rotation
  p ← ↕n
  {𝕩
    {𝕊i‿x:
      src ← ⊑p⊐i ⋄ dst ← n|src+x
      x {0: 0; ((n-1)××𝕩)|𝕩}↩  # don't generate duplicate indices by cycling around multiple times
      p 1⊸⌽ ⌾ ((n|src+(×x)×↕1+|x)⊸⊏)↩  # rotate cyclic slice [src,src+x]
    }¨ Enumerate xs
  }¨ ↕k
  p
}

{ # part one
  ys ← xs⊏˜ 1 Mix xs
  •Show +´ ys ⊏˜ n⊸|¨ 1000‿2000‿3000 + ys⊐0
}
{ # part two
  key ← 811589153
  ys ← key × xs ⊏˜ 10 Mix xs ×○((n-1)⊸|) key
  •Show +´ ys ⊏˜ n⊸|¨ 1000‿2000‿3000 + ys⊐0
}

