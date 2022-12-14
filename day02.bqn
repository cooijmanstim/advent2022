lines ← •FLines ⊑•args

# each line is an action pair
# A Y
# B X
# C Z
# convert to index
# ABC->012, XYZ->012
pairs ← {⟨(0⊑𝕩)-'A', (2⊑𝕩)-'X'⟩}¨ lines

# part one; each pair is [their_action, my_action], look up in a payoff matrix
action_rewards←1‿2‿3
# outcomes[i,j] = do I win if they play i and I play j?
outcomes←[ 0‿ 1‿¯1,
          ¯1‿ 0‿ 1,
           1‿¯1‿ 0]
payoffs ← action_rewards⊸+⎉1 3×outcomes+1
•Show payoffs
rewards ← (⊑⟜payoffs)¨ pairs
•Show +´rewards

# part two
# now the second number is the desired outcome (XYZ=lose draw win=012)
# flatten and reshape to turn it from list-of-lists into a matrix
pairs_matrix ← [≠pairs,2]⥊ ∾pairs

their_actions ← 0⊏⍉ pairs_matrix
desired_outcomes ← 1⊏⍉ pairs_matrix
# policy[i,j] = what I do if they play i and I want outcome j
policy ← [2‿0‿1,  # they play rock
          0‿1‿2,  # they play paper
          1‿2‿0]  # they play scissors
my_actions ← {𝕩⊑policy}˘ pairs_matrix
rewards2 ← (my_actions ⊏ action_rewards) + (desired_outcomes×3)
•Show +´ rewards2

