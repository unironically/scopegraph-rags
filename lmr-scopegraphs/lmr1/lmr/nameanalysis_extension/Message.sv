grammar lmr1:lmr:nameanalysis_extension;

import silver:langutil; -- for location.unparse

--------------------------------------------------

synthesized attribute pp::String;

nonterminal Message with pp;

production errorMessage
top::Message ::= msg::String loc::Location
{
  top.pp = loc.unparse ++ ": error: " ++ msg ++ "\n"; 
}

production warnMessage
top::Message ::= msg::String loc::Location
{
  top.pp = loc.unparse ++ ": warning: " ++ msg ++ "\n"; 
}

--------------------------------------------------

fun binopOk([Message], Type) ::= l::Type r::Type loc::Location 
                                 cond::(Boolean ::= Type) op::String expect::String =
  let msgs::[Message] =
    if r == tErr() || cond(r)
    then []
    else [errorMessage(
      op ++ " expects type of right operand to be " ++ expect ++ ", but an expression " ++
      "was given of type " ++ r.pp,
      loc
    )]
  in
  let msgs::[Message] =
    if l == tErr() || cond(l)
    then msgs
    else errorMessage(
      op ++ " expects type of left operand to be " ++ expect ++ ", but an expression " ++
      "was given of type " ++ l.pp,
      loc
    )::msgs
  in
    (msgs, if null(msgs) then castAdd(l, r) else tErr())
  end end;

fun addOk ([Message], Type) ::= l::Type r::Type loc::Location =
  let ok::([Message], Type) = 
    binopOk(
      l, r, loc, \t::Type -> t == tInt() || t == tFloat(), "addition", "int or float"
    )
  in
    if ok.2 == tErr() then ok else (ok.1, castAdd(l, r))
  end;

fun andOk ([Message], Type) ::= l::Type r::Type loc::Location =
  binopOk(
    l, r, loc, \t::Type -> t == tBool(), "conjunction", "bool"
  );

--

fun castAdd Type ::= l::Type r::Type =
  case l, r of
  | tFloat(), _ -> tFloat()
  | _, tFloat() -> tFloat()
  | _, _        -> tInt()
  end
;