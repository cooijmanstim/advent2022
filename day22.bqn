ParseNat ← 10⊸×⊸+˜´ ∘⌽ -⟜'0'
ParseNum ← {𝕊𝕩: '-'≡⊑𝕩 ? -ParseNat 1↓𝕩; ParseNat 𝕩}
Stretches ← {m𝕊s: s ⊔˜ +`m≠»m}

lines←•FLines⊑•args
moves ← {"L": 'L'; "R": 'R'; ParseNum 𝕩}¨ {(𝕩∊"LR") Stretches 𝕩} ¯1⊑lines
board ← > {𝕊bl: {𝕩↑˜⌈´≠¨bl}¨ bl} ¯2↓lines

{ # part one
  hw ← ≢board
  x ← ⟨0, ⊑'.'⊐˜⊏board⟩
  dx ← 0‿1
  Rotate ← (¯1‿1⊸×)∘⌽  # ccw
  {𝕊t‿move:
    {'L': dx Rotate ↩;
     'R': dx Rotate⁼↩;
     𝕊n: axis ← ⊑1⊐˜0≠dx
         invert ← 0>+´dx
         # see what's ahead of us (we are at idx 0)
         line ← invert◶⊢‿⌽  (invert+axis⊑x)⌽  ((1-axis)⊑x) ⊏ axis◶⍉‿⊢ board
         !(⊑line)=(x⊑board)  # we are at idx 0
         !n≤≠line  # expecting to wrap at most once (but can just replicate if this fails)

         # remove empty cells but keep track of real distances to us
         dists ← ↕≠line
         nonempty ← line≠' ' ⋄ ! ∨´nonempty
         line ↩ nonempty / line ⋄ dists ↩ nonempty / dists

         nwall ← ⊑line⊐'#' ⋄ !nwall>0
         newx ← hw| x+ dx×dists⊑˜n⌊nwall-1
         !'#'≠newx⊑board ⋄ !' '≠newx⊑board
         x ↩ newx
    } move
  }¨ ((↕≠)⋈¨⊢) moves
  •Show  ({0‿1:0;¯1‿0:3; 0‿¯1:2; 1‿0:1}dx) +´1000‿4×1+x
}

{ # part two
  right‿down‿left‿up ← ↕4
  dxs ← [0‿1, 1‿0, 0‿¯1, ¯1‿0]
  topology ← {
    "ex"≡¯2↑⊑•args ? # example
      # cut up the board into cube faces (and keep track of indices in 2d projection)
      quads‿indices⇐ {[0‿0‿1‿0,1‿1‿1‿0,0‿0‿1‿1] /○⥊ <⎉2 0‿2‿1‿3⍉ 3‿4‿4‿4 ⥊ 𝕩}¨ board‿(↕≢board)
      # quads and their connections ((0‿right⊑edges)=5‿left <=> quad 0 right connects to quad 5 left
      edges⇐ [[5‿left,  3‿down,  2‿down, 1‿down ],
              [2‿right, 4‿up,    5‿up,   0‿down ],
              [3‿right, 4‿right, 1‿left, 0‿right],
              [5‿down,  4‿down,  2‿left, 0‿up   ],
              [5‿right, 1‿up,    2‿up,   3‿up   ],
              [0‿left,  1‿right, 4‿left, 3‿left ]]
      # - indicates coordinate sign switch AFTER any axis swap
      signs⇐ [[-‿-, -‿+, -‿+, +‿-],
              [+‿-, +‿-, -‿-, +‿-],
              [+‿-, +‿-, +‿-, +‿+],
              [-‿-, -‿+, +‿-, -‿+],
              [+‿-, +‿-, -‿-, -‿+],
              [-‿+, -‿-, +‿-, -‿-]]
      qshape⇐ ≢⊑quads
    ; # input
      quads‿indices⇐ {[0‿1‿1,0‿1‿0,1‿1‿0,1‿0‿0] /○⥊ <⎉2 0‿2‿1‿3⍉ 4‿50‿3‿50 ⥊ 𝕩}¨ board‿(↕≢board)
      edges⇐ [[1‿right, 2‿down,  3‿right, 5‿right],
              [4‿left,  2‿left,  0‿left,  5‿up   ],
              [1‿up,    4‿down,  3‿down,  0‿up   ],
              [4‿right, 5‿down,  0‿right, 2‿right],
              [1‿left,  5‿left,  3‿left,  2‿up   ],
              [4‿up,    1‿down,  0‿down,  3‿up   ]]
      signs⇐ [[+‿-, -‿+, -‿+, +‿+],
              [-‿+, +‿+, +‿-, -‿+],
              [+‿+, -‿+, +‿+, -‿+],
              [+‿-, -‿+, -‿+, +‿+],
              [-‿+, +‿+, +‿-, -‿+],
              [+‿+, -‿+, +‿+, -‿+]]
      qshape⇐ ≢⊑quads
  }

  WithinQuad ← ∧´ (0⊸≤∧<⟜topology.qshape)
  Advance ← {𝕊q‿x‿dir:
    dx ← dir ⊏ dxs
    {WithinQuad x+dx
      ? q‿(x+dx)‿dir
      ; qnew‿dirnew ← q‿dir⊑<⎉1 topology.edges
        signs ← q‿dir⊑<⎉1 topology.signs
        xnew ← topology.qshape| signs {⊑𝕨=⟨-⟩?-𝕩+1;𝕩}¨ (0=+´dx×dirnew⊏dxs)◶⊢‿⌽ x
        !WithinQuad xnew
        qnew‿xnew‿dirnew
    }
  }
  GetTrueIndex ← {𝕊q‿x‿dir: x⊑q⊑topology.indices}

  q ← 0 ⋄ x ← 0‿0 ⋄ dir ← 0
  {𝕊t‿move:
    {'L': dir ↩ 4|dir-1;
     'R': dir ↩ 4|dir+1;
     𝕊n: {F n: {n ≤ 0 ? @;
                qnew‿xnew‿dirnew ← Advance q‿x‿dir
                {'#'=xnew⊑qnew⊑topology.quads ? @;
                 q‿x‿dir ↩ qnew‿xnew‿dirnew
                 F n-1}}} n
    } move
  }¨ ((↕≠)⋈¨⊢) moves
  •Show dir +´1000‿4×1+GetTrueIndex q‿x‿dir
}

