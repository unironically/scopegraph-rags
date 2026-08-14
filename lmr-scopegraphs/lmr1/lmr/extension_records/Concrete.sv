grammar lmr1:lmr:extension_records;

exports lmr1:lmr:concretesyntax;

--------------------------------------------------

terminal Rec_t 'record' dominates { Id_t };
terminal Extends_t 'extends' dominates { Id_t };
terminal With_t 'with' dominates { Id_t };

--------------------------------------------------

concrete production declRecord_c
top::Decl_c ::= r::Record_c
{ top.ast = declRecord(r.ast, location=top.location); }

--------------------------------------------------

nonterminal Record_c with ast<Record>, location;

concrete production record_c
top::Record_c ::= 'record' r::Id_t '{' flds::Fields_c '}'
{ top.ast = record(r.lexeme, flds.ast, location=top.location); }

concrete production recordExt_c
top::Record_c ::= 'record' r::Id_t 'extends' p::Id_t 'with' '{' flds::Fields_c '}'
{ top.ast = recordExt(r.lexeme, p.lexeme, flds.ast, location=top.location); }

--------------------------------------------------

nonterminal Fields_c with ast<Fields>, location;

concrete production fieldsCons_c
top::Fields_c ::= name::Id_t ':' tyann::Type_c ',' rest::Fields_c
{ top.ast = fieldsCons(name.lexeme, tyann.ast, rest.ast, location=top.location); }

concrete production fieldsOne_c
top::Fields_c ::= name::Id_t ':' tyann::Type_c
{ top.ast = fieldsOne(name.lexeme, tyann.ast, location=top.location); }

--------------------------------------------------

concrete production exprRecord_c
top::Expr_c ::= name::Id_t '{' flds::FieldExprs_c '}'
{ top.ast = exprRecord(name.lexeme, flds.ast, location=top.location); }

concrete production exprRecordAccess_c
top::Expr_c ::= r::RecAccess_c
{ top.ast = exprRecordAccess(r.ast, location=top.location); }

--------------------------------------------------

nonterminal FieldExprs_c with ast<FieldExprs>, location;

concrete production fieldExprsCons_c
top::FieldExprs_c ::= name::Id_t '=' e::Expr_c ',' rest::FieldExprs_c
{ top.ast = fieldExprsCons(name.lexeme, e.ast, rest.ast, location=top.location); }

concrete production fieldExprsOne_c
top::FieldExprs_c ::= name::Id_t '=' e::Expr_c
{ top.ast = fieldExprsOne(name.lexeme, e.ast, location=top.location); }

--------------------------------------------------

nonterminal RecAccessLHS_c with ast<RecAccessLHS>, location;

concrete production recAccessLHSQual_c
top::RecAccessLHS_c ::= r::RecAccessLHS_c '.' x::Id_t
{ top.ast = recAccessLHSQual(r.ast, x.lexeme, location=top.location); }

concrete production recAccessLHS_c
top::RecAccessLHS_c ::= x::Id_t
{ top.ast = recAccessLHS(x.lexeme, location=top.location); }

--

nonterminal RecAccess_c with ast<RecAccess>, location;

concrete production recAccess_c
top::RecAccess_c ::= lhs::RecAccessLHS_c '.' x::Id_t
{ top.ast = recAccess(lhs.ast, x.lexeme, location=top.location); }

--------------------------------------------------

concrete production tRecord_c
top::Type_c ::= id::Id_t
{ top.ast = tRecord(id.lexeme); }
