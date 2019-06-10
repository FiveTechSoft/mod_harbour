gcc -shared -L~/harbour/lib/linux/gcc -Wl,-soname,libharbour.so.3.2  -o libharbour.so.3.2.0 -ldl -lpthread -lm -lrt
