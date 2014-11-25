ctrlSetText [107, localize (
    if (ctrlText 107 == localize "STR/SQFCALC/FORMATTED-ON") then {
        ctrlShow [103, false];
        ctrlShow [104, true];
        "STR/SQFCALC/FORMATTED-OFF"
    } else {
        ctrlShow [104, false];
        ctrlShow [103, true];
        "STR/SQFCALC/FORMATTED-ON"
    }
)];