open Ag_syntax

module type AG_Spec = sig

  (* label set *)
  val label_set : string list

  (* nts *)
  val nt_set : nt list

  (* prods *)
  val prod_set : prod list

end