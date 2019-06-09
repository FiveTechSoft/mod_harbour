call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64
link.exe /MACHINE:amd64 -nxcompat -dynamicbase -nologo -dll -subsystem:console -libpath:c:/harbour_for_modharbour64/lib/win/msvc64 -def:harbour.def -nodefaultlib:libcmt.lib -out:"libharbour.dll" @libs.txt @windows.txt
