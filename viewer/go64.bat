@set oldpath=%Path%
@set oldinclude=%INCLUDE%
call "%ProgramFiles(x86)%\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvarsall.bat" x86_amd64
cl.exe main2.cc /EHsc /std:c++17 -I./script c:\webview\script\microsoft.web.webview2.0.9.488\build\native\x64\WebView2Loader.dll.lib -Fe:viewer.exe
@set INCLUDE=%oldinclude%