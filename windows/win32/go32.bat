call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86

cl -TC -LD -Ic:\Apache24\include mod_harbour.c @libs.txt -link -out:mod_harbour.so

copy mod_harbour.so c:\Apache24\modules\mod_harbour.so 
