grammar lmr0:lmr:nameanalysis10;

--

nonterminal Scope<(a::InhSet) b>;

synthesized attribute datum<b>::b occurs on Scope<(a::InhSet) b>;

production mkScope
top::Scope<(a::InhSet) b> ::= d::b
{ top.datum = d; }

production mkScope_var
top::Scope<LMSet (String, Type)> ::= d::(String, Type)
{ forwards to mkScope(d); }

--

type LMSet = {lex, var};

attribute lex, var occurs on Scope<(a::InhSet) b>;

inherited attribute lex::[Scope_dft];
inherited attribute var::[Scope_dft];

type Scope_dft = Decorated Scope<LMSet Either<Unit (String, Type)>> with LMSet;
type Scope_var = Decorated Scope<LMSet (String, Type)> with LMSet;

--

function coerce_var
Scope_dft ::= s::Scope_var
{
  return
    decorate mkScope(right(s.datum)) with {
      lex = s.lex;
      var = s.var;
    }
  ;
}

--

function to_var
Scope_var ::= s::Scope_dft
{
  return
    case s.datum of
    | right(d) -> decorate mkScope(d) with {
                    lex = s.lex;
                    var = s.var;
                  }
    | _ -> error("")
    end
  ;
}

--

type Predicate_var = (Boolean ::= (String, Type));

function predicate_var
(Boolean ::= Scope_var) ::= p::Predicate_var
{
  return
    \s::Scope_var -> p(s.datum)
  ;
}

function filter_var
[Scope_var] ::= p::Predicate_var ss::[Scope_var]
{
  return filter(predicate_var(p), ss);
}

function querypred_var
(Boolean ::= Scope_dft) ::= p::Predicate_var
{
  return
    \s::Scope_dft ->
      case s.datum of
      | right(d) -> p(d)
      | _ -> false
      end
  ;
}