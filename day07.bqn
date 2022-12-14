lines ← •FLines ⊑•args

StartsWith ← (≤○≠◶0‿(⊣≡≠⊸↑))˜
Split ← (⊢-˜+`×¬)∘=⊔⊢
ParseInt ← 10⊸×⊸+˜´∘⌽-⟜'0'

# collect list of files with absolute paths, and sizes
path ← ⟨⟩
nodes ← ⟨⟨⟩⟩
sizes ← ⟨0⟩
ProcessCD ← {
  𝕩 ≡ "/"
    ? path ↩ ⟨⟩
    ; 𝕩 ≡ ".."
        ? path ↩ ¯1↓path
        ; path ↩ path ∾ ⟨𝕩⟩
}
ProcessFile ← {
  tag‿name ← ' ' Split 𝕩
  size ← {tag ≡ "dir" ? 0 ; ParseInt tag}
  nodes ↩ nodes ∾ ⟨path∾⟨name⟩⟩
  sizes ↩ sizes ∾ ⟨size⟩
}

{
𝕩 ≡ "$ ls" ? @ ;
𝕩 StartsWith "$ cd " ? ProcessCD 5↓𝕩;
¬𝕩 StartsWith "$" ? ProcessFile 𝕩
}¨ lines

# for each node, compute sum of descendant sizes (quadratic time)
n ← ≠nodes
total_sizes ← {𝕊i:
  +´ {𝕊j:
    ((j⊑nodes) StartsWith (i⊑nodes))
    ? j⊑sizes; 0
  }¨ ↕n
}¨ ↕n

# part one
•Show total_sizes +´∘× ((sizes = 0) ∧ (total_sizes ≤ 100000))

# part two
space_total ← 70000000
space_needed ← 30000000
space_free ← space_total - ⊑total_sizes
space_to_free ← space_needed - space_free
# find smallest directory of at least that size
candidates ← (sizes = 0) ∧ (total_sizes ≥ space_to_free)
•Show ⌊´ candidates / total_sizes

