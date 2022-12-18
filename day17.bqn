RavelIndex ← {idx𝕊shape: +´ idx × ×`⌾ ⌽  1« shape}
_setmany_ ← {i _𝕣_ v x: v⌾ ((RavelIndex⟜(≢x)¨ i)⊸⊏∘⥊) x}

nudges ← {⥊ > 𝕩⋈¨'v'⥊˜≠𝕩}  ⊑•FLines ⊑•args
shapes ← ⌽ ¨ ⟨[1‿1‿1‿1], [0‿1‿0, 1‿1‿1, 0‿1‿0], [0‿0‿1, 0‿0‿1, 1‿1‿1], ⍉ ≍[1,1,1,1], [1‿1, 1‿1]⟩
ModIdx ← {i𝕊x: x⊑˜i|˜≠x}

width ← 7
margin ← 3
System ⇐ {𝕊:
  t_nudge ⇐ 0
  t_rock ⇐ 0
  board ← 100‿width ⥊ 0
  h ⇐ 0
  AddToBoard ← {board𝕊x‿shape:
    i ← x⊸+¨ shape /○⥊ ↕≢shape
    (i _setmany_ (1¨i)) board
  }
  SimulateRock⇐ {𝕊𝕩:
    shape ← t_rock ModIdx shapes
    sh‿sw ← ≢shape
    t_rock +↩ 1
    # compute starting height, if necessary double board height to make room
    jstart ← h + margin
    {(jstart+sh)≥≠board ? board ↩ board ∾ 0¨ board; @}
    x ← ⟨jstart, 2⟩
    {𝕊𝕩:
      nudge ← t_nudge ModIdx nudges
      t_nudge +↩ 1
      dx ← {'v': ¯1‿0; '<': 0‿¯1; '>': 0‿1} nudge
      newx ← x+dx
      inbounds ← ∧´ (0‿0≤newx) ∧ ((newx+≢shape)≤≢board)
      overlap ← {inbounds ? ∨´ ⊑⟜board¨ (newx⊸+¨ shape /○⥊ ↕≢shape); 0}
      {inbounds ∧ ¬overlap? x ↩ newx;
       nudge='v'? board (AddToBoard⟜x‿shape)↩ ⋄ shape ↩ @ ⋄ h ⌈↩ (sh+⊑x);  # come to rest
       @}
    }•_while_{𝕊𝕩:
      ¬shape≡@
    } @
  }
  State ⇐ {𝕊:
    ⟨t_rock|˜≠shapes, t_nudge|˜≠nudges⟩
  }
}

# part one: 2022 rocks
a ← System @
a.SimulateRock⍟ 2022 @
•Show a.h

# part two: 1E12 rocks. too big to fit the board in memory, and even if we could, we
# wouldn't have the time to simulate so many rocks. the system eventually becomes
# periodic. I ended up peeking at dzaima's solution to figure out how exactly to
# exploit that, and I ended up stealing his OO approach in the process.
b ← System @
b.SimulateRock⍟ 1000 @                          # warm up and take note of state
h1 ← b.h ⋄ n1 ← b.t_rock ⋄ state ← b.State @
b.SimulateRock @
b.SimulateRock •_while_ {𝕊: state≢b.State @} @  # run until state is revisited
h2 ← b.h ⋄ n2 ← b.t_rock
# we simulated `n1` rocks, and found the same state after `n2` more rocks.
# so we can tell that every `n2 - n1` rocks, h increases by `h2 - h1`.
# this lets us predict the h after n1+k*(n2-n1) rocks for integer k.
# the desired 1E12 will not be a nice multiple like that, so we need to simulate a
# few more steps.
ntotal ← 1E12
b.SimulateRock ⍟ ((n2 - n1) | (ntotal - n1)) @
h3 ← b.h

•Show h1 + (h3 - h2) + (h2 - h1) × ⌊(ntotal - n1) ÷ (n2 - n1)

