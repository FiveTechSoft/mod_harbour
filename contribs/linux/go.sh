gcc -shared -olibharbour.so.3.2.0 -L/home/anto/harbour_for_modharbour/lib/linux/gcc -Wl,--whole-archive @libs.txt -Wl,--no-whole-archive -ldl -lpthread -lm -lrt
