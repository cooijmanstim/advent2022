digitss ← {{'-': ¯1; '=': ¯2; !('0'⊸≤∧≤⟜'9') 𝕩 ⋄ 𝕩-'0'}¨ 𝕩}¨ •FLines⊑•args
ToSnafu ← {0: ⟨⟩;
  𝕊n: d ← 5|𝕩
      {d < 3 ? (ToSnafu ⌊n÷5)∾<d
             ; (ToSnafu 1+⌊n÷5)∾<d-5}
}
•Show {¯1: '-'; ¯2: '='; 𝕩+'0'}¨ ToSnafu +´ {5⊸×⊸+˜´ ⌽ }¨ digitss

