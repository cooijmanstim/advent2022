board ← >•FLines ⊑•args
•Show board

UnravelIndex ← {shape𝕊idx:
  {𝕊d:
    x ← d|idx
    idx ⌊∘÷↩ d
    x
  }¨ ⌾ ⌽ shape
}
IndexOf ← {h𝕊n: (≢h) UnravelIndex ((⥊h)⊸⊐⌾ < n)}

practicalinf ← ≠⥊board

start ← board IndexOf 'S'
end ← board IndexOf 'E'
board ↩ (≢board) ⥊ {("a"⌾ ((𝕩='S')⊸/) "z"⌾ ((𝕩='E')⊸/)) 𝕩} ⥊board
•Show board

Act ← {s𝕊a:
  ds ← a ⊑ ⟨0‿¯1, 0‿1, ¯1‿0, 1‿0⟩
  0 ⌈ (1-˜≢board) ⌊ s + ds
}

# use Q learning to find shortest path to end from anywhere.
# dzaima used flood fill; I didn't realize that was sufficient for this problem.

# initialize q values
q ← 0‿0‿0‿0¨ board
T ← {𝕊q:
  q {qs𝕊s:
    qs {qsa𝕊a:
      s2 ← s Act a
      r ← { # compute reward for the transition
        1<(s2⊑board)-(s⊑board) ? -practicalinf;  # punish illegal move
        s2 ≡ end ? 1;  # reward getting to the goal
        ¯1  # any other move costs one step
      }
      qs2 ← s2 ⊑ q
      {s ≡ end ? 0 ; r + ⌈´ qs2}  # r + max_a2 Q(s2, a2)
    }¨ ↕≠qs
  }¨ ↕≢q
}

qstar ← T⍟ practicalinf q
•Show ⌈´¨ qstar

Measure ← {𝕊start:
  t←0
  x←start
  {𝕊𝕩:
    x ≡ end ? @ ;
    x Act↩ ⊑⍒x⊑qstar
    t +↩ 1
  }¨ ↕practicalinf
  t
}

# part one
•Show Measure start
# part two
•Show Measure {𝕩⊑˜ ⊑∘⍒ ⌈´∘⊑⟜qstar¨ 𝕩} (board = 'a') /○⥊ ↕≢board

