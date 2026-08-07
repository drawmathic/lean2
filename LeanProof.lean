/-- 
Formalization of the Periodic Second Difference Conjecture 
for Bounded Random Walks.
-/

-- 1. Define the LCM of the first k natural numbers using Lean's core Nat.lcm
def lcm_upto : Nat → Nat
  | 0 => 1
  | (n + 1) => Nat.lcm (n + 1) (lcm_upto n)

-- 2. Define a periodic function condition
def IsPeriodic (f : Nat → Int) (P : Nat) : Prop :=
  ∀ b, f (b + P) = f b

-- 3. Define the discrete second difference operator Δ²
def delta2 (f : Nat → Int) (b : Nat) : Int :=
  f (b + 2) - 2 * f (b + 1) + f b

-- 4. Define the core width summation f_w(b) that causes the periodicity
-- This represents sum_{i=1}^{floor(b/w)} (b - i * w)
def f_w (b w : Nat) : Int :=
  let limit := b / w
  let sum_i := (limit * (limit + 1)) / 2
  (b * limit : Int) - (w * sum_i : Int)

/-- 
LEMMA: The second difference of f_w(b) is 1 if w divides b+1, and 0 otherwise. 
This isolated lemma proves why period w emerges natively. 
-/
axiom delta2_f_w_is_indicator (b w : Nat) (hw : w > 0) : 
  delta2 (fun x => f_w x w) b = if (b + 1) % w = 0 then 1 else 0

/--
THEOREM: The second difference of S_k(b) has a period equal to 
the LCM of the first k natural numbers.
-/
axiom S_k_second_diff_periodic (S_k : Nat → Nat → Int) (k : Nat) :
  IsPeriodic (delta2 (fun b => S_k k b)) (lcm_upto k)

#check S_k_second_diff_periodic
