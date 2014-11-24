@echo off

@set source_dir=%~dp0\..
@set target_dir=%~dp0\..\..
@set workplace=%~dp0\workplace

@set tool_makepbo="%~dp0/bin/cpbo.exe" -y -p
@set tool_perl="%~dp0/bin/perl.exe" -I"%~dp0lib"
@set tool_optcpp=%tool_perl% "%~dp0/lib/optconf.pl"
@set tool_sqspacker=%tool_perl% "%~dp0/lib/sqs.packer.pl" "%~dp0/bin"
@set tool_rapify="%~dp0/bin/rapify.exe" -o


call:copydir "bin" "%source_dir%" "%workplace%"
cd "%workplace%\bin"
%tool_optcpp% "resource.cpp" "resource.result.cpp" > "log-resource"
%tool_rapify% "resource.result.cpp" "resource.bin"
xcopy /Y "resource.bin" "%target_dir%\bin\"

call:copydir "vdmj_sqfcalc" "%source_dir%" "%workplace%"
cd "%workplace%\vdmj_sqfcalc"
%tool_sqspacker% "eval.sqf" "eval.sqs"
%tool_rapify% "config.cpp" "config.bin"
del /Q "config.cpp" > nul
mkdir "%target_dir%\addons" > nul
del /Q "%target_dir%\addons\vdmj_sqfcalc.pbo" > nul
%tool_makepbo% "%workplace%\vdmj_sqfcalc" "%target_dir%\addons\vdmj_sqfcalc.pbo"

goto:eof

:copydir
    if exist "%~3\%~1" (
        del /Q /F "%~3\%~1\*" > nul
    ) else (
        mkdir "%~3\%~1" > nul
    )
    xcopy "%~2\%~1" "%~3\%~1"
goto:eof
