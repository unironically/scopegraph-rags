grammar lmr_scopefunctions:resolution;


synthesized attribute resolve :: ([Decorated Scope] ::= Path DFA Integer (Boolean ::= String));
attribute resolve occurs on Scope;


synthesized attribute name::String occurs on Scope;


aspect production mkScope
top::Scope ::=
  id::Integer
  name::String
  lex::[Decorated Scope]
  var::[Decorated Scope]
  mod::[Decorated Scope]
  imp::[Decorated Scope]
{

  top.name = name;

  top.resolve = \ 
    p::Path 
    dfa::DFA 
    state::Integer 
    dwf::(Boolean ::= String) -> 

      let validTrans::[DFATrans] = getOrderedTransForState (fst(snd(dfa)), state) in

      let residual::[Decorated Scope] = 
        concat (
          map (
            (
              \trans::DFATrans -> 
                case trans of 
                  (_, lab, tgt) -> 
                    case lab of
                      labelLex () -> concat (map ((\ds::Decorated Scope -> ds.resolve (pathCons (top, labelLex(), p), dfa, tgt, dwf)), top.lexEdges))
                    | labelVar () -> concat (map ((\ds::Decorated Scope -> ds.resolve (pathCons (top, labelVar(), p), dfa, tgt, dwf)), top.varEdges))
                    | labelMod () -> concat (map ((\ds::Decorated Scope -> ds.resolve (pathCons (top, labelMod(), p), dfa, tgt, dwf)), top.modEdges))
                    | labelImp () -> concat (map ((\ds::Decorated Scope -> ds.resolve (pathCons (top, labelImp(), p), dfa, tgt, dwf)), top.impEdges))
                    end
                end
            ),
            validTrans
          ) 
        ) in

      if p.seen (id) && case p of pathOne(_) -> false | _ -> true end
        then []
        else 
          if dfaAccepts (dfa, state) && dwf (top.name)
            then top :: residual
            else residual

      end end;

}


aspect production mkScopeBind
top::Scope ::=
  id::Integer
  lex::[Decorated Scope]
  var::[Decorated Scope]
  mod::[Decorated Scope]
  imp::[Decorated Scope]
  decl::Bind
{
  top.name = decl.defname;
}


aspect production mkScopeMod
top::Scope ::=
  id::Integer
  lex::[Decorated Scope]
  var::[Decorated Scope]
  mod::[Decorated Scope]
  imp::[Decorated Scope]
  decl::Decl
{
  top.name = decl.defname;
}

function goodScope
Boolean ::= s::Decorated Scope p::Path
{
  return
    case s of
      mkScope (id, _, _, _, _, _) -> p.seen(id)
    | mkScopeBind (id, _, _, _, _, _) -> p.seen(id)
    | mkScopeMod (id, _, _, _, _, _) -> p.seen(id)
    | mkScopeGlobal (id, _, _, _) -> p.seen(id)
    end;
}

nonterminal Path;

synthesized attribute seen::(Boolean ::= Integer) occurs on Path;

abstract production pathCons
top::Path ::= 
  s::Decorated Scope 
  l::Label 
  p::Path
{
  top.seen = \lookup::Integer -> s.id == lookup || p.seen (lookup);
}


abstract production pathOne
top::Path ::= 
  s::Decorated Scope
{
  top.seen = \lookup::Integer -> s.id == lookup;
}
























-- type DFATrans = (Integer, Label, Integer); 

function getOrderedTransForState
[DFATrans] ::= moves::[DFATrans] state::Integer
{
  return
    let validTrans::[DFATrans] = filter ((\t::DFATrans -> fst(t) == state), moves) 
    in sortBy ((\t1::DFATrans t2::DFATrans -> fst(snd(t1)) > fst(snd(t2))), validTrans) end;
}

{-function resolutionFun
([Decorated Scope] ::= Decorated Scope String [Decorated Scope]) ::= dfa::DFA
{
  return dfaStateToFun (dfa, fst(snd(snd(dfa))));
}
-}