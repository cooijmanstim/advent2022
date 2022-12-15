ParseNat ← 10⊸×⊸+˜´ ∘⌽ -⟜'0'
ParseNum ← {𝕊𝕩: '-'≡⊑𝕩 ? -ParseNat 1↓𝕩; ParseNat 𝕩}
Numbers ← {𝕊s: ParseNum¨ s ⊔˜ {1-˜𝕩×+`0⌈𝕩-»𝕩} ('-'=s) ∨ (('0' ≤ s) ∧ (s ≤ '9'))}
RavelIndex ← {idx𝕊shape: +´ idx × ×`⌾ ⌽  1« shape}
_setmany_ ← {i _𝕣_ v x: v⌾ ((RavelIndex⟜(≢x)¨ i)⊸⊏∘⥊) x}

sensors ← {𝕊line:
  sx‿sy‿bx‿by ← Numbers line
  r ← +´|sx‿sy - bx‿by
  sx‿sy‿r
}¨ •FLines ⊑•args
#•Show sensors

# part one: care only about x=10 (in example, x=2M in input)
ytarget ← 10‿2E6 ⊑˜ "in"≡¯2↑ ⊑•args
EmptyRange ← >´
IntersectRange ← (⌈○(0⊸⊑))⋈(⌊○(1⊸⊑))
UnionRange ← (⌊○(0⊸⊑))⋈(⌈○(1⊸⊑))
CountRange ← 1+ -˜´  # 1+ because inclusive

# find ranges that each sensor can see on the target row.
ranges ← {𝕩/˜¬EmptyRange¨𝕩} {𝕊x‿y‿r:
  rowdist ← |y-ytarget
  w ← r - rowdist
  ⟨x-w, x+w⟩
}¨ sensors
#•Show ranges

# now merge overlapping ranges by union. the result is a set of nonoverlapping ranges.
mergedranges ← ⟨⟩ {range𝕊set:
  # note if multiple in set overlap with range, now they all overlap
  disjoint ← EmptyRange¨ range⊸IntersectRange¨ set
  (disjoint / set) ∾ < UnionRange´ (<range) ∾ (¬disjoint) / set
}´ ranges
# now the combined coverage of the merged ranges is our answer, except we need to
# subtract the number of beacons in that area.
beacons ← {𝕊line:
  sx‿sy‿bx‿by ← Numbers line
  bx‿by
}¨ •FLines ⊑•args
beaconsinranges ← {𝕊x‿y:
  (y=ytarget) ∧ ∨´ {𝕊range: ¬EmptyRange x‿x IntersectRange range}¨ mergedranges
}¨ ⍷ beacons
•Show (+´ CountRange¨ mergedranges) - +´ beaconsinranges

# part two
extent ← 20‿4E6 ⊑˜ "in"≡¯2↑⊑•args
TuningFreq ← {𝕊x: +´ x×4E6‿1}
# there is a single point p that is just out of reach of four (or more) sensors.
# if we increase their radius by 1, then it is on the perimeter of these sensors.
# so we only need to consider points that are on intersections of sensor perimeters.
Solve22 ← {m𝕊v:
  w‿x‿y‿z ← ⥊m
  ÷⟜((w×z)-(x×y)) +˝˘ v⊸×˘ 2‿2 ⥊ [z, -x, -y, w]
}
IntersectLine ← {a‿b𝕊c‿d:
  # solve 2d system a + alpha (b-a) = c + beta (d-c)
  coeff ← (⍉ [b-a, -(d-c)]) Solve22 c-a
  ∧´ (0≤coeff)∧(coeff≤1) ? a+(b-a)×⊑coeff; @
}
#•Show ⟨0‿0,1‿1⟩ IntersectLine ⟨1‿0,0‿1⟩
#•Show ⟨0‿0,0‿1⟩ IntersectLine ⟨1‿0,1‿1⟩
PerimeterSegments ← {𝕊x‿y‿r:
  cs ← x‿y⊸+¨ <˘ r× ∘‿2 ⥊ 0‿¯1‿¯1‿0‿0‿1‿1‿0  # corners
  <˘ 2↕ cs ∾ ⊏cs
}
Enumerate ← {𝕊xs: (↕≠xs)⋈¨xs}
candidates ← ⟨⟩
{𝕊i‿a:
  {𝕊j‿b:
    xa‿ya‿ra ← a ⋄ xb‿yb‿rb ← b
    intersections ← ⥊ (PerimeterSegments a+0‿0‿1) IntersectLine⌜ (PerimeterSegments b+0‿0‿1)
    mask ← {@: 0; 𝕊p: ∧´ ((⌊=⊢)p) ∧ (0≤p) ∧ (p≤extent)}¨ intersections
    candidates ∾↩ mask / intersections
  }¨ (i+1)↓ Enumerate sensors
}¨ Enumerate sensors
candidates ⍷↩
#•Show candidates
•Show ≠candidates

# now find the candidate that is not in the range of any sensor
outofrange ← {𝕊p:
  ∧´ {𝕊x‿y‿r: r<+´|p-x‿y}¨ sensors
}¨ candidates
•Show TuningFreq¨ •Show outofrange / candidates

