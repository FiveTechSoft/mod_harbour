Apple provides an installed apache by default, that serves pages at:

```
/Library/WebServer/Documents

if you have used brew to install httpd then the pages are located at:

/usr/local/var/www
```

Download mod_harbour files:
```
git clone https://github.com/fivetechsoft/mod_harbour
```

Create the required symbolic links:
```
cd /usr/local/httpd/modules
sudo ln -sf /Users/$USER/mod_harbour/osx/mod_harbour.so mod_harbour.so
cd /Library/WebServer/Documents
sudo ln -sf /Users/$USER/mod_harbour/osx/libharbour.3.2.0.dylib libharbour.3.2.0.dylib
sudo ln -sf /Users/$USER/mod_harbour/samples modharbour_samples
```

Edit **httpd.conf** at /private/etc/apache2 (or at /usr/local/etc/httpd/httpd.conf) and add these lines:
```
LoadModule harbour_module /usr/local/httpd/modules/mod_harbour.so

<FilesMatch "\.(prg|hrb)$">
    SetHandler harbour
</FilesMatch>
```
and add Indexes here:
```
Options Indexes FollowSymLinks Multiviews
```

Restart apache:
```
sudo apachectl start
```

Now just browse to **localhost/modharbour_samples/** from from browser and click on any PRG file

In case that you get errors please review the log files at:
```
/var/log/apache2
```

<hr>

In case that **you want to rebuild mod_harbour yourself**, then you need to install brew as the default installed apache does not provides all the required files (headers and libraries) to build it:

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install httpd
```
<hr>

0. Install curl and pcre:

```
brew install curl
brew install pcre
```

1. Download Harbour and build it:

```
git clone https://github.com/harbour/core harbour
export HB_WITH_CURL=/usr/local/Cellar/curl/7.70.0/include/
export HB_WITH_OPENSSL=/usr/local/Cellar/openssl@1.1/1.1.1g
export HB_BUILD_CONTRIBS=""
make
```

2. Install Apache so we get the missing required headers and libraries:

```
brew install httpd
```


**1.** sudo apachectl start

**2.** From the browser go to localhost and check that Apache is running

**3.** Go to /Library/WebServer/Documents and create these symlinks:

sudo ln -sf /Users/$USER/mod_harbour/osx/libharbour.3.2.0.dylib libharbour.3.2.0.dylib

sudo ln -sf /Users/$USER/mod_harbour/samples modharbour_samples

**4.** Create this folder:

sudo mkdir -p /usr/local/httpd/modules

**5.** Go to /usr/local/httpd/modules and create this symlink:

sudo ln -sf /Users/$USER/mod_harbour/osx/mod_harbour.so mod_harbour.so

**6.** Edit httpd.conf at /private/etc/apache2 and add these lines:

```
LoadModule harbour_module /usr/local/httpd/modules/mod_harbour.so

<FilesMatch "\.(prg|hrb)$">
    SetHandler harbour
</FilesMatch>
```

**Add Indexes here:**

Options **Indexes** FollowSymLinks Multiviews

**7.** sudo apachectl restart

**8.** Go to /Users/$USER/mod_harbour and change the owner of the samples folder:

sudo chown -R _www:_www samples

**9.** From your browser go to localhost/modharbour_samples

**10.** If you get a "don't have permission to access" error please review the logs at:

cd /var/log/apache2

**Included by default Apache in OSX is uncomplete, so first this to do is to properly install it:**

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install httpd

**execute go.sh to install the mod_harbour for OSX**

chmod +x go.sh

./go.sh

**If you want to build the mod_harbour yourself**

In order to make the generated apxs project, Makefile has to be edited this way:

top_srcdir=/usr/local/lib/httpd

top_builddir=/usr/local/lib/httpd

**Copy mod_harbour.so to the Apache modules folder**

cp mod_harbour.so /usr/local/lib/httpd/modules

cd /usr/local/var/www    # instead of /Library/WebServer/Documents

**Create a symlink at /usr/local/var/www pointing to libharbour.3.2.0.dylib**

sudo ln -sf /Users/$USER/mod_harbour/osx/libharbour.3.2.0.dylib libharbour.3.2.0.dylib

**Create a symlink to point to the mod_harbour samples folder:**

ln -sf /Users/anto/mod_harbour/samples modharbour_samples

**Apache configuration file:**

/etc/apache2/httpd.conf  or

/usr/local/etc/httpd/httpd.conf

Set the right port: 

Listen 80

ServerName localhost

**Copy the mod_harbour settings into httpd.conf**

```
LoadModule harbour_module lib/httpd/modules/mod_harbour.so

<FilesMatch "\.(prg|hrb)$">
    SetHandler harbour
</FilesMatch>
```

sudo apachectl restart

**From the browser go localhost**

**Served files folder: (htdocs)**

cd /Library/WebServer/Documents

**We place a symlink pointing to mod_harbour examples:**

ln -sf /Users/anto/mod_harbour/samples modharbour_samples

**To start Apache:**

sudo apachectl restart

<hr>

[![](https://bitbucket.org/fivetech/screenshots/downloads/harbour.jpg)](https://harbour.github.io "The Harbour Project")
<a href="https://httpd.apache.org/" alt="The Apache HTTP Server Project"><img width="150" height="150" src="http://www.apache.org/img/support-apache.jpg"></a>
