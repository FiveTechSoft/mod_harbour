@set oldpath=%path%
@set oldinclude=%INCLUDE%
call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
c:\harbour\bin\win\msvc\hbmk2 modharbour.hbp -comp=msvc -Lc:\Apache24\lib32
@set path=%oldpath%
@set INCLUDE=%oldinclude%