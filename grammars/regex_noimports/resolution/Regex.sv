grammar regex_noimports:resolution;


nonterminal Regex;


{- NFA for a given regex:   States     Transitions                         Start    Acc -}
synthesized attribute nfa::([Integer], [(Integer, Maybe<Label>, Integer)], Integer, Integer) occurs on Regex;


attribute pp occurs on Regex, Label;


abstract production regexSingle
top::Regex ::= l::Label
{
  local initial :: Integer = genInt();
  local final   :: Integer = genInt();
  top.nfa = ([initial, final], [(initial, just(l), final)], initial, final);
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
                  (fstFinal, nothing(), sndFinal)::(fstTrans ++ sndTrans),
                  fstInitial,
                  sndFinal
                )
            end;
  top.pp = r1.pp ++ " " ++ r2.pp;
}


nonterminal Label;


abstract production labelLex
top::Label ::= { top.pp = "LEX"; }

abstract production labelVar
top::Label ::= { top.pp = "VAR"; }