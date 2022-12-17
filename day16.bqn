lines ← •FLines ⊑•args
ParseNat ← 10⊸×⊸+˜´ ∘⌽ -⟜'0'
ParseNum ← {𝕊𝕩: '-'≡⊑𝕩 ? -ParseNat 1↓𝕩; ParseNat 𝕩}
Numbers ← {𝕊s: ParseNum¨ s ⊔˜ {1-˜𝕩×+`0⌈𝕩-»𝕩} ('-'=s) ∨ (('0' ≤ s) ∧ (s ≤ '9'))}
Split ← {𝕨𝕊𝕩: 𝕩⊔˜¯1+ 𝕨((¬∘=)×(1⊸+∘(+`∘=)))𝕩}
FillDiagonal ← {(𝕨 ⥊˜≠𝕩)⌾ (0‿0⊸⍉ ) 𝕩}

nodes ← {𝕊line:
  a‿b ← ';' Split line
  node ← 2↑(≠"Valve ")↓a
  rate ← ⊑Numbers a
  successors ← ¯2↑¨ ',' Split b
  ⟨node, rate, successors⟩
}¨ lines

# turn node names into numeric identifiers, so we can use a vector/matrix representation of the graph
names ← ⊑¨ nodes
identifiers ← ⊐ names
rates ← 1⊸⊑¨ nodes
tunnels ← > {𝕊name‿rate‿successors:
  i ← {⊑names⊐<𝕩}¨ successors
  (1¨i)⌾ (i⊸⊏) ∞¨ identifiers
}¨ nodes
# compute minimum distances between nodes
distances ← 0 FillDiagonal tunnels
{𝕊k:
  distances ⌊↩ distances +⌜○(k⊸⊏) ⍉ distances
}¨ ↕≠distances

RemoveNode ← {k𝕊v‿r‿e:  # remove node k from the graph
  m ← ¬k=↕≠v
  v ↩ m / v ⋄ r ↩ m / r ⋄ e ↩ {𝕩⊏⌾⍉ 𝕩⊏e} /m
  v‿r‿e
}

graph ← {𝕊v‿r‿e:
  # now remove zero-rate nodes (except starting node AA)
  v‿r‿e ↩ v‿r‿e RemoveNode´ /((¬"AA"⊸≡¨v)∧0=r)
  # permute nodes so that start is at index zero
  i ← ⍒ "AA"⊸≡¨ v
  v ↩ i⊏v ⋄ r ↩ i⊏r ⋄ e ↩ i ⊏⌾⍉ i⊏e
  v‿r‿e
} names‿rates‿distances
start ← 0

F ← {𝕊⟨t, score, bestscore, node, graph, path⟩:
  {score +↩ t×node⊑1⊑graph ⋄ graph 0⌾ ((node⊸⊑)∘(1⊸⊑))↩
   #{score > bestscore?  •Show ⟨"new best score", score, ⊑⟜(⊑graph)¨ path⟩; @}

   #ubound ← score++´(0⌈(t-2×1+↕≠1⊑graph))×∨1⊑graph  # if we opened remaining valves from big to small, assuming distance 1 between them
   ubound ← score + +´ (0⌈t-1+node⊏2⊑graph)×1⊑graph  # if we opened remaining valves, assuming we can go to each of them in parallel, but taking distance into account
   #ubound ← score++´(t×1⊑graph)  # if we opened all valves right now
   {bestscore < ubound ?
    successors ← {(0<𝕩⊏1⊑graph)/𝕩} ⍒1⊑graph  # consider next valves in descending order
    bestscore ⌈↩ score
    {𝕊dest:
      dt ← 1+ node‿dest ⊑ 2⊑graph  # +1 minute to open valve
      (0 < t-dt) ?
      bestscore ⌈↩ F ⟨t-dt, score, bestscore, dest, graph, path∾<dest⟩
      ; @
    }¨ successors
    ;@}
   bestscore
  }
}

# part one
•Show F ⟨30, 0, 0, start, graph, ⟨⟩⟩

# for part two, consider all partitions of the rate>0 nodes into two subsets
# NOTE currently broken on the example, getting 1704 instead of 1707.
bestscore ← 0
{𝕊𝕩:
  a ← 1+/ 𝕩 ⋄ b ← 1+/ (¬𝕩)  # 1+ to account for start node at index 0
  tmax ← 26
  ubound ← +´ {+´(tmax-1+𝕩⊏start⊏2⊑graph)×𝕩⊏1⊑graph}¨ a‿b  # if we travelled to each valve in parallel and opened it
  (bestscore < ubound) ∧ (a>○≠b) ?  # a>○≠b to avoid processing twice (complements)
    ascore ← F ⟨tmax, 0, 0, start, graph RemoveNode´ a, ⟨⟩⟩
    bscore ← F ⟨tmax, 0, 0, start, graph RemoveNode´ b, ⟨⟩⟩
    #{bestscore<ascore+bscore ? •Show ⟨"new best score", ascore+bscore, a, b⟩; @}
    bestscore ⌈↩ ascore + bscore
  ;@
}¨ ⥊ ↕2¨↕¯1+≠⊑graph  # ¯1+ to not partition start node
•Show bestscore

