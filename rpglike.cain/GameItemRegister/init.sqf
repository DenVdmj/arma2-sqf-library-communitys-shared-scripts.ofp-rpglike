#define __registerDirectory "GameItemRegister\register.sqf"
#define __register varGlobalGameItemRegister
#define arg(x) (_this select(x))
#define argIf(x) if(count _this>(x))
#define argIfType(x,t) if(argIf(x)then{(arg(x)call funcGetVarType)==(t)}else{false})
#define argSafe(x) argIf(x)then{arg(x)}
#define argSafeType(x,t) argIfType(x,t)then{arg(x)}
#define argOr(x,v) (argSafe(x)else{v})

__register = [];

private [
    "_registerData",
    "_countRegisterData",
    "_categoryName",
    "_categoryData",
    "_index",
    "_writeCategory",
    "_chunk"
];

_registerData = call ("["+(preprocessFile __registerDirectory)+"]");
_countRegisterData = count _registerData;

_categoryName = "UNDEFINED";
_categoryData = [];

_index = 0;

_writeCategory = {
    if (count _categoryData > 0) then {
        [__register, _categoryName, _categoryData] call funcStorageAdd;
        _categoryData = [];
    };
};

while {_index < _countRegisterData} do {
    _chunk = _registerData select _index;
    if (_chunk in [_chunk]) then {
        call _writeCategory;
        _categoryName = _chunk;
    } else {
        [_categoryData, _chunk select 0,
            // здесь добавляются новые свойства предметам
            [
                "price", _chunk select 1,
                "ico", _chunk select 2
                // например:
                // "description", _chunk select 2,
                // "еще одно какое-либо свойство", _chunk select 3
            ] call funcStorageCreate
        ] call funcStorageAdd;
        [__register, _object, _record] call funcStorageAdd;
    };
    _index = _index + 1;
};

call _writeCategory;

//
// funcGetGameItemData
// Syntax:
//      [categoryPrefix, itemName<, fieldName>] call funcGetGameItemData
// Example 1:
//      ["M", "Browning", "price"] call funcGetGameItemData
// Example 2:
//      _browningData = ["M", "Browning"] call funcGetGameItemData
//      _someValue = [_browningData, "someKey"] call funcStorageGet
//

funcGetGameItemData = {
    private "_rec";
    _rec = [[__register, arg(0), nil] call funcStorageGet, arg(1), nil] call funcStorageGet;
    if (count _this > 2) then {
        [_rec, arg(2), arg(3)] call funcStorageGet
    } else {
        _rec
    }
};

// ["M", "rls_Map", "ico", "123"] call funcGetGameItemData
// _rec = ["M", "rls_Map"] call funcGetGameItemData; [_rec, "ico"] call funcStorageGet
//

//
// funcSetGameItemData
// Syntax:
//      [categoryPrefix, itemName, fieldName, value] call funcSetGameItemData
// Example:
//      ["M", "Browning", "price", 1000] call funcSetGameItemData
//

funcSetGameItemData = {
    private "_rec";
    _rec = [[__register, arg(0), nil] call funcStorageGet, arg(1), nil] call funcStorageGet;
    if (count _this > 2) then {
        [_rec, arg(2), arg(3)] call funcStorageSet
    };
};

//
// funcGetGameItemPrice
// Syntax:
//      ["category", "itemName"] call funcGetGameItemPrice
//      ["category", "itemName", defaultPrice] call funcGetGameItemPrice
//
// Example:
//      ["M", "HKG3Mag"] call funcGetGameItemPrice
//      ["W", "HKG3"] call funcGetGameItemPrice
//
// Returns price of item
//

funcGetGameItemPrice = {
    [arg(0), arg(1), "price", arg(2)] call funcGetGameItemData
};

//
// funcSetGameItemPrice
// Syntax:
//      ["category", "itemName", newPrice] call funcSetGameItemPrice
//
// Example:
//      ["M", "HKG3Mag", 80] call funcSetGameItemPrice
//

funcSetGameItemPrice = {
    [arg(0), arg(1), "price", arg(2)] call funcSetGameItemData
};

//
// funcGetGameItemIco
// Syntax:
//      ["category", "itemName"] call funcGetGameItemIco
//      ["category", "itemName", defaultIco] call funcGetGameItemIco
//
// Example:
//      ["M", "HKG3Mag"] call funcGetGameItemIco
//

funcGetGameItemIco = {
    [arg(0), arg(1), "ico", arg(2)] call funcGetGameItemData
};





