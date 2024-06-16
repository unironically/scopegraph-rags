grammar LM;


{-
 - DFA for VarRefs.
 -}
global dfaVarRef::DFA = dfaVarRef();

{-
 - DFA for ModRefs.
 -}
global dfaModRef::DFA = dfaModRef();



synthesized attribute findReachableVar::([Res] ::= String VarRef);
synthesized attribute findReachableMod::([Res] ::= String ModRef);

nonterminal DFA with findReachableVar, findReachableMod;

{-
 - DFA.
 - We only need to hold the start state, as each state knows whether it is final, and there should
 - be a path from the start state to any other state in the DFA.
 -}
abstract production dfa
top::DFA ::=
  start::State
{ 
  top.findReachableVar = 
    \id::String vr::VarRef -> start.findReachable(id, right(vr), [], [], vr.lexScope); 
  top.findReachableMod = 
    \id::String mr::ModRef -> start.findReachable(id, left(mr), [], [], mr.lexScope); 
}



inherited attribute varT::State;
inherited attribute modT::State;
inherited attribute impT::State;
inherited attribute lexT::State;

synthesized attribute findReachable::([Res] ::= String Either<ModRef, VarRef> [Label] [Res] Scope);

nonterminal State with findReachable, varT, modR, impT, lexT;

abstract production varRefstate
  isFinal::Boolean
top::State ::=
{
  top.findReachable = 
    \lookup::String
     ref::Either<ModRef, VarRef>
     path::[Label]
     deps::[Res]
     scope::Scope ->

      let varRef::VarRef = ref.fromRight in
    
      let varRes::[Res] = 
        concat(map((top.varT.findReachable(lookup, ref, labVAR()::path, [], _)), scope.vars)) in

      let impRes::[Res] = 
        concat(map((top.impT.findReachable(lookup, ref, labIMP()::path, [], _)), scope.imps)) in

      let lexRes::[Res] = 
        concat(map((top.lexT.findReachable(lookup, ref, labLEX()::path, [], _)), scope.lexs)) in

      let contRes::[Res] = 
        if !null(varRes) then varRes
        else if !null(impRes) then impRes
        else lexRes
      in
        case scope of
        | scopeDatum(d) when isFinal && d.id == lookup ->
            varRes(varRef, scope, path) :: contRes 
        | _ -> contRes
        end

      end end end end end;
}

abstract production modRefState
top::State ::=
  isFinal::Boolean
{
  top.findReachable = 
    \lookup::String
     ref::Either<ModRef, VarRef>
     path::[Label]
     deps::[Res]
     scope::Scope ->

      let modRef::ModRef = ref.fromLeft in

      let modRes::[Res] = 
        concat(map((top.modT.findReachable(lookup, ref, labMOD()::path, deps, _)), scope.mods)) in

      let impRes::[Res] = 
        concat(
          map(
            (\r::Res -> 
              top.impT.findReachable(lookup, ref, labIMP()::path, r::deps, r.resTgt)), 
            scope.impsReachable
          )
        ) 
      in

      let lexRes::[Res] = 
        concat(map((top.lexT.findReachable(lookup, ref, labLEX()::path, deps, _)), scope.lexs)) in

      let contRes::[Res] = 
        if !null(modRes) then modRes
        else if !null(impRes) then impRes
        else lexRes
      in
        case scope of
        | scopeDatum(d) when isFinal && d.id == lookup -> 
            impRes(modRef, scope, path) :: contRes
        | _ -> contRes
        end
        
      end end end end end end;
}

{-
 - Sink state in a DFA. 
 - Cannot use the current scope in a resolution, and cannot transition.
 -}
abstract production sinkState
top::State ::=
{ top.findReachable = \_ _ _ _ _ -> []; }


{- DFA creation functions -}

function dfaVarRef
DFA ::=
{
  local start::State = varRefstate(false);
  start.varT = final;
  start.modT = sink;
  start.impT = afterImp;
  start.lexT = start; 

  local afterImp::State = varRefstate(false);
  afterImp.varT = final;
  afterImp.modT = sink;
  afterImp.impT = sink;
  afterImp.lexT = sink; 

  local final::State = varRefstate(true);
  final.varT = sink;
  final.modT = sink;
  final.impT = sink;
  final.lexT = sink;

  local sink::State = sinkState();
  final.varT = sink;
  final.modT = sink;
  final.impT = sink;
  final.lexT = sink;

  return dfa(start);
}

function dfaModRef
DFA ::=
{
  local start::State = modRefState(false);
  start.varT = sink;
  start.modT = final;
  start.impT = afterImp;
  start.lexT = start;

  local afterImp::State = modRefState(false);
  afterImp.varT = sink;
  afterImp.modT = final;
  afterImp.impT = sink;
  afterImp.lexT = sink; 

  local final::State = modRefState(true);
  final.varT = sink;
  final.modT = sink;
  final.impT = sink;
  final.lexT = sink;

  local sink::State = sinkState();
  final.varT = sink;
  final.modT = sink;
  final.impT = sink;
  final.lexT = sink;

  return dfa(start);
}