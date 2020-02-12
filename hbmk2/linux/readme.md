First of all, build Harbour
```
git clone https://github.com/harbour/core harbour
cd harbour
export HB_USER_CFLAGS="-fPIC"
make
```
Install apache2-dev
```
sudo apt-get install apache2-dev
```
then give execution permissions to go.sh and execute it:
```
chmod +x go.sh
./go.sh
```
Once built, do this:
```
cd /var/www/html
sudo ln -sf ~/mod_harbour/hbmk2/linux/libharbour.so.3.2.0 libharbour.so.3.2.0
sudo ln -sf ~/mod_harbour/samples modharbour_samples
```
copy mod_harbour.so to the Apache modules folder:
```
sudo mv mod_harbour.so /usr/lib/apache2/modules
```
and restart apache
```
sudo systemctl restart apache2
```

Then from your browser go to:
```
localhost/modharbour_samples
```
In case you get a wrong behavior, please check:
```
/var/log/apache2/error.log
```
