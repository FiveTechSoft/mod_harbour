@set oldpath=%path%
@set oldinclude=%INCLUDE%
call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64
msbuild msvc\mod_harbour.sln /p:Configuration=Release /t:Clean,Build
c:\harbour\bin\win\msvc64\hbmk2 modharbour.hbp -comp=msvc64 -dHB_WITH_ADS="c:\Program Files\Advantage 11.10\acesdk\" rddads.hbc
@set path=%oldpath%
@set INCLUDE=%oldinclude%