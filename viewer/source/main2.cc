//bin/echo; [ $(uname) = "Darwin" ] && FLAGS="-framework Webkit" || FLAGS="$(pkg-config --cflags --libs gtk+-3.0 webkit2gtk-4.0)" ; c++ "$0" $FLAGS -std=c++11 -g -o webview && ./webview ; exit
// +build ignore

#include "webview.h"

#include <iostream>

#ifdef _WIN32
int CALLBACK WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance,
                     LPSTR lpCmdLine, int nCmdShow)
#else
int main()
#endif
{
  webview::webview w(true, nullptr);
  w.set_title( "mod_Harbour viewer" );
  w.set_size(480, 320, WEBVIEW_HINT_NONE);
  w.set_size(180, 120, WEBVIEW_HINT_MIN);
  w.navigate( lpCmdLine );
  w.run();
  return 0;
}
