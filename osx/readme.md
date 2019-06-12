/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew install httpd

mkdir $HOME/temp

cd $HOME/temp

apxs -g -n harbour

cd $HOME

git clone https://github.com/FiveTechSoft/mod_harbour

cp $HOME/mod_harbour/mod_harbour.c $HOME/temp/harbour

