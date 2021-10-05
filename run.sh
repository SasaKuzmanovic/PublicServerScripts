while true
do
sudo rm -rf cache
sudo bash $(pwd)/../server/run.sh +exec server.cfg
sleep 15s
done
