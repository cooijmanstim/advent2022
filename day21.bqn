lines ← •FLines⊑•args
names ← 4⊸↑¨ lines
nodes ← { ('0'⊸≤∧≤⟜'9') ⊑𝕩 ? 10⊸×⊸+˜´⌽ 𝕩-'0'
                           ; ⟨4↑𝕩, 5⊑𝕩, 7↓𝕩⟩
}¨ 6⊸↓¨ lines

MaybeEval ← {op𝕊a‿b:
  {∧´1=•Type¨ a‿b ? ((⊑"+-*/="⊐op) ⊑ +‿-‿×‿÷‿=)´ a‿b
                  ; a‿op‿b}
}
MakeTree ← {𝕊nodes:
  {F a‿op‿b: op MaybeEval {F (⊑names⊐<𝕩)⊑nodes}¨ a‿b;
   𝕩
  } (⊑names⊐<"root")⊑nodes
}

{ # part one
  •Show MakeTree nodes
}

{ # part two: derive value of "humn" from setting "root"'s children equal
  a‿·‿b ← MakeTree @⌾ ((⊑names⊐<"humn")⊸⊑) nodes  # root's children
  a‿b ↩ ∨a‿b  # let a be the constant branch and b be the dependent branch
  •Show {F a‿b: # now invert the operations on b until @ remains
    {@: a;
     c‿op‿d: {0‿1: {'+': F⟨a-d,c⟩; '-': F⟨a+d,c⟩; '*': F⟨a÷d,c⟩; '/': F⟨a×d,c⟩} op; # expr  × const
              1‿0: {'+': F⟨a-c,d⟩; '-': F⟨c-a,d⟩; '*': F⟨a÷c,d⟩; '/': F⟨c÷a,d⟩} op  # const × expr
             } 1= •Type¨ c‿d
    } b
  } a‿b
}

