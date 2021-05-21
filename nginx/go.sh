../../harbour/bin/linux/gcc/hbmk2 modharbour.hbp
mv liblibharbour.so libharbour.so
sudo cp ./libharbour.so /usr/local/nginx/modules/libharbour.so
sudo cp ./libharbour.so ../../nginx/objs/libharbour.so
cd ../../nginx/objs
./nginx -s quit
./nginx
curl http://localhost?test.prg
