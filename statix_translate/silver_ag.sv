inherited attribute s_def::Decorated Scope;
inherited attribute s::Decorated Scope;

synthesized attribute s_def_VAR::[Decorated Scope];
synthesized attribute s_def_IMP::[Decorated Scope];
synthesized attribute s_def_MOD::[Decorated Scope];
synthesized attribute s_def_LEX::[Decorated Scope];
synthesized attribute ty::Nt_type;
synthesized attribute ok::Boolean;
synthesized attribute p::Path;
synthesized attribute s_VAR::[Decorated Scope];
synthesized attribute s_IMP::[Decorated Scope];
synthesized attribute s_MOD::[Decorated Scope];
synthesized attribute s_LEX::[Decorated Scope];

nonterminal Nt_main with ok;
nonterminal Nt_decls with s, ok, s_VAR, s_IMP, s_MOD, s_LEX;
nonterminal Nt_decl with s, ok, s_VAR, s_IMP, s_MOD, s_LEX;
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
	local s::Decorated Scope;
	local s_VAR::[Decorated Scope];
	local s_IMP::[Decorated Scope];
	local s_MOD::[Decorated Scope];
	local s_LEX::[Decorated Scope];
	_s_.VAR = top.s_VAR;
	_s_.IMP = top.s_IMP;
	_s_.MOD = top.s_MOD;
	_s_.LEX = top.s_LEX;
	top.s = _s_;
	local _s_::Scope = pf_mkScope();
	
	ds.s = top.s;
	
	
	
	
	top.ok = ds.ok;
	top.s_VAR = (ds.s_VAR);
	top.s_IMP = (ds.s_IMP);
	top.s_MOD = (ds.s_MOD);
	top.s_LEX = (ds.s_LEX);
}
abstract production pf_DeclsNil
top::Nt_decls ::=  {
	
	top.ok = true;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
}
abstract production pf_DeclsCons
top::Nt_decls ::= d::Nt_decl ds::Nt_decls {
	
	d.s = top.s;
	
	
	
	
	
	ds.s = top.s;
	
	
	
	
	top.ok = d.ok && ds.ok;
	top.s_VAR = (d.s_VAR) ++ (ds.s_VAR);
	top.s_IMP = (d.s_IMP) ++ (ds.s_IMP);
	top.s_MOD = (d.s_MOD) ++ (ds.s_MOD);
	top.s_LEX = (d.s_LEX) ++ (ds.s_LEX);
}
abstract production pf_DatumMod
top::Datum ::= datum_id::String {
	
}
abstract production pf_ActualDataDatumMod
top::Nt_actualData ::= arg_5::Decorated Scope {
	
}
abstract production pf_DeclModule
top::Nt_decl ::= x::String ds::Nt_decls {
	local s_mod::Decorated Scope;
	local s_mod_VAR::[Decorated Scope];
	local s_mod_IMP::[Decorated Scope];
	local s_mod_MOD::[Decorated Scope];
	local s_mod_LEX::[Decorated Scope];
	_s_mod_.VAR = top.s_mod_VAR;
	_s_mod_.IMP = top.s_mod_IMP;
	_s_mod_.MOD = top.s_mod_MOD;
	_s_mod_.LEX = top.s_mod_LEX;
	local s_mod_datum::Datum = pf_DatumMod(top.x);
	s_mod_datum.data = pf_ActualDataDatumMod(top.s_mod);
	top.s_mod = _s_mod_;
	local _s_mod_::Scope = pf_mkScope();
	_s_mod_.datum = s_mod_datum;
	
	
	
	ds.s = top.s_mod;
	
	
	
	
	top.ok = ds.ok;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = (top.s_mod::[]);
	top.s_LEX = [];
	top.s_mod_VAR = (ds.s_VAR);
	top.s_mod_IMP = (ds.s_IMP);
	top.s_mod_MOD = (ds.s_MOD);
	top.s_mod_LEX = (top.s::[]) ++ (ds.s_LEX);
}
abstract production pf_DeclImport
top::Nt_decl ::= r::Nt_mod_ref {
	local p::Path;
	local d::Decorated Datum;
	local s_mod::Decorated Scope;
	local tgt_s::Decorated Scope;
	
	r.s = top.s;
	top.p = r.p;
	
	
	
	
	local pair_6::(Boolean, Decorated Scope);
	top.pair_6 = pf_tgt(top.p);
	
	top.tgt_s = top.pair_6.2;
	top.d = top.tgt_s.datum;
	top.s_mod = case top.d of pf_DatumMod(_) -> if true then let d_lam_arg::Decorated Datum = top.d in let dscope__::Nt_ActualData = case d_lam_arg.data of pf_ActualDataDatumMod(dscope) -> dscope | _ -> error("data match abort") end in dscope__ end end else error("branch case else TODO") | _ -> error("Match failure!") end;
	
	top.ok = r.ok && top.pair_6.1;
	top.s_VAR = (r.s_VAR);
	top.s_IMP = (r.s_IMP) ++ (top.s_mod::[]);
	top.s_MOD = (r.s_MOD);
	top.s_LEX = (r.s_LEX);
}
abstract production pf_DeclDef
top::Nt_decl ::= b::Nt_par_bind {
	
	b.s = top.s;
	b.s_def = top.s;
	
	
	
	
	
	
	
	
	top.ok = b.ok;
	top.s_VAR = (b.s_VAR) ++ (b.s_def_VAR);
	top.s_IMP = (b.s_IMP) ++ (b.s_def_IMP);
	top.s_MOD = (b.s_MOD) ++ (b.s_def_MOD);
	top.s_LEX = (b.s_LEX) ++ (b.s_def_LEX);
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
	local p::Path;
	local d::Decorated Datum;
	local tgt_s::Decorated Scope;
	
	r.s = top.s;
	top.p = r.p;
	
	
	
	
	local pair_7::(Boolean, Decorated Scope);
	top.pair_7 = pf_tgt(top.p);
	
	top.tgt_s = top.pair_7.2;
	top.d = top.tgt_s.datum;
	top.ty = case top.d of pf_DatumVar(_) -> if true then let d_lam_arg::Decorated Datum = top.d in let dty__::Nt_ActualData = case d_lam_arg.data of pf_ActualDataDatumVar(dty) -> dty | _ -> error("data match abort") end in dty__ end end else error("branch case else TODO") | _ -> error("Match failure!") end;
	top.ok = r.ok && top.pair_7.1;
	top.s_VAR = (r.s_VAR);
	top.s_IMP = (r.s_IMP);
	top.s_MOD = (r.s_MOD);
	top.s_LEX = (r.s_LEX);
}
abstract production pf_ExprAdd
top::Nt_expr ::= e1::Nt_expr e2::Nt_expr {
	local ty1::Nt_type;
	local ty2::Nt_type;
	
	e1.s = top.s;
	top.ty1 = e1.ty;
	
	
	
	
	
	e2.s = top.s;
	top.ty2 = e2.ty;
	
	
	
	
	
	
	top.ty = pf_TInt();
	top.ok = e1.ok && e2.ok && top.ty1 == pf_TInt() && top.ty2 == pf_TInt();
	top.s_VAR = (e1.s_VAR) ++ (e2.s_VAR);
	top.s_IMP = (e1.s_IMP) ++ (e2.s_IMP);
	top.s_MOD = (e1.s_MOD) ++ (e2.s_MOD);
	top.s_LEX = (e1.s_LEX) ++ (e2.s_LEX);
}
abstract production pf_ExprAnd
top::Nt_expr ::= e1::Nt_expr e2::Nt_expr {
	local ty1::Nt_type;
	local ty2::Nt_type;
	
	e1.s = top.s;
	top.ty1 = e1.ty;
	
	
	
	
	
	e2.s = top.s;
	top.ty2 = e2.ty;
	
	
	
	
	
	
	top.ty = pf_TBool();
	top.ok = e1.ok && e2.ok && top.ty1 == pf_TBool() && top.ty2 == pf_TBool();
	top.s_VAR = (e1.s_VAR) ++ (e2.s_VAR);
	top.s_IMP = (e1.s_IMP) ++ (e2.s_IMP);
	top.s_MOD = (e1.s_MOD) ++ (e2.s_MOD);
	top.s_LEX = (e1.s_LEX) ++ (e2.s_LEX);
}
abstract production pf_ExprEq
top::Nt_expr ::= e1::Nt_expr e2::Nt_expr {
	local ty1::Nt_type;
	local ty2::Nt_type;
	
	e1.s = top.s;
	top.ty1 = e1.ty;
	
	
	
	
	
	e2.s = top.s;
	top.ty2 = e2.ty;
	
	
	
	
	
	top.ty = pf_TBool();
	top.ok = e1.ok && e2.ok && top.ty1 == top.ty2;
	top.s_VAR = (e1.s_VAR) ++ (e2.s_VAR);
	top.s_IMP = (e1.s_IMP) ++ (e2.s_IMP);
	top.s_MOD = (e1.s_MOD) ++ (e2.s_MOD);
	top.s_LEX = (e1.s_LEX) ++ (e2.s_LEX);
}
abstract production pf_ExprApp
top::Nt_expr ::= e1::Nt_expr e2::Nt_expr {
	local ty1::Nt_type;
	local ty2::Nt_type;
	
	e1.s = top.s;
	top.ty1 = e1.ty;
	
	
	
	
	
	e2.s = top.s;
	top.ty2 = e2.ty;
	
	
	
	
	top.ty = case top.ty1 of pf_TFun(l, r) -> if true then r else error("branch case else TODO") | _ -> error("Match failure!") end;
	
	top.ok = e1.ok && e2.ok && case top.ty1 of pf_TFun(l, r) -> if true then top.ty2 == l else error("branch case else TODO") | _ -> error("Match failure!") end;
	top.s_VAR = (e1.s_VAR) ++ (e2.s_VAR);
	top.s_IMP = (e1.s_IMP) ++ (e2.s_IMP);
	top.s_MOD = (e1.s_MOD) ++ (e2.s_MOD);
	top.s_LEX = (e1.s_LEX) ++ (e2.s_LEX);
}
abstract production pf_ExprIf
top::Nt_expr ::= e1::Nt_expr e2::Nt_expr e3::Nt_expr {
	local ty1::Nt_type;
	local ty2::Nt_type;
	local ty3::Nt_type;
	
	e1.s = top.s;
	top.ty1 = e1.ty;
	
	
	
	
	
	e2.s = top.s;
	top.ty2 = e2.ty;
	
	
	
	
	
	e3.s = top.s;
	top.ty3 = e3.ty;
	
	
	
	
	
	
	top.ty = top.ty2;
	top.ok = e1.ok && e2.ok && e3.ok && top.ty1 == pf_TBool() && top.ty2 == top.ty3;
	top.s_VAR = (e1.s_VAR) ++ (e2.s_VAR) ++ (e3.s_VAR);
	top.s_IMP = (e1.s_IMP) ++ (e2.s_IMP) ++ (e3.s_IMP);
	top.s_MOD = (e1.s_MOD) ++ (e2.s_MOD) ++ (e3.s_MOD);
	top.s_LEX = (e1.s_LEX) ++ (e2.s_LEX) ++ (e3.s_LEX);
}
abstract production pf_ExprFun
top::Nt_expr ::= d::Nt_arg_decl e::Nt_expr {
	local s_fun::Decorated Scope;
	local ty1::Nt_type;
	local ty2::Nt_type;
	local s_fun_VAR::[Decorated Scope];
	local s_fun_IMP::[Decorated Scope];
	local s_fun_MOD::[Decorated Scope];
	local s_fun_LEX::[Decorated Scope];
	_s_fun_.VAR = top.s_fun_VAR;
	_s_fun_.IMP = top.s_fun_IMP;
	_s_fun_.MOD = top.s_fun_MOD;
	_s_fun_.LEX = top.s_fun_LEX;
	top.s_fun = _s_fun_;
	local _s_fun_::Scope = pf_mkScope();
	
	
	d.s = top.s_fun;
	top.ty1 = d.ty;
	
	
	
	
	
	e.s = top.s_fun;
	top.ty2 = e.ty;
	
	
	
	
	top.ty = pf_TFun(top.ty1, top.ty2);
	top.ok = d.ok && e.ok;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
	top.s_fun_VAR = (d.s_VAR) ++ (e.s_VAR);
	top.s_fun_IMP = (d.s_IMP) ++ (e.s_IMP);
	top.s_fun_MOD = (d.s_MOD) ++ (e.s_MOD);
	top.s_fun_LEX = (top.s::[]) ++ (d.s_LEX) ++ (e.s_LEX);
}
abstract production pf_ExprLet
top::Nt_expr ::= bs::Nt_seq_binds e::Nt_expr {
	local s_let::Decorated Scope;
	local s_let_VAR::[Decorated Scope];
	local s_let_IMP::[Decorated Scope];
	local s_let_MOD::[Decorated Scope];
	local s_let_LEX::[Decorated Scope];
	_s_let_.VAR = top.s_let_VAR;
	_s_let_.IMP = top.s_let_IMP;
	_s_let_.MOD = top.s_let_MOD;
	_s_let_.LEX = top.s_let_LEX;
	top.s_let = _s_let_;
	local _s_let_::Scope = pf_mkScope();
	
	bs.s = top.s;
	bs.s_def = top.s_let;
	
	
	
	
	
	
	
	
	
	e.s = top.s_let;
	top.ty = e.ty;
	
	
	
	
	top.ok = bs.ok && e.ok;
	top.s_VAR = (bs.s_VAR);
	top.s_IMP = (bs.s_IMP);
	top.s_MOD = (bs.s_MOD);
	top.s_LEX = (bs.s_LEX);
	top.s_let_VAR = (bs.s_def_VAR) ++ (e.s_VAR);
	top.s_let_IMP = (bs.s_def_IMP) ++ (e.s_IMP);
	top.s_let_MOD = (bs.s_def_MOD) ++ (e.s_MOD);
	top.s_let_LEX = (bs.s_def_LEX) ++ (e.s_LEX);
}
abstract production pf_ExprLetRec
top::Nt_expr ::= bs::Nt_par_binds e::Nt_expr {
	local s_let::Decorated Scope;
	local s_let_VAR::[Decorated Scope];
	local s_let_IMP::[Decorated Scope];
	local s_let_MOD::[Decorated Scope];
	local s_let_LEX::[Decorated Scope];
	_s_let_.VAR = top.s_let_VAR;
	_s_let_.IMP = top.s_let_IMP;
	_s_let_.MOD = top.s_let_MOD;
	_s_let_.LEX = top.s_let_LEX;
	top.s_let = _s_let_;
	local _s_let_::Scope = pf_mkScope();
	
	
	bs.s = top.s_let;
	bs.s_def = top.s_let;
	
	
	
	
	
	
	
	
	
	e.s = top.s_let;
	top.ty = e.ty;
	
	
	
	
	top.ok = bs.ok && e.ok;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
	top.s_let_VAR = (bs.s_VAR) ++ (bs.s_def_VAR) ++ (e.s_VAR);
	top.s_let_IMP = (bs.s_IMP) ++ (bs.s_def_IMP) ++ (e.s_IMP);
	top.s_let_MOD = (bs.s_MOD) ++ (bs.s_def_MOD) ++ (e.s_MOD);
	top.s_let_LEX = (top.s::[]) ++ (bs.s_LEX) ++ (bs.s_def_LEX) ++ (e.s_LEX);
}
abstract production pf_ExprLetPar
top::Nt_expr ::= bs::Nt_par_binds e::Nt_expr {
	local s_let::Decorated Scope;
	local s_let_VAR::[Decorated Scope];
	local s_let_IMP::[Decorated Scope];
	local s_let_MOD::[Decorated Scope];
	local s_let_LEX::[Decorated Scope];
	_s_let_.VAR = top.s_let_VAR;
	_s_let_.IMP = top.s_let_IMP;
	_s_let_.MOD = top.s_let_MOD;
	_s_let_.LEX = top.s_let_LEX;
	top.s_let = _s_let_;
	local _s_let_::Scope = pf_mkScope();
	
	
	bs.s = top.s;
	bs.s_def = top.s_let;
	
	
	
	
	
	
	
	
	
	e.s = top.s_let;
	top.ty = e.ty;
	
	
	
	
	top.ok = bs.ok && e.ok;
	top.s_VAR = (bs.s_VAR);
	top.s_IMP = (bs.s_IMP);
	top.s_MOD = (bs.s_MOD);
	top.s_LEX = (bs.s_LEX);
	top.s_let_VAR = (bs.s_def_VAR) ++ (e.s_VAR);
	top.s_let_IMP = (bs.s_def_IMP) ++ (e.s_IMP);
	top.s_let_MOD = (bs.s_def_MOD) ++ (e.s_MOD);
	top.s_let_LEX = (top.s::[]) ++ (bs.s_def_LEX) ++ (e.s_LEX);
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
	top.s_def_LEX = (top.s::[]);
}
abstract production pf_SeqBindsOne
top::Nt_seq_binds ::= b::Nt_seq_bind {
	
	
	b.s = top.s;
	b.s_def = top.s_def;
	
	
	
	
	
	
	
	
	top.ok = b.ok;
	top.s_VAR = (b.s_VAR);
	top.s_IMP = (b.s_IMP);
	top.s_MOD = (b.s_MOD);
	top.s_LEX = (b.s_LEX);
	top.s_def_VAR = (b.s_def_VAR);
	top.s_def_IMP = (b.s_def_IMP);
	top.s_def_MOD = (b.s_def_MOD);
	top.s_def_LEX = (top.s::[]) ++ (b.s_def_LEX);
}
abstract production pf_SeqBindsCons
top::Nt_seq_binds ::= b::Nt_seq_bind bs::Nt_seq_binds {
	local s_def_::Decorated Scope;
	local s_def__VAR::[Decorated Scope];
	local s_def__IMP::[Decorated Scope];
	local s_def__MOD::[Decorated Scope];
	local s_def__LEX::[Decorated Scope];
	_s_def__.VAR = top.s_def__VAR;
	_s_def__.IMP = top.s_def__IMP;
	_s_def__.MOD = top.s_def__MOD;
	_s_def__.LEX = top.s_def__LEX;
	top.s_def_ = _s_def__;
	local _s_def__::Scope = pf_mkScope();
	
	
	b.s = top.s;
	b.s_def = top.s_def_;
	
	
	
	
	
	
	
	
	
	bs.s = top.s_def_;
	bs.s_def = top.s_def;
	
	
	
	
	
	
	
	
	top.ok = b.ok && bs.ok;
	top.s_VAR = (b.s_VAR);
	top.s_IMP = (b.s_IMP);
	top.s_MOD = (b.s_MOD);
	top.s_LEX = (b.s_LEX);
	top.s_def_VAR = (bs.s_def_VAR);
	top.s_def_IMP = (bs.s_def_IMP);
	top.s_def_MOD = (bs.s_def_MOD);
	top.s_def_LEX = (bs.s_def_LEX);
	top.s_def__VAR = (b.s_def_VAR) ++ (bs.s_VAR);
	top.s_def__IMP = (b.s_def_IMP) ++ (bs.s_IMP);
	top.s_def__MOD = (b.s_def_MOD) ++ (bs.s_MOD);
	top.s_def__LEX = (top.s::[]) ++ (b.s_def_LEX) ++ (bs.s_LEX);
}
abstract production pf_DefBindSeq
top::Nt_seq_bind ::= x::String e::Nt_expr {
	local s_var::Decorated Scope;
	local ty::Nt_type;
	local s_var_VAR::[Decorated Scope];
	local s_var_IMP::[Decorated Scope];
	local s_var_MOD::[Decorated Scope];
	local s_var_LEX::[Decorated Scope];
	_s_var_.VAR = top.s_var_VAR;
	_s_var_.IMP = top.s_var_IMP;
	_s_var_.MOD = top.s_var_MOD;
	_s_var_.LEX = top.s_var_LEX;
	local s_var_datum::Datum = pf_DatumVar(top.x);
	s_var_datum.data = pf_ActualDataDatumVar(top.ty);
	top.s_var = _s_var_;
	local _s_var_::Scope = pf_mkScope();
	_s_var_.datum = s_var_datum;
	
	
	e.s = top.s;
	top.ty = e.ty;
	
	
	
	
	top.ok = e.ok;
	top.s_VAR = (top.s_var::[]) ++ (e.s_VAR);
	top.s_IMP = (e.s_IMP);
	top.s_MOD = (e.s_MOD);
	top.s_LEX = (e.s_LEX);
	top.s_def_VAR = [];
	top.s_def_IMP = [];
	top.s_def_MOD = [];
	top.s_def_LEX = [];
	top.s_var_VAR = [];
	top.s_var_IMP = [];
	top.s_var_MOD = [];
	top.s_var_LEX = [];
}
abstract production pf_DefBindTypedSeq
top::Nt_seq_bind ::= x::String tyann::Nt_type e::Nt_expr {
	local s_var::Decorated Scope;
	local ty::Nt_type;
	local s_var_VAR::[Decorated Scope];
	local s_var_IMP::[Decorated Scope];
	local s_var_MOD::[Decorated Scope];
	local s_var_LEX::[Decorated Scope];
	_s_var_.VAR = top.s_var_VAR;
	_s_var_.IMP = top.s_var_IMP;
	_s_var_.MOD = top.s_var_MOD;
	_s_var_.LEX = top.s_var_LEX;
	local s_var_datum::Datum = pf_DatumVar(top.x);
	s_var_datum.data = pf_ActualDataDatumVar(top.ty);
	top.s_var = _s_var_;
	local _s_var_::Scope = pf_mkScope();
	_s_var_.datum = s_var_datum;
	
	
	tyann.s = top.s;
	top.ty = tyann.ty;
	
	
	
	
	
	e.s = top.s;
	top.ty = e.ty;
	
	
	
	
	top.ok = tyann.ok && e.ok;
	top.s_VAR = (top.s_var::[]) ++ (tyann.s_VAR) ++ (e.s_VAR);
	top.s_IMP = (tyann.s_IMP) ++ (e.s_IMP);
	top.s_MOD = (tyann.s_MOD) ++ (e.s_MOD);
	top.s_LEX = (tyann.s_LEX) ++ (e.s_LEX);
	top.s_def_VAR = [];
	top.s_def_IMP = [];
	top.s_def_MOD = [];
	top.s_def_LEX = [];
	top.s_var_VAR = [];
	top.s_var_IMP = [];
	top.s_var_MOD = [];
	top.s_var_LEX = [];
}
abstract production pf_ParBindsNil
top::Nt_par_binds ::=  {
	
	top.ok = true;
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
top::Nt_par_binds ::= b::Nt_par_bind ds::Nt_par_binds {
	
	b.s = top.s;
	b.s_def = top.s_def;
	
	
	
	
	
	
	
	
	
	bs.s = top.s;
	bs.s_def = top.s_def;
	
	
	
	
	
	
	
	
	top.ok = b.ok && bs.ok;
	top.s_VAR = (b.s_VAR) ++ (bs.s_VAR);
	top.s_IMP = (b.s_IMP) ++ (bs.s_IMP);
	top.s_MOD = (b.s_MOD) ++ (bs.s_MOD);
	top.s_LEX = (b.s_LEX) ++ (bs.s_LEX);
	top.s_def_VAR = (b.s_def_VAR) ++ (bs.s_def_VAR);
	top.s_def_IMP = (b.s_def_IMP) ++ (bs.s_def_IMP);
	top.s_def_MOD = (b.s_def_MOD) ++ (bs.s_def_MOD);
	top.s_def_LEX = (b.s_def_LEX) ++ (bs.s_def_LEX);
}
abstract production pf_DefBindPar
top::Nt_par_bind ::= x::String e::Nt_expr {
	local s_var::Decorated Scope;
	local ty::Nt_type;
	local s_var_VAR::[Decorated Scope];
	local s_var_IMP::[Decorated Scope];
	local s_var_MOD::[Decorated Scope];
	local s_var_LEX::[Decorated Scope];
	_s_var_.VAR = top.s_var_VAR;
	_s_var_.IMP = top.s_var_IMP;
	_s_var_.MOD = top.s_var_MOD;
	_s_var_.LEX = top.s_var_LEX;
	local s_var_datum::Datum = pf_DatumVar(top.x);
	s_var_datum.data = pf_ActualDataDatumVar(top.ty);
	top.s_var = _s_var_;
	local _s_var_::Scope = pf_mkScope();
	_s_var_.datum = s_var_datum;
	
	
	e.s = top.s;
	top.ty = e.ty;
	
	
	
	
	top.ok = e.ok;
	top.s_VAR = (e.s_VAR);
	top.s_IMP = (e.s_IMP);
	top.s_MOD = (e.s_MOD);
	top.s_LEX = (e.s_LEX);
	top.s_def_VAR = (top.s_var::[]);
	top.s_def_IMP = [];
	top.s_def_MOD = [];
	top.s_def_LEX = [];
	top.s_var_VAR = [];
	top.s_var_IMP = [];
	top.s_var_MOD = [];
	top.s_var_LEX = [];
}
abstract production pf_DefBindTypedPar
top::Nt_par_bind ::= x::String tyann::Nt_type e::Nt_expr {
	local s_var::Decorated Scope;
	local ty::Nt_type;
	local s_var_VAR::[Decorated Scope];
	local s_var_IMP::[Decorated Scope];
	local s_var_MOD::[Decorated Scope];
	local s_var_LEX::[Decorated Scope];
	_s_var_.VAR = top.s_var_VAR;
	_s_var_.IMP = top.s_var_IMP;
	_s_var_.MOD = top.s_var_MOD;
	_s_var_.LEX = top.s_var_LEX;
	local s_var_datum::Datum = pf_DatumVar(top.x);
	s_var_datum.data = pf_ActualDataDatumVar(top.ty);
	top.s_var = _s_var_;
	local _s_var_::Scope = pf_mkScope();
	_s_var_.datum = s_var_datum;
	
	
	tyann.s = top.s;
	top.ty = tyann.ty;
	
	
	
	
	
	e.s = top.s;
	top.ty = e.ty;
	
	
	
	
	top.ok = tyann.ok && e.ok;
	top.s_VAR = (tyann.s_VAR) ++ (e.s_VAR);
	top.s_IMP = (tyann.s_IMP) ++ (e.s_IMP);
	top.s_MOD = (tyann.s_MOD) ++ (e.s_MOD);
	top.s_LEX = (tyann.s_LEX) ++ (e.s_LEX);
	top.s_def_VAR = (top.s_var::[]);
	top.s_def_IMP = [];
	top.s_def_MOD = [];
	top.s_def_LEX = [];
	top.s_var_VAR = [];
	top.s_var_IMP = [];
	top.s_var_MOD = [];
	top.s_var_LEX = [];
}
abstract production pf_DatumVar
top::Datum ::= datum_id::String {
	
}
abstract production pf_ActualDataDatumVar
top::Nt_actualData ::= arg_8::Nt_type {
	
}
abstract production pf_ArgDecl
top::Nt_arg_decl ::= x::String tyann::Nt_type {
	local s_var::Decorated Scope;
	
	tyann.s = top.s;
	top.ty = tyann.ty;
	
	
	
	
	local s_var_VAR::[Decorated Scope];
	local s_var_IMP::[Decorated Scope];
	local s_var_MOD::[Decorated Scope];
	local s_var_LEX::[Decorated Scope];
	_s_var_.VAR = top.s_var_VAR;
	_s_var_.IMP = top.s_var_IMP;
	_s_var_.MOD = top.s_var_MOD;
	_s_var_.LEX = top.s_var_LEX;
	local s_var_datum::Datum = pf_DatumVar(top.x);
	s_var_datum.data = pf_ActualDataDatumVar(top.ty);
	top.s_var = _s_var_;
	local _s_var_::Scope = pf_mkScope();
	_s_var_.datum = s_var_datum;
	
	top.ok = tyann.ok;
	top.s_VAR = (tyann.s_VAR) ++ (top.s_var::[]);
	top.s_IMP = (tyann.s_IMP);
	top.s_MOD = (tyann.s_MOD);
	top.s_LEX = (tyann.s_LEX);
	top.s_var_VAR = [];
	top.s_var_IMP = [];
	top.s_var_MOD = [];
	top.s_var_LEX = [];
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
	local ty1::Nt_type;
	local ty2::Nt_type;
	
	tyann1.s = top.s;
	top.ty1 = tyann1.ty;
	
	
	
	
	
	tyann2.s = top.s;
	top.ty2 = tyann2.ty;
	
	
	
	
	top.ty = pf_TFun(top.ty1, top.ty2);
	top.ok = tyann1.ok && tyann2.ok;
	top.s_VAR = (tyann1.s_VAR) ++ (tyann2.s_VAR);
	top.s_IMP = (tyann1.s_IMP) ++ (tyann2.s_IMP);
	top.s_MOD = (tyann1.s_MOD) ++ (tyann2.s_MOD);
	top.s_LEX = (tyann1.s_LEX) ++ (tyann2.s_LEX);
}
abstract production pf_ModRef
top::Nt_mod_ref ::= x::String {
	local mods::[Path];
	local xmods::[Path];
	local xmods_::[Path];
	top.mods = pf_query(top.s, pf_regexSeq(pf_regexStar(pf_regexLabel(pf_labelLEX())), pf_regexSeq(pf_regexAlt(pf_regexLabel(pf_labelIMP()), pf_regexEps()), pf_regexLabel(pf_labelMOD()))));
	top.xmods = pf_path_filter(\d_lam_arg::Decorated Datum -> case d_lam_arg of pf_DatumMod(x_) -> x_ == top.x | _ -> false end, top.mods);
	top.xmods_ = pf_path_min(\l::Label r::Label -> case (l, r) of (pf_labelMOD(), pf_labelLEX()) -> -1 | (pf_labelLEX(), pf_labelMOD()) -> 1 | (pf_labelMOD(), pf_labelIMP()) -> -1 | (pf_labelIMP(), pf_labelMOD()) -> 1 | (pf_labelVAR(), pf_labelLEX()) -> -1 | (pf_labelLEX(), pf_labelVAR()) -> 1 | (pf_labelVAR(), pf_labelIMP()) -> -1 | (pf_labelIMP(), pf_labelVAR()) -> 1 | (pf_labelIMP(), pf_labelLEX()) -> -1 | (pf_labelLEX(), pf_labelIMP()) -> 1 | (_, _) -> 0 end, top.xmods);
	top.p = pf_one(top.xmods_);
	top.ok = true;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
}
abstract production pf_VarRef
top::Nt_var_ref ::= x::String {
	local vars::[Path];
	local xvars::[Path];
	local xvars_::[Path];
	top.vars = pf_query(top.s, pf_regexSeq(pf_regexStar(pf_regexLabel(pf_labelLEX())), pf_regexSeq(pf_regexAlt(pf_regexLabel(pf_labelIMP()), pf_regexEps()), pf_regexLabel(pf_labelVAR()))));
	top.xvars = pf_path_filter(\d_lam_arg::Decorated Datum -> case d_lam_arg of pf_DatumVar(x_) -> x_ == top.x | _ -> false end, top.vars);
	top.xvars_ = pf_path_min(\l::Label r::Label -> case (l, r) of (pf_labelMOD(), pf_labelLEX()) -> -1 | (pf_labelLEX(), pf_labelMOD()) -> 1 | (pf_labelMOD(), pf_labelIMP()) -> -1 | (pf_labelIMP(), pf_labelMOD()) -> 1 | (pf_labelVAR(), pf_labelLEX()) -> -1 | (pf_labelLEX(), pf_labelVAR()) -> 1 | (pf_labelVAR(), pf_labelIMP()) -> -1 | (pf_labelIMP(), pf_labelVAR()) -> 1 | (pf_labelIMP(), pf_labelLEX()) -> -1 | (pf_labelLEX(), pf_labelIMP()) -> 1 | (_, _) -> 0 end, top.xvars);
	top.p = pf_one(top.xvars_);
	top.ok = true;
	top.s_VAR = [];
	top.s_IMP = [];
	top.s_MOD = [];
	top.s_LEX = [];
}


function pf_tgt
(Boolean, Decorated Scope) ::= p::Path {
	local ok::Boolean;
	local s::Decorated Scope;
	local pair_9::(Boolean, Decorated Scope);
	top.pair_9 = case top.p of pf_End(x) -> if true then (true, x) else error("branch case else TODO") | pf_Edge(x, l, xs) -> if true then pf_tgt(xs) else error("branch case else TODO") | _ -> error("Match failure!") end;
	
	top.s = top.pair_9.2;
	return (top.ok, top.s);
	top.ok = top.pair_9.1;}

