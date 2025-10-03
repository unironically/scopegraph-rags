grammar sg_lib1:src;

--------------------------------------------------

synthesized attribute resolve::([Decorated Scope] ::= Pred Decorated Scope);
synthesized attribute start::Decorated DFAState;

nonterminal DFA with resolve, start;

abstract production varRefDFA
top::DFA ::=
{
  local state0::DFAState = stateVar();
  local state1::DFAState = stateVar();
  local final::DFAState  = stateFinal();
  local sink::DFAState   = stateSink();

  state0.varT = final;
  state0.modT = sink;
  state0.impT = state1;
  state0.lexT = state0;

  state1.varT = final;
  state1.modT = sink;
  state1.impT = sink;
  state1.lexT = sink;

  final.varT = sink;
  final.modT = sink;
  final.impT = sink;
  final.lexT = sink;

  sink.varT = sink;
  sink.modT = sink;
  sink.impT = sink;
  sink.lexT = sink;

  top.resolve = state0.resolve;
  top.start = state0;
}

abstract production modRefDFA
top::DFA ::= 
{
  local state0::DFAState = stateMod();
  local state1::DFAState = stateMod();
  local final::DFAState  = stateFinal();
  local sink::DFAState   = stateSink();

  state0.varT = sink;
  state0.modT = final;
  state0.impT = state1;
  state0.lexT = state0;

  state1.varT = sink;
  state1.modT = final;
  state1.impT = sink;
  state1.lexT = sink;

  final.varT = sink;
  final.modT = sink;
  final.impT = sink;
  final.lexT = sink;

  sink.varT = sink;
  sink.modT = sink;
  sink.impT = sink;
  sink.lexT = sink;

  top.resolve = state0.resolve;
  top.start = state0;
}

--------------------------------------------------

inherited attribute varT::Decorated DFAState;
inherited attribute modT::Decorated DFAState;
inherited attribute impT::Decorated DFAState;
inherited attribute lexT::Decorated DFAState;

nonterminal DFAState with varT, modT, impT, lexT, resolve;

abstract production stateVar
top::DFAState ::=
{
  top.resolve = \pred::Pred cur::Decorated Scope ->

    let varRes::[Decorated Scope] = 
      concat(map(top.varT.resolve(pred, _), cur.var))
    in

    let impRes::[Decorated Scope] = 
      concat(map(top.impT.resolve(pred, _), cur.imp))
    in

    let lexRes::[Decorated Scope] = 
      concat(map(top.lexT.resolve(pred, _), cur.lex))
    in
    
    if !null(varRes) then varRes
    else if !null(impRes) then impRes
    else lexRes

    end end end;
}

abstract production stateMod
top::DFAState ::= 
{
  top.resolve = \pred::Pred cur::Decorated Scope ->

    let modRes::[Decorated Scope] = 
      concat(map(top.modT.resolve(pred, _), cur.mod))
    in

    let impRes::[Decorated Scope] = 
      concat(map(top.impT.resolve(pred, _), cur.imp))
    in

    let lexRes::[Decorated Scope] = 
      concat(map(top.lexT.resolve(pred, _), cur.lex))
    in
    
    if !null(modRes) then modRes
    else if !null(impRes) then impRes
    else lexRes

    end end end;                                                                
}

abstract production stateFinal
top::DFAState ::=
{
  top.resolve = \pred::Pred cur::Decorated Scope -> 
              if pred(cur.datum) then [cur] else [];
}

abstract production stateSink
top::DFAState ::=
{ top.resolve = \_ _ -> []; }

-----------------------------------------------------

type Pred = (Boolean ::= Datum);

function query
[Decorated Scope] ::= 
  start::Decorated Scope 
  dfa::DFA
  pred::Pred
{ return dfa.resolve(pred, start); }