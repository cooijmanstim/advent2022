b ← ".#"⊐> •FLines⊑•args

System ← {𝕩
  b ⇐ b
  t ⇐ 0
  nelves ← +´⥊b
  ShowBoard ⇐ {𝕩: •Show b⊏".#"}
  Step ⇐ {𝕩
    b ↩ (⊢↑˝·≍⟜¬2+≢) CroppedBoard@  # crop to bbox + one unit of padding
    nn‿ss‿ww‿ee ← ⥊ ⊢‿⍉ {𝕏⌾ 𝕎 b}⌜ »‿«
    nw‿ne‿sw‿se ← ⥊ nn‿ss {𝕏⌾⍉ 𝕨}⌜ »‿«
    conditions ← t ⌽ [b∧¬∨´ nw‿nn‿ne,
                      b∧¬∨´ sw‿ss‿se,
                      b∧¬∨´ nw‿ww‿sw,
                      b∧¬∨´ ne‿ee‿se]
    fs ← t ⌽ ⟨1⊸⌽ , ¯1⊸⌽ , 1⊸⌽⌾⍉ , ¯1⊸⌽⌾⍉ ⟩
    needmove ← b ∧ ∨´ nw‿nn‿ne‿ww‿ee‿sw‿ss‿se
    proposals ← (4×¬needmove) + needmove× (⊐⟜1)⎉1 1‿2‿0 ⍉⁼ conditions
    collisions ← 1<+´ {𝕊i‿f: F proposals=i}¨ (↕4)⋈¨fs
    b ↩ (b∧proposals=4) ∨´ {𝕊i‿f:
      src← b∧proposals=i ⋄ dst ← F src
      cancel ← F⁼ collisions∧dst
      (cancel∧src)∨F(¬cancel)∧src
    }¨ (↕4)⋈¨fs
    !nelves = +´⥊b
    t+↩1
    ∨´⥊needmove
  }
  CroppedBoard ⇐ {𝕩
    tl ← {⊑⌊´1⊸(⊐˜)˘ 𝕏 b}¨ ⟨⍉ , ⊢⟩
    br ← {⊑⌊´{(⌽ 𝕩)⊐1}˘ 𝕏 b}¨ ⟨⍉ ,⊢⟩
    (-br)↓tl↓b
  }
}

{ # part one
  x ← System@
  {𝕩: x.Step@}⍟ 10 @
  •Show +´⥊ ¬x.CroppedBoard@
}

{ # part two
  x ← System@
  {𝕊𝕩:x.Step@}•_while_ ⊢ 1
  •Show x.t
}

