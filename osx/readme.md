/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install httpd

mkdir $HOME/temp

cd $HOME/temp

apxs -g -n harbour

cd $HOME

git clone https://github.com/FiveTechSoft/mod_harbour

cp $HOME/mod_harbour/mod_harbour.c $HOME/temp/harbour

***

[![](https://bitbucket.org/fivetech/screenshots/downloads/harbour.jpg)](https://harbour.github.io "The Harbour Project")
<a href="https://httpd.apache.org/" alt="The Apache HTTP Server Project"><img width="150" height="150" src="http://www.apache.org/img/support-apache.jpg"></a>
