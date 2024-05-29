grammar LM;


{-
 - DFA for VarRefs.
 -}
global dfaVarRef::DFA = 
  let sink::State = sinkState() in
  let final::State = state(sink, sink, sink, sink, true) in
  let impState::State = state(final, sink, sink, sink, false) in
  let start::State = state(final, sink, impState, start) in
    dfa (start)
  end end end end;

{-
 - DFA for qualified VarRefs.
 -}
global dfaVar::DFA = 
  let final::State = state(sink, sink, sink, sink, true) in
  let start::State = state(final, sink, sink, sink) in
    dfa (start)
  end end;

{-
 - DFA for ModRefs.
 -}
global dfaModRef::DFA = 
  let sink::State = sinkState() in
  let final::State = state(sink, sink, sink, sink, true) in
  let impState::State = state(sink, final, sink, sink, false) in
  let start::State = state(sink, final, impState, start) in
    dfa (start)
  end end end end;

{-
 - DFA for qualified ModRefs.
 -}
global dfaMod::DFA = 
  let final::State = state(sink, sink, sink, sink, true) in
  let start::State = state(sink, final, sink, sink) in
    dfa (start)
  end end;


synthesized attribute findReachable::([Res] ::= String Either<ModRef, VarRef> [Label] Boolean Scope);


nonterminal DFA with findReachable;

{-
 - DFA.
 - We only need to hold the start state, as each state knows whether it is final, and there should
 - be a path from the start state to any other state in the DFA.
 -}
abstract production dfa
top::DFA ::=
  start::State
{
  top.findReachable = start.findReachable;
}


nonterminal State with findReachable;

{-
 - Regular (non-sink) state in a DFA.
 - We continue traversal, and also take into account the current scope as a possible resolution
 - if the state is final.
 -}
abstract production state
top::State ::=
  var::State
  mod::State
  imp::State
  lex::State
  isFinal::Boolean
{
  top.findReachable = 
    \lookup::String
     fromRef::Either<ModRef, VarRef>
     currentPath::[Label]
     resolvingImp::Boolean 
     currentScope::Scope ->
    
      let varRes::[Res] = if resolvingImp then [] 
                          else concat(map((var.findReachable(lookup, fromRef, labelVar()::currentPath, resolvingImp, _)), currentScope.vars)) in
      
      let modRes::[Res] = if !resolvingImp then [] 
                          else concat(map((mods.findReachable(lookup, fromRef, labelMod()::currentPath, resolvingImp, _)), currentScope.mods)) in

      let imps::[Scope] = if resolvingImp then map((.resolvedScope), currentScope.impsReachable) 
                          else scope.imps in
      let impRes::[Res] = concat(map((imps.findReachable(lookup, fromRef, labelImp()::currentPath, resolvingImp, _)), imps)) in

      let lexRes::[Res] = concat(map((lexs.findReachable(lookup, fromRef, labelLex()::currentPath, resolvingImp, _)), currentScope.lexs)) in

      let contRes::[Res] = varRef ++ modRes ++ impRes ++ lexRes in

        case currentScope of
        | scopeDatum(d) -> if d.id != lookup then contRes 
                           else if resolvingImp then impRes(left(fromRef), currentScope, currentPath) :: contRes
                           else varRes(right(fromRef), currentScope, currentPath) :: contRes 
        | _ -> contRes -- ignore scopes that do not have data
        end

      end end end end end end;
}

{-
 - Sink state in a DFA. 
 - Cannot use the current scope in a resolution, and cannot transition.
 -}
abstract production sinkState
top::State ::=
{
  top.findReachable = 
    \lookup::String 
     fromRef::Either<ModRef, VarRef> 
     currentPath::[Label] 
     resolvingImp::Boolean
     currentScope::Scope -> 
      [];
}