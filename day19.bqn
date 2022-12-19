ParseNat ← 10⊸×⊸+˜´ ∘⌽ -⟜'0'
ParseNum ← {𝕊𝕩: '-'≡⊑𝕩 ? -ParseNat 1↓𝕩; ParseNat 𝕩}
Numbers ← {𝕊s: ParseNum¨ s ⊔˜ {1-˜𝕩×+`0⌈𝕩-»𝕩} ('-'=s) ∨ (('0' ≤ s) ∧ (s ≤ '9'))}
Enumerate ← {𝕩⋈˜¨↕≠𝕩}

blueprints ← {𝕊i‿rr‿cr‿or‿oc‿gr‿go: ⟨rr‿0‿0‿0, cr‿0‿0‿0, or‿oc‿0‿0, gr‿0‿go‿0⟩}¨ Numbers¨ •FLines ⊑•args

EvalBlueprint ← {tleft𝕊costs:
  F ← {𝕊tleft‿x‿dx‿lbound‿path:
    #{lbound<¯1⊑ x+tleft×dx ? •Show ⟨"new best", ¯1⊑x, tleft, dx, path⟩; @}
    ! tleft≥0 ⋄ ! ∧´ x≥0 ⋄ ! ∧´ dx≥0
    lbound ⌈↩ ¯1⊑ x+tleft×dx  # score we get if we build no more robots
    ubound ← (¯1⊑ x+tleft×dx)++´((tleft-1)-↕0⌈(tleft-1)) # if we could build a geode robot every minute
    {(ubound > lbound) ∧ (tleft > 0) ?
      {𝕊i‿c: # what do we build next?
        dt ← ⌈´⌈(c-x)÷dx # time until we can afford it (may be zero or negative if we can afford it now)
        (0≤dt) ∧ (dt<tleft) ?
          # (dt+1 to jump to time of completion)
          lbound ⌈↩ F ⟨tleft-dt+1, (x+(dt+1)×dx)-c, (1⊸+)⌾ (i⊸⊑) dx, lbound, path∾<(tleft-dt)‿i⟩
        ; @
      }¨ ⌽ Enumerate costs  # reverse to consider geode branch first
    ;@}
    lbound
  }
  F ⟨tleft, 0‿0‿0‿0, 1‿0‿0‿0, 0, ⟨⟩⟩
}

{ # part one
  scores ← 24⊸EvalBlueprint¨ blueprints
  #•Show scores
  •Show +´scores×1+↕≠blueprints
}
{ # part two
  scores ← 32⊸EvalBlueprint¨ (3⌊≠blueprints)↑blueprints
  #•Show scores
  •Show ×´scores
}

