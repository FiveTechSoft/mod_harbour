call "%ProgramFiles%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86
link.exe /MACHINE:x86 -nxcompat -dynamicbase -nologo -dll -subsystem:console -libpath:c:/harbour_for_modharbour/lib/win/msvc -def:harbour.def -nodefaultlib:libcmt.lib -out:"libharbour.dll" @libs.txt @windows.txt
