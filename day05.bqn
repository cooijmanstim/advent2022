lines ← •FLines ⊑•args

# a bitch to parse!
# first find the empty line
emptyidx ← ⊑ 0⊐˜ ≠¨ lines
# examine the line above it to find out how many stacks there are
baseline ← (emptyidx-1) ⊑ lines
stackindices ← / baseline > '0'
stacklines ← ⌽  (emptyidx-1) ↑ lines
# a matrix [ZN ,MCD,P  ]
stacks ← ⍉ > stackindices⊸⊏¨ stacklines
# convert to list of lists, trim spaces on the right
stacks ↩ •Show {(∨⟜«' '⊸≠)⊸/}¨ <˘stacks

# part one: play out the moves to figure out what's on the top of each stack at the end
Split ← (⊢-˜+`×¬)∘=⊔⊢
ParseInt ← (10⊸×⊸+˜´∘⌽-⟜'0')
movelines ← (emptyidx+1) ↓ lines
finalstacks ← stacks {
  parts ← ' ' Split 𝕨
  n ← ParseInt 1⊑parts
  src ← 1-˜ ParseInt 3⊑parts
  dst ← 1-˜ ParseInt 5⊑parts
  # remake 𝕩 (stacks) but with `dst` and `src` rows modified
  boxes ← n↑⌽ (src⊑𝕩)
  boxes ⌽ ↩ # for part two only
  newsrc ← ⌽ n↓⌽ src⊑𝕩
  newdst ← (dst⊑𝕩) ∾ boxes
  #•Show ⟨𝕨, n, src, dst, newsrc, newdst⟩
  (↕≠𝕩) {i𝕊x:  # rebuild 𝕩 by mapping over enumeration of rows
    {i ≡ src ? newsrc ; i ≡ dst ? newdst; x}
  }¨ 𝕩
}´ ⌽ movelines  # reverse because fold is back-to-front
•Show ¯1⊸⊑¨ finalstacks

