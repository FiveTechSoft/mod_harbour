@set oldpath=%path%
@set oldinclude=%INCLUDE%
call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64
c:\harbour\bin\win\msvc64\hbmk2 modharbour.hbp -comp=msvc64 -hbx=modharbour.hbx -dHB_WITH_ADS -dHB_WITH_ADS="c:\Program Files\Advantage 11.10\acesdk\" rddads.hbc
@set path=%oldpath%
@set INCLUDE=%oldinclude%
copy modharbour.exe c:\apache24\bin\modharbour.exe
