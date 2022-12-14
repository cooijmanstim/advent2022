lines ← •FLines ⊑ •args

ParseNumber ← {𝕊s:
  n ← ⊑0⊐˜ ('0' ≤ s) ∧ (s ≤ '9')
  !n>0
  x ← (10⊸×⊸+˜´∘⌽ ) -⟜'0' n↑s
  ⟨x, n↓s⟩
}
ParseList ← {𝕊s:
  !'['≡⊑s
  xs ← ⟨⟩
  s ↩ {𝕊s:
    {','≡⊑s ? 1↓s;
     '['≡⊑s ? x‿s ← ParseList   s ⋄ xs ∾↩ <x ⋄ s;
              x‿s ← ParseNumber s ⋄ xs ∾↩ <x ⋄ s}
  } •_while_ {𝕊s: (0<≠s) ∧ ¬(']'≡⊑s)} 1↓s
  !0<≠s ⋄ !']'≡⊑s
  ⟨xs, 1↓s⟩
}
ParseThing ← {𝕊s:
  !¬']'≡⊑s ⋄ !¬','≡⊑s
  { '['≡⊑s ? ParseList s ; ParseNumber s }
}
ParseLine ← ⊑∘ParseThing

pairs ← <˘ ParseLine¨ ¯1 ↓˘ ∘‿3 ⥊ lines ∾ <""

Cmp ← {a𝕊b:
  {0‿0: n ← a ⌊○≠ b ⋄ c ← a Cmp¨○(n⊸↑) b
            x ← × ¯1 -○(⊑∘(c⊸⊐)) 1  # sign(indexof(-1) - indexof(1)) --- -1 if -1 comes before 1, vice versa, 0 if neither occurred
            {x≡0 ? × a-○≠b; x};  # if element comparison wasn't conclusive, compare lengths
   0‿1: a Cmp ⟨b⟩;
   1‿0: ⟨a⟩ Cmp b;
   1‿1: × a - b
  } •Type¨ a‿b
}

# part one
•Show +´ 1+ / 0≥ Cmp´¨ pairs

Merge ← {a𝕊b:
  TakeA ← {𝕊𝕩: x←⊑a ⋄ a↓˜↩1 ⋄ x}
  TakeB ← {𝕊𝕩: x←⊑b ⋄ b↓˜↩1 ⋄ x}
  {𝕩
    0≡≠a ? TakeB @;
    0≡≠b ? TakeA @;
    {(a Cmp○⊑ b) < 0 ? TakeA @; TakeB @}
  }¨ ↕a+○≠b
}
MergeSort ← {
  1≥≠𝕩 ? 𝕩;
  k ← ⌊(≠𝕩)÷2
  Merge´ MergeSort¨ ⟨k↑𝕩, k↓𝕩⟩
}

# part two
dividers ← ⟨⟨⟨2⟩⟩, ⟨⟨6⟩⟩⟩
•Show ×´ ⥊1+/˘ dividers ≡⌜ MergeSort dividers ∾ ⥊ >pairs

