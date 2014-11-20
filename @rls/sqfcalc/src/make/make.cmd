@set cpbo="e:\modmaking\arma2\programs\kegetys\cpbo\cpbo.exe" -y -p
@set optcpp="%PERL_PATH%\bin\Perl" -I"D:\den\scripts\userlib" "%~dp0\ofp-config-precalculate-values.pl"
@set rapify=e:\Modmaking\ARMA2\programs\mikero-pbodll\Rapify.exe -o

if exist "..\bin.workplace" (
    del /Q /F "..\bin.workplace\*"
) else (
    md "..\bin.workplace"
)

copy "..\bin\resource.cpp" "..\bin.workplace\*"
copy "..\bin\resource.sqfcalc.cpp" "..\bin.workplace\*"

cd "..\bin.workplace"

%optcpp% "resource.cpp" "resource.result.cpp" > "log-resource"
%rapify% "resource.result.cpp" "resource.bin"

md "..\..\bin"
copy "resource.bin" "..\..\bin\resource.bin"

cd ".."
del /Q /F "bin.workplace\*"
rd "bin.workplace"

md "../addons"
del "../addons/vdmj_sqfcalc.pbo"
%cpbo% "vdmj_sqfcalc" "../addons/vdmj_sqfcalc.pbo"
