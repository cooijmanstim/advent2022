lines ← •FLines ⊑•args

Split ← (⊢-˜+`×¬)∘=⊔⊢
SplitMask ← (⊢-˜+`×¬)⊸⊔
ParseNat ← 10⊸×⊸+˜´∘⌽  -⟜'0'
TrimL ← {𝕊s: s↓˜0⊐˜s=' '}
TrimR ← TrimL ⌾ ⌽
Trim ← TrimL ∘ TrimR
ParseOperation ← {𝕊s:
  parts ← ' ' Split s
  operator ← +‿× ⊑˜ ⊑ "+*"⊐ ⊑1⊑parts
  {𝕊old: Operator´ {𝕊p: {p≡"old"?old;ParseNat p}}¨ 1‿0‿1 / parts}
}

ParseMonkey ← {𝕊ls:
  items ← ParseNat¨ Trim¨ ',' Split (≠"  Starting items: ")↓ 1⊑ls
  operation ← ParseOperation (≠"  Operation: new = ")↓ 2⊑ls
  divisor ← ParseNat (≠"  Test: divisible by ")↓ 3⊑ls
  branches ← ⟨ParseNat (≠"    If true: throw to monkey ")↓ 4⊑ls,
              ParseNat (≠"    If false: throw to monkey ")↓ 5⊑ls⟩
  activity ← 0
  ⟨items, operation, divisor, branches, activity⟩
}

monkeys ← ParseMonkey¨ ((""⊸≡¨⊢)SplitMask⊢) lines
•Show monkeys

modulus ← ×´ 2⊸⊑¨ monkeys  # NOTE could have used lcm

# NOTE dzaima used an object/namespace for each monkey, which provides mutable
# state and would be much cheaper than the modify-under-indexing updates I did
R ← {𝕊ms:
  {𝕊src:
    items‿operation‿divisor‿branches‿activity ← src⊑ms
    {𝕊i:
      #j ← ⌊ 3÷˜ Operation i  # part one
      j ← Operation i  # part two
      j ↩ modulus|j # modulus by product of monkeys divisors does not change dynamics of monkey business!
      dst ← branches ⊑˜ ¬0=(divisor|j)
      #•Show src‿i‿j‿dst
      ! ¬dst=src  # that would modify our own items we're looping over
      ms ↩ (∾⟜(<j))⌾ (0⊸⊑ dst⊸⊑) ms
    }¨ items
    ms ↩ (+⟜(≠items))⌾ (¯1⊸⊑ src⊸⊑) ms
    ms ↩ ⟨⟩ ⌾ (0⊸⊑ src⊸⊑) ms
  }¨ ↕≠ms
  ms
}
•Show R monkeys
•Show R⍟ 20 monkeys

# part one:
•Show ×´ 2↑ ∨ ¯1⊸⊑¨ R⍟ 20 monkeys
# part two:
•Show ×´ 2↑ ∨ ¯1⊸⊑¨ R⍟ 10000 monkeys


