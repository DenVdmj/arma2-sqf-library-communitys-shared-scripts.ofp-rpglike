
#define arg(x)            (_this select(x))
#define argIf(x)          if(count _this>(x))
#define argIfType(x,t)    if(argIf(x)then{(arg(x)call funcGetVarType)==(t)}else{false})
#define argSafe(x)        argIf(x)then{arg(x)}
#define argSafeType(x,t)  argIfType(x,t)then{arg(x)}
#define argOr(x,v)        (argSafe(x)else{v})

#define x(a) ((a) select 0)
#define y(a) ((a) select 1)
#define z(a) ((a) select 2)
#define w(a) ((a) select 2)
#define h(a) ((a) select 3)

#define push(a,v)  (a)set[count(a),(v)]
#define pushTo(a)  call{(a)set[count(a),_this]}
