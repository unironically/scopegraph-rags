grammar lmr1:lmr:nameanalysis6;

--

fun resolve
  Scope_ a,  LMEdgeLabels subset i =>
[Result] ::= r::Regex<i> s::Decorated a with i =
  []
;

--

nonterminal Result;

production resultScope
Scope_ s,
LMEdgeLabels subset i =>
top::Result ::= node::Decorated s with i
{}

production resultRegion
Region_ s,
LMEdgeLabels subset i =>
top::Result ::= node::Decorated s with i
{}

production resultDcl
Dcl_ s,
LMEdgeLabels subset i =>
top::Result ::= node::Decorated s with i
{}

production resultLex
Lex_ s,
LMEdgeLabels subset i =>
top::Result ::= node::Decorated s with i
{}

production resultVar
Var_ s,
LMEdgeLabels subset i =>
top::Result ::= node::Decorated s with i
{}

production resultMod
Mod_ s,
LMEdgeLabels subset i =>
top::Result ::= node::Decorated s with i
{}

--

fun followLex
  Scope_ s, LMEdgeLabels subset i =>
[Decorated Region] ::= s::Decorated s with i =
  s.lex
;

fun followVar
  Scope_ s, LMEdgeLabels subset i =>
[Decorated Var] ::= s::Decorated s with i =
  s.var
;

fun followMod
  Scope_ s, LMEdgeLabels subset i =>
[Decorated Mod] ::= s::Decorated s with i =
  s.mod
;

fun followImp
  Scope_ s, LMEdgeLabels subset i =>
[Decorated Mod] ::= s::Decorated s with i =
  s.imp
;

--

fun rxLab
  Scope_ a,
  Scope_ b,
  LMEdgeLabels subset i,
  LMEdgeLabels subset j =>
([Decorated a with i] ::= Decorated b with j) ::= f::([Decorated a with i] ::= Decorated b with j)
=
  \s::Decorated b with j -> f(s)
;

fun rxConcat
  Scope_ a,
  Scope_ b,
  Scope_ c,
  LMEdgeLabels subset i,
  LMEdgeLabels subset j,
  LMEdgeLabels subset k =>
([Decorated c with k] ::= Decorated b with j) ::=
  f1::([Decorated a with i] ::= Decorated b with j)
  f2::([Decorated c with k] ::= Decorated a with i)
=
  \s::Decorated b with j ->
    let res1::[Decorated a with i] = f1(s) in
    let res2::[Decorated c with k] = concat(map(f2(_), res1)) in
      res2
    end end
;

fun queryLexVar
  Scope_ a,
  LMEdgeLabels subset i =>
[Decorated Var] ::= s::Decorated a with i
=
  rxConcat(
    rxLab(followLex),
    rxLab(followVar)
  )(s)
;

--

{-
  let cont::[DecScope<i>] =
    -- labels that form a prefix of a word in L(r)
    let validLabels::[Label<i>] = r.first in
      foldl (
        \acc::(Maybe<Label<i>>, [DecScope<i>]) nextLab::Label<i> ->
          -- label followed to get the resolution in acc.2
          let prevLab::Maybe<Label<i>> = acc.1
          in
          -- resolution found by following the label in acc.1
          let prevRes::[DecScope<i>] = acc.2
          in
          -- make a new resolution by following edges with label nextLab
          let nextRes::[DecScope<i>] =
            concat(map(resolve(p, r.deriv(nextLab), o, _),
                       nextLab.demand(s)))
          in
          -- use function o to compare nextLab with the previous
          -- if -1, resolutions found by following edges of nextLab shadow previous resolutions
          -- if  0, combine results of following edges of label nextLab with previous results
          -- if  1, resolutions found by following edges of prevLab shadow those by following nextLab
          let compare::Integer = o.fromJust(nextLab, prevLab.fromJust)
          in
            -- if there is an ordering, a previous resolution, comparison is not 0, and new resolution is nonempty
            if o.isJust && prevLab.isJust && compare != 0 && !null(nextRes)
            then  -- visibility
              if compare < 0
              then (just(nextLab), nextRes) -- nextLab < prevLab
              else (prevLab, prevRes)       -- nextLab > nextLab
            else  -- reachability
              (just(nextLab), prevRes ++ nextRes)
          end end end end,
        (nothing(), []),
        validLabels
      ).2
    end
  in
    case r.simplify of
    | regexEmpty() -> []
    | _ -> if p(s.datum) && r.nullable then s::cont else cont
    end
  end;
-}