grammar regex_noimports:resolution;


-- Resolution type:
-- [Decorated Scope] ::= Decorated Scope VarRef


{- Given a state, give me back the transitions for it in label order -}
function getOrderedTransForState
[DFATrans] ::= moves::[DFATrans] state::Integer
{
  return
    let validTrans::[DFATrans] = filter ((\t::DFATrans -> fst(t) == state), moves) 
    in sortBy ((\t1::DFATrans t2::DFATrans -> fst(snd(t1)) > fst(snd(t2))), validTrans) end;
}

function resolutionFun
([Decorated Scope] ::= Decorated Scope VarRef) ::= dfa::DFA
{
  return dfaStateToFun (dfa, fst(snd(snd(dfa))));
}

function dfaStateToFun
([Decorated Scope] ::= Decorated Scope VarRef) ::= dfa::DFA state::Integer
{

  local orderedTrans::[DFATrans] = getOrderedTransForState (fst(snd(dfa)), state);
  local finalStates::[(Label, Integer)] = map ((\t::DFATrans -> (fst(snd(t)), snd(snd(t)))), orderedTrans);

  -- All resolution functions from states reached by transitions
  local resolvedAll::[(Label, ([Decorated Scope] ::= Decorated Scope VarRef))] = map ((\t::(Label, Integer) -> (fst(t), dfaStateToFun (dfa, snd(t)))), finalStates);
  
  return 
    \s::Decorated Scope v::VarRef ->
      let subRes::[Decorated Scope] = concat (
        map (
          (
            \f::(Label, ([Decorated Scope] ::= Decorated Scope VarRef)) ->
              case fst(f) of
                labelLex() -> concat (map ((\s::Decorated Scope -> snd(f)(s, v)), s.lexEdges))
              | labelVar() -> concat (map ((\s::Decorated Scope -> snd(f)(s, v)), s.varEdges))
              end
          ),
          resolvedAll
        )
      )

      in if contains (state, snd(snd(snd(dfa)))) && v.refname == s.name
           then [s]
           else subRes

      end;

}