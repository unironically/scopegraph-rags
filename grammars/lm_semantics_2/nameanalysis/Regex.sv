grammar lm_semantics_2:nameanalysis;

nonterminal Regex;

synthesized attribute dfa::DFA occurs on Regex;
synthesized attribute nfa::NFA occurs on Regex;

synthesized attribute pp::String;

attribute pp occurs on Regex;

abstract production regexEpsilon
top::Regex ::= 
{
  local initial :: Integer = genInt ();
  local final :: Integer = genInt ();
  top.nfa = ([initial, final], [(initial, nothing(), final)], initial, final);
  top.dfa = nfaToDFA (top.nfa);
  top.pp = "eps";
}

abstract production regexSingle
top::Regex ::= l::Label
{
  local initial :: Integer = genInt();
  local final   :: Integer = genInt();
  top.nfa = ([initial, final], [(initial, just(l), final)], initial, final);
  top.dfa = nfaToDFA (top.nfa);
  top.pp = l.pp;
}

abstract production regexStar
top::Regex ::= r::Regex
{
  local initial :: Integer = genInt();
  local final   :: Integer = genInt();
  top.nfa = case r.nfa of
              (subStates, subTrans, subInitial, subFinal) 
              ->
                (
                  initial::final::subStates,              -- States
                  (initial, nothing(), final)::           -- Transitions
                    (subFinal, nothing(), subInitial)::
                    (initial, nothing(), subInitial)::
                    (subFinal, nothing(), final)::
                    subTrans,
                  initial,                                -- Start state
                  final                                   -- Accepting state
                )
            end;
  top.dfa = nfaToDFA (top.nfa);
  top.pp = "(" ++ r.pp ++ ")*";
}

abstract production regexCat
top::Regex ::= r1::Regex r2::Regex
{
  top.nfa = case (r1.nfa, r2.nfa) of
              ((fstStates, fstTrans, fstInitial, fstFinal),
               (sndStates, sndTrans, sndInitial, sndFinal)) 
              ->
                (
                  fstStates ++ sndStates,
                  (fstFinal, nothing(), sndInitial)::(fstTrans ++ sndTrans),
                  fstInitial,
                  sndFinal
                )
            end;
  top.dfa = nfaToDFA (top.nfa);
  top.pp = r1.pp ++ " " ++ r2.pp;
}

abstract production regexAlt
top::Regex ::= r1::Regex r2::Regex
{
  local initial :: Integer = genInt();
  local final   :: Integer = genInt();
  top.nfa = case (r1.nfa, r2.nfa) of
              ((fstStates, fstTrans, fstInitial, fstFinal),
               (sndStates, sndTrans, sndInitial, sndFinal)) 
              ->
                (
                  initial::final::(fstStates ++ sndStates),
                  (initial, nothing(), fstInitial)::
                    (initial, nothing(), sndInitial)::
                    (fstFinal, nothing(), final)::
                    (sndFinal, nothing(), final)::
                    (fstTrans ++ sndTrans),
                  initial,
                  final
                )
            end;
  top.dfa = nfaToDFA (top.nfa);
  top.pp = r1.pp ++ " " ++ r2.pp;
}

abstract production regexOption
top::Regex ::= r::Regex
{
  forwards to regexAlt (r, regexEpsilon());
}

nonterminal Label;

attribute pp occurs on Label;

synthesized attribute priority::Integer occurs on Label;

{-----------------------------}
{----- LANGUAGE SPECIFIC -----}

abstract production labelVar
top::Label ::= { 
  top.pp = "VAR";
  top.priority = 1;
}

abstract production labelMod
top::Label ::= { 
  top.pp = "MOD";
  top.priority = 1;
}

abstract production labelImp
top::Label ::= { 
  top.pp = "IMP";
  top.priority = 2;
}

abstract production labelLex
top::Label ::= { 
  top.pp = "LEX";
  top.priority = 3;
}

instance Eq Label {
  eq = \l1::Label l2::Label -> l1.pp == l2.pp;
}

instance Ord Label {
  compare = \l1::Label l2::Label -> 
              if      l1.priority < l2.priority then 1
              else if l1.priority > l2.priority then -1
              else    0;
}

{-----------------------------}
{-----------------------------}

global globLabs::[Label] = [labelLex(), labelVar(), labelMod(), labelImp()];
type NFA = ([Integer], [NFATrans], Integer, Integer);   -- states, transitions, initial state, accepting state
type DFA = ([Integer], [DFATrans], Integer, [Integer]); -- states, transitions, inital state, accepting states
type NFATrans = (Integer, Maybe<Label>, Integer);
type DFATrans = (Integer, Label, Integer); 


function nfaToDFA
DFA ::= n::NFA
{
  return
    case n of
      (states, trans, start, final) ->
        
        let s0::[Integer] = eClosure (trans, [start]) in
        let states_moves::([[Integer]], [([Integer], Label, [Integer])]) = dfaMoves (trans, [], [s0]) in
        
        let states::[[Integer]] = fst(states_moves) in
        let moves::[([Integer], Label, [Integer])] = snd(states_moves) in

        let statesNums::[(Integer, [Integer])] = map ((\is::[Integer] -> (genInt(), is)), states) in 
        let movesNums::[DFATrans] = getDFATrans (moves, statesNums) in 

        let states::[Integer] = map ((fst(_)), statesNums) in 
        
        let startSt::Integer = fst(head(filter ((\pair::(Integer, [Integer]) -> contains(start, snd(pair))), statesNums))) in

        let endSt::[Integer] = map ((fst(_)), filter ((\pair::(Integer, [Integer]) -> contains(final, snd(pair))), statesNums)) in 

        (states, movesNums, startSt, endSt)

        end end end end end end end end end

    end;
}

function getDFATrans
[DFATrans] ::= dfaTransVerbose::[([Integer], Label, [Integer])] assgn::[(Integer, [Integer])]
{
  return
    case dfaTransVerbose of
      [] -> []
    | (from, lab, final)::t -> (getStateNum(from, assgn), lab, getStateNum(final, assgn)) :: getDFATrans (t, assgn)
    end;
}

function dfaAccepts
Boolean ::= dfa::DFA state::Integer
{
  return contains (state, snd(snd(snd(dfa))));
}

function getStateNum
Integer ::= st::[Integer] states::[(Integer, [Integer])]
{
  return
    case states of
      [] -> -1
    | (hI, hS)::t -> if hS == st then hI else getStateNum (st, t)
    end;
}

function dfaMoves
([[Integer]], [([Integer], Label, [Integer])]) ::= trans::[NFATrans] marked::[[Integer]] unmarked::[[Integer]]
{
  return
    case unmarked of
      [] -> (marked, [])
    | h::t -> 
      let transFromCurrent::[([Integer], Label, [Integer])] = transOnAll (trans, h, globLabs) in
      let unseen::[[Integer]] = filter((\sts::[Integer] -> !contains(sts, marked ++ unmarked)), map ((\t::([Integer], Label, [Integer]) -> snd(snd(t))), transFromCurrent)) in
      let rest::([[Integer]], [([Integer], Label, [Integer])]) = dfaMoves (trans, h::marked, t ++ unseen) in 
        (fst(rest), transFromCurrent ++ snd(rest))
      end end end
    end;
}

{- What states can I get to from any state in `from` on all labels in `labs`/ -}
function transOnAll
[([Integer], Label, [Integer])] ::= trans::[NFATrans] from::[Integer] labs::[Label]
{
  return
    case labs of
      [] -> []
    | h::t -> 
      let onLab::[Integer] = transOnLabel (trans, from, h) 
      in if !null (onLab) 
           then (from, h, eClosure (trans, onLab)) :: transOnAll (trans, from, t) 
           else transOnAll (trans, from, t)
      end
    end;
}

{- What states can I get to from any state in `from` on label `lab`/ -}
function transOnLabel
[Integer] ::= trans::[NFATrans] from::[Integer] lab::Label
{
  return 
    let valid::[NFATrans] = filter ((\t::NFATrans -> contains(fst(t), from) && fst(snd(t)) == just(lab)), trans) 
    in map ((\t::NFATrans -> snd(snd(t))), valid) end;
}

function eClosure
[Integer] ::= trans::[NFATrans] from::[Integer]
{
  return
    let validTrans::[NFATrans] = filter ((\t::NFATrans -> contains(fst(t), from) && !contains((snd(snd(t))), from) && !fst(snd(t)).isJust), trans) in
    let newStates::[Integer]  = map    ((\t::NFATrans -> snd(snd(t))), validTrans) in
      if null(newStates) 
        then sort(from)
        else eClosure (trans, from ++ newStates)
    end end;
}