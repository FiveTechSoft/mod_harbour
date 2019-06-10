gcc -shared -olibharbour.so.3.2.0 -L/home/anto/harbour_for_modharbour/lib/linux/gcc @libs.txt -Wl,--retain-symbols-file=harbour.def -ldl -lpthread -lm -lrt
