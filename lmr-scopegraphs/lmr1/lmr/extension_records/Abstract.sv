grammar lmr1:lmr:extension_records;

exports lmr1:lmr:nameanalysis_kastenswaite;

--------------------------------------------------

production declRecord
top::Decl ::= x::String fields::Fields
{}

production declRecordExt
top::Decl ::= x::String other::String fields::Fields
{}

--------------------------------------------------

nonterminal Fields with location;

production fieldsCons
top::Fields ::= x::String ty::Type rest::Fields
{}

production fieldsOne
top::Fields ::= x::String ty::Type
{}

--------------------------------------------------

production exprRecord
top::Expr ::= name::String flds::FieldExprs
{}

production exprRecordAccess
top::Expr ::= r::RecAccess
{}

--------------------------------------------------

nonterminal FieldExprs with location;

production fieldExprsCons
top::FieldExprs ::= x::String e::Expr rest::FieldExprs
{}

production fieldExprsOne
top::FieldExprs ::= x::String e::Expr
{}

--------------------------------------------------

nonterminal RecAccess with location;

production recAccessQual
top::RecAccess ::= r::RecAccess x::String
{}

production recAccess
top::RecAccess ::= x::String
{}
