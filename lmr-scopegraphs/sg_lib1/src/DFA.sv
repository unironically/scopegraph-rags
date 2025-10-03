grammar sg_lib:src;

--------------------------------------------------

-- Path

nonterminal Path;

abstract production pEnd
top::Path ::= s::Decorated SGScope
{}

abstract production pEdge
top::Path ::= s::Decorated SGScope lab::String rest::Path
{}

--------------------------------------------------

synthesized attribute paths::([Path] ::= Pred Decorated SGScope);
synthesized attribute start::Decorated DFAState;

nonterminal DFA with paths, start;

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

  top.paths = state0.paths;
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

  top.paths = state0.paths;
  top.start = state0;
}

--------------------------------------------------

inherited attribute varT::Decorated DFAState;
inherited attribute modT::Decorated DFAState;
inherited attribute impT::Decorated DFAState;
inherited attribute lexT::Decorated DFAState;

nonterminal DFAState with varT, modT, impT, lexT, paths;

abstract production stateVar
top::DFAState ::=
{
  top.paths = \pred::Pred cur::Decorated SGScope ->

    let varRes::[Path] = 
      let varPaths::[Path] = concat(map(top.varT.paths(pred, _), cur.var)) in
        map ((\p::Path -> pEdge(cur, "VAR", p)), varPaths)
      end
    in

    let impRes::[Path] = 
      let impPaths::[Path] = concat(map(top.impT.paths(pred, _), cur.imp)) in
        map ((\p::Path -> pEdge(cur, "IMP", p)), impPaths)
      end 
    in

    let lexRes::[Path] = 
      let lexPaths::[Path] = concat(map(top.lexT.paths(pred, _), cur.lex)) in
        map ((\p::Path -> pEdge(cur, "LEX", p)), lexPaths)
      end
    in
    
    if !null(varRes) then varRes
    else if !null(impRes) then impRes
    else lexRes

    end end end;

}

abstract production stateMod
top::DFAState ::= 
{
  top.paths = \pred::Pred cur::Decorated SGScope ->

    let modRes::[Path] = 
      let modPaths::[Path] = concat(map(top.modT.paths(pred, _), cur.mod)) in
        map ((\p::Path -> pEdge(cur, "MOD", p)), modPaths)
      end
    in

    let impRes::[Path] = 
      let impPaths::[Path] = concat(map(top.impT.paths(pred, _), cur.imp)) in
        map ((\p::Path -> pEdge(cur, "IMP", p)), impPaths)
      end 
    in

    let lexRes::[Path] = 
      let lexPaths::[Path] = concat(map(top.lexT.paths(pred, _), cur.lex)) in
        map ((\p::Path -> pEdge(cur, "LEX", p)), lexPaths)
      end
    in
    
    if !null(modRes) then modRes
    else if !null(impRes) then impRes
    else lexRes

    end end end;                                                                
}

abstract production stateFinal
top::DFAState ::=
{
  top.paths = \pred::Pred cur::Decorated SGScope -> 
              if pred(cur.datum) then [pEnd(cur)] else [];
}

abstract production stateSink
top::DFAState ::=
{ top.paths = \_ _ -> []; }


-----------------------------------------------------
-- Ministatix builtin functions

type Pred = (Boolean ::= SGDatum);

function query
[Path] ::= 
  start::Decorated SGScope 
  dfa::DFA
  pred::Pred
{ return dfa.paths(pred, start); }

function pathFilter
[Path] ::= f::(Boolean ::= SGDatum) ps::[Path]
{
  return filter (pathFilterOne(f, _), ps);
}

function pathFilterOne
Boolean ::= f::(Boolean ::= SGDatum) p::Path
{
  return
    case p of
      pEnd(s)         -> f(s.datum)
    | pEdge(s, l, ps) -> pathFilterOne(f, ^ps) -- QUESTION: why need ^ here?
    | _               -> false
    end;
}