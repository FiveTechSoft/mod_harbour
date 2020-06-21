user="www-data"
if [ "$1" == "off" ]; then
   user=$USER
fi   
sudo chown -R $user:$user data
cd apps/honey
sudo chown -R $user:$user data
cd ../..
cd apps/mvc
sudo chown -R $user:$user data
cd ../..
cd apps/mvc_notes
sudo chown -R $user:$user data
cd ../..
cd eshop
sudo chown -R $user:$user data
cd ..
cd genesis
sudo chown -R $user:$user data
cd ..
sudo chown -R $user:$user chat
sudo chown -R $user:$user machine
sudo chown -R $user:$user snippets
