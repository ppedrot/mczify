From Coq Require Import ZArith ZifyClasses ZifyBool.
From Coq Require Export Lia.

From mathcomp Require Import ssreflect ssrfun ssrbool eqtype ssrnat seq path.
From mathcomp Require Import div choice fintype tuple finfun bigop finset prime.
From mathcomp Require Import order binomial ssralg countalg ssrnum ssrint rat.
From mathcomp Require Import intdiv.
From mathcomp Require Import zify_ssreflect ssrZ.

Set Implicit Arguments.
Unset Strict Implicit.
Unset Printing Implicit Defensive.

Module AlgebraZifyInstances.

Local Delimit Scope Z_scope with Z.

Import Order.Theory GRing.Theory Num.Theory SsreflectZifyInstances.

(******************************************************************************)
(* ssrint                                                                     *)
(******************************************************************************)

Instance Inj_int_Z : InjTyp int Z :=
  { inj := Z_of_int; pred _ := True; cstr _ := I }.
Add Zify InjTyp Inj_int_Z.

Instance Op_Z_of_int : UnOp Z_of_int := { TUOp := id; TUOpInj _ := erefl }.
Add Zify UnOp Op_Z_of_int.

Instance Op_int_of_Z : UnOp int_of_Z := { TUOp := id; TUOpInj := int_of_ZK }.
Add Zify UnOp Op_int_of_Z.

Instance Op_Posz : UnOp Posz := { TUOp := id; TUOpInj _ := erefl }.
Add Zify UnOp Op_Posz.

Instance Op_Negz : UnOp Negz :=
  { TUOp x := (- (x + 1))%Z; TUOpInj := ltac:(simpl; lia) }.
Add Zify UnOp Op_Negz.

Instance Op_int_eq : BinRel (@eq int) :=
  { TR := @eq Z; TRInj := ltac:(by split=> [->|/(can_inj Z_of_intK)]) }.
Add Zify BinRel Op_int_eq.

Instance Op_int_eq_op : BinOp (@eq_op int_eqType : int -> int -> bool) :=
  { TBOp := Z.eqb;
    TBOpInj := ltac:(move=> [] ? [] ?; do 2 rewrite eqE /=; lia) }.
Add Zify BinOp Op_int_eq_op.

Instance Op_int_0 : CstOp (0%R : int) := { TCst := 0%Z; TCstInj := erefl }.
Add Zify CstOp Op_int_0.

Instance Op_addz : BinOp intZmod.addz := { TBOp := Z.add; TBOpInj := raddfD _ }.
Add Zify BinOp Op_addz.

Instance Op_int_add : BinOp +%R := Op_addz.
Add Zify BinOp Op_int_add.

Instance Op_oppz : UnOp intZmod.oppz := { TUOp := Z.opp; TUOpInj := raddfN _ }.
Add Zify UnOp Op_oppz.

Instance Op_int_opp : UnOp (@GRing.opp _) := Op_oppz.
Add Zify UnOp Op_int_opp.

Instance Op_int_1 : CstOp (1%R : int) := { TCst := 1%Z; TCstInj := erefl }.
Add Zify CstOp Op_int_1.

Instance Op_mulz : BinOp intRing.mulz :=
  { TBOp := Z.mul; TBOpInj := rmorphM _ }.
Add Zify BinOp Op_mulz.

Instance Op_int_mulr : BinOp *%R := Op_mulz.
Add Zify BinOp Op_int_mulr.

Instance Op_int_natmul : BinOp (@GRing.natmul _ : int -> nat -> int) :=
  { TBOp := Z.mul; TBOpInj _ _ := ltac:(rewrite /= pmulrn mulrzz; lia) }.
Add Zify BinOp Op_int_natmul.

Instance Op_int_intmul : BinOp ( *~%R%R : int -> int -> int) :=
  { TBOp := Z.mul; TBOpInj _ _ := ltac:(rewrite /= mulrzz; lia) }.
Add Zify BinOp Op_int_intmul.

Instance Op_int_scale : BinOp (@GRing.scale _ [lmodType int of int^o]) :=
  Op_mulz.
Add Zify BinOp Op_int_scale.

Fact Op_int_exp_subproof n m : Z_of_int (n ^+ m) = (Z_of_int n ^ Z.of_nat m)%Z.
Proof. rewrite -Zpower_nat_Z; elim: m => //= m <-; rewrite exprS; lia. Qed.

Instance Op_int_exp : BinOp (@GRing.exp _ : int -> nat -> int) :=
  { TBOp := Z.pow; TBOpInj := Op_int_exp_subproof }.
Add Zify BinOp Op_int_exp.

Instance Op_unitz : UnOp (has_quality 1 intUnitRing.unitz : int -> bool) :=
  { TUOp x := (x =? 1)%Z || (x =? - 1)%Z; TUOpInj := ltac:(simpl; lia) }.
Add Zify UnOp Op_unitz.

Instance Op_int_unit : UnOp (has_quality 1 GRing.unit) := Op_unitz.
Add Zify UnOp Op_int_unit.

Instance Op_invz : UnOp intUnitRing.invz :=
  { TUOp := id; TUOpInj _ := erefl }.
Add Zify UnOp Op_invz.

Instance Op_int_inv : UnOp GRing.inv := Op_invz.
Add Zify UnOp Op_int_inv.

Instance Op_absz : UnOp absz :=
  { TUOp := Z.abs; TUOpInj := ltac:(case=> ? /=; lia) }.
Add Zify UnOp Op_absz.

Instance Op_int_normr : UnOp (Num.norm : int -> int) :=
  { TUOp := Z.abs; TUOpInj := ltac:(rewrite /Num.norm /=; lia) }.
Add Zify UnOp Op_int_normr.

Instance Op_lez : BinOp intOrdered.lez :=
  { TBOp := Z.leb; TBOpInj := ltac:(case=> ? [] ? /=; lia) }.
Add Zify BinOp Op_lez.

Instance Op_ltz : BinOp intOrdered.ltz :=
  { TBOp := Z.ltb; TBOpInj := ltac:(case=> ? [] ? /=; lia) }.
Add Zify BinOp Op_ltz.

Instance Op_int_sgr : UnOp (Num.sg : int -> int) :=
  { TUOp := Z.sgn; TUOpInj := ltac:(case=> [[]|] //=; lia) }.
Add Zify UnOp Op_int_sgr.

Instance Op_int_sgz : UnOp (@sgz _) := Op_int_sgr.
Add Zify UnOp Op_int_sgz.

Instance Op_int_le : BinOp <=%O := Op_lez.
Add Zify BinOp Op_int_le.

Instance Op_int_le' : BinOp (>=^d%O : rel int^d) := Op_lez.
Add Zify BinOp Op_int_le'.

Instance Op_int_ge : BinOp (>=%O : int -> int -> bool) :=
  { TBOp := Z.geb; TBOpInj := ltac:(simpl; lia) }.
Add Zify BinOp Op_int_ge.

Instance Op_int_ge' : BinOp (<=^d%O : rel int^d) := Op_int_ge.
Add Zify BinOp Op_int_ge'.

Instance Op_int_lt : BinOp <%O := Op_ltz.
Add Zify BinOp Op_int_lt.

Instance Op_int_lt' : BinOp (>^d%O : rel int^d) := Op_ltz.
Add Zify BinOp Op_int_lt'.

Instance Op_int_gt : BinOp (>%O : int -> int -> bool) :=
  { TBOp := Z.gtb; TBOpInj := ltac:(simpl; lia) }.
Add Zify BinOp Op_int_gt.

Instance Op_int_gt' : BinOp (<^d%O : rel int^d) := Op_int_gt.
Add Zify BinOp Op_int_gt'.

Instance Op_int_min : BinOp (Order.min : int -> int -> int) :=
  { TBOp := Z.min; TBOpInj _ _ := ltac:(case: leP => /=; lia) }.
Add Zify BinOp Op_int_min.

Instance Op_int_min' : BinOp ((Order.max : int^d -> _) : int -> int -> int) :=
  { TBOp := Z.min; TBOpInj _ _ := ltac:(case: leP => /=; lia) }.
Add Zify BinOp Op_int_min'.

Instance Op_int_max : BinOp (Order.max : int -> int -> int) :=
  { TBOp := Z.max; TBOpInj _ _ := ltac:(case: leP => /=; lia) }.
Add Zify BinOp Op_int_max.

Instance Op_int_max' : BinOp ((Order.min : int^d -> _) : int -> int -> int) :=
  { TBOp := Z.max; TBOpInj _ _ := ltac:(case: leP => /=; lia) }.
Add Zify BinOp Op_int_max'.

Instance Op_int_meet : BinOp (Order.meet : int -> int -> int) :=
  { TBOp := Z.min; TBOpInj _ _ := ltac:(case: leP => /=; lia) }.
Add Zify BinOp Op_int_meet.

Instance Op_int_meet' : BinOp (Order.join : int^d -> _) := Op_int_min.
Add Zify BinOp Op_int_meet'.

Instance Op_int_join : BinOp (Order.join : int -> int -> int) :=
  { TBOp := Z.max; TBOpInj _ _ := ltac:(case: leP => /=; lia) }.
Add Zify BinOp Op_int_join.

Instance Op_int_join' : BinOp (Order.meet : int^d -> _) := Op_int_max.
Add Zify BinOp Op_int_join'.

(******************************************************************************)
(* ssrZ                                                                       *)
(******************************************************************************)

Instance Op_Z_eq_op : BinOp (eq_op : Z -> Z -> bool) := Op_Zeqb.
Add Zify BinOp Op_Z_eq_op.

Instance Op_Z_0 : CstOp (0%R : Z) := { TCst := 0%Z; TCstInj := erefl }.
Add Zify CstOp Op_Z_0.

Instance Op_Z_add : BinOp (+%R : Z -> Z -> Z) :=
  { TBOp := Z.add; TBOpInj _ _ := erefl }.
Add Zify BinOp Op_Z_add.

Instance Op_Z_opp : UnOp (@GRing.opp _ : Z -> Z) :=
  { TUOp := Z.opp; TUOpInj _ := erefl }.
Add Zify UnOp Op_Z_opp.

Instance Op_Z_1 : CstOp (1%R : Z) := { TCst := 1%Z; TCstInj := erefl }.
Add Zify CstOp Op_Z_1.

Instance Op_Z_mulr : BinOp ( *%R : Z -> Z -> Z) :=
  { TBOp := Z.mul; TBOpInj _ _ := erefl }.
Add Zify BinOp Op_Z_mulr.

Fact Op_Z_natmul_subproof (n : Z) (m : nat) : (n *+ m)%R = (n * Z.of_nat m)%Z.
Proof. elim: m => [|m]; rewrite (mulr0n, mulrS); lia. Qed.

Instance Op_Z_natmul : BinOp (@GRing.natmul _ : Z -> nat -> Z) :=
  { TBOp := Z.mul; TBOpInj := Op_Z_natmul_subproof }.
Add Zify BinOp Op_Z_natmul.

Instance Op_Z_intmul : BinOp ( *~%R%R : Z -> int -> Z) :=
  { TBOp := Z.mul; TBOpInj := ltac:(move=> n [] m; rewrite /intmul /=; lia) }.
Add Zify BinOp Op_Z_intmul.

Instance Op_Z_scale : BinOp (@GRing.scale _ [lmodType Z of Z^o]) := Op_Z_mulr.
Add Zify BinOp Op_Z_scale.

Fact Op_Z_exp_subproof n m : (n ^+ m)%R = (n ^ Z.of_nat m)%Z.
Proof. by rewrite -Zpower_nat_Z; elim: m => //= m <-; rewrite exprS. Qed.

Instance Op_Z_exp : BinOp (@GRing.exp _ : Z -> nat -> Z) :=
  { TBOp := Z.pow; TBOpInj := Op_Z_exp_subproof }.
Add Zify BinOp Op_Z_exp.

Instance Op_unitZ : UnOp (has_quality 1 ZInstances.unitZ : Z -> bool) :=
  { TUOp x := (x =? 1)%Z || (x =? - 1)%Z; TUOpInj _ := erefl }.
Add Zify UnOp Op_unitZ.

Instance Op_Z_unit : UnOp (has_quality 1 GRing.unit : Z -> bool) := Op_unitZ.
Add Zify UnOp Op_Z_unit.

Instance Op_invZ : UnOp ZInstances.invZ := { TUOp := id; TUOpInj _ := erefl }.
Add Zify UnOp Op_invZ.

Instance Op_Z_inv : UnOp (GRing.inv : Z -> Z) :=
  { TUOp := id; TUOpInj _ := erefl }.
Add Zify UnOp Op_Z_inv.

Instance Op_Z_normr : UnOp (Num.norm : Z -> Z) :=
  { TUOp := Z.abs; TUOpInj _ := erefl }.
Add Zify UnOp Op_Z_normr.

Instance Op_Z_sgr : UnOp (Num.sg : Z -> Z) :=
  { TUOp := Z.sgn; TUOpInj := ltac:(case=> //=; lia) }.
Add Zify UnOp Op_Z_sgr.

Instance Op_Z_le : BinOp (<=%O : Z -> Z -> bool) :=
  { TBOp := Z.leb; TBOpInj _ _ := erefl }.
Add Zify BinOp Op_Z_le.

Instance Op_Z_le' : BinOp (>=^d%O : rel Z^d) := Op_Z_le.
Add Zify BinOp Op_Z_le'.

Instance Op_Z_ge : BinOp (>=%O : Z -> Z -> bool) :=
  { TBOp := Z.geb; TBOpInj := ltac:(simpl; lia) }.
Add Zify BinOp Op_Z_ge.

Instance Op_Z_ge' : BinOp (<=^d%O : rel Z^d) := Op_Z_ge.
Add Zify BinOp Op_Z_ge'.

Instance Op_Z_lt : BinOp (<%O : Z -> Z -> bool) :=
  { TBOp := Z.ltb; TBOpInj _ _ := erefl }.
Add Zify BinOp Op_Z_lt.

Instance Op_Z_lt' : BinOp (>^d%O : rel Z^d) := Op_Z_lt.
Add Zify BinOp Op_Z_lt'.

Instance Op_Z_gt : BinOp (>%O : Z -> Z -> bool) :=
  { TBOp := Z.gtb; TBOpInj := ltac:(simpl; lia) }.
Add Zify BinOp Op_Z_gt.

Instance Op_Z_gt' : BinOp (<^d%O : rel Z^d) := Op_Z_gt.
Add Zify BinOp Op_Z_gt'.

Instance Op_Z_min : BinOp (Order.min : Z -> Z -> Z) :=
  { TBOp := Z.min; TBOpInj _ _ := ltac:(case: leP => /=; lia) }.
Add Zify BinOp Op_Z_min.

Instance Op_Z_min' : BinOp ((Order.max : Z^d -> _) : Z -> Z -> Z) :=
  { TBOp := Z.min; TBOpInj _ _ := ltac:(case: leP => /=; lia) }.
Add Zify BinOp Op_Z_min'.

Instance Op_Z_max : BinOp (Order.max : Z -> Z -> Z) :=
  { TBOp := Z.max; TBOpInj _ _ := ltac:(case: leP => /=; lia) }.
Add Zify BinOp Op_Z_max.

Instance Op_Z_max' : BinOp ((Order.min : Z^d -> _) : Z -> Z -> Z) :=
  { TBOp := Z.max; TBOpInj _ _ := ltac:(case: leP => /=; lia) }.
Add Zify BinOp Op_Z_max'.

Instance Op_Z_meet : BinOp (Order.meet : Z -> Z -> Z) :=
  { TBOp := Z.min; TBOpInj _ _ := ltac:(case: leP => /=; lia) }.
Add Zify BinOp Op_Z_meet.

Instance Op_Z_meet' : BinOp (Order.join : Z^d -> _) := Op_Z_min.
Add Zify BinOp Op_Z_meet'.

Instance Op_Z_join : BinOp (Order.join : Z -> Z -> Z) :=
  { TBOp := Z.max; TBOpInj _ _ := ltac:(case: leP => /=; lia) }.
Add Zify BinOp Op_Z_join.

Instance Op_Z_join' : BinOp (Order.meet : Z^d -> _) := Op_Z_max.
Add Zify BinOp Op_Z_join'.

(******************************************************************************)
(* intdiv                                                                     *)
(******************************************************************************)

Fact Op_divz_subproof n m :
  Z_of_int (divz n m) = divZ (Z_of_int n) (Z_of_int m).
Proof. case: n => [[|n]|n]; rewrite /divz /divZ /= ?addn1 /=; nia. Qed.

Instance Op_divz : BinOp (divz : int -> int -> int) :=
  { TBOp := divZ; TBOpInj := Op_divz_subproof }.
Add Zify BinOp Op_divz.

Instance Op_modz : BinOp modz :=
  { TBOp := modZ; TBOpInj := ltac:(rewrite /= /modz; lia) }.
Add Zify BinOp Op_modz.

Instance Op_dvdz : BinOp dvdz :=
  { TBOp n m := (modZ m n =? 0)%Z;
    TBOpInj _ _ := ltac:(apply/dvdz_mod0P/idP; lia) }.
Add Zify BinOp Op_dvdz.

Fact Op_gcdz_subproof n m :
  Z_of_int (gcdz n m) = Z.gcd (Z_of_int n) (Z_of_int m).
Proof. rewrite /gcdz -Z.gcd_abs_l -Z.gcd_abs_r; lia. Qed.

Instance Op_gcdz : BinOp gcdz := { TBOp := Z.gcd; TBOpInj := Op_gcdz_subproof }.
Add Zify BinOp Op_gcdz.

Instance Op_coprimez : BinOp coprimez :=
  { TBOp x y := (Z.gcd x y =? 1)%Z;
    TBOpInj := ltac:(rewrite /= /coprimez; lia) }.
Add Zify BinOp Op_coprimez.

Module Exports.
Add Zify InjTyp Inj_int_Z.
Add Zify UnOp Op_Z_of_int.
Add Zify UnOp Op_Posz.
Add Zify UnOp Op_Negz.
Add Zify BinRel Op_int_eq.
Add Zify BinOp Op_int_eq_op.
Add Zify CstOp Op_int_0.
Add Zify BinOp Op_addz.
Add Zify BinOp Op_int_add.
Add Zify UnOp Op_oppz.
Add Zify UnOp Op_int_opp.
Add Zify CstOp Op_int_1.
Add Zify BinOp Op_mulz.
Add Zify BinOp Op_int_mulr.
Add Zify BinOp Op_int_natmul.
Add Zify BinOp Op_int_intmul.
Add Zify BinOp Op_int_scale.
Add Zify BinOp Op_int_exp.
Add Zify UnOp Op_unitz.
Add Zify UnOp Op_int_unit.
Add Zify UnOp Op_invz.
Add Zify UnOp Op_int_inv.
Add Zify UnOp Op_absz.
Add Zify UnOp Op_int_normr.
Add Zify BinOp Op_lez.
Add Zify BinOp Op_ltz.
Add Zify UnOp Op_int_sgr.
Add Zify UnOp Op_int_sgz.
Add Zify BinOp Op_int_le.
Add Zify BinOp Op_int_le'.
Add Zify BinOp Op_int_ge.
Add Zify BinOp Op_int_ge'.
Add Zify BinOp Op_int_lt.
Add Zify BinOp Op_int_lt'.
Add Zify BinOp Op_int_gt.
Add Zify BinOp Op_int_gt'.
Add Zify BinOp Op_int_min.
Add Zify BinOp Op_int_min'.
Add Zify BinOp Op_int_max.
Add Zify BinOp Op_int_max'.
Add Zify BinOp Op_int_meet.
Add Zify BinOp Op_int_meet'.
Add Zify BinOp Op_int_join.
Add Zify BinOp Op_int_join'.
Add Zify BinOp Op_Z_eq_op.
Add Zify CstOp Op_Z_0.
Add Zify BinOp Op_Z_add.
Add Zify UnOp Op_Z_opp.
Add Zify CstOp Op_Z_1.
Add Zify BinOp Op_Z_mulr.
Add Zify BinOp Op_Z_natmul.
Add Zify BinOp Op_Z_intmul.
Add Zify BinOp Op_Z_scale.
Add Zify BinOp Op_Z_exp.
Add Zify UnOp Op_unitZ.
Add Zify UnOp Op_Z_unit.
Add Zify UnOp Op_invZ.
Add Zify UnOp Op_Z_inv.
Add Zify UnOp Op_Z_normr.
Add Zify UnOp Op_Z_sgr.
Add Zify BinOp Op_Z_le.
Add Zify BinOp Op_Z_le'.
Add Zify BinOp Op_Z_ge.
Add Zify BinOp Op_Z_ge'.
Add Zify BinOp Op_Z_lt.
Add Zify BinOp Op_Z_lt'.
Add Zify BinOp Op_Z_gt.
Add Zify BinOp Op_Z_gt'.
Add Zify BinOp Op_Z_min.
Add Zify BinOp Op_Z_min'.
Add Zify BinOp Op_Z_max.
Add Zify BinOp Op_Z_max'.
Add Zify BinOp Op_Z_meet.
Add Zify BinOp Op_Z_meet'.
Add Zify BinOp Op_Z_join.
Add Zify BinOp Op_Z_join'.
Add Zify BinOp Op_divz.
Add Zify BinOp Op_modz.
Add Zify BinOp Op_dvdz.
Add Zify BinOp Op_gcdz.
Add Zify BinOp Op_coprimez.
End Exports.

End AlgebraZifyInstances.
Export SsreflectZifyInstances.Exports.
Export AlgebraZifyInstances.Exports.
