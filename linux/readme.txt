The mod_harbour for Apache on Linux uses a different approach that turns it much much faster and lighter.

1. It has been built using the Windows 10 bash:

https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/

2. Install this from the Windows 10 bash:

sudo apt-get install apache2-dev

3. go to /home/<username> and type this:

apxs -n harbour -g

4. In order to test this do:

make all

sudo make install

sudo make test

5. Now replace your mod_harbour.c with the one provided here

