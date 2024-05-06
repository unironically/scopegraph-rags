grammar regex_noimports:resolution;


-- Resolution type:
-- [Decorated Scope] ::= Decorated Scope Either<VarRef ModRef>


{- Given a state, give me back the transitions for it in label order -}
function getOrderedTransForState
[DFATrans] ::= moves::[DFATrans] state::Integer
{
  return
    let validTrans::[DFATrans] = filter ((\t::DFATrans -> fst(t) == state), moves)
    in sortBy ((\t1::DFATrans t2::DFATrans -> fst(snd(t1)) > fst(snd(t2))), validTrans) end;
}

function resolutionFun
([Decorated Scope] ::= Decorated Scope String [Decorated Scope]) ::= dfa::DFA
{
  return dfaStateToFun (dfa, fst(snd(snd(dfa))));
}

function dfaStateToFun
([Decorated Scope] ::= Decorated Scope String [Decorated Scope]) ::= dfa::DFA state::Integer
{

  local orderedTrans::[DFATrans] = getOrderedTransForState (fst(snd(dfa)), state);
  local finalStates::[(Label, Integer)] = map ((\t::DFATrans -> (fst(snd(t)), snd(snd(t)))), orderedTrans);

  -- All resolution functions from states reached by transitions
  local resolvedAll::[(Label, ([Decorated Scope] ::= Decorated Scope String [Decorated Scope]))] = map ((\t::(Label, Integer) -> (fst(t), dfaStateToFun (dfa, snd(t)))), finalStates);


  return \s::Decorated Scope name::String seen::[Decorated Scope] ->

       let subRes::[Decorated Scope] = concat (
         map (
           (
            \f::(Label, ([Decorated Scope] ::= Decorated Scope String [Decorated Scope])) ->
              concat (
                map (
                  
                  (\new_s::Decorated Scope -> snd(f)(new_s, name, s::seen)),
                  
                  case fst(f) of
                    labelLex() -> case s.lexEdge of | just(s) -> [s] | nothing () -> [] end
                  | labelVar() -> s.varEdges
                  | labelMod() -> s.modEdges
                  | labelImp() -> case s.impEdge of | just(s) -> [s] | nothing () -> [] end
                  end

                )
              )
           ),
          resolvedAll -- in correct order, e.g. [VAR, IMP, LEX] / [MOD, IMP, LEX]
        )
      )

      in if contains (state, snd(snd(snd(dfa)))) && (case s.datum of | just(d) -> d.nameEq (name) | nothing () -> false end)
           then s :: subRes
           else subRes
      end;


}

function findFun
([Decorated Scope] ::= Decorated Scope String [Decorated Scope]) ::= l::Label resolvedAll::[(Label, ([Decorated Scope] ::= Decorated Scope String [Decorated Scope]))]
{
  return
    case resolvedAll of
      (lab, fun)::t -> if lab == l then fun else findFun (l, t)
    | [] -> (\s::Decorated Scope str::String seen::[Decorated Scope] -> [])
    end;
}