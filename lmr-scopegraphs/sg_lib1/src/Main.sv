grammar sg_lib:src;

function main
IO<Integer> ::= largs::[String]
{
  return do {
    
    let s1::Decorated SGScope with {lex, var} = 
      decorate mkScope(location=bogusLoc()) with {lex = [error("moo")]; var = [];};
    
    let s2::Decorated SGScope with {lex, var, imp, mod} =
      decorate ^s1 with {lex = s1.lex; var = s1.var; imp = []; mod = [];};

    print(toString(length(s2.lex)) ++ "\n");

    return 0;

  };
}