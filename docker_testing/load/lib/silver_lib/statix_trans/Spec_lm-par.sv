inherited attribute s_par::Decorated Scope;
inherited attribute s_def::Decorated Scope;
inherited attribute s::Decorated Scope;

synthesized attribute s_par_VAR::[Decorated Scope];
synthesized attribute s_par_IMP::[Decorated Scope];
synthesized attribute s_par_MOD::[Decorated Scope];
synthesized attribute s_par_LEX::[Decorated Scope];
synthesized attribute s_def_VAR::[Decorated Scope];
synthesized attribute s_def_IMP::[Decorated Scope];
synthesized attribute s_def_MOD::[Decorated Scope];
synthesized attribute s_def_LEX::[Decorated Scope];
synthesized attribute ty::Nt_type;
synthesized attribute ok::Boolean;
synthesized attribute p::Decorated Path;
synthesized attribute s_VAR::[Decorated Scope];
synthesized attribute s_IMP::[Decorated Scope];
synthesized attribute s_MOD::[Decorated Scope];
synthesized attribute s_LEX::[Decorated Scope];

nonterminal Nt_main with ok;
nonterminal Nt_decls with s, s_par, ok, s_VAR, s_IMP, s_MOD, s_LEX, s_par_VAR, s_par_IMP, s_par_MOD, s_par_LEX;
nonterminal Nt_decl with s, s_par, ok, s_VAR, s_IMP, s_MOD, s_LEX, s_par_VAR, s_par_IMP, s_par_MOD, s_par_LEX;
nonterminal Nt_expr with s, ok, ty, s_VAR, s_IMP, s_MOD, s_LEX;
nonterminal Nt_seq_binds with s, s_def, ok, s_VAR, s_IMP, s_MOD, s_LEX, s_def_VAR, s_def_IMP, s_def_MOD, s_def_LEX;
nonterminal Nt_seq_bind with s, s_def, ok, s_VAR, s_IMP, s_MOD, s_LEX, s_def_VAR, s_def_IMP, s_def_MOD, s_def_LEX;
nonterminal Nt_par_binds with s, s_def, ok, s_VAR, s_IMP, s_MOD, s_LEX, s_def_VAR, s_def_IMP, s_def_MOD, s_def_LEX;
nonterminal Nt_par_bind with s, s_def, ok, s_VAR, s_IMP, s_MOD, s_LEX, s_def_VAR, s_def_IMP, s_def_MOD, s_def_LEX;
nonterminal Nt_arg_decl with s, ok, ty, s_VAR, s_IMP, s_MOD, s_LEX;
nonterminal Nt_type with s, ok, ty, s_VAR, s_IMP, s_MOD, s_LEX;
nonterminal Nt_mod_ref with s, ok, p, s_VAR, s_IMP, s_MOD, s_LEX;
nonterminal Nt_var_ref with s, ok, p, s_VAR, s_IMP, s_MOD, s_LEX;




abstract production pf_Program
top::Nt_main ::= ds::Nt_decls {
	local attribute s::Decorated Scope;
	local attribute s_VAR::[Decorated Scope];
	local attribute s_IMP::[Decorated Scope];
	local attribute s_MOD::[Decorated Scope];
	local attribute s_LEX::[Decorated Scope];
	scope_s_.VAR = s_VAR;
	scope_s_.IMP = s_IMP;
	scope_s_.MOD = s_MOD;
	scope_s_.LEX = s_LEX;
	s = scope_s_;
	local scope_s_::Scope = pf_mkScope();
	ds.s = s;
	ds.s_par = s;
	top.ok = ds.ok && true;
	s_VAR = (ds.s_VAR) ++ (ds.s_par_VAR) ++ [];
	s_IMP = (ds.s_IMP) ++ (ds.s_par_IMP) ++ [];
	s_MOD = (ds.s_MOD) ++ (ds.s_par_MOD) ++ [];
	s_LEX = (ds.s_LEX) ++ (ds.s_par_LEX) ++ [];
}
abstract production pf_DeclsNil
top::Nt_decls ::=  {
	top.ok = true && true;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
	top.s_par_VAR = [];
	top.s_par_IMP = [];
	top.s_par_MOD = [];
	top.s_par_LEX = [];
}
abstract production pf_DeclsCons
top::Nt_decls ::= d::Nt_decl ds::Nt_decls {
	d.s = top.s;
	d.s_par = top.s_par;
	ds.s = top.s;
	ds.s_par = top.s_par;
	top.ok = d.ok && ds.ok && true;
	top.s_VAR = (d.s_VAR) ++ (ds.s_VAR) ++ [];
	top.s_IMP = (d.s_IMP) ++ (ds.s_IMP) ++ [];
	top.s_MOD = (d.s_MOD) ++ (ds.s_MOD) ++ [];
	top.s_LEX = (d.s_LEX) ++ (ds.s_LEX) ++ [];
	top.s_par_VAR = (d.s_par_VAR) ++ (ds.s_par_VAR) ++ [];
	top.s_par_IMP = (d.s_par_IMP) ++ (ds.s_par_IMP) ++ [];
	top.s_par_MOD = (d.s_par_MOD) ++ (ds.s_par_MOD) ++ [];
	top.s_par_LEX = (d.s_par_LEX) ++ (ds.s_par_LEX) ++ [];
}
abstract production pf_DatumMod
top::Datum ::= datum_id::String {
	
}
abstract production pf_ActualDataDatumMod
top::Nt_actualData ::= arg_5::Decorated Scope {
	
}
abstract production pf_DeclModule
top::Nt_decl ::= x::String ds::Nt_decls {
	local attribute s_mod::Decorated Scope;
	local attribute s_mod_VAR::[Decorated Scope];
	local attribute s_mod_IMP::[Decorated Scope];
	local attribute s_mod_MOD::[Decorated Scope];
	local attribute s_mod_LEX::[Decorated Scope];
	scope_s_mod_.VAR = s_mod_VAR;
	scope_s_mod_.IMP = s_mod_IMP;
	scope_s_mod_.MOD = s_mod_MOD;
	scope_s_mod_.LEX = s_mod_LEX;
	local s_mod_datum::Datum = pf_DatumMod(x);
	s_mod_datum.data = pf_ActualDataDatumMod(s_mod);
	s_mod = scope_s_mod_;
	local scope_s_mod_::Scope = pf_mkScope();
	scope_s_mod_.datum = s_mod_datum;
	ds.s = s_mod;
	ds.s_par = top.s;
	top.ok = ds.ok && true;
	top.s_VAR = (ds.s_par_VAR) ++ [];
	top.s_IMP = (ds.s_par_IMP) ++ [];
	top.s_MOD = (s_mod::[]) ++ (ds.s_par_MOD) ++ [];
	top.s_LEX = (ds.s_par_LEX) ++ [];
	top.s_par_VAR = [];
	top.s_par_IMP = [];
	top.s_par_MOD = [];
	top.s_par_LEX = [];
	s_mod_VAR = (ds.s_VAR) ++ [];
	s_mod_IMP = (ds.s_IMP) ++ [];
	s_mod_MOD = (ds.s_MOD) ++ [];
	s_mod_LEX = (top.s::[]) ++ (ds.s_LEX) ++ [];
}
abstract production pf_DeclImport
top::Nt_decl ::= r::Nt_mod_ref {
	local attribute p::Decorated Path;
	local attribute d::Decorated Datum;
	local attribute s_mod::Decorated Scope;
	local attribute tgt_s::Decorated Scope;
	r.s = top.s_par;
	p = r.p;
	local attribute pair_6::(Boolean, Decorated Scope);
	pair_6 = pf_tgt(p);
	tgt_s = pair_6.2;
	d = tgt_s.datum;
	s_mod = case d of pf_DatumMod(_) -> if true then let d_lam_arg::Decorated Datum = d in case d_lam_arg.data of pf_ActualDataDatumMod(dscope) -> dscope | _ -> error("data match abort") end end else error("branch case else TODO") | _ -> error("Match failure!") end;
	top.ok = r.ok && pair_6.1 && true;
	top.s_VAR = [];
	top.s_IMP = (s_mod::[]) ++ [];
	top.s_MOD = [];
	top.s_LEX = [];
	top.s_par_VAR = (r.s_VAR) ++ [];
	top.s_par_IMP = (r.s_IMP) ++ [];
	top.s_par_MOD = (r.s_MOD) ++ [];
	top.s_par_LEX = (r.s_LEX) ++ [];
}
abstract production pf_DeclDef
top::Nt_decl ::= b::Nt_par_bind {
	b.s = top.s;
	b.s_def = top.s;
	top.ok = b.ok && true;
	top.s_VAR = (b.s_VAR) ++ (b.s_def_VAR) ++ [];
	top.s_IMP = (b.s_IMP) ++ (b.s_def_IMP) ++ [];
	top.s_MOD = (b.s_MOD) ++ (b.s_def_MOD) ++ [];
	top.s_LEX = (b.s_LEX) ++ (b.s_def_LEX) ++ [];
	top.s_par_VAR = [];
	top.s_par_IMP = [];
	top.s_par_MOD = [];
	top.s_par_LEX = [];
}
abstract production pf_ExprInt
top::Nt_expr ::= i::String {
	top.ty = pf_TInt();
	top.ok = true;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
}
abstract production pf_ExprTrue
top::Nt_expr ::=  {
	top.ty = pf_TBool();
	top.ok = true;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
}
abstract production pf_ExprFalse
top::Nt_expr ::=  {
	top.ty = pf_TBool();
	top.ok = true;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
}
abstract production pf_ExprVar
top::Nt_expr ::= r::Nt_var_ref {
	local attribute p::Decorated Path;
	local attribute d::Decorated Datum;
	local attribute tgt_s::Decorated Scope;
	r.s = top.s;
	p = r.p;
	local attribute pair_7::(Boolean, Decorated Scope);
	pair_7 = pf_tgt(p);
	tgt_s = pair_7.2;
	d = tgt_s.datum;
	top.ty = case d of pf_DatumVar(_) -> if true then let d_lam_arg::Decorated Datum = d in case d_lam_arg.data of pf_ActualDataDatumVar(dty) -> ^dty | _ -> error("data match abort") end end else error("branch case else TODO") | _ -> error("Match failure!") end;
	top.ok = r.ok && pair_7.1 && true;
	top.s_VAR = (r.s_VAR) ++ [];
	top.s_IMP = (r.s_IMP) ++ [];
	top.s_MOD = (r.s_MOD) ++ [];
	top.s_LEX = (r.s_LEX) ++ [];
}
abstract production pf_ExprAdd
top::Nt_expr ::= e1::Nt_expr e2::Nt_expr {
	local attribute ty1::Nt_type;
	local attribute ty2::Nt_type;
	e1.s = top.s;
	ty1 = e1.ty;
	e2.s = top.s;
	ty2 = e2.ty;
	top.ty = pf_TInt();
	top.ok = e1.ok && e2.ok && ^ty1 == pf_TInt() && ^ty2 == pf_TInt() && true;
	top.s_VAR = (e1.s_VAR) ++ (e2.s_VAR) ++ [];
	top.s_IMP = (e1.s_IMP) ++ (e2.s_IMP) ++ [];
	top.s_MOD = (e1.s_MOD) ++ (e2.s_MOD) ++ [];
	top.s_LEX = (e1.s_LEX) ++ (e2.s_LEX) ++ [];
}
abstract production pf_ExprAnd
top::Nt_expr ::= e1::Nt_expr e2::Nt_expr {
	local attribute ty1::Nt_type;
	local attribute ty2::Nt_type;
	e1.s = top.s;
	ty1 = e1.ty;
	e2.s = top.s;
	ty2 = e2.ty;
	top.ty = pf_TBool();
	top.ok = e1.ok && e2.ok && ^ty1 == pf_TBool() && ^ty2 == pf_TBool() && true;
	top.s_VAR = (e1.s_VAR) ++ (e2.s_VAR) ++ [];
	top.s_IMP = (e1.s_IMP) ++ (e2.s_IMP) ++ [];
	top.s_MOD = (e1.s_MOD) ++ (e2.s_MOD) ++ [];
	top.s_LEX = (e1.s_LEX) ++ (e2.s_LEX) ++ [];
}
abstract production pf_ExprEq
top::Nt_expr ::= e1::Nt_expr e2::Nt_expr {
	local attribute ty1::Nt_type;
	local attribute ty2::Nt_type;
	e1.s = top.s;
	ty1 = e1.ty;
	e2.s = top.s;
	ty2 = e2.ty;
	top.ty = pf_TBool();
	top.ok = e1.ok && e2.ok && ^ty1 == ^ty2 && true;
	top.s_VAR = (e1.s_VAR) ++ (e2.s_VAR) ++ [];
	top.s_IMP = (e1.s_IMP) ++ (e2.s_IMP) ++ [];
	top.s_MOD = (e1.s_MOD) ++ (e2.s_MOD) ++ [];
	top.s_LEX = (e1.s_LEX) ++ (e2.s_LEX) ++ [];
}
abstract production pf_ExprApp
top::Nt_expr ::= e1::Nt_expr e2::Nt_expr {
	local attribute ty1::Nt_type;
	local attribute ty2::Nt_type;
	e1.s = top.s;
	ty1 = e1.ty;
	e2.s = top.s;
	ty2 = e2.ty;
	top.ty = case ^ty1 of pf_TFun(l, r) -> if true then ^r else error("branch case else TODO") | _ -> error("Match failure!") end;
	top.ok = e1.ok && e2.ok && case ^ty1 of pf_TFun(l, r) -> if true then ^ty2 == ^l else error("branch case else TODO") | _ -> error("Match failure!") end && true;
	top.s_VAR = (e1.s_VAR) ++ (e2.s_VAR) ++ [];
	top.s_IMP = (e1.s_IMP) ++ (e2.s_IMP) ++ [];
	top.s_MOD = (e1.s_MOD) ++ (e2.s_MOD) ++ [];
	top.s_LEX = (e1.s_LEX) ++ (e2.s_LEX) ++ [];
}
abstract production pf_ExprIf
top::Nt_expr ::= e1::Nt_expr e2::Nt_expr e3::Nt_expr {
	local attribute ty1::Nt_type;
	local attribute ty2::Nt_type;
	local attribute ty3::Nt_type;
	e1.s = top.s;
	ty1 = e1.ty;
	e2.s = top.s;
	ty2 = e2.ty;
	e3.s = top.s;
	ty3 = e3.ty;
	top.ty = ^ty2;
	top.ok = e1.ok && e2.ok && e3.ok && ^ty1 == pf_TBool() && ^ty2 == ^ty3 && true;
	top.s_VAR = (e1.s_VAR) ++ (e2.s_VAR) ++ (e3.s_VAR) ++ [];
	top.s_IMP = (e1.s_IMP) ++ (e2.s_IMP) ++ (e3.s_IMP) ++ [];
	top.s_MOD = (e1.s_MOD) ++ (e2.s_MOD) ++ (e3.s_MOD) ++ [];
	top.s_LEX = (e1.s_LEX) ++ (e2.s_LEX) ++ (e3.s_LEX) ++ [];
}
abstract production pf_ExprFun
top::Nt_expr ::= d::Nt_arg_decl e::Nt_expr {
	local attribute s_fun::Decorated Scope;
	local attribute ty1::Nt_type;
	local attribute ty2::Nt_type;
	local attribute s_fun_VAR::[Decorated Scope];
	local attribute s_fun_IMP::[Decorated Scope];
	local attribute s_fun_MOD::[Decorated Scope];
	local attribute s_fun_LEX::[Decorated Scope];
	scope_s_fun_.VAR = s_fun_VAR;
	scope_s_fun_.IMP = s_fun_IMP;
	scope_s_fun_.MOD = s_fun_MOD;
	scope_s_fun_.LEX = s_fun_LEX;
	s_fun = scope_s_fun_;
	local scope_s_fun_::Scope = pf_mkScope();
	d.s = s_fun;
	ty1 = d.ty;
	e.s = s_fun;
	ty2 = e.ty;
	top.ty = pf_TFun(^ty1, ^ty2);
	top.ok = d.ok && e.ok && true;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
	s_fun_VAR = (d.s_VAR) ++ (e.s_VAR) ++ [];
	s_fun_IMP = (d.s_IMP) ++ (e.s_IMP) ++ [];
	s_fun_MOD = (d.s_MOD) ++ (e.s_MOD) ++ [];
	s_fun_LEX = (top.s::[]) ++ (d.s_LEX) ++ (e.s_LEX) ++ [];
}
abstract production pf_ExprLet
top::Nt_expr ::= bs::Nt_seq_binds e::Nt_expr {
	local attribute s_let::Decorated Scope;
	local attribute s_let_VAR::[Decorated Scope];
	local attribute s_let_IMP::[Decorated Scope];
	local attribute s_let_MOD::[Decorated Scope];
	local attribute s_let_LEX::[Decorated Scope];
	scope_s_let_.VAR = s_let_VAR;
	scope_s_let_.IMP = s_let_IMP;
	scope_s_let_.MOD = s_let_MOD;
	scope_s_let_.LEX = s_let_LEX;
	s_let = scope_s_let_;
	local scope_s_let_::Scope = pf_mkScope();
	bs.s = top.s;
	bs.s_def = s_let;
	e.s = s_let;
	top.ty = e.ty;
	top.ok = bs.ok && e.ok && true;
	top.s_VAR = (bs.s_VAR) ++ [];
	top.s_IMP = (bs.s_IMP) ++ [];
	top.s_MOD = (bs.s_MOD) ++ [];
	top.s_LEX = (bs.s_LEX) ++ [];
	s_let_VAR = (bs.s_def_VAR) ++ (e.s_VAR) ++ [];
	s_let_IMP = (bs.s_def_IMP) ++ (e.s_IMP) ++ [];
	s_let_MOD = (bs.s_def_MOD) ++ (e.s_MOD) ++ [];
	s_let_LEX = (bs.s_def_LEX) ++ (e.s_LEX) ++ [];
}
abstract production pf_ExprLetRec
top::Nt_expr ::= bs::Nt_par_binds e::Nt_expr {
	local attribute s_let::Decorated Scope;
	local attribute s_let_VAR::[Decorated Scope];
	local attribute s_let_IMP::[Decorated Scope];
	local attribute s_let_MOD::[Decorated Scope];
	local attribute s_let_LEX::[Decorated Scope];
	scope_s_let_.VAR = s_let_VAR;
	scope_s_let_.IMP = s_let_IMP;
	scope_s_let_.MOD = s_let_MOD;
	scope_s_let_.LEX = s_let_LEX;
	s_let = scope_s_let_;
	local scope_s_let_::Scope = pf_mkScope();
	bs.s = s_let;
	bs.s_def = s_let;
	e.s = s_let;
	top.ty = e.ty;
	top.ok = bs.ok && e.ok && true;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
	s_let_VAR = (bs.s_VAR) ++ (bs.s_def_VAR) ++ (e.s_VAR) ++ [];
	s_let_IMP = (bs.s_IMP) ++ (bs.s_def_IMP) ++ (e.s_IMP) ++ [];
	s_let_MOD = (bs.s_MOD) ++ (bs.s_def_MOD) ++ (e.s_MOD) ++ [];
	s_let_LEX = (top.s::[]) ++ (bs.s_LEX) ++ (bs.s_def_LEX) ++ (e.s_LEX) ++ [];
}
abstract production pf_ExprLetPar
top::Nt_expr ::= bs::Nt_par_binds e::Nt_expr {
	local attribute s_let::Decorated Scope;
	local attribute s_let_VAR::[Decorated Scope];
	local attribute s_let_IMP::[Decorated Scope];
	local attribute s_let_MOD::[Decorated Scope];
	local attribute s_let_LEX::[Decorated Scope];
	scope_s_let_.VAR = s_let_VAR;
	scope_s_let_.IMP = s_let_IMP;
	scope_s_let_.MOD = s_let_MOD;
	scope_s_let_.LEX = s_let_LEX;
	s_let = scope_s_let_;
	local scope_s_let_::Scope = pf_mkScope();
	bs.s = top.s;
	bs.s_def = s_let;
	e.s = s_let;
	top.ty = e.ty;
	top.ok = bs.ok && e.ok && true;
	top.s_VAR = (bs.s_VAR) ++ [];
	top.s_IMP = (bs.s_IMP) ++ [];
	top.s_MOD = (bs.s_MOD) ++ [];
	top.s_LEX = (bs.s_LEX) ++ [];
	s_let_VAR = (bs.s_def_VAR) ++ (e.s_VAR) ++ [];
	s_let_IMP = (bs.s_def_IMP) ++ (e.s_IMP) ++ [];
	s_let_MOD = (bs.s_def_MOD) ++ (e.s_MOD) ++ [];
	s_let_LEX = (top.s::[]) ++ (bs.s_def_LEX) ++ (e.s_LEX) ++ [];
}
abstract production pf_SeqBindsNil
top::Nt_seq_binds ::=  {
	top.ok = true;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
	top.s_def_VAR = [];
	top.s_def_IMP = [];
	top.s_def_MOD = [];
	top.s_def_LEX = (top.s::[]) ++ [];
}
abstract production pf_SeqBindsOne
top::Nt_seq_binds ::= b::Nt_seq_bind {
	b.s = top.s;
	b.s_def = top.s_def;
	top.ok = b.ok && true;
	top.s_VAR = (b.s_VAR) ++ [];
	top.s_IMP = (b.s_IMP) ++ [];
	top.s_MOD = (b.s_MOD) ++ [];
	top.s_LEX = (b.s_LEX) ++ [];
	top.s_def_VAR = (b.s_def_VAR) ++ [];
	top.s_def_IMP = (b.s_def_IMP) ++ [];
	top.s_def_MOD = (b.s_def_MOD) ++ [];
	top.s_def_LEX = (top.s::[]) ++ (b.s_def_LEX) ++ [];
}
abstract production pf_SeqBindsCons
top::Nt_seq_binds ::= b::Nt_seq_bind bs::Nt_seq_binds {
	local attribute s_def_::Decorated Scope;
	local attribute s_def__VAR::[Decorated Scope];
	local attribute s_def__IMP::[Decorated Scope];
	local attribute s_def__MOD::[Decorated Scope];
	local attribute s_def__LEX::[Decorated Scope];
	scope_s_def__.VAR = s_def__VAR;
	scope_s_def__.IMP = s_def__IMP;
	scope_s_def__.MOD = s_def__MOD;
	scope_s_def__.LEX = s_def__LEX;
	s_def_ = scope_s_def__;
	local scope_s_def__::Scope = pf_mkScope();
	b.s = top.s;
	b.s_def = s_def_;
	bs.s = s_def_;
	bs.s_def = top.s_def;
	top.ok = b.ok && bs.ok && true;
	top.s_VAR = (b.s_VAR) ++ [];
	top.s_IMP = (b.s_IMP) ++ [];
	top.s_MOD = (b.s_MOD) ++ [];
	top.s_LEX = (b.s_LEX) ++ [];
	top.s_def_VAR = (bs.s_def_VAR) ++ [];
	top.s_def_IMP = (bs.s_def_IMP) ++ [];
	top.s_def_MOD = (bs.s_def_MOD) ++ [];
	top.s_def_LEX = (bs.s_def_LEX) ++ [];
	s_def__VAR = (b.s_def_VAR) ++ (bs.s_VAR) ++ [];
	s_def__IMP = (b.s_def_IMP) ++ (bs.s_IMP) ++ [];
	s_def__MOD = (b.s_def_MOD) ++ (bs.s_MOD) ++ [];
	s_def__LEX = (top.s::[]) ++ (b.s_def_LEX) ++ (bs.s_LEX) ++ [];
}
abstract production pf_DefBindSeq
top::Nt_seq_bind ::= x::String e::Nt_expr {
	local attribute s_var::Decorated Scope;
	local attribute ty::Nt_type;
	local attribute s_var_VAR::[Decorated Scope];
	local attribute s_var_IMP::[Decorated Scope];
	local attribute s_var_MOD::[Decorated Scope];
	local attribute s_var_LEX::[Decorated Scope];
	scope_s_var_.VAR = s_var_VAR;
	scope_s_var_.IMP = s_var_IMP;
	scope_s_var_.MOD = s_var_MOD;
	scope_s_var_.LEX = s_var_LEX;
	local s_var_datum::Datum = pf_DatumVar(x);
	s_var_datum.data = pf_ActualDataDatumVar(^ty);
	s_var = scope_s_var_;
	local scope_s_var_::Scope = pf_mkScope();
	scope_s_var_.datum = s_var_datum;
	e.s = top.s;
	ty = e.ty;
	top.ok = e.ok && true;
	top.s_VAR = (s_var::[]) ++ (e.s_VAR) ++ [];
	top.s_IMP = (e.s_IMP) ++ [];
	top.s_MOD = (e.s_MOD) ++ [];
	top.s_LEX = (e.s_LEX) ++ [];
	top.s_def_VAR = [];
	top.s_def_IMP = [];
	top.s_def_MOD = [];
	top.s_def_LEX = [];
	s_var_VAR = [];
	s_var_IMP = [];
	s_var_MOD = [];
	s_var_LEX = [];
}
abstract production pf_DefBindTypedSeq
top::Nt_seq_bind ::= x::String tyann::Nt_type e::Nt_expr {
	local attribute s_var::Decorated Scope;
	local attribute ty::Nt_type;
	local attribute s_var_VAR::[Decorated Scope];
	local attribute s_var_IMP::[Decorated Scope];
	local attribute s_var_MOD::[Decorated Scope];
	local attribute s_var_LEX::[Decorated Scope];
	scope_s_var_.VAR = s_var_VAR;
	scope_s_var_.IMP = s_var_IMP;
	scope_s_var_.MOD = s_var_MOD;
	scope_s_var_.LEX = s_var_LEX;
	local s_var_datum::Datum = pf_DatumVar(x);
	s_var_datum.data = pf_ActualDataDatumVar(^ty);
	s_var = scope_s_var_;
	local scope_s_var_::Scope = pf_mkScope();
	scope_s_var_.datum = s_var_datum;
	tyann.s = top.s;
	ty = tyann.ty;
	e.s = top.s;
	ty = e.ty;
	top.ok = tyann.ok && e.ok && true;
	top.s_VAR = (s_var::[]) ++ (tyann.s_VAR) ++ (e.s_VAR) ++ [];
	top.s_IMP = (tyann.s_IMP) ++ (e.s_IMP) ++ [];
	top.s_MOD = (tyann.s_MOD) ++ (e.s_MOD) ++ [];
	top.s_LEX = (tyann.s_LEX) ++ (e.s_LEX) ++ [];
	top.s_def_VAR = [];
	top.s_def_IMP = [];
	top.s_def_MOD = [];
	top.s_def_LEX = [];
	s_var_VAR = [];
	s_var_IMP = [];
	s_var_MOD = [];
	s_var_LEX = [];
}
abstract production pf_ParBindsNil
top::Nt_par_binds ::=  {
	top.ok = true && true;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
	top.s_def_VAR = [];
	top.s_def_IMP = [];
	top.s_def_MOD = [];
	top.s_def_LEX = [];
}
abstract production pf_ParBindsCons
top::Nt_par_binds ::= b::Nt_par_bind bs::Nt_par_binds {
	b.s = top.s;
	b.s_def = top.s_def;
	bs.s = top.s;
	bs.s_def = top.s_def;
	top.ok = b.ok && bs.ok && true;
	top.s_VAR = (b.s_VAR) ++ (bs.s_VAR) ++ [];
	top.s_IMP = (b.s_IMP) ++ (bs.s_IMP) ++ [];
	top.s_MOD = (b.s_MOD) ++ (bs.s_MOD) ++ [];
	top.s_LEX = (b.s_LEX) ++ (bs.s_LEX) ++ [];
	top.s_def_VAR = (b.s_def_VAR) ++ (bs.s_def_VAR) ++ [];
	top.s_def_IMP = (b.s_def_IMP) ++ (bs.s_def_IMP) ++ [];
	top.s_def_MOD = (b.s_def_MOD) ++ (bs.s_def_MOD) ++ [];
	top.s_def_LEX = (b.s_def_LEX) ++ (bs.s_def_LEX) ++ [];
}
abstract production pf_DefBindPar
top::Nt_par_bind ::= x::String e::Nt_expr {
	local attribute s_var::Decorated Scope;
	local attribute ty::Nt_type;
	local attribute s_var_VAR::[Decorated Scope];
	local attribute s_var_IMP::[Decorated Scope];
	local attribute s_var_MOD::[Decorated Scope];
	local attribute s_var_LEX::[Decorated Scope];
	scope_s_var_.VAR = s_var_VAR;
	scope_s_var_.IMP = s_var_IMP;
	scope_s_var_.MOD = s_var_MOD;
	scope_s_var_.LEX = s_var_LEX;
	local s_var_datum::Datum = pf_DatumVar(x);
	s_var_datum.data = pf_ActualDataDatumVar(^ty);
	s_var = scope_s_var_;
	local scope_s_var_::Scope = pf_mkScope();
	scope_s_var_.datum = s_var_datum;
	e.s = top.s;
	ty = e.ty;
	top.ok = e.ok && true;
	top.s_VAR = (e.s_VAR) ++ [];
	top.s_IMP = (e.s_IMP) ++ [];
	top.s_MOD = (e.s_MOD) ++ [];
	top.s_LEX = (e.s_LEX) ++ [];
	top.s_def_VAR = (s_var::[]) ++ [];
	top.s_def_IMP = [];
	top.s_def_MOD = [];
	top.s_def_LEX = [];
	s_var_VAR = [];
	s_var_IMP = [];
	s_var_MOD = [];
	s_var_LEX = [];
}
abstract production pf_DefBindTypedPar
top::Nt_par_bind ::= x::String tyann::Nt_type e::Nt_expr {
	local attribute s_var::Decorated Scope;
	local attribute ty::Nt_type;
	local attribute s_var_VAR::[Decorated Scope];
	local attribute s_var_IMP::[Decorated Scope];
	local attribute s_var_MOD::[Decorated Scope];
	local attribute s_var_LEX::[Decorated Scope];
	scope_s_var_.VAR = s_var_VAR;
	scope_s_var_.IMP = s_var_IMP;
	scope_s_var_.MOD = s_var_MOD;
	scope_s_var_.LEX = s_var_LEX;
	local s_var_datum::Datum = pf_DatumVar(x);
	s_var_datum.data = pf_ActualDataDatumVar(^ty);
	s_var = scope_s_var_;
	local scope_s_var_::Scope = pf_mkScope();
	scope_s_var_.datum = s_var_datum;
	tyann.s = top.s;
	ty = tyann.ty;
	e.s = top.s;
	ty = e.ty;
	top.ok = tyann.ok && e.ok && true;
	top.s_VAR = (tyann.s_VAR) ++ (e.s_VAR) ++ [];
	top.s_IMP = (tyann.s_IMP) ++ (e.s_IMP) ++ [];
	top.s_MOD = (tyann.s_MOD) ++ (e.s_MOD) ++ [];
	top.s_LEX = (tyann.s_LEX) ++ (e.s_LEX) ++ [];
	top.s_def_VAR = (s_var::[]) ++ [];
	top.s_def_IMP = [];
	top.s_def_MOD = [];
	top.s_def_LEX = [];
	s_var_VAR = [];
	s_var_IMP = [];
	s_var_MOD = [];
	s_var_LEX = [];
}
abstract production pf_DatumVar
top::Datum ::= datum_id::String {
	
}
abstract production pf_ActualDataDatumVar
top::Nt_actualData ::= arg_8::Nt_type {
	
}
abstract production pf_ArgDecl
top::Nt_arg_decl ::= x::String tyann::Nt_type {
	local attribute s_var::Decorated Scope;
	tyann.s = top.s;
	top.ty = tyann.ty;
	local attribute s_var_VAR::[Decorated Scope];
	local attribute s_var_IMP::[Decorated Scope];
	local attribute s_var_MOD::[Decorated Scope];
	local attribute s_var_LEX::[Decorated Scope];
	scope_s_var_.VAR = s_var_VAR;
	scope_s_var_.IMP = s_var_IMP;
	scope_s_var_.MOD = s_var_MOD;
	scope_s_var_.LEX = s_var_LEX;
	local s_var_datum::Datum = pf_DatumVar(x);
	s_var_datum.data = pf_ActualDataDatumVar(top.ty);
	s_var = scope_s_var_;
	local scope_s_var_::Scope = pf_mkScope();
	scope_s_var_.datum = s_var_datum;
	top.ok = tyann.ok && true;
	top.s_VAR = (tyann.s_VAR) ++ (s_var::[]) ++ [];
	top.s_IMP = (tyann.s_IMP) ++ [];
	top.s_MOD = (tyann.s_MOD) ++ [];
	top.s_LEX = (tyann.s_LEX) ++ [];
	s_var_VAR = [];
	s_var_IMP = [];
	s_var_MOD = [];
	s_var_LEX = [];
}
abstract production pf_TInt
top::Nt_type ::=  {
	top.ty = pf_TInt();
	top.ok = true;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
}
abstract production pf_TBool
top::Nt_type ::=  {
	top.ty = pf_TBool();
	top.ok = true;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
}
abstract production pf_TFun
top::Nt_type ::= tyann1::Nt_type tyann2::Nt_type {
	local attribute ty1::Nt_type;
	local attribute ty2::Nt_type;
	tyann1.s = top.s;
	ty1 = tyann1.ty;
	tyann2.s = top.s;
	ty2 = tyann2.ty;
	top.ty = pf_TFun(^ty1, ^ty2);
	top.ok = tyann1.ok && tyann2.ok && true;
	top.s_VAR = (tyann1.s_VAR) ++ (tyann2.s_VAR) ++ [];
	top.s_IMP = (tyann1.s_IMP) ++ (tyann2.s_IMP) ++ [];
	top.s_MOD = (tyann1.s_MOD) ++ (tyann2.s_MOD) ++ [];
	top.s_LEX = (tyann1.s_LEX) ++ (tyann2.s_LEX) ++ [];
}
abstract production pf_ModRef
top::Nt_mod_ref ::= x::String {
	local attribute mods::[Decorated Path];
	local attribute xmods::[Decorated Path];
	local attribute xmods_::[Decorated Path];
	mods = pf_query(top.s, pf_regexSeq(pf_regexStar(pf_regexLabel(pf_labelLEX())), pf_regexSeq(pf_regexAlt(pf_regexLabel(pf_labelIMP()), pf_regexEps()), pf_regexLabel(pf_labelMOD()))));
	xmods = pf_path_filter(\d_lam_arg::Decorated Datum -> case d_lam_arg of pf_DatumMod(x_) -> x_ == x | _ -> false end, mods);
	xmods_ = pf_path_min(\l::Label r::Label -> case (l, r) of (pf_labelMOD(), pf_labelLEX()) -> -1 | (pf_labelLEX(), pf_labelMOD()) -> 1 | (pf_labelMOD(), pf_labelIMP()) -> -1 | (pf_labelIMP(), pf_labelMOD()) -> 1 | (pf_labelVAR(), pf_labelLEX()) -> -1 | (pf_labelLEX(), pf_labelVAR()) -> 1 | (pf_labelVAR(), pf_labelIMP()) -> -1 | (pf_labelIMP(), pf_labelVAR()) -> 1 | (pf_labelIMP(), pf_labelLEX()) -> -1 | (pf_labelLEX(), pf_labelIMP()) -> 1 | (_, _) -> 0 end, xmods);
	top.p = pf_one(xmods_);
	top.ok = true;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
}
abstract production pf_VarRef
top::Nt_var_ref ::= x::String {
	local attribute vars::[Decorated Path];
	local attribute xvars::[Decorated Path];
	local attribute xvars_::[Decorated Path];
	vars = pf_query(top.s, pf_regexSeq(pf_regexStar(pf_regexLabel(pf_labelLEX())), pf_regexSeq(pf_regexAlt(pf_regexLabel(pf_labelIMP()), pf_regexEps()), pf_regexLabel(pf_labelVAR()))));
	xvars = pf_path_filter(\d_lam_arg::Decorated Datum -> case d_lam_arg of pf_DatumVar(x_) -> x_ == x | _ -> false end, vars);
	xvars_ = pf_path_min(\l::Label r::Label -> case (l, r) of (pf_labelMOD(), pf_labelLEX()) -> -1 | (pf_labelLEX(), pf_labelMOD()) -> 1 | (pf_labelMOD(), pf_labelIMP()) -> -1 | (pf_labelIMP(), pf_labelMOD()) -> 1 | (pf_labelVAR(), pf_labelLEX()) -> -1 | (pf_labelLEX(), pf_labelVAR()) -> 1 | (pf_labelVAR(), pf_labelIMP()) -> -1 | (pf_labelIMP(), pf_labelVAR()) -> 1 | (pf_labelIMP(), pf_labelLEX()) -> -1 | (pf_labelLEX(), pf_labelIMP()) -> 1 | (_, _) -> 0 end, xvars);
	top.p = pf_one(xvars_);
	top.ok = true;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
}


function pf_tgt
(Boolean, Decorated Scope) ::= p::Decorated Path {
	local attribute ok::Boolean;
	local attribute s::Decorated Scope;
	local attribute pair_9::(Boolean, Decorated Scope);
	pair_9 = case p of pf_End(x) -> if true then (true, x) else error("branch case else TODO") | pf_Edge(x, l, xs) -> if true then pf_tgt(xs) else error("branch case else TODO") | _ -> error("Match failure!") end;
	s = pair_9.2;
	return (ok, s);
	ok = pair_9.1 && true;
}
function pf_eq_Nt_main
Boolean ::= l::Nt_main r::Nt_main {
	return case (l, r) of (pf_Program(arg_0), pf_Program(arg_1)) -> ^arg_0 == ^arg_1 && true | (_, _) -> false end;
}
instance Eq Nt_main {eq = \l::Nt_main r::Nt_main -> pf_eq_Nt_main(l, r); }
function pf_eq_Nt_decls
Boolean ::= l::Nt_decls r::Nt_decls {
	return case (l, r) of (pf_DeclsNil(), pf_DeclsNil()) -> true | (pf_DeclsCons(arg_1, arg_0), pf_DeclsCons(arg_3, arg_2)) -> ^arg_1 == ^arg_3 && ^arg_0 == ^arg_2 && true | (_, _) -> false end;
}
instance Eq Nt_decls {eq = \l::Nt_decls r::Nt_decls -> pf_eq_Nt_decls(l, r); }
function pf_eq_Nt_decl
Boolean ::= l::Nt_decl r::Nt_decl {
	return case (l, r) of (pf_DeclModule(arg_1, arg_0), pf_DeclModule(arg_3, arg_2)) -> arg_1 == arg_3 && ^arg_0 == ^arg_2 && true | (pf_DeclImport(arg_0), pf_DeclImport(arg_1)) -> ^arg_0 == ^arg_1 && true | (pf_DeclDef(arg_0), pf_DeclDef(arg_1)) -> ^arg_0 == ^arg_1 && true | (_, _) -> false end;
}
instance Eq Nt_decl {eq = \l::Nt_decl r::Nt_decl -> pf_eq_Nt_decl(l, r); }
function pf_eq_Nt_expr
Boolean ::= l::Nt_expr r::Nt_expr {
	return case (l, r) of (pf_ExprInt(arg_0), pf_ExprInt(arg_1)) -> arg_0 == arg_1 && true | (pf_ExprTrue(), pf_ExprTrue()) -> true | (pf_ExprFalse(), pf_ExprFalse()) -> true | (pf_ExprVar(arg_0), pf_ExprVar(arg_1)) -> ^arg_0 == ^arg_1 && true | (pf_ExprAdd(arg_1, arg_0), pf_ExprAdd(arg_3, arg_2)) -> ^arg_1 == ^arg_3 && ^arg_0 == ^arg_2 && true | (pf_ExprAnd(arg_1, arg_0), pf_ExprAnd(arg_3, arg_2)) -> ^arg_1 == ^arg_3 && ^arg_0 == ^arg_2 && true | (pf_ExprEq(arg_1, arg_0), pf_ExprEq(arg_3, arg_2)) -> ^arg_1 == ^arg_3 && ^arg_0 == ^arg_2 && true | (pf_ExprApp(arg_1, arg_0), pf_ExprApp(arg_3, arg_2)) -> ^arg_1 == ^arg_3 && ^arg_0 == ^arg_2 && true | (pf_ExprIf(arg_2, arg_1, arg_0), pf_ExprIf(arg_5, arg_4, arg_3)) -> ^arg_2 == ^arg_5 && ^arg_1 == ^arg_4 && ^arg_0 == ^arg_3 && true | (pf_ExprFun(arg_1, arg_0), pf_ExprFun(arg_3, arg_2)) -> ^arg_1 == ^arg_3 && ^arg_0 == ^arg_2 && true | (pf_ExprLet(arg_1, arg_0), pf_ExprLet(arg_3, arg_2)) -> ^arg_1 == ^arg_3 && ^arg_0 == ^arg_2 && true | (pf_ExprLetRec(arg_1, arg_0), pf_ExprLetRec(arg_3, arg_2)) -> ^arg_1 == ^arg_3 && ^arg_0 == ^arg_2 && true | (pf_ExprLetPar(arg_1, arg_0), pf_ExprLetPar(arg_3, arg_2)) -> ^arg_1 == ^arg_3 && ^arg_0 == ^arg_2 && true | (_, _) -> false end;
}
instance Eq Nt_expr {eq = \l::Nt_expr r::Nt_expr -> pf_eq_Nt_expr(l, r); }
function pf_eq_Nt_seq_binds
Boolean ::= l::Nt_seq_binds r::Nt_seq_binds {
	return case (l, r) of (pf_SeqBindsNil(), pf_SeqBindsNil()) -> true | (pf_SeqBindsOne(arg_0), pf_SeqBindsOne(arg_1)) -> ^arg_0 == ^arg_1 && true | (pf_SeqBindsCons(arg_1, arg_0), pf_SeqBindsCons(arg_3, arg_2)) -> ^arg_1 == ^arg_3 && ^arg_0 == ^arg_2 && true | (_, _) -> false end;
}
instance Eq Nt_seq_binds {eq = \l::Nt_seq_binds r::Nt_seq_binds -> pf_eq_Nt_seq_binds(l, r); }
function pf_eq_Nt_seq_bind
Boolean ::= l::Nt_seq_bind r::Nt_seq_bind {
	return case (l, r) of (pf_DefBindSeq(arg_1, arg_0), pf_DefBindSeq(arg_3, arg_2)) -> arg_1 == arg_3 && ^arg_0 == ^arg_2 && true | (pf_DefBindTypedSeq(arg_2, arg_1, arg_0), pf_DefBindTypedSeq(arg_5, arg_4, arg_3)) -> arg_2 == arg_5 && ^arg_1 == ^arg_4 && ^arg_0 == ^arg_3 && true | (_, _) -> false end;
}
instance Eq Nt_seq_bind {eq = \l::Nt_seq_bind r::Nt_seq_bind -> pf_eq_Nt_seq_bind(l, r); }
function pf_eq_Nt_par_binds
Boolean ::= l::Nt_par_binds r::Nt_par_binds {
	return case (l, r) of (pf_ParBindsNil(), pf_ParBindsNil()) -> true | (pf_ParBindsCons(arg_1, arg_0), pf_ParBindsCons(arg_3, arg_2)) -> ^arg_1 == ^arg_3 && ^arg_0 == ^arg_2 && true | (_, _) -> false end;
}
instance Eq Nt_par_binds {eq = \l::Nt_par_binds r::Nt_par_binds -> pf_eq_Nt_par_binds(l, r); }
function pf_eq_Nt_par_bind
Boolean ::= l::Nt_par_bind r::Nt_par_bind {
	return case (l, r) of (pf_DefBindPar(arg_1, arg_0), pf_DefBindPar(arg_3, arg_2)) -> arg_1 == arg_3 && ^arg_0 == ^arg_2 && true | (pf_DefBindTypedPar(arg_2, arg_1, arg_0), pf_DefBindTypedPar(arg_5, arg_4, arg_3)) -> arg_2 == arg_5 && ^arg_1 == ^arg_4 && ^arg_0 == ^arg_3 && true | (_, _) -> false end;
}
instance Eq Nt_par_bind {eq = \l::Nt_par_bind r::Nt_par_bind -> pf_eq_Nt_par_bind(l, r); }
function pf_eq_Nt_arg_decl
Boolean ::= l::Nt_arg_decl r::Nt_arg_decl {
	return case (l, r) of (pf_ArgDecl(arg_1, arg_0), pf_ArgDecl(arg_3, arg_2)) -> arg_1 == arg_3 && ^arg_0 == ^arg_2 && true | (_, _) -> false end;
}
instance Eq Nt_arg_decl {eq = \l::Nt_arg_decl r::Nt_arg_decl -> pf_eq_Nt_arg_decl(l, r); }
function pf_eq_Nt_type
Boolean ::= l::Nt_type r::Nt_type {
	return case (l, r) of (pf_TInt(), pf_TInt()) -> true | (pf_TBool(), pf_TBool()) -> true | (pf_TFun(arg_1, arg_0), pf_TFun(arg_3, arg_2)) -> ^arg_1 == ^arg_3 && ^arg_0 == ^arg_2 && true | (_, _) -> false end;
}
instance Eq Nt_type {eq = \l::Nt_type r::Nt_type -> pf_eq_Nt_type(l, r); }
function pf_eq_Nt_mod_ref
Boolean ::= l::Nt_mod_ref r::Nt_mod_ref {
	return case (l, r) of (pf_ModRef(arg_0), pf_ModRef(arg_1)) -> arg_0 == arg_1 && true | (_, _) -> false end;
}
instance Eq Nt_mod_ref {eq = \l::Nt_mod_ref r::Nt_mod_ref -> pf_eq_Nt_mod_ref(l, r); }
function pf_eq_Nt_var_ref
Boolean ::= l::Nt_var_ref r::Nt_var_ref {
	return case (l, r) of (pf_VarRef(arg_0), pf_VarRef(arg_1)) -> arg_0 == arg_1 && true | (_, _) -> false end;
}
instance Eq Nt_var_ref {eq = \l::Nt_var_ref r::Nt_var_ref -> pf_eq_Nt_var_ref(l, r); }


abstract production pf_labelVAR top::Label ::= {}
abstract production pf_labelIMP top::Label ::= {}
abstract production pf_labelMOD top::Label ::= {}
abstract production pf_labelLEX top::Label ::= {}

function eqLabel Boolean ::= l1::Label l2::Label {return case (l1, l2) of (pf_labelVAR(), pf_labelVAR()) -> true | (pf_labelIMP(), pf_labelIMP()) -> true | (pf_labelMOD(), pf_labelMOD()) -> true | (pf_labelLEX(), pf_labelLEX()) -> true | (_, _) -> false end;}

inherited attribute VAR::[Decorated Scope] occurs on Scope;
inherited attribute IMP::[Decorated Scope] occurs on Scope;
inherited attribute MOD::[Decorated Scope] occurs on Scope;
inherited attribute LEX::[Decorated Scope] occurs on Scope;

global globalLabelList::[Label] = [pf_labelVAR(), pf_labelIMP(), pf_labelMOD(), pf_labelLEX()];

function demandEdgesForLabel [Decorated Scope] ::= s::Decorated Scope l::Label {return case l of pf_labelVAR() -> s.VAR | pf_labelIMP() -> s.IMP | pf_labelMOD() -> s.MOD | pf_labelLEX() -> s.LEX end;}
