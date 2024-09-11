grammar sg_lib;


--------------------------------------------------

synthesized attribute decls::([Decorated SGDecl] ::= SGRef Decorated SGScope);

nonterminal DFA with decls;

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

  top.decls = state0.decls;
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

  top.decls = state0.decls;
}

--------------------------------------------------

inherited attribute varT::Decorated DFAState;
inherited attribute modT::Decorated DFAState;
inherited attribute impT::Decorated DFAState;
inherited attribute lexT::Decorated DFAState;

nonterminal DFAState with varT, modT, impT, lexT, decls;

abstract production stateVar
top::DFAState ::=
{
  top.decls = \r::SGRef cur::Decorated SGScope ->
    let varRes::[Decorated SGDecl] = 
      concat(map(top.varT.decls(r, _), cur.var)) in
    let impRes::[Decorated SGDecl] = 
      concat(map(top.impT.decls(r, _), cur.imp)) in
    let lexRes::[Decorated SGDecl] = 
      concat(map(top.lexT.decls(r, _), cur.lex)) in
    
    if !null(varRes) then varRes
    else if !null(impRes) then impRes
    else lexRes

    end end end;
}

abstract production stateMod
top::DFAState ::=
{
  top.decls = \r::SGRef cur::Decorated SGScope ->
    let modRes::[Decorated SGDecl] = 
      concat(map(top.modT.decls(r, _), cur.mod)) in
    let impRes::[Decorated SGDecl] = 
      concat(map(top.impT.decls(r, _), cur.imp)) in
    let lexRes::[Decorated SGDecl] = 
      concat(map(top.lexT.decls(r, _), cur.lex)) in
    
    if !null(modRes) then modRes
    else if !null(impRes) then impRes
    else lexRes

    end end end;
}

abstract production stateFinal
top::DFAState ::=
{
  top.decls = \r::SGRef cur::Decorated SGScope ->
    case cur.datum of
    | just(d) when d.test(r) -> [cur]
    | _ -> []
    end;
}

abstract production stateSink
top::DFAState ::=
{ top.decls = \_ _ -> []; }