function branch_0 (Boolean, Scope) ::= p::Path x::Scope{local s::Scope = x;return (true, s);}
function branch_1 (Boolean, Scope) ::= p::Path x::Scope{local s::Scope = x;return (true, s);}
function branch_2 (Boolean, Scope) ::= p::Path x::Scope l::Label xs::Path{local tgt_3::(Boolean, Scope) = tgt(p);return (true, s);}
function branch_4 (Boolean, Scope) ::= p::Path x::Scope l::Label xs::Path{local match_5::(ok_6, s) = case xs of End(x) -> branch_1(p, x)|Edge(x, l, xs) -> branch_2(p, x, l, xs) end;local ok_6::Boolean = match_5.1;local s::Scope = match_5.2;return (ok_6, s);}
function branch_7 (Boolean, Scope) ::= p::Path x::Scope{local s::Scope = x;return (true, s);}
function branch_8 (Boolean, Scope) ::= p::Path x::Scope l::Label xs::Path{local s::Scope = x;return (true, s);}
function datumOf (Boolean, Datum) ::= p::Path{local tgt_9::(Boolean, Scope) = tgt(p);local d::Datum = top.s.datum;return (d);}
function src (Boolean, Scope) ::= p::Path{local match_10::(ok_11, s) = case p of End(x) -> branch_7(p, x)|Edge(x, l, xs) -> branch_8(p, x, l, xs) end;local ok_11::Boolean = match_10.1;local s::Scope = match_10.2;return (ok_11, s);}
function tgt (Boolean, Scope) ::= p::Path{local match_12::(ok_13, s) = case p of End(x) -> branch_0(p, x)|Edge(x, l, xs) -> branch_4(p, x, l, xs) end;local ok_13::Boolean = match_12.1;local s::Scope = match_12.2;return (ok_13, s);}