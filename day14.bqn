ParseNum ← 10⊸×⊸+˜´ ∘⌽ -⟜'0'
Numbers ← {𝕊s: ParseNum¨ s ⊔˜ {1-˜𝕩×+`0⌈𝕩-»𝕩} ('0'⊸≤∧≤⟜'9') s}
paths ← (<˘ ∘‿2 ⥊ Numbers)¨ •FLines ⊑•args

xmin ← 500⌊ ⌊´ ⌊´¨ 0⊸⊑¨¨ paths
xmax ← 500⌈ ⌈´ ⌈´¨ 0⊸⊑¨¨ paths
ymin ← 0
ymax ← ⌈´ ⌈´¨ 1⊸⊑¨¨ paths
•Show ⟨xmin, xmax⟩‿⟨ymin, ymax⟩

# for part two, add two rows on bottom, and widen to accomodate a full triangle
ymax +↩ 2
xmin‿xmax ↩ ⟨500 - ymax, 500 + ymax⟩

start ← 500‿0 - xmin‿ymin

blocked ← (1+xmax-xmin)‿(1+ymax-ymin) ⥊ 0
MarkBlocked ← {blocked 1⌾ (𝕩⊸⊑)↩}
RavelIndex ← {idx𝕊shape: +´ idx × ×`⌾ ⌽  1« shape}
_setmany_ ← {i _𝕣_ v x: v⌾ ((RavelIndex⟜(≢x)¨ i)⊸⊏∘⥊) x}
MarkManyBlocked ← {𝕊i: blocked (i _setmany_ ((≠i)⥊1))↩}
ShowBlocked ← {𝕊𝕩: •Show ⍉ ⊑⟜".#"¨ blocked}

# for part two, mark the floor
blocked ↩ ((≠blocked)⥊1)⌾ (¯1⊸⊏˘) blocked

{𝕊path: {a‿b:
    direction ← ¯1⌈1⌊b-a ⋄ distance ← ⌈´ |b-a
    #{MarkBlocked -⟜xmin‿ymin a + 𝕩×direction}¨ ↕1+distance  # sloow
    MarkManyBlocked {-⟜xmin‿ymin a + 𝕩×direction}¨ ↕1+distance
  }¨ ¯1↓path⋈¨«path
}¨ paths
#ShowBlocked @
#•Exit 1

# now simulate each unit of sand, adding it to blocked once it comes to rest
SimulateCrumb ← {𝕊start:
  {𝕊p:
    IsBlocked ← {𝕊q: ∧´(0≤q)∧(q≤(≢blocked)) ? blocked⊑˜q; ¯1}
    d‿l‿r ← p⊸+¨ ⟨0‿1, ¯1‿1, 1‿1⟩
    bd‿bl‿br ← IsBlocked¨ d‿l‿r
    {bd≡ 0? d; bl≡ 0? l; br≡ 0? r;
     MarkBlocked p ⋄ p  # come to rest
    }
  } •_while_ {@: 0; ¬𝕩⊑blocked} start
}

{1: # part one
InAbyss ← {𝕊x‿y: y ≥ ymax-2}
count ← 0
{𝕊done: count+↩1 ⋄ InAbyss SimulateCrumb start} •_while_ ¬ 0
#ShowBlocked @
•Show count-1
;2: # part two
count ← 0
{𝕊𝕩: count+↩1 ⋄ SimulateCrumb start} •_while_ {𝕊𝕩: ¬start⊑blocked} 0
#ShowBlocked @
•Show count
} 2

