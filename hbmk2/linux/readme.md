First of all, build Harbour then give execution permissions to go.sh and execute it:
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
and restart apache
```
sudo systemctl restart apache2
```

Then from your browser go to:
```
localhost/modharbour_samples
```
