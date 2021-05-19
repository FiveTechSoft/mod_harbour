../../harbour/bin/linux/gcc/hbmk2 modharbour.hbp
mv liblibharbour.so libharbour.so
sudo mv libharbour.so /usr/local/nginx/modules/libharbour.so
cd ../../nginx
nginx -s quit
nginx
curl http://localhost?test.prg
