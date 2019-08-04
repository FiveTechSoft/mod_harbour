clang -dynamiclib -flat_namespace -L$HOME/harbour_for_modharbour/lib/darwin/clang -L/usr/local/lib -install_name "libharbour.dylib" -compatibility_version 3.2 -current_version 3.2.0 -lslang -lpcre -lm

