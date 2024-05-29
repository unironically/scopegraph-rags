grammar LM;

synthesized attribute findVisible::([Scope] ::= String Scope);



nonterminal DFA with findVisible;

{-
 - DFA.
 - We only need to hold the start state, as each state knows whether it is final, and there should
 - be a path from the start state to any other state in the DFA.
 -}
abstract production dfa
top::DFA ::=
  start::State
{
  top.findVisible = start.findVisible;
}



nonterminal State with findVisible;;

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
  top.findVisible = 
    \lookup::String currentScope::Scope ->
      let varRes::[Scope] = concat(map((var.findVisible(lookup, _)), currentScope.vars)) in
      let modRes::[Scope] = concat(map((mods.findVisible(lookup, _)), currentScope.mods)) in
      let impRes::[Scope] = concat(map((imps.findVisible(lookup, _)), currentScope.imps)) in
      let lexRes::[Scope] = concat(map((lexs.findVisible(lookup, _)), currentScope.lexs)) in
      let contRes::[Scope] = 
        if !null(varRes) then varRes
        else if !null(modRes) then modRes
        else if !null(impRes) then impRes
        else lexRes 
      in
        case currentScope of
        | scopeDatum(d) -> if d.id == lookup then currentScope::contRes else contRes
        | _ -> contRes
        end
      end end end end end;
}

{-
 - Sink state in a DFA. 
 - Cannot use the current scope in a resolution, and cannot transition.
 -}
abstract production sinkState
top::State ::=
{
  top.findVisible = \lookup::String currentScope::Scope -> [];
}