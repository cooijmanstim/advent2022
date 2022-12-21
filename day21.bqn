nodes ← ∧ {
  name ← 4↑𝕩
  expr ← {('0'⊸≤∧≤⟜'9') ⊑𝕩 ? 10⊸×⊸+˜´⌽ 𝕩-'0';
                             ⟨4↑𝕩, 5⊑𝕩, 7↓𝕩⟩} 6↓𝕩
  name‿expr
}¨ •FLines⊑•args

MaybeEval ← {op𝕊a‿b:
{∧´1=•Type¨ a‿b ? ((⊑"+-*/="⊐op) ⊑ +‿-‿×‿÷‿=)´ a‿b
                ; a‿op‿b}
}
MakeTree ← {𝕊nodes:
  root ← ⊑(⊑¨nodes)⊐<"root"
  {F a‿op‿b: op MaybeEval {F 1⊑nodes⊑˜⊑(⊑¨nodes)⊐<𝕩}¨ a‿b;
   𝕩
  } 1⊑root⊑nodes
}

{ # part one
  •Show MakeTree nodes
}

{ # part two: derive value of "humn" from setting "root"'s children equal
  # luckily "humn" only appears once in the tree.
  tree ← MakeTree {
    "root"‿expr: ⟨"root", ⟨⊑expr, '=', 2⊑expr⟩⟩;
    "humn"‿expr: ⟨"humn", @⟩;
    𝕩: 𝕩
  }¨ nodes
  a‿·‿b ← tree
  a‿b ↩ ∨a‿b  # let a be the constant branch and b be the dependent branch
  •Show {F a‿b: # now invert the operations on b until @ remains
    # unpack b
    {@: a;
     c‿op‿d: {0‿1: {'+': F⟨a-d,c⟩; '-': F⟨a+d,c⟩; '*': F⟨a÷d,c⟩; '/': F⟨a×d,c⟩} op; # expr  × const
              1‿0: {'+': F⟨a-c,d⟩; '-': F⟨c-a,d⟩; '*': F⟨a÷c,d⟩; '/': F⟨c÷a,d⟩} op  # const × expr
             } 1= •Type¨ c‿d
    } b
  } a‿b
}

