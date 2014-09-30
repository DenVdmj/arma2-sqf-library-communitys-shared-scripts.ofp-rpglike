// SQF

#define __q(str) #str
#define __project_name rls

#define var(name) __project_name##_var_##name
#define func(name) __project_name##_func_##name
#define invoke(name) call func(name)

// redefine name preprocessFile
#define currentLangAbbr (localize "STR:LNG")
#define currentLang (localize "STR:LANGUAGE")

//
// Arguments macro
//

#define arg(i) (_this select (i))
#define ifExistArg(i) if (count _this > (i))
#define argIfExist(i) ifExistArg(i) then { arg(i) }
#define argOr(i,v) (argIfExist(i) else {v})

//
// Position macro
//

#define x(a) ((a)select 0)
#define y(a) ((a)select 1)
#define z(a) ((a)select 2)
#define w(a) ((a)select 2)
#define h(a) ((a)select 3)

//
// Array macro
//

#define push(a,v) (a)set[count(a),(v)]
#define pushTo(a) call{(a)set[count(a),_this]}
#define top(a) ((a)select([count(a)-1,0]select(count(a)<1)))
#define pop(a) (0 call{_this=top(a);(a)resize([count(a)-1,0]select(count(a)<1));_this})
#define writeTop(a,v) (a)set[count(a)-1,v]
#define randomSelect(a) ((a) select ((random count (a)) - .5) )

//
// Math macro
//

#define mathInf 1e9999
#define logN(pow,num) ((log(num))/(log(pow)))
#define log2(num) ((log(num))/.3010299956639812)
#define round(v) ((v)-((v)%1))
#define frac(v) ((v)-round(v))
#define xor(a,b) (!((a)&&(b))&&((a)||(b)))
#define inc(n) (call{n=n+1;n})
#define dec(n) (call{n=n-1;n})
#define change(v) v = v
#define _(v) _##v = _##v

//
// for, map, grep
//

#define map(lst) call{private"_0r_";_0r_=[];{_0r_ set[count _0r_,call{private"_0r_";_x call _this}]}foreach(lst);_0r_}
#define grep(lst) call{private"_0r_";_0r_=[];{if(call{private"_0r_";_x call _this})then{push(_0r_,_x)}}foreach(lst);_0r_}

