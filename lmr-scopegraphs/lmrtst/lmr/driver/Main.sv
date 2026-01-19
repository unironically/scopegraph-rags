grammar lmrtst:lmr:driver;

imports syntax:lmr0:lmr:driver;
imports syntax:lmr0:lmr:concretesyntax;
imports syntax:lmr0:lmr:abstractsyntax;

imports lmrtst:lmr:nameanalysis;

imports silver:util:treemap;


function main
IO<Integer> ::= largs::[String]
{
  return
    if !null(largs)
      then do {
        let filePath :: String = head(largs);
        file :: String <- readFile(head(largs));

        let fileName::String = head(explode(".", last(explode("/", filePath))));

        let result :: ParseResult<Main_c> = parse(file, filePath);
        let ast :: Main = result.parseTree.ast;

        let fileNameExt::String = last(explode("/", filePath));
        let fileNameExplode::[String] = explode(".", fileNameExt);
        let fileName::String = head(fileNameExplode);

        if result.parseSuccess
          then do {
            if length(fileNameExplode) >= 2 && last(fileNameExplode) == "lm"
              then do {
                print("[✔] Parse success\n");
                res::Integer <- programOk(ast.ok);

                thing::Integer <- doThing();
                return thing;
              }
              else do {
                print("[✗] Expected an input file of form [file name].lm\n");
                return -1;
              };
          }
          else do {
            print("[✗] Parse failure\n" ++ result.parseErrors);
            return -1;
          };
      }
      else do {
        print("[✗] No input file given\n");
            return -1;
      };
}

fun programOk IO<Integer> ::= ok::Boolean = do {
  print(if ok then "[✔] Semantic check successful\n" else "[✗] Semantic check failed\n");
  return if ok then 0 else -1;
};

fun doThing IO<Integer> ::= = do {
  return doThingReal();
};

----------

nonterminal MyMap<a b>;
synthesized attribute compare<a>::(Integer ::= a a) occurs on MyMap<a b>; 
synthesized attribute lookup<a b>::([b] ::= a) occurs on MyMap<a b>;

production emptyMyMap
top::MyMap<a b> ::= comparator::(Integer ::= a a)
{
  top.compare = comparator;
  top.lookup = \k::a ->
    []
  ;
}

production consMyMap
top::MyMap<a b> ::= k::a v::b m::MyMap<a b>
{
  top.compare = m.compare;
  top.lookup = \k_::a ->
    if top.compare(k, k_) == 0
    then v :: m.lookup(k_)
    else m.lookup(k_)
  ;
}

----------

function mergeMyMap
MyMap<a b> ::= l::MyMap<a b> r::MyMap<a b>
{
  return
    case l of
    | consMyMap(k, v, m) -> consMyMap(k, v, mergeMyMap(^m, ^r))
    | emptyMyMap(_) -> ^r
    end;
}

function doThingReal
Integer ::= 
{

  production attribute testMap::MyMap<String Integer> with mergeMyMap;
  testMap := emptyMyMap(compareString);
  testMap <- consMyMap("a", error("a"), emptyMyMap(compareString));
  testMap <- consMyMap("b", error("b"), emptyMyMap(compareString));
  testMap <- consMyMap("c",          0, emptyMyMap(compareString));
  testMap <- consMyMap("d", error("d"), emptyMyMap(compareString));
  testMap <- consMyMap("e", error("e"), emptyMyMap(compareString));

  return head(testMap.lookup("c"));

}