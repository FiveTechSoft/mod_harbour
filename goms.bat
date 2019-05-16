c:\harbour\bin\win\msvc64\harbour -n main.prg

rem call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64

call "%ProgramFiles(x86)%\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64

cl -TC -LD -Ic:\harbour\include -Ic:\Apache24\include mod_harbour.c main.c @libs.txt -link -out:mod_harbour.so

copy mod_harbour.so c:\Apache24\modules\mod_harbour.so 