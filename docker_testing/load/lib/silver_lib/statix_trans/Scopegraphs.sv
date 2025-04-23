grammar statix_trans;

nonterminal Scope;
inherited attribute datum::Decorated Datum occurs on Scope;

nonterminal Datum;
inherited attribute data::Nt_actualData occurs on Datum;

nonterminal Nt_actualData;

nonterminal Label;

--------------------------------------------------
--------------------------------------------------

abstract production pf_mkScope
top::Scope ::=
{ forwards to pf_mkScopeDatum(pf_DatumNone()); }

abstract production pf_mkScopeDatum
top::Scope ::= datum::Datum
{}

--------------------------------------------------

abstract production pf_DatumNone
top::Datum ::= 
{ }

--------------------------------------------------
--------------------------------------------------

nonterminal Regex;

abstract production pf_regexLabel
top::Regex ::= l::Label {}

abstract production pf_regexEps
top::Regex ::= {}

abstract production pf_regexEmptySet
top::Regex ::= {}

abstract production pf_regexStar
top::Regex ::= r::Regex {}

abstract production pf_regexAnd
top::Regex ::= r1::Regex r2::Regex {}

abstract production pf_regexSeq
top::Regex ::= r1::Regex r2::Regex {}

abstract production pf_regexAlt
top::Regex ::= r1::Regex r2::Regex {}

abstract production pf_regexNeg
top::Regex ::= r::Regex {}

--------------------------------------------------
--------------------------------------------------

nonterminal Path;

abstract production pf_End
top::Path ::= s::Decorated Scope {}

abstract production pf_Edge
top::Path ::= s::Decorated Scope l::Label p::Path {}

--------------------------------------------------
--------------------------------------------------

function pf_one
Decorated Path ::= ps::[Decorated Path]
{
  return
    case ps of
    | [h] -> h
    | _ -> error("Path list given to pf_one was not a singleton, aborting...")
    end;
}

function path_comp
Integer ::= f::(Integer ::= Label Label) p1::Decorated Path p2::Decorated Path
{
  return
    case (p1, p2) of
    | (pf_Edge(x1, l1, xs1), pf_Edge(x2, l2, xs2)) ->
        let headRes::Integer = f(^l1, ^l2) in
          if headRes == 0
          then path_comp(f, xs1, xs2)
          else headRes
        end
    | (pf_End(_), pf_End(_)) -> 0
    | (pf_End(_), _) -> -1
    | (_, pf_End(_)) -> 1
    end;
}

function pf_path_min
[Decorated Path] ::= f::(Integer ::= Label Label) ps::[Decorated Path]
{
  return
    case ps of
    | [] -> []
    | hp::t -> 
        foldr(
          \p::Decorated Path acc::[Decorated Path] ->
            let hd::Decorated Path = head(acc) in
            let minRes::Integer = path_comp(f, p, hd) in
              if minRes == -1 then [p]
              else if minRes == 1 then acc
              else p::acc
            end end,
          [hp],
          t
        )
    end;
}

function pf_path_filter
[Decorated Path] ::= f::(Boolean ::= Decorated Datum) ps::[Decorated Path]
{
  return
    foldr(
      \p::Decorated Path acc::[Decorated Path] ->
        let ptgt::(Boolean, Decorated Scope) = builtin_tgt(p) in
          case ptgt of
          | (ok_, s_) ->
              if !ok_
              then error("bad tgt res in pf_path_filter")
              else if f(s_.datum) then p::acc else acc
          end
        end,
      [],
      ps
    );
}

function builtin_tgt
(Boolean, Decorated Scope) ::= p::Decorated Path
{
  return
    case p of
    | pf_End(s_)       -> (true, s_)
    | pf_Edge(_, _, p) -> builtin_tgt(p)
    end;
}

--------------------------------------------------
--------------------------------------------------

function nullableAnd
Boolean ::= r1::Regex r2::Regex
{
  return nullable(^r1) && nullable(^r2);
}

function nullableOr
Boolean ::= r1::Regex r2::Regex
{
  return nullable(^r1) || nullable(^r2);
}

function nullable
Boolean ::= r::Regex
{
  return
    case r of
    | pf_regexLabel(_)    -> false
    | pf_regexEps()       -> true
    | pf_regexEmptySet()  -> false
    | pf_regexStar(_)     -> true
    | pf_regexSeq(r1, r2) -> nullableAnd(^r1, ^r2)
    | pf_regexAnd(r1, r2) -> nullableAnd(^r1, ^r2)
    | pf_regexAlt(r1, r2) -> nullableOr(^r1, ^r2)
    | pf_regexNeg(r)      -> !nullable(^r)
    end;   
}

function matchLab
Regex ::= l::Label r::Regex
{
  return
    case r of
    | pf_regexLabel(l_)   -> if eqLabel(^l, ^l_) then pf_regexEps() else pf_regexEmptySet()
    | pf_regexEps()       -> pf_regexEmptySet()
    | pf_regexEmptySet()  -> pf_regexEmptySet()
    | pf_regexStar(r)     -> pf_regexSeq(matchLab(^l, ^r), pf_regexStar(^r))
    | pf_regexSeq(r1, r2) -> let r1nullable::Boolean = nullable(^r1) in
                          let r1rec::Regex = pf_regexSeq(matchLab(^l, ^r1), ^r2) in
                            if r1nullable
                            then pf_regexAlt(r1rec, matchLab(^l, ^r2))
                            else r1rec
                          end end
    | pf_regexAnd(r1, r2) -> pf_regexAnd(matchLab(^l, ^r1), matchLab(^l, ^r2))
    | pf_regexAlt(r1, r2) -> pf_regexAlt(matchLab(^l, ^r1), matchLab(^l, ^r2))
    | pf_regexNeg(r)      -> pf_regexNeg(matchLab(^l, ^r))
    end;  
}

function isEmptySet
Boolean ::= r::Regex
{
  return
    case r of
    | pf_regexLabel(_)    -> false
    | pf_regexEps()       -> false
    | pf_regexEmptySet()  -> true
    | pf_regexStar(r)     -> isEmptySet(^r)
    | pf_regexSeq(r1, r2) -> isEmptySet(^r1) || isEmptySet(^r2)
    | pf_regexAnd(r1, r2) -> isEmptySet(^r1) || isEmptySet(^r2)
    | pf_regexAlt(r1, r2) -> isEmptySet(^r1) && isEmptySet(^r2)
    | pf_regexNeg(r)      -> isEmptySet(^r)
    end;
}

function isEpsilon
Boolean ::= r::Regex
{
  return
    case r of
    | pf_regexLabel(_)    -> false
    | pf_regexEps()       -> true
    | pf_regexEmptySet()  -> false
    | pf_regexStar(r)     -> false
    | pf_regexSeq(r1, r2) -> isEpsilon(^r1) && isEpsilon(^r2)
    | pf_regexAnd(r1, r2) -> isEpsilon(^r1) && isEpsilon(^r2)
    | pf_regexAlt(r1, r2) -> let r1Empty::Boolean = isEmptySet(^r1) in
                          let r2Empty::Boolean = isEmptySet(^r2) in
                            (isEpsilon(^r1) && isEpsilon(^r2)) ||
                            (r1Empty && isEpsilon(^r2) || r2Empty && isEpsilon(^r1))
                          end end
    | pf_regexNeg(r)       -> false
    end;
}

function dwce
Boolean ::= r::Regex s::Decorated Scope
{
  return
    if isEmptySet(^r) 
    then 
      true
    else if isEpsilon(^r)
    then 
      case s of -- demand the scope is built
      | pf_mkScope()       -> true
      | pf_mkScopeDatum(_) -> true
      end
    else 
      foldr(
        \l::Label acc::Boolean ->
          acc &&
          all (map (\s_::Decorated Scope -> dwce(matchLab(l, ^r), s_),
                    demandEdgesForLabel(s, l))),
        true,
        globalLabelList -- todo generic
      );
}

function pf_query
[Decorated Path] ::= s::Decorated Scope r::Regex
{
  return
    if dwce(^r, s)
    then resolve(^r, s)
    else [];
}

function resolve
[Decorated Path] ::= r::Regex s::Decorated Scope
{
  return
    if isEmptySet(^r)
    then 
      []
    else if isEpsilon(^r)
    then 
      [decorate pf_End(s) with {}]
    else 
      concat (
        map (
          \l::Label ->
            concat (
              map (
                \s_::Decorated Scope ->
                  map (
                    \p::Decorated Path -> decorate pf_Edge(s, l,  ^p) with {},
                    resolve(matchLab(l, ^r), s_)
                  ),
                demandEdgesForLabel(s, l)
              )
            ),
          globalLabelList -- todo generic
        )
      );
}

--------------------------------------------------
--------------------------------------------------