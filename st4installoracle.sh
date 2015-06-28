cd /data/database
./runInstaller -silent -ignorePrereq -responseFile /etc/db_install.rsp
sudo /u01/app/oracle/oraInventory/orainstRoot.sh
sudo /u01/app/oracle/product/11.2.0/db_1/root.sh
source /etc/profile
netca /silent /responsefile /etc/netca.rsp
lsnrctl status
dbca -silent -responseFile /etc/dbca.rsp

ps -ef | grep ora_ | grep -v grep
